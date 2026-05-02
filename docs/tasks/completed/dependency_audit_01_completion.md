---
Created: 2026-05-02T00:00:00-04:00
Source: docs/tasks/dependency_audit_01_prompt.md
---

# DEPENDENCY-AUDIT-01: Completion Report

## Phase 0: Source-of-Truth Audit

Result: **all retired paths covered.**

Every retired path enumerated in `assets/retired/README.md` is addressed by at least one grep pattern in the prompt's Inventory Targets table:
- `gnc355_pdf_extracted/llamaparse_agentic_v1/` → pattern `llamaparse_agentic_v1`
- `gnc355_pdf_extracted/images/` → prefix pattern `assets/gnc355_pdf_extracted`
- `gnc355_pdf_extracted/text_by_page.json` → pattern `text_by_page.json`
- `gnc355_pdf_extracted/extraction_report.md` → prefix pattern (subsumed)
- `gnc355_pdf_extracted/land-data-symbols.png` → pattern `land-data-symbols.png`
- `gnc355_pdf_extracted/llamaparse_agentic_v1_with_images/` → pattern `llamaparse_agentic_v1` (prefix match via `-F`)
- `gnc355_reference/land-data-symbols.png` → pattern `land-data-symbols.png`
- `gnc355_reference/README.md` → prefix pattern `assets/retired/gnc355_reference`

Side-finding from Phase 0: the README references "D-26-* (pending)" but D-26 is on disk. Flagged in report Side Findings §1.

## Pre-flight Check Results

| # | Check | Outcome |
|---|---|---|
| 1 | `assets/retired/README.md` exists; opens with `# Retired Assets` and 2026-04-30 created-date | **PASS** — file is 4,725 bytes; header confirmed |
| 2 | `assets/retired/gnc355_pdf_extracted/` and `assets/retired/gnc355_reference/` exist | **PASS** — both directories present |
| 3 | `assets/gnx375_llama_extract/` and `assets/gnx375_pymupdf_v1_0_1/` exist; pages/ present | **PASS** — both active replacement dirs confirmed; pages/ has 310 files |
| 4 | Repo root layout: `docs/`, `scripts/`, `src/`, `tests/`, `config/` present; `CLAUDE.md`, `claude-conventions.md`, `cc_safety_discipline.md`, `claude-memory-edits.md` present | **PASS** — all directories and project-instruction files found |

No deviations; proceeded to Phase A.

## Per-Phase Outcome Summary

**Phase A — Inventory:** 10 patterns run. Results:

| Pattern | Matches (approx) | Notes |
|---|---|---|
| `assets/retired/gnc355_pdf_extracted` | ~18 in ~9 files | Primarily task/status files describing the retired dir |
| `assets/retired/gnc355_reference` | ~12 in ~8 files | Similar |
| `assets/gnc355_pdf_extracted` | ~204 in ~70 files | Large; dominates the count |
| `assets/gnc355_reference` | ~50 in ~25 files | Spec and task files primarily |
| `gnc355_pdf_extracted` | Subsumes above; ~204+ | No additional unique lines beyond the prefixed patterns |
| `gnc355_reference` | Subsumes above; ~50+ | Same |
| `llamaparse_agentic_v1` | ~75 in ~25 files | Heavy overlap with `gnc355_pdf_extracted` pattern |
| `text_by_page.json` | ~90 in ~40 files | Most in completed/ and scripts/ |
| `land-data-symbols.png` | ~45 in ~25 files | Active specs + completed task records |
| `gnc355_pdf_extract` (bare) | 3 (comment, task label, self-ref) | No directory path matches found for the bare-name variant |

After deduplication across overlapping patterns: **~304 unique file:line matches across ~95 distinct files.**

**Phase B — Classification:**
- Category A (active spec/doc): 17 lines in 10 files
- Category B (active task/todo): ~100 lines in 14 files
- Category C (project-instruction files): 0 matches
- Category D (historical/immutable): ~130 lines in ~42 files
- Category E (code/config/scripts): ~27 lines in 20 files
- Category F (self-reference): ~25 lines in 1 file
- Category G (retired-doc internal): ~12 lines in 6 files

**Phase C — Salvage assessment:** Both `land-data-symbols.png` copies confirmed on disk (65,861 bytes each, identical). Two active candidates in `images_screenshot/`: `page_125.jpg` and `page_125_chart_1_v2.jpg`. Recommendation: **Defer** (visual inspection required); interim: salvage-in-place to `assets/gnx375_reference/land-data-symbols.png`.

**Phase D — Report assembly:** `docs/tasks/dependency_audit_01_report.md` written. Sections: Executive summary, Methodology, Findings by retired path (4 subsections), Salvage assessment, Recommended actions summary (patch list 14 entries, flag list 31 entries), Leave-as-is summary, Side findings (5 items).

## Final Empirical Numbers (from report executive summary)

- Total references: ~304 across ~95 distinct files
- Patch-recommended (A + B-active + E-active): 28 lines in 17 files
- Flag-for-decision (pending salvage, completed-not-archived, compliance scripts): 109 lines in 29 files
- Leave-as-is (D + F + G): 167 lines in 49 files
- Salvage recommendation: Defer; interim salvage-in-place to `assets/gnx375_reference/`

## Deviations from Prompt

None. All 10 grep patterns were run as specified. No ambiguous categories required special handling beyond what the rubric defined. The `gnc355_pdf_extract` (bare) pattern produced no directory-path matches (only a comment and task label), as anticipated by the prompt note "Possibly absent now; include for completeness."
