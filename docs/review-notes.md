# SQL review notes

Reviewed **18 October 2026**, starting from `Nicooo00/SQL-kurs` commit `b92f2c95de59e2442dbded42ae9619571b3d611d` on `docs/organize-sql-learning-notes`.

All 35 original files were read. Original lesson numbers, Polish notes and personal experiments were retained; names and folders were standardized. The original first file was split into a disabled lifecycle lesson and a new setup script, giving **35 lessons + 1 setup = 36 SQL files**.

## Per-lesson review

Entries describe static review and corrections, not successful execution on a live database. The lesson links also provide a complete old-number to new-path mapping; original filenames remain in Git history.

| Lesson | Review outcome |
| --- | --- |
| [01](../dangerous/01-database-lifecycle.sql) | Database deletion commands isolated and disabled; original sample definitions/data moved to guarded setup; import notes retained. GO explained as a client batch separator. |
| [02](../lessons/01-basics/02-select-queries.sql) | Country aggregation now groups by country only; GROUP BY/DISTINCT/TOP explanations corrected; decimal average retained. |
| [03](../labs/01-basics/03-ddl-commands.sql) | Column/constraint separation made explicit; composite PK uniqueness correctly applies to the pair, not each column independently. |
| [04](../labs/01-basics/04-dml-commands.sql) | UPDATE spelling and requested score fixed; TRUNCATE tradeoffs corrected. This lab changes customers and empties persons. |
| [05](../lessons/01-basics/05-where-conditions.sql) | String constants now match seed casing; collation explanation corrected. NULL still follows three-valued logic. |
| [06](../lessons/02-joins-sets/06-joins-basics.sql) | INNER JOIN description corrected to matching pairs under ON. Other join demonstrations retained. |
| [07](../lessons/02-joins-sets/07-advanced-joins.sql) | Anti-join and cross-join examples reviewed against unmatched sample rows; no query correction needed. |
| [08](../lessons/02-joins-sets/08-joining-multiple-tables.sql) | Multiple-table LEFT JOIN chain reviewed against SalesDB schema; personal explanatory comments retained. |
| [09](../lessons/02-joins-sets/09-set-operators.sql) | Type-resolution note corrected; history report explicitly retains archive versions with UNION ALL, without a false uniqueness guarantee. |
| [10](../lessons/03-functions/10-string-functions.sql) | Database switches fixed; whitespace detection uses DATALENGTH rather than EXCEPT/LEN pitfalls; LEN's trailing-space behavior explained. |
| [11](../lessons/03-functions/11-number-functions.sql) | Rounding explanation clarified for negative half-way values; scalar examples retained. |
| [12](../lessons/03-functions/12-date-time-functions.sql) | timestamp/rowversion distinguished from datetime2; DATETRUNC return type and date-filter performance advice corrected. |
| [13](../lessons/03-functions/13-formatting-casting.sql) | FORMAT default culture, 12-hour display, supported CONVERT styles, and ambiguous date literals corrected. |
| [14](../lessons/03-functions/14-date-calculations-validation.sql) | Completed age replaces year-boundary count; monthly grouping preserves year; decimal shipping averages and ISDATE caveats added. |
| [15](../lessons/03-functions/15-null-functions.sql) | Removed blanket ISNULL/COALESCE speed claims and empty-string join sentinel; decimal division avoids truncation. |
| [16](../lessons/03-functions/16-null-empty-blank.sql) | Corrected NULL/empty/space types, storage and speed claims; SQL Server string padding and ISNULL truncation explained. |
| [17](../lessons/03-functions/17-case-when.sql) | Fixed FROM.Sales.Orders, ascending result order, CASE type rules and category wording; personal country-code attempt retained as exploration. |
| [18](../lessons/04-aggregation-windows/18-aggregate-functions.sql) | Added the actual global maximum-score query; per-customer exploration retained with corrected count label; averages use decimals. |
| [19](../lessons/04-aggregation-windows/19-window-functions-basics.sql) | Corrected default RANGE frame, invalid shorthand, GROUP BY/window scope and order-status partition task. |
| [20](../lessons/04-aggregation-windows/20-aggregate-window-functions.sql) | Added denominator protection and decimal averages; clarified that product percentages repeat at order grain. |
| [21](../lessons/04-aggregation-windows/21-ranking-window-functions.sql) | Deterministic ROW_NUMBER tie-breakers added where a fixed top/bottom count is requested; transient IDs and PERCENT_RANK formula clarified. |
| [22](../lessons/04-aggregation-windows/22-value-window-functions.sql) | MoM now sorts by a date including year, handles zero/absent previous values and labels gaps honestly; retention averages keep fractions. |
| [23](../lessons/05-advanced-queries/23-subqueries.sql) | Corrected row/column subquery classification and claims about physical execution count/performance; NOT EXISTS/NOT IN NULL caveats added. |
| [24](../lessons/05-advanced-queries/24-common-table-expressions.sql) | CTEs terminated explicitly; materialization and arbitrary five-CTE rule corrected; chained CTE wording clarified; sequence stops at 20; segment boundary fixed. |
| [25](../labs/02-objects/25-views.sql) | Views created before use in valid batches with CREATE OR ALTER; stray drops removed; updateability, security, default schema and performance notes corrected. |
| [26](../labs/02-objects/26-select-into.sql) | Removed access/drop before first creation; year preserved in monthly snapshot; materialization cost/freshness tradeoff explained. |
| [27](../labs/02-objects/27-temp-tables.sql) | Clarified tempdb storage and local-table lifetime; #Orders can be rebuilt within a session. Persistent OrdersTest demonstration remains a lab. |
| [28](../labs/03-performance/28-indexes.sql) | Corrected clustered/nonclustered speed hierarchy, PK defaults, heap/row-locator explanation and composite-index prefix advice. |
| [29](../labs/03-performance/29-columnstore-indexes.sql) | Separated incompatible CCI/NCCI alternatives, made absent-index drops safe, normalized optional AdventureWorksDW2022 name and disabled optional dataset block. |
| [30](../labs/03-performance/30-unique-filtered-indexes.sql) | Corrected unique-index syntax and speed claims; deliberate duplicate INSERT is disabled and labelled as expected failure. |
| [31](../labs/03-performance/31-index-maintenance.sql) | Explicit EXEC and database-scoped DMV join; actual last-read calculation; optional AW block; removed hardcoded statistic name and default database-wide update; qualified overlap/fragmentation heuristics. |
| [32](../labs/03-performance/32-execution-plans.sql) | Explicit DW starting context; corrected seek/scan, estimate and hint guarantees; copied-table experiments require a disposable DW restore. |
| [33](../lessons/06-performance/33-indexing-strategy.sql) | Corrected OLAP access description; added per-execution average and cache/units caveats alongside cumulative elapsed time. |
| [34](../labs/03-performance/34-table-partitioning.sql) | Portable PRIMARY-based partition scheme; physical paths/filegroups retained only as optional notes; contradictory deletion disabled; catalog joins/date examples and fixed read-count claims corrected. |
| [35](../labs/03-performance/35-best-practices.sql) | Removed universal speed rankings and weekly mandates; result-changing rewrites labelled; meaningful same-domain OR/UNION comparison; CCI uses a copy; year-aware summary and exact purchase datatype. |

## Verification performed

- Parsed all 36 final SQL files with Microsoft's `TSql160Parser` (SQL Server 2022 grammar): **0 parse errors**. The original parser found two errors in lesson 25 caused by statements following CREATE VIEW without a new batch.
- Parsed the **five literal dynamic batches** in setup, including its nested CREATE SCHEMA: **0 parse errors**.
- Separately parsed the **three optional SQL blocks** in lessons 29, 31 and 34: **0 parse errors**.
- Checked the parsed read-only files: only USE and SELECT statements, no SELECT INTO. Lifecycle examples contain no executable deletion statements.
- Checked that every lesson number 01–35 occurs exactly once and all **80 local Markdown links** resolve.
- Compared all **seven CREATE TABLE definitions and seven INSERT statements** with the original initialization sections using tokens that preserve string literals; all match. Inspected the corresponding upstream files. The intentional missing values, spaces, unmatched order, repeated archive IDs and zero quantity remain.
- Checked the Git diff for whitespace problems and retained the complete upstream MIT notice.

The repeatable parser/boundary checks are in [tools/validate-sql.ps1](../tools/validate-sql.ps1). They do not execute SQL or resolve object/column names.

## Limits and remaining runtime verification

A Windows-authenticated connection to the local SQL Server instance failed (connection/access timeout). Consequently no lesson was run against a live server, and no benchmark result is claimed. The three optional SQL blocks were selected for separate syntax checks; they remain disabled reference examples, with unverified permissions, paths and runtime behavior.

On a disposable SQL Server 2022+ instance, run setup, then the read-only lessons before the labs. Verify schema binding, query output, permissions and plans there. Run 28 before 29/31; restore AdventureWorksDW2022 before 32. Most lab scripts are demonstrations with state changes, not idempotent migrations. Restore clean learning data before repeating experiments.

Useful **expected** checks for a future live run (not observed test results):

| Check on fresh setup | Expected |
| --- | --- |
| MyDatabase customers / orders | 5 / 4 rows |
| SalesDB Customers / Employees / Products | 5 / 5 / 5 rows |
| SalesDB Orders / OrdersArchive | 10 / 10 rows |
| SUM(Sales) across Sales.Orders | 380 |
| Monthly sales for Jan / Feb / Mar 2025 | 105 / 195 / 80 |
| MoM for Jan / Feb / Mar | NULL / 85.71% / -58.97% |
| Average customer Score, ignoring NULL / treating NULL as zero | 625 / 500 |
| Latest archive record per OrderID | 7 rows |
| MyDatabase order without a matching customer | order_id 1004 |

The tiny sample tables are unsuitable for validating real performance improvements. Different datasets, indexes, statistics, cache state and parameter values can produce different plans.

## References used for technical corrections

- [Index architecture and design](https://learn.microsoft.com/en-us/sql/relational-databases/sql-server-index-design-guide): workload-driven index choice, heaps, row locators and index tradeoffs.
- [Index maintenance](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/reorganize-and-rebuild-indexes): page density, fragmentation, resource costs and statistics behavior.
- [OVER clause](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql): default RANGE frame and valid frame syntax.
- [CTEs](https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql): scope, statement termination and non-materialized results.
- [COALESCE](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/coalesce-transact-sql): differences from ISNULL.
- [CAST and CONVERT](https://learn.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql), [FORMAT](https://learn.microsoft.com/en-us/sql/t-sql/functions/format-transact-sql), [ISDATE](https://learn.microsoft.com/en-us/sql/t-sql/functions/isdate-transact-sql): conversion styles, culture and validation scope.
- [AVG](https://learn.microsoft.com/en-us/sql/t-sql/functions/avg-transact-sql), [LEN](https://learn.microsoft.com/en-us/sql/t-sql/functions/len-transact-sql): integer result types and trailing spaces.
- [Partitioned tables and indexes](https://learn.microsoft.com/en-us/sql/relational-databases/partitions/partitioned-tables-and-indexes): logical partitions, PRIMARY placement and conditional partition elimination.

Source ownership and license scope are documented separately in [SOURCES.md](../SOURCES.md).
