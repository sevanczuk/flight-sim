# CC Task Prompt: BUILD-PAGE-NUMBER-MAP — Author and run `scripts/build_page_number_map.py`

**Location:** `docs/tasks/build_page_number_map_prompt.md`
**Created:** 2026-04-30T10:19:42-04:00
**Source:** CD Purple session — Turn 16 (2026-04-30); resolves ITM-11 ahead of C3 spec review per D-22
**Task ID:** GNX375-PAGEMAP-01
**Resolves:** ITM-11 (page-number offset; physical-vs-Garmin-logical)
**Priority:** P1 — gates `spec-pdf-source-fidelity-reviewer` agent authoring per D-22 §2; required before C3 spec review.
**Estimated scope:** Small-medium — one Python script (~150–250 lines), one JSON output, one verification report. ~20–35 min CC wall-clock.
**Task type:** code (Python script + JSON output + summary report)
**Audit level:** self-check only — deterministic mapping over a static input corpus; verification by comparing produced map against known anchor citations.

**Source of truth:**
- `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages/page_NNN.md` — 330 physical pages (PRIMARY input)
- `docs/todos/issue_index.md` §ITM-11 — context for why this map is needed
- `docs/decisions/D-22-c3-review-customizations.md` — review customization framework that consumes this map (PRIMARY consumer of output)

---

## Pre-flight Verification

**Execute these checks before writing any code. If any check fails, STOP and write a deviation report.**

1. Verify the LlamaParse extraction directory exists and has 330 page files:
   ```powershell
   Test-Path "assets\gnc355_pdf_extracted\llamaparse_agentic_v1\pages"
   (Get-ChildItem "assets\gnc355_pdf_extracted\llamaparse_agentic_v1\pages\page_*.md").Count
   ```
   Expect `True` and `330`.

2. Verify ITM-11 still references this work as required:
   ```powershell
   Select-String -Path "docs\todos\issue_index.md" -Pattern "ITM-11"
   ```
   Confirm ITM-11 is in the open issues table.

3. Verify no conflicting outputs exist:
   ```powershell
   Test-Path "scripts\build_page_number_map.py"
   Test-Path "assets\gnc355_pdf_extracted\llamaparse_agentic_v1\page_number_map.json"
   ```
   Both should be `False`.

4. Verify Python is callable:
   ```powershell
   python --version
   ```
   Expect Python 3.x.

If any check fails, write `docs/tasks/build_page_number_map_prompt_deviation.md` and STOP.

---

## Phase 0: Source-of-Truth Audit

Before writing the script:

1. Read `docs/todos/issue_index.md` §ITM-11 in full. Quote the four observed offset rows in your audit notes:

   | Content | Garmin logical page | New extraction physical page | Offset |
   |---------|---------------------|------------------------------|--------|
   | XPDR Modes (§11.4 source) | p. 78 | `page_080.md` | +2 |
   | VFR Key + IDENT (§11.6 source) | p. 80 | `page_082.md` | +2 |
   | Unit Selections (§4.10 source) | p. 94 | `page_098.md` | +4 |
   | Land Data Symbols (§4.X source) | p. 125 | `page_129.md` | +4 |

   These four pairs are **anchor citations** — your final map must reproduce all four mappings exactly. They are the verification targets.

2. Read 6–10 sample page files to confirm the footer formats. The known formats (per CD's Turn 16 audit) are:

   | Format | Example |
   |--------|---------|
   | Right-aligned: `190-02488-01 Rev. C    Pilot's Guide    {section-page}` | `190-02488-01 Rev. C    Pilot's Guide    1-1` (p. 17) |
   | Left-aligned: `{section-page} Pilot's Guide 190-02488-01 Rev. C` | `2-42 Pilot's Guide 190-02488-01 Rev. C` (p. 80) |
   | Bold variant: `**{section-page}** Pilot's Guide 190-02488-01 Rev. C` | `**2-2** Pilot's Guide 190-02488-01 Rev. C` (p. 39) |
   | Front matter (Roman numerals): `190-02488-01 Rev. C    Pilot's Guide    {roman}` | `190-02488-01 Rev. C    Pilot's Guide    iii` (p. 5) |
   | Multi-space (variable whitespace): may use 1, 4, or more spaces between fields | varies |
   | Curly apostrophe variant: `Pilot's` (U+2019) vs. `Pilot's` (U+0027) | both observed |

   Verify each format is present in your sampled pages. If you find a footer format **not in the list above**, document it in your audit notes and proceed — your script must handle it.

3. Read at least 3 known-blank/sparse pages to understand edge cases:
   - **p. 1** (cover): no footer, only "Pilot's Guide" title block
   - **p. 2** (copyright): no footer with page identifier
   - **p. 310** (intentionally blank): footer present but in narration form (`The content of the page is as follows: ... Footer (left to right): - 6-22 - Pilot's Guide - 190-02488-01 Rev. C`)
   - **p. 330** (back cover): only `190-02488-01 Rev. C` — no page identifier
   - Various other intentionally-blank pages (p. 36, 110, 208, 222, 270, 292, 298, 308, 309)

   Pages without a parseable identifier must be marked `unparseable` in the map (not skipped) so the consumer knows they exist.

4. Print "Phase 0: source-of-truth audit complete; X distinct footer formats observed; Y edge-case pages identified" and proceed.

---

## Instructions

Author `scripts/build_page_number_map.py` and use it to produce `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json`. Then verify the map against the four anchor citations.

### Implementation requirements

#### Script structure

The script must be self-contained, depend only on the Python standard library, and be runnable from the project root via:

```powershell
python scripts\build_page_number_map.py
```

Default behavior: walk `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages/page_*.md`, parse each page's footer to extract the Garmin logical page identifier, build a bidirectional mapping, write JSON output. Support these flags:

- `--pages-dir <path>` — directory containing `page_NNN.md` files (default: `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages`)
- `--output <path>` — JSON output path (default: `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json`)
- `--check` — parse and verify in memory; print summary; do NOT write JSON output
- `--verify` — after producing the map, run anchor-citation verification (4 known pairs from ITM-11) and report PASS/FAIL count
- `--verbose` — print per-page parse results (which footer pattern matched, what identifier extracted)

Exit codes: 0 on success (anchor verification PASS); 1 on any anchor verification FAIL or unrecoverable parse error. Pages with no extractable identifier are NOT a fatal error — they are recorded as `unparseable` in the map.

#### Footer parsing

Implement a `parse_footer(page_text: str) -> str | None` function that returns the Garmin logical page identifier (e.g., `"2-42"`, `"iii"`, `"6-22"`) or `None` if no identifier is parseable.

The function must handle, in order of preference:

1. **Right-aligned full footer:** regex matching `190-02488-01\s+Rev\.\s+C\s+Pilot[\u2019']s\s+Guide\s+([A-Za-z0-9\-]+)` at end of file (last 5 non-empty lines is sufficient scope). Capture group 1 = identifier.

2. **Left-aligned full footer:** regex matching `(?:\*\*)?([A-Za-z0-9\-]+)(?:\*\*)?\s+Pilot[\u2019']s\s+Guide\s+190-02488-01\s+Rev\.\s+C`. Capture group 1 = identifier; strip surrounding `**` markdown bold if present.

3. **Narration-form footer (sparse pages):** regex matching `Footer.*?-\s+([A-Za-z0-9\-]+)\s+-\s+Pilot[\u2019']s\s+Guide` or similar. Capture group 1 = identifier. This handles the `p. 310` case where the page was extracted as a description rather than rendered.

4. **Curly vs. straight apostrophe handling:** all three patterns above must accept either U+2019 (`'`) or U+0027 (`'`) in `Pilot's`. Use `[\u2019']` in the regex.

5. **Whitespace tolerance:** between footer fields, accept 1+ spaces (use `\s+`, not literal `' '`). Tabs may also occur in some cases.

6. **No match:** return `None`. The page will be recorded as `unparseable`.

Spec the regex patterns as module-level constants at the top of the script (e.g., `_FOOTER_RIGHT_RE`, `_FOOTER_LEFT_RE`, `_FOOTER_NARRATION_RE`). Test each against the documented anchor cases (page 80 = "2-42", page 98 = "2-58", page 125 = "3-11", page 129 = "3-15" or whatever the actual identifier is).

#### Mapping data structure

The output JSON has the following shape:

```json
{
  "metadata": {
    "source_pdf": "190-02488-01_Pilots_Guide_Rev_C.pdf",
    "extraction_dir": "assets/gnc355_pdf_extracted/llamaparse_agentic_v1",
    "physical_page_count": 330,
    "parsed_count": <int>,
    "unparseable_count": <int>,
    "generated": "<ISO 8601 timestamp>"
  },
  "physical_to_logical": {
    "1": "unparseable",
    "2": "unparseable",
    "...": "...",
    "17": "1-1",
    "...": "...",
    "80": "2-42",
    "98": "2-58",
    "125": "3-11",
    "...": "..."
  },
  "logical_to_physical": {
    "1-1": 17,
    "...": "...",
    "2-42": 80,
    "2-58": 98,
    "3-11": 125,
    "...": "..."
  },
  "unparseable_pages": [1, 2, 310, 330, ...]
}
```

Notes on the data structure:
- `physical_to_logical`: keys are stringified physical page numbers (`"1"`, `"2"`, ..., `"330"`); values are logical identifiers or the literal string `"unparseable"`.
- `logical_to_physical`: keys are logical identifiers (e.g., `"2-42"`, `"iii"`); values are physical page integers. Built only from successfully parsed entries.
- Logical-side duplicates: if two physical pages claim the same logical identifier, log a WARNING to stdout but record the FIRST occurrence in `logical_to_physical`. Subsequent duplicates are listed in a separate top-level key `logical_duplicates: [{"logical": "X-Y", "physical_pages": [P1, P2]}]` so the consumer can audit.
- `unparseable_pages`: convenience list of physical page numbers with `"unparseable"` value, for consumers who want to iterate just those.
- All pages must appear in `physical_to_logical` (no gaps from 1 to 330).

#### Output writing

Write JSON with `json.dumps(map_data, indent=2, ensure_ascii=False)`. Use UTF-8 without BOM (Python's default text mode does this correctly; do NOT use `'utf-8-sig'`). Include trailing newline.

Path: `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json`.

#### Verification

After producing the map (or in `--check` mode), run these checks:

**V1.** Page count: `physical_page_count == 330`. Print PASS/FAIL.

**V2.** Coverage: `parsed_count + unparseable_count == 330`. Print PASS/FAIL.

**V3.** Anchor citations from ITM-11: print PASS/FAIL for each of the four known pairs, then a summary count.

| Anchor | Logical | Physical |
|--------|---------|----------|
| XPDR Modes | `2-42` | 80 |
| VFR Key + IDENT | `2-44` (likely; verify against parsed result) | 82 |
| Unit Selections | `2-58` | 98 |
| Land Data Symbols | `3-15` (likely; verify against parsed result) | 129 |

For VFR Key + IDENT and Land Data Symbols, the ITM-11 entry only states the *physical* page; the logical identifier was not given. Your script should report what it parses for those physical pages, and the verification should consider PASS if the offset is consistent with the +2 (Section 2) and +4 (Section 3) patterns.

**V4.** Sanity check on roman-numeral parsing: pages 3–16 (front matter) should parse to roman numerals (`i`, `ii`, `iii`, ..., `xiv`). Print the parsed identifiers for pages 3–16 and verify they form a contiguous lowercase roman sequence. PASS/FAIL.

**V5.** Sanity check on section transitions: at section boundaries, physical page N+1 should have logical `<S>-1` while physical page N has logical `<S-1>-<last>`. Print all detected section transitions (e.g., `physical 17→18: logical 1-1→1-2`, `physical 38→39: logical 1-22→2-1`) and verify each transition is either a same-section increment or a clean section boundary (logical `<X>-1` after some `<X-1>-<n>`). PASS with notes for any anomaly. NOTE: Garmin's section pagination resets at boundaries; this is normal and expected.

**V6.** Logical-side duplicate count: print count and list any duplicates. Expected: 0 duplicates. PASS/FAIL.

**V7.** Unparseable list: print full list of unparseable physical pages with a brief note from the page content (first 80 chars) explaining why. Expected: ~10–15 pages (cover, copyright, intentionally-blank inserts, back cover). FAIL only if count is unreasonable (>30 pages unparseable suggests parser is broken).

If V1, V2, V3, V6 all PASS, the script exits 0. V4 and V5 are advisory (warnings only); V7 is informational.

### Phase B: Run the script

After authoring:

1. Run with verbose output:
   ```powershell
   python scripts\build_page_number_map.py --verbose --verify
   ```
2. Capture stdout to the completion report.
3. Run `--check` mode to verify deterministic behavior:
   ```powershell
   python scripts\build_page_number_map.py --check --verify
   ```
   Confirm parsed_count and anchor verification results match the production run.

### Phase C: Spot-check verification

Independent of the script's self-verification, manually confirm the following sample mappings by reading the page files directly (use the `view` tool or PowerShell `Get-Content`):

1. `page_017.md` → footer should yield `1-1` (start of Section 1)
2. `page_038.md` → footer should yield `1-22` (end of Section 1)
3. `page_039.md` → footer should yield `2-1` (start of Section 2; bold variant)
4. `page_080.md` → footer should yield `2-42` (matches ITM-11)
5. `page_098.md` → footer should yield `2-58` (matches ITM-11)
6. `page_125.md` → footer should yield `3-11` (matches ITM-11)
7. `page_129.md` → footer should yield `3-15` or similar (matches ITM-11 +4 offset; verify actual value)
8. `page_310.md` → narration-form footer should yield `6-22`
9. `page_005.md` → roman-numeral footer should yield `iii`
10. `page_001.md` → unparseable (cover)

Report each in your completion report's Phase C table with the actually-parsed value.

---

## Completion Protocol

1. Run final verification: `python scripts\build_page_number_map.py --verbose --verify`
2. Capture stdout.
3. Confirm `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json` exists and is valid JSON: `python -c "import json; json.load(open('assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json'))"`. Note: this `python -c` is acceptable here because it's a one-line read-only validation, not an authoring action — but if you prefer, write a `validate_map.py` and run that instead.
4. Write completion report to `docs/tasks/build_page_number_map_completion.md` with this structure:

   ```markdown
   ---
   Created: {ISO 8601 timestamp}
   Source: docs/tasks/build_page_number_map_prompt.md
   ---

   # BUILD-PAGE-NUMBER-MAP Completion Report

   **Task ID:** GNX375-PAGEMAP-01
   **Outputs:**
   - `scripts/build_page_number_map.py` ({N} lines)
   - `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json` ({N} bytes; {parsed_count} of 330 pages parsed)

   ## Pre-flight Verification Results
   {table of the 4 pre-flight checks}

   ## Phase 0 Audit Results
   {ITM-11 anchor citations summary; sampled footer formats observed; edge-case pages identified}

   ## Footer Format Coverage
   | Format | Pages matched | Sample identifier |
   |--------|---------------|-------------------|
   | Right-aligned | {n} | {e.g., "1-1"} |
   | Left-aligned | {n} | {e.g., "2-42"} |
   | Bold variant | {n} | {e.g., "2-2"} |
   | Roman numeral | {n} | {e.g., "iii"} |
   | Narration form | {n} | {e.g., "6-22"} |
   | Unparseable | {n} | — |

   ## Verification Results
   {table of V1–V7 with PASS/FAIL/INFO and details}

   ## Phase C Spot-Check Results
   {table of 10 spot-check pages with expected vs. actual identifier}

   ## Map Statistics
   | Metric | Value |
   |--------|-------|
   | Total physical pages | 330 |
   | Successfully parsed | {N} |
   | Unparseable | {N} |
   | Logical-side duplicates | {N} |
   | Section transitions detected | {N} |
   | Roman numeral pages | {N} |

   ## Logical Identifier Range
   - Roman: {first} → {last}
   - Section 1: {first} → {last} (e.g., "1-1" → "1-22")
   - Section 2: {first} → {last}
   - ... (one row per detected section)

   ## Unparseable Pages Detail
   {table of all unparseable pages with a brief reason}

   ## Open Questions / CD Review Items
   {any anomalies found that warrant CD attention; "None" if none}

   ## Deviations from Prompt
   {table; "None" if none}
   ```

5. `git add -A`

6. `git commit` with D-04 trailer format. **CRITICAL: use the BOM-free `[System.IO.File]::WriteAllText` + `git -F` PowerShell pattern per `claude-conventions.md` §Git Commit Trailers §CD commit execution mechanics. Do NOT use `Out-File -Encoding utf8` (it emits UTF-8 with BOM, which leaks into the commit subject — see ITM-13).**

   Subject: `GNX375-PAGEMAP-01: build physical-to-logical page number map for LlamaParse extraction`

   Trailers:
   ```
   Task-Id: GNX375-PAGEMAP-01
   Authored-By-Instance: cc
   Refs: ITM-11, D-22
   Fixes: ITM-11
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

   After commit, verify the subject is BOM-free: `git log -1 --format="%s" | xxd | Select-Object -First 1`. If you see `ef bb bf` at byte offset 0, the BOM-free pattern was not used — fix immediately by `git commit --amend -F <bom-free-file>`.

7. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-PAGEMAP-01 completed [flight-sim]"
   ```

8. **Do NOT git push.** Steve pushes manually.

---

## What CD will do with this report

1. Review the completion report and spot-check the page_number_map.json against a few non-anchor pages.
2. Confirm the BOM-free commit pattern was used (carries forward ITM-13 verification).
3. Resolve ITM-11 in `docs/todos/issue_index.md` (move to `issue_index_resolved.md`).
4. Move forward with the three domain-specific Sonnet reviewer agents per D-22 §2 — `spec-pdf-source-fidelity-reviewer.md` is now unblocked because it can consume `page_number_map.json` to validate `[p. N]` citations in the V1 aggregate against the new physical-page-numbered LlamaParse extraction.

## Estimated duration

CC wall-clock: ~20–35 min (per D-20 LLM calibration: ~200-line code task; deterministic input corpus; verification logic adds ~5 min; first-of-pattern multiplier doesn't apply — footer parsing is straightforward regex).
