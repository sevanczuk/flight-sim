---
Created: 2026-05-04T00:00:00-04:00
Source: docs/tasks/audit_cleanup_01_prompt.md
---

# AUDIT-CLEANUP-01 Completion Report

## Phase 0: Source-of-Truth Audit

Read `docs/tasks/completed/dependency_audit_01_report.md` (Recommended actions summary, Flag list, Compliance review notes, Salvage assessment). Read this prompt in full. Cross-referenced all operations:

- Phase A (11 task file moves) → Flag list "Move to `docs/tasks/completed/`" entries ✓
- Phase B (16 compliance script moves) → Flag list "Archive or delete" entries for compliance scripts ✓
- Phase C (3-line edit to build_page_number_map.py) → Side Finding #4 + Patch list entries for lines 327, 332, 360 ✓
- Phase A #11 (image_extraction_briefing.md archived) → Purple Turn 15 image-extraction-retired status; archived rather than patched ✓
- Phase D (land-data-symbols.png removal) → Steve's directive Purple Turn 25 superseding audit's salvage-defer recommendation ✓

**Phase 0: all operations trace to audit findings or Steve directive**

---

## Pre-flight Check Results

1. **Audit report exists:** PASS — `docs/tasks/completed/dependency_audit_01_report.md` present
2. **11 task files exist:** PASS — all 11 files confirmed present
3. **16 script files exist:** PASS — all 16 files confirmed present
4. **build_page_number_map.py stale defaults:** PASS — lines 327, 332, 360 contain `gnc355_pdf_extracted/llamaparse_agentic_v1` as expected
5. **land-data-symbols.png references:** PASS — found at Fragment A:463, Fragment B:252, GNX375 outline:252+1448, GNC355 outline:247+1306, Prep V2:159; plus aggregate (artifact), completed tasks and project-status (historical)
6. **Binary files:** PASS — both present at 65,861 bytes each
7. **Destination directories:** PASS — `docs/tasks/completed/` exists; `scripts/archived/` absent (created as first action of Phase B)
8. **Assembly script:** PASS — `scripts/assemble_gnx375_spec.py` exists; manifest is `docs/specs/GNX375_Functional_Spec_V1.md` (confirmed from aggregate header; no .json manifest file exists)

---

## Phase A: 11 task file moves to `docs/tasks/completed/`

All moves executed via `git mv`. All 11 files confirmed moved.

| # | File | Outcome |
|---|---|---|
| 1 | `docs/tasks/build_page_number_map_prompt.md` | MOVED |
| 2 | `docs/tasks/build_page_number_map_completion.md` | MOVED |
| 3 | `docs/tasks/gnx375_pagemap_rebuild_prompt.md` | MOVED |
| 4 | `docs/tasks/gnx375_pagemap_rebuild_completion.md` | MOVED |
| 5 | `docs/tasks/pdf_reextraction_llamaparse_prompt.md` | MOVED |
| 6 | `docs/tasks/pdf_reextraction_llamaparse_completion.md` | MOVED |
| 7 | `docs/tasks/extraction_inventory_compare_prompt.md` | MOVED |
| 8 | `docs/tasks/extraction_inventory_compare_prompt_deviation.md` | MOVED |
| 9 | `docs/tasks/MANUAL_gnc355_eyeball_low_confidence_pages.md` | MOVED |
| 10 | `docs/tasks/dependency_audit_prompt.md` | MOVED |
| 11 | `docs/tasks/image_extraction_briefing.md` | MOVED (archived rather than patched; image extraction retired Turn 15) |

Verification: `ls docs/tasks/build_page_number_map_prompt.md` → "No such file or directory" → MOVED confirmed.

---

## Phase B: 16 compliance script moves to `scripts/archived/`

Created `scripts/archived/` (did not exist). Ran collision check — no name collisions. All 16 moves via `git mv`.

| # | Source | Destination | Outcome |
|---|---|---|---|
| 1 | `scripts/c22_c_pdf_integrity_check.py` | `scripts/archived/c22_c_pdf_integrity_check.py` | MOVED |
| 2 | `scripts/c22_d_compliance_pdf_check.py` | `scripts/archived/c22_d_compliance_pdf_check.py` | MOVED |
| 3 | `scripts/c22c_check_pdf.py` | `scripts/archived/c22c_check_pdf.py` | MOVED |
| 4 | `scripts/c22c_check_s12_s13.py` | `scripts/archived/c22c_check_s12_s13.py` | MOVED |
| 5 | `scripts/c22c_check_s14_s15.py` | `scripts/archived/c22c_check_s14_s15.py` | MOVED |
| 6 | `scripts/compliance_s12_overlays.py` | `scripts/archived/compliance_s12_overlays.py` | MOVED |
| 7 | `scripts/compliance_s13_tabs.py` | `scripts/archived/compliance_s13_tabs.py` | MOVED |
| 8 | `scripts/compliance_s14_fpl_columns.py` | `scripts/archived/compliance_s14_fpl_columns.py` | MOVED |
| 9 | `scripts/verify_fragment_a_page_refs.py` | `scripts/archived/verify_fragment_a_page_refs.py` | MOVED |
| 10 | `scripts/compliance/c22_f/check_json_pages.py` | `scripts/archived/check_json_pages.py` | MOVED (flattened) |
| 11 | `scripts/compliance/c22_f/check_json_structure.py` | `scripts/archived/check_json_structure.py` | MOVED (flattened) |
| 12 | `scripts/compliance/c22_f/read_pdf_pages.py` | `scripts/archived/read_pdf_pages.py` | MOVED (flattened) |
| 13 | `scripts/compliance/c22_f/read_pdf_pages_fixed.py` | `scripts/archived/read_pdf_pages_fixed.py` | MOVED (flattened) |
| 14 | `scripts/compliance/c22_f/read_pdf_pages_utf8.py` | `scripts/archived/read_pdf_pages_utf8.py` | MOVED (flattened) |
| 15 | `scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse.py` | `scripts/archived/reextract_gnc355_pdf_llamaparse.py` | MOVED (flattened) |
| 16 | `scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse_with_images.py` | `scripts/archived/reextract_gnc355_pdf_llamaparse_with_images.py` | MOVED (flattened) |

Subdirectory cleanup: `rmdir scripts/compliance/c22_f/` — **did not remove**; file `check_encoding.py` found in directory (not in the audit's 16-file scope; left in place). `rmdir scripts/pdf_reextraction/` — removed (was empty after move). `scripts/compliance/c22_e/` intact: `check_ufffd.ps1`, `check_ufffd.py` present.

Verification: `ls scripts/archived/ | wc -l` → 16 ✓. `ls scripts/compliance/c22_e/check_ufffd.py` → present ✓.

---

## Phase C: Fix Side Finding #4 — `scripts/build_page_number_map.py`

Three edits applied:

**Edit 1 (line 327):**
- Before: `        default="assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages",`
- After:  `        default="assets/gnx375_llama_extract/pages",`

**Edit 2 (line 332):**
- Before: `        default="assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json",`
- After:  `        default="assets/gnx375_pymupdf_v1_0_1/page_number_map.json",`

**Edit 3 (line 360):**
- Before: `            "extraction_dir": "assets/gnc355_pdf_extracted/llamaparse_agentic_v1",`
- After:  `            "extraction_dir": "assets/gnx375_llama_extract",`

Verification: `grep -c "gnc355_pdf_extracted" scripts/build_page_number_map.py` → `0` ✓

---

## Phase D: Remove `land-data-symbols.png` references and delete binaries

### D-Step 1: Fragment A (`docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`)

Prompt specified 2 edits; 3 applied (line 514 also contained stale "supplement available" language).

**Edit A-1 (line 463 — table row):**
- Before: `| **p. 125** | **Sparse** | **Land data symbols — image-only; text labels extracted but symbols absent. Supplement: \`assets/gnc355_reference/land-data-symbols.png\`. See §4.2 (C2.2-B).** |`
- After:  `| **p. 125** | **Sparse** | **Land data symbols — image-only; text labels extracted but symbols absent. See §4.2 (C2.2-B).** |`

**Edit A-2 (line 503 — Appendix C body):**
- Before: `**Significant content gap:** p. 125 land data symbols — supplement available (see C.1).`
- After:  `**Significant content gap:** p. 125 land data symbols (see C.1).`

**Edit A-3 (line 514 — Appendix C summary table, additional cleanup):**
- Before: `| Significant content gaps | 1 (land data symbols — supplement available) |`
- After:  `| Significant content gaps | 1 (land data symbols) |`

### D-Step 2: Fragment B (`docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`)

**Edit B-1 (line 247 — subsection heading):**
- Before: `#### Land data symbols [p. 125 — sparse; see supplement]`
- After:  `#### Land data symbols [p. 125 — sparse]`

**Edit B-2 (lines 250–252 — supplement attribution paragraph):**
- Before:
  ```
  Pilot's Guide p. 125 is sparse (image-only; text labels extracted but symbol graphics absent).
  The authoritative source for the enumerated land symbol list is the supplement at
  `assets/gnc355_reference/land-data-symbols.png`. Symbols include:
  ```
- After:
  ```
  Pilot's Guide p. 125 is sparse (image-only; text labels extracted but symbol graphics absent).
  Symbols include:
  ```

**Edit B-3 (line 263 — implementation directive):**
- Before: `Implementation must reference the supplement image for accurate symbol representation.` (plus surrounding blank line)
- After: (line deleted; blank line collapsed)

### D-Step 3: GNX375 outline (`docs/specs/GNX375_Functional_Spec_V1_outline.md`)

**Edit C-1 (line 248 — section heading):**
- Before: `- Land data symbols [p. 125 — sparse, see supplement]`
- After:  `- Land data symbols [p. 125 — sparse]`

**Edit C-2 (line 252 — NOTE bullet deleted):**
- Before: `  - NOTE: p. 125 sparse; refer to \`assets/gnc355_reference/land-data-symbols.png\``
- After: (line deleted)

**Edit C-3 (lines 1448–1449 — Supplement + Impact bullets deleted):**
- Before:
  ```
      - Supplement: `assets/gnc355_reference/land-data-symbols.png`
      - Impact: §4.2 land data symbols should reference supplement
  ```
- After: (both lines deleted)

### D-Step 4: GNC355 outline (`docs/specs/GNC355_Functional_Spec_V1_outline.md`)

Same pattern as D-Step 3.

**Edit D-1 (line 243 — section heading):**
- Before: `- Land data symbols [p. 125 — sparse, see supplement]`
- After:  `- Land data symbols [p. 125 — sparse]`

**Edit D-2 (line 247 — NOTE bullet deleted):**
- Before: `  - NOTE: p. 125 is sparse; refer to \`assets/gnc355_reference/land-data-symbols.png\``
- After: (line deleted)

**Edit D-3 (lines 1306–1307 — Supplement + Impact bullets deleted):**
- Before:
  ```
      - Supplement: `assets/gnc355_reference/land-data-symbols.png` provides the visual; `README.md` in same directory
      - Impact on spec: §4.2 (Map page) land data symbols section should reference supplement
  ```
- After: (both lines deleted)

### D-Step 5: Prep V2 (`docs/specs/GNX375_Prep_Implementation_Plan_V2.md`)

**Edit E-1 (line 159 — excise supplement clause):**
- Before: `Delivered: \`assets/gnc355_pdf_extracted/text_by_page.json\` (310 pages; 297 clean, 12 sparse-but-intentional, 1 empty), \`assets/gnc355_pdf_extracted/extraction_report.md\`, curated supplement \`assets/gnc355_reference/land-data-symbols.png\` (page 125 was image-only; hand-curated). Note:`
- After:  `Delivered: \`assets/gnc355_pdf_extracted/text_by_page.json\` (310 pages; 297 clean, 12 sparse-but-intentional, 1 empty), \`assets/gnc355_pdf_extracted/extraction_report.md\`. Note:`

Note: `gnc355_pdf_extracted` path references on this line are out of scope for this task (active-content patches excluded per prompt); only the land-data-symbols.png clause was excised.

### D-Step 6: Binary deletions

```
git rm assets/retired/gnc355_reference/land-data-symbols.png
git rm assets/retired/gnc355_pdf_extracted/land-data-symbols.png
```

Both confirmed removed.

### D-Step 7: Aggregate regeneration

Command used:
```
python scripts/assemble_gnx375_spec.py --manifest docs/specs/GNX375_Functional_Spec_V1.md
```

Output: 4430 lines written to `docs/specs/GNX375_Functional_Spec_V1_aggregate.md`. All gating verification checks PASS (section numbering, sub-section integrity, no duplicate H2 headings, no coupling summary, no fragment headers, no YAML front-matter, 0 unresolved cross-references).

### D-Step 8: Final verification

`grep -c "assets/gnc355_reference/land-data-symbols.png" docs/specs/GNX375_Functional_Spec_V1_aggregate.md` → `0` ✓

`git grep -n -F "assets/gnc355_reference/land-data-symbols.png" -- ':!docs/tasks/completed/' ':!docs/decisions/' ':!project-status/' ':!assets/retired/'` → no matches (exit code 1) ✓

---

## Phase E: Self-check

1. **Phase A:** `ls docs/tasks/completed/build_page_number_map_prompt.md` → present ✓
2. **Phase B:** `ls scripts/archived/ | wc -l` → 16 ✓; `scripts/compliance/c22_f/` not removed (contains `check_encoding.py`, not in audit scope; expected); `scripts/compliance/c22_e/check_ufffd.py` → present ✓
3. **Phase C:** `grep -c "gnc355_pdf_extracted" scripts/build_page_number_map.py` → `0` ✓
4. **Phase D:** both binary `ls` commands → "No such file or directory" ✓; global git grep → no active references ✓
5. **Reproducibility:** `git status --porcelain` shows 2 deletions (D), 7 modifications (M), 27 renames (R), 1 untracked (??) for the prompt file — no unexpected deletions or untracked files in scope

---

## Deviations

1. **Fragment A: 3 edits instead of 2** — Line 514 (`| Significant content gaps | 1 (land data symbols — supplement available) |`) also contained stale "supplement available" language. Cleaned as a logical extension of the two specified edits. Documented as additional cleanup rather than a deviation from intent.

2. **`scripts/compliance/c22_f/` not removed** — Directory contained `check_encoding.py`, which was not in the audit's 16-file scope. `rmdir` silently declined (not empty); directory left intact with one remaining file. Expected outcome per "attempt to remove now-empty subdirectories" language.

3. **No .json manifest file** — Prompt's check 8 expected `GNX375_Functional_Spec_V1_manifest.json` or similar. Actual manifest is `docs/specs/GNX375_Functional_Spec_V1.md` (confirmed from aggregate header). Assembly command adapted accordingly.
