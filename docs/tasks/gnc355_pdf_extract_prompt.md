# CC Task Prompt: GNC 355 PDF Extraction

**Location:** `docs/tasks/gnc355_pdf_extract_prompt.md`
**Task ID:** GNC355-EXTRACT-01
**Spec:** N/A — guidance lives in decision records and the implementation plan; see Source of truth below.
**Depends on:** None
**Priority:** Stream C Wave 1 (one of three parallel Wave-1 tasks under `docs/specs/GNC355_Prep_Implementation_Plan_V1.md`)
**Estimated scope:** Medium — 45–60 min script development; minutes to run text extraction; 30–60 min if OCR fallback is triggered; 30 min verification
**Task type:** code
**Source of truth:**
- `docs/decisions/D-02-gnc355-prep-scoping.md` (especially §Stream C items 7, 8, 9)
- `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` §6 Stream C (C1 section)
**Supporting assets:**
- `assets/Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf` — 24.31 MB; Garmin publication 190-02488-01 revision C; covers 4 devices (GPS 175, GNC 355, GNC 375, GNX 375)
**Audit level:** self-check only — rationale: read-only on the PDF, output to a dedicated extraction directory, no network I/O, no destructive operations. Low risk. Cross-instance audit would add cost without proportional safety benefit.

---

## Pre-flight Verification

**Execute these checks before writing any code. If any check fails, STOP and write a deviation report.**

1. Verify source-of-truth docs exist and are readable:
   - `ls docs/decisions/D-02-gnc355-prep-scoping.md`
   - `ls docs/specs/GNC355_Prep_Implementation_Plan_V1.md`
2. Verify PDF asset exists and is readable:
   - Filename note: the filename contains a double-space (`GNC 375 -  GPS 175`) and an apostrophe (`Pilot's`). Quote the path carefully in shell commands.
   - `ls "assets/Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf"` — should report a ~24 MB file
3. Verify no `assets/gnc355_pdf_extracted/` directory already exists. If it does, note in deviation report; script must be idempotent (safe to re-run, overwrites previous extraction).
4. Verify Python 3 and `pip install --break-system-packages` are available.
5. Verify test baseline: document current test count.
6. Verify no blocking issues: read `docs/todos/issue_index.md` if it exists.

**If any check fails:** Write `docs/tasks/gnc355_pdf_extract_prompt_deviation.md` following the standard deviation structure. Commit. Do NOT proceed until CD reviews.

---

## Phase 0: Source-of-Truth Audit

Before any implementation work:

1. Read both source-of-truth documents. Extract actionable requirements for Stream C1.

**Definition — Actionable requirement:** A statement that, if not implemented, would make the task incomplete. Includes: behavioral requirements, data model constraints, integration contracts, error handling specifications. Excludes: background/rationale, rejected alternatives, future considerations, cross-references, informational notes.

2. Key requirements to verify coverage of:
   - D-02 §Stream C item 7: pdfplumber → CC review → Tesseract OCR as last-resort fallback
   - D-02 §Stream C item 8: operational behavior vs pilot-technique material (this task produces raw extraction; the split happens in C2 — flag pages for category but do NOT split content into spec vs archive here)
   - D-02 §Stream C item 9: family delta appendix (this task is extraction only; delta analysis is C2's concern)
   - Plan §6 C1: per-page output schema, OCR gap handling, extraction report
3. Cross-reference against this prompt's implementation phases below.
4. If ALL requirements covered: print "Phase 0: all source requirements covered" and proceed.
5. If uncovered: write `docs/tasks/gnc355_pdf_extract_prompt_phase0_deviation.md` listing each uncovered requirement; commit; notify; STOP.

---

## Instructions

Extract structured text, images, and (where detectable) tables from the Garmin Pilot's Guide PDF. Produce a JSON structure indexed by page number, with per-page text content, extracted images, detected tables, and quality flags indicating where extraction was clean vs where OCR fallback was applied vs where extraction remains problematic. This task does NOT interpret the content — it produces raw structured material for downstream task C2 to synthesize into the GNC 355 functional spec.

**Also read `CLAUDE.md`** for conventions. **Also read `cc_safety_discipline.md`** at the project root. **Also read `claude-conventions.md`** — especially PowerShell quoting (paths with spaces and apostrophes require care) and Python-file discipline.

---

## Integration Context

- **Platform:** Windows; PowerShell. PDF path contains double-space and apostrophe; use Python's `pathlib` or quoted raw strings, not shell concatenation.
- **Python environment:** Install with `pip install --break-system-packages pdfplumber Pillow pytesseract`. Tesseract binary must be installed separately on Windows — if `pytesseract.get_tesseract_version()` fails, log a clear message and fall back to text-only extraction (skip OCR). Do NOT attempt to install Tesseract via pip.
- **Input PDF:** `assets/Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf` — 24.31 MB, Garmin pub 190-02488-01 rev C. Expected: modern PDF with good text layer. OCR is fallback only.
- **Key files this task creates:**
  - NEW: `scripts/gnc355_pdf_extract.py` — main extraction script
  - NEW: `scripts/pdf_extract_lib/` — helper modules if useful; single file is fine for this scope
  - NEW: `assets/gnc355_pdf_extracted/text_by_page.json` — canonical per-page extracted content
  - NEW: `assets/gnc355_pdf_extracted/images/` — extracted images, named `page_{NNN}_img_{MM}.{ext}`
  - NEW: `assets/gnc355_pdf_extracted/extraction_report.md` — summary of extraction quality
  - NEW: `tests/test_gnc355_pdf_extract.py`
- **Safety:** PDF is read-only input. Output directory is new. No modification of any existing file except (optional) creation of a `.gitignore` entry for the extraction directory — see Phase F for that decision.
- **Output size consideration:** 24 MB PDF may produce hundreds of extracted images. Extraction directory could be sizable (tens to hundreds of MB). Default behavior: extract everything; log total size at the end.

---

## Implementation Order

**Execute phases sequentially. Do NOT parallelize or launch subagents.**

Run tests after Phase E and do not proceed to Phase F if tests fail.

### Phase A: Dependency detection and setup

In `scripts/gnc355_pdf_extract.py`:

1. Import `pdfplumber`, `PIL.Image`, and `pytesseract`. Wrap imports in try/except so missing dependencies produce a clear install command in the error message.
2. Detect Tesseract availability:
   ```python
   def tesseract_available() -> bool:
       try:
           pytesseract.get_tesseract_version()
           return True
       except Exception:
           return False
   ```
   Log the result at startup. If unavailable, the script continues — OCR fallback simply doesn't run, and any page that would have triggered OCR is flagged in the report as "text-extraction-gap, OCR unavailable".

### Phase B: Per-page text extraction

Implement `extract_page_text(page) -> dict` that returns:

```python
{
    'page_number': int,           # 1-indexed
    'text': str,                  # concatenated text from pdfplumber; empty if none extractable
    'text_char_count': int,
    'text_confidence': str,       # 'clean' | 'sparse' | 'empty'
    'extraction_method': str,     # 'pdfplumber' | 'ocr' | 'pdfplumber+ocr'
    'ocr_applied': bool,
    'warnings': list[str],
}
```

Confidence heuristic:
- `char_count >= 200` → `'clean'`
- `char_count in (1, 199)` → `'sparse'` (suspicious — may be a diagram page or extraction gap)
- `char_count == 0` → `'empty'` (almost certainly an OCR candidate)

If confidence is `'sparse'` or `'empty'` AND Tesseract is available AND `--ocr` mode is `'auto'` or `'force'`:
- Render the page to an image via `pdfplumber`'s `page.to_image(resolution=300)`
- Run `pytesseract.image_to_string` on the rendered image
- If OCR returns more characters than pdfplumber, use OCR result and set `extraction_method='ocr'`; if pdfplumber had some text, set `extraction_method='pdfplumber+ocr'` and store both in the output (add field `text_ocr` with OCR result; `text` is whichever has more content)
- Set `ocr_applied=True`

### Phase C: Image extraction

For each page, extract embedded images:

- Use `page.images` (pdfplumber) to identify image regions
- For each image: extract the underlying bytes via the PDF's object stream; save to `assets/gnc355_pdf_extracted/images/page_{page:04d}_img_{idx:02d}.{ext}` where `ext` is derived from the stream's filter (`/DCTDecode` → `.jpg`, `/FlateDecode` → `.png`, fallback `.bin`)
- Record per-image metadata in the page dict:
  ```python
  'images': [
      {
          'index': int,
          'filename': str,  # relative path from assets/gnc355_pdf_extracted/
          'bbox': (x0, top, x1, bottom),
          'width_px': int,
          'height_px': int,
          'byte_size': int,
          'format': str,   # 'jpg' | 'png' | 'bin'
      },
      ...
  ]
  ```

If image extraction fails for a specific image, log a warning in the page's `warnings` list and continue — do not crash the whole extraction for one bad image.

### Phase D: Table detection

For each page, use `page.extract_tables()` to detect tables:

- Record count and rough position of each table
- For small tables (≤ 20 rows, ≤ 10 cols), serialize the data into the page dict as a 2D list
- For large tables, record metadata only (`rows`, `cols`, `bbox`) and flag for manual review in C2
  ```python
  'tables': [
      {
          'index': int,
          'bbox': tuple,
          'rows': int,
          'cols': int,
          'data': list[list[str]] | None,  # None if too large
          'truncated': bool,
      },
      ...
  ]
  ```

### Phase E: Main flow and output

`main()`:

1. `argparse` options:
   - `--pdf` (default path to the Garmin PDF — hardcode as default)
   - `--output-dir` (default `assets/gnc355_pdf_extracted`)
   - `--ocr` (default `'auto'`; choices `'auto'`, `'force'`, `'off'`)
     - `'auto'`: OCR only sparse/empty pages
     - `'force'`: OCR every page (slow; for testing)
     - `'off'`: never OCR
   - `--image-min-bytes` (default `1024`) — skip extracting images smaller than this (avoids extracting every tiny UI icon as a separate file)
   - `--pages` (default `'all'`) — optional page range like `'1-50'` or `'all'`; useful for smoke-testing on a subset
2. Open PDF with pdfplumber; get page count
3. Create output directory; create `images/` subdirectory
4. Iterate pages (respecting `--pages`):
   - Extract text (Phase B)
   - Extract images (Phase C) — subject to `--image-min-bytes`
   - Extract tables (Phase D)
   - Accumulate per-page dict
   - Print progress every 10 pages (newline-terminated, simple `print`): `processed page 50/240: clean text, 3 images, 1 table`
5. Write `text_by_page.json`:
   ```json
   {
       "source_pdf": "assets/.../Pilot's Guide 190-02488-01_c.pdf",
       "extracted_at": "ISO 8601 UTC",
       "page_count": 240,
       "pages_processed": 240,
       "tesseract_available": true,
       "ocr_mode": "auto",
       "image_min_bytes": 1024,
       "pages": [
           { "page_number": 1, ... },
           ...
       ]
   }
   ```
6. Write `extraction_report.md` with:
   - Provenance header (Created, Source=this prompt path)
   - Summary stats: total pages, clean/sparse/empty counts, OCR-applied page count, total images extracted, total tables detected
   - List of pages with `text_confidence != 'clean'` (for manual review in C2)
   - List of pages with warnings
   - Total byte size of the extraction output
   - Runtime in seconds
7. Print summary to stdout and exit

### Phase F: Tests

Create `tests/test_gnc355_pdf_extract.py`. Tests cover pure-function components only (no real PDF).

Required test coverage:

1. **Confidence heuristic:**
   - `text_char_count=0` → `'empty'`
   - `text_char_count=1` → `'sparse'`
   - `text_char_count=199` → `'sparse'`
   - `text_char_count=200` → `'clean'`
   - `text_char_count=1000` → `'clean'`

2. **Image filename formatting:**
   - `page=1, idx=0, ext='jpg'` → `'page_0001_img_00.jpg'`
   - `page=240, idx=15, ext='png'` → `'page_0240_img_15.png'`

3. **Image format mapping:**
   - Filter `/DCTDecode` → `'jpg'`
   - Filter `/FlateDecode` → `'png'`
   - Unknown filter → `'bin'`

4. **Page range parsing:**
   - `'all'` → yields full range
   - `'1-10'` → yields 1..10
   - `'5'` → yields just page 5
   - `'1-5,10,20-25'` → yields 1,2,3,4,5,10,20,21,22,23,24,25 (if your implementation supports comma ranges; if not, skip this test and simplify to single range)

5. **Tesseract detection graceful failure:**
   - Mock `pytesseract.get_tesseract_version` to raise; verify `tesseract_available()` returns False without raising

6. **Table truncation decision:**
   - 20 rows / 10 cols → `truncated=False`, data retained
   - 21 rows / 10 cols → `truncated=True`, data None
   - 20 rows / 11 cols → `truncated=True`, data None

**DO NOT** include an end-to-end test against the real PDF in this test file — it's slow and makes the test suite fragile. The smoke test in Phase G exercises the real file once.

Test command: `python -m pytest tests/test_gnc355_pdf_extract.py -v`.

### Phase G: Smoke-test run

1. Run the script with a small page range first (first 10 pages) to verify the pipeline works:
   ```
   python scripts/gnc355_pdf_extract.py --pages 1-10
   ```
   Check: output directory created, JSON written, images extracted, report generated, no crashes.

2. Examine the report:
   - What's the distribution of `text_confidence` on these pages?
   - Any OCR triggered?
   - Reasonable image count?

3. Run full extraction:
   ```
   python scripts/gnc355_pdf_extract.py
   ```
   This is expected to take 5–30 minutes depending on PDF complexity and whether OCR fires.

4. After full extraction: summarize the extraction report in the completion report.

### Phase H: gitignore decision

The extraction output in `assets/gnc355_pdf_extracted/` may be large (tens to hundreds of MB). Recommendation: add to `.gitignore` because it's regenerable from the source PDF. BUT this is a decision worth flagging in the completion report rather than making unilaterally — the completion report should include:

- Final output directory size
- Recommendation: add `assets/gnc355_pdf_extracted/` to `.gitignore`, OR keep it tracked for traceability
- Do NOT modify `.gitignore` in this task — leave that decision for CD

---

## Completion Protocol

1. Run full test suite for this task: `python -m pytest tests/test_gnc355_pdf_extract.py -v`
2. Record final test count and pass/fail status
3. Write completion report to `docs/tasks/gnc355_pdf_extract_completion.md` with:
   - Provenance header (Created, Source=this prompt path)
   - Summary of what was built
   - Test results
   - Smoke-test + full-run results:
     - Page count
     - Distribution of `text_confidence` (clean/sparse/empty)
     - OCR-applied page count
     - Total images extracted; total size of images directory
     - Total tables detected; truncated count
     - Total output directory size
     - Wall-clock duration
   - List of the 10 lowest-confidence pages (page numbers + reason) for C2 to examine first
   - Tesseract availability status on this machine
   - Gitignore recommendation (see Phase H)
   - Any deviations from this prompt
4. `git add -A` (this will stage the extraction output; if output is >50 MB, flag it in the completion report and recommend gitignore before committing). If output is >50 MB: `git restore --staged assets/gnc355_pdf_extracted/` to unstage, commit the rest, and note in the completion report that the extraction output is NOT committed pending gitignore decision.
5. `git commit -m "GNC355-EXTRACT-01: extract text, images, and tables from Garmin GNC 355 Pilot's Guide [refs: D-02, GNC355_Prep_Implementation_Plan_V1]"`
6. **Flag refresh check:** This task does not modify `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`. Do NOT create refresh flags.
7. Send completion notification:
   ```
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNC355-EXTRACT-01 completed [flight-sim]"
   ```

**Do NOT git push.** Steve pushes manually.
