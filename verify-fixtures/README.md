# Verify fixtures

Minimal workflow JSONs that each trigger a distinct error or warning emitted by `carto workflows verify-remote`. Use them to reproduce, demonstrate, or regression-test the verify pipeline.

## How to use

```bash
# All fixtures need a real BigQuery connection.
# Replace 000-dvicente with the name (or UUID) of your own connection.
cd ~/Projects/workflows-assistant-skills/verify-fixtures
carto workflows verify-remote <fixture>.json --connection 000-dvicente

# Tier-2 checks are opt-in; the tier2-*.json fixtures require flags:
carto workflows verify-remote tier2-source-inaccessible.json \
  --connection 000-dvicente --verify=sources

carto workflows verify-remote tier2-customsql-dryrun-fail.json \
  --connection 000-dvicente --verify=sql
```

Some fixtures embed a placeholder connection UUID — Tier-0 fixtures don't need it to be real (they fail before any network call). Tier-1 and Tier-2 fixtures expect a working BigQuery connection in your tenant.

## Tier-0 — Structural (offline Zod)

Fail before the CLI talks to the API. Run via the standalone command (`workflows verify-remote`), not via `--verify` on create/update.

| Fixture | Triggers |
|---|---|
| `tier0-missing-connectionid.json` | Bundle has no `connectionId` (required on create) |
| `tier0-non-uuid-connectionid.json` | `connectionId` is a name, not a UUID |
| `tier0-stray-bundle-key.json` | `nodes` placed at the bundle root instead of inside `config` |
| `tier0-unknown-provider.json` | `connectionProvider` outside the allow-list |
| `tier0-nodes-not-array.json` | `config.nodes` is an object, not an array |
| `tier0-node-missing-id.json` | A node without `id` |
| `tier0-node-bad-type.json` | A node `type` outside the allow-list |
| `tier0-generic-no-version.json` | A `generic` node missing `data.version` |
| `tier0-source-fqn-mismatch.json` | `source` node where `data.id` and `data.inputs[0].value` differ |
| `tier0-unknown-component.json` | `data.name` references a component not in the catalog |
| `tier0-component-input-shape.json` | A component input value with the wrong type (string for `Number`) |
| `tier0-edge-ghost-target.json` | An edge whose `target` is not the id of any node |
| `tier0-bad-privacy.json` | `privacy` outside the allow-list |

## Tier-1 — Deep engine pipeline (always runs)

Surface as `errors` (workflow invalid) or `warnings` (skipped/load) in the deep validation result.

| Fixture | Triggers | Code |
|---|---|---|
| `tier1-component-invalid-missing-required.json` | Required component parameter unset | `COMPONENT_INVALID` (cheap pass) |
| `tier1-component-invalid-wrong-value.json` | Component-specific custom rule violation (`STANDARD_SCALER` + `GEOMETRIC` on spatialcompositeunsupervised) | `COMPONENT_INVALID` (cheap pass) |
| `tier1-schema-trace-customsql-syntax.json` | Custom SQL body has a syntax error | `SCHEMA_TRACE` |
| `tier1-schema-trace-hallucinated-column.json` | Custom SQL references a column the upstream doesn't expose | `SCHEMA_TRACE` (with "Available columns: …" hint) |
| `tier1-schema-trace-skipped-disconnected.json` | Required InputTable port has no inbound edge | `SCHEMA_TRACE_SKIPPED` |
| `tier1-schema-trace-skipped-upstream-failed.json` | Node downstream of a node that failed schema trace | `SCHEMA_TRACE_SKIPPED` |

> `EXTENSION_LOAD` / `STORED_PROCEDURE_LOAD` warnings depend on the workflow referencing extensions or stored procedures that exist (and break) inside your specific connection — they aren't portable as static fixtures.

## Tier-2 — Opt-in dry-run probes (warnings only)

Need the corresponding `--verify=…` flag.

| Fixture | Flag | Code |
|---|---|---|
| `tier2-source-inaccessible.json` | `--verify=sources` | `SOURCE_INACCESSIBLE` |
| `tier2-source-region-mismatch.json` | `--verify=sources` | `SOURCE_REGION_MISMATCH` |
| `tier2-customsql-unbound.json` | `--verify=sql` | `CUSTOMSQL_INVALID` (no inbound edge for `$a`) |
| `tier2-customsql-dryrun-fail.json` | `--verify=sql` | `CUSTOMSQL_INVALID` (body fails dry-run) |
| `tier2-customsql-skipped-chained.json` | `--verify=sql` | `VERIFY_SKIPPED` (upstream FQN only known at runtime) |
