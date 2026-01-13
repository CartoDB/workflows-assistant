# CLI: Authentication

## Commands

```bash
carto auth status   # Check authentication status
carto auth login    # Login (opens browser)
carto auth logout   # Logout
```

## Gotchas

### Browser window opens on login

The `carto auth login` command opens a browser window for authentication. Always inform the user before running this command and wait for their confirmation.

### Token expiration

Tokens expire periodically. Re-authenticate with `carto auth login` when you see authentication errors.
