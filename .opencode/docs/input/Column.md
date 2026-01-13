# Column

Select one or more columns from a parent table.

## Type Name
`Column` (internal: `WorkflowComponentParamType.Column`)

## Value Format

### Single Column
```json
{
  "name": "geo",
  "type": "Column",
  "value": "geom"
}
```

### Multiple Columns (when mode is Multiple)
```json
{
  "name": "groupby",
  "type": "Column",
  "value": ["district", "category", "year"]
}
```

## Required Properties

| Property | Description |
|----------|-------------|
| `parent` | Name of the Table input parameter this column comes from |

## Optional Properties

| Property | Type | Description |
|----------|------|-------------|
| `dataType` | `string[]` | Restrict to specific column types: `"Boolean"`, `"Number"`, `"String"`, `"Geography"`, `"Date"`, `"Datetime"`, `"Time"`, `"Timestamp"`, `"Json"`, `"Array"` |
| `mode` | `string` | Set to `"Multiple"` to allow selecting multiple columns |
| `excludedColumns` | `string[]` | Column names to hide from selection |
| `noDefault` | `boolean` | Don't auto-select the first matching column |
| `maxSelectionsCount` | `number` | Maximum columns selectable (when mode is Multiple) |

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Missing `parent` property | Always specify which table the column comes from |
| Array value for single mode | Use string for single column, array only with `mode: "Multiple"` |
| Wrong column name | Verify exact column name with `carto connections describe` |
| Case sensitivity | Column names are case-sensitive |

## Example Usage

### Single Column Selection
```json
{
  "name": "geo",
  "type": "Column",
  "value": "geometry",
  "parent": "source"
}
```

### Multiple Columns with Type Filter
```json
{
  "name": "groupby",
  "type": "Column",
  "value": ["district", "category"],
  "parent": "source",
  "mode": "Multiple",
  "dataType": ["String", "Number", "Boolean"]
}
```

### Geography Column Only
```json
{
  "name": "geosource",
  "type": "Column",
  "value": "geom",
  "parent": "source",
  "dataType": ["Geography"]
}
```

## Valid Data Types

- `Boolean` - True/false values
- `Number` - Integer and float types
- `String` - Text values
- `Geography` - Spatial geometry data
- `Date` - Date values
- `Datetime` - Date and time values
- `Time` - Time values
- `Timestamp` - Timestamp values
- `Json` - JSON objects
- `Array` - Array values

## Related Types
- `Table` - The parent table input
- `SelectColumnAggregation` - Column selection with aggregation methods
- `ColumnsForJoin` - Column selection with rename capability
