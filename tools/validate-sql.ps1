<# Offline syntax and repository-boundary checks; does not execute SQL. Requires PowerShell 7 and ScriptDom. #>
param(
    [Parameter(Mandatory = $true)][string]$ScriptDomPath,
    [string]$Root = (Join-Path $PSScriptRoot '..')
)
$ErrorActionPreference = 'Stop'
Add-Type -Path (Resolve-Path -LiteralPath $ScriptDomPath).Path
$parser = [Microsoft.SqlServer.TransactSql.ScriptDom.TSql160Parser]::new($true)
$script:failureCount = 0
$script:dynamicCount = 0

function Read-Sql([string]$Sql, [string]$Label, [bool]$ReadOnly) {
    $reader = [System.IO.StringReader]::new($Sql)
    $parseErrors = $null
    $ast = $parser.Parse($reader, [ref]$parseErrors)
    $reader.Dispose()
    foreach ($problem in $parseErrors) {
        Write-Output "${Label}:$($problem.Line):$($problem.Column): $($problem.Message)"
        $script:failureCount++
    }
    if ($ReadOnly) {
        foreach ($batch in $ast.Batches) {
            foreach ($statement in $batch.Statements) {
                $type = $statement.GetType().Name
                if ($type -notin @('UseStatement', 'SelectStatement') -or
                    ($type -eq 'SelectStatement' -and $null -ne $statement.Into)) {
                    Write-Output "${Label}:$($statement.StartLine): statement outside read-only boundary: $type"
                    $script:failureCount++
                }
            }
        }
    }
    # Setup has literal dynamic batches for CREATE DATABASE and USE/schema/seed statements.
    # Parse their decoded contents too, including nested CREATE SCHEMA strings.
    foreach ($token in $ast.ScriptTokenStream) {
        if ($token.TokenType.ToString() -in @('AsciiStringLiteral', 'UnicodeStringLiteral')) {
            $literal = $token.Text -replace '^N', ''
            $decoded = $literal.Substring(1, $literal.Length - 2).Replace("''", "'")
            if ($decoded -match '^\s*(USE\s|CREATE\s+(DATABASE|SCHEMA)\s)') {
                $script:dynamicCount++
                Read-Sql $decoded "$Label (dynamic SQL at line $($token.Line))" $false
            }
        }
    }
}

$rootPath = (Resolve-Path -LiteralPath $Root).Path
$files = @(Get-ChildItem -LiteralPath $rootPath -Filter '*.sql' -Recurse | Sort-Object FullName)
$lessonFiles = @($files | Where-Object {
    -not [System.IO.Path]::GetRelativePath($rootPath, $_.FullName).Replace('\', '/').StartsWith('setup/')
})
$numbers = @($lessonFiles | ForEach-Object { [int]($_.BaseName.Split('-')[0]) } | Sort-Object)
if (($numbers -join ',') -ne ((1..35) -join ',')) {
    throw 'Expected exactly one lesson for every number from 01 through 35.'
}
foreach ($file in $files) {
    $relative = [System.IO.Path]::GetRelativePath($rootPath, $file.FullName).Replace('\', '/')
    $isReadOnly = $relative.StartsWith('lessons/') -or $relative.StartsWith('dangerous/')
    Read-Sql ([System.IO.File]::ReadAllText($file.FullName)) $relative $isReadOnly
}
Write-Output "SQL files: $($files.Count); literal dynamic batches: $script:dynamicCount; failures: $script:failureCount"
if ($script:failureCount -gt 0) { exit 1 }
