# Json

JSON object input.

## Type Name
`Json` (internal: `WorkflowComponentParamType.Json`)

## Value Format

The value is a **JSON string** (escaped JSON inside the value):

```json
{
  "name": "options",
  "type": "Json",
  "value": "{\"method\":\"GET\",\"headers\":{\"Content-Type\":\"text/plain\"}}"
}
```

**Important**: The value is a string containing JSON, not a native JSON object.

## Formatting

### Compact (Required in workflow.json)
```json
"value": "{\"key\":\"value\",\"nested\":{\"a\":1}}"
```

### Readable (for documentation)
```json
{
  "key": "value",
  "nested": {
    "a": 1
  }
}
```

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Using native JSON object | Stringify the JSON: `JSON.stringify(obj)` |
| Single quotes | Use escaped double quotes: `\"` |
| Unescaped special characters | Escape quotes and backslashes |
| Invalid JSON syntax | Validate JSON before using |

## Example Usage

### HTTP Request Options
```json
{
  "name": "options",
  "type": "Json",
  "value": "{\"method\":\"POST\",\"headers\":{\"Authorization\":\"Bearer token\"}}"
}
```

Represents:
```json
{
  "method": "POST",
  "headers": {
    "Authorization": "Bearer token"
  }
}
```

### Configuration Object
```json
{
  "name": "config",
  "type": "Json",
  "value": "{\"enabled\":true,\"retries\":3,\"timeout\":30}"
}
```

Represents:
```json
{
  "enabled": true,
  "retries": 3,
  "timeout": 30
}
```

### Array of Objects
```json
{
  "name": "items",
  "type": "Json",
  "value": "[{\"id\":1,\"name\":\"first\"},{\"id\":2,\"name\":\"second\"}]"
}
```

Represents:
```json
[
  {"id": 1, "name": "first"},
  {"id": 2, "name": "second"}
]
```

## Escaping Rules

| Character | Escaped Form |
|-----------|--------------|
| `"` | `\"` |
| `\` | `\\` |
| Newline | `\n` |
| Tab | `\t` |

## Related Types
- `GeoJson` - For GeoJSON spatial data
- `JsonExtractPaths` - For JSON path extraction configuration
