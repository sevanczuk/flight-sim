---
Created: 2026-04-21T10:00:00-04:00
Source: Purple Turn 25 inline output saved by Steve at Turn 26; CD-maintained status doc going forward
Purpose: Flat view of all prep/design/implementation tasks with completion status, updated as work progresses
Update cadence: CD updates this file when a task status changes (e.g., task completed and archived to `completed/`, new task inserted into the sequence, decision pivots the flow). Updated in the same CD turn as the status-changing event.
Related docs: `docs/specs/GNX375_Prep_Implementation_Plan_V2.md` (narrative plan, stream-by-stream); `docs/tasks/CC_Task_Prompts_Status.md` (task-prompt lifecycle tracker); `docs/todos/priority_task_list.md` (cross-cutting priority ranking)

Primary target: GNX 375 (per D-12). The GNC 355 is a planned secondary deliverable, deferred until after GNX 375 completes (see "Future (deferred)" section at the end).
---

## Task flow plan (with current status)

### Prep phase — Stream A (AMAPI documentation) ✅ COMPLETE

| ID   | Task                                                         | Status                           |
| ---- | ------------------------------------------------------------ | -------------------------------- |
| A1   | AMAPI wiki crawler + HTML mirror + tracking DB (+ 3 bugfix cycles) | ✅ Done                           |
| A2   | Parser → 214 per-function reference docs (`docs/reference/amapi/by_function/*.md`); FE-01 deferred | ✅ Done                           |
| A3   | Use-case index (`docs/knowledge/amapi_by_use_case.md`, 18 sections) | ✅ Done (CD-authored per rescope) |
| A4   | Reference review                                             | ✅ Done (implicit via A3)         |

Streams A and B are unit-agnostic and serve both GNX 375 and the future GNC 355 deliverable.

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
| **[Turn 23/24]**                           | Prompt Unicode fix + launch to CC                            | ✅ Done                                      |
| **C2.1-375**                               | CC produces `docs/specs/GNX375_Functional_Spec_V1_outline.md` + completion report (1,477 lines, 18 divisions, piecewise+manifest recommendation) | ✅ Done (Turn 27 Phase 1 review passed) |
| C2.1-375 check-completions (Phase 1)       | CD reads prompt + completion report → generates compliance prompt | ✅ Done (Turn 27)                       |
| C2.1-375 compliance verification (Phase 2) | CC runs compliance prompt → `_compliance.md` (17 items across 8 categories) | ✅ Done (Turn 28–29; 16 PASS, 1 DISCREPANCY → ITM-07) |
| C2.1-375 compliance review + archive       | CD reviews compliance → PASS WITH NOTES; ITM-07 logged; all 4 files archived to `completed/` | ✅ Done (Turn 29)                       |
| **D-18 (format decision)**                 | CD decides C2.2 format: piecewise + manifest, 7 tasks; resolves ITM-07 inline by adopting §4 sub-section sum | ✅ Done (Turn 30; `D-18-c22-format-decision-piecewise-manifest.md`) |
| C2.2-A (full lifecycle)                    | Prompt drafted → executed (545 lines) → Phase 1 + Phase 2 compliance (17/17 PASS or CONFIRMED) → archived; manifest created | ✅ Done (Turns 31–35)                  |
| **D-19 (line-count ratio)**                | CD logs fragment prompt line-count expansion ratio (~1.35× outline sum); per-fragment targets (B=720, C=575, D=750, E=455, F=540, G=300) | ✅ Done (Turn 35; `D-19-fragment-prompt-line-count-expansion-ratio.md`) |
| C2.2-B (full lifecycle)                    | Prompt drafted → executed (799 lines) → Phase 1 + Phase 2 compliance (**ALL PASS 23/23**; S13 outline-vs-PDF note) → archived; manifest updated | ✅ Done (Turns 1–7 post-resumption 2026-04-22) |
| **D-20 (LLM-calibrated duration estimates)** | CD logs lesson: CC task duration estimates should use LLM-calibrated baselines (docs-only ~800-line fragment = 10–25 min); includes adjustment factors (×0.7 reuse, ×2 first-of-pattern) | ✅ Done (Turn 4, 2026-04-22; `D-20-cc-task-duration-estimates-llm-calibrated.md`) |
| **D-21 (sequential drafting discipline)**  | CD logs principle: multi-fragment task prompts drafted only after predecessor archive; extends D-18's sequential execution to drafting | ✅ Done (Turn 11, 2026-04-22T17:19 ET; `D-21-multi-fragment-sequential-drafting-discipline.md`) |
| C2.2-C (full lifecycle)                    | Prompt drafted → executed (725 lines; +26% structural overage classified) → Phase 1 + Phase 2 compliance (**PASS WITH NOTES 22/25 PASS, 3/25 PARTIAL, 0 FAIL**) → archived; manifest + Task flow plan updated. S13-pattern confirmed (LNAV/VNAV + MAPR added beyond outline, PDF-confirmed). ITM-08 + ITM-09 logged. | ✅ Done (Turns 8–14 post-resumption 2026-04-22) |
| **[ITM-08 logged]**                        | Fragment C Coupling Summary over-claims 4 glossary terms absent from Fragment A Appendix B. No-action observation (Coupling Summary stripped on assembly). Watchpoint: repeat-check for C2.2-D/E/F/G Coupling Summaries. | ✅ Logged (Turn 14; `docs/todos/issue_index.md` §ITM-08) |
| **[ITM-09 logged]**                        | Outline §7 lacks §7.9 heading referenced by Fragment C forward-refs (XPDR-interaction during approach + TSAA during approach). Recommended resolution: C2.2-D authors §7.9 sub-section. | ✅ Logged (Turn 14; `docs/todos/issue_index.md` §ITM-09) |
| **C2.2-D task prompt drafting**            | CD drafts `docs/tasks/c22_d_prompt.md` (covers §§5–7 — FPL editing, Direct-to operation, Procedures operational workflows; ~750 lines target per D-19 — largest upcoming fragment; must author §7.9 per ITM-09; must include Coupling Summary grep-verify per ITM-08 watchpoint) | 🔶 **NEXT UP** (gate unlocked per D-21) |
| C2.2-D through C2.2-G                      | Remaining 4 fragments + check-completions + compliance cycles (targets per D-19: D=750, E=455, F=540, G=300); drafted sequentially one-at-a-time per D-21 | ⚪ Pending                                   |
| Aggregate spec                             | Assembly script (`scripts/assemble_gnx375_spec.py`) + single-file aggregate; CD authors at C2.2-G archive per D-18 | ⚪ Pending                                   |
| C3                                         | `/spec-review` V1 — tiered review pipeline                   | ⚪ Pending                                   |
| C3 triage                                  | CD triages review findings → gaps/opportunities → issue index | ⚪ Pending                                   |
| C4                                         | Iterate to V2, V3… until implementation-ready (zero CRITICAL/HIGH) | ⚪ Pending (1–3 cycles likely)               |

### GNX 375 Design phase (post-Stream C) ⚪ PENDING

**Target unit: GNX 375.** Follows directly from the C4 implementation-ready GNX 375 functional spec.

| ID                         | Task                                                         | Status    |
| -------------------------- | ------------------------------------------------------------ | --------- |
| Abstraction-layer decision | Deferred decision keyed on Stream C complete                 | ⚪ Pending |
| D1                         | Write `GNX375_Design_Spec_V1.md` using A3 + B3 + C4 outputs  | ⚪ Pending |
| D2                         | `/spec-review` design spec iterations to implementation-ready | ⚪ Pending |

### GNX 375 Implementation phase (post-Design) ⚪ PENDING

**Target unit: GNX 375.** Builds the Air Manager plugin for the GNX 375 touchscreen GPS/MFD + Mode S transponder + built-in dual-link ADS-B In/Out. Follows from the implementation-ready GNX 375 design spec.

| ID   | Task                                                      | Status    |
| ---- | --------------------------------------------------------- | --------- |
| I1   | CC task prompts for GNX 375 Air Manager plugin build      | ⚪ Pending |
| I2   | CC implements GNX 375 plugin                              | ⚪ Pending |
| I3   | check-completions + compliance cycles (GNX 375 plugin)    | ⚪ Pending |

### Future (deferred): GNC 355 workstream ⚪ FUTURE

**Target unit: GNC 355.** Separate, parallel workstream keyed on the shelved 355 outline at `docs/specs/GNC355_Functional_Spec_V1_outline.md`. Deferred per D-12 until after GNX 375 completes; **not abandoned**. No timeline; resumption timed against Steve's other project priorities.

When 355 resumes, a separate plan (or a Stream D extension to the V2 implementation plan) will be drafted. The rough sequence will mirror the 375 workstream:

1. **Back-port insights** — CD walks the GNX 375 outline + spec looking for patterns/clarifications that should update the shelved 355 outline.
2. **C2.2-355 body authoring** — CC authors the GNC 355 functional spec body using the same piecewise-or-monolithic format analysis the 375 went through.
3. **GNC 355 design spec** (`GNC355_Design_Spec_V1.md`) — analogous to D1/D2 above but for the 355.
4. **GNC 355 implementation** — CC builds the Air Manager plugin for the GNC 355 GPS/MFD + VHF COM radio.

The 355 workstream's design + implementation phases are independent of (and downstream of) the 375's phases.

------

### Where we are right now

**C2.2-C fully archived (Turn 14, 2026-04-22).** Fragment C at 725 lines (target 575, +26% overage classified as structural — all PDF-sourced tables, D-18 Coupling Summary template, multi-item open-question blocks; no invented content). Compliance: PASS WITH NOTES (22/25 PASS, 3/25 PARTIAL, 0 FAIL). All 4 files moved to `docs/tasks/completed/`: `c22_c_prompt.md`, `c22_c_completion.md`, `c22_c_compliance_prompt.md`, `c22_c_compliance.md`. Manifest updated; Fragment C → ✅ Archived (575 / 725).

**Notable compliance outcomes:**
1. **S13-pattern confirmed again.** Fragment C's GPS Flight Phase Annunciations table added LNAV/VNAV and MAPR beyond the outline's 9-item list; both confirmed on PDF pp. 184–185. Fragment is more PDF-accurate than outline — intended pattern. Continue trusting PDF over outline when in conflict.
2. **ITM-08 logged:** Fragment C Coupling Summary over-claims 4 glossary terms (TSO-C151c, EPU, HFOM/VFOM, HDOP) as Appendix B entries; grep-confirmed absent from Appendix B. Coordination metadata only (stripped on assembly); zero functional impact. Watchpoint for C2.2-D/E/F/G Coupling Summaries.
3. **ITM-09 logged (Medium severity):** Outline §7 lacks a §7.9 heading, but Fragment C forward-refs §7.9 twice (XPDR-interaction during approach + TSAA behavior during approach). Must be resolved in C2.2-D: Fragment D should author a §7.9 sub-section. Content is real; only numbering needs to exist.

**Next CD action: draft C2.2-D task prompt.** D-21 gate unlocked (predecessor archived). Scope: §§5–7 (Flight Plan Editing + Direct-to Operation + Procedures operational workflows). Target: ~750 lines per D-19 — largest upcoming fragment, right at the 700-line soft ceiling. Two new constraints must flow into the prompt:
- **ITM-09 resolution:** hard constraint that §7 must include a §7.9 sub-section (XPDR-interaction during approach) covering XPDR ALT mode + TSAA behavior during approach flight phases + WOW state interaction.
- **ITM-08 watchpoint:** self-review step requiring Coupling Summary backward-refs to Appendix B be grep-verified against Fragment A.
- **Coupling Summary budget correction:** allocate ~60 lines (not ~15) in the section-budget table, matching actual observed Coupling Summary template size across Fragments B and C.

**Critical path:** ~10 more sequential CD steps to C3 kick-off (one step closer since last status):
- C2.2-D full lifecycle (gated)
- C2.2-E full lifecycle (gated)
- C2.2-F full lifecycle (gated; most-coupled fragment per watchpoint 2)
- C2.2-G full lifecycle (gated)
- Assembly script + aggregate spec
- C3 `/spec-review` V1

**Watchpoints carried forward:**
1. C2.2-D is the largest upcoming fragment (~750 lines, right at the 700-line soft ceiling per D-19); monitor during drafting. May need to split if content expansion suggests >800 lines realistic.
2. C2.2-F is most-coupled (§11 XPDR + §§12–13 Audio/Alerts/Messages); densest Coupling Summary.
3. Assembly script (`scripts/assemble_gnx375_spec.py`) deferred until C2.2-G archives.
4. S13 watchpoint: outline may contain other PDF-term discrepancies; CC's PDF-direct reading catches these during authoring. Continue to trust the PDF as authoritative over the outline when in conflict. **Confirmed again by Fragment C LNAV/VNAV + MAPR additions.**
5. **D-21 gate overhead:** sequential drafting adds ~1 CD turn of wait between each fragment archive and the next fragment's prompt drafting. For D→G that's 3 remaining gate waits. Benefit (ITM-08 and ITM-09 both surfaced during C2.2-C review and must be incorporated into C2.2-D) dominates overhead.
6. **ITM-09 structural contract:** C2.2-D must author §7.9 or Fragment C's forward-refs will dangle on assembly. Single most important hard constraint for C2.2-D prompt.
7. **Coupling Summary budget miscalibration (both Fragments B and C):** future fragment prompts allocate ~60 lines for the Coupling Summary block, not ~15. This is a prompt-design refinement for C2.2-D drafting.
8. **ITM-08 Coupling Summary grep-verify:** add self-review step to future fragment prompts requiring Appendix B backward-ref claims be grep-verified against Fragment A. Prevents silent Coupling Summary accuracy drift.

---
