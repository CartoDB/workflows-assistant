# String

Text input value.

## Type Name
`String` (internal: `WorkflowComponentParamType.String`)

## Value Format

```json
{
  "name": "newcolumn",
  "type": "String",
  "value": "my_new_column"
}
```

### With Expressions
```json
{
  "name": "prefix",
  "type": "String",
  "value": "{{@tablePrefix}}"
}
```

## Optional Properties

| Property | Type | Description |
|----------|------|-------------|
| `validation` | `string` | Regex pattern for validation |
| `trimSpaces` | `boolean` | Trim leading/trailing whitespace |
| `placeholder` | `string` | UI placeholder text |
| `allowExpressions` | `boolean` | Allow `{{...}}` expression syntax |
| `mode` | `string` | Set to `"Multiline"` for multi-line text |
| `default` | `string` | Default value |

## Validation Rules

1. If `validation` regex is provided, value must match the pattern
2. If `trimSpaces` is true, whitespace is trimmed before validation
3. Empty string may be valid depending on `optional` property

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Using expression without `allowExpressions: true` | Check if component allows expressions |
| Invalid characters | Check `validation` pattern if present |
| SQL injection in non-SQL fields | Use `StringSql` for SQL expressions |

## Example Usage

### Simple String
```json
{
  "name": "newcolumn",
  "type": "String",
  "value": "result_column"
}
```

### Table FQN
```json
{
  "name": "tablename",
  "type": "String",
  "value": "project.dataset.tablename"
}
```

### With Expression
```json
{
  "name": "output_name",
  "type": "String",
  "value": "{{@prefix}}_results"
}
```

### With Validation
```json
{
  "name": "column_name",
  "type": "String",
  "value": "valid_name_123",
  "validation": "^[a-zA-Z_][a-zA-Z0-9_]*$"
}
```

## Expression Syntax

When `allowExpressions: true`, values can include:

```
{{@variableName}}           - Variable reference
{{@count + 10}}             - Expression with arithmetic
{{'prefix_' || @varName}}   - String concatenation
```

## Related Types
- `StringSql` - For raw SQL expressions
- `Column` - For column name selection
- `Email` - For email address values
