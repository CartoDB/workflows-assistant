# Protocol: Bug Report

When you encounter an **unexpected error or bug** in the workflows-engine (not user errors like wrong input format), follow this protocol.

## When to Create a Bug Report

**Create a bug report when:**
- The workflows-engine throws an unexpected exception
- Validation produces incorrect or misleading results
- Generated SQL is malformed or incorrect
- The CLI crashes or hangs unexpectedly
- Behavior contradicts documented functionality

**Do NOT create a bug report for:**
- User input errors (wrong format, missing parameters)
- Authentication issues (`carto auth login` to fix)
- Network/connectivity problems
- Expected validation errors (the engine is correctly rejecting invalid input)

## Bug Report Process

1. **Stop execution immediately** - Do not attempt to work around or fix the bug

2. **Call the `bug-report` agent** with the following information:
   - The exact error message
   - The command that was executed
   - What you expected to happen
   - What actually happened
   - Any relevant file paths (workflow.json, etc.)

3. **Report to the user** after the bug report is created:
   - Tell the user a bug has been identified
   - Provide the path to the bug report file
   - Explain that you cannot proceed due to this bug
   - Suggest they can review the bug report for details

## Example Response

```
I encountered an unexpected error in the workflows-engine.

I've created a bug report at: bug-reports/2025-01-15-groupby-schema-error.md

This appears to be a bug in the engine's schema computation. I cannot proceed with
the current workflow until this is resolved. Please review the bug report for 
reproduction steps and technical details.
```

## Important

- **Do NOT attempt to fix bugs** - Your role is to document them, not fix them
- **Do NOT work around bugs** - This masks issues and leads to unreliable workflows
- The bug-report agent will gather all materials needed for later debugging
- Bug reports are saved in `./bug-reports/` (relative to the project root)
