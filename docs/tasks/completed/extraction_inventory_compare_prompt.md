# CC Task Prompt: EXTRACTION-INVENTORY-COMPARE-01 — Audit and compare PDF extraction directories

**Location:** `docs/tasks/extraction_inventory_compare_prompt.md`
**Created:** 2026-04-30T10:58:10-04:00
**Source:** CD Purple session — Turn 23 (2026-04-30); resolves the directory-naming convention drift discovered in Turn 18 when CC was inadvertently using the wrong canonical extraction path.
**Task ID:** EXTRACTION-INVENTORY-COMPARE-01
**Priority:** P1 — gates correct disposition of the just-produced `page_number_map.json` and unblocks the rename of project-wide source-of-truth references.
**Estimated scope:** Small-medium — read-only inventory + comparison + reference search across the repo. ~15–25 min CC wall-clock.
**Task type:** code (Python comparison script + JSON output + markdown summary)
**Audit level:** self-check — deterministic comparison; verification by cross-checking summary counts.

---

## Headline question this task must answer

**The retirement candidate is `assets/gnc355_pdf_extracted/` (whole directory).**
**The retirement target / new canonical path is `assets/gnx375_llama_extract/`.**

The retirement candidate contains a freshly-built `page_number_map.json` (just produced by the prior BUILD-PAGE-NUMBER-MAP task) at `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json`. That map was built by parsing the page footers in `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages/page_*.md`.

**The decision-determining question:**

> Are the 330 page files in `gnc355_pdf_extracted/llamaparse_agentic_v1/pages/` (retirement candidate) the **same content** as the 330 page files in `gnx375_llama_extract/pages/` (target)?

If YES → the just-produced `page_number_map.json` can be **relocated** to the target with a one-field metadata edit (`metadata.extraction_dir` updated). The map's content is correct because it derives from text content that's identical between the two directories.

If NO → the just-produced `page_number_map.json` must be **rebuilt** against the target's pages by re-running `scripts/build_page_number_map.py` with `--pages-dir` pointed at `gnx375_llama_extract/pages/`. The footer text on at least some pages diverges, which means parsed identifiers may diverge.

**Phase 1 of this task answers exactly that question.** The other comparison areas (B–H) and the reference search are secondary; do them only after Phase 1 produces a definitive YES or NO.

---

**Source of truth:**
- `assets/gnc355_pdf_extracted/` — older extraction directory; candidate for retirement
- `assets/gnx375_llama_extract/` — newer LlamaParse extraction; candidate for canonical going forward
- `docs/todos/issue_index.md` § ITM-11 — references the old path; will need update post-comparison
- `docs/specs/Spec_Tracker.md` — may reference paths
- `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` — may reference paths
- `docs/specs/fragments/GNX375_Functional_Spec_V1_part_*.md` — may reference paths in Coupling Summary blocks
- `scripts/build_page_number_map.py` (just produced; check default `--pages-dir` arg)
- `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json` (just produced; check `metadata.extraction_dir` field)

---

## Background

This task arises from a convention drift discovered mid-flight:

- In April 2026 the project pivoted from GNC 355 to GNX 375 as primary instrument (D-12).
- Before the pivot, an initial PDF extraction landed in `assets/gnc355_pdf_extracted/` using the GNC-355-era directory name.
- Inside that directory, multiple sub-extractions accumulated: a PyMuPDF-era extract (`images/`, `text_by_page.json`), the original LlamaParse run (`llamaparse_agentic_v1/`), and a partial cache-test attempt (`llamaparse_agentic_v1_with_images/`).
- Steve manually pulled `land-data-symbols.png` from p. 125 because the PyMuPDF run had missed it (image-only page).
- After the D-12 pivot, a new LlamaParse run targeting the GNX 375 specifically landed at `assets/gnx375_llama_extract/` with the proper project-aligned name. This run includes both `images_layout/` and `images_screenshot/` outputs, plus `structured_items.json` and `raw_json_result.json`.
- The new extraction was never integrated into the project's source-of-truth references; ITM-11 and other docs still point at the old path.
- The just-completed BUILD-PAGE-NUMBER-MAP task was specified against the old path because CD did not audit `assets/` before drafting the prompt.

This task confirms whether the older directory is fully superseded by the newer one, identifies all in-repo references to the old path, and produces a retirement-and-rename action plan.

**No source files are modified by this task.** The task is read-only inventory and comparison; the cleanup commit happens in a follow-on CD-direct turn.

---

## Pre-flight Verification

**Execute these checks before writing any code. If any check fails, STOP and write a deviation report.**

1. Verify both extraction directories exist:
   ```powershell
   Test-Path "assets\gnc355_pdf_extracted"
   Test-Path "assets\gnx375_llama_extract"
   ```
   Both should be `True`.

2. Verify both have a `pages/` subdirectory with content:
   ```powershell
   (Get-ChildItem "assets\gnc355_pdf_extracted\llamaparse_agentic_v1\pages\page_*.md").Count
   (Get-ChildItem "assets\gnx375_llama_extract\pages\page_*.md").Count
   ```
   Both should be `330`.

3. Verify no conflicting outputs exist:
   ```powershell
   Test-Path "scripts\compare_extractions.py"
   Test-Path "_audit\extraction_comparison_summary.md"
   Test-Path "_audit\extraction_comparison.json"
   ```
   All should be `False`.

4. Verify Python is callable:
   ```powershell
   python --version
   ```
   Expect Python 3.x.

If any check fails, write `docs/tasks/extraction_inventory_compare_prompt_deviation.md` and STOP.

---

## Phase 0: Source-of-Truth Audit

Before writing the script:

1. List the top-level contents of both directories:
   ```powershell
   Get-ChildItem -Force "assets\gnc355_pdf_extracted"
   Get-ChildItem -Force "assets\gnx375_llama_extract"
   ```

2. Read the `extraction_log.json` from each side (if present) and quote the LlamaParse parameters used (`parsing_mode`, `result_type`, `images_to_save`, etc.). Per CD context, the older run did NOT include image-output parameters; the newer run DID. This is the expected param difference.

3. Note the documented per-side contents from CD's audit (Turn 18, Turn 21):

   **`gnc355_pdf_extracted/` (old):**
   - `extraction_report.md` — PyMuPDF-era audit report
   - `text_by_page.json` — PyMuPDF-era full-text-by-page extraction
   - `images/` — PyMuPDF-extracted raw image bytes (~400 `.bin` files, page_0001 through page_0272)
   - `land-data-symbols.png` — manually pulled from p. 125 by Steve to fix a PyMuPDF gap
   - `llamaparse_agentic_v1/` — original LlamaParse run with text only (`extraction_log.json`, `extraction_report.md`, `full_markdown.md`, `pages/`, `page_number_map.json` newly added)
   - `llamaparse_agentic_v1_with_images/` — partial cache-test artifact (`CACHE_TEST_RESULT.md`, mostly empty `images/` and `pages/`, `extraction_log.json`, `full_markdown.md`, `raw_json_result.json`)

   **`gnx375_llama_extract/` (new):**
   - `extraction_log.json` — LlamaParse log
   - `full_markdown.md`
   - `images_layout/` — LlamaParse image-layout outputs
   - `images_screenshot/` — LlamaParse screenshot outputs
   - `pages/` — 330 page markdowns
   - `raw_json_result.json` — raw LlamaParse API response
   - `structured_items.json` — structured items JSON

4. Print "Phase 0: source-of-truth audit complete" and proceed.

---

## Instructions

Author `scripts/compare_extractions.py` and use it to produce:
- `_audit/extraction_comparison.json` — machine-readable comparison report
- `_audit/extraction_comparison_summary.md` — human-readable summary

Then perform a **reference search** across the repo to find all in-repo references to the old directory path, and append the reference list to the summary.

### Implementation requirements

#### Script structure

The script must be self-contained, depend only on the Python standard library, and be runnable from the project root via:

```powershell
python scripts\compare_extractions.py
```

Default behavior: walk both extraction directories, compare equivalent files, produce JSON + markdown reports. Support these flags:

- `--old-dir <path>` — old extraction root (default: `assets/gnc355_pdf_extracted`)
- `--new-dir <path>` — new extraction root (default: `assets/gnx375_llama_extract`)
- `--output-dir <path>` — report output directory (default: `_audit`)
- `--check` — run comparisons in memory; print summary; do NOT write reports
- `--verbose` — print per-file comparison results

Exit code: 0 on successful comparison run regardless of what was found (this is a read-only audit; "found differences" is data, not error). Non-zero only on unrecoverable errors (e.g., missing source directory).

#### Comparison logic

**The pages comparison (Phase 1) is the gating check.** It produces a single boolean recommendation at the top of the JSON output: `relocate_or_rebuild_map: "RELOCATE" | "REBUILD"`. Phase 2 (B–H) runs only after Phase 1 completes; Phase 2 findings are informational for the retirement disposition but do not affect the relocate-vs-rebuild decision.

**Phase 1: Pages directory comparison — GATING DECISION**

For each filename in `gnc355_pdf_extracted/llamaparse_agentic_v1/pages/` (retirement candidate, 330 pages expected):

- Check if a same-named file exists in `gnx375_llama_extract/pages/` (target, 330 pages expected).
- If both exist:
  - Compute SHA-256 of each side.
  - **Hash match → IDENTICAL.** No further investigation needed for this page.
  - **Hash mismatch → DIFFERENT.** Investigate further:
    - Capture byte length on each side, line count on each side.
    - Compute the first 3 differing line numbers (one-indexed) using stdlib `difflib`.
    - Capture the first differing line's content from each side (truncate to 200 chars; replace newlines with `\n` for single-line display).
    - **Footer-equivalence check (critical for the decision):** parse the *footer* of both versions of the page using the same regex set the BUILD-PAGE-NUMBER-MAP script uses (right-aligned, left-aligned, bold variant, roman-numeral, narration form; accept either curly or straight apostrophe). Record `footer_old`, `footer_new`, and `footer_match` (boolean: do they yield the same parsed Garmin logical page identifier?).
- If only old exists → OLD_ONLY (target is missing this page; this would be unexpected and is a hard FAIL signal for relocate-vs-rebuild).
- If only new exists → NEW_ONLY (retirement candidate is missing this page; less critical because the candidate is being retired anyway, but still record).

**Decision rule for `relocate_or_rebuild_map`:**

- IF (DIFFERENT count == 0) AND (OLD_ONLY count == 0) AND (NEW_ONLY count == 0) → **RELOCATE**. Every page is byte-identical between the two directories. The map can be moved with only a metadata edit.
- IF (DIFFERENT count > 0) AND (every DIFFERENT page has `footer_match == True`) → **RELOCATE**. Pages differ in body content but yield identical parsed footer identifiers, so the map's logical-to-physical mapping is unchanged. (This is the "identical conclusions from different inputs" case — e.g., LlamaParse re-runs may produce different whitespace, table layouts, or surrounding markdown but extract the same footer text.)
- IF (DIFFERENT count > 0) AND (any DIFFERENT page has `footer_match == False`) → **REBUILD**. At least one page's parsed footer identifier diverges between the two extractions, so the map's content would change if rebuilt against the target. The relocate path is unsafe; the map must be regenerated.
- IF (OLD_ONLY count > 0) → **REBUILD**. Some page exists in the retirement candidate but not the target; the map references a page the target doesn't have. (Investigate further: the page-numbering offset may have changed, which is exactly what the map encodes.)
- IF (NEW_ONLY count > 0) AND every other condition is RELOCATE-safe → **RELOCATE WITH NOTE**. The target has additional pages not in the candidate; the existing map covers a subset but is correct for what it covers. Flag for CD review.

Report per-page result in JSON. Print the decision and supporting counts at the top of stdout in Phase B.

**Phase 2: Other inventory comparisons (B–H) — INFORMATIONAL**

These run after Phase 1 and inform retirement disposition recommendations for items other than the pages directory. They do NOT affect the relocate-vs-rebuild decision.

**B. `full_markdown.md` comparison**

Both directories have a `full_markdown.md`. Hash both, capture byte lengths. If different, capture line-count delta and first 3 differing lines.

**C. `images/` (old, PyMuPDF) vs. `images_layout/` + `images_screenshot/` (new, LlamaParse)**

These are not directly comparable file-by-file because the extractors produce different output formats. Inventory only:
- For old `images/`: count `.bin` files; group by `page_NNNN_img_NN.bin` to get distinct pages covered (e.g., page 0001, 0018, 0019, 0021, 0023–0070, ...). Report total file count and pages covered.
- For new `images_layout/`: count files; report any naming pattern observed.
- For new `images_screenshot/`: count files; report any naming pattern observed.

Conclusion: report whether the new directory's image set is **plausibly a superset of the old's coverage** (same-or-greater page coverage; format differences acceptable).

**D. `text_by_page.json` (old) vs. `full_markdown.md` (new)**

These are different formats but cover the same source PDF content. Don't deep-compare — just confirm `text_by_page.json` is parseable JSON, report its structure (likely `{page_N: text}` mapping), and confirm `full_markdown.md` exists and is non-empty in the new directory. Conclusion: report whether old `text_by_page.json` is structurally redundant given new `full_markdown.md` exists.

**E. `extraction_report.md` (old) vs. nothing in new**

The new directory has no `extraction_report.md`. Inventory only: report old's file size and confirm no equivalent in new. Don't classify as superseded — it's a historical report; classification is a CD decision.

**F. `llamaparse_agentic_v1_with_images/` (old) — partial cache test**

Inventory: list contents; if mostly empty (likely just `CACHE_TEST_RESULT.md`, empty `images/`, empty `pages/`), classify as scratch artifact. Read `CACHE_TEST_RESULT.md` and quote it (likely small).

**G. `land-data-symbols.png` (old, manual pull)**

Per CD context (Turn 22), this was a manual pull because PyMuPDF missed image-only page 125. The new extraction's image dirs should now cover page 125. Verify:
- Find any file in `gnx375_llama_extract/images_layout/` or `images_screenshot/` whose filename contains `125` or `0125` or `p125` (page 125 indicators).
- Report file path(s) found and their byte sizes.
- Conclusion: report whether p. 125 image content is present in the new extraction.

**H. `extraction_log.json` comparison**

Both sides have one. Read both as JSON; print the parameters used (`parsing_mode`, `result_type`, `images_to_save`, model, page count, timestamp). The expected difference: new run includes `images_to_save` parameter; old run does not. Confirm this. If LlamaParse parsing_mode or result_type differs unexpectedly, flag as a potential source of text-content divergence.

#### Reference search across the repo

After the comparison, do a content search across the repo for all references to the soon-to-be-retired path. Use `grep -rni` (case-insensitive) with these patterns, scoped to safe directories:

```bash
grep -rniE "gnc355_pdf_extracted" \
  docs/ scripts/ src/ tests/ config/ \
  --include="*.md" --include="*.py" --include="*.json" --include="*.yml" --include="*.yaml" --include="*.txt" --include="*.toml" \
  2>/dev/null
```

Also search for the manually-pulled file path:

```bash
grep -rniE "gnc355_pdf_extracted/land-data-symbols\.png" \
  docs/ scripts/ src/ tests/ config/ \
  --include="*.md" --include="*.py" --include="*.json" --include="*.yml" --include="*.yaml" --include="*.txt" --include="*.toml" \
  2>/dev/null
```

Report the file:line:context for every match. Include the just-produced files (`scripts/build_page_number_map.py` and `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json`) since they were produced against the old path and need to be patched.

Group findings by file path for readability:

```
docs/todos/issue_index.md
  line 18: ...gnc355_pdf_extracted/llamaparse_agentic_v1/...
  line 245: ...

docs/specs/Spec_Tracker.md
  ...

scripts/build_page_number_map.py
  line 32 (default arg): assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages
  line 48 (default output arg): assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json
```

#### Output structure

`_audit/extraction_comparison.json`:

```json
{
  "metadata": {
    "old_dir": "assets/gnc355_pdf_extracted",
    "new_dir": "assets/gnx375_llama_extract",
    "generated": "<ISO 8601 timestamp>",
    "comparison_script_version": "1.0"
  },
  "gating_decision": {
    "relocate_or_rebuild_map": "RELOCATE" | "RELOCATE_WITH_NOTE" | "REBUILD",
    "rationale": "<one-sentence rationale tied to the rule that fired>",
    "supporting_counts": {
      "identical": <int>,
      "different": <int>,
      "different_with_matching_footer": <int>,
      "different_with_diverging_footer": <int>,
      "old_only": <int>,
      "new_only": <int>
    }
  },
  "pages_comparison": {
    "total_pages_compared": <int>,
    "identical_count": <int>,
    "different_count": <int>,
    "old_only_count": <int>,
    "new_only_count": <int>,
    "per_page": {
      "page_001.md": {
        "result": "IDENTICAL" | "DIFFERENT" | "OLD_ONLY" | "NEW_ONLY",
        "old_sha256": "...",
        "new_sha256": "...",
        "old_bytes": <int>,
        "new_bytes": <int>,
        "old_lines": <int>,
        "new_lines": <int>,
        "first_differing_lines": [<int>, <int>, <int>],
        "first_diff_excerpt_old": "...",
        "first_diff_excerpt_new": "...",
        "footer_old": "<parsed identifier from old, e.g. '2-42'>",
        "footer_new": "<parsed identifier from new>",
        "footer_match": <bool>
      }
    }
  },
  "full_markdown_comparison": { ... },
  "images_inventory": {
    "old_pymupdf_images_count": <int>,
    "old_pymupdf_pages_covered": [<list of page numbers>],
    "new_images_layout_count": <int>,
    "new_images_screenshot_count": <int>,
    "page_125_check": {
      "found_in_new": <bool>,
      "matching_files": [<list of paths>]
    }
  },
  "text_by_page_check": { ... },
  "extraction_log_comparison": { ... },
  "land_data_symbols_check": { ... },
  "cache_test_artifact": { ... },
  "extraction_report_old": { ... },
  "references_found": {
    "total_files_with_refs": <int>,
    "total_lines_with_refs": <int>,
    "by_file": {
      "<file_path>": [
        { "line": <int>, "content": "..." }
      ]
    }
  }
}
```

**Note on `footer_old` / `footer_new` / `footer_match`:** These three fields are present on every page record but are only populated for DIFFERENT pages. For IDENTICAL pages, footer_old == footer_new is implied by the byte-identity; set `footer_match: true` and copy the parsed identifier into both. For OLD_ONLY / NEW_ONLY pages, set the relevant field to the parsed identifier (or `null` if unparseable) and the other field to `null`; set `footer_match: false`.

`_audit/extraction_comparison_summary.md`:

The markdown summary opens with the **gating decision** as the very first heading-and-paragraph after the title. Format:

```markdown
# Extraction Comparison Summary

## Gating Decision: {RELOCATE | RELOCATE_WITH_NOTE | REBUILD}

**Verdict:** {one-sentence rationale}

**Supporting counts:** {identical: N, different: N, ..., footer_match: N/N}

**Implication for `page_number_map.json`:** {one paragraph explaining what CD should do per the verdict}

---

## Phase 1: Pages comparison detail
...

## Phase 2: Inventory comparisons (B-H)
...

## Reference search
...

## Per-item retirement disposition
...
```

The per-item disposition table (which previously was the headline) becomes a Phase-2-output section near the end:

| Path | Recommendation | Rationale |
|------|----------------|-----------|
| `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages/` | RETIRE (superseded by `gnx375_llama_extract/pages/`) | All 330 pages identical (or differences explained as benign) |
| `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/full_markdown.md` | RETIRE | Superseded |
| `assets/gnc355_pdf_extracted/images/` | RETIRE | PyMuPDF binaries; page coverage subset of new images_layout/screenshot |
| `assets/gnc355_pdf_extracted/text_by_page.json` | RETIRE | Superseded by full_markdown.md |
| `assets/gnc355_pdf_extracted/land-data-symbols.png` | RETIRE | Page 125 image present in new extraction (or NOT, in which case flag as needs-preservation) |
| `assets/gnc355_pdf_extracted/extraction_report.md` | DECIDE | Historical record; CD to decide retain or retire |
| `assets/gnc355_pdf_extracted/llamaparse_agentic_v1_with_images/` | RETIRE | Empty cache-test scaffolding |
| `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json` | RE-RUN-OR-PATCH | Just produced; needs to point at new path post-rename |

Recommendations should be the script's best assessment based on comparison results. CD reviews and may override per-item.

The summary must end with:

1. **Retirement plan** — proposed sequence: rename `assets/gnc355_pdf_extracted/` → `assets/retired/gnc355_pdf_extracted/`; patch the references identified; regenerate `page_number_map.json` against the new canonical path.
2. **Reference patch list** — copy of the reference search findings, formatted for CD action.

#### Read-only safety

The script must not write to either source directory. The only outputs are `_audit/extraction_comparison.json`, `_audit/extraction_comparison_summary.md`, and the script itself at `scripts/compare_extractions.py`.

If `_audit/` does not exist, create it (one-time directory creation is acceptable).

### Phase B: Run the script

After authoring:

1. Run with verbose output:
   ```powershell
   python scripts\compare_extractions.py --verbose
   ```
2. **The first thing the script must print to stdout is a clearly-marked gating decision block:**
   ```
   === GATING DECISION ===
   relocate_or_rebuild_map: <RELOCATE | RELOCATE_WITH_NOTE | REBUILD>
   rationale: <one sentence>
   supporting counts: identical=<N>, different=<N>, footer_match_count=<N/N>, old_only=<N>, new_only=<N>
   =======================
   ```
   This appears BEFORE any Phase 2 output. It must be visible at the very top of the captured stdout.
3. Capture full stdout to the completion report.

### Phase C: Manual spot-check verification

Independent of the script's automatic comparison, manually confirm:

1. Read 3 pages from each side at the same physical page number (suggestion: 80, 98, 125) and confirm the comparison classification (IDENTICAL or DIFFERENT) matches your visual inspection.
2. Read both `extraction_log.json` files manually and confirm the parameter difference reported by the script matches actual content.
3. Spot-check 5 of the reference findings to confirm grep didn't false-positive (e.g., the line content actually contains the string).

Report each in your completion report's Phase C table.

---

## Completion Protocol

1. Run final verification: `python scripts\compare_extractions.py --verbose`
2. Capture stdout.
3. Confirm `_audit/extraction_comparison.json` and `_audit/extraction_comparison_summary.md` both exist and are valid (JSON parses; markdown is well-formed).
4. Write completion report to `docs/tasks/extraction_inventory_compare_completion.md` with this structure:

   ```markdown
   ---
   Created: {ISO 8601 timestamp}
   Source: docs/tasks/extraction_inventory_compare_prompt.md
   ---

   # EXTRACTION-INVENTORY-COMPARE-01 Completion Report

   **Task ID:** EXTRACTION-INVENTORY-COMPARE-01
   **Outputs:**
   - `scripts/compare_extractions.py` ({N} lines)
   - `_audit/extraction_comparison.json` ({N} bytes)
   - `_audit/extraction_comparison_summary.md` ({N} lines)

   ## Headline Verdict (Phase 1)

   **Decision:** {RELOCATE | RELOCATE_WITH_NOTE | REBUILD}

   **One-sentence rationale:** {tied to the rule that fired}

   **Supporting counts:** identical: {N}, different: {N}, different_with_matching_footer: {N}, different_with_diverging_footer: {N}, old_only: {N}, new_only: {N}

   **Implication:** {one paragraph: what should happen with the just-produced `page_number_map.json`}

   ## Pre-flight Verification Results
   {table of the 4 pre-flight checks}

   ## Phase 0 Audit Results
   {top-level contents of both directories; LlamaParse parameter comparison}

   ## Pages Comparison Summary
   | Result | Count |
   |--------|-------|
   | IDENTICAL | {n} |
   | DIFFERENT | {n} |
   | OLD_ONLY | {n} |
   | NEW_ONLY | {n} |

   {if any DIFFERENT, summarize the nature of the differences in 2–3 sentences and reference the JSON detail}

   ## Other Comparisons (B–H)
   {one short subsection per comparison area, with the script's classification}

   ## Reference Search Results
   | File | Refs found |
   |------|-----------|
   | {path} | {count} |

   {Total: N references across M files}

   ## Disposition Recommendations
   {table of per-item recommendations from summary}

   ## Phase C Spot-Check Results
   {3 page comparisons + 5 reference spot-checks}

   ## Open Questions / CD Review Items
   {anything that warrants CD attention; "None" if none}

   ## Deviations from Prompt
   {table; "None" if none}
   ```

5. `git add -A`

6. `git commit` with D-04 trailer format. **CRITICAL: use the BOM-free `[System.IO.File]::WriteAllText` + `git -F` PowerShell pattern per `claude-conventions.md` §Git Commit Trailers §CD commit execution mechanics. Do NOT use `Out-File -Encoding utf8` (it emits UTF-8 with BOM, which leaks into the commit subject — see ITM-13).**

   Subject: `EXTRACTION-INVENTORY-COMPARE-01: audit and compare PDF extraction directories`

   Trailers:
   ```
   Task-Id: EXTRACTION-INVENTORY-COMPARE-01
   Authored-By-Instance: cc
   Refs: ITM-11, D-12, D-25
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

   After commit, verify the subject is BOM-free: `git log -1 --format="%s" | xxd | Select-Object -First 1`. If you see `ef bb bf` at byte offset 0, the BOM-free pattern was not used — fix immediately by `git commit --amend -F <bom-free-file>`. **The previous CC task had a BOM-in-subject defect (ITM-13); avoiding it on this task is the verification gate for closing ITM-13.**

7. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "EXTRACTION-INVENTORY-COMPARE-01 completed [flight-sim]"
   ```

8. **Do NOT git push.** Steve pushes manually.

---

## What CD will do with this report

1. Review the comparison report. **Start with the gating decision (RELOCATE / RELOCATE_WITH_NOTE / REBUILD).**
2. Confirm or override per-item disposition recommendations.
3. Execute (CD-direct turn): rename `assets/gnc355_pdf_extracted/` → `assets/retired/gnc355_pdf_extracted/`. Create `assets/retired/` if needed.
4. Patch every in-repo reference identified in the report — including the `--pages-dir` and `--output` defaults in `scripts/build_page_number_map.py`.
5. Disposition `page_number_map.json` per the gating decision:
   - **RELOCATE →** move `page_number_map.json` from `assets/retired/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json` to `assets/gnx375_llama_extract/page_number_map.json`. Edit the `metadata.extraction_dir` field from `assets/gnc355_pdf_extracted/llamaparse_agentic_v1` to `assets/gnx375_llama_extract`. No regeneration needed.
   - **RELOCATE_WITH_NOTE →** same as RELOCATE, but record the additional NEW_ONLY pages in a project note so any future user of the map knows the target has more pages than the map covers.
   - **REBUILD →** spawn a small CC patch task that re-runs `scripts/build_page_number_map.py --pages-dir assets/gnx375_llama_extract/pages --output assets/gnx375_llama_extract/page_number_map.json --verify`. The old map (now in `assets/retired/`) is preserved for audit but is not the canonical source going forward.
6. Open ITM-15 (or fold into a single decision-log entry) recording the convention: canonical extraction path is `assets/gnx375_llama_extract/`; project naming convention prefers project-aligned paths over historical names.
7. Close ITM-11 (page-number offset) once the page_number_map.json is in its correct final location.
8. Verify ITM-13 (BOM-in-commit-subject) status: if CC's commit on this task is BOM-free, that's one of two consecutive clean commits needed to close ITM-13.

## Estimated duration

CC wall-clock: ~15–25 min (per D-20 LLM calibration: ~150-line script; deterministic comparison logic; reference search adds ~3–5 min; well-defined output schema means no iteration).
