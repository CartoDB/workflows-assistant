# SelectColumnType

Select columns with new names and data types for schema editing.

## Type Name
`SelectColumnType` (internal: `WorkflowComponentParamType.SelectColumnType`)

## Value Format

**Newline-separated** list of column transformations, each with format:
```
original_name,new_name,new_type
```

```json
{
  "name": "columns",
  "type": "SelectColumnType",
  "value": "old_col1,new_col1,STRING\nold_col2,new_col2,INT64"
}
```

**Important**: Lines are separated by `\n` (newline), not commas between entries.

## Structure

Each line contains three comma-separated values:
1. **Original column name** - Existing column in the source table
2. **New column name** - Desired name after transformation
3. **New data type** - Target data type (provider-specific)

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Using commas between lines | Use newline `\n` between entries |
| JSON array format | Use newline-separated text, not JSON |
| Invalid data type | Use provider-specific types |
| Missing any of the 3 parts | Each line needs all three values |

## Example Usage

### Single Column Rename and Type Change
```json
{
  "name": "columns",
  "type": "SelectColumnType",
  "value": "user_id,customer_id,STRING"
}
```

### Multiple Columns
```json
{
  "name": "columns",
  "type": "SelectColumnType",
  "value": "id,user_id,STRING\nage,user_age,INT64\nscore,rating,FLOAT64"
}
```

### Keep Name, Change Type Only
```json
{
  "name": "columns",
  "type": "SelectColumnType",
  "value": "amount,amount,FLOAT64\ncount,count,INT64"
}
```

## Provider-Specific Types

### BigQuery
- `STRING`, `INT64`, `FLOAT64`, `BOOL`, `DATE`, `DATETIME`, `TIMESTAMP`, `GEOGRAPHY`, `JSON`

### Snowflake
- `VARCHAR`, `NUMBER`, `FLOAT`, `BOOLEAN`, `DATE`, `TIMESTAMP`, `GEOGRAPHY`, `VARIANT`

### PostgreSQL
- `TEXT`, `INTEGER`, `DOUBLE PRECISION`, `BOOLEAN`, `DATE`, `TIMESTAMP`, `GEOGRAPHY`

## Typical Use Cases

- `native.refactorcolumns` - Rename and retype columns
- Schema normalization
- Data type standardization

## Related Types
- `Column` - Simple column selection
- `SelectionType` - Single type selection
