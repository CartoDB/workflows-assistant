# Example: Filter and Count Workflow

A complete workflow that reads a table, filters rows, and counts results.

## Complete Workflow JSON

```json
{
  "connectionId": "<uuid from carto connections list>",
  "title": "Filter and Count POIs",
  "description": "Filter points of interest by category and count them",
  "config": {
    "schemaVersion": "1.0.0",
    "connectionProvider": "bigquery",
    "nodes": [
      {
        "id": "source-pois",
        "type": "generic",
        "data": {
          "name": "native.gettablebyname",
          "label": "Get POIs",
          "inputs": [
            { "name": "source", "type": "String", "value": "project.dataset.points_of_interest" }
          ],
          "outputs": [
            { "name": "out", "type": "Table" }
          ]
        },
        "position": { "x": 100, "y": 100 }
      },
      {
        "id": "filter-restaurants",
        "type": "generic",
        "data": {
          "name": "native.where",
          "label": "Filter Restaurants",
          "inputs": [
            { "name": "source", "type": "Table" },
            { "name": "expression", "type": "StringSql", "value": "category = 'restaurant'" }
          ],
          "outputs": [
            { "name": "match", "type": "Table" },
            { "name": "unmatch", "type": "Table" }
          ]
        },
        "position": { "x": 300, "y": 100 }
      },
      {
        "id": "count-results",
        "type": "generic",
        "data": {
          "name": "native.count",
          "label": "Count Restaurants",
          "inputs": [
            { "name": "source", "type": "Table" }
          ],
          "outputs": [
            { "name": "result", "type": "Table" }
          ]
        },
        "position": { "x": 500, "y": 100 }
      }
    ],
    "edges": [
      {
        "id": "edge-source-to-filter",
        "source": "source-pois",
        "target": "filter-restaurants",
        "sourceHandle": "out",
        "targetHandle": "source"
      },
      {
        "id": "edge-filter-to-count",
        "source": "filter-restaurants",
        "target": "count-results",
        "sourceHandle": "match",
        "targetHandle": "source"
      }
    ],
    "variables": []
  }
}
```

## Key Patterns Demonstrated

- **Descriptive node IDs**: `source-pois`, `filter-restaurants`
- **Descriptive edge IDs**: `edge-source-to-filter`
- **Left-to-right positions**: x: 100 -> 300 -> 500
- **Handle matching**: `sourceHandle` matches the output name, `targetHandle` matches the input name
- **gettablebyname gotcha**: Input is `source`, output is `out`
- **where outputs**: `match` and `unmatch` (not `result`)
- **Match component schemas**: Always verify input/output names with `carto workflows components get`
