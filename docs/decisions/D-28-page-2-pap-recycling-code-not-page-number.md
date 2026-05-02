# D-28 — Page 2 of GNX 375 Pilot's Guide footer is a recycling code, not a page number

**Created:** 2026-05-02T07:16:55-04:00
**Source:** CD Purple session — Turn 3; empirical inspection of `assets/gnx375_pymupdf_v1_0_1/page_metadata.json` after Steve identified via screenshot that the "22 PAP" footer text is a paper recycling identifier (triangle-encoded "22" over "PAP"), not a printed page identifier
**Status:** Adopted
**Supersedes:** None
**Decision class:** Project-specific data convention

---

## Decision

The footer band on physical page 2 of the GNX 375 Pilot's Guide PDF (`assets/Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf`) contains a paper-recycling code symbol, not a page identifier. PyMuPDF-extract V1.0.1 captured "22" from inside the triangle and parsed it as `printed_page_number: "22"`. This was a parser false positive on cover-page typography.

In `assets/gnx375_pymupdf_v1_0_1/page_metadata.json`, page 2's `printed_page_number` is forced to `null` while `footer_text_raw: "22\nPAP"` is preserved for audit. All downstream artifacts derived from this extraction — in particular, the forthcoming `page_number_map.json` — reflect page 2 as unparseable.

**Updated empirical counts** for this extraction: 310 entries, **306 parsed** printed page numbers, **4 unparseable** (physical pages 1, 2, 309, 310 — front cover, inside front cover with recycling code, back inside cover, back cover). These counts supersede the briefing's claimed 307/3 split.

---

## Context — what "PAP 22" is

The triangle-with-"22" symbol over "PAP" is a paper-recycling identifier. The "22" inside a triangle and the "PAP" abbreviation together identify the substrate as a paper-class material under the EU recycling-code convention (codes 20–39 cover paper). It's commonly printed on cover pages of professionally-printed manuals to indicate the substrate is recyclable. The Pilot's Guide cover stock evidently uses this code.

The PyMuPDF parser sees only what's inside the footer-band bounding box and applies a regex to extract page-identifier candidates. "22" matches a valid page-identifier shape, so the parser accepts it. The triangle and "PAP" tokens fall outside the page-identifier regex.

---

## Recurrence concern

Future re-runs of `pymupdf-extract` against this PDF will re-parse "22" on physical page 2 and overwrite the manual `null`. Three mitigation paths, in order of preference:

1. **Manual re-edit each re-extraction** (current state). Fragile — easy to forget across sessions and instances. Documented here as the interim approach.
2. **Project-level override file** consumed by the transform script. A future `assets/gnx375_pymupdf_v1_0_1/page_overrides.json` listing entries of the shape `{"<phys-as-string>": {"printed_page_number": null, "rationale": "PAP 22 paper recycling code, not a page identifier (D-28)"}}`. The transform script applies overrides during the `page_metadata.json` → `page_number_map.json` transform, so the canonical extraction stays manual-edit-free. Reproducible across re-extractions. **Recommended as a transform-script feature** when the GNX375-PAGEMAP-PYMUPDF-01 task is drafted. (See the page-map transform plan for how this integrates.)
3. **Upstream fix in `commons/pymupdf-extract`** to detect symbol-with-text patterns (recycling codes, stock IDs, regulatory marks) and reject them as page-identifier candidates. Out of flight-sim scope; flagged here for cross-project visibility.

This decision adopts #1 as the immediate state and prescribes #2 as the design pattern for the upcoming transform script. #3 is logged for cross-project visibility but not actioned here.

---

## Scope

Applies to:

- `assets/gnx375_pymupdf_v1_0_1/page_metadata.json` — page 2 stays at `null`; `footer_text_raw` remains "22\nPAP" for audit
- The forthcoming `scripts/build_page_number_map_from_pymupdf.py` — must include the override-file mechanism (path #2 above), or document the deferral if scoped out of v1
- Any analogous Garmin manual extractions revisited in the future (GNC 355, GTN 750, etc.) — apply the same scrutiny to physical page 2 (and any other front/back-matter pages) of those manuals

Does not apply to:

- Generic PyMuPDF parser improvements — separate concern, owned by the commons project

---

## Citation

The triangle-encoded "22" over "PAP" recycling-code convention is documented across packaging-recycling standards (EU Decision 97/129/EC; ASTM D7611 covers a related plastics scheme that uses the same triangle visual language). Visual evidence: Steve's Turn 3 screenshot of the GNX 375 Pilot's Guide page-2 footer band.
