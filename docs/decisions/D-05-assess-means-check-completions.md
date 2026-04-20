# D-05: "Assess" + review-artifact file = trigger the appropriate review protocol

**Created:** 2026-04-20T08:59:24-04:00  
**Amended:** 2026-04-20T09:10:00-04:00 (Purple Turn 37 — extended scope to compliance + validation docs)  
**Source:** Purple Turns 36–37 — Steve clarified that his "assess" request in Turn 17 (and similar) was shorthand for triggering the appropriate review protocol based on the referenced filename  
**Decision type:** convention / process refinement

## Decision

When the user says "assess" (or similar review verbs — "review," "look at," etc.) and references a review-artifact file, CD treats this as the trigger for the protocol that corresponds to the file type. No need for the literal trigger phrase.

| Filename pattern | Triggered protocol |
|---|---|
| `*_completion.md` | **check completions** (two-phase: CD reads + generates compliance prompt → CC runs compliance → CD reviews) |
| `*_compliance.md` | **check compliance** (CD reviews CC's compliance report; PASS: move files to `completed/`; FAIL: bug-fix task) |
| `*_validation.md` | **check validation** (CD reviews CC's validation report; same PASS/FAIL disposition as compliance) |
| `*_review.md` (spec review findings) | **spec review triage** (CD reads findings; triages each gap/opportunity with Accept/Defer/Reject; decides on next spec version) |

Conversely, the literal trigger phrases ("check completions," "check compliance," "check validation") without a specific file reference mean: process ALL unprocessed files of that type (discover via filesystem scan).

## Context

In Turn 17, Steve said "assess `docs/tasks/amapi_crawler_completion.md`" and CD responded with a partial assessment without running the full two-phase check-completions protocol. This produced a useful technical review but skipped protocol steps (generating a compliance prompt; producing a structured PASS/FAIL/PARTIAL verdict; deciding on file movement to `completed/`). Turn 28 corrected this when Steve said "check completions" — but the bugfix task chain had already diverged from the protocol.

Turn 37 extended the scope: Steve noted that the same shorthand pattern applies to compliance and validation artifacts as well. The common thread is "filename identifies the protocol; assess is the trigger."

## Consequences

- CD recognizes "assess" + review-artifact file as protocol trigger based on filename
- If ambiguity arises (could be technical review OR a formal protocol), CD asks
- Phase 1 of check-completions always produces the compliance prompt unless Steve explicitly declines it
- Phase 2 (check compliance) triggered via the literal "check compliance" OR by "assess" of a `*_compliance.md` file
- Spec-review triage triggered via "assess" of a `*_review.md` file

## Related

- D-04 (commit trailer policy — adjacent workflow refinement)
- `claude-conventions.md` §Check Completions Protocol
- Memory slot #13 (check completions protocol)
