# SQL Commands

## carto sql query

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

### Gotcha: Default is POST (No Cache)

By default, queries use POST which doesn't cache. Use `--cache` for GET with caching (1 year cache, 1 minute timeout).

## carto sql job

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

## Common Patterns

### Execute Generated Workflow SQL

```bash
carto workflows to-sql workflow.json --connection my-connection > workflow.sql
cat workflow.sql | carto sql job my-connection
```

### Preview Data

```bash
carto sql query <conn> "SELECT * FROM \`project.dataset.table\` LIMIT 10"
```

### Get Column Statistics

```bash
carto sql query <conn> "
  SELECT
    MIN(numeric_col) as min_val,
    MAX(numeric_col) as max_val,
    AVG(numeric_col) as avg_val,
    COUNT(*) as total_rows
  FROM \`project.dataset.table\`
"
```

### Check Distinct Values

```bash
carto sql query <conn> "SELECT DISTINCT column FROM \`project.dataset.table\` LIMIT 50"
```
