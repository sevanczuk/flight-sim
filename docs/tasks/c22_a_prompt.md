# CC Task Prompt: C2.2-A — GNX 375 Functional Spec V1 Fragment A (§§1–3 + Appendices B, C)

**Created:** 2026-04-21T14:00:00-04:00
**Source:** CD Purple session — Turn 31 — first of 7 piecewise fragments per D-18
**Task ID:** GNX375-SPEC-C22-A (Stream C2, sub-task 2A for the 375 primary deliverable)
**Parent reference:** `docs/decisions/D-18-c22-format-decision-piecewise-manifest.md` §"Task partition"
**Authorizing decisions:** D-11 (outline-first), D-12 (pivot to 375), D-13 (superseded by D-18), D-14 (procedural fidelity), D-15 (display architecture), D-16 (XPDR + ADS-B scope), D-18 (piecewise format + 7-task partition)
**Predecessor task:** GNX375-SPEC-OUTLINE-01 (in `docs/tasks/completed/`) produced the authoritative outline that drives this task
**Depends on:** C2.1-375 outline complete (✅ archived Turn 29), D-18 format decision (✅ Turn 30)
**Priority:** Critical-path — first of 7 fragments; sets template for remaining 6
**Estimated scope:** Medium — ~60–90 min; authors ~445 lines across 5 distinct sections (§1 ~50, §2 ~150, §3 ~80, Appendix B ~65, Appendix C ~35, plus fragment header and structure) from outline and harvest-map inputs
**Task type:** docs-only (no code, no tests)
**CRP applicability:** NO — single phase, single output file

---

## Source of Truth (READ ALL OF THESE BEFORE AUTHORING ANY SPEC BODY CONTENT)

### Tier 1 — Authoritative content source

1. **`docs/specs/GNX375_Functional_Spec_V1_outline.md`** — **THE PRIMARY BLUEPRINT.** This is the authoritative outline produced by GNX375-SPEC-OUTLINE-01. For C2.2-A, authoritative content comes from:
   - The outline header (pp. 1–26): format decision + navigation aids
   - §1 Overview (~50 lines estimated; sub-sections 1.1–1.4)
   - §2 Physical Layout & Controls (~150 lines estimated; sub-sections 2.1–2.9)
   - §3 Power-On, Self-Test, and Startup State (~80 lines estimated; sub-sections 3.1–3.5)
   - Appendix B: Glossary and Abbreviations (~65 lines estimated; B.1 Pilot's Guide terms + B.1 additions for XPDR/ADS-B + B.2 AMAPI + B.3 Garmin-specific)
   - Appendix C: Extraction Gaps and Manual-Review-Required Pages (~35 lines estimated; C.1 sparse pages + C.2 content gaps + C.3 summary)

   **Do not deviate from the outline's section numbering, sub-structure, or page references.** The outline is the contract; this task expands it into prose.

2. **`docs/decisions/D-18-c22-format-decision-piecewise-manifest.md`** — **format contract.** Defines:
   - Fragment file conventions (path, YAML front-matter, heading levels, line-count target)
   - Coupling Summary convention (what backward/forward refs to note and how)
   - Why Appendix B lives in C2.2-A (not C2.2-G): so later tasks can reference glossary terms without forward-refs
   - Read §"Fragment file conventions" and §"Coupling summary convention" before starting authoring.

### Tier 2 — PDF source material (authoritative for content details)

3. **`assets/gnc355_pdf_extracted/text_by_page.json`** — the primary PDF content source (310 pages). For C2.2-A, the relevant pages are:
   - §1 Overview: pp. 18–20
   - §2 Physical Layout & Controls: pp. 21–32 (bezel, SD, touchscreen, keys, knobs, locater bar, screenshots, colors)
   - §3 Power-On / Database: pp. 38–52 (startup, self-test, fuel preset, power-off, database loading/update/sync/Concierge)
   - Appendix B Glossary: pp. 299–304
   - Appendix C: `assets/gnc355_pdf_extracted/extraction_report.md` + pages noted in outline §Appendix C.1

   Read these pages (JSON `pages[N-1]` indexed from 0) when authoring to confirm specific facts (e.g., exact bezel component lists, SD card capacity range, mode-state descriptions). **The outline already cites specific page numbers — honor those citations in the spec body.**

4. **`assets/gnc355_pdf_extracted/extraction_report.md`** — extraction quality notes. Required reading for Appendix C (§C.1 sparse pages list).

5. **`assets/gnc355_reference/land-data-symbols.png`** — supplement for p. 125 (NOT relevant to C2.2-A directly; §4.2 in C2.2-B will reference it). Appendix C.1 mentions it exists; do not duplicate coverage.

### Tier 3 — Cross-reference context

6. **`docs/knowledge/355_to_375_outline_harvest_map.md`** — harvest categorization. For C2.2-A, the relevant categorizations are:
   - §1: [PART] — TSO correction, baseline flip, XPDR scope mentions
   - §2: [PART] — knob behavior differences (inner knob push = Direct-to, not COM standby)
   - §3: [FULL] — startup and database behavior identical across all three units
   - Appendix B: [NEW additions] — 11 XPDR/ADS-B terms added to 355 glossary baseline
   - Appendix C: [PART] — disambiguation gap dropped per D-12

7. **`docs/specs/GNC355_Functional_Spec_V1_outline.md`** — the shelved 355 outline. For [FULL] §3 content, the 355 outline's §3 structure transfers verbatim (only the introductory scope sentence needs the unit name updated). Useful reference; not authoritative (the 375 outline is).

8. **`docs/knowledge/amapi_by_use_case.md`** — A3 use-case index. The outline's "AMAPI cross-refs" bullets cite specific sections from this file. When transcribing these cross-refs to the spec body, verify the referenced sections exist.

9. **`docs/knowledge/amapi_patterns.md`** — B3 pattern catalog. Same as above: the outline cites specific Pattern numbers; verify they exist when authoring.

10. **`docs/decisions/D-01-project-scope.md`** — XPL primary + MSFS secondary
11. **`docs/decisions/D-12-pivot-gnc355-to-gnx375-primary-instrument.md`** — pivot rationale (referenced in §1.3 scope)
12. **`docs/decisions/D-15-gnx375-display-architecture-internal-vs-external-turn-20-research.md`** — referenced in outline's navigation aids header for VDI constraint (not directly relevant to §§1–3 body content but may be mentioned in §1 scope)
13. **`docs/decisions/D-16-gnx375-xpdr-adsb-scope-corrections-turn-21-research.md`** — referenced in §1.1 for TSO-C112e correction

14. **`CLAUDE.md`** (project conventions, commit format, ntfy requirement)
15. **`claude-conventions.md`** §Git Commit Trailers (D-04)

**Audit level:** standard — CD will check completions and run a compliance verification modeled on the C2.1-375 compliance approach (17-item check). This is the first C2.2 fragment, so the compliance bar is higher than subsequent fragments (which will benefit from template reuse).

---

## Pre-flight Verification

**Execute these checks before authoring any fragment content. If any fails, STOP and write `docs/tasks/c22_a_prompt_deviation.md`.**

1. Verify Tier 1 and Tier 2 source files exist:
   ```bash
   ls docs/specs/GNX375_Functional_Spec_V1_outline.md
   ls docs/decisions/D-18-c22-format-decision-piecewise-manifest.md
   ls assets/gnc355_pdf_extracted/text_by_page.json
   ls assets/gnc355_pdf_extracted/extraction_report.md
   ```

2. Verify outline integrity (1,477 lines expected per C2.1-375 archive):
   ```bash
   wc -l docs/specs/GNX375_Functional_Spec_V1_outline.md
   ```
   Expect exactly 1,477 lines.

3. Verify `text_by_page.json` structural integrity:
   ```bash
   python3 -c "import json; d = json.load(open('assets/gnc355_pdf_extracted/text_by_page.json')); p = d['pages']; print(f'pages={len(p)}'); print(f'p18_chars={p[17][\"text_char_count\"]}'); print(f'p21_chars={p[20][\"text_char_count\"]}'); print(f'p38_chars={p[37][\"text_char_count\"]}'); print(f'p299_chars={p[298][\"text_char_count\"]}')"
   ```
   Expect 310 pages; p. 18 (Overview), p. 21 (bezel components), p. 38 (power-up), p. 299 (glossary start) should all have non-trivial character counts.

4. Verify no conflicting fragment output exists:
   ```bash
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md 2>/dev/null
   ```
   Expect failure (file should not exist yet). If it exists, STOP and note in deviation report.

5. Verify the `docs/specs/fragments/` directory either doesn't exist yet (you'll create it) or is empty:
   ```bash
   ls docs/specs/fragments/ 2>/dev/null
   ```
   If the directory exists and contains files, STOP and note in deviation report.

---

## Phase 0: Source-of-Truth Audit

Before authoring any spec body content:

1. Read all Tier 1 documents in full (outline, D-18).
2. Read the outline sections for §§1, 2, 3, Appendix B, Appendix C in full — these define scope.
3. Read the PDF pages listed in outline sub-section `[pp. N]` citations (primarily pp. 18–32 for §§1–2; pp. 38–52 for §3; pp. 299–304 for Appendix B; extraction_report.md for Appendix C).
4. Read `docs/knowledge/355_to_375_outline_harvest_map.md` §§ covering the sections assigned to this task.

**Definition — Actionable requirement:** A statement in the outline or an authorizing decision that, if not reflected in the fragment, would make the fragment incomplete relative to what C2.2-B through C2.2-G depend on. Includes: glossary terms that later fragments will reference, framing decisions (GNX 375 as baseline, TSO-C112e not C112d, inner knob push = Direct-to), and Appendix C extraction gap inventory.

5. Extract actionable requirements. Particular attention to:
   - §1 Overview: TSO-C112e (per D-16, NOT C112d); GNX 375 as baseline; scope excludes pilot technique/aeronautical guidance/MSFS implementation details per D-01; 1090 ES + dual-link ADS-B In framing; sibling-unit relationships (GPS 175, GNC 355/355A)
   - §2 Physical Layout: knob behavior differences (inner knob push = Direct-to on GNX 375 / GPS 175; NOT COM standby tuning); locater bar (Slot 1 Map fixed, Slots 2–3 user-configurable); color conventions; touchscreen gestures; NO reference to COM volume or COM standby frequency tuning as present behaviors
   - §3 Power-On: startup sequence; self-test; preset fuel quantities; power-off press-and-hold; database loading/update/sync/Concierge; FAT32 8–32 GB SD requirement
   - Appendix B Glossary: all 11 XPDR/ADS-B terms per outline (Mode S, Mode C, 1090 ES, UAT, Extended Squitter, TSAA, FIS-B, TIS-B, Flight ID, squawk code, IDENT, WOW, Target State and Status, TSO-C112e, TSO-C166b); plus 355-carryover aviation abbreviations from Pilot's Guide Glossary (pp. 299–304); plus AMAPI terms (B.2); plus Garmin-specific terms (B.3)
   - Appendix C Extraction Gaps: sparse pages list from extraction_report.md (pp. 1, 36, 110, 125, 208, 222, 270, 271, 292, 298, 308, 309, 310); XPDR pages pp. 75–82 verified CLEAN (not in sparse list); content gaps (6 open research questions, 4 design decision gaps, 1 significant content gap for p. 125); disambiguation gap DROPPED per D-12

6. If ALL requirements are covered by your planned fragment structure: print "Phase 0: all source requirements covered" and proceed to authoring.
7. If any requirement is uncovered: write `docs/tasks/c22_a_prompt_phase0_deviation.md` and STOP.

---

## Instructions

Produce the first fragment of the GNX 375 Functional Spec V1 body: the foundation sections (§§1–3) plus the appendices that establish cross-reference scaffolding for later fragments (Appendix B Glossary, Appendix C Extraction Gaps).

**Primary output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`

### Authoring strategy

For each section, the outline provides the structural skeleton (scope, source pages, estimated length, sub-structure bullets, AMAPI cross-refs, open questions). Your job is to **expand each outline bullet into prose that a spec reader can actually implement from, while preserving the outline's structure, page references, and cross-references.**

#### Authoring depth guidance

- **Scope paragraphs:** 2–4 sentences per section. State what the section covers, what it excludes, and any key framing decisions (e.g., "§2 documents the hardware interface for the GNX 375; knob behavior differs from GNC 355 in that the inner knob push enters Direct-to rather than COM standby tuning.").

- **Sub-section prose:** each outline bullet (e.g., "2.1 Bezel components [p. 21]") should become a short sub-section (5–15 lines typical) with the bullet points expanded into prose or preserved as a refined list where enumeration is natural (color conventions, SD card requirements, database types). Preserve the source-page citations.

- **Tables:** use tables where the content is naturally tabular (unit feature comparison in §1.2; mode characteristics in §2 knob mode sequence; database types in §3.5).

- **AMAPI cross-refs:** at the end of each sub-section that has AMAPI implications, include an "AMAPI notes" block citing the specific `amapi_by_use_case.md` section or `amapi_patterns.md` pattern number. Do not expand the AMAPI content here — that's the design-spec's job. Just cite.

- **Open questions / flags:** preserve any outline flags as "Open questions" sub-bullets at the end of the relevant sub-section. Use the same non-speculative language the outline uses ("behavior unknown", "research needed during design phase", "spec-body design decision").

- **Cross-references to other fragments:** use the Coupling Summary convention from D-18. For §§1–3 + Appendices B, C, no backward-refs exist (this is the first fragment). Forward-refs use the "see §N.x" pattern without further qualification; later fragments will author the targets.

#### Fragment file conventions (per D-18)

- **Path:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`
- **Create the `docs/specs/fragments/` directory if it does not exist.**
- **YAML front-matter (required):**
  ```yaml
  ---
  Created: 2026-04-21T{HH:MM:SS}-04:00
  Source: docs/tasks/c22_a_prompt.md
  Fragment: A
  Covers: §§1–3 + Appendix B + Appendix C
  ---
  ```
- **Heading levels:**
  - `# GNX 375 Functional Spec V1 — Fragment A` — fragment header (repeats across fragments; manifest will strip on assembly)
  - `## 1. Overview`, `## 2. Physical Layout & Controls`, `## 3. Power-On, Self-Test, and Startup State`, `## Appendix B: Glossary and Abbreviations`, `## Appendix C: Extraction Gaps and Manual-Review-Required Pages` — top-level sections
  - `### 1.1 Product description and family placement [p. 18]` — sub-sections (note: Pilot's Guide page refs in square brackets per outline convention)
- **Line count target:** ~445 lines (per D-18 partition table). Under-delivery (<400) is a completion-report finding; significant over-delivery (>550) warrants reassessment of whether content creep happened.

#### Specific framing commitments

These are **hard constraints** that must appear in the fragment:

1. **TSO-C112e, Level 2els, Class 1** — §1.1 product description. Not TSO-C112d.
2. **GNX 375 = baseline** — §1 framing throughout. GPS 175 and GNC 355/355A are the comparison units.
3. **No internal VDI** — any §1 scope mention of vertical deviation must note that the GNX 375 has no on-screen VDI; vertical deviation is output to external CDI/VDI only. (Per D-15.) This may be mentioned briefly in §1.3 scope; the full treatment is in §7 (C2.2-D) and §15 (C2.2-G).
4. **Inner knob push = Direct-to** on the GNX 375 (and GPS 175). NOT COM standby tuning (that's GNC 355/355A behavior).
5. **No COM radio on GNX 375** — §§1, 2 must not describe COM features as present on the GNX 375. May reference "the GNC 355 adds a VHF COM radio" as a sibling-unit comparison; never state the GNX 375 has COM.
6. **Appendix B — 11 XPDR/ADS-B terms required** (per outline §B.1 additions): Mode S, Mode C, 1090 ES, UAT, Extended Squitter, TSAA, FIS-B, TIS-B, Flight ID, squawk code, IDENT. Plus these additional terms already listed in outline: WOW, Target State and Status, TSO-C112e, TSO-C166b. Total: at least 15 XPDR/ADS-B-related entries.
7. **Appendix C — disambiguation gap DROPPED** per D-12; do not include a "GNC 375 vs. GNX 375 disambiguation" entry as an active gap. May reference it as "resolved per D-12; formerly flagged" if you want historical context.
8. **Appendix C — XPDR pages pp. 75–82 are CLEAN** (not in the sparse list). Note this explicitly in §C.1 because later fragments (C2.2-F for §11) depend on this.

#### Per-section page budget (informative)

| Section | Outline estimate | Fragment prose target |
|---------|------------------|------------------------|
| Fragment header + YAML + scope intro | — | ~10 |
| §1 Overview | ~50 | ~55 |
| §2 Physical Layout & Controls | ~150 | ~165 |
| §3 Power-On, Self-Test, Startup | ~80 | ~90 |
| Appendix B | ~65 | ~75 |
| Appendix C | ~35 | ~40 |
| Inter-section spacing + horizontal rules | — | ~10 |
| **Total target** | **~380** | **~445** |

The ~65-line buffer over the outline sum accounts for fragment header, sub-section prose expansion, and Coupling Summary block (below). Prose expansion averages ~1.15× the outline estimate.

#### Coupling Summary block

At the end of the fragment (after Appendix C), include a **Coupling Summary** section per D-18:

```markdown
---

## Coupling Summary

This section is authored per D-18 for CD/CC coordination across the 7-fragment spec. It is not part of the spec body and is stripped on assembly.

### Backward cross-references (sections this fragment references that were authored in prior fragments)

None. Fragment A is the first piece.

### Forward cross-references (sections this fragment writes that later fragments will reference)

- §1.4 "See Appendix A for family-delta details" → Appendix A is authored in Fragment G (C2.2-G).
- §2.5, §2.7 knob shortcuts reference Direct-to workflow → §6 Direct-to Operation in Fragment D (C2.2-D).
- §3.5 database sync mentions crossfill → §10.9 Crossfill in Fragment E (C2.2-E).
- Appendix B glossary terms used by all later fragments.

### Outline coupling footprint

This fragment draws from outline §§1, 2, 3, Appendix B, Appendix C. No content from §§4–15 or Appendix A is authored here.
```

---

## Integration Context

- **Primary output file:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` (new)
- **Directory to create if needed:** `docs/specs/fragments/`
- **No code modification in this task.** Docs-only.
- **No test suite run required.** Docs-only.
- **Do not modify the outline.** The outline at `docs/specs/GNX375_Functional_Spec_V1_outline.md` is archival. If you spot outline errors during authoring, note them in the completion report's Deviations section.
- **Do not modify the manifest yet.** The manifest at `docs/specs/GNX375_Functional_Spec_V1.md` will be created by CD after this task archives (per D-18). C2.2-A is not responsible for manifest authoring.

---

## Implementation Order

**Execute phases sequentially. Do not parallelize phases or launch subagents.**

### Phase A: Read and audit (Phase 0 per above)

Read all Tier 1 and Tier 2 sources. Extract actionable requirements. Confirm coverage. Print the Phase 0 completion line OR write the Phase 0 deviation report and STOP.

### Phase B: Create fragment file skeleton

1. Create `docs/specs/fragments/` directory if it does not exist.
2. Create the fragment file with YAML front-matter, fragment header, and section headers (`## 1.`, `## 2.`, `## 3.`, `## Appendix B:`, `## Appendix C:`).
3. Add the Coupling Summary placeholder at the end.

### Phase C: Author §1 Overview (~55 lines)

Expand outline §1 sub-structure into prose. Structure:
- §1.1 Product description and family placement — TSO-C112e, form factor, key capabilities, sibling placement
- §1.2 Unit feature comparison — concise table covering GPS 175 / GNC 355/355A / GNX 375 rows
- §1.3 Scope of this spec — covers/excludes list; reference to D-01 + D-12 for context
- §1.4 How to read this spec — the "GNX 375 only" marker convention; Appendix A pointer

### Phase D: Author §2 Physical Layout & Controls (~165 lines)

Expand outline §2 sub-structure into prose. Structure:
- §2.1 Bezel components
- §2.2 SD card slot operations
- §2.3 Touchscreen gestures
- §2.4 Keys and UI primitives
- §2.5 Control knob functions (honor [PART vs. GNC 355] framing)
- §2.6 Page navigation labels (locater bar)
- §2.7 Knob shortcuts (honor [PART vs. GNC 355] framing — inner knob push = Direct-to)
- §2.8 Screenshots
- §2.9 Color conventions

Include AMAPI notes blocks at the end of sub-sections where the outline cites them (§2.3 touchscreen → Pattern 4; §2.5 knobs → Patterns 11, 15, 20, 21; §2.9 colors → N/A).

### Phase E: Author §3 Power-On, Self-Test, and Startup State (~90 lines)

Expand outline §3 sub-structure into prose. This is [FULL]-categorized (identical behavior across all three units); structure transfers cleanly from the 355 outline with scope-paragraph adjustments for unit-agnostic language.

- §3.1 Power-up sequence
- §3.2 Instrument panel self-test
- §3.3 Preset fuel quantities
- §3.4 Power-off
- §3.5 Database loading and management (longest sub-section; covers database types, active/standby, manual updates, automatic updates, Database Concierge, Database SYNC)

### Phase F: Author Appendix B Glossary (~75 lines)

Structure per outline:
- B.1 Aviation abbreviations from Pilot's Guide Glossary (pp. 299–304) — at least 20 key abbreviations; define each in 1 line (e.g., "**CDI** — Course Deviation Indicator. Displays lateral deviation from desired course.")
- B.1 additions for GNX 375 XPDR/ADS-B terms — all 15 terms per outline (Mode S, Mode C, 1090 ES, UAT, Extended Squitter, TSAA, FIS-B, TIS-B, Flight ID, squawk code, IDENT, WOW, Target State and Status, TSO-C112e, TSO-C166b). 1–2 line definitions each.
- B.2 AMAPI-specific terms (Air Manager, AMAPI, dataref, persist store, canvas, dial, button_add, triple-dispatch)
- B.3 Garmin-specific terms (FastFind, Connext, SafeTaxi, Smart Airspace, CDI On Screen, GPS NAV Status indicator key)

Glossary entries should be short and informational. This appendix is a reference resource; later fragments will cite terms defined here.

### Phase G: Author Appendix C Extraction Gaps (~40 lines)

Structure per outline:
- C.1 Sparse pages list — enumerate the 13 pages from extraction_report.md with 1-line impact notes. Emphasize p. 125 (land data symbols — supplement available) and note pp. 75–82 (XPDR content) are CLEAN.
- C.2 Content gaps identified during outline authoring — 6 open research questions + 4 design decision gaps + 1 significant content gap. Note disambiguation gap RESOLVED per D-12.
- C.3 Summary — counts: 1 significant content gap, 4 design decision gaps, 6 open research questions, 10 blank/filler pages, 0 OCR-applied pages.

### Phase H: Author Coupling Summary

Write the Coupling Summary block per the template above under §"Coupling Summary block".

### Phase I: Self-review

Before writing the completion report, perform the following self-checks (per D-08 — completion report claim verification):

1. **Line count:** `wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` — report actual count. Target: ~445 ± 10%.
2. **Character encoding:** `grep -c '\\u[0-9a-f]\{4\}' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` — expect 0.
3. **Replacement chars:** Python one-liner to count U+FFFD bytes — expect 0. (Use a saved `.py` file per D-08, not inline `python -c`, if the verification turns into more than a single line.)
4. **TSO value:** `grep -n 'TSO-C112' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` — expect only `TSO-C112e` matches, no `TSO-C112d`.
5. **COM not present on GNX 375:** `grep -ni 'COM radio\|COM standby\|COM volume\|COM active frequency' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` — any matches must be in "GNC 355 has X" comparison context, never "GNX 375 has X".
6. **Knob push behavior:** `grep -n 'inner knob push' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` — verify it describes Direct-to access, not COM standby tuning.
7. **Glossary term count:** Count XPDR/ADS-B-related entries in Appendix B. Expect at least 15.
8. **Disambiguation gap absent as active flag:** `grep -ni 'GNC 375/GNX 375 disambiguation\|GNC 375 disambiguation' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` — matches must be in "resolved per D-12" context, not as an active gap.
9. **Fragment file conventions:** YAML front-matter present; fragment header `# GNX 375 Functional Spec V1 — Fragment A`; top-level sections use `##`; sub-sections use `###`.

Report all 9 check results in the completion report.

---

## Completion Protocol

1. Write completion report to `docs/tasks/c22_a_completion.md` with this structure:

   ```markdown
   ---
   Created: {ISO 8601 timestamp}
   Source: docs/tasks/c22_a_prompt.md
   ---

   # C2.2-A Completion Report — GNX 375 Functional Spec V1 Fragment A

   **Task ID:** GNX375-SPEC-C22-A
   **Output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`
   **Completed:** 2026-04-21

   ## Pre-flight Verification Results
   {table of the 5 pre-flight checks with PASS/FAIL}

   ## Phase 0 Audit Results
   {summary of actionable requirements confirmed covered}

   ## Fragment Summary Metrics
   | Metric | Value |
   |--------|-------|
   | Fragment file | `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` |
   | Line count | {actual} |
   | Target line count | ~445 |
   | Sections covered | §1, §2, §3, Appendix B, Appendix C |
   | Sub-section count | {total including Appendix B/C sub-structure} |

   ## Self-Review Results (Phase I)
   {table of the 9 self-checks with PASS/FAIL and specifics}

   ## Hard-Constraint Verification
   {confirm each of the 8 framing commitments}

   ## Coupling Summary Preview
   {brief summary of forward-refs authored for later fragments}

   ## Deviations from Prompt
   {table of any deviations with rationale; if none, state "None"}
   ```

2. `git add -A`

3. `git commit` with the D-04 trailer format. Write the commit message to a temp file via `[System.IO.File]::WriteAllText()` (BOM-free):

   ```
   GNX375-SPEC-C22-A: author fragment A (§§1–3 + Appendices B, C)

   First of 7 piecewise fragments per D-18. Covers GNX 375 Overview,
   Physical Layout, Power-On/Startup, Glossary, and Extraction Gaps.
   Target: ~445 lines; actual: {N}.

   Framing commitments honored: TSO-C112e, GNX 375 as baseline, no
   internal VDI, inner knob push = Direct-to, no COM on GNX 375.
   Appendix B includes {N} XPDR/ADS-B term definitions enabling
   later fragments to reference glossary without forward-refs.

   Task-Id: GNX375-SPEC-C22-A
   Authored-By-Instance: cc
   Refs: D-18, GNX375-SPEC-OUTLINE-01
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

   PowerShell pattern (mandatory — do not use inline `python -c`):
   ```powershell
   $msg = @'
   ...message above with actual {N} values substituted...
   '@
   [System.IO.File]::WriteAllText((Join-Path $PWD ".git\COMMIT_EDITMSG_cc"), $msg)
   git commit -F .git\COMMIT_EDITMSG_cc
   Remove-Item .git\COMMIT_EDITMSG_cc
   ```

4. **Flag refresh check:** This task does NOT modify `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`. Do NOT create refresh flags.

5. **Send completion notification:**
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-A completed [flight-sim]"
   ```

6. **Do NOT git push.** Steve pushes manually.

---

## What CD will do with this report

After CC completes:

1. CD runs check-completions Phase 1: reads the prompt + completion report, cross-references claims against the fragment file, generates a compliance prompt modeled on the C2.1-375 compliance approach. The compliance prompt will verify the 9 self-checks plus additional items CD identifies from reading the fragment directly (e.g., sampled page-reference validation, outline-to-fragment fidelity check, AMAPI cross-ref validity).

2. After CC runs the compliance prompt: CD runs check-compliance Phase 2. PASS → archive all four files (prompt, completion, compliance_prompt, compliance) to `docs/tasks/completed/`; begin drafting C2.2-B task prompt. PASS WITH NOTES → log ITM if needed, archive, continue. FAIL → bug-fix task.

3. Parallel CD action: after C2.2-A archives, CD creates `docs/specs/GNX375_Functional_Spec_V1.md` (manifest) with the ordered fragment list, marking Fragment A as its first entry. The manifest is CD-authored, not CC.

---

## Estimated duration

- CC wall-clock: ~45–75 min (reading sources + authoring ~445 lines of structured prose + self-review + commit)
- CD coordination cost after this: ~1 check-completions turn + ~1 check-compliance turn + ~0.5 turn to start manifest + C2.2-B prompt

Proceed when ready.
