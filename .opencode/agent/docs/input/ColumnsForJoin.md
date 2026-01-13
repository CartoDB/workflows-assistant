# ColumnsForJoin

Select columns for join operations with rename capability.

## Type Name
`ColumnsForJoin` (internal: `WorkflowComponentParamType.ColumnsForJoin`)

## Value Format

JSON string containing an array of column mappings:

```json
{
  "name": "lefttablecolumns",
  "type": "ColumnsForJoin",
  "value": "[{\"name\":\"id\",\"joinname\":\"left_id\"},{\"name\":\"value\",\"joinname\":\"left_value\"}]"
}
```

## Structure

```json
[
  { "name": "original_column", "joinname": "output_column_name" },
  { "name": "another_col", "joinname": "renamed_col" }
]
```

### Schema
```typescript
interface JoinColumnConfig {
  name: string;      // Original column name in source table
  joinname: string;  // Column name in join output
}
```

## Purpose

When joining tables, columns from both sides may have the same name. `ColumnsForJoin` allows you to:
1. Select which columns to include from each table
2. Rename columns to avoid conflicts
3. Create meaningful output column names

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Not escaping JSON | Value must be a JSON string |
| Missing `joinname` | Both `name` and `joinname` required |
| Same `joinname` on both sides | Use distinct names to avoid conflicts |
| Empty array when required | Include at least one column |

## Example Usage

### Select and Rename Two Columns
```json
{
  "name": "lefttablecolumns",
  "type": "ColumnsForJoin",
  "value": "[{\"name\":\"id\",\"joinname\":\"customer_id\"},{\"name\":\"name\",\"joinname\":\"customer_name\"}]"
}
```

### Keep Same Name
```json
{
  "name": "righttablecolumns",
  "type": "ColumnsForJoin",
  "value": "[{\"name\":\"amount\",\"joinname\":\"amount\"},{\"name\":\"date\",\"joinname\":\"transaction_date\"}]"
}
```

### Empty Selection (Include No Columns)
```json
{
  "name": "secondarytablecolumns",
  "type": "ColumnsForJoin",
  "value": "[]"
}
```

## Complete Join Example

```json
{
  "id": "join-node",
  "type": "generic",
  "data": {
    "name": "native.joinv2",
    "label": "Join Tables",
    "inputs": [
      { "name": "lefttable", "type": "Table" },
      { "name": "righttable", "type": "Table" },
      { "name": "leftcolumn", "type": "Column", "value": "customer_id" },
      { "name": "rightcolumn", "type": "Column", "value": "id" },
      { "name": "jointype", "type": "Selection", "value": "Inner" },
      { 
        "name": "lefttablecolumns", 
        "type": "ColumnsForJoin", 
        "value": "[{\"name\":\"customer_id\",\"joinname\":\"customer_id\"},{\"name\":\"name\",\"joinname\":\"customer_name\"}]"
      },
      { 
        "name": "righttablecolumns", 
        "type": "ColumnsForJoin", 
        "value": "[{\"name\":\"amount\",\"joinname\":\"order_amount\"},{\"name\":\"order_date\",\"joinname\":\"order_date\"}]"
      }
    ],
    "outputs": [
      { "name": "result", "type": "Table" }
    ]
  }
}
```

## Important Note for Spatial Joins

For `native.spatialjoin`, column mappings marked as "optional" are **actually required for SQL generation**. Without them, the spatial join node may be silently skipped.

Always include:
- `maintablecolumns`
- `secondarytablecolumns`

## Typical Use Cases

- `native.joinv2` - Table joins
- `native.spatialjoin` - Spatial joins
- Any operation combining columns from multiple tables

## Related Types
- `Column` - Simple column selection
- `Table` - Table input for join sources
