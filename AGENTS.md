# Repository Guidelines

## Project Structure & Module Organization
This repository is currently a lightweight SQL practice/project workspace.

- `SQLQueryMain.sql`: main T-SQL script for schema changes and administrative operations (currently targeting `ClaudeDB`).
- `README.md`: minimal project descriptor.

Keep new SQL files focused and single-purpose. If the project grows, organize scripts by intent:
- `migrations/` for ordered schema changes (for example, `001_add_employees_email.sql`)
- `checks/` for verification queries and post-change checks

## Build, Test, and Development Commands
There is no build system in this repository. Work is done by executing SQL scripts against a SQL Server instance.

- Run the main script:
  - `sqlcmd -S <server> -d ClaudeDB -i SQLQueryMain.sql`
- Run interactively in SSMS:
  - Open `SQLQueryMain.sql`, select target DB, execute selected statements.
- Inspect recent history:
  - `git log --oneline -n 10`

Use a non-production database for all local validation.

## Coding Style & Naming Conventions
- Use T-SQL style consistently: uppercase SQL keywords (`USE`, `ALTER TABLE`, `EXEC`).
- Use one statement per logical block and keep related statements grouped.
- Prefer descriptive object names (for example, `retail_price` over ambiguous names).
- Use 4-space indentation for wrapped clauses and avoid mixed tab/space alignment.
- End statements with `;` for clarity and future compatibility.

## Testing Guidelines
No automated tests are configured yet. Validate changes manually after each script update.

- Verify schema changes with `INFORMATION_SCHEMA` queries.
- Confirm renamed columns with `sp_help` or direct `SELECT` checks.
- Include a short “how verified” note in PR descriptions (query used + result summary).

## Commit & Pull Request Guidelines
Current history uses short, informal commit messages. Going forward, use clear, action-based messages:
- `feat(schema): add employees.email column`
- `fix(books): rename price to retail_price`

PRs should include:
- What changed and why
- Affected tables/views/procedures
- Validation steps executed
- Rollback considerations for schema edits

## Security & Configuration Tips
- Never commit credentials, connection strings with secrets, or production server names.
- Use placeholders in examples (`<server>`, `<database>`).
