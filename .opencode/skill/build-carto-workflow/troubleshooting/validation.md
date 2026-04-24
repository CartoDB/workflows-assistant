# Validation Issues

Error patterns and resolutions for `carto workflows validate` (offline) and `carto workflows verify` (deep) failures.

- **`carto workflows validate`** — Zod-only, offline, no auth. Catches JSON structure and schema errors.
- **`carto workflows verify`** — warehouse-aware. Catches column types, table existence, AT resolution, source errors, and custom SQL issues. Requires `--connection` (or `connectionId` in the bundle).

---

## Error Patterns

| Error Pattern | Likely Cause | Resolution |
|---------------|--------------|------------|
| "column not found" | Typo or case mismatch in column name | Run `carto connections describe <conn> "<table>"` to get exact column names |
| "type mismatch" / "expected GEOGRAPHY" | Using wrong column type for spatial operation | Check schema for correct geo column; look for columns of type `GEOGRAPHY` |
| "table not found" | Table doesn't exist or wrong FQN | Load `find-tables` skill to verify table exists and get correct path |
| "connection failed" | Auth expired or wrong connection name | Run `carto auth status`, then `carto connections list` to verify |
| "unknown component" | Component name typo or wrong provider | Run `carto workflows components list --connection <conn> --json` |
| "No value assigned" | Missing required input parameter | Check component schema for required inputs |
| "Edge references non-existent output" | Wrong sourceHandle name | Verify output handle name from component schema |

---

## For Snowflake: Always Use verify

`carto workflows validate` is offline and cannot resolve AT components. For Snowflake workflows using Analytics Toolbox components (H3, Quadbin, Getis-Ord, enrichment), always run `carto workflows verify --connection <conn>` — `analyticsToolboxDataset` is only resolved via the connection.

Column name warnings (e.g. `geom` not found, available: `GEOM`) indicate Snowflake uppercase casing — update your column references to UPPERCASE.

---

## Type Mismatch Warnings

Column type mismatches (e.g., string instead of geography) are reported as **warnings**, not errors. The workflow is still "valid" but may fail at runtime.

Always review warnings carefully - they often indicate issues that will cause runtime failures.

---

## General Recovery Steps

1. **Re-validate** with full flags after any fix
2. **Preview data** before assuming filter values: `SELECT DISTINCT column LIMIT 20`
3. **Check warnings** - they often indicate issues that cause runtime failures
4. **Simplify** - if stuck, remove nodes until you find the problematic one
5. **Fetch component schema** - verify input/output names match exactly
