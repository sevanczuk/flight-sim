---
Created: 2026-04-22T10:00:00-04:00
Source: D-18 C2.2 format decision (Purple Turn 30); first fragment archived Turn 35
---

# GNX 375 Functional Spec V1

**Status:** Draft (1 of 7 fragments authored)
**Source outline:** `docs/specs/GNX375_Functional_Spec_V1_outline.md` (1,477 lines)
**Format decision:** D-18 (piecewise + manifest, 7 fragments)
**Total estimated body length:** ~3,180 lines (per D-18, after ITM-07 resolution)

---

## Fragment manifest

| Order | Task ID | Fragment file | Covers | Status | Lines (target / actual) |
|-------|---------|--------------|--------|--------|--------------------------|
| 1 | C2.2-A | `fragments/GNX375_Functional_Spec_V1_part_A.md` | §§1–3, App. B, App. C | ✅ Archived (Turn 35) | 445 / 545 |
| 2 | C2.2-B | `fragments/GNX375_Functional_Spec_V1_part_B.md` | §§4.1–4.6 (Home, Map, FPL, Direct-to, Waypoint Info, Nearest pages) | ⚪ Not yet drafted | 610 / — |
| 3 | C2.2-C | `fragments/GNX375_Functional_Spec_V1_part_C.md` | §§4.7–4.10 (Procedures, Planning, Hazard Awareness, Settings display) | ⚪ Not yet drafted | 480 / — |
| 4 | C2.2-D | `fragments/GNX375_Functional_Spec_V1_part_D.md` | §§5–7 (Flight Plan Editing, Direct-to Operation, Procedures) | ⚪ Not yet drafted | 630 / — |
| 5 | C2.2-E | `fragments/GNX375_Functional_Spec_V1_part_E.md` | §§8–10 (Nearest Functions, Waypoint Information, Settings) | ⚪ Not yet drafted | 380 / — |
| 6 | C2.2-F | `fragments/GNX375_Functional_Spec_V1_part_F.md` | §§11–13 (Transponder + ADS-B, Audio/Alerts, Messages) | ⚪ Not yet drafted | 450 / — |
| 7 | C2.2-G | `fragments/GNX375_Functional_Spec_V1_part_G.md` | §§14–15 + Appendix A (Persistent State, External I/O, Family Delta) | ⚪ Not yet drafted | 250 / — |

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

An assembly script (`scripts/assemble_gnx375_spec.py`) will be provided at C2.2-G archive. For partial assembly during the C2.2 sequence (e.g., to feed an early `/spec-review` pass on the foundation), the script can run against whatever fragments exist in the `fragments/` directory, producing a partial spec with placeholder notices for unfinished sections.

---

## Status journal

| Date | Event |
|------|-------|
| 2026-04-21 | D-18 format decision; manifest plan locked at 7 fragments |
| 2026-04-22 | Fragment A archived; manifest created |

---

## Related

- `docs/decisions/D-18-c22-format-decision-piecewise-manifest.md` — format authority
- `docs/specs/GNX375_Functional_Spec_V1_outline.md` — source outline
- `docs/tasks/Task_flow_plan_with_current_status.md` — live status tracker
- `docs/specs/Spec_Tracker.md` — spec lifecycle tracker (CD-maintained)
