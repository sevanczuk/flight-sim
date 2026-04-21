---
Created: 2026-04-20T12:13:00+00:00
Source: docs/tasks/gnc355_pdf_extract_prompt.md
---

# GNC355-EXTRACT-01 Completion Report

## Summary

Implemented `scripts/gnc355_pdf_extract.py` — a pdfplumber-based extraction pipeline that
processes the Garmin 190-02488-01_c Pilot's Guide PDF page-by-page and produces:

- `assets/gnc355_pdf_extracted/text_by_page.json` — canonical per-page structured content
  (text, images, tables, quality flags)
- `assets/gnc355_pdf_extracted/images/` — 521 extracted images (page_NNNN_img_MM.ext naming)
- `assets/gnc355_pdf_extracted/extraction_report.md` — extraction quality summary
- `tests/test_gnc355_pdf_extract.py` — 21 unit tests covering pure-function components

The script is idempotent (re-running overwrites previous extraction), supports argparse
options for OCR mode, image min-bytes filter, page range, PDF path, and output directory.
Tesseract detection is graceful — if unavailable, sparse/empty pages are flagged but the
script completes without error.

---

## Test Results

Command: `python -m pytest tests/test_gnc355_pdf_extract.py -v`

**Result: 21 passed, 0 failed**

Coverage:
- Confidence heuristic (5 tests): boundary conditions at 0, 1, 199, 200, 1000
- Image filename formatting (2 tests)
- Image format mapping (4 tests): DCTDecode, FlateDecode, unknown, None
- Page range parsing (5 tests): all, range, single, comma-combined, clamping
- Tesseract graceful failure (1 test): mock raises, returns False without raising
- Table truncation (4 tests): boundary, rows-over, cols-over, both-over

Previous test suite (92 tests in test_amapi_crawler.py) was not disturbed.
New total: 113 tests.

---

## Smoke-Test Results (pages 1-10)

Command: `python scripts/gnc355_pdf_extract.py --pages 1-10`

| Metric | Value |
|--------|-------|
| Pages processed | 10 of 310 |
| Clean text | 9 |
| Sparse text | 1 (page 1) |
| Empty text | 0 |
| Images extracted | 1 |
| Tables detected | 5 |
| Duration | 0.7 s |

Output directory created, JSON written, images extracted, report generated. No crashes.

---

## Full Extraction Results

Command: `python scripts/gnc355_pdf_extract.py`

| Metric | Value |
|--------|-------|
| Source PDF | Garmin GNC 375 - GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf |
| Total pages in PDF | 310 |
| Pages processed | 310 |
| Clean text pages | 297 (95.8%) |
| Sparse text pages | 12 (3.9%) |
| Empty text pages | 1 (0.3%) |
| OCR-applied pages | 0 |
| Total images extracted | 521 |
| Total tables detected | 170 |
| Truncated tables (too large to inline) | 7 |
| Total output size | 151.2 MB |
| Wall-clock duration | 16.0 s |

PDF has excellent text layer — 95.8% of pages extracted clean. The 12 sparse pages and
1 empty page are almost certainly diagram-heavy or blank pages (cover, dividers, figure-only
pages). Without Tesseract installed on this machine, those 13 pages flagged
"text-extraction-gap, OCR unavailable" rather than receiving OCR recovery.

---

## 10 Lowest-Confidence Pages (for C2 to examine first)

| Rank | Page | Confidence | Notes |
|------|------|------------|-------|
| 1 | 309 | empty | Likely blank or full-bleed diagram; no text extracted |
| 2 | 1 | sparse | Cover page — low character count expected |
| 3 | 36 | sparse | Likely section divider or figure-heavy page |
| 4 | 110 | sparse | Likely section divider or figure-heavy page |
| 5 | 125 | sparse | Likely section divider or figure-heavy page |
| 6 | 208 | sparse | Likely section divider or figure-heavy page |
| 7 | 222 | sparse | Likely section divider or figure-heavy page |
| 8 | 270 | sparse | Likely section divider or figure-heavy page |
| 9 | 271 | sparse | Likely section divider or figure-heavy page |
| 10 | 292 | sparse | Likely section divider or figure-heavy page |

Remaining sparse: pages 298, 308, 310.

All 13 low-confidence pages received the warning "text-extraction-gap, OCR unavailable"
and are listed in `assets/gnc355_pdf_extracted/extraction_report.md`. If Tesseract is
installed before C2 runs, re-running the extractor with `--ocr auto` will attempt OCR
on those 13 pages.

---

## Tesseract Status

Tesseract binary is NOT installed on this machine. OCR fallback was unavailable.
Impact: 13 pages (12 sparse + 1 empty) were not OCR-recovered and are flagged for review.
If Tesseract is needed: install from https://github.com/tesseract-ocr/tesseract and ensure
it's in PATH, then re-run the script. The script will auto-detect and apply OCR on the
next run.

---

## Gitignore Recommendation

**Final output directory size: 151.2 MB**

Recommendation: **add `assets/gnc355_pdf_extracted/` to `.gitignore`**.

Rationale:
- 151.2 MB exceeds Git's practical file size limits and would bloat repo history
- Output is fully regenerable from the source PDF (which is tracked) in ~16 seconds
- No manual curation has gone into the extracted data (it's raw machine output)

Decision left for CD: modify `.gitignore` before committing the extraction output if
traceability is desired via a separate storage mechanism (e.g., local artifact store or
noting extraction config in a sidecar). This task does NOT modify `.gitignore`.

**Extraction output is NOT committed** (see git commit note below — output exceeds
50 MB threshold per completion protocol).

---

## Deviations from Prompt

None. All phases executed as specified.

- Phase A: Dependency detection + Tesseract check — implemented as specified
- Phase B: Per-page text extraction with confidence heuristic and OCR branching — implemented
- Phase C: Image extraction with min-bytes filter and fallback render path — implemented
- Phase D: Table detection with truncation threshold (20 rows / 10 cols) — implemented
- Phase E: Main flow with argparse, JSON output, extraction report — implemented
- Phase F: 21 unit tests — all pass
- Phase G: Smoke test (10 pages) + full run (310 pages) — both successful
- Phase H: Gitignore recommendation documented above; `.gitignore` not modified
