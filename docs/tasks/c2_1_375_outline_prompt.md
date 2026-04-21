# CC Task Prompt: C2.1-375 — GNX 375 Functional Spec V1 Outline

**Created:** 2026-04-21T11:33:00-04:00
**Source:** CD Purple session — Turn 22 — drafted to action C2.1-375 per D-12 Option 5
**Task ID:** GNX375-SPEC-OUTLINE-01 (Stream C2, sub-task 1 for the 375 primary deliverable)
**Parent reference:** `docs/specs/GNX375_Prep_Implementation_Plan_V2.md` §6.C2.1-375
**Authorizing decisions:** D-11 (outline-first), D-12 (pivot to 375 + Option 5 harvest approach), D-13 (C2.2 format still deferred), D-14 (procedural fidelity additions), D-15 (display architecture — internal vs. external instruments), D-16 (XPDR + ADS-B scope corrections)
**Predecessor task:** GNC355-SPEC-OUTLINE-01 (in `docs/tasks/completed/`) produced the shelved 355 outline that feeds this task as reference material
**Depends on:** Stream A complete (AMAPI ref + A3 use-case index), Stream B complete (B3 pattern catalog, B4 readiness review), C1 PDF extraction complete, harvest map complete (C2.0)
**Priority:** Critical-path — gates the C2.2 format decision and spec body authoring
**Estimated scope:** Medium — ~45–90 min; reads the PDF for [NEW] content, leverages the shelved 355 outline for [FULL]/[PART] content per harvest categorization, produces single outline document
**Task type:** docs-only (no code, no tests)
**CRP applicability:** NO — single phase, single output file, brief duration

---

## Source of Truth (READ ALL OF THESE BEFORE PRODUCING ANY OUTLINE CONTENT)

Three document tiers, to be consulted in the order listed:

### Tier 1 — Authoritative guidance (produced Turns 18–21)

1. **`docs/knowledge/355_to_375_outline_harvest_map.md`** — **PRIMARY CATEGORIZATION GUIDE.** Section-by-section reusability map for transforming the 355 outline into the 375 outline. Legend: [FULL] = verbatim-reusable, [PART] = partially reusable with identified edits, [355] = omit, [NEW] = fresh authoring. Read in full before starting.

2. **`docs/knowledge/gnx375_ifr_navigation_role_research.md`** — Turn 20 research on the 375's display architecture. KEY FINDING: the 375 has NO internal VDI (vertical deviation is output only to external CDI/VDI), and the on-screen CDI is an OPTIONAL small lateral-only indicator. Multiple items in §7 procedural fidelity must be scoped per this document.

3. **`docs/knowledge/gnx375_xpdr_adsb_research.md`** — Turn 21 research on the XPDR + ADS-B content. AUTHORITATIVE for §11 structure (14 sub-sections, finalized). Includes corrections to Turn 18 assumptions (no Ground/Test modes, no Anonymous mode, TSO-C112e not C112d, 18-second IDENT, external altitude source dependency).

### Tier 2 — Reference material (read for [FULL] and [PART] sections)

4. **`docs/specs/GNC355_Functional_Spec_V1_outline.md`** — the shelved 355 outline produced by the predecessor task. For sections marked [FULL] in the harvest map, this document's structure and page references transfer verbatim to the 375 outline. For [PART] sections, this document provides the structural template with identified edits per the harvest map. **Do not re-derive content that [FULL]-categorized sections already provide; copy the structure and update minor language (e.g., scope statements referring to "GNC 355" → "GNX 375" where appropriate).**

5. **`assets/gnc355_pdf_extracted/text_by_page.json`** — the primary PDF content source (310 pages). The Pilot's Guide covers all three units (GPS 175, GNC 355, GNX 375); content is intermixed. Consult specific pages called out in the harvest map or research documents. Read pages in full for [NEW] content (especially pp. 75–82 for §11).

6. **`assets/gnc355_pdf_extracted/extraction_report.md`** — extraction quality notes; flags pages with OCR or structural issues.

7. **`assets/gnc355_reference/land-data-symbols.png`** — curated supplement for page 125.

### Tier 3 — Cross-reference context

8. **`docs/knowledge/amapi_by_use_case.md`** — A3 use-case index for AMAPI capabilities.
9. **`docs/knowledge/amapi_patterns.md`** — B3 pattern catalog.
10. **`docs/knowledge/stream_b_readiness_review.md`** — B4 identifying coverage gaps.
11. **`docs/decisions/D-01-project-scope.md`** (XPL primary + MSFS secondary)
12. **`docs/decisions/D-12-pivot-gnc355-to-gnx375-primary-instrument.md`** (pivot rationale)
13. **`docs/decisions/D-14-procedural-fidelity-coverage-additions-turn-19-audit.md`** (procedural fidelity scope)
14. **`docs/decisions/D-15-gnx375-display-architecture-internal-vs-external-turn-20-research.md`** (display architecture)
15. **`docs/decisions/D-16-gnx375-xpdr-adsb-scope-corrections-turn-21-research.md`** (XPDR + ADS-B scope)
16. **`CLAUDE.md`** (project conventions)
17. **`claude-conventions.md`** §Git Commit Trailers (D-04 commit format)

**Audit level:** standard — CD reviews the outline thoroughly before authorizing C2.2; the format-decision quality depends on outline quality.

---

## Pre-flight Verification

**Execute these checks before reading PDF content. If any fails, STOP and write `docs/tasks/c2_1_375_outline_prompt_deviation.md`.**

1. Verify Tier 1 and Tier 2 source files exist:
   ```bash
   ls docs/knowledge/355_to_375_outline_harvest_map.md
   ls docs/knowledge/gnx375_ifr_navigation_role_research.md
   ls docs/knowledge/gnx375_xpdr_adsb_research.md
   ls docs/specs/GNC355_Functional_Spec_V1_outline.md
   ls assets/gnc355_pdf_extracted/text_by_page.json
   ls assets/gnc355_pdf_extracted/extraction_report.md
   ls assets/gnc355_reference/land-data-symbols.png
   ```

2. Verify `text_by_page.json` structural integrity:
   ```bash
   python3 -c "import json; d = json.load(open('assets/gnc355_pdf_extracted/text_by_page.json')); p = d['pages']; print(f'pages={len(p)}'); print(f'p75_chars={p[74][\"text_char_count\"]}'); print(f'p82_chars={p[81][\"text_char_count\"]}')"
   ```
   Expect 310 pages; p.75 and p.82 should have non-trivial character counts (core XPDR pages).

3. Verify no conflicting outline output exists:
   ```bash
   ls docs/specs/GNX375_Functional_Spec_V1_outline.md
   ```
   Expect FAIL (file should not exist yet). If it exists, STOP and note in deviation report.

4. Skim the harvest map's summary section (category distribution, key structural changes, corrections from Turn 18/19/20/21). These set the scope for the task.

---

## Phase 0: Source-of-Truth Audit

Before producing any outline content:

1. Read all Tier 1 documents in full.
2. Read the shelved 355 outline in full.
3. Read the relevant PDF sections for [NEW] content per the harvest map (especially pp. 75–82 for §11 plus cross-cutting ADS-B content from pp. 18, 225, 244, 282–284, 290).

**Definition — Actionable requirement:** A statement in any Tier 1 or Tier 2 document that, if not reflected in the outline, would make the outline incomplete relative to the D-12 pivot scope + D-14/D-15/D-16 refinements.

4. Extract actionable requirements, with particular attention to:
   - Harvest map categorization for each of the 18 divisions (which sections are [FULL], [PART], [355], [NEW])
   - Harvest map's "375-Needs-New-Content Synthesis" (items 1–25 plus the major new §11)
   - Turn 20 research corrections to items 11, 14, 16, 21, 23, 24 (display-architecture-driven reframings)
   - Turn 21 research finalized §11 structure (14 sub-sections; 4 explicit corrections to Turn 18 assumptions)
   - D-12 Q3c full procedural fidelity target (LPV approach flying)
   - D-14 items (A) XPDR+ADS-B interactions, (B) vertical guidance fidelity, (C) full procedural features
   - Nomenclature correction (GNX 375, not GNC 375) — per D-12 and the amended D-02
   - Family-delta appendix baseline flip (GNX 375 as baseline; GPS 175 and GNC 355 as comparison units)
   - Stream B readiness review's three coverage gaps (applicable to 375 outline where relevant)

5. If ALL covered by your planned outline structure: print "Phase 0: all source requirements covered" and proceed to authoring.
6. If any requirement is uncovered: write `docs/tasks/c2_1_375_outline_prompt_phase0_deviation.md` and STOP.

---

## Instructions

Produce a detailed structural outline for the GNX 375 Functional Spec V1. The outline is the structural blueprint that the C2.2 spec body authoring task will expand into prose. Quality of the outline directly determines quality of the eventual spec.

**Primary output:** `docs/specs/GNX375_Functional_Spec_V1_outline.md`

### Authoring strategy

The 375 outline is NOT authored from scratch. It is transformed from the 355 outline per the harvest map, with [NEW] content authored fresh from the PDF. For each of the 18 divisions:

| Harvest category | Authoring action |
|---|---|
| [FULL] | Copy structure and page references verbatim from the 355 outline; update scope statements to reference GNX 375 as baseline where needed. No re-derivation. |
| [PART] | Copy structure from the 355 outline; apply the identified edits per the harvest map (specific sub-bullets, framing flips, feature-requirement blocks). Keep page references valid; update where the harvest map flags them. |
| [355] | OMIT from the 375 outline entirely. (Do NOT write a placeholder "this section is 355-only, skipped" block — just don't include the section.) |
| [NEW] | Author fresh content from the PDF. For §11 Transponder + ADS-B, follow the Turn 21 research's 14-sub-section structure exactly; use pp. 75–82 of the PDF plus cross-cutting ADS-B content from pp. 18, 225, 244, 282–284, 290. |

### Specific authoring directives by section

**§1 Overview** — [PART]. Flip baseline to GNX 375. Correct TSO reference to **C112e (Level 2els, Class 1)** per Pilot's Guide p. 18 (NOT C112d as Turn 18 harvest map initially listed). Drop the GNC 375 / GNX 375 disambiguation flag (resolved per D-12).

**§2 Physical Layout & Controls** — mostly [FULL]; §2.5 and §2.7 are [PART] (knob push behavior and knob shortcuts differ on 375 vs. 355).

**§3 Power-On, Self-Test, Startup State** — [FULL].

**§4 Display Pages** (sub-sections):
- §4.1 Home Page — [PART]. Add XPDR app icon to Home page app icon inventory.
- §4.2 Map Page — [FULL]. Adjust default user fields (355 defaults were distance/GS/DTK/TRK; 375 defaults differ per 355 outline line 196 — research the PDF to identify 375 defaults, or flag as open question if not documented).
- §4.3 Active Flight Plan (FPL) Page — [PART]. Add GPS NAV Status indicator key (375-only per p. 158); drop Flight Plan User Field (355-only). B4 Gap 2 still applies.
- §4.4 Direct-to Page — [FULL].
- §4.5 Waypoint Information Pages — [FULL]. Minor framing on airport Weather tab (built-in ADS-B vs. external).
- §4.6 Nearest Pages — [FULL].
- §4.7 Procedures Pages — [FULL] structure with light additions noting XPDR-interaction open questions (interleave with §7 content).
- §4.8 Planning Pages — [FULL].
- §4.9 Hazard Awareness Pages — [PART]. Major framing flip: 355's "requires external ADS-B receiver" becomes 375's "built-in dual-link receiver." TSAA with aural alerts (375-only capability).
- §4.10 Settings and System Pages — [PART]. Add CDI On Screen [p. 89] feature; reframe ADS-B Status [pp. 107–108] for built-in receiver; add 375 traffic logging.
- §4.11 COM Standby Control Panel — **[355] OMIT ENTIRELY.** The 375 has no COM and no analogous persistent overlay.
- **Possible new §4.x dedicated to XPDR display integration** — consult PDF p. 75 context to determine whether the XPDR Control Panel fits under §4 (as a display page) or under §11 (as an operational section). Recommended: treat the XPDR Control Panel as an integral part of §11 and reference from §4.1 Home Page app icon inventory only.

**§5 Flight Plan Editing** — [FULL].

**§6 Direct-to Operation** — [FULL].

**§7 Procedures** — [PART] with substantial augmentations per D-14 and D-15. Sub-sections 7.1–7.8 transfer structurally from 355. Add new content per the harvest map's procedural fidelity augmentations list (items 11–25 as corrected by Turn 20 research):

  Per D-15, CDI/VDI coverage requires the two-mode (on-screen-optional + external-primary) framing:
  - Item 11 (VDI) is DROPPED as on-screen; relocated to §15 I/O as output contract.
  - Item 23 (CDI) is a small on-screen lateral indicator + primary external CDI.
  - Item 24 (TO/FROM) is the annunciator-bar FROM/TO field + external CDI output.

  Per D-14, the LPV-approach-flying target requires:
  - Item 17 Turn anticipation / "Time to Turn" advisory with 10-second countdown (CONFIRMED at pp. 200, 202).
  - Items 12–16 vertical guidance fidelity with the D-15 corrections.
  - Items 18–22, 25 waypoint sequencing and procedural features.

  Item 21 (altitude constraints): **REFRAME AS OPEN QUESTION** — not documented in the extracted PDF. Do not speculate; flag as "behavior unknown from available documentation; research needed."

**§8 Nearest Functions** — [FULL].

**§9 Waypoint Information Pages** — [FULL].

**§10 Settings / System Pages** — [PART]. Add CDI On Screen (per §4.10); reframe ADS-B Status; add 375 traffic logging; possibly new XPDR configuration sub-section (10.14 or merged into §11).

**§11 Transponder + ADS-B Operation** — **[NEW]**. **Follow the Turn 21 research document's finalized 14-sub-section structure EXACTLY.** Do not invent sub-sections. Do not include Ground, Test, or Anonymous modes (they don't exist on GNX 375). Do not make Flight ID editability a core feature (it's configuration-dependent). TSO is C112e, IDENT is 18 seconds, altitude source is external. Remote G3X Touch control gets the "out of scope for v1 instrument" flag.

**§12 Audio, Alerts, and Annunciators** — [PART]. Flip §12.4 aural-alerts framing (present on 375). Drop §12.9 COM annunciations; replace with §12.9 XPDR annunciations (squawk code, mode, Reply (R), IDENT, failure "X").

**§13 Messages** — [PART]. Drop §13.9 COM radio advisories; replace with §13.9 XPDR advisories sourced from pp. 283–284, 290 (9 applicable advisory conditions per Turn 21 research). Reframe §13.11 Traffic System Advisories for the 375's ADS-B In (built-in receiver advisory set).

**§14 Persistent State** — [PART]. Drop §14.1 COM State; replace with §14.1 XPDR State (squawk code, mode, Flight ID if configurable, ADS-B Out enable, data field preference).

**§15 External I/O** — [PART]. Drop COM-specific datarefs/events; add XPDR + ADS-B datarefs/events. Add altitude source dependency (per Turn 21 research; the 375's XPDR requires external ADC/ADAHRS for pressure altitude per p. 34). Add output contract for external CDI/VDI/HSI (per D-15: lateral deviation, vertical deviation, course, roll steering). Dataref/variable exact names remain open questions for design phase.

**Appendix A: Family Delta** — [PART] with substantial flip. GNX 375 becomes baseline. Comparison units are GPS 175 and GNC 355/355A. Drop the GNC 375/GNX 375 disambiguation flag. 355-baseline content is preserved in the shelved 355 outline for eventual 355 resumption.

**Appendix B: Glossary and Abbreviations** — [FULL] with additions for 375 terms (Mode S, 1090 ES, UAT, Extended Squitter, Flight ID, squawk code, IDENT, TSAA, FIS-B, TIS-B).

**Appendix C: Extraction Gaps** — [FULL] structure with updates. Verify whether pp. 75–85 appear in the sparse-pages list from `extraction_report.md`; if any do, note the impact on §11. Drop the GNC 375/GNX 375 disambiguation gap (resolved).

### Hard constraints

- The outline file is a complete document — provenance header, all sections, all appendices. Not a partial draft.
- Do NOT begin writing prose for any section. The outline is structural only. Sub-bullets are noun phrases / topic descriptors, not full sentences. Resist the temptation to "just sketch a paragraph."
- Do NOT specify an internal VDI / glidepath needle / glideslope needle for the 375 (per D-15, only external CDI/VDI displays provide vertical deviation indications).
- Do NOT include Ground mode, Test mode, or Anonymous mode under §11 (per D-16, they do not exist on the 375).
- Do NOT speculate about altitude constraints on flight plan legs (item 21) — flag as open question.
- Do NOT speculate about ARINC 424 leg types beyond what the 355 outline and PDF actually document — flag as open question.
- Cite source pages liberally and accurately. A wrong page reference in the outline becomes a wrong page reference in the spec body; verify with the PDF JSON.
- Maintain the harvest map's [FULL]/[PART]/[355]/[NEW] categorization faithfully. Do not promote or demote sections between categories without explicit rationale.
- If the PDF content for a section is genuinely sparse or absent, say so explicitly in the section's "Open questions / flags" — do NOT pad the outline to make sections look balanced.

### The six known open research questions (flag; do NOT resolve)

Per D-15 and D-16, the following remain unresolved from the available PDF content. Flag each in the appropriate section's "Open questions / flags" block but do NOT speculate:

1. **Altitude constraints on flight plan legs** — §7 or §4.3. "Whether the 375 automatically displays published procedure altitude restrictions (cross at/above/below/between) is not documented in the extracted PDF. VCALC is a separate pilot-input planning tool. Behavior unknown; research needed during design phase."
2. **ARINC 424 leg type enumeration** — §7.5 or §7.8. "The Pilot's Guide mentions TF, CF, DF, RF legs among examples but does not enumerate the full set of supported leg types. Research needed or flag as limited-source feature."
3. **Fly-by vs. fly-over turn geometry** — §4.3 or §7. "Pilot's Guide p. 157 references the Fly-over Waypoint Symbol; behavioral turn-geometry details (anticipation distance, corner-cutting algorithm) are not prominently documented. Research needed."
4. **Exact XPL dataref names** — §15. "XPL dataref names for XPDR, ADS-B, CDI source, flight phase, vertical deviation require verification during design phase (XPL datareftool output or official Garmin avionics reference)."
5. **MSFS SimConnect variable behavior** — §15. "MSFS XPDR SimConnect variables and events differ between FS2020 and FS2024; Pattern 23 (FS2024 B: event dispatch) may apply. Exact variable names and behavior require design-phase research."
6. **TSAA aural alert delivery mechanism** — §4.9 or §11.11. "Whether the 375 instrument emits aural alerts via `sound_play` directly or depends on an external audio panel integration is a spec-body design decision. Behavior TBD."

### Outline document structure

```markdown
---
Created: <ISO 8601>
Source: docs/tasks/c2_1_375_outline_prompt.md
---

# GNX 375 Functional Spec V1 — Detailed Outline

**Purpose:** Structural blueprint for C2.2 spec body authoring. See D-11 for the outline-first approach rationale. Primary instrument pivot from GNC 355 per D-12; scope expanded for XPDR + ADS-B + full procedural fidelity per D-12 Q3c.
**Source content:** `assets/gnc355_pdf_extracted/text_by_page.json` (310 pages; Pilot's Guide 190-02488-01 Rev. C covers GPS 175, GNC 355/355A, and GNX 375)
**Harvest basis:** `docs/knowledge/355_to_375_outline_harvest_map.md` (Turn 18 categorization + Turn 20/21 research corrections)
**Research references:** `docs/knowledge/gnx375_ifr_navigation_role_research.md` (display architecture), `docs/knowledge/gnx375_xpdr_adsb_research.md` (XPDR + ADS-B scope)
**Estimated total spec length:** <your estimate; harvest map anticipates ~2,800–2,900 lines>
**Format recommendation for C2.2:** <your recommendation: monolithic CRP / piecewise+manifest / one-task-per-section> with rationale referencing outline size, cross-section coupling, and largest section

## Outline navigation aids

- **Section count:** N top-level + M appendices
- **Largest sections (by estimate):** [list top 3]
- **Sections with significant coverage gaps:** [list any sections where PDF content is thin or extraction flagged issues; include the 6 open research questions]
- **Summary of pivot/research-driven changes from the 355 outline:** [2–4 sentences summarizing the major structural differences per harvest map and research documents]

---

## 1. <Section title>

**Scope.** <2–4 sentences>

**Source pages.** [pp. X–Y]

**Estimated length.** ~N lines

**Sub-structure:**
- 1.1 <subsection title> [pp. X–Y, ~M lines]
  - <topic bullet> [pp. X]
  - <topic bullet> [pp. X]
- 1.2 <subsection title> [pp. X–Y, ~M lines]

**AMAPI knowledge cross-refs.**
- [link to relevant Pattern in B3 or use-case section in A3 — placeholders only, not expanded]

**Open questions / flags.**
- [any ambiguity, missing content, extraction issue, or one of the 6 known open questions]

---
```

The "Format recommendation for C2.2" field at the top is what closes the loop with D-13. CD will use it as input to the format-decision turn.

---

## Completion Protocol

1. **Verify report claims against actual state** (per D-08 — re-run any `wc -l`, `grep -c`, etc. commands at the moment of writing the completion report; do not carry numbers from earlier in the session).

2. Verify outputs exist:
   - `docs/specs/GNX375_Functional_Spec_V1_outline.md` (the primary output)

3. Spot-check page references: pick 5 section sub-bullets at random (at least one from §11 [NEW] content); verify the cited PDF page numbers actually contain content matching the topic. Record results in the completion report.

4. Verify harvest-map fidelity: for 3 random [PART] sections, confirm the identified edits per the harvest map are actually applied in the 375 outline. For 1 random [355] section, confirm it's fully omitted (not present as a placeholder).

5. Verify the 6 open research questions are flagged (not resolved): grep the outline for the key phrases ("altitude constraint", "ARINC 424", "fly-over", "XPL dataref", "MSFS ", "TSAA aural") and confirm each has an "Open questions / flags" entry rather than a speculative specification.

6. Write completion report `docs/tasks/c2_1_375_outline_completion.md` with:
   - Provenance header (Created, Source)
   - Pre-flight verification results
   - Phase 0 audit results
   - Outline summary metrics: section count, total estimated spec length, largest sections
   - Format recommendation summary (1–2 paragraphs — same as in the outline header but with completion-report context)
   - Page-reference spot-check results (5 random checks with at least one from §11)
   - Harvest-map fidelity check results (3 [PART] + 1 [355] confirmation)
   - Open-question flag check results (6 items confirmed flagged)
   - Coverage flags: count of sections with "Open questions / flags" entries, summary of the most significant flags
   - Any deviations from this prompt with rationale

7. Commit using the D-04 trailer format. Write the commit message to a temp file via `[System.IO.File]::WriteAllText()` (BOM-free) and use `git commit -F <file>`. Message structure:
   ```
   GNX375-SPEC-OUTLINE-01: GNX 375 Functional Spec V1 detailed outline

   Outline-first sub-task per D-11, scoped to GNX 375 per D-12 pivot
   (Option 5: harvest 355 outline + author dedicated 375 outline).
   Structure follows the harvest map categorization [FULL]/[PART]/[355]/[NEW]
   with research-driven corrections per D-15 (display architecture —
   no internal VDI, external CDI primary) and D-16 (XPDR + ADS-B scope
   — 3 modes only, no Anonymous mode, TSO-C112e, 18-second IDENT).

   Full procedural fidelity target per D-12 Q3c and D-14 items 11–25
   (as corrected by Turn 20/21 research). Six open research questions
   flagged but not resolved.

   Section count: <N>
   Estimated total spec length: <X> lines
   Format recommendation: <choice>

   Task-Id: GNX375-SPEC-OUTLINE-01
   Authored-By-Instance: cc
   Refs: D-11, D-12, D-14, D-15, D-16, GNX375_Prep_Implementation_Plan_V2, GNC355-SPEC-OUTLINE-01
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

   Use the file-based commit pattern (NOT multi-`-m`):
   ```powershell
   $msg = @'
   ...message above...
   '@
   [System.IO.File]::WriteAllText((Join-Path $PWD ".git\COMMIT_EDITMSG_cc"), $msg)
   git commit -F .git\COMMIT_EDITMSG_cc
   Remove-Item .git\COMMIT_EDITMSG_cc
   ```

8. **Flag refresh check:** This task does not modify `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`. Do NOT create refresh flags.

9. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-OUTLINE-01 completed [flight-sim]"
   ```

10. **Do NOT git push.** Steve pushes manually.

---

## What This Unblocks

- CD review of the 375 outline (next CD turn after this task's archive)
- D-13's format decision for C2.2 (monolithic CRP / piecewise+manifest / per-section), now grounded in the actual 375 outline
- C2.2 task prompt drafting (CD turn following format decision)
- Eventually: C2.2 execution → C3 spec-review → C4 iteration → implementation-ready V_n → GNX 375 design phase → implementation

---

## Rationale Notes (informational)

- **Why harvest-based authoring:** per D-12 Option 5, the 355 outline contains ~75% unit-agnostic content. Re-deriving that content from the PDF would waste work and risk inconsistencies between the shelved 355 outline and the 375 outline. Transforming per the harvest map is faster and more faithful.
- **Why research-document-first:** Turns 20 and 21 surfaced corrections to Turn 18 assumptions (no internal VDI, no Ground/Test modes, no Anonymous mode, etc.). Without these corrections, the 375 outline would have over-specified features the unit doesn't have.
- **Why don't resolve the 6 open questions:** they're outside the PDF's coverage. Speculating would embed incorrect assumptions in the spec; flagging preserves the epistemic state for the design-phase to resolve with authoritative references (XPL datareftool, Garmin avionics reference, sim-specific documentation).
- **Why §11 structure is authoritative:** Turn 21 research read the actual XPDR pages in full and cross-referenced with the advisory message tables. The 14-sub-section structure is grounded in the Pilot's Guide, not speculation.
- **Why don't specify on-screen VDI:** Pilot's Guide p. 205 is explicit: "Only external CDI/VDI displays provide vertical deviation indications." Specifying an on-375 VDI would contradict the authoritative reference.
