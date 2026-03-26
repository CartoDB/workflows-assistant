---
name: build-carto-workflow
description: How to write, validate, and upload CARTO Workflows
---

# Building CARTO Workflows

This skill contains everything needed to build CARTO workflows:
- [6-Phase Development Process](#development-process)
- [JSON Structure Reference](#json-structure)
- [Troubleshooting](troubleshooting/) - Validation errors, execution issues, common gotchas

Component schemas, input type formats, and gotchas are served by the CLI — **never hardcode or assume them**.

---

## Development Process

**Follow these 6 phases in order for every workflow request.** Do not skip or reorder phases.

### Phase 1: Gather Information

**Goal**: Understand what the user wants and collect all necessary inputs.

1. **Identify data sources**:
   - If user provides table names - note them
   - If not - load `find-tables` skill to discover tables

2. **Clarify the goal**: What transformation? What output? What filters/conditions?

3. **Determine connection**:
   ```bash
   carto connections list | head -n 20
   ```

4. **Fetch component catalog**:
   ```bash
   carto workflows components list --connection <connection> --json
   ```
   This is your ONLY source of truth for component names.

### Phase 2: Design the Approach

**Goal**: Gather component details and prepare a plan.

1. **Select components** from the catalog you fetched

2. **Fetch schemas for ALL components you plan to use**:
   ```bash
   carto workflows components get <name1>,<name2>,<name3> --connection <connection> --json
   ```
   The response includes `inputs`, `outputs`, and `notes`. The `notes` array contains gotchas — read them carefully.

3. **Fetch input type formats** for the components you selected:
   ```bash
   carto workflows inputs <name1>,<name2>,<name3> --connection <connection> --json
   ```
   The response includes `format`, `examples`, and `pitfalls` for each input type used by those components. This is your reference for how to set parameter values.

4. **Design principles**:
   - Preserve identifier and spatial columns throughout
   - Prefer high-level components over `native.customsql`
   - H3/Quadbin columns work for visualization without geometry extraction
   - Use standard names for visualization: `geom`, `h3`, `quadbin`

### Phase 3: Present Plan and Confirm

**Goal**: Get user agreement before building.

1. Present workflow plan (components, data flow, decisions)
2. Prompt for clarification on any ambiguities
3. **Wait for confirmation** before proceeding

### Phase 4: Build the Workflow

**Goal**: Implement iteratively, validating frequently.

1. **Create workflow file** with basic structure (see [JSON Structure](#json-structure))

2. **Build in phases**, validating after each:
   ```bash
   carto workflows validate workflow.json --connection <connection-name> --json
   ```
   The `--connection` flag auto-configures all needed settings (tempLocation, AT, etc.).

3. **Fix errors silently** - don't expose implementation details to user

4. **Iterate** until complete and validated

### Phase 5: Present Result

1. Summarize what was built
2. Confirm validation success
3. Wait for user confirmation

### Phase 6: Upload to CARTO

1. Ask if user wants to upload
2. Upload and provide URL:
   ```bash
   carto workflows create --file workflow.json --connection <connection-name>
   ```
3. Do NOT auto-execute unless explicitly requested

---

## JSON Structure

### Top-Level Structure

```json
{
  "schemaVersion": "1.0.0",
  "title": "Workflow Title",
  "description": "What this workflow does",
  "connectionProvider": "bigquery",
  "nodes": [],
  "edges": [],
  "variables": []
}
```

| Field | Required | Description |
|-------|----------|-------------|
| `schemaVersion` | Yes | Always `"1.0.0"` |
| `title` | Yes | Display name |
| `connectionProvider` | Yes | `bigquery`, `snowflake`, `redshift`, `postgres`, `databricks`, `oracle` |
| `nodes` | Yes | Array of workflow components |
| `edges` | Yes | Array of connections between nodes |

### Node Structure

```json
{
  "id": "unique-node-id",
  "type": "generic",
  "data": {
    "name": "native.componentname",
    "version": "2",
    "label": "Display Label",
    "inputs": [
      { "name": "source", "type": "Table", "value": "" }
    ],
    "outputs": [
      { "name": "out", "type": "Table" }
    ]
  },
  "position": { "x": 100, "y": 100 }
}
```

- `id`: Unique identifier (use descriptive names)
- `type`: Always `"generic"`
- `data.name`: Component name from catalog
- `data.version`: Include if not "1"
- `position`: Layout coordinates (left-to-right, ~200px spacing)

### Edge Structure

```json
{
  "id": "edge-source-to-target",
  "source": "source-node-id",
  "target": "target-node-id",
  "sourceHandle": "out",
  "targetHandle": "source"
}
```

Handle names must match component schema exactly.

### Variables

```json
{
  "variables": [
    { "id": "var-1", "name": "distance_meters", "type": "Number", "defaultValue": "1000" }
  ]
}
```

Reference with `{{variable_name}}` syntax.

---

## Fetching Component & Input Information

**Do not rely on memorized component schemas or input formats.** Always fetch live data from the CLI.

| Command | Purpose |
|---------|---------|
| `carto workflows components list --connection <conn> --json` | List all available components |
| `carto workflows components get <names> --connection <conn> --json` | Get component schemas with inputs, outputs, and `notes` (gotchas) |
| `carto workflows inputs <names> --connection <conn> --json` | Get input type `format`, `examples`, and `pitfalls` for the types used by those components |

### What to look for in the response

- **Component `notes`**: Array of gotcha strings — non-obvious behavior, deprecated status, output column naming, etc.
- **Input `format`**: Prose describing the expected value shape and structure
- **Input `examples`**: Concrete JSON snippets showing correct usage
- **Input `pitfalls`**: Common mistakes — required-but-not-obvious fields, evaluation order, format quirks

---

## Troubleshooting

When things go wrong, see the [troubleshooting/](troubleshooting/) folder:

| Issue Type | Guide |
|------------|-------|
| Validation fails | [validation.md](troubleshooting/validation.md) - Error patterns and fixes |
| Execution fails | [execution.md](troubleshooting/execution.md) - Runtime errors, debugging |
| Unexpected behavior | [gotchas.md](troubleshooting/gotchas.md) - CLI and design quirks |

### Quick Fixes

| Error Pattern | Fix |
|---------------|-----|
| "column not found" | Check exact name with `carto connections describe` |
| "table not found" | Verify FQN: `project.dataset.table` |
| "connection failed" | Run `carto auth status`, then `carto auth login` |
| Empty results (0 rows) | Filters too restrictive; check join keys; verify case sensitivity |
| Validation passes but execution fails | Use `--connection` for full schema validation |

---

## Examples

| Example | Description |
|---------|-------------|
| [Filter and Count](examples/example-filter-count.md) | Read table, filter rows, count results |
| [Bike Accidents Near Parkings](examples/example-bike-accidents.md) | Buffer, spatial join, aggregation |

---

## Session Completion

When workflow is complete, load `session-wrapup` skill to document the session.
