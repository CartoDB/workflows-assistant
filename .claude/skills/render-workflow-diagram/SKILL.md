---
name: render-workflow-diagram
description: Renders a CARTO Workflow JSON as a Unicode box-art DAG diagram in the terminal
---

# Render Workflow Diagram

Display a CARTO Workflow as a Unicode DAG diagram directly in the terminal. Useful for:
- Showing the user what was built after constructing a workflow
- Helping understand an existing workflow's structure
- Verifying the data flow between components

## Setup

Run once to install the dependency (`@hpcc-js/wasm-graphviz`):

```bash
bash .claude/skills/render-workflow-diagram/setup.sh
```

## Usage

Render any workflow JSON file:

```bash
node .claude/skills/render-workflow-diagram/render-workflow.mjs <workflow.json>
```

Or pipe from stdin:

```bash
cat workflow.json | node .claude/skills/render-workflow-diagram/render-workflow.mjs
```

## When to Use

- **After building a workflow**: Show the user a diagram of what was constructed
- **When loading an existing workflow**: Display the structure before making changes
- **When explaining a workflow**: Pair the diagram with a description of each component

## Displaying to the User

The script outputs plain text to stdout. Since the Bash tool result is not visible to the user,
you **must** copy the output and present it inside a fenced code block in your response:

````markdown
```
<paste the script output here>
```
````

This preserves the Unicode box-drawing alignment in the terminal.

## How It Works

1. Parses the workflow JSON (nodes, edges)
2. Converts to Graphviz DOT format (note nodes are excluded — only data-flow components)
3. Uses `@hpcc-js/wasm-graphviz` to compute a Sugiyama/layered layout via the `dot` engine
4. Maps layout positions to a character grid and renders Unicode box-drawing art
5. Prints to stdout

## Example Output

```
  Commercial Hotspot Analysis
  ───────────────────────────

  ┌──────────────────┐     ┌──────────────────┐
  │    Read Table     │     │    Read Table     │
  │   (readtable)     │     │   (readtable)     │
  └────────┬─────────┘     └────────┬─────────┘
           │                        │
           ▼                        ▼
  ┌──────────────────┐     ┌──────────────────┐
  │  Spatial Filter   │────▶│     Enrich       │
  │ (spatialfilter)   │     │    (enrich)      │
  └────────┬─────────┘     └────────┬─────────┘
           │                        │
           ▼                        ▼
        ┌──────────────────────────────┐
        │           Group By           │
        │          (groupby)           │
        └──────────────────────────────┘
```

## Limitations

- Edge routing is Manhattan-style (orthogonal lines), not curved splines
- Very large workflows (30+ nodes) may produce wide output — consider terminal width
- Port-level connections (sourceHandle/targetHandle) are not shown individually; edges connect node-to-node
