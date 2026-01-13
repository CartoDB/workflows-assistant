# Email

Email address input (single or multiple).

## Type Name
`Email` (internal: `WorkflowComponentParamType.Email`)

## Value Format

### Single Email
```json
{
  "name": "email",
  "type": "Email",
  "value": "user@example.com"
}
```

### Multiple Emails (JSON Array)
```json
{
  "name": "email",
  "type": "Email",
  "value": "[\"user1@example.com\",\"user2@example.com\"]"
}
```

## Accepted Formats

1. **Single email string**: `"user@example.com"`
2. **JSON array of emails**: `"[\"email1@example.com\",\"email2@example.com\"]"`

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `allowExpressions` | `boolean` | If true, can use `{{@variable}}` syntax |

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Invalid email format | Use valid email: `user@domain.com` |
| Comma-separated (not JSON) | Use JSON array for multiple emails |
| Missing quotes in array | Escape quotes: `"[\"email@x.com\"]"` |

## Example Usage

### Single Recipient
```json
{
  "name": "email",
  "type": "Email",
  "value": "analyst@company.com"
}
```

### Multiple Recipients
```json
{
  "name": "email",
  "type": "Email",
  "value": "[\"team@company.com\",\"manager@company.com\"]"
}
```

### Using Variable Expression
```json
{
  "name": "email",
  "type": "Email",
  "value": "{{@notificationEmail}}"
}
```

## Typical Use Cases

- `native.savetobucketandnotify` - Send notification after export
- Workflow completion notifications
- Error alerts

## Related Types
- `String` - For general text values
