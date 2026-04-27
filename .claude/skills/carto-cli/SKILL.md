---
name: carto-cli
description: How to use the CARTO CLI to interact with the platform
---

# CARTO CLI Reference

The `carto` CLI is the command-line interface for the CARTO platform. This skill provides quick reference and links to detailed documentation for each command group.

**Version**: 0.5.0

## Quick Reference

| Task | Command |
|------|---------|
| Check auth | `carto auth status` |
| Login | `carto auth login` |
| List connections | `carto connections list` |
| Describe table | `carto connections describe <conn> "<fqn>"` |
| Run query | `carto sql query <conn> "<sql>"` |
| Execute DDL/DML | `carto sql job <conn> "<sql>"` |
| Validate workflow (offline) | `carto workflows validate file.json --json` |
| Validate workflow (deep, warehouse-aware) | `carto workflows verify file.json --connection <conn> --json` |
| Generate SQL | `carto workflows to-sql file.json --connection <conn>` |
| List components | `carto workflows components list --connection <conn> --json` |
| Get component schema | `carto workflows components get <names> --connection <conn> --json` |
| Get input type formats | `carto workflows components get <names> --connection <conn> --input-formats --json` |
| Upload workflow | `carto workflows create --file file.json --verify` |
| List workflows | `carto workflows list --json` |
| Update workflow | `carto workflows update <id> --file file.json` |
| Delete workflow | `carto workflows delete <id>` |
| Import file | `carto imports create --file <path> --connection <conn> --destination "<fqn>"` |

## Command Groups

| Group | Description | Details |
|-------|-------------|---------|
| [auth](auth.md) | Authentication and profiles | Login, logout, status, profile switching |
| [connections](connections.md) | Data connections | List, browse, describe tables |
| [sql](sql.md) | SQL execution | Query and job commands |
| [workflows](workflows.md) | Workflow operations | Validate, to-sql, components, schedules |
| [imports](imports.md) | Data import | Upload files to tables |
| [install](install.md) | Installation | Build CLI from source |

## Global Options

These flags work with all commands:

| Flag | Description |
|------|-------------|
| `--json` | Output in JSON format (recommended for parsing) |
| `--debug` | Show request details (method, URL, headers) |
| `--yes`, `-y` | Skip confirmation prompts (for automation) |
| `--profile <name>` | Use specific profile (default: "default") |
| `--token <token>` | Override API token |
| `--base-url <url>` | Override base API URL |

**Environment Variables**:
- `CARTO_API_TOKEN` - API token for authentication
- `CARTO_PROFILE` - Profile to use (overrides current_profile)

## Common Gotchas

| Issue | Cause | Solution |
|-------|-------|----------|
| `workflows validate` misses column errors | `validate` is offline/Zod-only — use `workflows verify --connection <conn>` for warehouse-aware checks |  |
| `workflows components list` fails | Missing connection | Add `--connection <name>` |
| `connections browse --page-size` ignored | Known limitation | Use `head -n N` or query INFORMATION_SCHEMA |
| Table path not found | Unquoted path | Quote paths with dots: `"project.dataset.table"` |
| Token expired | Session timeout | Run `carto auth login` |
| Delete command hangs | Waiting for confirmation | Type "delete" or use `--yes` flag |

## Before Any Operation

Always verify authentication first:

```bash
carto auth status
```

If not authenticated or token expired, run `carto auth login` (opens browser).
