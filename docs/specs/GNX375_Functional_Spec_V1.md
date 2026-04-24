---
Created: 2026-04-22T10:00:00-04:00
Source: D-18 C2.2 format decision (Purple Turn 30); Fragment A archived Turn 35; Fragment B archived Turn 7 post-resumption; Fragment C archived Turn 14 post-resumption; Fragment D archived Turn 22 post-resumption (2026-04-23); Fragment E archived Turn 3 (2026-04-23, post-session-reset)
---

# GNX 375 Functional Spec V1

**Status:** Draft (5 of 7 fragments authored)
**Source outline:** `docs/specs/GNX375_Functional_Spec_V1_outline.md` (1,477 lines)
**Format decision:** D-18 (piecewise + manifest, 7 fragments)
**Total estimated body length:** ~3,180 lines (per D-18, after ITM-07 resolution)

---

## Fragment manifest

| Order | Task ID | Fragment file | Covers | Status | Lines (target / actual) |
|-------|---------|--------------|--------|--------|--------------------------|
| 1 | C2.2-A | `fragments/GNX375_Functional_Spec_V1_part_A.md` | §§1–3, App. B, App. C | ✅ Archived (Turn 35, 2026-04-22) | 445 / 545 |
| 2 | C2.2-B | `fragments/GNX375_Functional_Spec_V1_part_B.md` | §§4.1–4.6 (Home, Map, FPL, Direct-to, Waypoint Info, Nearest pages) | ✅ Archived (Turn 7 post-resumption, 2026-04-22) | 720 / 799 |
| 3 | C2.2-C | `fragments/GNX375_Functional_Spec_V1_part_C.md` | §§4.7–4.10 (Procedures, Planning, Hazard Awareness, Settings/System display) | ✅ Archived (Turn 14 post-resumption, 2026-04-22) | 575 / 725 |
| 4 | C2.2-D | `fragments/GNX375_Functional_Spec_V1_part_D.md` | §§5–7 (Flight Plan Editing, Direct-to Operation, Procedures incl. §7.1–7.9 numeric + §7.A–7.M lettered) | ✅ Archived (Turn 22 post-resumption, 2026-04-23) | 750 / 913 |
| 5 | C2.2-E | `fragments/GNX375_Functional_Spec_V1_part_E.md` | §§8–10 (Nearest Functions, Waypoint Information, Settings) | ✅ Archived (Turn 3, 2026-04-23 post-session-reset) | 455 / 829 |
| 6 | C2.2-F | `fragments/GNX375_Functional_Spec_V1_part_F.md` | §§11–13 (Transponder + ADS-B, Audio/Alerts, Messages) | ⚪ Not yet drafted | 540 / — |
| 7 | C2.2-G | `fragments/GNX375_Functional_Spec_V1_part_G.md` | §§14–15 + Appendix A (Persistent State, External I/O, Family Delta) | ⚪ Not yet drafted | 300 / — |

**Note on line targets:** C2.2-B through C2.2-G targets updated per D-19 (~1.35× outline expansion ratio). D-18's partition (7 fragments, scope per fragment) remains authoritative; D-19 adjusts prompt-target line counts for delivery quality-of-life only.

**Overage trend (5 of 7 fragments archived):** A=+22%, B=+11%, C=+26%, D=+22%, E=+82%. Fragment E is the largest relative overshoot in the series, driven by §10's 13 sub-sections each requiring operational workflow prose + 1–4 tables (§10.11 alone has 4 PDF-sourced tables). Compliance N1 classified as structural (content-justified, PDF-accurate, non-duplicative) — Fragment E is scope-smallest so any absolute overage shows as a large relative percentage. All overage verified as structural content (no invented material) via per-fragment compliance source-fidelity spot checks. C2.2-F/G prompts should continue to acknowledge structural overage as expected.

**§7.9 note:** Fragment D created `### 7.9 XPDR + ADS-B Approach Interactions` per ITM-09 resolution (see status journal). §7 now has 22 sub-sections: §§7.1–7.9 numeric + §§7.A–7.M lettered. On assembly, sub-sections present in numeric-first, lettered-second order.

**Status legend:**
- ⚪ Not yet drafted: CD has not authored the task prompt
- 🔶 Prompt drafted: Task prompt exists at `docs/tasks/c22_X_prompt.md`; CC not yet launched
- 🔵 In flight: CC executing or compliance running
- ✅ Archived: All four task files (prompt, completion, compliance_prompt, compliance) in `docs/tasks/completed/`

---

## Assembly

To produce the single-file spec for review (C3 `/spec-review`) or implementation reference (C4+):

1. Concatenate fragments in the order listed in the manifest above (A → G).
2. Strip each fragment's YAML front-matter and the H1 fragment header (`# GNX 375 Functional Spec V1 — Fragment X`).
3. Strip each fragment's "Coupling Summary" section (the trailing `## Coupling Summary` block — this is CD/CC coordination metadata, not spec content).
4. Add a single H1 to the assembled file: `# GNX 375 Functional Spec V1`.
5. Verify section numbering is continuous (no duplicates, no gaps): §1 → §15 + Appendices A → C.
6. Verify all internal cross-references (`see §N.x` patterns) resolve to existing targets after concatenation.

**§4 parent-scope note for assembly:** Fragment B authors the §4 parent scope paragraph. Fragment C opens directly with `### 4.7 Procedures Pages` (no duplicate `## 4. Display Pages` header). Concatenation yields a single continuous §4 section.

**§7 sub-section ordering note for assembly:** Fragment D presents §7.1 → §7.2 → ... → §7.9 (numeric) → §7.A → §7.B → ... → §7.M (lettered). This order is authored-in-order in Fragment D and preserved on concatenation. Fragment C's two forward-refs to §7.9 in §4.7 Open Questions resolve to Fragment D §7.9 content.

An assembly script (`scripts/assemble_gnx375_spec.py`) will be provided at C2.2-G archive. For partial assembly during the C2.2 sequence (e.g., to feed an early `/spec-review` pass on the foundation), the script can run against whatever fragments exist in the `fragments/` directory, producing a partial spec with placeholder notices for unfinished sections.

---

## Status journal

| Date | Event |
|------|-------|
| 2026-04-21 | D-18 format decision; manifest plan locked at 7 fragments |
| 2026-04-22 | Fragment A archived; manifest created |
| 2026-04-22 | D-19 logged: fragment prompt line-count expansion ratio (~1.35×); per-fragment targets refined |
| 2026-04-22 | Fragment B drafted, executed (799 lines), Phase 1 + Phase 2 compliance ALL PASS (23/23); archived. Compliance surfaced one outline-vs-PDF term discrepancy (outline "Search by Facility Name" vs. PDF "SEARCH BY CITY"); fragment uses correct PDF term. Observation preserved; no action required. |
| 2026-04-22 | D-20 logged: CC task duration estimates should use LLM-calibrated baselines. |
| 2026-04-22 | D-21 logged: multi-fragment task prompts drafted sequentially after predecessor archive; extends D-18's sequential-execution discipline to drafting. |
| 2026-04-22 | Fragment C drafted, executed (725 lines; +26% overage classified as structural), Phase 1 + Phase 2 compliance PASS WITH NOTES (22/25 PASS, 3/25 PARTIAL, 0 FAIL); archived. Compliance surfaced: (a) S13-pattern additions confirmed (LNAV/VNAV and MAPR added beyond outline, both PDF-confirmed); (b) Coupling Summary over-claims 4 glossary terms → ITM-08 (no-action observation); (c) outline §7 lacks §7.9 heading that Fragment C forward-refs → ITM-09 (must resolve in C2.2-D). |
| 2026-04-23 | Fragment D drafted, executed (913 lines; +22% overage classified as structural — 22 §7 sub-sections + PDF-sourced tables), Phase 1 + Phase 2 compliance **ALL PASS (30/30)**; archived. First zero-PARTIAL, zero-FAIL compliance in the series. Notable outcomes: (a) ITM-09 resolved — §7.9 authored as real sub-section; both Fragment C forward-refs semantically resolve; (b) ITM-08 watchpoint discipline validated — authoring-phase grep-verify prevented Coupling Summary over-claim recurrence; (c) S13-pattern third recurrence confirmed in §5.3 Waypoint Options (8 items PDF-sourced vs. outline implied 6); (d) §7.D HAL 4-row table confirmed PDF-accurate (not typo). |
| 2026-04-23 | Fragment E drafted, executed (829 lines; +82% overage classified as structural — §10 has 13 sub-sections, §10.11 has 4 PDF-sourced tables), Phase 1 + Phase 2 compliance **PASS WITH NOTES (33 PASS / 3 PASS WITH NOTES / 0 PARTIAL / 0 FAIL across 36 checks)**; archived. Notable outcomes: (a) ITM-08 authoring-phase grep-verify discipline continues to work — all 17 claimed Appendix B terms independently re-verified as formal glossary entries, all 5 exclusions confirmed absent; (b) §10.6 Unit Selections PDF/Fragment C/prompt reconciliation resolved in favor of Fragment C consistency (Fragment E matches Fragment C §4.10 → PASS per decision rule); (c) Fragment C §4.10 vs. PDF p. 94 Unit Selections divergence is a pre-existing condition in Fragment C — logged as ITM-10 watchpoint for future Fragment C review; (d) third undocumented S13 instance surfaced at §8.2 "approach type" (fragment body correct — PDF-accurate; completion report did not enumerate it — archive note only); (e) §9.2 Airport Information tabs 8-vs-7 vs. PDF p. 167: non-blocking minor (SafeTaxi documented in Appendix B.3 and task prompt). Session context: this session reset from a prior Purple session that was moved mid-flight from photoprinting → flight-sim; compliance work was unaffected because all file ops went to absolute Windows paths. |

---

## Related

- `docs/decisions/D-18-c22-format-decision-piecewise-manifest.md` — format authority
- `docs/decisions/D-19-fragment-prompt-line-count-expansion-ratio.md` — per-fragment line-count targets
- `docs/decisions/D-20-cc-task-duration-estimates-llm-calibrated.md` — duration estimation baselines
- `docs/decisions/D-21-multi-fragment-sequential-drafting-discipline.md` — sequential drafting
- `docs/todos/issue_index.md` §ITM-08 — Coupling Summary over-claim watchpoint (validated by Fragment D)
- `docs/todos/issue_index_resolved.md` §ITM-09 — §7.9 authorship resolution (Fragment D)
- `docs/specs/GNX375_Functional_Spec_V1_outline.md` — source outline
- `docs/tasks/Task_flow_plan_with_current_status.md` — live status tracker
- `docs/specs/Spec_Tracker.md` — spec lifecycle tracker (CD-maintained)
