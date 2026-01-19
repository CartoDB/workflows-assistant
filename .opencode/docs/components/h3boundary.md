# Component: native.h3boundary

Converts H3 cell indices to polygon geometries.

## IMPORTANT: When to Use This Component

<critical>
**Do NOT use `native.h3boundary` unless the geometry is required for a spatial operation that cannot be natively performed with H3 indices.**

The H3 index alone is sufficient for:
- **Visualization**: CARTO Builder natively renders H3 cells from the index column
- **Storage**: H3 indices are compact and efficient; adding geometries increases storage significantly
- **Aggregations**: Group by, counts, and statistics work directly on H3 indices
- **H3-native operations**: K-ring, parent/child resolution, grid distance, polyfill

**Only add geometry when you need to**:
- Perform spatial joins with non-H3 geometries (e.g., join H3 cells to arbitrary polygons)
- Use spatial predicates like buffer, intersection, or distance with non-H3 data
- Export to systems that don't understand H3 indices

If the workflow ends with visualization or storage, keep the H3 index as-is.
</critical>

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
