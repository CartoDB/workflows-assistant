# ColumnNumber

Select columns with associated numeric weights.

## Type Name
`ColumnNumber` (internal: `WorkflowComponentParamType.ColumnNumber`)

## Value Format

JSON string containing an array of column/weight pairs:

```json
{
  "name": "weights",
  "type": "ColumnNumber",
  "value": "[{\"column\":\"population\",\"weight\":0.5},{\"column\":\"income\",\"weight\":0.5}]"
}
```

## Structure

```json
[
  { "column": "column_name", "weight": numeric_value },
  { "column": "another_column", "weight": numeric_value }
]
```

### Schema
```typescript
interface ColumnWeight {
  column: string;  // Column name from parent table
  weight: number;  // Numeric weight value
}
```

## Optional Properties

| Property | Type | Description |
|----------|------|-------------|
| `excludedColumns` | `string[]` | Columns to hide from selection |
| `enableReverse` | `boolean` | Allow negative weights |
| `noDefault` | `boolean` | Don't auto-populate with defaults |
| `parent` | `string` | Parent table parameter name |

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Weight as string | Use number: `0.5` not `"0.5"` |
| Missing column name | Every entry needs `column` field |
| Invalid column reference | Column must exist in parent table |
| Weights don't sum to 1 | Some components require normalized weights |

## Example Usage

### Equal Weights
```json
{
  "name": "weights",
  "type": "ColumnNumber",
  "value": "[{\"column\":\"population\",\"weight\":0.5},{\"column\":\"income\",\"weight\":0.5}]"
}
```

### Multiple Columns with Different Weights
```json
{
  "name": "weights",
  "type": "ColumnNumber",
  "value": "[{\"column\":\"score_a\",\"weight\":0.3},{\"column\":\"score_b\",\"weight\":0.5},{\"column\":\"score_c\",\"weight\":0.2}]"
}
```

### With Negative Weight (Reverse Effect)
```json
{
  "name": "weights",
  "type": "ColumnNumber",
  "value": "[{\"column\":\"positive_factor\",\"weight\":0.7},{\"column\":\"negative_factor\",\"weight\":-0.3}]"
}
```

### Single Column
```json
{
  "name": "weights",
  "type": "ColumnNumber",
  "value": "[{\"column\":\"value\",\"weight\":1.0}]"
}
```

## Typical Use Cases

- Weighted average calculations
- Commercial hotspot analysis
- Composite index creation
- Multi-criteria analysis

## Related Types
- `SelectColumnNumber` - Similar functionality
- `Column` - Simple column selection without weights
- `Range` - For min/max value ranges
