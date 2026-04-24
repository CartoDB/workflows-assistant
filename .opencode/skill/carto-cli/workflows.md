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

Offline structural validation of a workflow diagram JSON file using Zod schemas. No auth or connection required.

```bash
carto workflows validate [json]
  --file <path>             # Read JSON from file (or pipe via stdin)
  --mode <create|update>    # Validation mode (default: update)
  --json                    # JSON output
```

**Examples**:
```bash
# Offline structural validation
carto workflows validate workflow.json --json

# Validate as a new workflow
carto workflows validate workflow.json --mode create --json
```

**Note**: `validate` is Zod-only and offline — it checks JSON structure and schema conformance but does NOT connect to the warehouse. Use `carto workflows verify` for deep (warehouse-aware) validation.

## carto workflows verify

Deep validation against a live warehouse connection. Runs: structural (Zod) + engine compile + schema trace + sources + custom SQL checks.

```bash
carto workflows verify [json]
  --file <path>                      # Read JSON from file (or pipe via stdin)
  --connection <name|uuid>           # Connection (required unless bundle has connectionId)
  --json                             # JSON output
```

**Examples**:
```bash
# Full deep validation with explicit connection
carto workflows verify workflow.json --connection my-bigquery --json

# When bundle already has connectionId set
carto workflows verify workflow.json --json
```

**Use `verify` when**: you need column-type checking, table existence, AT resolution, or any warehouse-aware validation. This is the replacement for the old `validate --connection` flow.

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

Upload a workflow to CARTO. The connection is read from `connectionId` inside the bundle — there is no `--connection` flag.

```bash
carto workflows create [json]
  --file <path>                      # Read JSON from file (or pipe via stdin)
  --verify[=sources,sql,compile]     # Run Tier-1+Tier-2 pipeline after writing (optional subset)
```

**Examples**:
```bash
carto workflows create --file workflow.json
carto workflows create --file workflow.json --verify
cat workflow.json | carto workflows create
```

## carto workflows components list

List available workflow components. `--connection` is required.

```bash
carto workflows components list
  --connection <name|uuid>  # Connection name or UUID (required)
  --group <name>            # Filter by group (optional)
  --search <term>           # Filter by search term (optional)
  --starred                 # Show only starred components (optional)
  --include-deprecated      # Include deprecated components (optional)
  --json                    # JSON output (recommended)
```

**Example**:
```bash
carto workflows components list --connection my-bigquery --json
carto workflows components list --connection my-bigquery --starred --json
```

## carto workflows components get

Get detailed component definitions. `--connection` is required.

```bash
carto workflows components get <names>
  --connection <name|uuid>  # Connection name or UUID (required)
  --input-formats           # Also return the deduped input/output type reference for these components
  --json                    # JSON output (always use this)
```

**Examples**:
```bash
# Single component
carto workflows components get native.buffer --connection my-bq --json

# Multiple components (comma-separated, no spaces)
carto workflows components get native.buffer,native.spatialjoin,native.groupby --connection my-bq --json

# Fetch component schemas AND input type format reference in one call
carto workflows components get native.buffer,native.spatialjoin --connection my-bq --input-formats --json
```

**JSON output includes**: inputs, outputs, types, defaults, validation rules.

### --input-formats flag

When `--input-formats` is passed, the response also includes the deduped format reference for every input/output type used across the requested components.

```json
{
  "inputTypes": [
    {
      "type": "Table",
      "format": "...",
      "examples": ["..."],
      "pitfalls": ["..."]
    }
  ],
  "notFound": []
}
```

**Important**: Pass **component names** (e.g. `native.buffer,native.spatialjoin`), NOT input type names (e.g. `Table`, `Column`). The flag resolves which input types those components use and returns their format/examples/pitfalls.

This replaces the old `carto workflows inputs` subcommand, which was planned but never shipped.

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
