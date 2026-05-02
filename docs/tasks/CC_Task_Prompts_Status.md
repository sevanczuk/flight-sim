---
Created: 2026-04-25T09:33:26-04:00
Source: Purple Turn 2 — reconstituted from briefing + 0828 checkpoint + Task_flow_plan_with_current_status.md + completed/ inventory after discovering file did not exist on disk
Purpose: Running status of all CC task prompts (per CLAUDE.md Key Data Sources)
Update cadence: CD updates this file when a CC task prompt changes lifecycle state — drafted, launched, completion received, compliance verified, archived. Updated in the same CD turn as the state-change event.
**Last updated:** 2026-05-02T10:50:56-04:00 (Purple Turn 15 — GNX375-PAGEMAP-PYMUPDF-01 task family archived; build_page_number_map.py pending entry retired; DEPENDENCY-AUDIT-01 added to drafting-in-progress)
Scope confirmation needed: This is a first-pass reconstitution. The columns and granularity may not match what the briefing/CLAUDE.md originally envisioned. Steve to validate or redirect.
Lifecycle states: drafted → launched → completion-received → compliance-prompt-drafted → compliance-launched → compliance-received → reviewed → archived
Related docs: `docs/tasks/Task_flow_plan_with_current_status.md` (task-level flow); `docs/specs/Spec_Tracker.md` (spec lifecycle); `docs/todos/priority_task_list.md` (priority ranking).
---

# CC Task Prompts Status

## Active

(no active CC tasks — V1 spec body complete)

## Pending — drafted, not launched

(none)

## Pending — not yet drafted

| Task | Trigger | Notes |
|------|---------|-------|
| `verify_gnx375_manifest.py` authoring | After C2.2-ASSEMBLE | Per D-22 §6 |
| 3 domain-specific Sonnet agents | Before C3 review | `.claude/agents/spec-pdf-source-fidelity-reviewer.md`, `spec-cross-fragment-coupling-reviewer.md`, `spec-sibling-unit-consistency-reviewer.md`; per D-22 §2 |
| Review Priority Guide prepend | After C2.2-ASSEMBLE | Per D-22 §5 |
| DEPENDENCY-AUDIT-01 | After ITM-11 closure (now satisfied) | Inventory references to retired paths (`assets/retired/gnc355_pdf_extracted/`, `assets/retired/gnc355_reference/`, pre-pivot paths) across `docs/`, `scripts/`, `src/`, `tests/`, `config/`, project-instruction files, and `docs/tasks/completed/`. Drafting in progress Purple Turn 15. |

**Retired pending entries** (formerly listed; no longer applicable):
- `build_page_number_map.py` authoring — superseded by GNX375-PAGEMAP-PYMUPDF-01 (archived 2026-05-02). The PyMuPDF-based extraction tool replaced the LlamaParse-based footer-parsing approach this entry anticipated. ITM-11 closed by D-30.
- Image extraction Approach A — retired with the GNC 355 PDF extraction pivot to GNX 375 PyMuPDF; the briefing flagged but no archive disposition has been written. If this task is revived, draft fresh.
- Image extraction Approach B — cache window expired 2026-04-26; retired alongside Approach A.

## Pending — V2 amendment (Supplemental AFM integration)

Gated on GNX 375 Functional Spec V1 implementation-ready. Tracked here to keep on the front burner; see `Spec_Tracker.md` §GNX375_Functional_Spec_V2 for full scope.

| Task | Trigger | Notes |
|------|---------|-------|
| AFMS PDF extraction (LlamaParse) | Post-V1 closure | Source: `assets/Supplemental Airplane Flight Manual ... 190-02207-a3_03.pdf` (50 pages, 750KB). Agentic tier = ~500 credits / ~1.25% of Starter monthly. Output to `assets/afms_extracted/`. Use new commons LlamaParse CLI tool. |
| AFMS reconciliation | After AFMS extraction | CC task: map AFMS sections to Functional Spec sections that should reference or comply with each AFMS §. Produce coverage table for V2 changebar scoping. |
| GNX 375 Functional Spec V2 changebar patch | After AFMS reconciliation | Add only AFMS-mandated behaviors not already in V1. Use changebar versioning per claude-conventions §Artifact Conventions. |
| V2 review (scope TBD) | After V2 changebar drafted | Small targeted review, or skip if patch is purely additive — decision deferred until reconciliation coverage table exists. |

## Archived (in `docs/tasks/completed/`)

### Stream A — AMAPI documentation

| Task ID | Files | Verdict |
|---------|-------|---------|
| amapi_crawler | prompt + completion + 3 bugfix cycles + combined compliance | PASS (post-bugfix) |
| amapi_parser | prompt + completion | PASS |
| amapi_patterns | prompt + completion + compliance | PASS |

### Stream B — Instrument sample analysis

| Task ID | Files | Verdict |
|---------|-------|---------|
| rename_instrument_samples | prompt + completion | PASS |
| (B2 subset selection) | inline CD work | — |
| (B3 pattern catalog / B4 readiness review) | tracked in Task_flow_plan; CC-executed work archived as part of B sequence | PASS |

### Stream C — GNX 375 functional spec

| Task ID | Files | Verdict |
|---------|-------|---------|
| gnc355_pdf_extract | prompt + completion | PASS (PyMuPDF extraction; pre-LlamaParse) |
| pdf_reextraction_llamaparse | prompt + completion (in `docs/tasks/`, not yet archived) | PASS — kept in active dir per Steve's pattern; major quality uplift |
| c2_1_outline (GNC 355) | prompt + completion + compliance | PASS — superseded by D-12 pivot |
| c2_1_375_outline (GNX 375) | prompt + completion + compliance | PASS WITH NOTES — ITM-07 logged, resolved by D-18 |
| c22_a (Fragment A) | prompt + completion + compliance | PASS — 17/17 |
| c22_b (Fragment B) | prompt + completion + compliance | PASS — 23/23 |
| c22_c (Fragment C) | prompt + completion + compliance | PASS WITH NOTES — 22/25 PASS, 3 PARTIAL; ITM-08, ITM-09 logged |
| c22_d (Fragment D) | prompt + completion + compliance | PASS — 30/30; ITM-09 resolved |
| c22_e (Fragment E) | prompt + completion + compliance | PASS WITH NOTES — 33/3/0/0 across 36; ITM-10 logged |
| c22_f (Fragment F) | prompt + completion + compliance | PASS WITH NOTES — 36/1/1/0 across 38; ITM-12 logged |

| c22_g (Fragment G) | prompt + completion + compliance | PASS WITH NOTES — 49/2/0/0 across 51; ITM-12 resolved; **7-fragment decomposition complete; spec body assembly-ready** |
| c22_assemble_gnx375 | prompt + completion + compliance prompt + compliance | PASS WITH NOTES — 39/3/2/1 across 45; CD reclassified P1 FAIL (BOM in commit subject) as PASS WITH NOTES → ITM-13; S7 PARTIAL (`--partial` continuity-skip not implemented) → ITM-14; both deferred. Outputs: `scripts/assemble_gnx375_spec.py` (555 lines), `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` (4433 lines). Two retained Fragment B/C preambles in aggregate; Appendix B/C placement preserved per Turn 7 decision. |
| build_page_number_map_from_pymupdf (GNX375-PAGEMAP-PYMUPDF-01) | prompt + completion + compliance prompt + compliance | ALL PASS — 17/17 across 7 categories (S/L/A/N/D/G/C); zero issues. Outputs: `scripts/build_page_number_map_from_pymupdf.py` (~370 lines), `assets/gnx375_pymupdf_v1_0_1/page_number_map.json` (schema v2.0; 310 / 306 parsed / 4 unparseable). Built atop pymupdf-extract V1.0.1 metadata + `page_overrides.json` (D-28 PAP 22 entry on page 2). |

### Cross-cutting / housekeeping

| Task ID | Files | Verdict |
|---------|-------|---------|
| itm_01_file_movement | prompt + completion | PASS |

### External-to-flight-sim (commons/)

| Task | Path | State |
|------|------|-------|
| LLAMAPARSE-EXTRACT-CLI-V1 | `commons-project/commons/llamaparse-extract/` | Done; superseded by V2 |
| LLAMAPARSE-EXTRACT-CLI-V2 | `commons-project/commons/llamaparse-extract/` | Done — 33/33 smoke tests passing |

These external tasks live outside flight-sim; tracked here for cross-reference only.

---

## Conventions

- New CC tasks enter at "drafted" or "not yet drafted" depending on whether a prompt file exists.
- A task graduates to "archived" only after `check completions` Phase 2 review verdict (PASS or PASS WITH NOTES) and the four-file move to `docs/tasks/completed/`.
- Verdict shorthand uses Compliance Verification Guide vocabulary: PASS, PASS WITH NOTES, PARTIAL, FAIL.
- Fragment compliance counts use the format observed in the C2.2 series: `{PASS}/{PARTIAL}/{FAIL}/{...}` across N total checks, where category breakdown matches the compliance prompt's category structure.
