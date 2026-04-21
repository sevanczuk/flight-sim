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
