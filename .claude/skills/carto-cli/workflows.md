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
carto workflows get <id>
  --client <name>             # Client identifier
  --json                      # JSON output
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

## carto workflows update

Update an existing workflow's configuration. Partial bundles are accepted.

```bash
carto workflows update <id> [json]
  --file <path>                      # Read JSON from file (or pipe via stdin)
  --verify[=sources,sql,compile]     # Run Tier-1+Tier-2 checks after writing (optional subset)
```

**Input methods** (in priority order):
1. Inline JSON argument
2. `--file` flag
3. Stdin (pipe)

**Examples**:
```bash
carto workflows update <id> '{"title":"New Title"}'
carto workflows update <id> --file updated-workflow.json
carto workflows update <id> --file workflow.json --verify
cat workflow.json | carto workflows update <id>
```

## carto workflows delete

Delete a workflow.

```bash
carto workflows delete <id>
```

**Note**: Requires typing "delete" to confirm, or use `--yes` to skip confirmation.

## carto workflows create

Upload a workflow to CARTO. The connection is read from `connectionId` inside the bundle — there is no `--connection` flag.

```bash
carto workflows create [json]
  --file <path>                      # Read JSON from file (or pipe via stdin)
  --verify[=sources,sql,compile]     # Run Tier-1+Tier-2 pipeline after writing (optional subset)
```

**Input methods** (in priority order):
1. Inline JSON argument
2. `--file` flag
3. Stdin (pipe)

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
  --connection <name>       # Connection name (optional)

# Remove schedule
carto workflows schedule remove <id>
  --connection <name>       # Connection name (optional)
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

## carto workflows run

Execute a workflow against its connection. Synchronous by default — polls until the job reaches a terminal state and surfaces per-node output tables on success.

```bash
carto workflows run <id>
  --no-cache              # Compile in FullNoCache mode (skip the engine cache)
  --async                 # Return jobId immediately instead of polling
  --poll-interval <ms>    # Polling interval (default: engine default)
  --timeout <ms>          # Abort polling after this many ms
  --json                  # JSON output
```

**Subcommands**:

```bash
# Check status of a previously submitted job
carto workflows run status <job-id>
  --connection <name>     # Connection (required if not derivable from job)
  --json

# Fetch output rows for a specific node
carto workflows run output <workflow-id> <node-id>
  --limit <n>             # Max rows to return
  --json
```

**Notes**:
- The workflow must have a `connectionId` set (no `--connection` flag on `run` itself — it uses the bundle's connection).
- `--async` is useful for long-running workflows; capture `jobId` from the response and poll with `workflows run status`.
- This command is hidden from `--help` (agent-facing) but stable.

## carto workflows share / unshare

Convenience verbs over the privacy endpoint. Resolves user emails → Auth0 user IDs and merges sharing changes (the underlying API requires full replacement of `userIds`/`groupIds`, but the CLI fetches current state and merges for you).

```bash
carto workflows share <id>
  --with <email>[,<email>...]   # Share with specific users (repeatable, or comma-separated)
  --org                         # Share with the entire organization
  --can-edit                    # Grant edit access (sets collaborative = true)
  --list                        # Show who has access; do not modify
  --json
```

```bash
carto workflows unshare <id>
  --with <email>[,<email>...]   # Revoke for specific users
  --org                         # Revoke org-wide sharing
  --json
```

**Examples**:
```bash
# Share with two users, viewer access
carto workflows share <id> --with alice@x.com,bob@x.com

# Share with the org and allow edits
carto workflows share <id> --org --can-edit

# Inspect current sharing state
carto workflows share <id> --list --json

# Revoke a user
carto workflows unshare <id> --with alice@x.com
```

**Note**: An email that doesn't resolve to a user in the org fails the command — typos error loud rather than silently skipping.

## carto workflows extensions install

Install a CARTO Workflows extension zip into a connection. Extracts the zip and runs the contained SQL via SQL API jobs.

```bash
carto workflows extensions install
  --file <path>             # Extension zip file (required)
  --connection <name>       # Target connection name (required)
  --json
```

**Example**:
```bash
carto workflows extensions install --file my-extension.zip --connection my-bigquery
```

## carto workflows schema [section]

Emit the JSON Schema for a part of the workflow bundle. Use this to introspect the exact bundle shape rather than guessing from examples — agents that read `customsql` and `handles` before composing a bundle produce runnable workflows on first try.

```bash
carto workflows schema [section] [--json]
```

**Available sections**:

| Section | What it documents |
|---------|-------------------|
| `bundle` | Top-level bundle shape used by `create` / `update` / `get` |
| `config` | The `config` block (datasets, nodes, edges, variables) |
| `node` | Generic workflow node |
| `node.source` | Source node specifics |
| `node.customsql` | Custom SQL node specifics |
| `customsql` | Custom SQL template / variable interpolation rules |
| `edge` | Edge between nodes |
| `privacy` | `privacy` + `sharingScope` + `userIds` / `groupIds` |
| `schedule` | Schedule expression shape |
| `variable` | Variable definition |
| `handles` | Input / output handle reference |
| `enums` | Enumerated values used across the bundle |
| `components` | Connected components catalog result |
| `components.summary` | Component summary entry |
| `components.detail` | Component detail entry |
| `components.input` | Component input summary |
| `components.output` | Component output summary |

**Examples**:
```bash
# List available sections
carto workflows schema

# Get the bundle shape
carto workflows schema bundle --json

# Custom SQL templating reference (high-value for agents)
carto workflows schema customsql --json

# Handle reference
carto workflows schema handles --json
```

## carto workflows mcp

Manage workflows-as-MCP-tools. A workflow can be published as a named MCP tool so AI agents can invoke it as a capability. The tool definition lives at `config.mcpTool` inside the workflow.

```bash
# Enable as MCP tool
carto workflows mcp publish <id>
  --name <name>              # Tool name (default: derived from workflow title)
  --description <desc>       # Tool description (default: workflow description)
  --from-file <path>         # Provide full mcpTool spec (overrides --name/--description)
  --json

# Disable as MCP tool
carto workflows mcp unpublish <id>
  --json

# Show the current mcpTool config
carto workflows mcp describe <id>
  --json

# List all workflows currently published as MCP tools
carto workflows mcp list
  --json
```

**Examples**:
```bash
# Quick publish using workflow title/description
carto workflows mcp publish <id>

# Publish with explicit name + description
carto workflows mcp publish <id> --name buffer_areas --description "Buffer geometries by N meters"

# Publish with a hand-crafted spec (inputs/outputs/procedure)
carto workflows mcp publish <id> --from-file mcp-tool.json

# List everything published in the current account
carto workflows mcp list --json
```

**Note**: The backend expands a minimal `{ enabled: true }` into the full skeleton on save. Use `--from-file` only when you need fine control over `inputs`, `output`, or `procedure`.
