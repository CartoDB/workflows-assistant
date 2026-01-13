# GeoJsonDraw

GeoJSON input with map drawing interface.

## Type Name
`GeoJsonDraw` (internal: `WorkflowComponentParamType.GeoJsonDraw`)

## Value Format

Identical to `GeoJson` - a valid GeoJSON string:

```json
{
  "name": "geojson",
  "type": "GeoJsonDraw",
  "value": "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-3.75,40.4],[-3.65,40.4],[-3.65,40.45],[-3.75,40.45],[-3.75,40.4]]]}}]}"
}
```

## Difference from GeoJson

The only difference is in the **UI presentation**:
- `GeoJson` - Text input for pasting GeoJSON
- `GeoJsonDraw` - Interactive map with drawing tools

Both accept the same value format and validation rules.

## Typical Use Cases

- Drawing custom areas of interest
- Creating geographic boundaries
- Defining study areas interactively
- Drawing routes or paths

## Example Usage

### Draw Custom Geographies Component
```json
{
  "id": "draw-area",
  "type": "generic",
  "data": {
    "name": "native.drawcustomgeographies",
    "label": "Define Area",
    "inputs": [
      {
        "name": "geojson",
        "type": "GeoJsonDraw",
        "value": "{\"type\":\"FeatureCollection\",\"features\":[]}"
      }
    ],
    "outputs": [
      { "name": "result", "type": "Table" }
    ]
  }
}
```

## Creating Values Programmatically

When creating workflows programmatically (not through UI), you can provide pre-defined GeoJSON:

```json
{
  "name": "geojson",
  "type": "GeoJsonDraw",
  "value": "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"name\":\"Study Area\"},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-73.99,40.73],[-73.98,40.73],[-73.98,40.74],[-73.99,40.74],[-73.99,40.73]]]}}]}"
}
```

## Related Types
- `GeoJson` - Same format, text-based input
