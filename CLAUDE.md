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

- **Always fetch from CLI**: Never hardcode component schemas. Use `carto workflows components get` and `carto workflows inputs` as the source of truth.
- **Check provider first**: Different providers (BigQuery, Snowflake, Databricks) have different SQL dialects and conventions.
- **Hide implementation details**: Users see workflows visually, not JSON. Describe changes in terms of components and connections.
- **Validate frequently**: Use `carto workflows validate --connection <conn>` after every change.
