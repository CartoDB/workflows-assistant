# Component: native.gettablebyname

Loads a table as a source in the workflow using its fully-qualified name.

## Gotcha: Non-obvious Naming

**This component does NOT follow common naming patterns.**

| Expected | Actual |
|----------|--------|
| Input: `tablename` | Input: `source` |
| Output: `result` | Output: `out` |

## Correct Usage

```json
{
  "id": "load-table",
  "type": "generic",
  "data": {
    "name": "native.gettablebyname",
    "label": "Load My Table",
    "inputs": [
      { "name": "source", "type": "String", "value": "project.dataset.table" }
    ],
    "outputs": [
      { "name": "out", "type": "Table" }
    ]
  },
  "position": { "x": 0, "y": 0 }
}
```

## Edge Connection

When connecting this component to downstream nodes, use `out` as the sourceHandle:

```json
{
  "id": "edge-1",
  "source": "load-table",
  "target": "next-node",
  "sourceHandle": "out",
  "targetHandle": "source"
}
```

## Common Mistake

```json
// WRONG - will cause validation errors
"inputs": [
  { "name": "tablename", "type": "String", "value": "..." }
],
"outputs": [
  { "name": "result", "type": "Table" }
]

// CORRECT
"inputs": [
  { "name": "source", "type": "String", "value": "..." }
],
"outputs": [
  { "name": "out", "type": "Table" }
]
```

## Why This Matters

If you use `tablename` instead of `source`, validation will fail with:
- "No value assigned" for `source` parameter
- "Edge references non-existent output 'result'"

Always fetch the component schema before use:
```bash
carto workflows components get native.gettablebyname --connection <conn> --json
```
