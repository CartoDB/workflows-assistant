# Component: native.join (DEPRECATED)

## IMPORTANT: Use `native.joinv2` Instead

<critical>
**`native.join` is deprecated.** Always use `native.joinv2` for join operations.

Even though `native.join` exists in the component catalog (v1.2), it should NOT be used for new workflows.
</critical>

## Comparison

| Aspect | `native.join` (deprecated) | `native.joinv2` (use this) |
|--------|---------------------------|---------------------------|
| Version | 1.2 | 1 |
| Table inputs | `maintable`, `secondarytable` | `lefttable`, `righttable` |
| Key columns | `maincolumn`, `secondarycolumn` | `lefttablekeycolumn`, `righttablekeycolumn` |
| Column selection | Not available | `lefttablecolumns`, `righttablecolumns` (optional) |
| Where clause | Not available | `whereclause` (optional) |

## `native.joinv2` Inputs

| Input | Type | Required | Description |
|-------|------|----------|-------------|
| `lefttable` | Table | Yes | Left table |
| `righttable` | Table | Yes | Right table |
| `lefttablekeycolumn` | Column | Yes | Key column in left table |
| `righttablekeycolumn` | Column | Yes | Key column in right table |
| `lefttablecolumns` | ColumnsForJoin | No | Columns to include from left table |
| `righttablecolumns` | ColumnsForJoin | No | Columns to include from right table |
| `jointype` | Selection | Yes | Inner, Left, Right, Full outer |
| `whereclause` | StringSql | No | Additional filter condition |

## Output

- Output handle: `result`
