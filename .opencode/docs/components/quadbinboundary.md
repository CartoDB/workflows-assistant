# Component: native.quadbinboundary

Converts Quadbin cell indices to polygon geometries.

## IMPORTANT: When to Use This Component

<critical>
**Do NOT use `native.quadbinboundary` unless the geometry is required for a spatial operation that cannot be natively performed with Quadbin indices.**

The Quadbin index alone is sufficient for:
- **Visualization**: CARTO Builder natively renders Quadbin cells from the index column
- **Storage**: Quadbin indices are compact and efficient; adding geometries increases storage significantly
- **Aggregations**: Group by, counts, and statistics work directly on Quadbin indices
- **Quadbin-native operations**: K-ring, parent/child resolution, polyfill

**Only add geometry when you need to**:
- Perform spatial joins with non-Quadbin geometries (e.g., join Quadbin cells to arbitrary polygons)
- Use spatial predicates like buffer, intersection, or distance with non-Quadbin data
- Export to systems that don't understand Quadbin indices

If the workflow ends with visualization or storage, keep the Quadbin index as-is.
</critical>

## Output Columns

All input columns are preserved, plus a new geometry column.

## Gotcha: Geometry Column Naming

The output geometry column is named **`{quadbin_column}_geo`**, not `geometry` or `geom`.

| Input Quadbin Column | Output Geometry Column |
|----------------------|------------------------|
| `quadbin` | `quadbin_geo` |
| `qb_index` | `qb_index_geo` |

Reference `{column}_geo` in downstream nodes that need the geometry.
