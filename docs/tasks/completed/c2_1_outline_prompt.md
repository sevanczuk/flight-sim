# CC Task Prompt: C2.1 — GNC 355 Functional Spec V1 Outline

**Created:** 2026-04-21T07:02:13-04:00
**Source:** CD Purple session — Turn 11 — drafted to action C2.1 per D-11
**Task ID:** GNC355-SPEC-OUTLINE-01 (Stream C2, sub-task 1)
**Parent reference:** `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` §6.C2 (original C2 scope; slightly amended by D-11)
**Authorizing decision:** D-11 (`docs/decisions/D-11-c2-delivery-format-deferred-outline-first.md`)
**Depends on:** Stream A complete (A2 reference docs, A3 use-case index), Stream B complete (B3 pattern catalog, B4 readiness review), C1 PDF extraction complete
**Priority:** Critical-path — gates the C2.2 spec body authoring task
**Estimated scope:** Small-to-medium — ~30–60 min; reads C1 PDF extraction extensively, produces single outline document
**Task type:** docs-only (no code, no tests)
**CRP applicability:** NO — single phase, single output file, brief duration
**Source of truth:**
- `assets/gnc355_pdf_extracted/text_by_page.json` (310 pages of extracted PDF text — the primary content source)
- `assets/gnc355_pdf_extracted/extraction_report.md` (extraction quality notes; flags any pages with OCR or structural issues)
- `assets/gnc355_reference/land-data-symbols.png` + `assets/gnc355_reference/README.md` (manually curated supplement for page 125)
- `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` §6.C2 (original spec scope and structure outline — use as starting point but expand significantly)
- `docs/knowledge/amapi_by_use_case.md` (A3 — use-case index; reference for what AMAPI capabilities exist)
- `docs/knowledge/amapi_patterns.md` (B3 — pattern catalog; reference for established AMAPI idioms)
- `docs/knowledge/stream_b_readiness_review.md` (B4 — identifies coverage gaps in B3 the spec author should know about)
- `docs/decisions/D-01-project-scope.md` (XPL primary + MSFS secondary)
- `docs/decisions/D-02-gnc355-prep-scoping.md` (three-stream structure; family-delta appendix requirement)
**Audit level:** standard — CD reviews the outline thoroughly before authorizing C2.2; the format-decision quality depends on outline quality

---

## Pre-flight Verification

**Execute these checks before reading PDF content. If any fails, STOP and write `docs/tasks/c2_1_outline_prompt_deviation.md`.**

1. Verify all source-of-truth files exist:
   ```bash
   ls assets/gnc355_pdf_extracted/text_by_page.json
   ls assets/gnc355_pdf_extracted/extraction_report.md
   ls assets/gnc355_reference/land-data-symbols.png
   ls docs/specs/GNC355_Prep_Implementation_Plan_V1.md
   ls docs/knowledge/amapi_by_use_case.md
   ls docs/knowledge/amapi_patterns.md
   ls docs/knowledge/stream_b_readiness_review.md
   ```

2. Verify `text_by_page.json` is structurally readable:
   ```bash
   python -c "import json; d = json.load(open('assets/gnc355_pdf_extracted/text_by_page.json')); print(f'pages={len(d)}'); print(f'first_keys={list(d[0].keys()) if isinstance(d, list) else list(d.keys())[:5]}')"
   ```
   Expect 310 pages (or close — extraction report is authoritative).

3. Verify no conflicting outline output exists:
   ```bash
   ls docs/specs/GNC355_Functional_Spec_V1_outline.md
   ```
   Expect FAIL (file should not exist yet). If it exists, STOP and note in deviation report — could indicate a previous incomplete attempt.

4. Skim the C1 extraction report end-to-end. Note any pages flagged as OCR'd, garbled, or otherwise low-confidence — the outline should reference these flags so future readers know which sections may need manual review.

---

## Phase 0: Source-of-Truth Audit

Before producing any outline content:

1. Read all source-of-truth documents listed in the prompt header. The PDF extraction (`text_by_page.json`) is the primary content source — read it page by page or in chunks as needed.

**Definition — Actionable requirement:** A statement that, if not implemented, would make the outline incomplete relative to the C2 charter.

2. Extract actionable requirements from these inputs, with particular attention to:
   - The implementation plan's §6.C2 spec structure outline (15 sections + 3 appendices listed there) — your outline must cover at minimum what's listed there, but should EXPAND with sub-sections derived from the actual PDF content
   - D-02 family-delta appendix requirement (compare GNC 355 vs. GPS 175, GNC 375, GNX 375 in each significant functional area where the Pilot's Guide notes differences)
   - D-01 dual-sim scope (XPL primary + MSFS secondary) — outline should note where sim-specific behavior is documented
   - Stream B readiness review's three identified coverage gaps (canvas-drawn faces, touchscreen idioms beyond button_add, A3 §8 running displays + §10 maps) — outline should call out sections where these gaps will require AMAPI reference doc consultation rather than B3 pattern lookup

3. Cross-reference each requirement against the outline structure you'll produce.
4. If ALL covered: print "Phase 0: all source requirements covered" and proceed to Phase A.
5. If any requirement is uncovered: write `docs/tasks/c2_1_outline_prompt_phase0_deviation.md` and STOP.

---

## Instructions

Produce a detailed structural outline for the GNC 355 Functional Spec V1. The outline is the structural blueprint that the C2.2 spec body authoring task will expand into prose. Quality of the outline directly determines quality of the eventual spec.

**Primary output:** `docs/specs/GNC355_Functional_Spec_V1_outline.md`

### What "detailed outline" means in this context

This is NOT just a table of contents. It is the spec's full structural skeleton with enough specificity that:

- A different CC instance reading the outline could expand it into prose without needing to re-read the PDF (the outline carries the structural decisions; the PDF carries the source content)
- Structural mistakes (missing sections, wrong abstraction level, mis-grouped content) are visible at outline stage
- Per-section length estimates inform the C2.2 format decision (monolithic vs. piecewise vs. per-section)

For each section, the outline includes:

1. **Section number and title.** Use a sensible numbering scheme; recommend `1.`, `1.1`, `1.1.1` Markdown header levels matching `##`, `###`, `####`.

2. **One-paragraph scope statement.** What this section covers in 2–4 sentences. Includes the key questions the section answers.

3. **Sub-sub-bullets enumerating the specific topics.** For example, under "Display pages → Flight plan page," list every operation the FPL page supports (insert waypoint, delete waypoint, re-order, activate, view leg details, etc.).

4. **Source page references from C1.** For each major topic, cite the PDF page(s) where the content lives — e.g., `[pp. 87–94]`. This makes C2.2 authoring O(1) lookup per topic instead of O(N) re-scanning.

5. **Estimated section length** in lines (rough — `~50`, `~150`, `~300`). Used to inform the format decision.

6. **Cross-references to AMAPI knowledge.** Where a section will reference Stream A or Stream B output, name the specific document — e.g., "see `docs/knowledge/amapi_patterns.md` Pattern 4 for long-press detection" or "see `docs/knowledge/amapi_by_use_case.md` §3 for touchscreen function inventory." Don't expand these references; just place them.

7. **Open questions or coverage flags.** Where the PDF content is ambiguous, missing, or where C1 extraction flagged a page as low-quality, note explicitly. These become the spec's "Appendix C: Extraction gaps" content.

### Sections to include (minimum — expand with PDF-derived sub-structure)

Based on the implementation plan §6.C2 (which is the starting structure — your outline should expand it significantly):

1. Overview (what the GNC 355 is, what the spec covers, scope boundaries from D-01)
2. Physical layout & controls (bezel buttons, knobs, touch zones)
3. Power-on, self-test, startup state
4. Display pages (overview + per-page section each — likely the largest section group; includes map, flight plan, procedures, nearest, waypoint info, direct-to, settings, COM)
5. Flight plan editing
6. Direct-to operation
7. Procedures (approaches, arrivals, departures — if in scope per Pilot's Guide)
8. Nearest functions
9. Waypoint information pages
10. Settings / system pages
11. COM radio operation
12. Audio / alerts / annunciators
13. Messages
14. Persistent state (what survives a power cycle)
15. External I/O (datarefs, commands — if documented)
16. Appendix A: Family delta (GPS 175 / GNC 375 / GNX 375 differences per D-02 §9)
17. Appendix B: Glossary / abbreviations
18. Appendix C: Extraction gaps and manual-review-required pages

The numbering above is the implementation plan's. You may renumber if a different organization fits the actual PDF content better — but if you renumber, include a brief note in the outline header explaining why.

**Important:** Sections 4 (Display pages) and 11 (COM radio) are likely candidates to be very large with many sub-sections. Sections 16 (Family delta) and 18 (Extraction gaps) need full sub-section structure even though they reference content elsewhere.

### Outline document structure

```markdown
---
Created: <ISO 8601>
Source: docs/tasks/c2_1_outline_prompt.md
---

# GNC 355 Functional Spec V1 — Detailed Outline

**Purpose:** Structural blueprint for C2.2 spec body authoring. See D-11 for the outline-first approach rationale.
**Source content:** `assets/gnc355_pdf_extracted/text_by_page.json` (310 pages)
**Estimated total spec length:** [your estimate based on summing section estimates]
**Format recommendation for C2.2:** [your recommendation: monolithic CRP / piecewise+manifest / one-task-per-section] with rationale ([1–2 paragraphs])

## Outline navigation aids

- **Section count:** N top-level + M appendices
- **Largest sections (by estimate):** [list top 3]
- **Sections with significant coverage gaps:** [list any sections where PDF content is thin or extraction flagged issues]

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
  - <topic bullet> [pp. X]

**AMAPI knowledge cross-refs.**
- [link to relevant Pattern in B3 or use-case section in A3 — placeholders only, not expanded]

**Open questions / flags.**
- [any ambiguity, missing content, or extraction issue]

---

## 2. <Section title>
...

---

## Appendix A: <Title>
...
```

The "Format recommendation for C2.2" field at the top is what closes the loop with D-11. CD will use it as input to the format-decision turn.

### Hard constraints

- The outline file is a complete document — provenance header, all sections, all appendices. Not a partial draft.
- Do NOT begin writing prose for any section. The outline is structural only. Sub-bullets are noun phrases / topic descriptors, not full sentences. Resist the temptation to "just sketch a paragraph."
- Do NOT attempt to compute the family-delta content (GPS 175 vs. GNC 375 vs. GNX 375) yourself unless the Pilot's Guide explicitly compares them in extracted text — the appendix outline should call out which functional areas the Pilot's Guide compares, leaving the actual comparison content for C2.2 prose authoring.
- Cite source pages liberally and accurately. A wrong page reference in the outline becomes a wrong page reference in the spec body; verify with the PDF JSON.
- If the PDF content for a section is genuinely sparse or absent, say so explicitly in the section's "Open questions / flags" — do NOT pad the outline to make sections look balanced.

**Also read `CLAUDE.md`** for project conventions and `claude-conventions.md` §Git Commit Trailers for the D-04 commit format.

---

## Completion Protocol

1. **Verify report claims against actual state** (per D-08 — re-run any `wc -l`, `grep -c`, etc. commands at the moment of writing the completion report; do not carry numbers from earlier in the session).

2. Verify outputs exist:
   - `docs/specs/GNC355_Functional_Spec_V1_outline.md` (the primary output)

3. Spot-check page references: pick 3 section sub-bullets at random; verify the cited PDF page numbers actually contain content matching the topic. Record results in the completion report.

4. Write completion report `docs/tasks/c2_1_outline_completion.md` with:
   - Provenance header (Created, Source)
   - Pre-flight verification results
   - Phase 0 audit results
   - Outline summary metrics: section count, total estimated spec length, largest sections
   - Format recommendation summary (1–2 paragraphs — same as in the outline header but with completion-report context)
   - Page-reference spot-check results (3 random checks)
   - Coverage flags: count of sections with "Open questions / flags" entries, summary of the most significant flags
   - Any deviations from this prompt with rationale

5. Commit using the D-04 trailer format. Write the commit message to a temp file via `[System.IO.File]::WriteAllText()` (BOM-free) and use `git commit -F <file>`. Message structure:
   ```
   GNC355-SPEC-OUTLINE-01: GNC 355 Functional Spec V1 detailed outline

   Outline-first sub-task per D-11. Produces structural blueprint for
   C2.2 spec body authoring with section/sub-section breakdown, source
   page references from C1 PDF extraction, per-section length estimates,
   and a format recommendation (monolithic / piecewise / per-section)
   for CD to use in the C2.2 format-decision turn.

   Section count: <N>
   Estimated total spec length: <X> lines
   Format recommendation: <choice>

   Task-Id: GNC355-SPEC-OUTLINE-01
   Authored-By-Instance: cc
   Refs: D-01, D-02, D-11, GNC355_Prep_Implementation_Plan_V1
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

6. **Flag refresh check:** This task does not modify `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`. Do NOT create refresh flags.

7. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNC355-SPEC-OUTLINE-01 completed [flight-sim]"
   ```

8. **Do NOT git push.** Steve pushes manually.

---

## What This Unblocks

- CD review of the outline (next CD turn after this task's archive)
- D-11's format decision for C2.2 (monolithic / piecewise / per-section)
- C2.2 task prompt drafting (CD turn following format decision)
- Eventually: C2.2 execution → C3 spec-review → C4 iteration → implementation-ready V_n

---

## Rationale Notes (informational)

- **Why outline-first:** see D-11. The format question (monolithic vs. piecewise) is downstream of the structural picture. Outline-first makes the format decision informed rather than guessed.
- **Why not write a partial spec:** outline-first only works if it's actually outline. A partial spec drift commits the format implicitly and forecloses the format decision D-11 wants to defer.
- **Why detailed page references:** C2.2 authoring is much faster when each topic has an O(1) page lookup. The outline IS the index.
- **Why per-section length estimates:** the C2.2 format decision uses these as the primary signal. Without them, CD has to guess again.
- **Why don't compute family-delta yet:** the GPS 175 / GNC 375 / GNX 375 comparison content is spec-body work, not outline work. The outline records what to compare, not the comparison itself.
