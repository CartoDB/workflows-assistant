# Number

Numeric input value (integer or floating point).

## Type Name
`Number` (internal: `WorkflowComponentParamType.Number`)

## Value Format

```json
{
  "name": "distance",
  "type": "Number",
  "value": "100"
}
```

**Important**: Values are stored as **strings** in the JSON, not native numbers.

### With Expressions
```json
{
  "name": "limit",
  "type": "Number",
  "value": "{{@rowLimit}}"
}
```

## Optional Properties

| Property | Type | Description |
|----------|------|-------------|
| `min` | `number` | Minimum allowed value |
| `max` | `number` | Maximum allowed value |
| `default` | `number` | Default value if not specified |

## Validation Rules

1. Value must parse to a valid, finite number
2. If `min` is specified, value must be >= min
3. If `max` is specified, value must be <= max
4. Empty string is invalid (unless optional)

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Using native number `100` | Use string `"100"` |
| Value below min | Check component definition for constraints |
| Non-numeric string | Ensure value parses to a number |
| NaN or Infinity | Value must be finite |

## Example Usage

### Simple Number
```json
{
  "name": "limit",
  "type": "Number",
  "value": "10"
}
```

### Float Value
```json
{
  "name": "distance",
  "type": "Number",
  "value": "1.5"
}
```

### With Constraints
```json
{
  "name": "kvalue",
  "type": "Number",
  "value": "6",
  "min": 1,
  "max": 100,
  "default": 6
}
```

### Using Variable Expression
```json
{
  "name": "buffer_distance",
  "type": "Number",
  "value": "{{@bufferMeters}}"
}
```

## Related Types
- `Range` - For min/max value pairs
- `ColumnNumber` - For column + weight pairs
- `String` - For text values
