# Condition

Complex condition builder for CASE WHEN logic.

## Type Name
`Condition` (internal: `WorkflowComponentParamType.Condition`)

## Value Format

JSON string containing an array of column conditions:

```json
{
  "name": "conditions",
  "type": "Condition",
  "value": "[{\"column\":\"status\",\"conditions\":[{\"condition\":\"=\",\"value\":\"active\",\"return\":\"1\"},{\"condition\":\"=\",\"value\":\"inactive\",\"return\":\"0\"}]}]"
}
```

## Structure

### Parsed Structure
```json
[
  {
    "column": "status",
    "conditions": [
      { "condition": "=", "value": "active", "return": "1" },
      { "condition": "=", "value": "inactive", "return": "0" }
    ]
  }
]
```

### Schema
```typescript
interface ColumnConditions {
  column: string;           // Column to evaluate
  conditions: Condition[];  // Array of conditions
}

interface Condition {
  condition: ConditionType; // Operator
  value: string;            // Value to compare (ignored for IS NULL, IS TRUE, IS FALSE)
  return: string;           // Value to return when condition matches
}
```

## Condition Types

| Type | SQL Equivalent | Requires Value |
|------|----------------|----------------|
| `=` | `= 'value'` | Yes |
| `!=` | `!= 'value'` | Yes |
| `>` | `> value` | Yes |
| `>=` | `>= value` | Yes |
| `<` | `< value` | Yes |
| `<=` | `<= value` | Yes |
| `contains` | `LIKE '%value%'` | Yes |
| `IS NULL` | `IS NULL` | No |
| `IS TRUE` | `IS TRUE` | No |
| `IS FALSE` | `IS FALSE` | No |

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Not escaping JSON | Value must be a JSON string |
| Wrong condition type | Use exact string from table above |
| Missing `return` field | Every condition needs a return value |
| Empty conditions array | At least one condition required |

## Example Usage

### Simple Status Mapping
```json
{
  "name": "conditions",
  "type": "Condition",
  "value": "[{\"column\":\"status\",\"conditions\":[{\"condition\":\"=\",\"value\":\"A\",\"return\":\"Active\"},{\"condition\":\"=\",\"value\":\"I\",\"return\":\"Inactive\"}]}]"
}
```

Generates SQL like:
```sql
CASE 
  WHEN status = 'A' THEN 'Active'
  WHEN status = 'I' THEN 'Inactive'
END
```

### Numeric Ranges
```json
{
  "name": "conditions",
  "type": "Condition",
  "value": "[{\"column\":\"score\",\"conditions\":[{\"condition\":\">=\",\"value\":\"90\",\"return\":\"A\"},{\"condition\":\">=\",\"value\":\"80\",\"return\":\"B\"},{\"condition\":\">=\",\"value\":\"70\",\"return\":\"C\"},{\"condition\":\"<\",\"value\":\"70\",\"return\":\"F\"}]}]"
}
```

### NULL Check
```json
{
  "name": "conditions",
  "type": "Condition",
  "value": "[{\"column\":\"email\",\"conditions\":[{\"condition\":\"IS NULL\",\"value\":\"\",\"return\":\"No Email\"},{\"condition\":\"!=\",\"value\":\"\",\"return\":\"Has Email\"}]}]"
}
```

### Multiple Columns
```json
{
  "name": "conditions",
  "type": "Condition",
  "value": "[{\"column\":\"status\",\"conditions\":[{\"condition\":\"=\",\"value\":\"active\",\"return\":\"1\"}]},{\"column\":\"type\",\"conditions\":[{\"condition\":\"=\",\"value\":\"premium\",\"return\":\"P\"}]}]"
}
```

## Typical Use Cases

- `native.casewhen` - CASE WHEN logic for data transformation
- Categorizing numeric values into buckets
- Mapping codes to descriptions
- Handling NULL values

## Related Types
- `StringSql` - For custom SQL expressions
