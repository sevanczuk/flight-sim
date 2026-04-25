# Continuation Briefing — flight-sim GNX 375 Effort

**Authored:** 2026-04-25T07:40:41-04:00 ET (Purple Turn 48)
**Author:** CD Purple
**Purpose:** Post-handoff briefing for the next CD session resuming the GNX 375 Functional Spec V1 effort. Use this as session-init context after starting a fresh CD instance.
**Scope:** Flight-sim GNX 375 work only. Does NOT cover the LlamaParse CLI tool diversion (commons/llamaparse-extract) except as a tool dependency.

---

## 1. Where the GNX 375 Functional Spec V1 stands

### Fragment manifest

| Fragment | Status | Lines (actual / target) | Notes |
|----------|--------|-------------------------|-------|
| A | Archived | 545 / 445 | + |
| B | Archived | 799 / 720 | + |
| C | Archived | 725 / 575 | + |
| D | Archived | 913 / 750 | + |
| E | Archived | 829 / 455 | + |
| F | Archived | 606 / 540 | + (Turn 21) |
| **G** | **Prompt drafted, CC launch pending** | target 300; expected 330–410 | Fragment G covers §§14–15 + Appendix A |

Fragment line totals are running 13–82% over targets per fragment. Cumulative overage trend tracked in spec manifest.

### Fragment G prompt highlights (what's queued)

Prompt at `docs/tasks/c22_g_prompt.md` covers final fragment (§§14–15 + Appendix A). 17 hard constraints including:

- #2 — ITM-12 prose-per-ref Coupling Summary (90–110 lines, NOT compact bullets). This was the only PARTIAL on Fragment F's compliance review.
- #3 — no forward references (final fragment, all upstream §§ now real).
- #6 — D-15: §15.6 no internal VDI on GNX 375.
- #7 — D-16: §15.7 external altitude only.
- #10 — D-12: Appendix A.1 GNC 355 → GNX 375 pivot.
- #13 — Appendix A.5 tri-unit matrix.
- #17 — assembly readiness (manifest-aware, boundary markers honored).

25 self-review items. OQ4/OQ5 preserved verbatim.

### To resume

1. Steve launches CC on C2.2-G via the prompt + tab-title combo from Turn 21's briefing.
2. CC produces fragment + completion report.
3. CD runs check-completions: Phase 1 (compliance prompt) → Phase 2 (compliance review).
4. Archive to `docs/tasks/completed/` on PASS or PASS WITH NOTES.
5. Assemble V1 aggregate from all 7 fragments. (Helper script work below.)

---

## 2. Open ITMs affecting GNX 375 work

Active in `docs/todos/issue_index.md`:

- **ITM-08** — terminology grep watchpoint (resolved during Fragment F via 20-term grep verification).
- **ITM-10** — Fragment C §4.10 Unit Selections vs. PDF p. 94 watchpoint (logged Turn 3).
- **ITM-11** — page-number offset (physical page vs. Garmin logical page). Required follow-up: `scripts/build_page_number_map.py` before C3 spec review. Concrete examples: `page_080.md` = Pilot's Guide p. 78 XPDR Modes, `page_098.md` = p. 94 Unit Selections, `page_129.md` = p. 125 Land Symbols.
- **ITM-12** — Coupling Summary format (logged Turn 21). Watchpoint applied to Fragment G constraint #2; check during G's compliance review.

Plus older ITM-02, ITM-03, ITM-04, ITM-05, FE-01.

---

## 3. Newly identified work — Supplemental AFM (AFMS)

A second Garmin source document was added to `assets/`: **"Supplemental Airplane Flight Manual - Garmin GPS 175, GNC 355, or GNX 375 GPS-COM-XPDR Navigation System - 190-02207-a3_03.pdf"** (50 pages, 750KB, FAA-approved).

### Recommendation: defer integration until after V1 closure

The AFMS provides regulatory/operational context the Pilot's Guide doesn't: limitations, kinds-of-operation, autopilot coupling rules, emergency procedures, normal procedures (pre-flight, RAIM check, database verification), and §7 system-description detail on transponder control and traffic systems.

**It is worth folding in — but as a V2 amendment, not a V1 insertion.** V1 is already 340+ lines past target and one fragment from closure. Adding a major new source mid-Fragment-G risks scope creep and another full review cycle.

### Recommended sequence post-V1

1. Archive Fragment G; assemble V1 aggregate; run V1 spec review per D-22 customizations.
2. Run V1 amendment cycle if needed (review-driven changes to part files).
3. Declare V1 implementation-ready (zero CRITICAL/HIGH gaps or explicit deferrals).
4. **AFMS extraction task:** use the new commons LlamaParse CLI tool to extract the AFMS PDF (50 pages × Agentic tier = 500 credits = ~1.25% of Starter monthly quota; ~$0 incremental cost while inside quota). Output to `assets/afms_extracted/`.
5. **AFMS reconciliation task (CC):** map AFMS sections to Functional Spec sections that should reference or comply with each AFMS §. Produce a coverage table.
6. **V2 patch (small, focused):** add only the AFMS-mandated behaviors not already in V1. Use changebar versioning per claude-conventions §Artifact Conventions (`{name}_changebar.md` + revision history block at top).

### AFMS sections relevant to spec V2

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

AFMS sections to ignore: §1.3 GNSS approvals (regulatory paperwork), §5–6 perf/W&B (airframe-specific), §2.25 placards.

---

## 4. Tooling — pending dependency

A LlamaParse CLI tool is in development under `commons-project/commons/llamaparse-extract/`. V1 of the tool delivered Turn 33; V2 modifications running now (Turn 42).

**For flight-sim purposes, this tool will be used for:**
- Re-extracting GNX 375 Pilot's Guide images for spec illustration assets (deferred from prior session per Approach B image-extraction plan).
- Extracting AFMS PDF (per §3 of this briefing, post-V1).
- Future similar re-extractions if any GNX 375 source documents are added.

**Do not block flight-sim work on tool readiness** — the immediate task is Fragment G + spec assembly + review. Tool will be ready before AFMS-extraction time.

---

## 5. Helper-script work needed before C3 spec review

After Fragment G archives and before C3 spec review:

1. **`scripts/assemble_gnx375_spec.py`** — assemble V1 aggregate from 7 part files using fragment manifest.
2. **`scripts/verify_gnx375_manifest.py`** — manifest pre-flight check per D-22 §6.
3. **`scripts/build_page_number_map.py`** — resolve ITM-11 (physical-vs-logical page offset). Required before C3.
4. **Prepend Review Priority Guide** to V1 aggregate before review (per D-22 §5).
5. **Draft 3 domain-specific Sonnet agents** in `.claude/agents/` (per D-22 §2 customized roster).

---

## 6. Decisions affecting V1 closure (active)

- D-12: GNC 355 → GNX 375 pivot in Appendix A
- D-14: procedural fidelity
- D-15: no internal VDI on GNX 375
- D-16: XPDR three-modes only + external altitude
- D-18: piecewise + manifest delivery
- D-19: fragment line-count ratio (informs overage tracking)
- D-22: C3 spec review customization (six levers) — applies AT C3 review time, not during Fragment G authoring.

---

## 7. Suggested next-session opening

If the C2.2-G CC task has completed and Steve says "continue":

1. Read `docs/tasks/c22_g_completion.md` (if present).
2. Begin Phase 1 of check-completions: cross-reference C2.2-G prompt against completion report.
3. Generate `c22_g_compliance_prompt.md` per Compliance_Verification_Guide.
4. Provide Steve the launch command for the compliance run.

If Steve asks about AFMS integration directly, point at §3 of this briefing for the deferred-V2 plan.

If Steve asks about the LlamaParse tool status, point at §4 — it's a dependency, not a blocker.

---

## 8. Project state at briefing time

- **Current physical date:** 2026-04-25 (Saturday)
- **Active Purple turn count when briefing written:** 48
- **Last commit pushed by Steve:** check `git log -1` for current state
- **Refresh flags:** none expected from this session's CD work; flight-sim CLAUDE.md and conventions files unchanged.
