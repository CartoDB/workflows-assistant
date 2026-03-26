---
name: enriching-local-api-info
description: How to enrich component notes and input type documentation served by the local workflows-api
---

# Enriching Local API Information

The workflows-api serves component schemas (with `notes`) and input type documentation (with `format`, `examples`, `pitfalls`) to the CLI. This skill explains how to add or improve that information and verify it locally.

## Where the data lives

### Input type formats

**File**: `~/Projects/cloud-native/packages/workflows-engine/src/input-formats.ts`

Each input type (Table, Number, Condition, ColumnsForJoin, etc.) is an entry in the `INPUT_TYPE_FORMATS` record. Structure:

```typescript
[WorkflowComponentParamType.Condition]: {
  type: 'Condition',
  title: 'Condition',
  format: 'Prose description of the value format and structure.',
  examples: [
    '{ "name": "conditions", "type": "Condition", "value": "..." }'
  ],
  pitfalls: [
    'Common mistake or non-obvious behavior.'
  ]
}
```

- **format**: Describes the expected value shape. Be specific about nested structures and field roles.
- **examples**: Concrete JSON snippets showing correct usage. Cover the main variants (simple, multi-value, edge cases like NULL checks).
- **pitfalls**: Things that are easy to get wrong. Include required-but-not-obvious fields, evaluation semantics, and format quirks.

### Component notes

**Directory**: `~/Projects/cloud-native/packages/workflows-engine/src/components/`

Each component is defined in its own file (e.g., `buffer.ts`, `spatialjoin.ts`). The component definition object has an optional `notes` array — short strings surfaced alongside the schema. These cover gotchas like unexpected output column names, deprecated components, or parameters whose names differ from what you'd guess.

```typescript
// Example from buffer.ts
{
  name: 'native.buffer',
  description: '...',
  starred: true,
  notes: [
    'Output geometry column is named "geom_buffer", not "buffer" or "geom".'
  ]
}
```

## How to verify changes

### Step 1: Check the local API is running

```bash
curl -s http://localhost:3030/
# Expected: {"status":"running"}
```

### Step 2: Restart the API after editing

The workflows-engine package is consumed directly from `src/` via ts-node — no build step needed. Just restart the API process:

```bash
kill $(lsof -i :3030 -t)
cd ~/Projects/cloud-native/workflows-api && yarn start:no-check &>/tmp/workflows-api.log &
```

Wait a few seconds for startup, then confirm:

```bash
curl -s http://localhost:3030/
```

### Step 3: Query the CLI to verify

For input types, request a component that uses the type you changed:

```bash
export CARTO_WORKFLOWS_API_URL=http://localhost:3030
carto workflows inputs <component-names> --connection <connection> --json
```

For component notes, fetch the component detail:

```bash
carto workflows components get <component-name> --connection <connection> --json
```

### Step 4: Start the API if it wasn't running

If the API isn't running at all:

```bash
cd ~/Projects/cloud-native/workflows-api
yarn start:no-check &>/tmp/workflows-api.log &
```

Check logs if startup fails:

```bash
tail -30 /tmp/workflows-api.log
```

## Minimum action sequence

1. Edit the relevant file in `~/Projects/cloud-native/packages/workflows-engine/src/`
2. Restart: `kill $(lsof -i :3030 -t) && cd ~/Projects/cloud-native/workflows-api && yarn start:no-check &>/tmp/workflows-api.log &`
3. Verify: `export CARTO_WORKFLOWS_API_URL=http://localhost:3030 && carto workflows inputs <component> --connection <conn> --json`

No build, no compile, no dependency install. Edit, restart, verify.
