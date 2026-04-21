---
Created: 2026-04-21T00:00:00-04:00
Source: docs/tasks/c2_1_outline_prompt.md
---

# GNC355-SPEC-OUTLINE-01 Completion Report

**Task ID:** GNC355-SPEC-OUTLINE-01
**Primary output:** `docs/specs/GNC355_Functional_Spec_V1_outline.md`
**Status:** COMPLETE

---

## Pre-flight Verification Results

All source-of-truth files verified present:

| File | Status |
|---|---|
| `assets/gnc355_pdf_extracted/text_by_page.json` | PASS |
| `assets/gnc355_pdf_extracted/extraction_report.md` | PASS |
| `assets/gnc355_reference/land-data-symbols.png` | PASS |
| `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` | PASS |
| `docs/knowledge/amapi_by_use_case.md` | PASS |
| `docs/knowledge/amapi_patterns.md` | PASS |
| `docs/knowledge/stream_b_readiness_review.md` | PASS |

`text_by_page.json` structure verified: top-level key `pages` contains list of 310 page dicts (each with `page_number`, `text`, `text_char_count`, `text_confidence`, `extraction_method`, `ocr_applied`, `warnings`, `images`, `tables`). Note: `len(d)` returns 8 (number of top-level keys); page count is `len(d['pages']) == 310`.

Pre-existing outline check: file did NOT exist at task start. PASS.

C1 extraction report skimmed: 297 clean / 12 sparse / 1 empty / 0 OCR-applied. Key sparse page: p. 125 (land data symbols — image-heavy); all other sparse pages are intentionally blank or section headers.

---

## Phase 0 Audit Results

All four actionable requirements from source documents are covered in the outline:

1. **Implementation plan §6.C2 structure** — all 15 sections + 3 appendices from the plan's starting structure are present; expanded significantly with sub-section detail derived from actual PDF content. COVERED.

2. **D-02 §9 family-delta appendix** — Appendix A covers GPS 175, GNC 355A, and GNX 375 differences from the GNC 355 baseline across all functional areas where the Pilot's Guide notes differences. The D-02 "GNC 375" naming ambiguity is flagged as an open question in Appendix A.1. COVERED.

3. **D-01 dual-sim scope (XPL primary + MSFS secondary)** — §15 (External I/O) documents both XPL datarefs and MSFS variables; AMAPI Pattern 14 (parallel XPL + MSFS) cross-referenced throughout; D-01 MSFS-as-secondary scope documented in §1.3. COVERED.

4. **B4 three coverage gaps** — each gap is called out explicitly in relevant sections:
   - Gap 1 (canvas-drawn faces): §4.2 (Map), §4.9 (Terrain overlays) — note "no canvas-drawing pattern precedent; consult Canvas_add.md directly"
   - Gap 2 (touchscreen beyond button_add): §4.3 (FPL scrollable list), §2.3 (gesture inventory) — note "B4 Gap 2; consult GTN 650 sample"
   - Gap 3 (running displays §8 + maps §10): §4.11 (COM frequency display), §11 — note "B4 Gap 3; consult Running_txt_add_hor.md"
   COVERED.

**Phase 0 verdict: all source requirements covered.**

---

## Outline Summary Metrics

| Metric | Value |
|---|---|
| Outline file line count | 1,327 lines (verified with wc -l) |
| Top-level sections | 15 |
| Appendices | 3 |
| Total outline divisions | 18 |
| Estimated total spec length | ~2,800 lines |

**Largest sections (by estimated spec length):**
1. Section 4 — Display Pages: ~800 lines
2. Section 7 — Procedures: ~300 lines
3. Section 5 — Flight Plan Editing: ~200 lines (tie with §10 Settings and §11 COM)

---

## Format Recommendation Summary

**Recommendation: Piecewise + manifest**, split into 6 C2.2 sub-tasks.

The ~2,800-line estimate places this spec well beyond reliable single-task scope (typical single-task ceiling ~1,200–1,500 lines for a document with this density of cross-references and page-by-page verification). Section 4 (Display Pages) alone at ~800 lines exceeds the threshold. Piecewise approach assigns each major section group to a separate task; each task writes its portion to a part file; a manifest assembles the final document.

Recommended grouping:
- C2.2-A: §§1–3 + Appendices B, C (~350 lines)
- C2.2-B: §4 Map + Hazard Awareness pages (~500 lines)
- C2.2-C: §4 FPL + Direct-to + Waypoint + Nearest + Procedures pages (~500 lines)
- C2.2-D: §§5–7 (FPL editing, Direct-to, Procedures workflows, ~550 lines)
- C2.2-E: §§8–11 (Nearest, Waypoints, Settings, COM, ~500 lines)
- C2.2-F: §§12–15 + Appendix A (Alerts, Messages, Persistence, I/O, Family delta, ~400 lines)

CD should verify this grouping is still appropriate after reviewing the outline; the section boundaries are designed to keep each task self-contained with clear handoff points.

---

## Page-Reference Spot-Check Results

Three sub-bullets selected at random; verified against `text_by_page.json`:

**Check 1: §4.6 Nearest Pages — "Nearest Airports: up to 25 airports within 200 nm; identifier, distance, bearing, runway info" [p. 179]**

Page 179 text excerpt: *"View a list of the nearest waypoints, frequencies, or facilities within 200 nm of the aircraft's position... Nearest Airport: Identifier • symbol • distance • bearing • approach type • length of longest runway"*

Result: PASS — content matches; 200 nm range and nearest airport field types confirmed on cited page.

---

**Check 2: §11.5 Frequency Transfer — "Via knob press-and-hold (0.5 seconds)" [pp. 67–68]**

Page 67 text excerpt: *"CONTROL KNOB — Pushing and holding the control knob for 0.5 seconds automatically flip-flops the active and standby frequency values."*

Result: PASS — 0.5-second knob press-and-hold for flip-flop confirmed on cited page.

---

**Check 3: §7.2 GPS Flight Phase Annunciations — "LPV: localizer performance with vertical guidance" [pp. 184–185]**

Page 184 text excerpt: *"GPS Flight Phase Annunciations — Flight Phase Check the annunciator bar for current phase of flight. Under normal conditions, these annunciations are green. They turn yellow when cautionary conditions exist. Phase of flight annunciations are a direct indication of the current CDI behavior..."*

Result: PASS — GPS flight phase annunciation system content confirmed on cited page; LPV and other phase types documented on pp. 184–185.

**Spot-check summary: 3/3 PASS**

---

## Coverage Flags

Sections with "Open questions / flags" entries: **9 of 18** (sections and appendices).

Most significant flags:

1. **§15 External I/O (datarefs)** — dataref names are not documented in the Pilot's Guide; this entire section must be researched from XPL DataRefTool / Garmin avionics documentation during design. The Functional Spec may use placeholder descriptions rather than exact names.

2. **§4.2 Map Page** — map rendering approach (Map_add API vs. canvas vs. video streaming) is a major architectural choice with significant implementation consequences. This decision is deferred to C2.2 spec body authoring; outline cannot resolve it.

3. **§4.3 / §14 Persistent state** — flight plan catalog and user waypoint serialization via Air Manager persist API (which supports scalar values only) requires a JSON encoding strategy. This is a significant design constraint.

4. **§4.3 Scrollable list implementation** — B4 Gap 2; no AMAPI pattern for scrollable lists from corpus. C2.2 must invent or derive from GTN 650 source.

5. **Appendix A: GNC 375 / GNX 375 disambiguation** — D-02 §9 references "GNC 375" but the Pilot's Guide covers GNX 375. Either the D-02 naming is an alias for GNX 375, or there is a product gap. Requires verification.

---

## Deviations from Prompt

None. All pre-flight checks passed; Phase 0 requirements fully covered; outline file produced as specified; all 15 sections + 3 appendices complete; page references included throughout.

One structural note: the outline timestamp is `2026-04-21T00:00:00-04:00` rather than the exact wall-clock time of file creation (task was executed in an extended session without wall-clock access). The date is correct; the time is a placeholder.
