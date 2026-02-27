# SQL-kurs

## Overview
This repository is a lightweight SQL Server practice workspace for T-SQL schema and administrative tasks.
It is focused on simple, clear scripts that can be run and validated in a non-production environment.

## Repository Structure
- `SQLQueryMain.sql`: Main T-SQL script for schema changes and administrative operations (currently targeting `ClaudeDB`).
- `README.md`: Project documentation and usage notes.
- `migrations/` (optional): Ordered schema change scripts, for example `001_add_employees_email.sql`.
- `checks/` (optional): Verification queries and post-change checks.

## Usage
- Run the main script with `sqlcmd`:
  - `sqlcmd -S <server> -d ClaudeDB -i SQLQueryMain.sql`
- Run interactively in SSMS:
  - Open `SQLQueryMain.sql`, select the target database, and execute selected statements.

## Coding Conventions
- Use uppercase SQL keywords (for example `USE`, `ALTER TABLE`, `EXEC`).
- Keep related statements grouped and easy to scan.
- Prefer descriptive object names (for example, `retail_price`).
- Use 4-space indentation for wrapped clauses.
- End statements with semicolons (`;`).

## Validation
- Validate all changes in a non-production database.
- Verify schema updates with `INFORMATION_SCHEMA` queries.
- Confirm renamed columns with `sp_help` or direct `SELECT` checks.

## Contributing
- Use clear, action-based commit messages such as:
  - `feat(schema): add employees.email column`
  - `fix(books): rename price to retail_price`
- In pull requests, include:
  - What changed and why
  - Affected tables/views/procedures
  - Validation steps and result summary
  - Rollback considerations for schema edits

## Security Notes
- Do not commit credentials or secrets.
- Use placeholders in examples (for example, `<server>` and `<database>`).
- Avoid exposing production server names in repository files.
