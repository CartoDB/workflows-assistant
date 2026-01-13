# SelectColumnNumber

Select columns with associated numeric values (similar to ColumnNumber).

## Type Name
`SelectColumnNumber` (internal: `WorkflowComponentParamType.SelectColumnNumber`)

## Value Format

Identical to `ColumnNumber` - JSON string containing an array of column/weight pairs:

```json
{
  "name": "columnweights",
  "type": "SelectColumnNumber",
  "value": "[{\"column\":\"metric_a\",\"weight\":1.5},{\"column\":\"metric_b\",\"weight\":2.0}]"
}
```

## Structure

```json
[
  { "column": "column_name", "weight": numeric_value }
]
```

## Difference from ColumnNumber

Functionally equivalent. The distinction is primarily for UI presentation purposes in specific component contexts.

## Example Usage

### Basic Usage
```json
{
  "name": "columnweights",
  "type": "SelectColumnNumber",
  "value": "[{\"column\":\"value1\",\"weight\":1.0},{\"column\":\"value2\",\"weight\":2.0}]"
}
```

## Related Types
- `ColumnNumber` - Equivalent type
- `Column` - Simple column selection
