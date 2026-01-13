# Example: Bike Accidents Near Parkings

A complete walkthrough of building a workflow to find how many bike accidents happened near bike parkings.

## User Request

"I want to find how many bike accidents happened near bike parkings"

## Workflow Steps

### 1. Clarify requirements

Ask: "What distance defines 'near'? And which connection has your data?"

User responds: "100 meters, connection is `my-bigquery`"

### 2. Find and explore the data

If the user doesn't know the exact table names, **delegate to the `carto-table-finder` agent** to discover relevant tables.

Once tables are identified, confirm schemas:

```bash
carto connections describe my-bigquery "project.dataset.bike_accidents"
carto connections describe my-bigquery "project.dataset.bike_parkings"
```

Confirm both tables have geometry columns.

### 3. Explore buffer component

Always use `--json` for full schema:

```bash
carto workflows components get native.buffer --provider bigquery --json
```

### 4. Create workflow JSON

Create a workflow.json file with the basic structure:

```json
{
  "schemaVersion": "1.0.0",
  "title": "Accidents Near Parkings",
  "connectionProvider": "bigquery",
  "nodes": [],
  "edges": [],
  "variables": []
}
```

### 5. Add nodes iteratively, validating after each

Add source nodes, buffer, spatial join, count.

**Always prefer high-level components** - only use SQL if no component exists for the operation.

After each change, validate:

```bash
carto workflows validate workflow.json \
  --connection my-bigquery \
  --temp-location "project.dataset" \
  --json
```

### 6. Generate and review SQL

```bash
carto workflows to-sql workflow.json \
  --temp-location "project.dataset"
```

### 7. Execute locally or upload

Execute:
```bash
cat workflow.sql | carto sql job my-bigquery
```

Or upload:
```bash
carto workflows create --file workflow.json
```

### 8. Verify results and show to user

```bash
# Check the result table has data
carto sql query my-bigquery "SELECT COUNT(*) as total FROM \`<result-table>\`"

# Show sample results to the user
carto sql query my-bigquery "SELECT * FROM \`<result-table>\` LIMIT 10"
```

Confirm the results match expectations before finishing.

## Key Principle

After adding each node, always validate. After execution, always verify results and show them to the user.
