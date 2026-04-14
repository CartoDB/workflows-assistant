# Authentication Commands

## carto auth status

Check authentication status and token expiration.

```bash
carto auth status [profile]
```

**Output includes**:
- Token validity and expiration time
- Tenant, organization, and user info
- Available profiles

**Example**:
```bash
carto auth status
# Shows: ✓ Authenticated, token expires in X hours
```

## carto auth login

Interactive browser-based login.

```bash
carto auth login [profile]
  --organization-name <name>  # Required for SSO login
  --env <env>                 # Only if instructed by support
```

**Important**: Opens a browser window. Always inform the user before running and wait for confirmation.

**Examples**:
```bash
carto auth login                              # Default login
carto auth login production                   # Login with profile name
carto auth login --organization-name "ACME"   # SSO login
```

## carto auth logout

Remove stored credentials.

```bash
carto auth logout [profile]
```

## carto auth use

Switch between profiles.

```bash
carto auth use <profile>
```

## carto auth whoami

Show current user info only.

```bash
carto auth whoami
```

## Multiple Profiles

If the user has multiple CARTO accounts or organizations:

```bash
# List profiles (shown in auth status output)
carto auth status

# Switch profile
carto auth use <profile-name>

# Check current user
carto auth whoami
```

## Gotchas

### Browser Opens on Login

The `carto auth login` command opens a browser window for OAuth authentication. Always:
1. Inform the user before running
2. Wait for their confirmation
3. Explain that a browser window will open

### Token Expiration

Tokens expire after a period of inactivity. If you see authentication errors:
1. Run `carto auth status` to confirm
2. Run `carto auth login` to refresh

### Critical Rule

**Do NOT proceed with any workflow operations until authentication is confirmed.** Failed auth causes all subsequent commands to fail with unhelpful error messages.
