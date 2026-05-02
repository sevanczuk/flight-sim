---
Created: 2026-05-02T15:30:00-04:00
Source: docs/tasks/dependency_audit_01_compliance_prompt.md
---

# DEPENDENCY-AUDIT-01 Compliance Report

**Verified:** 2026-05-02T15:30:00-04:00
**Verdict:** FAILURES FOUND

## Summary

- Total checks: 11 (M1, M2, N1, N2, O1, S1, S2, E1, E2, G1, G2)
- Passed: 6 (N1, S1, S2, E2, G1, G2)
- Failed: 3 (M1, N2, O1)
- Partial: 2 (M2, E1)

---

## Results

### M. Math verification

**M1. FAIL** — Computed unique file:line total: **539** (raw); **429** after excluding the three audit output files (`dependency_audit_01_report.md`, `dependency_audit_01_completion.md`, `dependency_audit_01_compliance_prompt.md`). Report claims ~304. Even the filtered 429 exceeds ±5% tolerance (429/304 = 41% above claim). The three excluded files account for 110 of the 235 excess matches (539−429); all three are now committed to HEAD and contain extensive references to retired paths. The remaining ~125-match gap between 429 and 304 likely reflects: (a) working-tree modifications to `assets/retired/README.md` and `docs/commands/check_updates.md` (both modified post-audit), and (b) files created since the audit that were not yet tracked at audit time. A definitively comparable count would require running git grep against the `2cc421d` commit tree directly (`git grep --cached ... 2cc421d`) rather than the current working tree.

Per-pattern counts (raw):

```
'assets/retired/gnc355_pdf_extracted': 45
'assets/retired/gnc355_reference': 23
'assets/gnc355_pdf_extracted': 249
'assets/gnc355_reference': 54
'gnc355_pdf_extracted': 332
'gnc355_reference': 94
'llamaparse_agentic_v1': 117
'text_by_page.json': 154
'land-data-symbols.png': 81
'gnc355_pdf_extract': 385
```

Distinct files (raw): 101 vs ~95 claimed (within ±5% on file count, but line count fails).

---

**M2. PARTIAL** — Arithmetic check: 28 + 109 + 167 = 304 ✓

Summand cross-checks:

- **Patch list (28 lines):** Table rows account for exactly 28 lines (counting each cited line number individually, including ranges): GNX375_Functional_Spec:9(1), GNC355_Functional_Spec:9(1), GNX375_Prep_V2:159(1), GNC355_Prep_V1:283+295(2), 355_to_375:462+470(2), gnx375_ifr:5(1), gnx375_xpdr:5(1), Task_flow_plan:77+78(2), image_extraction_briefing:16,44–47,66–68,136,165–166(11), issue_index:273(1), page_number_map.json:4(1), build_page_number_map.py:327+332+360(3), .gitignore:47(1) = 28 lines ✓. However, the table has **13 distinct files**, not the claimed 17. The 4-file discrepancy appears to result from the exec summary counting file appearances across subsections without deduplication (GNC355_Prep_V1 appears in two subsections; Task_flow_plan and image_extraction_briefing likewise). PARTIAL on file count.

- **Flag list (109 lines):** Table has 33 distinct rows (33 files). Exec summary claims 29 files — also a 4-file discrepancy. Line count: counting all cited lines including range expansions and the approximate entries (~20 for extraction_inventory_compare_prompt.md, ~10 for dependency_audit_prompt.md) yields approximately 112 lines, within the approximation margin of 109. Line count PASS; file count PARTIAL.

- **Leave-as-is (167 lines):** Phase B classification summary states D ≈ 130 lines, F ≈ 25 lines, G ≈ 12 lines → total ≈ 167 ✓. Consistent.

---

### N. Negative / Source integrity

**N1. PASS** — Audit commit `2cc421d` contains exactly two files:

```
docs/tasks/dependency_audit_01_completion.md  |  77 +++
docs/tasks/dependency_audit_01_report.md      | 250 +++
2 files changed, 327 insertions(+)
```

No source files were modified. Current working tree (`git status --porcelain`) shows three post-audit CD-authored changes:

```
 M assets/retired/README.md
 M docs/commands/check_updates.md
?? docs/decisions/D-31-drop-backup-step-from-check-updates.md
```

All three are CD updates made after the audit was committed (Side Finding #1 remediation on README; D-31 decision; check_updates.md update). `docs/tasks/CC_Task_Prompts_Status.md` does not appear as modified in the current working tree (Side Finding #2 pre-existing change has since been committed).

---

**N2. FAIL** — Three of five claims verified; two fail:

```
assets/retired/gnc355_reference/land-data-symbols.png    — FOUND, 65861 bytes  ✓
assets/retired/gnc355_pdf_extracted/land-data-symbols.png — FOUND, 65861 bytes  ✓
assets/gnx375_llama_extract/images_screenshot/page_125.jpg — FOUND, 160803 bytes  ✓
assets/gnx375_llama_extract/images_screenshot/page_125_chart_1_v2.jpg — NOT FOUND  ✗
assets/gnx375_llama_extract/images_layout/ has no page_125* — FALSE  ✗
```

Claim 4 fails: `page_125_chart_1_v2.jpg` does NOT exist in `images_screenshot/`. Claim 5 fails: `images_layout/` DOES contain `page_125_chart_1_v2.jpg`:

```
$ ls "assets/gnx375_llama_extract/images_layout/"page_125*
assets/gnx375_llama_extract/images_layout/page_125_chart_1_v2.jpg
```

The report has the subdirectory wrong for this file. It is in `images_layout/`, not `images_screenshot/`. The salvage assessment cited it as an "images_screenshot" candidate, which is incorrect — it is the chart-extract image in the layout directory, not a screenshot.

---

### O. Sort ordering

**O1. FAIL** — 0/3 tables verified as ascending by (path, line).

**Table 1** (`### Subpath: text_by_page.json`): `docs/specs/GNX375*` (row 1) precedes `docs/specs/GNC355*` (row 2) — 'X' > 'C', wrong order. `docs/specs/` (rows 1–5) precedes `docs/knowledge/` (rows 6–9) — alphabetically knowledge < specs, wrong order. NOT sorted.

**Table 2** (`#### Subpath: text_by_page.json (scripts — functional dependencies)`): `scripts/compliance_s12_overlays.py` (row 6) precedes `scripts/compliance/c22_f/check_json_pages.py` (row 9) — '/' (0x2F) < '_' (0x5F) in ASCII, so `compliance/` should precede `compliance_`. Wrong order. `scripts/verify_fragment_a_page_refs.py` (row 14) precedes `scripts/gnc355_pdf_extract.py` (row 15) — 'g' < 'v', gnc355 should precede verify. Wrong order. NOT sorted.

**Table 3** (Patch list in Recommended Actions Summary): `docs/specs/GNX375*` precedes `docs/specs/GNC355*` (same issue as Table 1). `docs/todos/issue_index.md` (row 10) precedes `assets/gnx375_llama_extract/page_number_map.json` (row 11) — 'a' < 'd', so assets/ should precede docs/. Wrong order. NOT sorted.

---

### S. Sample classification verification

**S1. PASS** — All 5 sampled entries verified across 3 different retired paths:

1. `docs/specs/GNX375_Functional_Spec_V1_outline.md:9` (Category A, text_by_page.json path)
   — Line content: `**Source content:** \`assets/gnc355_pdf_extracted/text_by_page.json\`` ✓ Active spec → A ✓

2. `docs/knowledge/355_to_375_outline_harvest_map.md:462` (Category A, text_by_page.json path)
   — Line content: `- Pilot's Guide coverage: all pp. 1–310 of \`assets/gnc355_pdf_extracted/text_by_page.json\`` ✓ Active knowledge doc → A ✓

3. `docs/tasks/Task_flow_plan_with_current_status.md:77` (Category B, llamaparse_agentic_v1 path)
   — Line content: `Output to \`assets/gnc355_pdf_extracted/llamaparse_agentic_v1/\`` (in active task table) ✓ Active task → B ✓

4. `docs/tasks/image_extraction_briefing.md:16` (Category B, images/ path)
   — Line content: `...extracted 521 embedded images into \`assets/gnc355_pdf_extracted/images/\`` ✓ QUEUED task → B ✓

5. `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md:463` (Category A, land-data-symbols path)
   — Line content: `| **p. 125** | **Sparse** | **Land data symbols...Supplement: \`assets/gnc355_reference/land-data-symbols.png\`.** |` ✓ Canonical spec part → A ✓

---

**S2. PASS** — All 3 D-category items verified in immutable directories:

1. `docs/tasks/completed/c22_a_prompt.md` — EXISTS in `docs/tasks/completed/` (28618 bytes, 2026-04-21) ✓
2. `docs/tasks/completed/c22_b_prompt.md` — EXISTS in `docs/tasks/completed/` (51186 bytes, 2026-04-22) ✓
3. `project-status/flight-sim-2026-04-20-1010-purple.md` — EXISTS in `project-status/` (9086 bytes, 2026-04-20) ✓

---

### E. High-stakes E-category items

**E1. PARTIAL** — 9/10 sample lines contain the cited retired-path reference; 1 is off by one line.

Patch list (all 5 unique files covered):

| File | Cited line | Actual line content |
|---|---|---|
| `assets/gnx375_llama_extract/page_number_map.json` | 4 | `"extraction_dir": "assets/gnc355_pdf_extracted/llamaparse_agentic_v1"` ✓ |
| `scripts/build_page_number_map.py` | 327 | `default="assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages"` ✓ |
| `scripts/build_page_number_map.py` | 332 | `default="assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json"` ✓ |
| `scripts/build_page_number_map.py` | 360 | `"extraction_dir": "assets/gnc355_pdf_extracted/llamaparse_agentic_v1"` ✓ |
| `.gitignore` | 47 | `# GNC 355 PDF extraction output — regenerable from source PDF + scripts/gnc355_pdf_extract.py (D-06)` — **this is the comment line**; the actual rule `assets/gnc355_pdf_extracted/` is on line 48. Off by one (line 48 verified). PARTIAL ±1. |

Flag list (5 samples):

| File | Cited line | Actual line content |
|---|---|---|
| `scripts/c22_c_pdf_integrity_check.py` | 3 | `with open("assets/gnc355_pdf_extracted/text_by_page.json", "r", encoding="utf-8") as f:` ✓ |
| `scripts/gnc355_pdf_extract.py` | 373 | `# --- Write text_by_page.json ---` ✓ (`text_by_page.json` pattern present) |
| `scripts/gnc355_pdf_extract.py` | 384 | `json_path = output_dir / "text_by_page.json"` ✓ |
| `scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse.py` | 8 | `Output: assets/gnc355_pdf_extracted/llamaparse_agentic_v1/` ✓ |
| `scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse_with_images.py` | 7 | `Turn 18's successful extraction (output at llamaparse_agentic_v1/)` ✓ (`llamaparse_agentic_v1` pattern present) |

---

**E2. PASS** — Stale defaults confirmed at exact cited lines:

```
$ grep -n "default=" scripts/build_page_number_map.py | head -10
327:        default="assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages",
332:        default="assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json",
```

Side Finding #4 verified: both `--pages-dir` and `--output` defaults point to the retired 330-page extraction path. Running the script without flags would use defective source and write stale metadata. Risk is real.

---

### G. Git / Commit compliance

**G1. PASS** — Commit `2cc421d` message:

```
DEPENDENCY-AUDIT-01: inventory references to retired asset paths [AI commit]

Read-only audit producing docs/tasks/dependency_audit_01_report.md. ~304 total
references across ~95 files; 28 patch-recommended, 109 flag-for-decision, 167
leave-as-is. Salvage assessment for land-data-symbols.png: defer (visual
inspection needed); interim: salvage-in-place to assets/gnx375_reference/
recommended.

Refs: D-12, D-30
```

- Subject begins with `DEPENDENCY-AUDIT-01:` ✓
- Subject ends with ` [AI commit]` ✓
- No `Task-Id:` trailer ✓ (D-29 compliant)
- Body paragraph present and describes the work ✓
- `Refs:` line as final paragraph ✓
- No `Authored-By-Instance:`, `Co-Authored-By:`, or other D-04-style trailers ✓

---

**G2. PASS** — No BOM in commit subject:

```
$ git show --format="%s" 2cc421d | head -c 50 | od -c | head -2
0000000   D   E   P   E   N   D   E   N   C   Y   -   A   U   D   I   T
0000020   -   0   1   :       i   n   v   e   n   t   o   r   y       r
```

First byte is 'D' (0x44). No BOM (0xEF 0xBB 0xBF). Clean.

---

## Notes

**M1 count drift:** The 77% inflation in the raw recount (539 vs ~304) is primarily explained by the audit's own output files now being committed and containing extensive references to retired paths. The filtered recount (429) still exceeds ±5%; the remaining gap likely reflects working-tree modifications (`assets/retired/README.md`, `docs/commands/check_updates.md`) that git grep picks up from the working tree. A fully accurate repro of the original count would require `git grep` run against the `2cc421d` commit tree. The M1 check criterion is therefore somewhat self-defeating when applied post-commit — the audit output is itself a dense source of pattern matches.

**N2 image path error:** The `page_125_chart_1_v2.jpg` file is in `images_layout/`, not `images_screenshot/`. This is a factual error in the salvage assessment — the file is the chart-cropped image from the layout pipeline, not a screenshot. The deferred recommendation to visually compare it against the curated PNG is still valid, but the path cited in the report is wrong. The curated manual PNG (`assets/retired/gnc355_reference/land-data-symbols.png`) remains the only confirmed path for the symbols legend.

**O1 sort order:** The three tables checked are organized by file type/category grouping rather than strict lexicographic order. This is a documentation convention choice rather than a structural error, but it does not satisfy the compliance prompt's "ascending path-then-line" criterion.

**M2 file-count discrepancy:** Both the patch list (13 files in table vs 17 claimed) and flag list (~33 files vs 29 claimed) show a 4-file gap. The most likely explanation is that the exec summary file counts were computed by tallying section appearances (with files double-counted across subsections) rather than deduplicated unique-file counts. The line counts are consistent.

**E1 .gitignore off-by-one:** The `assets/gnc355_pdf_extracted/` ignore rule is on line 48; the comment explaining it is on line 47. The report cited line 47 (the comment), which matches the `gnc355_pdf_extract` bare-name pattern but not the full `assets/gnc355_pdf_extracted/` path. The rule itself is on line 48, within the ±2 allowance.
