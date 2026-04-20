# Manual Task: Eyeball 13 Low-Confidence Pages from GNC 355 Pilot's Guide

**Task type:** MANUAL — for Steve to perform. Not a CC task.
**Location:** `docs/tasks/MANUAL_gnc355_eyeball_low_confidence_pages.md`
**Created:** 2026-04-20T09:10:00-04:00
**Source:** Purple Turn 37 — follow-up from GNC355-EXTRACT-01 completion
**Parent task:** GNC355-EXTRACT-01 (completed 2026-04-20)
**Priority:** Low — does not block Wave-2 tasks. Can happen any time before Stream C2 drafts the GNC 355 functional spec.
**Estimated effort:** 15–30 minutes with the PDF open

---

## Context

GNC355-EXTRACT-01 extracted text + images + tables from the 310-page Garmin Pilot's Guide PDF (190-02488-01 rev C). 297 pages extracted clean. **13 pages came out with incomplete or empty text layers:**

| Rank | Page | Confidence | Notes from extraction report | disposition |
|------|------|------------|-----------------------------|-----------------------------|
| 1 | 309 | empty | Likely blank or full-bleed diagram; no text extracted | ignore (blank) |
| 2 | 1 | sparse | Cover page — low character count expected | ignore (cover page) |
| 3 | 36 | sparse | Likely section divider or figure-heavy page | ignore (blank) |
| 4 | 110 | sparse | Likely section divider or figure-heavy page | ignore (intentionally blank) |
| 5 | 125 | sparse | Likely section divider or figure-heavy page | keep (saved as "C:\Users\artroom\projects\flight-sim-project\flight-sim\assets\gnc355_pdf_extracted\land-data-symbols.png") |
| 6 | 208 | sparse | Likely section divider or figure-heavy page | ignore (intentionally blank) |
| 7 | 222 | sparse | Likely section divider or figure-heavy page | ignore (intentionally blank) |
| 8 | 270 | sparse | Likely section divider or figure-heavy page | ignore (intentionally blank) |
| 9 | 271 | sparse | Likely section divider or figure-heavy page | ignore (subsection header page) |
| 10 | 292 | sparse | Likely section divider or figure-heavy page | ignore (intentionally blank) |
| 11 | 298 | sparse | Unknown | ignore (intentionally blank) |
| 12 | 308 | sparse | Unknown | ignore (intentionally blank) |
| 13 | 310 | sparse | Unknown | ignore (closing page but it does have the doc rev number: 190-02488-01 Rev. C) |

The extraction task flagged these because either their text layer is sparse/absent or the content is likely image-heavy (diagrams, screen captures without embedded text).

## What you're deciding

For each of the 13 pages, answer: **does this page contain text content that matters for the GNC 355 functional spec (Stream C2)?**

- **If yes (actual content missing)** — the page needs to be OCR'd so Stream C2 has the content. Per Turn 37, Tesseract is not being installed for this one-off; a better OCR solution exists in another project of yours and you'll use that. Note the outcome in the spreadsheet below.
- **If no (cover page, divider, figure-only with no informational text)** — no action needed. Mark accordingly.

## How to do it

1. Open the source PDF:
   ```
   C:\Users\artroom\projects\flight-sim-project\flight-sim\assets\Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf
   ```
2. Jump to each page in the table below. Most PDF viewers support direct-page navigation via Ctrl-G or a page-number input box.
3. For each page, record one of four verdicts:
   - **BLANK** — actually blank, no content at all
   - **COVER/DIVIDER** — title page, chapter divider, or similar structural page with no substantive content
   - **FIGURE-ONLY** — page is a diagram/screenshot with no associated text OR the text is present but not relevant to functional behavior (e.g., legal disclaimers, index entries)
   - **NEEDS-OCR** — page has actual content that extraction missed. Examples: captions under diagrams, screen-captured text, tables rendered as images
4. If **NEEDS-OCR**: briefly describe what's on the page so Stream C2 knows what was missed and can prioritize the OCR'd text correctly.

## Results template

Fill this table in and save the filled version at:
`docs/tasks/MANUAL_gnc355_eyeball_low_confidence_pages_results.md`

```
| Page | Verdict         | Notes                                         |
|------|-----------------|-----------------------------------------------|
|   1  | COVER/DIVIDER   | Title page                                    |
|   36 |                 |                                               |
|  110 |                 |                                               |
|  125 |                 |                                               |
|  208 |                 |                                               |
|  222 |                 |                                               |
|  270 |                 |                                               |
|  271 |                 |                                               |
|  292 |                 |                                               |
|  298 |                 |                                               |
|  308 |                 |                                               |
|  309 |                 |                                               |
|  310 |                 |                                               |
```

## What happens next

- After you complete this eyeball and save the results file: let CD know. CD will integrate the findings into the Stream C2 task prompt.
- If any pages are **NEEDS-OCR**: you'll use your other project's OCR tool to process them separately and drop the OCR'd text into a file under `assets/gnc355_pdf_extracted/ocr_supplements/` (directory to be created at that point). Stream C2 will then pick up both the original extraction JSON and the OCR supplements.
- If no pages are **NEEDS-OCR**: the extraction is complete as-is. Stream C2 proceeds with the 297 clean pages and can note the 13 skipped pages in the spec's Appendix C (extraction gaps).

## Related

- GNC355-EXTRACT-01 completion report: `docs/tasks/gnc355_pdf_extract_completion.md`
- Source PDF: `assets/Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf`
- Extraction output directory (gitignored per D-06): `assets/gnc355_pdf_extracted/`
- Per-page extraction detail: `assets/gnc355_pdf_extracted/text_by_page.json`
- Extraction report: `assets/gnc355_pdf_extracted/extraction_report.md`
