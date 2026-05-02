---
Created: 2026-04-25T09:33:26-04:00
Source: Purple Turn 2 — reconstituted from briefing + 0828 checkpoint + Task_flow_plan_with_current_status.md + issue_index.md after discovering file did not exist on disk
Purpose: Combined ranking of all tasks, TODOs, and followups by criticality (per CLAUDE.md Key Data Sources)
Update cadence: CD updates this file when priorities shift — task moves up/down due to dependency change, new urgent ITM logged, or active work completes. Updated in the same CD turn as the priority shift.
**Last updated:** 2026-05-02T10:50:56-04:00 (Purple Turn 15 — ITM-11 + ITM-13 closed and removed from P3; build_page_number_map.py retired from P1; DEPENDENCY-AUDIT-01 added to P1; image-extraction approaches retired from P2)
Scope confirmation needed: This is a first-pass reconstitution. The columns and granularity may not match what the briefing/CLAUDE.md originally envisioned. Steve to validate or redirect.
Related docs: `docs/tasks/Task_flow_plan_with_current_status.md` (task-level flow); `docs/specs/Spec_Tracker.md` (spec lifecycle); `docs/tasks/CC_Task_Prompts_Status.md` (CC prompt lifecycle); `docs/todos/issue_index.md` (open issues with details).
---

# Priority Task List

Cross-cutting priority ranking of every active concern: in-flight tasks, queued tasks, open ITMs, deferred enhancements. Independent of the source-of-truth tracking in `Task_flow_plan_with_current_status.md` and `issue_index.md` — those are exhaustive; this file is opinionated about what to do next.

Priority bands: **P0** (active blocker) · **P1** (next session) · **P2** (this week) · **P3** (when convenient) · **P4** (deferred / waiting).

---

## P0 — Active

(no active blockers — V1 spec body assembly complete)

---

## P1 — Next session

| Item | Type | Status | Notes |
|------|------|--------|-------|
| `scripts/verify_gnx375_manifest.py` authoring | Code | ⚪ Pending | Per D-22 §6 manifest pre-flight |
| Review Priority Guide prepend | Doc | ⚪ Pending | Per D-22 §5 — P1/P2/P3 table prepended to V1 aggregate |
| 3 domain-specific Sonnet agents | Doc | ⚪ Pending | `.claude/agents/spec-pdf-source-fidelity-reviewer.md`, `spec-cross-fragment-coupling-reviewer.md`, `spec-sibling-unit-consistency-reviewer.md`; per D-22 §2 |
| DEPENDENCY-AUDIT-01 | Task | 🔶 Drafting | Inventory references to retired paths across the repo. CD-direct prompt drafting at Purple Turn 15; CC-executable. |

---

## P2 — This week (pre-C3 review prep)

| Item | Type | Status | Notes |
|------|------|--------|-------|
| C3 spec review V1 (quick tier) | Review | ⚪ Pending | Per D-22 customizations; quick → standard `-s C` → full as needed. Gated on P1 items above. |

**Retired from P2** (formerly listed):
- Image extraction Approach A — retired alongside the GNC 355 PDF → GNX 375 PyMuPDF pivot. Re-add fresh if image extraction is revived.
- Image extraction Approach B — cache window expired 2026-04-26; retired alongside Approach A.

---

## P3 — Open ITMs (process / cleanup)

| ID | Title | Severity | Notes |
|----|-------|----------|-------|
| **ITM-14** | `assemble_gnx375_spec.py` `--partial` continuity-skip not implemented | Low | Opened Turn 14, 2026-04-30. Defer until partial-assembly workflow is needed. |
| **ITM-10** | Fragment C §4.10 vs PDF p. 94 watchpoint | Low | Carry to C3 review |
| ITM-08 | Fragment C Coupling Summary glossary over-claim | Low | Resolved by D's authoring discipline; tracking residual |
| ITM-04 | CC task prompt template: add verify-completion-claims step | Low | CD-direct; small enough for inline edit |
| ITM-05 | Compliance Verification Guide: reference D-10 skip criteria | Low | CD-direct |
| ITM-02 | AMAPI patterns: add Tier 2 columns to function_usage_matrix | Low | Batchable with ITM-03; `_crp_work/` scratch artifact |
| ITM-03 | AMAPI patterns: plain-text → markdown link for `hw_dial_add` | Low | Batchable with ITM-02 |

**Recently closed** (moved to `issue_index_resolved.md`):
- **ITM-11** — Page-number offset between archived fragment citations and new extraction. Closed Purple Turn 14 (2026-05-02); 13/13 V1 citations verified to resolve directly to physical pages with zero offset. Convention captured in D-30.
- **ITM-13** — CC commit subject contains UTF-8 BOM. Closed Purple Turn 11 (2026-05-02) by D-29 (file-based commit pattern dropped; BOM failure mode unreachable).

---

## P4 — Deferred / waiting

| Item | Type | Trigger to advance |
|------|------|---------------------|
| Supplemental AFM (190-02207-a3) extraction + reconciliation | V2 amendment work | After GNX 375 V1 implementation-ready |
| AFMS V2 changebar patch | Spec amendment | After AFMS reconciliation |
| GNC 355 Functional Spec resumption | Secondary deliverable | After GNX 375 V1 implementation-ready (per D-12) |
| FE-01 — AMAPI parser: preserve `<a>` links inside Arguments-table cells | Future enhancement | Reprioritize when AMAPI parser revisited |

---

## Pending decisions (from 0828 checkpoint)

- AFMS V2 amendment scope: when to schedule the Supplemental AFM extraction + reconciliation task (recommendation: post-V1 closure)

---

## Open questions (from 0828 checkpoint)

- Will C2.2-G fragment hit 300-line target or run over like prior fragments? (Pattern is 13–82% over.)
- Will V2 spec amendment for AFMS need its own review cycle or can it be a small changebar patch?
