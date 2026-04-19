# Compliance Verification Guide

## Purpose

This guide governs how CD (Claude Desktop) creates compliance verification prompts for CC (Claude Code) after reviewing task completions. It captures lessons learned and standard verification categories to ensure thorough, consistent code-level checks.

## When to Use

After every "check completions" review. CD reviews the prompt and completion report, then immediately generates a compliance prompt using this guide and the template at the bottom.

## Protocol Overview

| Step | Actor | Trigger | Output |
|------|-------|---------|--------|
| 1 | CD | "check completions" | Reviews prompt vs completion; creates `{name}_compliance_prompt.md` |
| 2 | Steve | Launches prompt in CC | CC produces `{name}_compliance.md` |
| 3 | CD | "check compliance" | Reviews compliance report; PASS → move all to `completed/`; FAIL → create bug-fix task |

Files moved to `completed/` on PASS: `{name}_prompt.md`, `{name}_completion.md`, `{name}_compliance_prompt.md`, `{name}_compliance.md`.

## Guidelines for Creating Compliance Prompts

### Start from the completion review

Read the prompt and completion report first. Note:
- Claims that seem too good (e.g., "all endpoints emit SSE" — verify each one)
- Features mentioned in the prompt but not addressed in the completion report
- Regression fixes claimed — these need independent verification
- Anything CD cannot efficiently verify due to file size or MCP limitations

### Think in categories, not just line items

Don't just list things to grep for. Think about what *kind* of verification each task needs. The standard categories below cover the most common patterns. Select the relevant ones, delete the rest, and add task-specific items.

### Include negative checks

For every thing the task adds, consider what it replaces or retires. Verify the old thing is actually gone — not just that the new thing exists. Stale references to retired code, config files, or patterns are a common class of bug that completion reports never mention.

### Include cross-file consistency checks

Many tasks modify the same concept in multiple files (e.g., DDL in a migration AND in a startup function, or a route in a blueprint AND its registration in the app). These must match. Don't trust that one file is correct just because another is.

### Include behavioral checks, not just structural ones

"Does the route exist?" is structural. "Does the route silently ignore optional fields when a linked profile provides defaults?" is behavioral. Both matter. Behavioral checks are harder to write but catch more bugs.

### Ask CC to produce the full route/function inventory first

Before checking individual items, have CC run a broad inventory command (e.g., `grep -n '@blueprint.route'`). This often reveals missing or unexpected items that the checklist wouldn't catch.

### Lessons learned

These are specific pitfalls discovered during the PAPER-PROFILE-IMPL compliance check that should inform future prompts:

1. **SSE notification coverage** — Completion reports often claim "SSE on all mutations" but miss one or two. Always ask CC to enumerate every emit_notification call and cross-reference against the mutation endpoint list.

2. **SQLite ATTACH scope** — When a task uses ATTACH DATABASE, verify that ALL DDL/DML inside the ATTACH block uses the `main.` schema prefix. SQLite silently resolves unqualified table names to the attached schema, which causes data to be written to the wrong database.

3. **Migration version gates** — Check not just "< target version" but also "requires prerequisite version." Chained migrations that skip prerequisites will silently corrupt data.

4. **Fresh-install vs upgrade parity** — When a migration modifies a table's schema, the startup DDL (`CREATE TABLE IF NOT EXISTS`) must produce the same schema as the migration path. Otherwise fresh installs and upgrades diverge.

5. **Retired code references** — When a task retires a config file or function, grep for ALL references to it across the codebase, not just in the files the task claims to have modified.

---

## Standard Checklist Categories

Select and customize the categories below based on what the task actually changed. Delete irrelevant categories. Add task-specific items under each category.

### S. Schema / Migration
*Include when the task adds or modifies database schema.*

- Migration function exists and is called from the correct startup chain
- Version gate checks prevent re-running and enforce prerequisite versions
- Version bump occurs at the end of successful migration
- All new columns/tables match the spec DDL exactly
- Fresh-install DDL matches migration DDL (cross-file parity)
- Graceful handling of missing dependencies (e.g., external DBs)
- Idempotency: running the migration twice is safe

### E. Endpoints / API
*Include when the task adds or modifies API routes.*

- Run `grep -n '@{blueprint}.route' {file}` to get the full route inventory
- For each endpoint: verify route path, HTTP method, and key behaviors
- Confirm all new routes are registered (blueprint imported and registered in app)
- SSE: every mutation endpoint (POST, PUT, PATCH, DELETE) emits a notification — enumerate all emit_notification calls and cross-reference
- Validation: required field checks, enum validation, error codes per spec
- Auth: soft_admin_gate or equivalent applied where spec requires
- ETag/If-Match handling where spec requires optimistic concurrency

### L. Logic / Behavioral
*Include when the task has non-trivial business logic.*

- Task-specific logic checks derived from the spec (e.g., "Linked profiles silently ignore override fields on PUT")
- Edge cases and error paths (e.g., "ATTACH transaction uses main. prefix on ALL references")
- Conditional behavior (e.g., "override_field required unless linked_profile_id provided")

### N. Negative Checks
*Include when the task retires, removes, or replaces something.*

- Retired code/config is no longer imported or referenced by any production code
- Removed function bodies are no-ops (not deleted — prevents import errors from other files)
- No stale references to old patterns (grep for removed function names, old config keys, retired file paths)

### R. Regression Fixes
*Include when the completion report mentions regressions fixed.*

- Each regression fix mentioned in the completion report: confirm the test file was actually modified
- Old assertions updated to match new behavior (not just deleted)

### T. Test Coverage
*Always include.*

- List each new test file with count of `def test_` functions
- Total new test count matches completion report claim
- Schema parity tests exist if the task introduces migration + startup DDL

### A. Auxiliary / Config
*Include when the task modifies config, .gitignore, or helper utilities.*

- Config file changes present and correct
- .gitignore additions present
- Helper functions exist with correct signatures

---

## Compliance Prompt Template

Copy the template below and customize it for each task. Replace all `{placeholders}`.

```markdown
# CC Task Prompt: {TASK-ID} Compliance Verification

**Task ID:** {TASK-ID}-COMPLIANCE
**Verifying:** {TASK-ID} (completed {date})
**Prompt:** `docs/tasks/completed/{name}_prompt.md`
**Completion:** `docs/tasks/completed/{name}_completion.md`
**Spec:** `docs/specs/{spec_name}.md` (if applicable)

---

## Instructions

This is a **read-only verification task**. Do NOT modify any source files. Verify that the {TASK-ID} implementation matches the original prompt and spec by gathering concrete evidence from the source code.

Read `CLAUDE.md` for project conventions.

For each checklist item below, report:
- **PASS** — with the evidence (file, line number, relevant snippet)
- **FAIL** — with what was expected vs. what was found
- **PARTIAL** — with explanation of what's present and what's missing

Use `grep -n` liberally. Quote the specific lines that prove compliance.

---

## Checklist

{Customized checklist items organized by category — see Standard Checklist Categories in the Compliance Verification Guide}

---

## Output

Write the compliance report to `docs/tasks/{name}_compliance.md` with this structure:

# {TASK-ID} Compliance Report

**Verified:** [timestamp]
**Verdict:** [ALL PASS / PASS WITH NOTES / FAILURES FOUND]

## Summary
- Total checks: [N]
- Passed: [N]
- Failed: [N]
- Partial: [N]

## Results

### {Category}
{ID}. [PASS/FAIL/PARTIAL] — [evidence]
...

## Notes

[Any observations, minor deviations, or recommendations that don't rise
to FAIL level but are worth documenting.]

---

## Completion Protocol

1. Write compliance report to `docs/tasks/{name}_compliance.md`
2. `git add -A`
3. `git commit -m "{TASK-ID}-COMPLIANCE: verification report for {task description}"`
4. Send completion notification: `Invoke-RestMethod -Uri "https://ntfy.sh/{channel}" -Method Post -Body "{TASK-ID}-COMPLIANCE completed"`

**Do NOT git push.**
```
