# SQL Learning Notes

A personal SQL learning journal built while following the **Data With Baraa** SQL course.

This repository contains **35 SQL lesson files** with queries, exercises, experiments, and explanations in Polish. It follows my progress from basic SELECT statements to window functions, indexing, execution plans, and partitioning.

The exercises and sample datasets come from Data With Baraa. My contribution is the personal notes, attempted solutions, and adaptations collected while learning.

## What's inside

The lesson numbers follow the order in which I studied the topics:

- **01–05:** databases, querying, DDL, DML, and filtering
- **06–09:** joins and set operators
- **10–17:** text, numeric, date, NULL, and conditional expressions
- **18–22:** aggregation and window functions
- **23–27:** subqueries, CTEs, views, and intermediate tables
- **28–35:** indexes, execution plans, partitioning, and performance

The original filenames and Polish comments are kept as part of the learning journal.

## Requirements

- **Microsoft SQL Server 2022 or newer** — examples using `DATETRUNC` require SQL Server 2022+.
- **SQL Server Management Studio (SSMS)** or another client that supports T-SQL and `GO` batch separators.
- The course's `MyDatabase` and `SalesDB` sample databases.

Some performance exercises also use an AdventureWorks data warehouse sample. Microsoft's [AdventureWorks installation guide](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure) provides the downloads and restore instructions. Check that the database name in `USE` matches your restored sample.

These notes use **T-SQL**, Microsoft SQL Server's SQL dialect.

## Getting started

1. Clone the repository:

   ```sh
   git clone https://github.com/Nicooo00/sql-learning-notes.git
   cd sql-learning-notes
   ```

2. Open SSMS and connect to a local learning instance.
3. Prepare the sample databases using the [official course materials](https://github.com/DataWithBaraa/sql-ultimate-course/tree/main/01_datasets/00_sql-server) or the definitions in [lesson 01](01_creating-and-deleting-databases.sql).
4. Open a lesson, read the task and comments, check the selected database, then execute the statements you want to explore.

**Lesson 01 drops and recreates `MyDatabase` and `SalesDB` if they already exist.** Run it only against disposable learning databases. Other lessons include data and schema changes, so review the selected statements before executing them.

The files contain independent examples rather than a single installation sequence. Some examples demonstrate errors or limitations intentionally; others preserve personal attempts alongside course solutions. Run individual tasks instead of executing every file together.

## Lesson index

| # | Lesson |
| --- | --- |
| 01 | [Creating and deleting databases](01_creating-and-deleting-databases.sql) |
| 02 | [SELECT queries](02_SQL_select-queries.sql) |
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
| 24 | [Common table expressions (CTEs)](24_SQL_Common-Table-Expressions.sql) |
| 25 | [Views](25_SQL_Views.sql) |
| 26 | [CTAS and SELECT INTO](26_SQL_CTAS.sql) |
| 27 | [Temporary tables](27_SQL_Temp-tables.sql) |
| 28 | [Indexes](28_SQL_Indexes.sql) |
| 29 | [Columnstore indexes](29_SQL_Columnstore-Index.sql) |
| 30 | [Unique and filtered indexes](30_SQL_Unique-%26-Filtered-Indexes.sql) |
| 31 | [Index maintenance](31_SQL_Index-Maintanance.sql) |
| 32 | [Execution plans](32_SQL_Execution-Plans.sql) |
| 33 | [Indexing strategy](33_SQL_Indexing-strategy.sql) |
| 34 | [Table partitioning](34_SQL_Table-Partitioning.sql) |
| 35 | [SQL best practices](35_SQL_Best-practices.sql) |

## Working with the notes

The comments mix Polish explanations with the course's English task descriptions and SQL terminology. They are working study notes, including observations and experiments from the learning process.

For performance exercises, compare the query results as well as execution plans, logical reads, CPU time, and elapsed time. The small sample datasets are useful for understanding behavior; they do not establish performance gains for larger workloads.

## Sources and attribution

The original course, exercises, and sample datasets are by **Baraa Khatib Salkini / Data With Baraa**:

- [Official SQL course repository](https://github.com/DataWithBaraa/sql-ultimate-course)
- [SQL course video](https://youtu.be/SSKVgrwhzus)
- [Upstream MIT license](https://github.com/DataWithBaraa/sql-ultimate-course/blob/123d634e5be4214c6cde278a6d86cbd5ec92e09a/LICENSE)

This repository is an independent learning journal maintained by [Nicooo00](https://github.com/Nicooo00), not an official course release. Course-derived examples are credited to their original author.

## License

[LICENSE](LICENSE) preserves the course repository's MIT copyright and permission notice for course-derived code and its adaptations:

> Copyright (c) 2025 Baraa Khatib Salkini

No separate license is introduced for my original personal notes. Linked videos and other external resources remain subject to their own terms.
