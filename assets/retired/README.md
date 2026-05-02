# Retired Assets

**Created:** 2026-04-30T12:00:01-04:00
**Source:** CD Purple Turn 32 — recording the retirement of two `gnc355_*` directories per the D-12 GNX 375 pivot and the Turn 30 discovery that the older PDF extraction is defective.
**Tracked:** Yes. Contents in this directory remain in git for audit and reference until the dependency-audit cleanup is complete; after that, the directory will be moved out of the project entirely.

## Purpose

This directory houses former-`assets/`-resident material that has been removed from active use but is preserved temporarily for two reasons:

1. **Audit trail.** Some completed work (V1 spec fragments, prior task reports, the ITM-11 page-map effort) was authored against content that lived under these paths. Until a dependency audit confirms what consumed retired data and what — if anything — needs reconciliation, the retired material must remain readable in-place.
2. **Salvage window.** Some items in retired directories may be unique and non-regenerable; the audit will determine whether any survive the move-out as relocated assets in `assets/`.

## What's here

### `gnc355_pdf_extracted/`

The pre-pivot PDF extraction, including:

- `llamaparse_agentic_v1/` — the original LlamaParse run using `llama_parse 0.6.94` with `parse_page_with_agent`. Produced 330 pages of markdown plus `page_number_map.json`. **Defective:** the source PDF has 310 pages (Steve confirmed via Adobe Acrobat, 2026-04-30); this extraction inflated the count by 20 phantom pages whose locations within the document are not mapped. Any physical-page-number-based references to this extraction are unreliable.
- `images/` — PyMuPDF-era binary image extracts (`page_NNNN_img_NN.bin`, ~400 files covering pages 1–272). Pre-LlamaParse era; superseded by `gnx375_llama_extract/images_layout/` and `images_screenshot/`.
- `text_by_page.json` — PyMuPDF-era full-text-by-page JSON. Pre-LlamaParse era; superseded by `gnx375_llama_extract/full_markdown.md`.
- `extraction_report.md` — historical PyMuPDF extraction audit report.
- `land-data-symbols.png` — Steve's manual pull from p. 125 of the source PDF, originally placed here when PyMuPDF missed image-only pages. Its retained-asset twin lives at `gnc355_reference/land-data-symbols.png` (the curated copy referenced by the V1 spec).
- `llamaparse_agentic_v1_with_images/` — partial cache-test scaffolding (`CACHE_TEST_RESULT.md`, mostly-empty subdirectories). Not authoritative; preserved only for completeness.

### `gnc355_reference/`

The pre-pivot curated reference asset directory, originally established as the long-term-stable home for non-regenerable PDF-derived assets. Contains:

- `land-data-symbols.png` — Garmin's land-data-symbols legend, manually extracted from PDF p. 125 by Steve during the eyeball task. **Possibly cited by the V1 spec** at `assets/gnc355_reference/land-data-symbols.png`. The dependency audit will confirm whether the equivalent image is present in `gnx375_llama_extract/images_layout/` or `images_screenshot/`, and either retire this asset alongside the rest or relocate it to a renamed `assets/gnx375_reference/` (or equivalent) before final move-out.
- `README.md` — the original directory's provenance and purpose record. Read it for the historical context of why the directory existed.

## Policy

- **No active work should reference paths under `assets/retired/`.** All in-repo references are being patched out as part of the dependency audit (see `docs/tasks/dependency_audit_*`).
- **Do not modify retired material.** It is read-only for audit purposes. Bug fixes, regeneration, or supersession happen in the active assets (`assets/gnx375_llama_extract/` and any future `assets/gnx375_reference/`), not here.
- **The directory is temporary.** Once the dependency audit completes, every retired item will be either (a) confirmed redundant and the directory moved out of the project entirely, or (b) salvaged into a renamed active location with the rest moved out.

## Related

- `docs/decisions/D-12-*` (or successor) — GNX 375 pivot rationale.
- `docs/decisions/D-25-*` — CD's verify-before-asserting convention; the discovery that the old extraction was defective came from violating this convention multiple times.
- `docs/decisions/D-26-cd-verify-against-ground-truth-source-documents.md` — generalized verify-against-ground-truth discipline (created 2026-04-30).
- `docs/decisions/D-30-v1-fragment-citations-use-physical-pdf-page-numbers.md` — V1 fragment citations use absolute physical PDF page numbers; closed ITM-11.
- `docs/todos/issue_index_resolved.md` §ITM-11 — the page-number offset issue, closed 2026-05-02 by 13/13 content-match verification.
- `docs/tasks/dependency_audit_01_*` — the audit producing the reference patch list, the work-dependency report, and the salvage recommendations (executed 2026-05-02).
