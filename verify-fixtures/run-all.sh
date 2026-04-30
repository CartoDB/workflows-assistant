#!/usr/bin/env bash
# Run every fixture and compare the expected issue code against the actual
# verify output. Pass --connection / -c to override the default connection.
#
# Usage:
#   ./run-all.sh                       # uses 000-dvicente
#   ./run-all.sh --connection my-conn  # custom connection
#   CARTO_CLI=/path/to/carto ./run-all.sh

set -u

CONNECTION=000-dvicente
while [ $# -gt 0 ]; do
  case "$1" in
    -c|--connection) CONNECTION="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

CARTO=${CARTO_CLI:-carto}
DIR=$(cd "$(dirname "$0")" && pwd)

# Each row: <fixture> <verify-flag> <expected-substring>
# verify-flag: empty for Tier-0/1, "sources" or "sql" for Tier-2.
# expected-substring is a fixed string the script greps for in the (color-stripped) output.
ROWS=(
  # ── Tier-0 (offline structural) ─────────────────────────────────────
  "tier0-missing-connectionid|     |connectionId|Required on create"
  "tier0-non-uuid-connectionid|    |connectionId|Expected UUID format"
  "tier0-stray-bundle-key|         |belongs inside \"config\""
  "tier0-unknown-provider|         |Unrecognized provider"
  "tier0-nodes-not-array|          |config.nodes|Expected array"
  "tier0-node-missing-id|          |id|Required string"
  "tier0-node-bad-type|            |type|Expected one of"
  "tier0-generic-no-version|       |version|Required on generic nodes"
  "tier0-source-fqn-mismatch|      |Source nodes: data.id and data.inputs.* must be the same FQN"
  "tier0-unknown-component|        |Unknown component"
  "tier0-component-input-shape|    |distance: Expected number"
  "tier0-edge-ghost-target|        |Must reference an existing node id"
  "tier0-bad-privacy|              |privacy|Expected one of"
  # ── Tier-1 (deep, always runs) ──────────────────────────────────────
  "tier1-component-invalid-missing-required|  |COMPONENT_INVALID"
  "tier1-component-invalid-wrong-value|       |Aggregation method cannot be \"GEOMETRIC\""
  "tier1-schema-trace-customsql-syntax|       |SCHEMA_TRACE.*Syntax error"
  "tier1-schema-trace-hallucinated-column|    |SCHEMA_TRACE.*nonexistent_column"
  "tier1-schema-trace-skipped-disconnected|   |SCHEMA_TRACE_SKIPPED.*not connected"
  "tier1-schema-trace-skipped-upstream-failed||SCHEMA_TRACE_SKIPPED.*upstream node 'broken-upstream' failed"
  # ── Tier-2 (opt-in) ─────────────────────────────────────────────────
  "tier2-source-inaccessible|sources|SOURCE_INACCESSIBLE"
  "tier2-source-region-mismatch|sources|SOURCE_REGION_MISMATCH"
  "tier2-customsql-unbound|sql    |CUSTOMSQL_INVALID.*no edge binds"
  "tier2-customsql-dryrun-fail|sql |CUSTOMSQL_INVALID.*failed dry-run"
  "tier2-customsql-skipped-chained|sql|VERIFY_SKIPPED.*statically-knowable FQN"
)

# ANSI color stripper used on every captured output before grepping.
strip_ansi() { sed -E 's/\x1b\[[0-9;]*m//g'; }

PASS=0
FAIL=0
RESULTS=()

for row in "${ROWS[@]}"; do
  IFS='|' read -r fixture flag expected <<<"$row"
  fixture=$(echo "$fixture" | xargs)  # trim
  flag=$(echo "$flag" | xargs)

  cmd=("$CARTO" workflows verify-remote "$DIR/$fixture.json" --connection "$CONNECTION")
  [ -n "$flag" ] && cmd+=("--verify=$flag")

  echo "─── $fixture ───"
  echo "  expected: $expected"
  output=$("${cmd[@]}" 2>&1 | strip_ansi)

  if echo "$output" | grep -Eq "$expected"; then
    echo "  actual:   ✓ matched"
    PASS=$((PASS + 1))
    RESULTS+=("PASS $fixture")
  else
    echo "  actual:   ✗ MISMATCH"
    echo "$output" | sed 's/^/    │ /'
    FAIL=$((FAIL + 1))
    RESULTS+=("FAIL $fixture")
  fi
  echo
done

echo "════════════════════════════════════════════════"
echo "Summary: $PASS passed, $FAIL failed (of $((PASS + FAIL)))"
printf '  %s\n' "${RESULTS[@]}"

[ "$FAIL" -eq 0 ]
