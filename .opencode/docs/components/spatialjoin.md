# Component: native.spatialjoin

Joins two tables based on spatial relationship.

## Gotcha

The `maintablecolumns` and `secondarytablecolumns` inputs are marked "optional" but are **required for SQL generation**. Without them, the node is silently skipped.

Always include both with `ColumnsForJoin` format (see `docs/input/ColumnsForJoin.md`).
