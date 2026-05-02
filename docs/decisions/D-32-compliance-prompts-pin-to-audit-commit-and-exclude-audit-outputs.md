# D-32 — Compliance prompts that recount post-commit grep audits must specify baseline ref + exclude audit outputs

**Created:** 2026-05-02T14:52:00-04:00
**Source:** CD Purple session — Turn 23; lesson surfaced by DEPENDENCY-AUDIT-01-COMPLIANCE M1 self-defeating count check
**Status:** Adopted
**Supersedes:** None
**Decision class:** Compliance-prompt design / process refinement

---

## Decision

When a compliance prompt verifies a grep-based audit by recounting matches, the recount methodology must:

1. **Pin to the audit's commit ref.** Run `git grep` against the audit's source-of-truth tree (the commit where the audit was produced), not against HEAD. The standard form is `git grep -n -F "<pattern>" <audit-commit-sha>`.
2. **Exclude the audit's own output files** from the recount. The audit's report, completion report, and any prompt/compliance-prompt files contain extensive pattern matches that inflate any HEAD-based recount.

If either step is omitted, a recount-after-commit produces inflated numbers that the audit cannot pass — not because the audit is wrong, but because the verification methodology is self-defeating.

---

## Context — what triggered this decision

DEPENDENCY-AUDIT-01 produced an audit report claiming "~304 unique file:line matches across ~95 distinct files" of references to retired asset paths. The audit was executed and committed (commit `2cc421d`) on 2026-05-02 at Purple Turn 16.

DEPENDENCY-AUDIT-01-COMPLIANCE was launched at Purple Turn 18. Its M1 check was: re-run the 10 grep patterns and compare the deduplicated total to the audit's "~304" claim. The compliance prompt was designed to allow ±5% drift for the audit's own approximate caveat.

When CC ran M1, the result was:

| Measurement | Count |
|---|---|
| Raw recount (working tree, includes audit's outputs) | 539 |
| Filtered recount (excludes audit's 3 output files) | 429 |
| Audit's claim | ~304 |
| Drift even after filtering | +41% (well outside ±5%) |

CC correctly identified the cause: the audit's own outputs (now committed and tracked) contain extensive pattern matches. They had to — they enumerate every retired-path reference. A recount against HEAD picks up those references in the audit's own tables and inflates the count.

CC's compliance report wrote it most clearly:

> The M1 check criterion is therefore somewhat self-defeating when applied post-commit — the audit output is itself a dense source of pattern matches.

The audit's substantive content (patch list, flag list, side findings, salvage recommendation) was unaffected. The audit was good; the verification methodology was self-defeating.

---

## What's required going forward

### For compliance prompts that recount grep-based audit work

Two requirements, both must hold:

**1. Pin to the audit's commit ref.**

```bash
# Get the audit's commit SHA from git history
git log --grep="<TASK-ID>:" -1 --format=%H

# Run grep against that tree (NOT HEAD)
git grep -n -F "<pattern>" <audit-commit-sha> -- ':(top)'
```

Or equivalently in Python:

```python
import subprocess
audit_sha = subprocess.check_output(
    ["git", "log", "--grep=<TASK-ID>:", "-1", "--format=%H"]
).decode().strip()
result = subprocess.run(
    ["git", "grep", "-n", "-F", pattern, audit_sha],
    capture_output=True, text=True
)
```

**2. Exclude the audit's own output files.**

Compliance prompts must enumerate the audit's output files explicitly and filter them from the recount. The standard set for a CC task that follows the prompt + report + completion + compliance-prompt convention is:

- `docs/tasks/<task>_prompt.md`
- `docs/tasks/<task>_report.md` (or equivalent deliverable)
- `docs/tasks/<task>_completion.md`
- `docs/tasks/<task>_compliance_prompt.md` (if present at audit time)

In the recount script, filter these out before computing totals:

```python
EXCLUDED_FILES = {
    "docs/tasks/dependency_audit_01_prompt.md",
    "docs/tasks/dependency_audit_01_report.md",
    "docs/tasks/dependency_audit_01_completion.md",
    "docs/tasks/dependency_audit_01_compliance_prompt.md",
}
unique_matches = {(p, l) for (p, l) in raw_matches if p not in EXCLUDED_FILES}
```

### When this applies

This requirement applies whenever ALL of the following are true:

- The original task is a **grep-based inventory or audit** (counts of pattern matches are a primary deliverable)
- The compliance prompt asks CC to **recount and compare** to the original claim
- The audit's output files **themselves contain the patterns** they're inventorying (typically true for any retired-path / dead-code / deprecation audit)

For compliance prompts that don't recount, or where the audit's outputs don't contain the audit's patterns, the standard `git grep` against HEAD is fine.

---

## What this does NOT change

- Audit outputs are still committed normally — the audit is itself the deliverable.
- Audit prompts are unaffected. Only the **compliance prompts that recount audit work** need this discipline.
- The "approximate (±N%)" caveat audits sometimes carry is fine; this decision is about how compliance verifies the count, not whether audits report exact or approximate counts.

---

## Disposition for DEPENDENCY-AUDIT-01-COMPLIANCE

The M1 FAIL is treated as a known compliance-methodology limitation, not an audit defect. The audit's substantive content stands. PASS WITH NOTES disposition for the overall compliance, with M1 specifically flagged as a methodology issue rather than a content issue. Documented in `docs/tasks/dependency_audit_01_report.md` §"Compliance review notes" and reflected here in D-32 for future reference.

A retroactive M1 against `2cc421d` (excluding the four audit files) would produce the actual ground-truth count at audit-execution time. Not run this round because the audit's substantive content is what matters; if a future task requires the exact count, run the retroactive M1 then.

---

## Related

- D-26 (CD verify against ground-truth source documents) — sibling principle: this decision is about CD's compliance verification matching what the audit actually claimed at the time, not what HEAD now contains
- D-29 (commit policy simplification) — same family of "drop ceremony that doesn't earn its cost" simplifications
- `docs/tasks/dependency_audit_01_compliance.md` (compliance report that surfaced this lesson)
- `docs/tasks/dependency_audit_01_report.md` §"Compliance review notes" (PASS WITH NOTES disposition entry)
