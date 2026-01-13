# CLI: workflows to-sql

Generates executable SQL from a workflow JSON file.

## Usage

```bash
carto workflows to-sql workflow.json --temp-location "project.dataset"
carto workflows to-sql workflow.json --dry-run
```

## Gotchas

### Does NOT support --connection flag

Unlike `validate`, the `to-sql` command does not connect to the database. Only use `--temp-location`.

```bash
# Wrong - --connection is ignored
carto workflows to-sql workflow.json --connection my-bigquery

# Correct
carto workflows to-sql workflow.json --temp-location "project.dataset"
```
