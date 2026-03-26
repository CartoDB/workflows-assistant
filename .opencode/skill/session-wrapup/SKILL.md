---
name: session-wrapup
description: How to gather everything for future learnings
---

# Session Wrap-up

Load this skill when:
- The user confirms a workflow is complete
- You cannot proceed further (blocked by bugs, missing capabilities)
- The user explicitly asks to wrap up

This skill covers three types of documentation:
1. [Session Reports](#session-reports) - General session summary
2. [Bug Reports](#bug-reports) - Engine bugs encountered
3. [Improvement Feedback](#improvement-feedback) - Tool/process improvements

---

## Session Reports

**Location**: `./session-reports/YYYY-MM-DD-brief-topic.md`

Create after every session to document what happened.

### Template

```markdown
# Session Report: <Brief Description>

**Date**: YYYY-MM-DD
**Workflow**: <workflow filename or "N/A">
**Outcome**: Completed | Partially Completed | Blocked

## Errors Encountered

| Error | Cause | Resolution |
|-------|-------|------------|
| <error message> | <why it happened> | <how fixed or "unresolved"> |

## Limitations & Workarounds

| Limitation | Workaround | Ideal Solution |
|------------|------------|----------------|
| <what was missing> | <how you worked around it> | <what would be better> |

## New Learnings

| Learning | Source | Should Document? |
|----------|--------|------------------|
| <what you learned> | <how discovered> | Yes/No |

## Improvement Suggestions

- Documentation: <missing/unclear docs>
- Components: <useful new components>
- CLI: <missing features, better errors>
- Agent: <process refinements>
```

---

## Bug Reports

**Location**: `./bug-reports/YYYY-MM-DD-brief-description.md`

Create when you encounter **unexpected engine errors** (not user errors).

### When to Create

**Create a bug report when:**
- Workflows-engine throws unexpected exception
- Validation produces incorrect results
- Generated SQL is malformed
- CLI crashes or hangs unexpectedly
- Behavior contradicts documentation

**Do NOT create for:**
- User input errors (wrong format, missing params)
- Authentication issues (`carto auth login` to fix)
- Network/connectivity problems
- Expected validation errors (engine correctly rejecting invalid input)

### Template

```markdown
# Bug Report: [Brief Description]

## Summary
[One paragraph describing the issue]

## Reproduction Steps
1. [Step 1]
2. [Step 2]

## Expected Behavior
[What should have happened]

## Actual Behavior
[What actually happened, including error messages]

## Environment
- Connection: [name]
- Provider: [bigquery/snowflake/etc]
- CLI version: [output of `carto --version`]

## Attachments
- workflow.json: [path or inline]
```

### Important

- **Stop execution** when you hit a bug
- **Do NOT work around bugs** - document them
- **Tell the user** about the bug and provide the report path

---

## Improvement Feedback

**Location**: `./model-feedback/YYYY-MM-DD-short-topic.md`

Create when you encounter inefficiencies that could be improved.

### When to Create

- Spent significant time on something that should be simpler
- Had to work around tool/documentation limitations
- Discovered missing information that caused delays
- Found repeating patterns that could be automated
- Error messages were unclear or unhelpful

### Template

```markdown
# Feedback: [Topic]

**Date**: YYYY-MM-DD
**Task**: [What you were trying to do]
**Time Lost**: [Estimate]

## What Happened
[Describe the struggle]

## Root Cause
[Why - missing tool, unclear docs, bad error message, etc.]

## What Would Have Helped
- [Improvement #1]
- [Improvement #2]

## Priority
[Low/Medium/High]
```

---

## After Creating Documentation

1. Tell the user the report location
2. Briefly summarize key findings
3. Ask if they want to review or add anything
