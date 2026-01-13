# Range

Numeric range with min and max values.

## Type Name
`Range` (internal: `WorkflowComponentParamType.Range`)

## Value Format

JSON string containing an array with exactly two values `[min, max]`:

```json
{
  "name": "returnrange",
  "type": "Range",
  "value": "[\"0.0\",\"1.0\"]"
}
```

**Important**: Values inside the array are strings, not numbers.

## Structure

```json
["min_value", "max_value"]
```

Both values must be valid numbers (as strings).

## Validation Rules

1. Must be valid JSON array
2. Must contain exactly 2 values
3. Both values must parse to valid numbers
4. First value (min) must be ≤ second value (max)

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Using native numbers | Use strings: `["0", "1"]` not `[0, 1]` |
| More than 2 values | Exactly 2 values required |
| Min > Max | First value must be ≤ second value |
| Invalid number strings | Both must be valid numbers |

## Example Usage

### Normalized Range (0 to 1)
```json
{
  "name": "returnrange",
  "type": "Range",
  "value": "[\"0.0\",\"1.0\"]"
}
```

### Percentage Range
```json
{
  "name": "percentrange",
  "type": "Range",
  "value": "[\"0\",\"100\"]"
}
```

### Custom Scale
```json
{
  "name": "scorerange",
  "type": "Range",
  "value": "[\"-10\",\"10\"]"
}
```

### With Decimals
```json
{
  "name": "weightrange",
  "type": "Range",
  "value": "[\"0.0\",\"5.5\"]"
}
```

## Typical Use Cases

- Normalization ranges for spatial composite analysis
- Score scaling ranges
- Value clamping boundaries
- Index calculation bounds

## Related Types
- `Number` - For single numeric values
- `ColumnNumber` - For column + weight pairs
