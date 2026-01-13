# GeoJson

GeoJSON string input for spatial data.

## Type Name
`GeoJson` (internal: `WorkflowComponentParamType.GeoJson`)

## Value Format

The value is a **GeoJSON string** (escaped JSON):

```json
{
  "name": "geojson",
  "type": "GeoJson",
  "value": "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Point\",\"coordinates\":[-3.7,40.4]}}]}"
}
```

## GeoJSON Structure

### FeatureCollection (Most Common)
```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Point",
        "coordinates": [-3.7037, 40.4168]
      }
    }
  ]
}
```

### Geometry Types
- `Point` - Single point: `[longitude, latitude]`
- `MultiPoint` - Multiple points
- `LineString` - Line: `[[lon1, lat1], [lon2, lat2], ...]`
- `MultiLineString` - Multiple lines
- `Polygon` - Polygon: `[[[lon1, lat1], [lon2, lat2], ...]]` (closed ring)
- `MultiPolygon` - Multiple polygons

## Coordinate Order

**Important**: GeoJSON uses `[longitude, latitude]` order (not lat/lon).

```json
"coordinates": [-3.7037, 40.4168]  // Madrid: longitude first, then latitude
```

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Lat/Lon order | Use `[longitude, latitude]` |
| Missing quotes | Value must be a JSON string |
| Invalid GeoJSON | Validate with geojson.io or similar |
| Unclosed polygon | First and last coordinates must match |
| Missing `type` fields | Every Feature and Geometry needs `type` |

## Example Usage

### Point
```json
{
  "name": "geojson",
  "type": "GeoJson",
  "value": "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Point\",\"coordinates\":[-3.7037,40.4168]}}]}"
}
```

### Polygon (Area of Interest)
```json
{
  "name": "geojson",
  "type": "GeoJson",
  "value": "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-3.75,40.4],[-3.65,40.4],[-3.65,40.45],[-3.75,40.45],[-3.75,40.4]]]}}]}"
}
```

### LineString
```json
{
  "name": "geojson",
  "type": "GeoJson",
  "value": "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"LineString\",\"coordinates\":[[-3.7,40.4],[-3.65,40.42],[-3.6,40.45]]}}]}"
}
```

## Validation

The engine validates GeoJSON using the `geojson-validation` library. Invalid GeoJSON will fail validation.

## Creating GeoJSON

Tools for creating GeoJSON:
- https://geojson.io - Interactive map editor
- QGIS - Export features as GeoJSON
- `ST_AsGeoJSON()` - SQL function in spatial databases

## Related Types
- `GeoJsonDraw` - GeoJSON with drawing interface
- `Json` - For generic JSON data
