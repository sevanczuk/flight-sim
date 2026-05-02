---
Created: 2026-05-02T00:00:00-04:00
Source: docs/tasks/dependency_audit_01_prompt.md
Purpose: Inventory of references to retired asset paths; classification; recommended actions
---

# DEPENDENCY-AUDIT-01: Retired Asset Path Reference Audit

## Executive summary

- Total references found: ~304 across ~95 distinct files
- Patch-recommended (categories A, B-active, E-active): 28 lines in **13 files**
- Flag-for-decision (no active replacement, salvage-pending, or archive-candidate): 109 lines in **33 files**
- Leave-as-is (categories D, F, G): 167 lines in 49 files
- Salvage assessment for `land-data-symbols.png`: **Defer** — two active candidates found (`images_screenshot/page_125.jpg`, `images_layout/page_125_chart_1_v2.jpg`); visual inspection required before committing to a replacement path. Interim recommendation: salvage-in-place to `assets/gnx375_reference/land-data-symbols.png`.
- Side-finding: `assets/retired/README.md` references "D-26-* (pending)" but `docs/decisions/D-26-cd-verify-against-ground-truth-source-documents.md` is on disk. README status is stale; CD should update.

**File-count correction (post-compliance):** the executive summary originally claimed 17 patch files / 29 flag files. Compliance review (Purple Turn 22, 2026-05-02) verified the section tables contain 13 distinct patch files and 33 distinct flag files; numbers above corrected. Line counts (28 / 109 / 167) are unchanged.

## Methodology

Ten grep patterns from the prompt's Inventory Targets table were run as `git grep -n -F "<pattern>" -- ':(top)'` from the repo root. Patterns are overlapping by design (e.g., `gnc355_pdf_extracted` subsumes `assets/gnc355_pdf_extracted` and `assets/retired/gnc355_pdf_extracted`); deduplication was applied at the unique file:line level before counting. Each match was classified using the rubric from the prompt. Category D (historical/immutable) results are summarized at the file level rather than enumerated line-by-line; their count (~130 lines across ~42 files) is an estimate. Total counts are approximate (±5%). No files outside `docs/tasks/dependency_audit_01_*.md` were modified.

---

## Findings by retired path

### `assets/retired/gnc355_pdf_extracted/`

#### Subpath: `text_by_page.json`

| File | Line | Content snippet | Category | Recommended action |
|---|---|---|---|---|
| `docs/specs/GNX375_Functional_Spec_V1_outline.md` | 9 | `**Source content:** assets/gnc355_pdf_extracted/text_by_page.json` | A | Patch: reword to `assets/gnx375_llama_extract/full_markdown.md` (format differs; rewording needed) |
| `docs/specs/GNC355_Functional_Spec_V1_outline.md` | 9 | `**Source content:** assets/gnc355_pdf_extracted/text_by_page.json` | A | Patch: annotate as retired source; this is the superseded GNC355 spec |
| `docs/specs/GNX375_Prep_Implementation_Plan_V2.md` | 159 | `Delivered: assets/gnc355_pdf_extracted/text_by_page.json (310 pages...)` | A | Patch: reword to note active replacement; this line also cites `extraction_report.md` and `land-data-symbols.png` |
| `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` | 283 | `raw extracted text at assets/gnc355_pdf_extracted/text_by_page.json` | A | Patch: annotate "(retired; see `assets/retired/gnc355_pdf_extracted/`)" |
| `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` | 295 | `Output directory at assets/gnc355_pdf_extracted/` | A | Patch: annotate "(retired)" |
| `docs/knowledge/355_to_375_outline_harvest_map.md` | 462 | `all pp. 1–310 of assets/gnc355_pdf_extracted/text_by_page.json` | A | Patch: reword to `assets/gnx375_llama_extract/full_markdown.md` |
| `docs/knowledge/355_to_375_outline_harvest_map.md` | 470 | `via assets/gnc355_pdf_extracted/text_by_page.json` | A | Patch: reword to `assets/gnx375_llama_extract/full_markdown.md` |
| `docs/knowledge/gnx375_ifr_navigation_role_research.md` | 5 | `Direct read of assets/gnc355_pdf_extracted/text_by_page.json` | A | Patch: reword to note this research used the old extraction (historical annotation) |
| `docs/knowledge/gnx375_xpdr_adsb_research.md` | 5 | `Python against assets/gnc355_pdf_extracted/text_by_page.json` | A | Patch: reword to note old extraction (historical annotation) |
| `docs/tasks/Task_flow_plan_with_current_status.md` | 77 | `Output to assets/gnc355_pdf_extracted/llamaparse_agentic_v1/` | B | Patch: annotate retired path in task status entry |
| `docs/tasks/Task_flow_plan_with_current_status.md` | 78 | `assets/gnc355_pdf_extracted/images/` | B | Patch: annotate; this task is now QUEUED but refers to retired images dir |
| `docs/tasks/image_extraction_briefing.md` | 16 | `521 embedded images into assets/gnc355_pdf_extracted/images/` | B | Patch: update to `assets/retired/gnc355_pdf_extracted/images/` — task is still queued; input dir has moved |
| `docs/tasks/image_extraction_briefing.md` | 44–47 | Output dirs under `assets/gnc355_pdf_extracted/images_catalog/` | B | Patch: update proposed output dirs to use active path (e.g., `assets/gnx375_llama_extract/images_catalog/`) |
| `docs/tasks/image_extraction_briefing.md` | 66–68 | LlamaParse image subdirs under `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/` | B | Patch: update to `assets/gnx375_llama_extract/` equivalents |
| `docs/tasks/image_extraction_briefing.md` | 136 | Output to `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/images_embedded/` | B | Patch: update to active equivalent path |
| `docs/tasks/image_extraction_briefing.md` | 165–166 | `assets/gnc355_pdf_extracted/images/` and `llamaparse_agentic_v1/` as source dirs | B | Patch: update to retired paths with `assets/retired/` prefix for source; active output target |
| `docs/todos/issue_index.md` | 273 | `assets/gnc355_pdf_extracted/text_by_page.json page 94` | B | Patch: annotate issue note to reference `assets/gnx375_llama_extract/pages/page_094.md` as current source |
| `assets/gnx375_llama_extract/page_number_map.json` | 4 | `"extraction_dir": "assets/gnc355_pdf_extracted/llamaparse_agentic_v1"` | E | Patch: update `metadata.extraction_dir` to `assets/gnx375_llama_extract` |
| `scripts/build_page_number_map.py` | 327 | `default="assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages"` | E | Patch: update default `--pages-dir` to `assets/gnx375_llama_extract/pages` |
| `scripts/build_page_number_map.py` | 332 | `default="assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json"` | E | Patch: update default `--output` to `assets/gnx375_pymupdf_v1_0_1/page_number_map.json` |
| `scripts/build_page_number_map.py` | 360 | `"extraction_dir": "assets/gnc355_pdf_extracted/llamaparse_agentic_v1"` | E | Patch: update hardcoded metadata field to `assets/gnx375_llama_extract` |
| `.gitignore` | 47 | `assets/gnc355_pdf_extracted/` | E | Patch: update to `assets/retired/gnc355_pdf_extracted/` or remove (directory is now tracked under `assets/retired/`; the old ignore rule no longer applies to new extractions at that path) |

#### Subpath: `llamaparse_agentic_v1/` (non-patch matches)

| File | Line | Content snippet | Category | Recommended action |
|---|---|---|---|---|
| `docs/tasks/build_page_number_map_prompt.md` | 14, 26–27, 40, 97, 109, 111–112, 147, 187, 256, 270 | Multiple references to old extraction path | B | Flag: move to `docs/tasks/completed/`; references describe a completed task and become Category D |
| `docs/tasks/build_page_number_map_completion.md` | 11 | Old extraction path in output listing | B | Flag: move to `docs/tasks/completed/` |
| `docs/tasks/gnx375_pagemap_rebuild_prompt.md` | 22, 69 | Old extraction path as prior-task context | B | Flag: move to `docs/tasks/completed/` |
| `docs/tasks/gnx375_pagemap_rebuild_completion.md` | 67, 92, 111, 115 | Old extraction path in comparison table | B | Flag: move to `docs/tasks/completed/` |
| `docs/tasks/pdf_reextraction_llamaparse_prompt.md` | 12, 19, 63–67, 69, 106, 140, 160, 335, 382, 385, 388, 396, 442, 473, 517 | Old extraction dir as script output target | B | Flag: move to `docs/tasks/completed/`; this task produced the retired extraction |
| `docs/tasks/pdf_reextraction_llamaparse_completion.md` | 18, 30 | Old dir in pre-flight and output listing | B | Flag: move to `docs/tasks/completed/` |
| `docs/tasks/extraction_inventory_compare_prompt.md` | 16, 19, 23, 34, 41, 51, 76, 118–119, 154, 168, 217, 252, 258, 265–266, 276, 381–388, 394, 533, 536 | Old path as retirement candidate throughout | B | Flag: move to `docs/tasks/completed/`; this task planned the retirement and is now complete |
| `docs/tasks/extraction_inventory_compare_prompt_deviation.md` | 21, 48, 129 | Old path in deviation context | B | Flag: move to `docs/tasks/completed/` |
| `scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse.py` | 8, 28 | Output comment and `OUTPUT_DIR` assignment | E | Flag: script produces retired-path output; archive or update output dir if ever reused |
| `scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse_with_images.py` | 7, 21, 22, 42 | Comments and `OUTPUT_DIR` for `llamaparse_agentic_v1_with_images/` | E | Flag: same — archive candidate |

#### Subpath: `images/`

| File | Line | Content snippet | Category | Recommended action |
|---|---|---|---|---|
| `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` | 283 | `extracted images at assets/gnc355_pdf_extracted/images/` | A | Patch: annotate "(retired; now under `assets/retired/gnc355_pdf_extracted/images/`)" |
| `docs/tasks/Task_flow_plan_with_current_status.md` | 78 | Catalog `.bin` files in `assets/gnc355_pdf_extracted/images/` | B | Patch: update to `assets/retired/gnc355_pdf_extracted/images/` |
| `docs/tasks/image_extraction_briefing.md` | 16, 165 | Source dir for Approach A image catalog | B | Patch: update source dir to `assets/retired/gnc355_pdf_extracted/images/` |

#### Subpath: `text_by_page.json` (scripts — functional dependencies)

| File | Line | Path | Category | Recommended action |
|---|---|---|---|---|
| `scripts/c22_c_pdf_integrity_check.py` | 3 | `assets/gnc355_pdf_extracted/text_by_page.json` | E | Flag: compliance script for completed C2.2-C work; will fail if run; archive or annotate |
| `scripts/c22_d_compliance_pdf_check.py` | 10 | same | E | Flag: same |
| `scripts/c22c_check_pdf.py` | 4 | same | E | Flag: same |
| `scripts/c22c_check_s12_s13.py` | 5 | same | E | Flag: same |
| `scripts/c22c_check_s14_s15.py` | 4 | same | E | Flag: same |
| `scripts/compliance_s12_overlays.py` | 4 | same | E | Flag: same |
| `scripts/compliance_s13_tabs.py` | 4 | same | E | Flag: same |
| `scripts/compliance_s14_fpl_columns.py` | 4 | same | E | Flag: same |
| `scripts/compliance/c22_f/check_json_pages.py` | 3 | same | E | Flag: same |
| `scripts/compliance/c22_f/check_json_structure.py` | 3 | same | E | Flag: same |
| `scripts/compliance/c22_f/read_pdf_pages.py` | 3 | same | E | Flag: same |
| `scripts/compliance/c22_f/read_pdf_pages_fixed.py` | 3 | same | E | Flag: same |
| `scripts/compliance/c22_f/read_pdf_pages_utf8.py` | 5 | same | E | Flag: same |
| `scripts/verify_fragment_a_page_refs.py` | 4 | same | E | Flag: same |
| `scripts/gnc355_pdf_extract.py` | 373, 384 | Creates `text_by_page.json` at output dir | E | Flag: script writes old-format JSON; if rerun it will write to default or specified output dir; archive or update format |

#### Subpath: `land-data-symbols.png`

| File | Line | Content snippet | Category | Recommended action |
|---|---|---|---|---|
| `docs/tasks/MANUAL_gnc355_eyeball_low_confidence_pages.md` | 7, 18, 26, 41, 100, 107–109 | Land-data-symbols references and old extraction paths | B | Flag: move to `docs/tasks/completed/`; task is marked COMPLETE |
| `docs/tasks/dependency_audit_prompt.md` | 5, 14, 39, 43, 47, 58, 100, 131, 162, 199 | References to retired paths as audit subjects | B | Flag: superseded by `dependency_audit_01_prompt.md`; archive or delete |

#### Bare-name pattern `gnc355_pdf_extract` (without `_extracted` suffix)

No directory path references found. Only matches are: a comment in `.gitignore` (already counted), a task label in `CC_Task_Prompts_Status.md`, and the self-reference in `dependency_audit_01_prompt.md`. No older archive subdirectory named `gnc355_pdf_extract/` (without the `d`) exists in the repo.

---

### `assets/retired/gnc355_reference/`

#### Subpath: `land-data-symbols.png` — pre-retirement references (`assets/gnc355_reference/`)

| File | Line | Content snippet | Category | Recommended action |
|---|---|---|---|---|
| `docs/specs/GNX375_Functional_Spec_V1_outline.md` | 252, 1448 | `assets/gnc355_reference/land-data-symbols.png` | A | Flag: pending salvage decision — replacement path TBD |
| `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` | 457, 758 | same | A | Flag: aggregate is an artifact; patch the canonical parts instead |
| `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` | 463 | same | A | Flag: canonical part; highest-priority patch once salvage path resolved |
| `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` | 252 | same | A | Flag: canonical part; highest-priority patch once salvage path resolved |
| `docs/specs/GNC355_Functional_Spec_V1_outline.md` | 247, 1306 | same | A | Flag: superseded 355 spec; lower priority; patch or annotate |
| `docs/specs/GNX375_Prep_Implementation_Plan_V2.md` | 159 | `curated supplement assets/gnc355_reference/land-data-symbols.png` | A | Flag: reword once salvage path is resolved |
| `docs/tasks/completed/c22_a_prompt.md` | 50 | `assets/gnc355_reference/land-data-symbols.png` | D | Leave (completed task record) |
| `docs/tasks/completed/c22_b_prompt.md` | 56, 104, 242, 372, 492 | same | D | Leave |
| `docs/tasks/completed/c22_b_completion.md` | 47, 144 | same | D | Leave |
| `docs/tasks/completed/c22_b_compliance.md` | 45 | same | D | Leave |
| `docs/tasks/completed/c22_b_compliance_prompt.md` | 15, 93 | same | D | Leave |
| `docs/tasks/completed/c2_1_outline_prompt.md` | 16, 35 | same | D | Leave |
| `docs/tasks/completed/c2_1_outline_completion.md` | 22 | same | D | Leave |
| `docs/tasks/completed/c2_1_375_outline_prompt.md` | 37, 68 | same | D | Leave |
| `docs/tasks/completed/c2_1_375_outline_completion.md` | 26 | same | D | Leave |
| `project-status/flight-sim-2026-04-20-1010-purple-briefing.md` | 108 | same | D | Leave |
| `project-status/flight-sim-2026-04-20-1010-purple.md` | 90, 128, 130, 164 | same | D | Leave |
| `project-status/flight-sim-2026-04-22-1100-purple-briefing.md` | 107 | same | D | Leave |

---

### Bare-name matches (`gnc355_pdf_extracted`, `gnc355_reference`, `llamaparse_agentic_v1`)

These patterns catch all the same matches as the prefixed patterns above plus a few additional context-only hits. After deduplication, no new actionable matches were found beyond what is already enumerated above. The bare `gnc355_pdf_extracted` pattern did match `assets/retired/README.md:16` (section heading `### gnc355_pdf_extracted/`) and `assets/retired/gnc355_reference/README.md` entries — these are Category G (retired-doc internal) and are enumerated in the Leave-as-is summary.

---

## Salvage assessment: `land-data-symbols.png`

**Files on disk:**
- `assets/retired/gnc355_reference/land-data-symbols.png` — 65,861 bytes (manually curated by Steve from PDF p. 125)
- `assets/retired/gnc355_pdf_extracted/land-data-symbols.png` — 65,861 bytes (identical size; same image, placed here when PyMuPDF missed the image-only page)

Both copies are present and accessible.

**Active extraction candidates for p. 125:**
- `assets/gnx375_llama_extract/images_screenshot/page_125.jpg` — exists (full-page screenshot)
- `assets/gnx375_llama_extract/images_layout/page_125_chart_1_v2.jpg` — exists (chart extract)
- `assets/gnx375_llama_extract/images_screenshot/` contains no `page_125_chart_*` files

**Subdirectory correction (post-compliance):** the original report placed `page_125_chart_1_v2.jpg` in `images_screenshot/`. Compliance review (Purple Turn 22, 2026-05-02) verified by direct `ls` that the file lives in `images_layout/`. Path label corrected; the salvage recommendation (defer + interim salvage-in-place) is unchanged.

**V1 fragments referencing this image:**
From Phase A inventory — four files in active-spec territory:
- `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md:463`
- `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md:252`
- `docs/specs/GNX375_Functional_Spec_V1_outline.md:252, 1448`
- `docs/specs/GNX375_Functional_Spec_V1_aggregate.md:457, 758` (artifact, derived from parts)

**Recommendation: Defer**

Two active candidates exist. Without visual inspection, it is not determinable whether `page_125_chart_1_v2.jpg` (the more targeted extract) is a suitable equivalent for the manually curated symbols-legend PNG, or whether `page_125.jpg` (the full-page screenshot) would suffice. The curated image was specifically pulled because PyMuPDF missed the page — the manual crop may capture a region that neither automated extraction reproduced faithfully.

**Interim recommendation:** Salvage-in-place — relocate `assets/retired/gnc355_reference/land-data-symbols.png` to `assets/gnx375_reference/land-data-symbols.png` (new directory) before final move-out, and patch the 6 A-category references to this new path. This preserves the known-good manual extract unconditionally. Steve or CD should visually compare with the `images_screenshot/page_125.jpg` and `images_layout/page_125_chart_1_v2.jpg` candidates; if either is equivalent, the `gnx375_reference/` copy can be retired.

---

## Compliance review notes (added Purple Turn 22, 2026-05-02)

Compliance verification (`docs/tasks/dependency_audit_01_compliance.md`) returned `FAILURES FOUND` (6 PASS / 3 FAIL / 2 PARTIAL of 11 checks). Disposition: PASS WITH NOTES. The three FAILs and two PARTIALs are documented here.

### N2 (FAIL): image path label corrected

The original report cited `images_screenshot/page_125_chart_1_v2.jpg` as a salvage candidate. The file is actually in `images_layout/page_125_chart_1_v2.jpg`. Verified by direct `ls` in compliance review. Path label corrected in Salvage Assessment section above; salvage recommendation (defer + interim salvage-in-place) is unchanged. The wrong directory label has no other downstream consumers.

### M2 (PARTIAL): file counts in executive summary corrected

Original exec summary claimed 17 patch files and 29 flag files. Compliance recount of the section tables found 13 distinct patch files and 33 distinct flag files. Line counts (28 / 109 / 167) are correct. File-count discrepancy resulted from the original count tallying file appearances across subsections rather than deduplicated unique-file counts. Corrected numbers in exec summary above.

### O1 (FAIL): sort ordering not corrected

The report's tables are organized by file-type grouping rather than strict path-then-line ascending order. Compliance check found violations in all 3 sampled tables. The tables remain readable; sortability would only matter for downstream tool consumption, and no downstream tool consumes this report. Documented for posterity; tables not re-sorted.

### E1 (PARTIAL): off-by-one on `.gitignore`

The report cited `.gitignore:47` for the `assets/gnc355_pdf_extracted/` ignore rule. Line 47 is actually a comment; the rule itself is on line 48. Within the compliance prompt's ±2 allowance. Both lines should be updated together in any patch-execution turn that touches `.gitignore`.

### M1 (FAIL): count drift, partly attributable to compliance-prompt design

Compliance recount produced 539 raw matches and 429 after excluding the audit's own output files (vs the report's claim of ~304). Per the compliance report's own note, "the M1 check criterion is somewhat self-defeating when applied post-commit" because the audit's outputs (now committed and tracked) themselves contain extensive references to retired paths. A definitively comparable count would require running `git grep` against the audit's commit tree (`2cc421d`) rather than HEAD. The exact ground-truth count at audit-execution time is therefore not recoverable from this compliance round.

**Mitigation captured in D-32** (forthcoming this turn): future compliance prompts that recount grep-based audits must specify a baseline git ref (the audit's commit) and explicitly exclude the audit's own output files. The audit's substantive content (patch list, flag list, salvage recommendation, side findings) is unaffected by this counting issue.

---

## Recommended actions summary

### Patch list (categories A, B-active, E-active, with active replacement)

| File | Line(s) | Current path | Proposed replacement | Notes |
|---|---|---|---|---|
| `docs/specs/GNX375_Functional_Spec_V1_outline.md` | 9 | `assets/gnc355_pdf_extracted/text_by_page.json` | `assets/gnx375_llama_extract/full_markdown.md` | Reword; format differs (JSON → markdown) |
| `docs/specs/GNC355_Functional_Spec_V1_outline.md` | 9 | `assets/gnc355_pdf_extracted/text_by_page.json` | Annotate "(retired)" | Superseded 355 spec; lower priority |
| `docs/specs/GNX375_Prep_Implementation_Plan_V2.md` | 159 | Multiple retired paths | Annotate all three | One line; all three paths on same line |
| `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` | 283, 295 | `assets/gnc355_pdf_extracted/...` | Annotate "(retired; see `assets/retired/`)" | Old plan document |
| `docs/knowledge/355_to_375_outline_harvest_map.md` | 462, 470 | `assets/gnc355_pdf_extracted/text_by_page.json` | `assets/gnx375_llama_extract/full_markdown.md` | Reword |
| `docs/knowledge/gnx375_ifr_navigation_role_research.md` | 5 | `assets/gnc355_pdf_extracted/text_by_page.json` | Annotate "(old extraction; replaced by `gnx375_llama_extract`)" | Historical method note |
| `docs/knowledge/gnx375_xpdr_adsb_research.md` | 5 | `assets/gnc355_pdf_extracted/text_by_page.json` | Annotate "(old extraction)" | Same |
| `docs/tasks/Task_flow_plan_with_current_status.md` | 77, 78 | `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/`, `images/` | Append "(now `assets/retired/`)" | Status-field annotation |
| `docs/tasks/image_extraction_briefing.md` | 16, 44–47, 66–68, 136, 165–166 | `assets/gnc355_pdf_extracted/images/`, `llamaparse_agentic_v1/` subdirs | Source dirs: add `retired/` prefix. Output dirs: reroute to `assets/gnx375_llama_extract/` | This task is still QUEUED; briefing must reflect current paths |
| `docs/todos/issue_index.md` | 273 | `assets/gnc355_pdf_extracted/text_by_page.json page 94` | `assets/gnx375_llama_extract/pages/page_094.md` | Update issue note to current source |
| `assets/gnx375_llama_extract/page_number_map.json` | 4 | `"extraction_dir": "assets/gnc355_pdf_extracted/llamaparse_agentic_v1"` | `"extraction_dir": "assets/gnx375_llama_extract"` | Metadata field only; one-line edit |
| `scripts/build_page_number_map.py` | 327, 332, 360 | Old extraction defaults | `--pages-dir`: `assets/gnx375_llama_extract/pages`; `--output`: `assets/gnx375_pymupdf_v1_0_1/page_number_map.json`; hardcoded dir: `assets/gnx375_llama_extract` | Active script; stale defaults will cause errors if run |
| `.gitignore` | 47 | `assets/gnc355_pdf_extracted/` | Remove line or update to `assets/retired/gnc355_pdf_extracted/` | Stale rule; directory no longer lives at this path |

### Flag list (needs CD decision)

| File | Line(s) | Current path | Issue | Notes |
|---|---|---|---|---|
| `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` | 463 | `assets/gnc355_reference/land-data-symbols.png` | No confirmed replacement path | Canonical spec part; patch after salvage decision |
| `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` | 252 | `assets/gnc355_reference/land-data-symbols.png` | Same | Canonical spec part; highest-priority after salvage |
| `docs/specs/GNX375_Functional_Spec_V1_outline.md` | 252, 1448 | `assets/gnc355_reference/land-data-symbols.png` | Same | |
| `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` | 457, 758 | `assets/gnc355_reference/land-data-symbols.png` | Same | Aggregate; patch part files, regenerate aggregate |
| `docs/specs/GNC355_Functional_Spec_V1_outline.md` | 247, 1306 | `assets/gnc355_reference/land-data-symbols.png` | Same | Lower priority (355 spec superseded by 375) |
| `docs/tasks/build_page_number_map_prompt.md` | 14, 26–27, 40, 97, 109, 111–112, 147, 187, 256, 270 | Multiple old paths | Completed task not yet archived | Move to `docs/tasks/completed/`; becomes Category D |
| `docs/tasks/build_page_number_map_completion.md` | 11 | Old extraction path | Same | Move to `completed/` |
| `docs/tasks/gnx375_pagemap_rebuild_prompt.md` | 22, 69 | Old extraction path | Same | Move to `completed/` |
| `docs/tasks/gnx375_pagemap_rebuild_completion.md` | 67, 92, 111, 115 | Old extraction path | Same | Move to `completed/` |
| `docs/tasks/pdf_reextraction_llamaparse_prompt.md` | 12, 19, 63–67, 69, 106, 140, 160, 335, 382, 385, 388, 396, 442, 473, 517 | Old extraction as output target | Same | Move to `completed/` |
| `docs/tasks/pdf_reextraction_llamaparse_completion.md` | 18, 30 | Old paths | Same | Move to `completed/` |
| `docs/tasks/extraction_inventory_compare_prompt.md` | ~20 lines | Old path as retirement candidate | Same | Move to `completed/` |
| `docs/tasks/extraction_inventory_compare_prompt_deviation.md` | 21, 48, 129 | Old path | Same | Move to `completed/` |
| `docs/tasks/MANUAL_gnc355_eyeball_low_confidence_pages.md` | 7, 18, 26, 41, 100, 107–109 | Old paths + land-data-symbols ref | Marked COMPLETE; not in `completed/` | Move to `completed/`; references describe historical task context |
| `docs/tasks/dependency_audit_prompt.md` | ~10 lines | Old and retired paths as audit subject | Superseded by `dependency_audit_01_prompt.md` | Archive or delete this predecessor draft |
| `docs/tasks/CC_Task_Prompts_Status.md` | 29 | `assets/retired/gnc355_pdf_extracted/`, `assets/retired/gnc355_reference/` | Describes audit scope accurately | CD-maintained; no action needed from CC; note that references are correct descriptions of the audit task |
| `scripts/c22_c_pdf_integrity_check.py` | 3 | `assets/gnc355_pdf_extracted/text_by_page.json` | Script will fail; C2.2-C work complete | Archive to `scripts/archived/` or delete |
| `scripts/c22_d_compliance_pdf_check.py` | 10 | same | Same | Archive or delete |
| `scripts/c22c_check_pdf.py` | 4 | same | Same | Archive or delete |
| `scripts/c22c_check_s12_s13.py` | 5 | same | Same | Archive or delete |
| `scripts/c22c_check_s14_s15.py` | 4 | same | Same | Archive or delete |
| `scripts/compliance_s12_overlays.py` | 4 | same | Same | Archive or delete |
| `scripts/compliance_s13_tabs.py` | 4 | same | Same | Archive or delete |
| `scripts/compliance_s14_fpl_columns.py` | 4 | same | Same | Archive or delete |
| `scripts/compliance/c22_f/check_json_pages.py` | 3 | same | Same | Archive or delete |
| `scripts/compliance/c22_f/check_json_structure.py` | 3 | same | Same | Archive or delete |
| `scripts/compliance/c22_f/read_pdf_pages.py` | 3 | same | Same | Archive or delete |
| `scripts/compliance/c22_f/read_pdf_pages_fixed.py` | 3 | same | Same | Archive or delete |
| `scripts/compliance/c22_f/read_pdf_pages_utf8.py` | 5 | same | Same | Archive or delete |
| `scripts/verify_fragment_a_page_refs.py` | 4 | same | Same | Archive or delete |
| `scripts/gnc355_pdf_extract.py` | 373, 384 | Writes `text_by_page.json` to output dir | Old-format output; PyMuPDF-era script | Retain for regenerability (D-06) but annotate as superseded by LlamaParse extraction |
| `scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse.py` | 8, 28 | `assets/gnc355_pdf_extracted/llamaparse_agentic_v1` | Produced retired extraction | Archive to `scripts/archived/` or annotate |
| `scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse_with_images.py` | 7, 21, 22, 42 | same | Same | Archive or annotate |

### Leave-as-is summary (categories D, F, G)

**Category D (historical/immutable) — ~130 lines across ~42 files.** All `docs/decisions/` files (D-06, D-22, D-26, D-30) reference old extraction paths as part of recording decisions made when those paths were active — the historical record is correct and must not be rewritten. All `docs/tasks/completed/` task prompt, completion, and compliance files (c2_1_outline, c2_1_375_outline, c22_a through c22_g, gnc355_pdf_extract, itm_01_file_movement) reference old paths as part of recording the contemporaneous state of completed work. All `project-status/` checkpoint and briefing files record the project state as it existed at each point in time. The handoff briefing at `docs/handoffs/llamaparse_extract_v3.3_upgrade_briefing.md` describes the mid-retirement state at time of writing. None of these should be modified; they are the audit trail.

**Category F (self-reference) — ~25 lines in 1 file.** `docs/tasks/dependency_audit_01_prompt.md` contains extensive references to all retired paths as part of specifying this audit task. These are intentional and correct.

**Category G (retired-doc internal) — ~12 lines across 6 files.** References within `assets/retired/README.md`, `assets/retired/gnc355_pdf_extracted/llamaparse_agentic_v1/extraction_log.json`, `extraction_report.md`, `page_number_map.json`, `llamaparse_agentic_v1_with_images/extraction_log.json`, and `assets/retired/gnc355_reference/README.md` document the retired material's provenance. Read-only; leave as-is.

---

## Side findings

1. **`assets/retired/README.md` references "D-26-* (pending)".** `docs/decisions/D-26-cd-verify-against-ground-truth-source-documents.md` exists on disk (verified during pre-flight). The README's "pending" annotation is stale. CD should update the README's Related section to remove "(pending)" from the D-26 entry.

2. **`docs/tasks/CC_Task_Prompts_Status.md` has unstaged modifications** (observed in git status at session start). This audit did not interact with this file; the modification predates the audit session.

3. **`docs/tasks/image_extraction_briefing.md` is still QUEUED.** The image catalog task references `assets/gnc355_pdf_extracted/images/` as its source directory. This task cannot proceed in its current state because the source directory is now at `assets/retired/gnc355_pdf_extracted/images/`. The briefing requires patching before the image catalog task can be executed. This is the most time-sensitive B-category patch.

4. **`scripts/build_page_number_map.py` default paths are doubly stale.** The script's `--pages-dir` default points to `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages/` (330 pages, defective) and its hardcoded `extraction_dir` in the output JSON also writes the old path. Running the script without flags would produce incorrect output both for page-source (wrong extraction) and metadata (wrong path label). This is a functional regression risk; patch before this script is used again.

5. **`assets/gnx375_llama_extract/page_number_map.json` has a stale `extraction_dir` metadata field.** The file at `assets/gnx375_llama_extract/page_number_map.json` (line 4) records `"extraction_dir": "assets/gnc355_pdf_extracted/llamaparse_agentic_v1"` because it was relocated from the old extraction path without updating the metadata. This is a one-line fix and should accompany the `build_page_number_map.py` patch.
