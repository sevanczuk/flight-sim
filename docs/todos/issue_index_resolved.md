# Issue Index — Resolved

**Created:** 2026-04-21T06:41:13-04:00
**Source:** Purple Turn 8 — first ITM resolved (ITM-01 via ITM-01-FILE-MOVEMENT task) triggered creation of this index
**Purpose:** Master cross-reference of all closed tracked items (ITM-, G-, O-, FE-). Paired with `issue_index.md` which holds open items.
**Maintained by:** CD

**Prefix glossary:**
- **ITM-** — Item (general housekeeping, cleanup, process followup; default catchall)
- **G-** — Gap (spec review finding: missing requirement, unaddressed scenario, etc.)
- **O-** — Opportunity (spec review finding: improvement that's nice-to-have, not required)
- **FE-** — Future Enhancement (deferred work item; not blocking; revisit when prioritized)

| ID | Resolved | Resolution | Title | Resolved by |
|----|----------|------------|-------|-------------|
| ITM-01 | 2026-04-21 | Done | File movement reminder — after Streams A and B complete | ITM-01-FILE-MOVEMENT task (CC, Turn 8) |
| ITM-06 | 2026-04-21 | Done (same-turn) | Implementation plan update after D-12 pivot | Purple Turn 17 (CD inline) |
| ITM-07 | 2026-04-21 | Adopted in D-18 | GNX 375 outline: §4 length estimates inconsistent (nav-aids ~800, §4 header ~740, sub-section sum ~1,090) | Purple Turn 30 (CD — D-18 adopts sub-section sum) |
| ITM-09 | 2026-04-23 | Resolved by C2.2-D §7.9 authorship | Outline §7 lacks named §7.9 sub-section referenced by Fragment C forward-refs | Purple Turn 22 (C2.2-D compliance X23 PASS) |

---

## ITM-01: File movement reminder — after Streams A and B complete (RESOLVED)

**Created:** 2026-04-20T09:10:00-04:00
**Resolved:** 2026-04-21T06:41:13-04:00 (Purple Turn 8)
**Resolution:** Completed via the `ITM-01-FILE-MOVEMENT` CC task. 16 task files (8 task sets) moved from `docs/tasks/` to `docs/tasks/completed/` via `git mv`. The `MANUAL_gnc355_eyeball_low_confidence_pages.md` file remained in `docs/tasks/` per the original ITM-01 exclusion (Steve's active manual work list).

### Verification

- All 16 files present at destination (verified via `ls docs/tasks/completed/*.md | wc -l` returning 20: 4 pre-existing B3 quad + 16 newly moved)
- Source directory contains only 2 .md files: the MANUAL file and the ITM-01 task prompt itself (the prompt's own residence in the source dir was correctly noted in the completion report; not a deviation)
- `git diff --cached --stat` showed all 16 renames at `R100` (100% similarity, no content changes)
- Single CC commit per ITM-01 task spec; D-04 trailer format
- Compliance step skipped per D-10 (task met all five mechanical/self-verifying criteria)

### Disposition rationale

Compliance was skipped per D-10 (the decision logged this same turn). The task qualified as mechanical, self-verifying, fully reversible, and the completion report included the verification commands inline per D-08. CD's lightweight final check confirmed:
- Refresh flag listing (no new flags from this task)
- Disk state matches the completion report's claims
- No unexpected anomalies

Items not independently verified by CD: commit trailer correctness (no git access from CD) and ntfy notification send (no log access). These were trusted based on the completion report and the task prompt's explicit instructions; per D-10's audit-trail requirement, this is documented here.

### Related

- Source ITM definition: previously at `issue_index.md` §ITM-01 (now removed from open index)
- Task prompt: `docs/tasks/completed/itm_01_file_movement_prompt.md`
- Completion report: `docs/tasks/completed/itm_01_file_movement_completion.md`
- D-10 (skip-compliance criteria) — the decision authorizing the disposition

---

## ITM-06: Implementation plan update after D-12 pivot (RESOLVED same-turn)

**Created:** 2026-04-21T08:57:03-04:00 (logged in D-12 Consequences)
**Resolved:** 2026-04-21T09:11:33-04:00 (Purple Turn 17)
**Resolution:** Plan updated inline during Turn 17 rather than entering the open-issue queue. The V1 plan at `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` was marked SUPERSEDED (top-of-file banner) and a V2 plan written at `docs/specs/GNX375_Prep_Implementation_Plan_V2.md` reflecting the D-12 pivot (unit, scope, Stream C sub-structuring).

### Verification

- V1 file: banner added at top pointing to V2; original content preserved for historical reference
- V2 file: 356 lines; covers amendment summary, stream completion status (A, B, C1), Stream C sub-structuring per D-11 + D-12, updated dependency graph, updated risks + wall-clock, and revision history linking V1
- Both files in git via the Turn 17 commit

### Related

- D-12 (the pivot decision that created this ITM)
- `docs/specs/pivot_355_to_375_rationale.md` (full option analysis)
- `docs/specs/GNX375_Prep_Implementation_Plan_V2.md` (the new plan)
- `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` (historical)

---

## ITM-07: GNX 375 outline — §4 length estimates inconsistent (RESOLVED)

**Created:** 2026-04-21T13:00:00-04:00 (Purple Turn 29)
**Resolved:** 2026-04-21T13:30:00-04:00 (Purple Turn 30)
**Resolution:** Adopted by D-18. The sub-section sum (~1,090 lines) is authoritative going forward. The outline's §4 top-level estimate field (~740) and nav-aids header estimate (~800) remain unchanged in the outline file — the outline is archival and reflects state at C2.1-375 archive. D-18 is the authoritative source for §4 length and all C2.2 planning.

### Impact on C2.2

The ~350-line increase in §4 pushed total estimated spec length from ~2,860 to ~3,180 and motivated splitting C2.2 into 7 tasks instead of the completion report's original 6. Details in D-18.

### Verification

- D-18 written at `docs/decisions/D-18-c22-format-decision-piecewise-manifest.md`
- ITM-07 entry moved from `issue_index.md` to this file
- `Task_flow_plan_with_current_status.md` updated to reflect D-18 complete and C2.2-A task prompt drafting as NEXT UP

### Related

- D-18 (C2.2 format decision — adopts sub-section sum; splits C2.2 into 7 tasks)
- `docs/tasks/completed/c2_1_375_outline_compliance.md` §"Item 12" (discrepancy origin)
- Previous location: `issue_index.md` §ITM-07 (now removed from open index)

---

## ITM-09: Outline §7 lacks named §7.9 sub-section referenced by Fragment C forward-refs (RESOLVED)

**Created:** 2026-04-22T20:32:25-04:00 (Purple Turn 14 — C2.2-C compliance X19 PARTIAL)
**Resolved:** 2026-04-23T13:48:23-04:00 (Purple Turn 22 — C2.2-D compliance X23 PASS)
**Resolution:** Fragment D authored `### 7.9 XPDR + ADS-B Approach Interactions [pp. 75–82, 245–256]` as a real sub-section (Fragment D line 556). Both Fragment C forward-refs now resolve to §7.9 content:

1. Fragment C §4.7 line 226 ("interaction between WOW state, approach phase annunciation, and XPDR ALT mode behavior is documented in §7.9") → resolves to Fragment D §7.9 lines 564–570 (XPDR ALT mode during approach; WOW automatic handling; p. 78 citation; no pilot mode change required).
2. Fragment C §4.7 line 232 ("interaction detail between TSAA state and GPS flight phase annunciations is in §7.9") → resolves to Fragment D §7.9 lines 577–589 (TSAA continues during all approach phases; GNX 375-only framing; flight phase + XPDR state concurrent display correlation).

### Resolution path

Adopted **Option A** from the original ITM-09 resolution options: C2.2-D prompt included a hard constraint directing CC to author §7.9 as a real numeric sub-section (not lettered augmentation, not outline retrofit). Option A was the least-disruptive path — Fragment C's forward-refs resolve naturally on assembly; §7 grew by one sub-section.

### Verification

- **Structural:** `grep -c '^### 7\.9' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` = 1 (C2.2-D compliance F1 + N27)
- **Content coverage:** C2.2-D compliance F2 (XPDR ALT + WOW) and F4 (TSAA during approach) both PASS; X23 confirms both forward-refs semantically resolve to §7.9 content
- **Framing discipline:** §7.9 honors D-16 three-modes-only framing (Standby/On/ALT; no Ground/Test/Anonymous) per C2.2-D compliance F6
- **Cross-reference preservation:** §7.9 forward-refs to §11, §11.4, §11.11, §12.4, §4.9, §15 all present (C2.2-D compliance F7)
- **Coupling Summary:** §7.9 authorship note present at Fragment D line 907 explaining the new sub-section creation (C2.2-D compliance C26)

### Impact on spec assembly

On C2.2 assembly (after C2.2-G archive), §7 will present §§7.1–7.9 numeric (in order) followed by §§7.A–7.M lettered augmentations. Fragment C's two forward-refs in §4.7 Open Questions will resolve to the assembled §7.9 section. No dangling cross-references.

### Related

- C2.2-C compliance report (`docs/tasks/completed/c22_c_compliance.md` §X19) — original PARTIAL finding
- C2.2-D compliance report (`docs/tasks/c22_d_compliance.md` §F1, §F2, §F4, §F6, §F7, §X23, §N27, §C26) — multi-angle verification
- C2.2-D prompt (`docs/tasks/c22_d_prompt.md` hard constraint #1) — authorship directive
- D-21 (multi-fragment sequential drafting) — the discipline that surfaced ITM-09 at the right moment (during C2.2-C review, before C2.2-D drafting)
- Fragment C `docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` §4.7 open questions (lines 226, 232) — forward-refs now resolved
- Fragment D `docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` §7.9 (line 556) — resolution
- Previous location: `issue_index.md` §ITM-09 (now removed from open index)
