# Table (InputTable)

Reference to an input table, typically connected from another component's output.

## Type Name
`Table` (internal: `WorkflowComponentParamType.InputTable`)

## Value Format

Table inputs are **connected via edges** in the workflow - they don't have a direct `value` in the node definition.

### In Node Definition
```json
{
  "name": "source",
  "type": "Table"
}
```

Note: No `value` property - the table is provided through an edge connection.

### Edge Connection
```json
{
  "id": "edge-1",
  "source": "source-node-id",
  "target": "target-node-id",
  "sourceHandle": "result",
  "targetHandle": "source"
}
```

### For Source Tables (native.gettablebyname)
When reading a table by name, the table reference is a fully-qualified name (FQN):
```json
{
  "name": "tablename",
  "type": "String",
  "value": "project.dataset.tablename"
}
```

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Adding `value` to Table input | Table inputs receive data via edges, not values |
| Missing edge connection | Every Table input must have an incoming edge |
| Wrong `targetHandle` name | Must match the input `name` exactly |

## Example Usage

### Reading a source table
```json
{
  "id": "source-node",
  "type": "generic",
  "data": {
    "name": "native.gettablebyname",
    "label": "Get Data",
    "inputs": [
      { "name": "tablename", "type": "String", "value": "my_project.my_dataset.my_table" }
    ],
    "outputs": [
      { "name": "result", "type": "Table" }
    ]
  }
}
```

### Consuming a table input
```json
{
  "id": "filter-node",
  "type": "generic",
  "data": {
    "name": "native.where",
    "label": "Filter Data",
    "inputs": [
      { "name": "source", "type": "Table" },
      { "name": "expression", "type": "String", "value": "status = 'active'" }
    ],
    "outputs": [
      { "name": "result", "type": "Table" }
    ]
  }
}
```

With connecting edge:
```json
{
  "id": "edge-source-to-filter",
  "source": "source-node",
  "target": "filter-node",
  "sourceHandle": "result",
  "targetHandle": "source"
}
```

## Related Types
- `OutputTable` - For output table references
- `String` - Used for table FQN in `native.gettablebyname`
