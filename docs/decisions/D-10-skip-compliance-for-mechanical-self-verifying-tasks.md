# D-10: Compliance step can be skipped for mechanical, self-verifying CC tasks

**Created:** 2026-04-21T06:41:13-04:00
**Source:** Purple Turn 8 — ITM-01-FILE-MOVEMENT completion review surfaced that the formal compliance protocol adds no value for a class of tasks that are mechanical and self-verifying
**Decision type:** convention / process refinement
**Amends/supplements:** D-05 (assess shorthand triggers compliance protocol), D-07 (compliance triage rubric), D-08 (completion-report claim verification)

## Decision

CD may skip the formal compliance step (Phase 2 of check-completions: drafting a compliance prompt for CC, having CC execute it, reviewing the compliance report) for CC tasks that meet ALL of the following criteria:

1. **Mechanical** — the task consists of file moves, file deletions, or other operations that are byte-for-byte deterministic. No content authoring, no judgment-driven decisions, no synthesis.
2. **Self-verifying** — the operation's success can be verified by directory listings, diff stats, or other commands whose output the completion report quotes inline per D-08.
3. **Fully reversible** — the operation can be undone trivially (e.g., `git mv` is reversible by another `git mv`; `git commit` is reversible by `git revert`).
4. **Completion report meets D-08** — verification commands and their outputs are quoted inline; no claims rely on un-quoted estimates.
5. **No code or content changes to other deliverables** — the task did not touch `src/`, `tests/`, `scripts/`, `assets/`, or any non-task `docs/` content beyond what the operation explicitly affects.

When all five criteria are met, CD reads the completion report, performs any verifications it can do directly (refresh flag listing, file existence checks, etc.), and archives directly to `docs/tasks/completed/`. CD documents the skipped-compliance decision in the archive turn's response.

When ANY criterion fails, the standard two-phase compliance protocol applies as documented in D-05 and `docs/templates/Compliance_Verification_Guide.md`.

## What this means in practice

| Task pattern | Compliance step? |
|---|---|
| File-movement batches (e.g., ITM-01) | **Skip** — mechanical, self-verifying, reversible |
| Bulk renames | **Skip** if filename mapping is trivially auditable |
| Deletion of confirmed-stale files | **Skip** if the deletion list was reviewed by CD pre-task |
| Refresh flag cleanup | **Skip** — file existence is self-verifying |
| Code generation (specs → tests, scaffolding) | **Run** — content correctness requires verification |
| Spec authoring (drafts, reviews) | **Run** — substantive content requires verification |
| Bug fixes | **Run** — behavioral verification needed |
| Crawler/parser/extractor runs | **Run** — output quality requires verification |
| Pattern catalogs, knowledge docs | **Run** — synthesis requires verification |
| Schema migrations | **Run** — irreversibility risk requires verification |

The bar for "mechanical and self-verifying" is high. When in doubt, run compliance. Skipping is the exception, not the default.

## What CD still does on skipped-compliance tasks

CD does NOT just rubber-stamp. CD performs a lightweight final check:

1. Read the completion report end-to-end
2. Spot-check the inline verification command outputs against current disk state via Filesystem MCP (e.g., directory listings, file existence)
3. Verify any items NOT covered in the completion report that CD can verify directly (refresh flag listing is the canonical example)
4. List explicitly in the response which items could NOT be verified from CD (e.g., commit trailer correctness, ntfy notification send) — this preserves the audit trail of what was trusted-without-verification
5. Make the archive disposition decision

If the lightweight final check surfaces ANYTHING unexpected — even a minor anomaly — CD escalates to the full compliance protocol. The threshold for escalation is low.

## Context

ITM-01-FILE-MOVEMENT (Turn 7 task, executed in Turn 8) was a 16-file `git mv` batch. The completion report included:

- 5 pre-flight checks with PASS/FAIL results
- Phase A summary: `git status --short` confirmed 16 R-prefixed lines
- Phase B verification: source count (`wc -l`), source listing (`ls`), destination count (`wc -l`), destination sorted listing (`ls | sort`), and `git diff --cached --stat` showing all 16 renames at 100% similarity
- Final state metrics
- Explicit "Deviations: None"

A formal compliance CC session would have run the same `ls` / `wc` / `git diff` commands and produced the same outputs. The compliance step would have spent ~10 minutes (CC startup + execution + report writing) and ~5 minutes (CD Phase 2 review) to confirm what the completion report already showed.

D-08 already mandates that completion reports include inline verification commands for numerical and existence claims. When a task's correctness is fully expressible as such claims, the completion report IS the compliance report. Spinning up a separate CC session to re-run the same commands is process theater.

## Trade-offs (considered and accepted)

**Risk:** A skipped compliance step could miss a subtle issue (e.g., commit trailer typo, missing ntfy send, file content drift CC didn't notice).

**Mitigation:**
- The skip is restricted to mechanical, self-verifying, fully reversible tasks. Reversibility means subtle issues can be corrected without bug-fix tasks.
- CD's lightweight final check covers what's verifiable from the CD-side (refresh flags, directory state).
- Items CD cannot verify (commit trailers, ntfy) are EXPLICITLY noted in the archive response, not silently trusted. This preserves audit trail.
- Per D-07, even if a missed issue is later discovered, mechanical-task issues are likely to discharge as ITM followups, not bug-fix tasks.

**Risk:** Slippery slope — what counts as "mechanical and self-verifying" could expand over time.

**Mitigation:**
- The five criteria are explicit and conjunctive (ALL must be met).
- The "What CD still does" section requires explicit acknowledgment of unverified items.
- The escalation threshold is "anything unexpected." This is intentionally low.
- Future CD sessions can revisit the criteria via amendment if the line proves blurry.

## Implementation note

Update `docs/templates/Compliance_Verification_Guide.md` (or the `claude-conventions.md` §Check Completions Protocol section) to reference D-10 as the skip-criteria source. This is captured as ITM-05 (followup).

## Related

- D-04 (commit trailer policy — items CD cannot verify on skipped compliance)
- D-05 (assess shorthand → check-completions / check-compliance triggers)
- D-07 (compliance triage rubric — what to do when compliance finds FAILs)
- D-08 (completion-report claim verification — the precondition that makes self-verifying completion reports possible)
- ITM-01-FILE-MOVEMENT (the case study; first task to use this skip pattern)
- ITM-05 (followup: update compliance verification guide to reference D-10)
