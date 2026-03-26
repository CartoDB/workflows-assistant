# Common Gotchas

Quick reference for known quirks that are NOT covered by the CLI's component `notes` or input `pitfalls`.

---

## CLI Gotchas

| Command | Issue |
|---------|-------|
| `workflows validate` | Always use `--connection` for full validation |
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
| Version mismatch | Include `"version": "2"` in node data if needed |
| Layout issues | Always include `position: { x, y }` for each node |
