# Selection

Dropdown selection from predefined options.

## Type Name
`Selection` (internal: `WorkflowComponentParamType.Selection`)

## Value Format

```json
{
  "name": "jointype",
  "type": "Selection",
  "value": "Inner"
}
```

The value must be one of the predefined `options`.

## Required Context

Selection inputs have an `options` array in their component definition that lists valid values:

```json
{
  "name": "jointype",
  "type": "Selection",
  "options": ["Inner", "Left", "Right", "Full outer"],
  "default": "Inner"
}
```

## Optional Properties

| Property | Type | Description |
|----------|------|-------------|
| `options` | `string[]` | List of valid values |
| `optionsText` | `string[]` | Display labels for options (optional) |
| `default` | `string` | Default selected option |
| `mode` | `string` | `"Radio"` for radio buttons, `"Toggle"` for toggle switch |

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Value not in options | Use exact value from options list |
| Case mismatch | Options are case-sensitive: `"Inner"` ≠ `"inner"` |
| Using index instead of value | Use the string value, not a numeric index |

## Example Usage

### Join Type Selection
```json
{
  "name": "jointype",
  "type": "Selection",
  "value": "Left"
}
```

Valid options: `"Inner"`, `"Left"`, `"Right"`, `"Full outer"`

### Buffer Units
```json
{
  "name": "units",
  "type": "Selection",
  "value": "Meters"
}
```

Valid options: `"Meters"`, `"Kilometers"`, `"Miles"`, `"Feet"`

### Spatial Predicate
```json
{
  "name": "predicate",
  "type": "Selection",
  "value": "intersects"
}
```

Valid options: `"intersects"`, `"contains"`, `"within"`, `"touches"`, etc.

### Aggregation Method
```json
{
  "name": "method",
  "type": "Selection",
  "value": "SUM"
}
```

## Finding Valid Options

To find valid options for a Selection input:

```bash
carto workflows components get <component-name> --provider bigquery --json
```

Look for the `options` array in the input definition.

## Common Selection Values by Component

| Component | Input | Common Options |
|-----------|-------|----------------|
| `native.buffer` | `units` | `Meters`, `Kilometers`, `Miles`, `Feet` |
| `native.join` | `jointype` | `Inner`, `Left`, `Right`, `Full outer` |
| `native.spatialjoin` | `predicate` | `intersects`, `contains`, `within` |
| `native.orderby` | `direction` | `ASC`, `DESC` |

## Related Types
- `SelectionType` - For selecting data types
- `Boolean` - For simple true/false choices
