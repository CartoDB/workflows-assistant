# Common Gotchas

Quick reference for known quirks that are NOT covered by the CLI's component `notes` or input `pitfalls`.

---

## CLI Gotchas

| Command | Issue |
|---------|-------|
| `workflows validate` | Offline/Zod-only — use `workflows verify --connection <conn>` for warehouse-aware validation |
| `workflows verify` | Requires `--connection` (or `connectionId` in the bundle) |
| `workflows to-sql` | Always use `--connection` for correct SQL generation |
| `connections browse/describe` | Quote paths with dots: `"project.dataset"` |

**Full details**: Load the `carto-cli` skill for complete CLI reference.

---

## Design Gotchas

| Issue | Solution |
|-------|----------|
| Lost columns after groupby | Include all needed columns in groupby or select first |
| Lost geometry after operations | Verify geometry column survives each step |
| Slow map rendering | Use H3/Quadbin columns directly instead of polygon geometry |
| Map doesn't auto-detect spatial column | Rename to `geom`, `h3`, or `quadbin` |

---

## Build Gotchas

| Issue | Solution |
|-------|----------|
| Edge not connecting | Verify handle names from component schema |
| Component not found | Fetch catalog: `carto workflows components list --connection <conn> --json` |
| Version mismatch | Always include `"version"` in node data — check schema for current version |
| Layout issues | Always include `position: { x, y }` for each node — it's required |
| `ColumnsForJoin` empty array | `[]` is valid and means "all columns". Use `[{"name":"col","joinname":"alias"}]` to select specific columns. |
| `inputs` as object | Must be an array of `{name, type, value}`, not a key-value params object |
| `--input-formats` wrong names | Pass component names (e.g. `native.buffer`), not input type names (e.g. `Table`), to `carto workflows components get <names> --connection <conn> --input-formats --json` |

---

## Component-Specific Gotchas

### `native.groupby` is single-column

`native.groupby` accepts a single `Column` for grouping. For multi-key
aggregation (e.g. group by `day_of_week` AND `month`), you need either:

- Two `native.groupby` nodes chained (group by A, then group by B), OR
- A `native.customsql` node with explicit `GROUP BY a, b` clause.

The skill's general guidance to "prefer high-level components over
`native.customsql`" doesn't apply when the high-level component can't
express what you need.

### `native.customsql` handle names are `sourcea`, `sourceb`, `sourcec`

Inside the SQL body, refer to upstream tables as `$a`, `$b`, `$c`. But the
input *names* on the node are `sourcea`, `sourceb`, `sourcec` — not `a`,
`b`, `c`. Use `carto workflows components get native.customsql --connection <conn> --json`
to see the exact input definition.

---

## Provider-Specific Gotchas

### For Snowflake

| Issue | Solution |
|-------|----------|
| Column names are UPPERCASE | Snowflake auto-uppercases unquoted identifiers. Use UPPERCASE in column references — including component-generated columns (e.g. `geom_buffer` → `GEOM_BUFFER`). |
| `connectionProvider` mismatch | Must be `"snowflake"` — mismatches cause wrong SQL dialect |
| Table FQN format | Use `DATABASE.SCHEMA.TABLE`, not `project.dataset.table` |
| Structure-only validation fails for AT components | Use `--connection` instead — structure-only can't resolve `analyticsToolboxDataset` |

### For BigQuery

| Issue | Solution |
|-------|----------|
| Table FQN format | Use `project.dataset.table` |
| Column casing | Preserves original case — must match exactly |

See [providers/](../providers/) for complete provider-specific documentation.
