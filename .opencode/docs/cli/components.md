# CLI: workflows components

List and inspect workflow component definitions.

## Usage

```bash
# List all components for a provider
carto workflows components list --provider bigquery --json

# Get component details
carto workflows components get native.buffer --provider bigquery --json

# With connection (fetches from remote)
carto workflows components list --connection my-connection --json
```

## Gotcha: --provider vs --connection

| Flag | Purpose | When to Use |
|------|---------|-------------|
| `--provider` | Use built-in component definitions | Default for local development |
| `--connection` | Fetch from remote connection | When you need connection-specific components |

**Common error**:
```
workflows components requires --connection <name>
```

This occurs when neither `--provider` nor `--connection` is specified. Always include one:

```bash
# For general component exploration
carto workflows components list --provider bigquery --json

# When using a specific connection
carto workflows components list --connection datascience --json
```
