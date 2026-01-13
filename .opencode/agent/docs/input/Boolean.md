# Boolean

True/false toggle value.

## Type Name
`Boolean` (internal: `WorkflowComponentParamType.Boolean`)

## Value Format

```json
{
  "name": "include_nulls",
  "type": "Boolean",
  "value": true
}
```

### Accepted Values
- `true` (boolean)
- `false` (boolean)
- `"true"` (string - also accepted)
- `"false"` (string - also accepted)

## Optional Properties

| Property | Type | Description |
|----------|------|-------------|
| `default` | `boolean` | Default value if not specified |

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Using `1` or `0` | Use `true` or `false` |
| Using `"yes"` or `"no"` | Use `true` or `false` |
| Missing value | Provide explicit `true` or `false` |

## Example Usage

### Simple Boolean
```json
{
  "name": "droporiginal",
  "type": "Boolean",
  "value": true
}
```

### With Default
```json
{
  "name": "include_geometry",
  "type": "Boolean",
  "value": false,
  "default": true
}
```

### Enable/Disable Feature
```json
{
  "name": "use_cache",
  "type": "Boolean",
  "value": true
}
```

## Typical Use Cases

- Enable/disable optional features
- Toggle behavior modes
- Include/exclude columns or data
- Dry-run flags

## Related Types
- `Selection` - For choosing between multiple options (not just two)
