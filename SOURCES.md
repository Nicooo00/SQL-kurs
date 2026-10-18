# Sources and attribution

## Course material

The exercises, lesson progression, SQL examples and sample datasets in this learning journal are based on **Data With Baraa**, by **Baraa Khatib Salkini**:

- [Official SQL course repository](https://github.com/DataWithBaraa/sql-ultimate-course)
- [Course video](https://youtu.be/SSKVgrwhzus)
- [Upstream scripts at the version inspected for this review](https://github.com/DataWithBaraa/sql-ultimate-course/blob/123d634e5be4214c6cde278a6d86cbd5ec92e09a/03_scripts)
- [MyDatabase initialization source](https://github.com/DataWithBaraa/sql-ultimate-course/blob/123d634e5be4214c6cde278a6d86cbd5ec92e09a/01_datasets/00_sql-server/init-sqlserver-mydatabase.sql)
- [SalesDB initialization source](https://github.com/DataWithBaraa/sql-ultimate-course/blob/123d634e5be4214c6cde278a6d86cbd5ec92e09a/01_datasets/00_sql-server/init-sqlserver-salesdb.sql)

The source version inspected on **18 October 2026** is commit `123d634e5be4214c6cde278a6d86cbd5ec92e09a`. This pins the attribution/license check; it does not assert that the original notes were written from that exact revision.

Nicooo00's contribution is the personal Polish learning notes, attempted solutions, experiments, and adaptations. Labels such as “rozwiazanie barra” in the notes acknowledge course examples; they are retained. Lesson-level source comments point here. Course-derived examples are not presented as original course authorship by Nicooo00.

## License scope

The inspected upstream repository uses the [MIT License](https://github.com/DataWithBaraa/sql-ultimate-course/blob/123d634e5be4214c6cde278a6d86cbd5ec92e09a/LICENSE):

> Copyright (c) 2025 Baraa Khatib Salkini

The full copyright and permission notice is preserved in [LICENSES/data-with-baraa-MIT.txt](LICENSES/data-with-baraa-MIT.txt). Retain it with copies or substantial portions of the upstream software.

The sample initialization data was compared with the upstream SQL Server initialization files. Its teaching cases were preserved. The local setup changes execution structure: it refuses existing databases, removes reset/drop operations, and executes guarded initialization batches. Other course-derived examples have corrections and clarifications described in [the review notes](docs/review-notes.md).

No new blanket license is applied to Nicooo00's original notes. The upstream MIT notice covers upstream material and its adaptations; it is not a claim of ownership of the course. This review did not audit every historical commit or establish the origin of every individual comment. It does not grant rights to separately hosted videos, artwork, PDFs, or other linked resources.

## Other resources

Optional AdventureWorks exercises refer to [Microsoft's sample databases and restore instructions](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure). No AdventureWorks backups, PDFs, screenshots, or course videos are redistributed here. Consult the source's own terms before redistributing separately obtained resources.

Technical corrections were checked against Microsoft Learn. Specific references are listed in [docs/review-notes.md](docs/review-notes.md).
