# JsonExtractPaths

Define JSON extraction paths for creating new columns from JSON data.

## Type Name
`JsonExtractPaths` (internal: `WorkflowComponentParamType.JsonExtractPaths`)

## Value Format

JSON string containing an array of extraction configurations:

```json
{
  "name": "newcolumns",
  "type": "JsonExtractPaths",
  "value": "[{\"jsoncolumn\":\"data\",\"path\":\"$.name\",\"newcol\":\"extracted_name\"}]"
}
```

## Structure

```json
[
  {
    "jsoncolumn": "source_column",  // Column containing JSON
    "path": "$.key.nested",          // JSON path expression
    "newcol": "output_column"        // Name for extracted column
  }
]
```

### Schema
```typescript
interface JsonExtractPath {
  jsoncolumn: string;  // Column containing JSON data
  path: string;        // JSON path expression (e.g., "$.key")
  newcol: string;      // Name for the new extracted column
}
```

## JSON Path Syntax

| Path | Matches |
|------|---------|
| `$.key` | Top-level key |
| `$.parent.child` | Nested key |
| `$.array[0]` | First array element |
| `$.array[*]` | All array elements |
| `$..key` | Recursive descent |

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Missing `$` prefix | Path must start with `$`: `$.name` |
| Wrong source column | `jsoncolumn` must contain JSON data |
| Invalid path expression | Verify path exists in JSON structure |
| Duplicate `newcol` names | Each output column needs unique name |

## Example Usage

### Single Extraction
```json
{
  "name": "newcolumns",
  "type": "JsonExtractPaths",
  "value": "[{\"jsoncolumn\":\"metadata\",\"path\":\"$.author\",\"newcol\":\"author_name\"}]"
}
```

### Multiple Extractions
```json
{
  "name": "newcolumns",
  "type": "JsonExtractPaths",
  "value": "[{\"jsoncolumn\":\"data\",\"path\":\"$.name\",\"newcol\":\"name\"},{\"jsoncolumn\":\"data\",\"path\":\"$.age\",\"newcol\":\"age\"},{\"jsoncolumn\":\"data\",\"path\":\"$.email\",\"newcol\":\"email\"}]"
}
```

### Nested Path
```json
{
  "name": "newcolumns",
  "type": "JsonExtractPaths",
  "value": "[{\"jsoncolumn\":\"response\",\"path\":\"$.result.items[0].id\",\"newcol\":\"first_item_id\"}]"
}
```

### Multiple Source Columns
```json
{
  "name": "newcolumns",
  "type": "JsonExtractPaths",
  "value": "[{\"jsoncolumn\":\"user_data\",\"path\":\"$.name\",\"newcol\":\"user_name\"},{\"jsoncolumn\":\"order_data\",\"path\":\"$.total\",\"newcol\":\"order_total\"}]"
}
```

## Complete Node Example

```json
{
  "id": "parse-json",
  "type": "generic",
  "data": {
    "name": "native.parsejson",
    "label": "Extract JSON Fields",
    "inputs": [
      { "name": "source", "type": "Table" },
      { 
        "name": "newcolumns", 
        "type": "JsonExtractPaths", 
        "value": "[{\"jsoncolumn\":\"properties\",\"path\":\"$.category\",\"newcol\":\"category\"},{\"jsoncolumn\":\"properties\",\"path\":\"$.subcategory\",\"newcol\":\"subcategory\"}]"
      }
    ],
    "outputs": [
      { "name": "result", "type": "Table" }
    ]
  }
}
```

## Example JSON and Paths

Given JSON in column `data`:
```json
{
  "user": {
    "name": "John",
    "contacts": [
      {"type": "email", "value": "john@example.com"},
      {"type": "phone", "value": "555-1234"}
    ]
  },
  "status": "active"
}
```

Extraction paths:
| Path | Extracts |
|------|----------|
| `$.status` | `"active"` |
| `$.user.name` | `"John"` |
| `$.user.contacts[0].value` | `"john@example.com"` |
| `$.user.contacts[*].type` | Array of types |

## Typical Use Cases

- `native.parsejson` - Extract fields from JSON columns
- Processing API responses
- Flattening nested data structures
- Extracting specific attributes from complex objects

## Related Types
- `Json` - JSON object input
- `Column` - Column selection
- `String` - For simple string values
