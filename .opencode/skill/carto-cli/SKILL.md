---
name: carto-cli
description: Complete `carto` CLI reference commands - load me before any `carto` command
---

# CARTO CLI Reference

The `carto` CLI is the command-line interface for the CARTO platform. This skill provides comprehensive documentation for the most commonly used commands.

**Version**: 0.1.0

---

## Global Options

These flags work with all commands:

| Flag | Description |
|------|-------------|
| `--json` | Output in JSON format (recommended for parsing) |
| `--debug` | Show request details (method, URL, headers) |
| `--yes`, `-y` | Skip confirmation prompts (for automation) |
| `--profile <name>` | Use specific profile (default: "default") |
| `--token <token>` | Override API token |
| `--base-url <url>` | Override base API URL |

**Environment Variables**:
- `CARTO_API_TOKEN` - API token for authentication
- `CARTO_PROFILE` - Profile to use (overrides current_profile)

---

## Authentication Commands

### carto auth status

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

### carto auth login

Interactive browser-based login.

```bash
carto auth login [profile]
  --organization-name <name>  # Required for SSO login
  --env <env>                 # Only if instructed by support
```

**Important**: Opens a browser window. Inform the user before running.

**Examples**:
```bash
carto auth login                              # Default login
carto auth login production                   # Login with profile name
carto auth login --organization-name "ACME"   # SSO login
```

### carto auth logout

Remove stored credentials.

```bash
carto auth logout [profile]
```

### carto auth use

Switch between profiles.

```bash
carto auth use <profile>
```

### carto auth whoami

Show current user info only.

```bash
carto auth whoami
```

---

## Connection Commands

### carto connections list

List all available connections.

```bash
carto connections list [--all]
  --page <n>          # Page number (default: 1)
  --page-size <n>     # Items per page (default: 10)
  --search <query>    # Search by text
  --json              # JSON output
```

**Examples**:
```bash
carto connections list                    # First 10 connections
carto connections list --all              # All connections (paginated)
carto connections list --search bigquery  # Search by name
carto connections list --json             # JSON output for parsing
```

### carto connections get

Get detailed connection info by ID.

```bash
carto connections get <id>
```

### carto connections browse

Browse connection resources hierarchically.

```bash
carto connections browse <name> [path]
  --page <n>          # Page number (default: 1)
  --page-size <n>     # Items per page (default: 30)
```

**Path hierarchy for BigQuery**:
1. No path: Lists projects
2. `"project"`: Lists datasets
3. `"project.dataset"`: Lists tables

**Examples**:
```bash
carto connections browse carto_dw                          # List projects
carto connections browse carto_dw "carto-demo-data"        # List datasets
carto connections browse carto_dw "carto-demo-data.demo_tables"  # List tables
```

**Gotcha**: Path must be quoted if it contains dots.

### carto connections describe

Get table schema and details.

```bash
carto connections describe <name> "<table-path>"
  --json              # JSON output (recommended)
```

**Examples**:
```bash
carto connections describe carto_dw "carto-demo-data.demo_tables.cities"
carto connections describe my-bq "project.dataset.table" --json
```

**Gotcha**: Table path must be quoted and use fully-qualified name.

---

## SQL Commands

### carto sql query

Run SQL query and return results.

```bash
carto sql query <connection> [sql]
  --file <path>       # Read SQL from file
  --cache             # Use cached results (1yr cache, 1min timeout)
  --json              # JSON output
```

**Input methods** (in priority order):
1. Inline SQL argument
2. `--file` flag
3. Stdin (pipe)

**Examples**:
```bash
# Inline query
carto sql query carto_dw "SELECT * FROM dataset.table LIMIT 10"

# From file
carto sql query carto_dw --file query.sql

# From stdin
echo "SELECT COUNT(*) FROM dataset.table" | carto sql query carto_dw

# With caching
carto sql query carto_dw "SELECT * FROM table" --cache

# JSON output
carto sql query carto_dw "SELECT * FROM table LIMIT 5" --json
```

**JSON output format**:
```json
{
  "rows": [{"column": "value"}],
  "schema": [{"name": "column", "type": "string"}],
  "meta": {"cacheHit": false, "totalBytesProcessed": "1234"}
}
```

**Gotcha**: Default POST (no cache). Use `--cache` for GET with caching.

### carto sql job

Run SQL job for DDL/DML operations (no results returned).

```bash
carto sql job <connection> [sql]
  --file <path>       # Read SQL from file
```

**Use for**:
- CREATE TABLE
- INSERT/UPDATE/DELETE
- Any long-running operation

**Examples**:
```bash
carto sql job carto_dw "CREATE TABLE dataset.newtable AS SELECT..."
carto sql job carto_dw --file create_tables.sql
cat workflow.sql | carto sql job carto_dw
```

**Behavior**: Polls until job completes, no timeout.

---

## Workflow Commands

### carto workflows list

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

### carto workflows get

Get workflow details.

```bash
carto workflows get <id> [--json]
```

### carto workflows validate

Validate a workflow diagram JSON file.

```bash
carto workflows validate <file>
  --connection <name>       # Connection for schema validation (recommended)
  --temp-location <loc>     # Temp location (e.g., project.dataset)
  --json                    # JSON output
```

**Important**: Without `--connection`, only structure is validated, NOT column types or table existence.

**Examples**:
```bash
# Structure-only validation (basic)
carto workflows validate workflow.json

# Full validation with connection (recommended)
carto workflows validate workflow.json \
  --connection my-bigquery \
  --temp-location "project.dataset" \
  --json
```

### carto workflows to-sql

Generate SQL from workflow diagram.

```bash
carto workflows to-sql <file>
  --temp-location <loc>     # Where intermediate tables are created
  --provider <name>         # Override diagram provider
  --dry-run                 # Generate empty tables for schema validation
  --no-cache                # Disable caching
```

**Gotcha**: Does NOT support `--connection` flag. This is different from `validate`.

**Examples**:
```bash
# Generate SQL
carto workflows to-sql workflow.json --temp-location "project.dataset"

# Dry-run for schema validation
carto workflows to-sql workflow.json --dry-run

# Save to file and execute
carto workflows to-sql workflow.json --temp-location "project.dataset" > workflow.sql
cat workflow.sql | carto sql job my-connection
```

### carto workflows show

Display workflow diagram structure (for debugging).

```bash
carto workflows show <file>
```

### carto workflows components list

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

**Gotcha**: Requires `--connection`. There is no `--provider` flag for listing.

### carto workflows components get

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

# Multiple components
carto workflows components get native.buffer,native.spatialjoin --connection my-bq --json
```

**JSON output includes**: inputs, outputs, types, defaults, validation rules.

### carto workflows schedule

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

### carto workflows copy

Copy workflow between profiles/organizations.

```bash
carto workflows copy <id>
  --dest-profile <profile>   # Destination profile (required)
  --source-profile <profile> # Source profile (default: current)
  --connection <name>        # Destination connection (optional)
  --title <title>            # Override title (optional)
  --skip-source-validation   # Skip table accessibility check
```

---

## Import Commands

### carto imports create

Import geospatial files to a table.

```bash
carto imports create
  --file <path>             # Local file to upload
  --url <url>               # Remote file URL
  --connection <name>       # Connection name (required)
  --destination <fqn>       # Target table FQN (required)
  --overwrite               # Overwrite existing table
  --no-autoguessing         # Disable column type detection
  --async                   # Return immediately (don't wait)
```

**Supported formats**: CSV, GeoJSON, GeoPackage, GeoParquet, KML, KMZ, Shapefile (zip)

**Size limit**: 1GB per file

**Examples**:
```bash
# Local file
carto imports create \
  --file ./data.csv \
  --connection carto_dw \
  --destination project.dataset.table

# Remote URL
carto imports create \
  --url https://example.com/data.geojson \
  --connection carto_dw \
  --destination project.dataset.my_data

# Overwrite existing
carto imports create \
  --file ./updated.csv \
  --connection carto_dw \
  --destination project.dataset.table \
  --overwrite
```

**Behavior**: Waits for completion by default. Use `--async` to return immediately.

---

## Common Gotchas

| Issue | Cause | Solution |
|-------|-------|----------|
| `workflows validate` misses column errors | Missing `--connection` flag | Always use `--connection` and `--temp-location` |
| `workflows to-sql --connection` fails | Flag not supported | Remove `--connection`, use only `--temp-location` |
| `workflows components list` fails | Missing connection | Add `--connection <name>` |
| Table path not found | Unquoted path | Quote paths with dots: `"project.dataset.table"` |
| Token expired | Session timeout | Run `carto auth login` |
| Delete command hangs | Waiting for confirmation | Type "delete" or use `--yes` flag |

---

## Quick Reference

| Task | Command |
|------|---------|
| Check auth | `carto auth status` |
| List connections | `carto connections list` |
| Describe table | `carto connections describe <conn> "<fqn>"` |
| Run query | `carto sql query <conn> "<sql>"` |
| Execute DDL/DML | `carto sql job <conn> "<sql>"` |
| Validate workflow | `carto workflows validate file.json --connection <conn> --temp-location "<loc>"` |
| Generate SQL | `carto workflows to-sql file.json --temp-location "<loc>"` |
| List components | `carto workflows components list --connection <conn> --json` |
| Get component | `carto workflows components get <name> --connection <conn> --json` |
| Import file | `carto imports create --file <path> --connection <conn> --destination "<fqn>"` |
