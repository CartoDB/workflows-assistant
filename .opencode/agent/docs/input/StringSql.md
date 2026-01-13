# StringSql

SQL expression input - allows raw SQL syntax.

## Type Name
`StringSql` (internal: `WorkflowComponentParamType.StringSql`)

## Value Format

```json
{
  "name": "expression",
  "type": "StringSql",
  "value": "population > 10000 AND status = 'active'"
}
```

## Purpose

Use `StringSql` when the input is a SQL expression that will be embedded directly into the generated query. This differs from `String` which is for general text values.

## Common Use Cases

- WHERE clause conditions
- Custom SQL expressions
- Calculated column expressions
- HAVING clause conditions

## Syntax Rules

- Use SQL syntax appropriate for the target database (BigQuery, Snowflake, etc.)
- Column names can be referenced directly
- String literals must use single quotes: `'value'`
- Comparison operators: `=`, `!=`, `<>`, `<`, `>`, `<=`, `>=`
- Logical operators: `AND`, `OR`, `NOT`
- NULL checks: `IS NULL`, `IS NOT NULL`

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Using double quotes for strings | Use single quotes: `'value'` |
| Wrong column name | Verify column exists in source table |
| Provider-specific syntax | Use syntax compatible with your provider |
| Missing quotes around strings | `status = active` → `status = 'active'` |

## Example Usage

### Filter Expression
```json
{
  "name": "expression",
  "type": "StringSql",
  "value": "category = 'restaurant' AND rating >= 4.0"
}
```

### Complex Condition
```json
{
  "name": "expression",
  "type": "StringSql",
  "value": "population > 50000 OR (is_capital = TRUE AND area_km2 > 100)"
}
```

### NULL Check
```json
{
  "name": "expression",
  "type": "StringSql",
  "value": "geometry IS NOT NULL AND name IS NOT NULL"
}
```

### Aggregation Condition (HAVING)
```json
{
  "name": "customexpression",
  "type": "StringSql",
  "value": "AVG(population) > 3000"
}
```

### String Pattern Matching
```json
{
  "name": "expression",
  "type": "StringSql",
  "value": "name LIKE 'San%' OR name LIKE '%City%'"
}
```

## Provider Differences

### BigQuery
- Use backticks for reserved words: `` `from` ``
- SAFE functions: `SAFE_DIVIDE(a, b)`

### Snowflake
- Use double quotes for case-sensitive identifiers: `"Column"`

### PostgreSQL
- Use double quotes for case-sensitive identifiers: `"Column"`

## Related Types
- `String` - For general text values (not SQL)
- `Condition` - For structured condition building
