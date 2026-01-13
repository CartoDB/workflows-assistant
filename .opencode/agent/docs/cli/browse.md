# CLI: connections browse

Browse tables and datasets in a connection.

## Usage

```bash
carto connections browse <connection> "<project.dataset>"
carto connections browse <connection> "<project.dataset>" | head -n 20
```

## Gotchas

### --page-size flag doesn't work

The `--page-size` flag exists but is ignored. Use `| head -n N` to limit output, or query `INFORMATION_SCHEMA.TABLES` for more control.
