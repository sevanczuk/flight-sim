# D-07: Compliance triage rubric — `_crp_work/` failures discharge as followup, published-deliverable failures trigger bug-fix task

**Created:** 2026-04-20T18:41:01-04:00
**Source:** Purple Turn 3 — AMAPI-PATTERNS-01 compliance triage; first PASS-WITH-NOTES case where a FAIL landed on a scratch-directory artifact rather than a published deliverable
**Decision type:** convention / process refinement

## Decision

When a CC compliance report returns FAIL on individual checks, CD's triage decision (move to `completed/` with followup vs. create bug-fix task) depends on **where the failing artifact lives**:

| Artifact location | Triage when FAIL |
|---|---|
| `_crp_work/` (scratch / CRP intermediate work) | Discharge as followup ITM in `docs/todos/issue_index.md`; archive task files to `completed/`; do NOT create bug-fix task |
| `docs/` (published deliverables — knowledge, specs, reference, decisions, etc.) | Create bug-fix task; do NOT move to `completed/` until fix verified |
| `src/`, `tests/`, `config/`, `scripts/` (code) | Create bug-fix task; do NOT move to `completed/` until fix verified |
| `assets/` (sources / source-of-truth assets) | Create bug-fix task; do NOT move to `completed/` until fix verified |
| Completion-report meta-issues (e.g., omitted ntfy mention, inaccurate self-reported metrics) | Discharge as followup if action already happened in practice; address root cause via decision-log entry tightening process |

The rationale is asymmetric cost-benefit: scratch artifacts in `_crp_work/` are designed to be throwaway (per the original CRP spec, CD cleans them up after compliance verification anyway). Rebuilding a scratch artifact to satisfy a process audit costs more than its residual value. Published deliverables, by contrast, ARE the value the task produced — defects there warrant correction.

## Context

AMAPI-PATTERNS-01 compliance returned 2 FAILs:

1. **V3 — `function_usage_matrix.md` missing Tier 2 columns.** Phase C step 3 of the prompt explicitly required updating the matrix with Tier 2 sample columns. CC didn't do this. Matrix lives in `_crp_work/amapi_patterns_01/`. The patterns themselves (in `docs/knowledge/amapi_patterns.md`) correctly cite Tier 2 sample counts and exemplars — i.e., the matrix's purpose was to support pattern extraction, which succeeded.

2. **VII4 — ntfy notification not documented in completion report.** Notification was almost certainly sent in practice (Steve received it and knew to assess); the completion report's "Deviations: None" line was inaccurate. This is a documentation/process accuracy issue, not an execution defect.

Without this rubric, both items would gate `completed/` archival until a bug-fix task ran. That overcorrects: V3 fixes a throwaway artifact, and VII4 has nothing real to fix (the action already happened). Triaging both as followup ITMs preserves the audit trail without blocking ITM-01 / C2 critical path.

## Consequences

- CD applies this triage rubric on every future check-compliance Phase 2 review
- `_crp_work/` failures still get logged as ITMs so they're tracked, not silently dropped
- The bar for "FAIL → bug-fix task" is now explicit: published deliverable defect, code defect, or asset defect — not process miss on scratch artifacts
- Future CC task prompts targeting `_crp_work/` artifacts can carry lower review priority on those specific artifacts (e.g., "matrix is reference-only; pattern catalog is the deliverable")
- Edge case: if a `_crp_work/` failure indicates the underlying analysis is wrong (e.g., a raw_notes file missing a sample → patterns derived from incomplete data), that escalates back to bug-fix territory because it implicates a published deliverable's correctness. Judge by downstream impact, not literal location.

## Related

- D-05 (assess shorthand → check-completions / check-compliance / check-validation protocol triggers)
- D-08 (companion decision: completion-report claim verification)
- AMAPI-PATTERNS-01 compliance report (`docs/tasks/completed/amapi_patterns_compliance.md`)
- ITM-02, ITM-03 (the followups created from this triage)
