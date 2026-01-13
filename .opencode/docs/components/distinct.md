# Component: native.distinct

Removes duplicate values based on specified columns.

## Gotcha: Only Outputs Distinct Columns

**`native.distinct` only outputs the columns specified in the `columns` input.** All other columns are dropped.

```
Input:  id, name, category, geom
Distinct on: category
Output: category   <-- Only this column!
```

This behavior causes downstream nodes to fail with "column not found" errors.

## Workaround: Use GroupBy Instead

If you need to deduplicate while preserving all columns, use `native.groupby` with `any` aggregation:

```json
{
  "name": "native.groupby",
  "inputs": [
    { "name": "source", "type": "Table" },
    { "name": "groupby", "type": "Column", "value": ["category"] },
    { "name": "columns", "type": "SelectColumnAggregation", "value": "id,any,name,any,geom,any" }
  ]
}
```

This groups by the deduplication column and keeps one value (`any`) for all other columns.

## When to Use Each

| Goal | Component | Result |
|------|-----------|--------|
| Get unique values of one column | `native.distinct` | Single column output |
| Deduplicate rows, keep all columns | `native.groupby` with `any` | All columns preserved |
