---
project: flight-sim
timestamp: 2026-05-02T06:43:32-04:00
type: briefing
instance: purple
authored_by: Purple CD (prior session, Turn 43)
purpose: hand off page-map rebuild work after PyMuPDF-extract V1.0.1 ships
---

# Purple Continuation Briefing — Page-Map Rebuild Track

## Why this briefing exists

The flight-sim page_number_map.json rebuild track was blocked on getting the Garmin printed page identifier (e.g., `2-42`, `3-15`) into a structured per-page format that the build-page-number-map script (or its successor) can consume. The path forward got resolved out-of-session by the yellow/commons track:

> PyMuPDF-extract V1.0.1 is committed and pushed (commits `1df1d19` + `87bcc79`). The tool extracts footer text from any PDF with bbox-region clipping, parses Garmin-style page identifiers, and optionally verifies alignment against a LlamaParse extract using the chapter-anchors JSON pattern. Empirical validation on the GNX 375 PDF: 307/310 pages have parsed `printed_page_number`; 10/10 chapter anchors verified PASS against the existing LlamaParse extract.
>
> For the page_number_map.json build: the data you need is at `<output_dir>/page_metadata.json` after running pymupdf-extract on the GNX 375 PDF. The schema gives you `{"physical_page": ..., "printed_page_number": ...}` per page, ready to transform into whatever downstream format flight-sim expects.
>
> Anchors JSON for future runs lives at `commons/pymupdf-extract/sample_anchors/gnx375_chapter_anchors.json` — 10 anchors verified.

This means flight-sim no longer needs a LlamaParse re-extraction with `extract_printed_page_number=true`. The page-identifier extraction is solved by a separate, deterministic, free-of-credit-cost tool that operates directly on the source PDF. The data flow is:

```
GNX 375 source PDF
       │
       ▼
PyMuPDF-extract V1.0.1
       │
       ▼
page_metadata.json  ──►  page_number_map.json  ──►  downstream consumers
                          (transform step)             (V1 spec citation
                                                       validation, ITM-11)
```

## Where work was paused

Several threads were in flight when this hand-off occurred:

- **Page-map rebuild approach (R-extract):** The proposed plan was to update `commons/llamaparse-extract/llamaparse_extract.py` to V3.3 with `extract_printed_page_number=true` as default, then re-extract the entire GNX 375 manual at a credit cost of ~3100 to recover printed page numbers. **This plan is now superseded by PyMuPDF-extract V1.0.1.** The yellow/commons CD session was briefed to do the V3.3 update; whatever its disposition, the GNX 375 extraction itself does not need to be re-run for the page-map rebuild objective.
- **Live test for `extract_printed_page_number` capture:** The 11-page test (physical pages 1, 2, 8, 17, 18, 80, 125, 293, 300, 308, 310) was designed to verify v2 LlamaParse correctly returns Garmin logical IDs before paying for a full re-extraction. **This test is no longer needed for the page-map track.** It may still be useful as a separate validation of LlamaParse's `extract_printed_page_number` capability, but that's a separate line of inquiry — not on the critical path here.
- **Dependency audit (DEPENDENCY-AUDIT-01):** Pending CC task to inventory references in completed work (`docs/tasks/completed/`), decisions, specs, and scripts that point at retired paths under `assets/retired/gnc355_pdf_extracted/` and `assets/retired/gnc355_reference/`. Not yet drafted.
- **Translation-table follow-on:** Once the new page-map exists, build a translation table between old retired-extraction logical IDs and new page-map values. Speculatively useful for fixing references in completed artifacts. Not yet scoped.
- **D-26 decision log entry:** Multiple D-25-pattern violations accumulated this session (CD asserting external-API behavior or relationships without verification). Three to four distinct instances logged in the conversation but never written to `docs/decisions/`. Tripwire fired.
- **Filesystem MCP issue:** Timed out twice in Turn 38 trying to write a briefing to disk (V3.3 briefing for yellow/commons). MCP recovered by Turn 43. The yellow briefing was delivered inline instead. If MCP times out again, fall back to inline delivery.

## Source-of-truth files (read on demand)

These are the canonical files for the current state. Don't pre-read; load when relevant to the active task.

| File | Purpose |
|------|---------|
| `assets/retired/README.md` | Documents what's in `assets/retired/` and why it was retired |
| `docs/todos/issue_index.md` | Active ITMs including ITM-11 (page-number offset, work-in-progress on rebuild track) |
| `docs/specs/Spec_Tracker.md` | V1 spec lifecycle status (V1 BODY ASSEMBLED; pending C3 review) |
| `docs/tasks/completed/` | Archived task prompts + completion reports (60+ — exact count not verified) |
| `docs/tasks/extraction_inventory_compare_prompt.md` | Halted EXTRACTION-INVENTORY-COMPARE-01 task; pre-flight failed on 330 vs 310 mismatch; still on disk |
| `docs/tasks/gnx375_pagemap_rebuild_prompt.md` | GNX375-PAGEMAP-REBUILD-01 prompt; FAIL on completion (footers absent from new extraction) |
| `docs/tasks/gnx375_pagemap_rebuild_completion.md` | CC's completion report on the failed rebuild |
| `assets/gnx375_llama_extract/` | The canonical extraction (310 pages; missing printed page numbers in per-page output) |
| `assets/Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf` | Source PDF (310 pages confirmed by Steve via Adobe Acrobat) |

The hand-off mention also points to commons:

| File | Purpose |
|------|---------|
| `commons/pymupdf-extract/` | New tool committed at `1df1d19` + `87bcc79`; canonical for footer extraction |
| `commons/pymupdf-extract/sample_anchors/gnx375_chapter_anchors.json` | 10 verified anchors for the GNX 375 manual |

## Suggested next steps

In recommended order. Each is sized as a single CD turn or single CC task — pick what fits Steve's priorities.

### 1. Run PyMuPDF-extract on the GNX 375 PDF — Steve runs the command

The actual invocation is in commons project conventions, not flight-sim's. The new Purple session should ask Steve for the CLI command (or have Steve trigger it on the Mac/Windows — wherever commons is set up). Output target: somewhere under `flight-sim/assets/`, exact path TBD by Steve. Expected output: `<output_dir>/page_metadata.json` with 310 entries.

### 2. Inspect `page_metadata.json` and confirm schema

After Steve runs the extraction, read `page_metadata.json` and confirm:
- 310 entries
- 307 with parsed `printed_page_number`, 3 without (per the briefing's empirical claim)
- Schema is `{"physical_page": <int>, "printed_page_number": <string-or-null>}`

If schema differs, surface the difference before doing anything else.

### 3. Draft the transform step: page_metadata.json → page_number_map.json

The flight-sim `page_number_map.json` schema (per the existing retired one at `assets/retired/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json`) has these top-level fields:

- `physical_to_logical: {<phys_str>: <logical_str_or_"unparseable">}`
- `logical_to_physical: {<logical_str>: <phys_int>}`
- `unparseable_pages: [<phys_int>, ...]`
- `logical_duplicates: [...]`
- `metadata: {extraction_dir, physical_page_count, parsed_count, unparseable_count, generated, ...}`

The transform is mechanical: map `pymupdf` field names to `page_number_map.json` field names. Write a short Python script `scripts/build_page_number_map_from_pymupdf.py` that does this transform deterministically. ~50 lines.

The transform script should NOT use the V1 footer-regex parser (that was for raw text extraction). It just renames fields and rebuilds inverse and duplicate indices.

### 4. Write CC task prompt for the transform step

Save the prompt at `docs/tasks/build_page_number_map_from_pymupdf_prompt.md`. CC writes the script, runs it against `page_metadata.json`, produces `assets/gnx375_llama_extract/page_number_map.json`, runs sanity checks, commits with D-04 trailers.

### 5. Verify ITM-11 anchor citations against the new map

ITM-11's anchor citations (78→80, 80→82, 94→98, 125→129) were derived from the OLD defective extraction. The new map's values at those physical pages will tell us what the ITM-11 citations *should* have been. If the new map says e.g. physical page 80 has printed page number `2-42`, then ITM-11's claim "Garmin logical 78 is at physical 80" still holds if `2-42` corresponds to the 78th body page in Garmin's numbering scheme. This requires a small calibration check: examine the new map's section boundaries and cross-walk to Garmin's logical page-number-by-section numbering.

This is a CD-direct turn. Once verified or corrected, ITM-11 can close.

### 6. Draft DEPENDENCY-AUDIT-01

Pending; deferred from this prior session. Now is a fine time to draft it once the new map exists. The prompt should:

- Inventory references to `assets/retired/gnc355_pdf_extracted/`, `assets/retired/gnc355_reference/`, and pre-move paths `assets/gnc355_pdf_extracted/`, `assets/gnc355_reference/` across `docs/`, `scripts/`, `src/`, `tests/`, `config/`, project-instruction files, and committed artifacts in `docs/tasks/completed/`.
- For each reference, classify as: BROKEN, STALE, or HISTORICAL.
- Build a translation table (per Steve's Turn 33 suggestion): retired logical IDs ↔ new logical IDs.
- Recommend per-item remediation.

Steve's earlier guidance: report decisions inside the decision file itself (don't create a separate report file). Multi-agent CC strategy is appropriate; the audit's parts are independent.

### 7. Write D-26 to the decision log

Multiple D-25-pattern violations accumulated this session:
- Turn 27: Asserted "new extraction is content-complete" based on three boundary spot-checks; did not verify against source PDF
- Turn 28: Asserted "no documented v2 parameter to preserve blank pages" — the parameter exists but is named differently (`extract_printed_page_number` solves the actual underlying problem)
- Turn 30: Asserted old extraction was correct because it ran first; reversed when source PDF revealed 310 pages
- Turn 39: Wrote `--page-ranges` based on the v2 API key without verifying the V3.x CLI flag is `--pages`

D-26 should generalize: CD must ground claims in a primary source — source PDF, schema definition, API docs page, or actual script source — before asserting whether two derived artifacts agree, or which capability exists. Tripwire: any CD turn that reasons about "X is correct because Y" where Y is itself a derivative artifact, not a primary source.

Save to `docs/decisions/D-26-cd-must-ground-claims-in-primary-sources.md`. Same-turn write per existing convention.

### 8. Status doc updates pending

`Spec_Tracker.md`, `CC_Task_Prompts_Status.md`, `priority_task_list.md`, `Task_flow_plan_with_current_status.md` haven't been updated since Turn 14 (C2.2-ASSEMBLE archive). They need:

- GNX375-PAGEMAP-01 archive (the original page-map task that ran against the now-retired extraction; technically completed but its output is retired with that directory)
- GNX375-PAGEMAP-REBUILD-01 FAIL disposition
- EXTRACTION-INVENTORY-COMPARE-01 halt + retire (no longer needed; PyMuPDF approach supersedes the comparison)
- New track: PyMuPDF-based page-map rebuild as the active path
- ITM-11 status: still active; reframed as "rebuild against PyMuPDF metadata"
- ITM-13 status: BOM-in-commit-subject; verify recent commits
- Open new ITM-15 if appropriate: "PyMuPDF-extract V1.0.1 is the canonical path-extraction tool for Garmin-style printed page identifiers"

Run the `check updates` command to refresh.

## Conventions reminder

- Every CD response begins with turn number and ISO 8601 timestamp obtained via `TZ="America/New_York" date "+%Y-%m-%dT%H:%M:%S%:z"`
- Colored-instance turn header format: `## Purple Turn N — YYYY-MM-DDTHH:MM:SS-04:00 ET`
- Colored-instance file naming: `flight-sim-YYYY-MM-DD-HHMM-purple.md` for checkpoints, `flight-sim-YYYY-MM-DD-HHMM-purple-pulse.md` for pulses
- D-04 commit trailer policy: `Task-Id`, `Authored-By-Instance: cd-purple` for CD direct writes; CC commits use `cc`
- BOM-free PowerShell writes via `[System.IO.File]::WriteAllText(...)`, not `Out-File -Encoding utf8`
- Decision log entries written same-turn — never deferred (compaction risk)
- ntfy notification after every git commit: `Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "{message}"`
- CC does not push; CD does not push; only Steve pushes

## What this briefing does NOT cover

- The yellow/commons V3.3 update task — that's the yellow CD session's track
- The live test of `extract_printed_page_number` (designed but not run) — separate from this track now
- The Supplemental AFM (190-02207-a3, 50 pages) — V2 amendment work, deferred until V1 ships
- Spec body work (V1 aggregate review C3, domain-specific reviewers per D-22) — distinct track from page-map rebuild

The next Purple session can come back to those separately or in parallel; the page-map rebuild is the active critical-path item here.

## Open question for Steve at session start

After reading this briefing, the new Purple session should ask:

> "Do you want me to start with running PyMuPDF-extract on the GNX 375 PDF (which needs you to run the command on your machine — I can specify it), or do you want to handle the run yourself and have me start with the transform step once `page_metadata.json` exists?"

Steve will direct from there.
