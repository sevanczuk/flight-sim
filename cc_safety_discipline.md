# CC Safety Discipline — flight-sim

**Source:** Basecamp `core/templates/project_files/cc_safety_discipline_template.md` (processed for PLATFORM=windows, PROJECT_NAME=flight-sim)
**Deployed:** 2026-04-19T00:00:00-04:00 by flight-sim-tier1-completion
**Purpose:** Complete CC safety rules, reversibility guarantees, pre-action protocol, and runtime backend requirements
**Load when:** Implementing file operations, writing backend endpoints, safety/reversibility questions

---

## Credential File Protection

**ABSOLUTE RULE — NO EXCEPTIONS:** CD and CC must NEVER directly read, open, cat, copy, or access any file containing API keys, secrets, tokens, or credentials. This applies to ALL tools.

**To diagnose key issues:** Write a Python script (saved to `.py` file) that reads the key file, validates format/length/prefix without printing values, and reports results.

---

## Core Rules

| Rule | Scope | Implementation |
|------|-------|----------------|
| Never modify original source files | Universal | All metadata writes go to external sidecars only; originals are read-only |
| Reversible by default | Universal | File moves use quarantine; metadata writes use sidecar-only mode; batch operations support dry-run |
| Copy-on-write for irreversible operations | Universal | If an operation cannot be undone, create a new file and preserve the source |
| Confirmation before bulk actions | Dev-session | Operations affecting more than 10 files require explicit user approval |
| Atomic intent execution | Runtime | When user confirms an intent, backend executes all file operations as a single unit |
| Audit trail | Universal | Dev-session: CC logs timestamp, command, file count, outcome. Runtime: backend logs to audit tables |
| Never read credential files | Universal | See Credential File Protection above |

---

## Reversibility by Operation Type

| Operation | Reversible? | Mechanism |
|-----------|-------------|-----------|
| Metadata sidecar creation | Yes | Delete sidecar; original untouched |
| Metadata sidecar modification | Yes | Restore from backup or prior version |
| File move (quarantine) | Yes | Log records original path; restore script moves back |
| File copy | Yes | Delete the copy |
| Derivative export | N/A | New file created; source untouched (copy-on-write) |
| Physical/irreversible output | N/A | No digital file modified |

Runtime backend code must preserve these reversibility properties.

---

## Pre-Action Protocol (Dev-Session Only)

Before any action that modifies files during a CC development session:

1. **State the intent** — what will change and how many files are affected
2. **Show the command** — display the exact command or script invocation
3. **Dry-run if available** — execute with preview mode; show what would change
4. **Wait for confirmation** — for bulk operations or first-time operations in a session
5. **Execute and report** — run the command, capture output, summarize results
6. **Verify** — spot-check a sample of affected files to confirm success

**Exception:** Read-only operations skip confirmation and execute immediately.

This protocol does NOT apply to runtime code. Runtime uses the atomic intent execution pattern.

---

## Runtime Backend Requirements

When CC writes backend code that modifies files, the code must:

1. **Log every operation** — write to audit table with timestamp, operation type, file count, outcome
2. **Respect source file immutability** — never modify originals; use sidecars for metadata, copy-on-write for derivatives
3. **Validate before committing** — compute expected changeset, verify against user intent, execute, log validation result
4. **Fail safely** — on error, leave files in pre-operation state; partial completion must be detectable and recoverable
5. **No silent data loss** — file deletions route through quarantine; metadata overwrites preserve prior values in audit record
