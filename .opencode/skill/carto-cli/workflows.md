# Workflow Commands

## carto workflows list

List workflows in the organization.

```bash
carto workflows list [options]
  --page <n>              # Page number
  --pageSize <n>          # Items per page
  --orderBy <field>       # Order by field
  --orderDirection <dir>  # ASC or DESC
  --search <term>         # Search term
  --privacy <level>       # Privacy level
  --tags <json-array>     # Filter by tags
  --json                  # JSON output
```

**Examples**:
```bash
carto workflows list --pageSize 10
carto workflows list --search "sales" --json
carto workflows list --orderBy updatedAt --orderDirection DESC
```

## carto workflows get

Get workflow details.

```bash
carto workflows get <id> [--json]
```

## carto workflows validate

Validate a workflow diagram JSON file.

```bash
carto workflows validate <file>
  --connection <name>       # Connection (provides all defaults - recommended)
  --temp-location <loc>     # Override temp location (optional)
  --json                    # JSON output
```

**Examples**:
```bash
# Structure-only validation (basic)
carto workflows validate workflow.json

# Full validation with connection (recommended)
carto workflows validate workflow.json --connection my-bigquery --json
```

### Connection-Derived Defaults

When `--connection` is provided, these are auto-configured from the connection:
- Analytics Toolbox location (`atLocation`)
- Temp location (`tempLocations`)
- Workspace/Extensions locations

**Always use `--connection`** for full validation (column types, table existence).

## carto workflows to-sql

Generate SQL from workflow diagram.

```bash
carto workflows to-sql <file>
  --connection <name>       # Connection (provides all defaults - recommended)
  --temp-location <loc>     # Override temp location (optional)
  --provider <name>         # Override diagram provider (optional)
  --dry-run                 # Generate empty tables for schema validation
  --no-cache                # Disable caching
```

**Examples**:
```bash
# Generate SQL using connection defaults (recommended)
carto workflows to-sql workflow.json --connection my-bigquery

# Dry-run for schema validation
carto workflows to-sql workflow.json --connection my-bigquery --dry-run

# Save to file and execute
carto workflows to-sql workflow.json --connection my-bigquery > workflow.sql
cat workflow.sql | carto sql job my-bigquery
```

### Connection-Derived Defaults

When `--connection` is provided, these are auto-configured from the connection:
- Analytics Toolbox location (`atLocation`)
- Temp location (`tempLocations`)
- Provider (`provider_id`)

**Always use `--connection`** for simplest usage.

## carto workflows show

Display workflow diagram structure (for debugging).

```bash
carto workflows show <file>
```

## carto workflows create

Upload a workflow to CARTO.

```bash
carto workflows create --file <path> --connection <name>
```

**Note**: The `--connection` flag is required when uploading a workflow diagram JSON.

## carto workflows components list

List available workflow components.

```bash
carto workflows components list
  --connection <name>       # Connection name (required)
  --json                    # JSON output (recommended)
```

**Example**:
```bash
carto workflows components list --connection my-bigquery --json
```

### Gotcha: Requires --connection

There is no `--provider` flag for listing. Must specify a connection:

```bash
# Wrong
carto workflows components list

# Correct
carto workflows components list --connection carto_dw --json
```

## carto workflows components get

Get detailed component definitions.

```bash
carto workflows components get <names>
  --connection <name>       # Connection name (required)
  --json                    # JSON output (always use this)
```

**Examples**:
```bash
# Single component
carto workflows components get native.buffer --connection my-bq --json

# Multiple components (comma-separated, no spaces)
carto workflows components get native.buffer,native.spatialjoin,native.groupby --connection my-bq --json
```

**JSON output includes**: inputs, outputs, types, defaults, validation rules.

## carto workflows inputs

Get input type formats, examples, and pitfalls for the input types used by specific components.

```bash
carto workflows inputs <component-names>
  --connection <name>       # Connection name (required)
  --json                    # JSON output (always use this)
```

**Important**: Pass **component names** (e.g. `native.buffer,native.spatialjoin`), NOT input type names (e.g. `Table`, `Column`). The command resolves which input types those components use and returns their format details.

**Examples**:
```bash
# Get input formats for buffer component
carto workflows inputs native.buffer --connection my-bq --json

# Multiple components
carto workflows inputs native.buffer,native.spatialjoin,native.groupby --connection my-bq --json
```

**JSON output includes**: `format` (expected value shape), `examples` (concrete JSON snippets), `pitfalls` (common mistakes).

## carto workflows schedule

Manage workflow schedules.

```bash
# Add schedule
carto workflows schedule add <id>
  --expression <expr>       # Schedule expression (required)
  --connection <name>       # Connection name (optional)

# Update schedule
carto workflows schedule update <id>
  --expression <expr>       # New expression (required)

# Remove schedule
carto workflows schedule remove <id>
```

**Schedule expression formats by provider**:

| Provider | Format | Example |
|----------|--------|---------|
| BigQuery/CARTO DW | English | `"every day 08:00"`, `"every monday 09:00"`, `"every 2 hours"` |
| Snowflake/PostgreSQL | Cron | `"0 8 * * *"`, `"0 9 * * 1"` |
| Databricks | Quartz Cron | `"0 0 8 * * ?"`, `"0 0 9 ? * MON"` |

## carto workflows copy

Copy workflow between profiles/organizations.

```bash
carto workflows copy <id>
  --dest-profile <profile>   # Destination profile (required)
  --source-profile <profile> # Source profile (default: current)
  --connection <name>        # Destination connection (optional)
  --title <title>            # Override title (optional)
  --skip-source-validation   # Skip table accessibility check
```
