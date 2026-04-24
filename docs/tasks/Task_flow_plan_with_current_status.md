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
| **[ITM-09 logged → resolved]**             | Outline §7 lacks §7.9 heading referenced by Fragment C forward-refs. Resolution: C2.2-D authored §7.9 as real sub-section; both Fragment C forward-refs semantically resolve (C2.2-D compliance X23 PASS). | ✅ Logged Turn 14; ✅ Resolved Turn 22, 2026-04-23 (`docs/todos/issue_index_resolved.md` §ITM-09) |
| C2.2-D task prompt drafting                | CD drafts `docs/tasks/c22_d_prompt.md` (covers §§5–7; ~750 lines target per D-19; 14 hard framing commitments; 24 self-review items; hard constraint: §7.9 must be authored as new sub-section per ITM-09; Phase G ITM-08 grep-verify step; Coupling Summary budget corrected to ~60 lines; soft ceiling 815; borderline CRP applicability) | ✅ Done (Turn 15, 2026-04-23T06:23 ET) |
| C2.2-D (full lifecycle)                    | Prompt drafted → executed (913 lines; +22% structural overage classified — 22 §7 sub-sections + PDF-sourced tables) → Phase 1 + Phase 2 compliance (**ALL PASS 30/30**) → archived; manifest + Task flow plan + issue_index updated. First zero-PARTIAL, zero-FAIL compliance in series. ITM-09 resolved. ITM-08 discipline validated (authoring-phase grep-verify prevented recurrence). S13-pattern third recurrence confirmed (§5.3 8-item Waypoint Options PDF-sourced). §7.D 4-row HAL table confirmed PDF-accurate. | ✅ Done (Turns 15–22 post-resumption; spans 2026-04-22 to 2026-04-23) |
| **[ITM-08 watchpoint validated]**          | Fragment D authoring-phase grep-verify executed successfully: 25 Appendix B terms confirmed present; 4 excluded terms (EPU, HFOM/VFOM, HDOP, TSO-C151c) correctly omitted from backward-refs. C2.2-D compliance F11 independently re-grep'd and confirmed. Discipline working as intended. Carry-forward to C2.2-E/F/G prompts. | ✅ Validated (Turn 22, 2026-04-23)          |
| **C2.2-E task prompt drafting**            | CD drafts `docs/tasks/c22_e_prompt.md` (covers §§8–10 — Nearest Functions, Waypoint Information pages, Settings/System operational pages; ~455 lines target per D-19; 14 hard framing commitments including Phase F ITM-08 grep-verify and Coupling Summary ~60-line budget; 22 self-review items; S13 trust-PDF-over-outline watchpoint flagged for §9.5 Search Tabs and §10.11 GPS Status field labels; consistency with Fragment C §4.10 Settings display + Fragment B §4.5 Waypoint Info + §4.6 Nearest + Fragment D §7.D/§7.G CDI cross-refs) | ✅ Done (Turn 1, 2026-04-23T14:11 ET; 625-line prompt) |
| C2.2-E execution                           | CC authors `docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` | ✅ Done (Turn 2, 2026-04-23; 829 lines — +82% over target, classified as structural overage; completion report received Turn 3) |
| C2.2-E check-completions + compliance      | CD Phase 1 check-completions (Turn 3, 2026-04-23T14:48 ET) → compliance prompt drafted (`docs/tasks/completed/c22_e_compliance_prompt.md`, 30 items / 5 categories F/S/X/C/N); CC Phase 2 compliance executed → PASS WITH NOTES (33/3/0/0 across 36 checks). CD Phase 2 review: Fragment C §4.10 vs. PDF p. 94 Unit Selections divergence logged as ITM-10; §8.2 "approach type" noted as third undocumented S13 instance (body correct; archive note only); §9.2 8-vs-7 tab count non-blocking minor. All four files archived to `completed/`. | ✅ Done (Turn 3 post-session-reset, 2026-04-23) |
| C2.2-F task prompt drafting                | CD drafts `docs/tasks/c22_f_prompt.md` (covers §§11–13 — Transponder + ADS-B, Audio/Alerts, Messages; ~540 lines target per D-19; most-coupled fragment) | 🔶 **IN PROGRESS** (Turn 3 post-session-reset, 2026-04-23 — draft underway as part of "proceed. then write next prompt" composite) |
| C2.2-F (full lifecycle)                    | Remaining lifecycle steps                                    | ⚪ Pending                                   |
| C2.2-G task prompt drafting                | CD drafts `docs/tasks/c22_g_prompt.md` (covers §§14–15 + Appendix A — Persistent State, External I/O, Family Delta; ~300 lines target per D-19; smallest fragment but highest coupling footprint in Coupling Summary) | ⚪ Pending (gated on C2.2-F archive per D-21) |
| C2.2-G (full lifecycle)                    | Final fragment lifecycle                                     | ⚪ Pending                                   |
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

**C2.2-E archived (Turn 3 post-session-reset, 2026-04-23T15:2x ET).** Fragment E at 829 lines (target 455, +82% — largest relative overshoot in series but scope-smallest fragment so absolute overage is modest). Compliance PASS WITH NOTES: 33 PASS / 3 PASS WITH NOTES / 0 PARTIAL / 0 FAIL across 36 checks (F 5 / S 8 / X 5 / C 14 / N 4). All four files moved to `docs/tasks/completed/`. Manifest updated; Fragment E → ✅ Archived (455 / 829). C2.2-F gate unlocked per D-21 — drafting started same-turn.

**Notable compliance outcomes:**
1. **ITM-08 discipline continues to work** (three-for-three now). All 17 claimed Appendix B terms independently re-verified as formal glossary entries in Fragment A; all 5 exclusions (EPU, HFOM, VFOM, HDOP, TSO-C151c) confirmed absent. B.3 section existence confirmed in Fragment A.
2. **S6 §10.6 Unit Selections** resolved: Fragment E matches Fragment C §4.10 (7 types) → PASS per decision rule. PDF p. 94 shows a different partial list (Fuel + Magnetic Variation present; Altitude/VSI/Wind/Pressure absent). Fragment C §4.10 itself diverges from PDF p. 94 — pre-existing condition in archived Fragment C.
3. **ITM-10 logged** for the Fragment C §4.10 vs. PDF p. 94 discrepancy as a low-severity watchpoint for any future Fragment C review or C3 full-spec `/spec-review`.
4. **Third undocumented S13 instance** at §8.2 "approach type" (PDF p. 179 uses "approach type" not outline's "runway surface"). Fragment body correctly applies the S13 correction; completion report only listed §9.5 and §10.11 as S13 instances — documentation gap, not content issue. Archive note in manifest status journal.
5. **§9.2 Airport Information tabs** 8 (Fragment E) vs. 7 (PDF p. 167): non-blocking. SafeTaxi is a formal Appendix B.3 entry and is in the task prompt.

**C2.2-D fully archived (Turn 22, 2026-04-23).** Fragment D at 913 lines (target 750, +22%). Compliance **ALL PASS 30/30**. Series pattern validated through D-E transition. ITM-08 discipline embedded in all future prompts; no recurrence observed.

**Session context note:** This session reset from a prior Purple session that started in photoprinting and was moved mid-flight to flight-sim, leaving `/mnt/project` still bound to photoprinting. Compliance work was unaffected because all file ops went to absolute Windows paths. Current session correctly bound to flight-sim (verified Turn 1 by `ls /mnt/project/` + `head -2 /mnt/project/CLAUDE.md`).

**C2.2-F task prompt drafting in progress (Turn 3, 2026-04-23).** Scope: §§11–13 (Transponder + ADS-B, Audio/Alerts, Messages). Target ~540 lines per D-19. Most-coupled fragment in the series — densest Coupling Summary expected (may calibrate budget upward from ~60 to ~80 lines). Carry-forward constraints from D + E plus §11 D-16 three-modes framing (Standby / On / Altitude Reporting) and built-in dual-link ADS-B In. §11.10 Remote G3X Touch out of v1 scope. §11.11 ADS-B In must match Fragment C §4.9 + Fragment E §10.12. §11.13 XPDR Advisory Messages (9 advisories) cross-refs §13.9 in same fragment. ITM-10 noted as watchpoint (not a new constraint).

**Critical path:** ~6 more sequential CD steps to C3 kick-off:
- C2.2-F full lifecycle (~5 turns)
- C2.2-G full lifecycle (~5 turns)
- Assembly script + aggregate spec
- C3 `/spec-review` V1

**Watchpoints carried forward:**
1. **Line-count trend:** A+22, B+11, C+26, D+22, E+82. Fragment F target 540 — if 20–30% over, actual ~650–700; if 80% over (like E), actual ~970. Classify in completion report.
2. **S13 watchpoint** is now at 3–4 confirmed instances (B Search-by-City, C LNAV/VNAV + MAPR, D §5.3 Waypoint Options, E §9.5 + §10.11 + §8.2-documented-post-compliance). PDF continues to beat outline; enshrine in F/G prompts as a Phase 0 expectation, not a surprise.
3. **ITM-08 discipline** embedded in all future prompts. No recurrence expected.
4. **ITM-10 (new)** — Fragment C §4.10 vs. PDF p. 94 Unit Selections — low-severity watchpoint; does not block Fragment F/G. Revisit at C3 full-spec review.
5. **Coupling Summary budget for Fragment F:** may calibrate up to ~80 lines (vs. ~60 for D and E) due to dense §11 coupling to C §4.9, E §10.12, and same-fragment §13.9 cross-refs.
6. **Assembly script** (`scripts/assemble_gnx375_spec.py`) deferred until C2.2-G archives.
7. **D-21 gate overhead acknowledged:** 2 remaining sequential gates (F→G, G→assembly). Discipline continues to justify overhead.

---
