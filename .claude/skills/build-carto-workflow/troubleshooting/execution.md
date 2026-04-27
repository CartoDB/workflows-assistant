# Execution Issues

Debugging runtime failures and unexpected results.

---

## Error Patterns

| Error Pattern | Likely Cause | Resolution |
|---------------|--------------|------------|
| "Access Denied" | Insufficient permissions on table | Verify user has read access; check with data owner |
| "Query exceeded resources" | Query too complex or data too large | Add filters to reduce data volume; break into smaller steps |
| "Job timeout" | Long-running query | Check if table has appropriate partitioning; consider filtering early |
| Empty results (0 rows) | Filter too restrictive or join mismatch | Preview source data to verify filter values exist; check join keys |

---

## Debugging Empty Results

When a query returns 0 rows unexpectedly:

1. **Check filter values**: Run `SELECT DISTINCT column FROM table LIMIT 20` to see actual values
2. **Verify case sensitivity**: Values are case-sensitive; `'Active'` != `'active'`
3. **Check join keys**: Ensure join columns have matching values in both tables
4. **Inspect intermediate results**: Add temporary output nodes to check data at each step

---

## Debugging SQL

Generate and inspect the SQL:

```bash
carto workflows to-sql workflow.json --connection <connection>
```

Review the generated SQL for:
- Correct table references
- Expected filter conditions
- Proper join logic

---

## Execution Methods

### Local Execution

```bash
carto workflows to-sql workflow.json --connection <connection> > workflow.sql
cat workflow.sql | carto sql job <connection>
```

### Platform Execution

Upload the workflow and run it from CARTO:

```bash
carto workflows create --file workflow.json --verify
# Then run from https://app.carto.com/workflows/<workflow-id>
```

The connection is read from `connectionId` inside the bundle — no `--connection` flag is accepted by `create`.

---

## For Snowflake: SQL Generation Notes

- Verify `connectionProvider` is set to `"snowflake"` — a mismatch generates BigQuery SQL against a Snowflake connection
- Column references in generated SQL will be uppercase — this is expected Snowflake behavior

---

## Performance Tips

1. **Filter early**: Apply filters as close to the source as possible
2. **Limit columns**: Select only needed columns in joins
3. **Use spatial indices**: Prefer H3/Quadbin operations over raw geometry operations
4. **Partition awareness**: Filter on partition columns when possible
