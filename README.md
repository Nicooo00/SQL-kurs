# SQL Learning Notes

My personal SQL learning notes and exercises, written while following the **Data With Baraa** SQL course.

This repository documents my learning process: queries, experiments, attempted solutions, and explanations in Polish. The course examples and sample datasets come from Data With Baraa; my contribution is the personal notes and adaptations.

## Environment

- **Microsoft SQL Server 2022 or newer** — some examples use `DATETRUNC`.
- **SQL Server Management Studio (SSMS)** or another client that supports T-SQL and `GO` batch separators.
- The course's `MyDatabase` and `SalesDB` sample databases. Some later exercises also use AdventureWorks sample databases.

These are T-SQL notes, so the scripts may require changes to run on other database engines.

## How to use

1. Clone this repository and open the SQL files in SSMS.
2. Prepare the course sample databases using the [official course materials](https://github.com/DataWithBaraa/sql-ultimate-course). Database definitions also appear in lesson 01.
3. Check the database selected by `USE`, read the task, then select and execute the query you want to explore.
4. Follow the lesson numbers below, referring to the original course when needed.

**Read lesson 01 before executing anything in it.** It contains `DROP DATABASE` and `SINGLE_USER WITH ROLLBACK IMMEDIATE` commands, including examples targeting AdventureWorks databases. Its creation sections can also drop existing sample databases. Other lessons include UPDATE, DELETE, TRUNCATE and schema/index changes. Use disposable learning databases and run selected exercises; do not execute all files as one batch.

The notes are a learning journal and may contain mistakes or incomplete experiments. The scripts are not a tested, sequential installation process.

## Lessons

The original filenames and Polish comments are preserved.

| # | Topic |
| --- | --- |
| 01 | [Database lifecycle and import notes](01_creating-and-deleting-databases.sql) |
| 02 | [SELECT queries, grouping and sorting](02_SQL_select-queries.sql) |
| 03 | [DDL commands](03_SQL_DDL-commansds.sql) |
| 04 | [DML commands](04_SQL_DML-commands.sql) |
| 05 | [WHERE conditions](05_SQL_Where-conditions.sql) |
| 06 | [JOIN basics](06_SQL_Joins-basics.sql) |
| 07 | [Advanced JOIN patterns](07_Advanced-SQL-joins.sql) |
| 08 | [Joining multiple tables](08_Joining-Multiple-tables-in-SQL.sql) |
| 09 | [Set operators](09_SQL_Set-operators.sql) |
| 10 | [String functions](10_SQL_String-functions.sql) |
| 11 | [Number functions](11_SQL_Number-functions.sql) |
| 12 | [Date and time functions](12_SQL_Date-and-time-functions.sql) |
| 13 | [Formatting and casting](13_SQL_Formating-and-casting.sql) |
| 14 | [Date calculations and validation](14_SQL_Date-calculations-and-validation.sql) |
| 15 | [NULL functions](15_SQL_NULL-functions.sql) |
| 16 | [NULL, empty strings and blank spaces](16_SQL-NULL-vs-EmptyString-vs-BlankSpace.sql) |
| 17 | [CASE WHEN](17_SQL-CASE-WHEN-Statement.sql) |
| 18 | [Aggregate functions](18_SQL-Aggregate-functions.sql) |
| 19 | [Window function basics](19_SQL_Window-functions-basics.sql) |
| 20 | [Aggregate window functions](20_SQL_Aggregate-window-functions.sql) |
| 21 | [Ranking window functions](21_SQL_Ranking-window-functions.sql) |
| 22 | [Value window functions](22_SQL_Value-window-functions.sql) |
| 23 | [Subqueries](23_SQL_Subqueries.sql) |
| 24 | [Common table expressions](24_SQL_Common-table-expressions%28CTE%27s%29.sql) |
| 25 | [Views](25_SQL_Views.sql) |
| 26 | [SELECT INTO and materialized results](26_SQL_CTAS.sql) |
| 27 | [Temporary tables](27_SQL_Temp-tables.sql) |
| 28 | [Rowstore and composite indexes](28_SQL_Indexes.sql) |
| 29 | [Columnstore indexes](29_SQL_Columnstore-Index.sql) |
| 30 | [Unique and filtered indexes](30_SQL_Unique-%26-Filtered-Indexes.sql) |
| 31 | [Index monitoring and maintenance](31_SQL_Index-Maintanance.sql) |
| 32 | [Execution plans and hints](32_SQL_Execution-Plans.sql) |
| 33 | [Indexing strategy](33_SQL_Indexing-strategy.sql) |
| 34 | [Table partitioning](34_SQL_Table-Partitioning.sql) |
| 35 | [SQL best practices: measured tradeoffs](35_SQL_Best-practices.sql) |

## Sources and license

Course exercises and sample datasets originate from **Baraa Khatib Salkini / Data With Baraa**:

- [Official SQL course repository](https://github.com/DataWithBaraa/sql-ultimate-course)
- [SQL course video](https://youtu.be/SSKVgrwhzus)
- [Upstream MIT license at the version checked](https://github.com/DataWithBaraa/sql-ultimate-course/blob/123d634e5be4214c6cde278a6d86cbd5ec92e09a/LICENSE)
- [Microsoft AdventureWorks samples](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure)

[LICENSE](LICENSE) preserves the upstream MIT copyright and permission notice for course-derived code and its adaptations. It does not attribute the original course to me or introduce a separate license for my original personal notes. Separately linked videos and other resources retain their own terms.

This is an independent learning journal, not an official course release.
