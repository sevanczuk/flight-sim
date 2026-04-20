# D-08: CC completion reports must verify factual claims against current file state before submission

**Created:** 2026-04-20T18:41:01-04:00
**Source:** Purple Turn 3 — AMAPI-PATTERNS-01 completion report contained two materially inaccurate claims that the compliance scan caught
**Decision type:** convention / process refinement

## Decision

CC task prompt template's completion protocol must require: **before writing the completion report, CC verifies each numerical, structural, and existence claim against the actual current file state.** The completion report is a final-state attestation, not a running estimate.

Specifically:

- **Numerical claims** (file counts, link counts, pattern counts, line counts, byte counts): re-derive from a grep / wc / ls command run at completion-report-writing time, not estimated mid-flight
- **Existence claims** about cross-referenced files ("X exists" / "X is missing"): verify with `ls` or equivalent; do not infer from earlier-phase notes
- **"Deviations: None"** statements: cross-check the completion-report body against every numbered step in the prompt's Completion Protocol section. If any step (e.g., ntfy notification, refresh-flag check, git commit format) lacks an explicit confirmation in the report, it must either be confirmed inline or listed as a deviation

CD's check-completions Phase 1 cross-reference is a backstop, not a substitute. CC's completion report should be self-consistent and self-verified before reaching CD.

## Context

AMAPI-PATTERNS-01 completion report contained:

1. **Cross-link count claim "~85"** — actual count via `grep -oE '\.\./reference/amapi/by_function/[^)]+\.md' | wc -l` is 72. Discrepancy of ~15%. The "~" approximation prefix doesn't fully cover this. Likely an in-progress estimate that wasn't refreshed before the report was written.

2. **`Hw_dial_add.md` missing claim** — completion report's deviations section stated this file should be flagged as missing from the AMAPI reference docs. Compliance check confirmed `docs/reference/amapi/by_function/Hw_dial_add.md` exists (2007 bytes, present before the task ran). The catalog defensively used plain-text `` `hw_dial_add` `` instead of a markdown link based on a belief that turned out to be wrong.

3. **"Deviations: None" line** — coexisted with the Hw_dial_add gap statement (so really one deviation was self-noted). Also missed: ntfy notification step from the Completion Protocol was not confirmed in the report. The report didn't explicitly state "notification sent" anywhere.

These aren't analytical errors — the patterns themselves are correct, the cross-links resolve, the work is sound. They're attestation errors: claims in the report drift from the artifact's actual state because the report was written from in-progress notes rather than from a fresh end-state check.

## Consequences

- CC task prompt template's Completion Protocol section gets a new step before "Write completion report": **"Verify the report's numerical and existence claims against current file state via grep / ls / wc commands. Quote the commands and their output in the report."**
- Future completion reports include verification commands inline (e.g., `$ grep -c '^### Pattern' ... → 24` shown in the report itself)
- CD's Phase 1 review still performs cross-reference but can give claims more weight if they include verification command output
- This does not relax the compliance check — independent re-verification by CC in Phase 2 still happens. The two layers reinforce: CC self-attests with commands, then CD asks CC to re-verify under a different hat (compliance role).
- For CRP-tagged tasks specifically: numerical claims captured in `_phase_X_complete.md` markers MUST also be re-verified at the completion-report stage (don't trust phase-marker numbers verbatim — they're often estimates from when that phase ran, before later phases added more)

## Implementation note

The CC task prompt template at `docs/templates/CC_Task_Prompt_Template.md` should be updated to add this requirement to its Completion Protocol section. CD captures this as a separate followup so the change is visible in the project's task history rather than a silent template edit. → see ITM-04.

## Related

- D-07 (companion decision: how to triage compliance findings; addresses what to do AFTER CC's claims diverge from reality)
- D-05 (assess shorthand triggers the check-completions protocol where these claim drift issues surface)
- AMAPI-PATTERNS-01 completion + compliance reports (`docs/tasks/completed/amapi_patterns_completion.md`, `docs/tasks/completed/amapi_patterns_compliance.md`)
- ITM-04 (template update followup)
