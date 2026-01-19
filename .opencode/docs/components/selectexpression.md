# Component: native.selectexpression

Creates a new column computed using an expression.

## Gotcha: Input Parameter Name

The parameter for the new column name is `column`, not `columnname`.

| Expected | Actual |
|----------|--------|
| `columnname` | `column` |

## Correct Usage

```json
{
  "id": "create-column",
  "type": "generic",
  "data": {
    "name": "native.selectexpression",
    "label": "Create New Column",
    "inputs": [
      { "name": "source", "type": "Table" },
      { "name": "column", "type": "String", "value": "new_column_name" },
      { "name": "expression", "type": "StringSql", "value": "col1 + col2" }
    ],
    "outputs": [
      { "name": "result", "type": "Table" }
    ]
  },
  "position": { "x": 200, "y": 0 }
}
```

## Input Order

Note the input order in the schema:
1. `source` - The input table
2. `column` - Name for the new column (String, not Column type)
3. `expression` - SQL expression to compute the value

## Common Mistake

```json
// WRONG - will cause validation errors
"inputs": [
  { "name": "source", "type": "Table" },
  { "name": "expression", "type": "StringSql", "value": "COALESCE(x, 0)" },
  { "name": "columnname", "type": "String", "value": "filled_value" }
]

// CORRECT
"inputs": [
  { "name": "source", "type": "Table" },
  { "name": "column", "type": "String", "value": "filled_value" },
  { "name": "expression", "type": "StringSql", "value": "COALESCE(x, 0)" }
]
```

## Why This Matters

If you use `columnname` instead of `column`, validation will fail with:
- "No value assigned" for `column` parameter

Always fetch the component schema before use:
```bash
carto workflows components get native.selectexpression --connection <conn> --json
```
