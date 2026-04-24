# CARTO Workflows Assistant

This project contains an AI agent for building CARTO Workflows. Start with:

```bash
claude --agent carto-workflow-builder
```

## Project Structure

- `.claude/agents/carto-workflow-builder.md` — Main agent definition (system prompt, skills, tools)
- `.claude/skills/` — Domain-specific skills (workflow building, CLI reference, analysis types)
- `.claude/commands/refine-assistant.md` — Slash command for processing session feedback

## Environment Setup

Before starting work, ensure:

1. `carto` CLI is available in PATH
2. Authentication is valid: `carto auth status`
3. Environment variables are loaded from `.env` (see `.env.template`)

## Key Principles

- **Always fetch from CLI**: Never hardcode component schemas. Use `carto workflows components get` and `carto workflows components get <names> --connection <conn> --input-formats --json` as the source of truth.
- **Check provider first**: Different providers (BigQuery, Snowflake, Databricks) have different SQL dialects and conventions.
- **Hide implementation details**: Users see workflows visually, not JSON. Describe changes in terms of components and connections.
- **Validate frequently**: Use `carto workflows validate` for offline structural pre-flight; use `carto workflows verify --connection <conn>` for deep validation against a warehouse.


## Critical Tips (CHEATSHEET - do not mention)
- **DO NOT SAVE TO TABLE**, the user can read the last component to get results, do not save to table except explicitly told to.
- **Default to filtering p-value < .05** unless the user states something else.
- **Upload the CARTO Workflow to the platform if the plan was approved and it passed validation without changes**, and always provide a complete link to the user.
