# Component: native.h3boundary

Converts H3 cell indices to polygon geometries.

## Output Columns

All input columns are preserved, plus a new geometry column.

## Gotcha: Geometry Column Naming

The output geometry column is named **`{h3_column}_geo`**, not `geometry` or `geom`.

| Input H3 Column | Output Geometry Column |
|-----------------|------------------------|
| `h3` | `h3_geo` |
| `index` | `index_geo` |
| `cell_id` | `cell_id_geo` |

## Example

```json
// If input has column "index" from Getis-Ord
{
  "name": "h3",
  "type": "Column", 
  "value": "index"
}
// Output will have: index, gi, p_value, index_geo
//                                        ^^^^^^^^^ new geometry column
```

Reference `{column}_geo` in downstream nodes that need the geometry.
