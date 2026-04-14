---
name: map-visualization
description: Tips and useful information when an user wants to visualize in a map as result
---

# Map Visualization in CARTO Workflows

This skill covers how to create map visualizations from workflow outputs using the `native.createmap` component and best practices for spatial data handling.

---

## The `native.createmap` Component

The `native.createmap` component creates a CARTO Builder map from workflow output. This is the recommended way to visualize workflow results.

### When to Use

- User wants to "see the results on a map"
- User asks to "visualize" or "display" the output
- User wants to create a dashboard or share results visually
- Final step of a workflow that produces spatial data

### Component Inputs

Fetch the full schema with:
```bash
carto workflows components get native.createmap --connection <connection> --json
```

Key inputs:
| Input | Type | Description |
|-------|------|-------------|
| `source` | Table | The input table to visualize |
| `name` | String | Name for the created map |
| `geo` | Column | The geometry/spatial column to use for rendering |

### Basic Usage

```json
{
  "id": "create-map-1",
  "type": "generic",
  "data": {
    "name": "native.createmap",
    "label": "Create Map",
    "inputs": [
      {
        "name": "source",
        "type": "Table",
        "value": ""
      },
      {
        "name": "name",
        "type": "String",
        "value": "My Analysis Results"
      },
      {
        "name": "geo",
        "type": "Column",
        "value": "geom"
      }
    ],
    "outputs": []
  },
  "position": { "x": 800, "y": 100 }
}
```

---

## Spatial Index Columns: H3 and Quadbin

<critical_rule name="preserve-spatial-indices">
**Do NOT convert H3 or Quadbin indices to geometry for map visualization.**

CARTO Builder natively understands H3 and Quadbin spatial indices. When your workflow output contains these columns, leave them as-is:

- **H3**: Keep the H3 cell index column (e.g., `h3`, `h3_index`)
- **Quadbin**: Keep the Quadbin index column (e.g., `quadbin`, `qb_index`)

Builder will automatically:
1. Recognize the spatial index column
2. Render the cells with proper boundaries
3. Apply appropriate styling and aggregations
</critical_rule>

### When to Extract Geometry

Only use `native.h3boundary` or `native.quadbinboundary` when:
1. You need to perform **spatial operations** on the cell geometries (e.g., spatial join, buffer)
2. You're exporting to a non-CARTO system that doesn't understand spatial indices
3. The user explicitly requests polygon geometries

### Example: Correct vs Incorrect

**Correct** - Let Builder handle H3 visualization:
```
source -> h3frompoint -> groupby (count per cell) -> createmap
                                                      geo: "h3"
```

**Unnecessary** - Adding h3boundary just for visualization:
```
source -> h3frompoint -> groupby -> h3boundary -> createmap
                                                   geo: "h3_geo"
```
The second approach works but adds unnecessary computation. Builder can render H3 cells directly.

---

## Geometry Column Selection

When using `native.createmap`, the `geo` input must reference a valid spatial column:

| Data Type | Column to Use |
|-----------|---------------|
| H3 | The H3 column directly (e.g., `h3`, `index`) - Builder renders cells natively |
| Quadbin | The Quadbin column directly (e.g., `quadbin`) - Builder renders cells natively |
| Point / Line / Polygon / MultiPolygon | The geometry column name (e.g., `geom`, `geometry`, `geom_buffer`) |

---

## Best Practices

1. **Check output schema before createmap**: Validate the workflow and inspect available columns to ensure the geometry column exists

2. **Name maps descriptively**: The `name` input becomes the map title in Builder - use meaningful names

3. **One map per workflow output**: Each `createmap` component creates a separate map. For multiple layers, create multiple maps or use Builder to combine them

4. **Spatial indices are preferred**: For aggregated data (e.g., counts per H3 cell), spatial indices render faster than polygon geometries

---

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| Map shows no data | Wrong `geo` column specified | Check output schema for correct geometry column name |
| Map renders slowly | Using extracted polygons instead of spatial indices | Use H3/Quadbin columns directly instead of boundary components |
| "Column not found" error | Geometry column was renamed or dropped | Trace the workflow to ensure geometry is preserved through all transformations |
