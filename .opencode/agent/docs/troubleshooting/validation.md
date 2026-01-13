# Troubleshooting: Validation Failures

## Error Patterns

| Error Pattern | Likely Cause | Resolution |
|---------------|--------------|------------|
| "column not found" | Typo or case mismatch in column name | Run `carto connections describe <conn> "<table>"` to get exact column names |
| "type mismatch" / "expected GEOGRAPHY" | Using wrong column type for spatial operation | Check schema for correct geo column; look for columns of type `GEOGRAPHY` |
| "table not found" | Table doesn't exist or wrong FQN | Delegate to `carto-table-finder` to verify table exists and get correct path |
| "connection failed" | Auth expired or wrong connection name | Run `carto auth status`, then `carto connections list` to verify |
| "unknown component" | Component name typo or wrong provider | Run `carto workflows components list --provider <provider> --json` |

## Type Mismatch Warnings

Column type mismatches (e.g., string instead of geography) are reported as **warnings**, not errors. The workflow is still "valid" but may fail at runtime.

Always review warnings carefully - they often indicate issues that will cause runtime failures.

## General Recovery Steps

1. **Re-validate** with full flags after any fix
2. **Preview data** before assuming filter values: `SELECT DISTINCT column LIMIT 20`
3. **Check warnings** - they often indicate issues that cause runtime failures
4. **Simplify** - if stuck, remove nodes until you find the problematic one
