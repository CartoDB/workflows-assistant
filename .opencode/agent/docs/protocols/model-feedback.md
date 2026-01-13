# Protocol: Model Feedback

After completing a task (successfully or not), reflect on your experience and document any inefficiencies or missing capabilities that would have helped you perform better.

## When to Write Feedback

Write feedback when:
- You spent significant time on something that should have been simpler
- You had to work around a limitation in the tools or documentation
- You discovered missing information that caused delays
- You found yourself repeating similar patterns that could be automated
- The error messages were unclear or unhelpful
- You wish you had a tool or capability that doesn't exist

## Feedback Process

1. **Reflect** on what took longer than expected
2. **Identify** the root cause (missing tool, unclear docs, bad error message, etc.)
3. **Suggest** what would have helped
4. **Save** feedback to `./model-feedback/` (relative to the project root)

## Feedback File Format

**Filename**: `YYYY-MM-DD-short-topic.md`

**Structure**:

```markdown
# Model Feedback: [Topic]

**Date**: YYYY-MM-DD
**Task**: [Brief description of what you were trying to do]
**Time Lost**: [Estimate: minutes or "significant"]

## What Happened

[Describe the situation where you lost time or struggled]

## Root Cause

[Why did this happen? What was missing or unclear?]

## What Would Have Helped

- [Tool, feature, or improvement #1]
- [Tool, feature, or improvement #2]

## Suggested Implementation

[Optional: How could this be implemented?]

## Priority

[Low/Medium/High] - Based on how often this might occur and impact
```

## Example Feedback Topics

- "Error messages should include expected format examples"
- "Need a component search by functionality, not just name"
- "Validation should catch JSON format in comma-separated fields earlier"
- "Missing documentation for column type constraints"
- "Would benefit from a 'workflow template' generator"

## Important

- Be specific and actionable - vague feedback is not useful
- Focus on **systemic improvements**, not one-off issues
- This feedback helps improve the tools and documentation for future tasks
