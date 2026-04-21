---
Created: 2026-04-21T10:00:00-04:00
Source: Purple Turn 25 inline output saved by Steve at Turn 26; CD-maintained status doc going forward
Purpose: Flat view of all prep/design/implementation tasks with completion status, updated as work progresses
Update cadence: CD updates this file when a task status changes (e.g., task completed and archived to `completed/`, new task inserted into the sequence, decision pivots the flow). Updated in the same CD turn as the status-changing event.
Related docs: `docs/specs/GNX375_Prep_Implementation_Plan_V2.md` (narrative plan, stream-by-stream); `docs/tasks/CC_Task_Prompts_Status.md` (task-prompt lifecycle tracker); `docs/todos/priority_task_list.md` (cross-cutting priority ranking)
---

## Task flow plan (with current status)

### Prep phase — Stream A (AMAPI documentation) ✅ COMPLETE

| ID   | Task                                                         | Status                           |
| ---- | ------------------------------------------------------------ | -------------------------------- |
| A1   | AMAPI wiki crawler + HTML mirror + tracking DB (+ 3 bugfix cycles) | ✅ Done                           |
| A2   | Parser → 214 per-function reference docs (`docs/reference/amapi/by_function/*.md`); FE-01 deferred | ✅ Done                           |
| A3   | Use-case index (`docs/knowledge/amapi_by_use_case.md`, 18 sections) | ✅ Done (CD-authored per rescope) |
| A4   | Reference review                                             | ✅ Done (implicit via A3)         |

### Prep phase — Stream B (Instrument sample analysis) ✅ COMPLETE

| ID   | Task                                                         | Status |
| ---- | ------------------------------------------------------------ | ------ |
| B1   | Rename 45 vendor samples to safe names + manifest            | ✅ Done |
| B2   | Tier 1/2/3 subset selection (6 + 8 + 26)                     | ✅ Done |
| B3   | Pattern catalog (24 patterns) + sample appendix; ITM-02/03 discharged per D-07 | ✅ Done |
| B4   | Readiness review — 3 non-blocking coverage gaps documented   | ✅ Done |

### Prep phase — Stream C (GNX 375 functional spec) 🔶 ACTIVE

| ID                                         | Task                                                         | Status                                      |
| ------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------- |
| C1                                         | PDF extraction — 310 pages, extraction report, page-125 supplement | ✅ Done                                      |
| C2.1 (355)                                 | GNC 355 outline (1,327 lines, 18 divisions)                  | ✅ Done — SHELVED per D-12                   |
| **[D-12 pivot logged]**                    | Steve's clarification: primary is GNX 375, not GNC 355       | ✅ Done (Turns 14–17)                        |
| **[Implementation Plan V2]**               | Plan updated to reflect pivot + restructure                  | ✅ Done (Turn 17)                            |
| C2.0                                       | 355 → 375 harvest map — section-by-section [FULL]/[PART]/[355]/[NEW] categorization | ✅ Done (Turn 18)                            |
| **[Turn 19 audit]**                        | D-14: procedural fidelity items 11–25 added to harvest map   | ✅ Done                                      |
| **[Turn 20 research]**                     | D-15: GNX 375 display architecture research (`gnx375_ifr_navigation_role_research.md`); harvest items 11–25 corrected | ✅ Done                                      |
| **[Turn 21 research]**                     | D-16: XPDR + ADS-B research (`gnx375_xpdr_adsb_research.md`); §11 finalized to 14 sub-sections | ✅ Done                                      |
| **[Turn 22]**                              | C2.1-375 task prompt drafted (`docs/tasks/c2_1_375_outline_prompt.md`) | ✅ Done                                      |
| **[Turn 23/24]**                           | Prompt Unicode fix + launch to CC                            | ✅ Done (per your message: "cc has started") |
| **C2.1-375**                               | CC produces `docs/specs/GNX375_Functional_Spec_V1_outline.md` + completion report (1,477 lines, 18 divisions, piecewise+manifest recommendation) | ✅ Done (Turn 27 Phase 1 review passed) |
| C2.1-375 check-completions (Phase 1)       | CD reads prompt + completion report → generates compliance prompt | ✅ Done (Turn 27)                       |
| C2.1-375 compliance verification (Phase 2) | CC runs compliance prompt → `_compliance.md` (17 items across 8 categories) | ✅ Done (Turn 28–29; 16 PASS, 1 DISCREPANCY → ITM-07) |
| C2.1-375 compliance review + archive       | CD reviews compliance → PASS WITH NOTES; ITM-07 logged; all 4 files archived to `completed/` | ✅ Done (Turn 29)                       |
| **D-18 (format decision)**                 | CD decides C2.2 format: piecewise + manifest, 7 tasks; resolves ITM-07 inline by adopting §4 sub-section sum | ✅ Done (Turn 30; `D-18-c22-format-decision-piecewise-manifest.md`) |
| C2.2-A task prompt drafted                 | CD drafts `docs/tasks/c22_a_prompt.md` (covers §§1–3 + Appendices B, C; ~445 lines target) | ✅ Done (Turn 31)                             |
| **C2.2-A execution**                       | **CC authors `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`** | **🔵 READY TO LAUNCH**                        |
| C2.2-A check-completions + compliance      | Standard two-phase lifecycle                                 | ⚪ Pending                                   |
| C2.2-B–G task prompt drafting              | CD drafts prompts for remaining 6 sub-tasks (~1 CD turn each, interleaved with CC execution) | ⚪ Pending                                   |
| C2.2 execution                             | CC authors remaining 6 fragments sequentially (B through G) | ⚪ Pending (6 tasks remaining)                |
| C2.2 check-completions + compliance        | Standard lifecycle                                           | ⚪ Pending                                   |
| C3                                         | `/spec-review` V1 — tiered review pipeline                   | ⚪ Pending                                   |
| C3 triage                                  | CD triages review findings → gaps/opportunities → issue index | ⚪ Pending                                   |
| C4                                         | Iterate to V2, V3… until implementation-ready (zero CRITICAL/HIGH) | ⚪ Pending (1–3 cycles likely)               |

### Design phase (post-prep) ⚪ PENDING

| ID                         | Task                                                         | Status    |
| -------------------------- | ------------------------------------------------------------ | --------- |
| Abstraction-layer decision | Deferred decision keyed on Stream C complete                 | ⚪ Pending |
| D1                         | Write `GNX375_Design_Spec_V1.md` using A3 + B3 + C4 outputs  | ⚪ Pending |
| D2                         | `/spec-review` design spec iterations to implementation-ready | ⚪ Pending |

### Implementation phase ⚪ PENDING

| ID   | Task                                         | Status    |
| ---- | -------------------------------------------- | --------- |
| I1   | CC task prompts for Air Manager plugin build | ⚪ Pending |
| I2   | CC implements                                | ⚪ Pending |
| I3   | check-completions + compliance cycles        | ⚪ Pending |

### Future (deferred): GNC 355 implementation ⚪ FUTURE

Back-port 375 insights to shelved 355 outline → C2.2-355 body → design → implementation. No timeline. Timed against Steve's other project priorities.

------

### Where we are right now

**C2.2-A task prompt drafted and ready to launch (Turn 31).** Prompt at `docs/tasks/c22_a_prompt.md`. CC authors fragment A covering §§1 Overview, §2 Physical Layout & Controls, §3 Power-On/Startup, Appendix B Glossary, and Appendix C Extraction Gaps. Target: ~445 lines at `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` (new directory `docs/specs/fragments/` to be created by CC).

**Key framing commitments CC must honor** (hard constraints per the prompt):
1. TSO-C112e (not C112d) per D-16
2. GNX 375 = baseline; GPS 175 + GNC 355/355A are comparison units
3. No internal VDI (per D-15) — briefly noted in §1 scope
4. Inner knob push = Direct-to on GNX 375 (not COM standby tuning)
5. No COM radio on GNX 375 — only referenced as a sibling-unit comparison
6. Appendix B includes 15 XPDR/ADS-B-related glossary entries (enables later fragments to reference without forward-refs)
7. Disambiguation gap dropped per D-12
8. XPDR pages pp. 75–82 noted CLEAN in Appendix C

Expected CC wall-clock: 45–75 min.

**Next CD action after CC finishes:** "check completions" on `docs/tasks/c22_a_completion.md`. CD generates a compliance prompt modeled on the C2.1-375 17-item approach, scaled to fragment-level concerns (self-check re-verification + outline-to-fragment fidelity + AMAPI cross-ref validity). Then standard PASS/FAIL flow.

**After C2.2-A archives:** CD creates the manifest at `docs/specs/GNX375_Functional_Spec_V1.md` (per D-18) and drafts C2.2-B prompt. Sequential flow continues.

**Critical path:** ~18 more sequential steps (C2.2-A execution → compliance → archive → manifest → C2.2-B drafting → execution → compliance... through C2.2-G → aggregate → C3 `/spec-review` V1). Estimated 6–10 hours CC wall-clock + ~20 CD coordination turns.