# SQL Learning Notes

My SQL learning journal: **35 lessons**, practical exercises, and personal notes written while studying the [Data With Baraa SQL course](https://github.com/DataWithBaraa/sql-ultimate-course).

The SQL examples follow the course; my contribution is the learning process, Polish explanations, attempts, and experiments. This repository preserves that progression, including clearly labelled alternative approaches. The English guide makes the material easier to navigate; the lesson comments remain in Polish.

**Dialect:** Microsoft SQL Server / T-SQL. **Recommended learning environment:** a disposable SQL Server 2022 or newer Developer instance and SQL Server Management Studio (SSMS). `DATETRUNC` requires SQL Server 2022+. These scripts are not directly portable to PostgreSQL, MySQL, or SQLite.

## Start here

1. Clone the repository and select the working branch:

   ```sh
   git clone --branch docs/organize-sql-learning-notes https://github.com/Nicooo00/SQL-kurs.git
   cd SQL-kurs
   ```

2. Connect SSMS to your **local learning instance**. Open and execute the entire [sample setup](setup/00-create-sample-databases.sql) outside a transaction. It creates `MyDatabase` and `SalesDB`, their tables, and the course's small sample datasets. It **stops if either database already exists** and contains no reset or database deletion. Run the whole file so its guard remains effective; do not select and execute only a later section. Setup requires permission to create databases and objects.

3. Open [lesson 02](lessons/01-basics/02-select-queries.sql). Read the task, select its query, and execute it. Each file sets its starting database where needed. Lesson 10 deliberately switches between the two sample databases.

4. Follow the lesson numbers in the index below. Treat lab files as separate exercises, not a migration sequence. Complete read-only exploration against the original sample data before changing it in labs.

If you use `sqlcmd` with Windows authentication, the equivalent first steps are:

```powershell
sqlcmd -S localhost -E -b -f 65001 -i "setup/00-create-sample-databases.sql"
sqlcmd -S localhost -E -b -f 65001 -i "lessons/01-basics/02-select-queries.sql"
```

Replace `localhost` with your learning instance name. `-b` stops on SQL errors; `-f 65001` reads UTF-8 comments. Use your configured authentication if Windows authentication is unavailable. `GO` is a batch separator understood by SSMS and sqlcmd; it is not a T-SQL statement.

Setup is not an automatic repair tool. If creation fails midway, inspect the reported error and partially created learning databases before retrying. To repeat a destructive lab, restore your own clean learning backup or recreate the disposable instance, then run setup again. Never point a reset exercise at a database containing work you need.

## Repository layout and safety

| Location | Purpose |
| --- | --- |
| `setup/` | Creates new sample databases; refuses to overwrite existing ones |
| `lessons/` | Read-only queries, grouped by topic |
| `labs/01-basics/` | DDL and DML exercises, including DELETE and TRUNCATE |
| `labs/02-objects/` | Views, permanent SELECT INTO tables, and temporary tables |
| `labs/03-performance/` | Index changes, maintenance, execution plans, partitioning |
| `dangerous/` | Database-deletion demonstrations, disabled with line comments |
| `docs/review-notes.md` | Per-lesson review, corrections and verification limits |
| `LICENSES/` | Preserved upstream license notice |
| `tools/` | Optional offline syntax and read-only boundary validation |

**Do not run every SQL file recursively.** Lab scripts can alter data and schema, remove objects, consume resources, or fail on rerun because a demonstration object already exists. Read their warnings and run one task at a time on disposable databases. The dangerous lifecycle examples include `SINGLE_USER WITH ROLLBACK IMMEDIATE` and `DROP DATABASE`; they are disabled and are not needed for setup.

## Complete lesson index

Numbers preserve the original learning order; filenames use lowercase kebab-case.

| # | Lesson | Database / dataset | Mode |
| --- | --- | --- | --- |
| 01 | [Database lifecycle and import notes](dangerous/01-database-lifecycle.sql) | — | Disabled danger examples |
| 02 | [SELECT queries, grouping and sorting](lessons/01-basics/02-select-queries.sql) | MyDatabase | Read only |
| 03 | [DDL commands](labs/01-basics/03-ddl-commands.sql) | MyDatabase | Lab: writes / DDL |
| 04 | [DML commands](labs/01-basics/04-dml-commands.sql) | MyDatabase | Lab: writes / DDL |
| 05 | [WHERE conditions](lessons/01-basics/05-where-conditions.sql) | MyDatabase | Read only |
| 06 | [JOIN basics](lessons/02-joins-sets/06-joins-basics.sql) | MyDatabase | Read only |
| 07 | [Advanced JOIN patterns](lessons/02-joins-sets/07-advanced-joins.sql) | MyDatabase | Read only |
| 08 | [Joining multiple tables](lessons/02-joins-sets/08-joining-multiple-tables.sql) | SalesDB | Read only |
| 09 | [Set operators](lessons/02-joins-sets/09-set-operators.sql) | SalesDB | Read only |
| 10 | [String functions](lessons/03-functions/10-string-functions.sql) | Both samples | Read only |
| 11 | [Number functions](lessons/03-functions/11-number-functions.sql) | No tables | Read only |
| 12 | [Date and time functions](lessons/03-functions/12-date-time-functions.sql) | SalesDB | Read only |
| 13 | [Formatting and casting](lessons/03-functions/13-formatting-casting.sql) | SalesDB | Read only |
| 14 | [Date calculations and validation](lessons/03-functions/14-date-calculations-validation.sql) | SalesDB | Read only |
| 15 | [NULL functions](lessons/03-functions/15-null-functions.sql) | SalesDB | Read only |
| 16 | [NULL, empty strings and blank spaces](lessons/03-functions/16-null-empty-blank.sql) | No tables | Read only |
| 17 | [CASE WHEN](lessons/03-functions/17-case-when.sql) | SalesDB | Read only |
| 18 | [Aggregate functions](lessons/04-aggregation-windows/18-aggregate-functions.sql) | SalesDB | Read only |
| 19 | [Window function basics](lessons/04-aggregation-windows/19-window-functions-basics.sql) | SalesDB | Read only |
| 20 | [Aggregate window functions](lessons/04-aggregation-windows/20-aggregate-window-functions.sql) | SalesDB | Read only |
| 21 | [Ranking window functions](lessons/04-aggregation-windows/21-ranking-window-functions.sql) | SalesDB | Read only |
| 22 | [Value window functions](lessons/04-aggregation-windows/22-value-window-functions.sql) | SalesDB | Read only |
| 23 | [Subqueries](lessons/05-advanced-queries/23-subqueries.sql) | SalesDB | Read only |
| 24 | [Common table expressions](lessons/05-advanced-queries/24-common-table-expressions.sql) | SalesDB | Read only |
| 25 | [Views](labs/02-objects/25-views.sql) | SalesDB | Lab: writes / DDL |
| 26 | [SELECT INTO and materialized results](labs/02-objects/26-select-into.sql) | SalesDB | Lab: writes / DDL |
| 27 | [Temporary tables](labs/02-objects/27-temp-tables.sql) | SalesDB | Lab: writes / DDL |
| 28 | [Rowstore and composite indexes](labs/03-performance/28-indexes.sql) | SalesDB | Lab: writes / DDL |
| 29 | [Columnstore indexes](labs/03-performance/29-columnstore-indexes.sql) | SalesDB; optional DW | Lab: writes / DDL |
| 30 | [Unique and filtered indexes](labs/03-performance/30-unique-filtered-indexes.sql) | SalesDB | Lab: writes / DDL |
| 31 | [Index monitoring and maintenance](labs/03-performance/31-index-maintenance.sql) | SalesDB; optional DW | Lab: writes / DDL |
| 32 | [Execution plans and hints](labs/03-performance/32-execution-plans.sql) | AdventureWorksDW2022; SalesDB | Lab: writes / DDL |
| 33 | [Indexing strategy](lessons/06-performance/33-indexing-strategy.sql) | SalesDB (DMVs) | Read only |
| 34 | [Table partitioning](labs/03-performance/34-table-partitioning.sql) | SalesDB | Lab: writes / DDL |
| 35 | [SQL best practices: measured tradeoffs](labs/03-performance/35-best-practices.sql) | SalesDB | Lab: writes / DDL |

## Lab prerequisites and expected behavior

- **03–04:** use a fresh `MyDatabase`. Lesson 03 creates, alters and drops `dbo.persons`; lesson 04 creates it again, changes sample customers, and truncates persons. Run 03 before 04 if using the same instance. Repeating 04 without cleanup can cause object or key collisions.
- **25–27:** use `SalesDB`. Views are created before their first use with `CREATE OR ALTER VIEW` in separate batches. SELECT INTO creates a new table; it does not copy the full source schema, indexes, constraints, or subsequent source changes. Lesson 26 drops its prior demonstration snapshot. Keep lesson 27 in one connection because `#Orders` is session-local.
- **28 → 29 and 31:** run 28 first to create `Sales.Ctest` and its rowstore indexes. Lesson 29 demonstrates clustered and nonclustered columnstore as separate alternatives. Its AdventureWorks section, and the AdventureWorks query in 31, are commented out until that optional dataset is ready. The deliberate duplicate-product INSERT in 30 is also commented out; executing it demonstrates a unique-index violation.
- **32:** restore a disposable copy of Microsoft's **AdventureWorksDW2022** from the [official installation instructions](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure). Use the DW database, not the similarly named OLTP database. This lab creates heap/columnstore copies and an index in that copy; later hint examples switch to `SalesDB`. AdventureWorks backups are not included here.
- **31 and 33:** DMV queries require appropriate monitoring permissions; on SQL Server 2022+, several server performance DMVs require `VIEW SERVER PERFORMANCE STATE`. Database DMVs have their own permission requirements. Empty DMV results can reflect a fresh cache or lack of activity; they are not proof that an index is unnecessary. See the [Microsoft DMV reference](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-index-usage-stats-transact-sql).
- **34:** the default exercise puts all logical partitions on `PRIMARY`. The original multiple-filegroup example is retained in a disabled optional block, with machine-specific paths that must be reviewed before use. Logical partitioning does not require separate physical files.
- **35:** use a fresh `SalesDB`. This file includes DDL as well as comparison queries. Its columnstore experiment uses a separate copy to avoid replacing the clustered primary key on `Sales.Orders`.

The sample data intentionally contains missing values, a leading space in `' John'`, an unmatched order in `MyDatabase`, repeated archive order IDs, and an order with zero quantity. These are teaching cases, not data-cleaning omissions. Replacing them would hide JOIN, NULL, duplicate-handling, and division-by-zero behavior.

## Reading the performance notes

Choose the required result first, then compare equivalent queries using actual plans, logical reads, CPU, and elapsed time. An index seek, CTE, view, JOIN type, or syntax rewrite is not inherently faster. INNER/OUTER JOIN, DISTINCT, UNION/UNION ALL and wildcard changes may change the result itself. The tiny datasets illustrate syntax and behavior; they do not establish production performance improvements. [Review notes](docs/review-notes.md) link the documentation used for corrections.

## Verification

All **35 original lessons** were reviewed, and all **36 final SQL files** (including the extracted setup) passed Microsoft ScriptDom's SQL Server 2022 syntax parser. The five literal dynamic batches in setup were parsed separately. Read-only lesson boundaries and disabled lifecycle examples were checked from the parsed statements.

Live SQL execution could not be completed: the available local SQL Server connection failed. Object binding, permissions, runtime output, optional AdventureWorks sections, and performance claims therefore remain unverified on a running server. This is an educational review, not a claim of full integration testing.

To repeat the offline checks, install PowerShell 7 and obtain `Microsoft.SqlServer.TransactSql.ScriptDom.dll` from Microsoft's [ScriptDom package](https://www.nuget.org/packages/Microsoft.SqlServer.TransactSql.ScriptDom), then supply its actual local path:

```powershell
./tools/validate-sql.ps1 -ScriptDomPath "C:/path/to/Microsoft.SqlServer.TransactSql.ScriptDom.dll"
```

The validator does not connect to a database or execute SQL.

## Sources and authorship

Course exercises and sample datasets originate from **Baraa Khatib Salkini / Data With Baraa**. Nicooo00's contribution is the personal learning notes and adaptations; this repository is not the original course or an official course release.

See [SOURCES.md](SOURCES.md) for pinned source links and scope, and [the preserved upstream MIT license](LICENSES/data-with-baraa-MIT.txt). No blanket relicensing of personal notes or externally linked materials is introduced.
