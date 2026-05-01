# GNC 355 Reference Assets

**Created:** 2026-04-20T09:50:02-04:00
**Source:** Purple Turn 54 — housing curated reference assets for Stream C2 (GNC 355 Functional Spec authoring)
**Purpose:** Store permanent, authored (non-regenerable) reference assets derived from the Garmin Pilot's Guide PDF and related sources.
**Tracked:** Yes. This directory and its contents are committed to git.

## Why this directory exists

The extraction output at `assets/gnc355_pdf_extracted/` is gitignored per D-06 because it is regenerable from the source PDF via `scripts/gnc355_pdf_extract.py`. However, some reference assets derived from the PDF are **manually curated** — they require human judgment to isolate (e.g., a specific region of a specific page) and cannot be re-derived automatically.

These curated assets belong in git so they:
- Survive a fresh clone without requiring the original PDF
- Are tracked as first-class references for Stream C2 and downstream spec authoring
- Have provenance and review history via git blame/log

## Contents

### `land-data-symbols.png`

**Created by:** Steve (manual extraction during MANUAL_gnc355_eyeball task, Turn 54)
**Source page:** PDF page 125 of `190-02488-01 rev C` (Garmin Pilot's Guide)
**Purpose:** Canonical legend for land data symbols rendered on the GNC 355's map display.
**Why it's here:** The full PDF extraction flagged page 125 as sparse (text layer incomplete — content is primarily a symbol table rendered as graphics). During the manual eyeball task, Steve determined this page contains substantive content that Stream C2 will need and captured it to PNG. Not regenerable automatically — saved manually.

## Planned additions

- Additional manually-curated symbol tables, charts, or diagrams from the Pilot's Guide if Stream C2 identifies gaps during spec authoring.
- OCR-supplemented text for any pages requiring OCR via the external tool (none required at this time per the eyeball task; 12 of 13 low-confidence pages were verified blank or structural).

## Related

- `docs/tasks/MANUAL_gnc355_eyeball_low_confidence_pages.md` — the eyeball task with filled disposition column
- `assets/gnc355_pdf_extracted/` — regenerable full-PDF extraction (gitignored per D-06)
- `docs/decisions/D-06-gitignore-pdf-extraction-output.md` — gitignore rationale
