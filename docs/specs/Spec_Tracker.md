---
Created: 2026-04-25T09:33:26-04:00
Source: Purple Turn 2 — reconstituted from briefing + 0828 checkpoint + Task_flow_plan_with_current_status.md after discovering file did not exist on disk
Purpose: Spec lifecycle, review rounds, dispositions, CC task links (per CLAUDE.md Key Data Sources)
Update cadence: CD updates this file when a spec changes state — version bump, review round completed, disposition decided, CC task linked. Updated in the same CD turn as the state-change event.
Scope confirmation needed: This is a first-pass reconstitution. The columns and granularity may not match what the briefing/CLAUDE.md originally envisioned. Steve to validate or redirect.
Related docs: `docs/tasks/Task_flow_plan_with_current_status.md` (task-level flow); `docs/tasks/CC_Task_Prompts_Status.md` (CC prompt lifecycle); `docs/todos/priority_task_list.md` (priority ranking).
---

# Spec Tracker

Tracks every spec under `docs/specs/` through its lifecycle: drafting → review rounds → dispositions → implementation-ready.

## Active specs

### GNX375_Functional_Spec_V1 — primary deliverable per D-12

| Field | Value |
|-------|-------|
| Path | `docs/specs/GNX375_Functional_Spec_V1.md` (manifest); fragments in `docs/specs/fragments/` |
| Version | V1 (drafting) |
| Status | 🟢 V1 BODY ASSEMBLED — aggregate at `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` (4433 lines); pending Review Priority Guide prepend + manifest pre-flight + C3 review |
| Format | Piecewise + manifest (per D-18); 7 fragments, assembly script gated on G archive |
| Outline source | `docs/specs/GNX375_Functional_Spec_V1_outline.md` (1,477 lines, 18 divisions; archived) |
| Implementation Plan | `docs/specs/GNX375_Prep_Implementation_Plan_V2.md` |
| Review status | C3 review pending V1 closure; D-22 customizations apply |
| Disposition | Not yet implementation-ready — pending Fragment G + assembly + C3 review |

**Fragment manifest:**

| Fragment | Sections | Lines (actual / target) | Status | Compliance |
|----------|----------|-------------------------|--------|------------|
| A | §§1–3 | 545 / 445 | ✅ Archived | 17/17 PASS or CONFIRMED |
| B | §§4 (split) | 799 / 720 | ✅ Archived | 23/23 PASS |
| C | §§4 cont. | 725 / 575 | ✅ Archived | 22/25 PASS, 3 PARTIAL, 0 FAIL |
| D | §§5–7 | 913 / 750 | ✅ Archived | 30/30 PASS |
| E | §§8–10 | 829 / 455 | ✅ Archived | 33/3 PASS, 3 partial, 0 FAIL (PASS WITH NOTES) |
| F | §§11–13 | 606 / 540 | ✅ Archived | 36/1/1/0 across 38 (PASS WITH NOTES) |
| G | §§14–15 + Appendix A | 443 / 300 | ✅ Archived | 49 PASS / 2 PASS WITH NOTES / 0 PARTIAL / 0 FAIL across 51 checks |

**Active ITMs against this spec:** ITM-08 (terminology grep — resolved by F authoring discipline), ITM-10 (§4.10 vs PDF p. 94 watchpoint), ITM-11 (page-number offset; needs `scripts/build_page_number_map.py` before C3), ITM-14 (assembly script `--partial` continuity-skip gap; defer until needed). ITM-12 resolved Turn 6 by C2.2-G Coupling Summary discipline.

---

### GNX375_Functional_Spec_V2 — pending V2 amendment (Supplemental AFM integration)

| Field | Value |
|-------|-------|
| Path | `docs/specs/GNX375_Functional_Spec_V2_changebar.md` (planned) → `docs/specs/GNX375_Functional_Spec_V2.md` (clean) |
| Version | V2 (planned changebar patch) |
| Status | ⚪ Planned — gated on V1 implementation-ready |
| Source PDF | `assets/Supplemental Airplane Flight Manual - Garmin GPS 175, GNC 355, or GNX 375 GPS-COM-XPDR Navigation System - 190-02207-a3_03.pdf` (50 pages, 750KB, FAA-approved) |
| Format | Changebar patch per claude-conventions §Artifact Conventions (`{name}_changebar.md` + revision history block) |
| Rationale | AFMS provides regulatory/operational context the Pilot's Guide doesn't (limitations, kinds of operation, autopilot coupling rules, emergency procedures, normal procedures, transponder/traffic system detail) |
| Disposition | Defer until V1 closure to avoid scope creep on V1 (V1 already 340+ lines past target, one fragment from closure) |
| Open question | Whether V2 needs its own review cycle or can be a small focused changebar patch (carried in 0828 checkpoint) |

**Planned task sequence:**

1. AFMS PDF extraction via LlamaParse Agentic tier (~500 credits / ~1.25% of Starter monthly quota)
2. AFMS reconciliation: map AFMS sections to Functional Spec sections that should reference or comply with each AFMS §; produce coverage table
3. V2 changebar patch authoring: add only AFMS-mandated behaviors not already in V1
4. V2 review (scope TBD — small targeted review or skip if patch is purely additive)

**AFMS sections relevant to V2 (per briefing §3):**

| AFMS § | Topic | Likely V2 spec impact |
|--------|-------|------------------------|
| §2.1–2.6 | Kinds of Operation / Min Equipment / Flight Planning | UI must distinguish "approved" vs. "advisory only" functions |
| §2.10–2.11 | Instrument Approaches / RF Legs | Autopilot coupling rules during approach |
| §2.12 | Autopilot Coupling | Cross-check vs. spec D-15/D-16 |
| §2.13 | Terrain Alerting Function | Alert annunciation rules |
| §2.15–2.16 | ADS-B Weather / Traffic | Operational use boundaries |
| §3 | Emergency Procedures | LOI annunciation, integrity loss UI behavior |
| §4 | Normal Procedures | Pre-flight, RAIM check, DB verification UI flows |
| §7.9 | ADS-B Traffic | Direct GNX 375 transponder section reference |
| §7.10 | Transponder Control (GNX 375 only) | Direct GNX 375 spec reference |

**AFMS sections to ignore:** §1.3 GNSS approvals (regulatory paperwork), §5–6 perf/W&B (airframe-specific), §2.25 placards.

---

### GNX375_Functional_Spec_V1_outline

| Field | Value |
|-------|-------|
| Path | `docs/specs/GNX375_Functional_Spec_V1_outline.md` |
| Version | V1 |
| Status | ✅ Done — superseded by V1 fragments under construction |
| Disposition | Reference only; outline → fragment authoring (C2.2-A through G) is the canonical lineage |

---

### GNX375_Prep_Implementation_Plan_V2

| Field | Value |
|-------|-------|
| Path | `docs/specs/GNX375_Prep_Implementation_Plan_V2.md` |
| Version | V2 (revised from V1 after D-12 pivot) |
| Status | ✅ Done — narrative plan stream-by-stream |
| Notes | Drives Stream A/B/C task structure |

---

## Shelved specs

### GNC355_Functional_Spec_V1_outline — secondary deliverable per D-12

| Field | Value |
|-------|-------|
| Path | `docs/specs/GNC355_Functional_Spec_V1_outline.md` |
| Status | ⏸ SHELVED per D-12 (Turn 14, GNX 375 pivot) |
| Disposition | Resume after GNX 375 V1 implementation-ready; harvest map (C2.0) covers 355→375 reuse |

### GNC355_Prep_Implementation_Plan_V1

| Field | Value |
|-------|-------|
| Path | `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` |
| Status | ⏸ SHELVED per D-12 |
| Disposition | Reference for future GNC 355 work |

---

## Reference / supporting docs in `docs/specs/`

| Doc | Purpose |
|-----|---------|
| `pivot_355_to_375_rationale.md` | D-12 pivot rationale and harvest mapping |
| `Spec_Review_Workflow.md` | Authoritative reference for `/spec-review` agent tiers + execution |
| `lifecycle/` | Per-spec runtime state JSON (gitignored) |
| `fragments/` | GNX 375 V1 part files |

---

## Review-round disposition log

(Empty — V1 has not yet been reviewed. C3 review per D-22 pending V1 assembly.)
