# Connection Commands

## carto connections list

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

## carto connections get

Get detailed connection info by ID.

```bash
carto connections get <id>
```

## carto connections browse

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
carto connections browse carto_dw                               # List projects
carto connections browse carto_dw "carto-demo-data"             # List datasets
carto connections browse carto_dw "carto-demo-data.demo_tables" # List tables
```

### Gotcha: --page-size Ignored

The `--page-size` flag exists but is ignored. Use `| head -n N` to limit output, or query `INFORMATION_SCHEMA.TABLES` for more control:

```bash
carto sql query <connection> "
  SELECT table_name
  FROM \`project.dataset.INFORMATION_SCHEMA.TABLES\`
  ORDER BY table_name
  LIMIT 20
"
```

### Gotcha: Quote Paths with Dots

Path must be quoted if it contains dots:

```bash
# Wrong - shell interprets dots
carto connections browse carto_dw carto-demo-data.demo_tables

# Correct
carto connections browse carto_dw "carto-demo-data.demo_tables"
```

## carto connections describe

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

**Output includes**:
- Column names and types
- Table metadata
- Row count (when available)

### Gotcha: Fully-Qualified Path Required

Table path must be quoted and use the fully-qualified name:

```bash
# Wrong
carto connections describe carto_dw cities

# Correct
carto connections describe carto_dw "project.dataset.cities"
```
