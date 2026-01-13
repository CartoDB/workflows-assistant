# Troubleshooting: Execution Failures

## Error Patterns

| Error Pattern | Likely Cause | Resolution |
|---------------|--------------|------------|
| "Access Denied" | Insufficient permissions on table | Verify user has read access; check with data owner |
| "Query exceeded resources" | Query too complex or data too large | Add filters to reduce data volume; break into smaller steps |
| "Job timeout" | Long-running query | Check if table has appropriate partitioning; consider filtering early |
| Empty results (0 rows) | Filter too restrictive or join mismatch | Preview source data to verify filter values exist; check join keys |

## Debugging Empty Results

When a query returns 0 rows unexpectedly:

1. **Check filter values**: Run `SELECT DISTINCT column FROM table LIMIT 20` to see actual values
2. **Verify case sensitivity**: Values are case-sensitive; `'Active'` ≠ `'active'`
3. **Check join keys**: Ensure join columns have matching values in both tables
4. **Inspect intermediate results**: Add temporary output nodes to check data at each step
