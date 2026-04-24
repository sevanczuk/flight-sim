---
Created: 2026-04-24T10:35:00-04:00
Source: docs/tasks/pdf_reextraction_llamaparse_prompt.md
---

# PDF Re-extraction via LlamaParse — Completion Report

**Task ID:** PDF-REEXTRACT-LLAMAPARSE-V1
**Completed:** 2026-04-24T10:31:37-04:00

## Pre-flight Results

| Check | Detail | Result |
|-------|--------|--------|
| 1. Source PDF exists | `assets/Garmin GNC 375 - GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf` — 25,487,834 bytes (~25.5 MB) | PASS |
| 2. Credential file present | `Test-Path C:\PhotoData\config\api_keys.json` → True; file length = 391 bytes (contents NOT read, NOT logged) | PASS |
| 3. llama-parse installed | Installed 0.6.94 via `pip install --upgrade llama-parse` (was not present; installed with dependencies) | PASS |
| 4. Output directory absent | `Test-Path assets/gnc355_pdf_extracted/llamaparse_agentic_v1` → False | PASS |

## Extraction Run

| Metric | Value |
|--------|-------|
| llama-parse SDK version | 0.6.94 |
| Parse mode | parse_page_with_agent |
| Result type | markdown |
| Credential source | C:/PhotoData/config/api_keys.json[llamaparse] (value not logged) |
| Pages extracted | 330 |
| Elapsed wall-clock | 148.7s (2.5 min) |
| Output directory | `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/` |

Note: LlamaParse reported two deprecation warnings that do not affect extraction:
- `llama-parse` package deprecated (maintained through May 1, 2026; extraction completes well before then)
- `parsing_instruction` parameter deprecated in favor of `system_prompt`/`user_prompt`; behavior unchanged

## Output Verification

- Per-page files: 330 / expected 330 ✓
- Aggregate `full_markdown.md` size: 451,572 bytes ✓
- `extraction_log.json` present: yes ✓
- `extraction_report.md` present: yes ✓

## Spot Check — Unit Selections (ITM-10 context)

The original extraction referenced "p. 94" for Unit Selections. The new LlamaParse extraction indexes from the PDF's physical page 1 (cover), so the Unit Selections content lands on **`page_098.md`** (footer reads "2-58 Pilot's Guide 190-02488-01 Rev. C").

Content from `pages/page_098.md`:

```markdown
# Unit Selections

Customize the display of unit settings. Tapping a parameter key opens a menu of the available unit types.

| PARAMETER           | SETTINGS                                                                    |
| ------------------- | --------------------------------------------------------------------------- |
| Distance/Speed      | • Nautical Miles (nm/kt)  • Statute Miles (sm/mph)                          |
| Fuel                | • Gallons (gal)  • Imperial Gallons (Ig)  • Kilograms (kg)  • Liters (lt)  • Pounds (lb) |
| Temperature         | • Celsius (°C)  • Fahrenheit (°F)                                           |
| NAV Angle           | • Magnetic (°)  • True (°T)  • User (°U)                                    |
| Magnetic Variation  | • Specify number of degrees for east or west (°E, °W) — available only when "User (°U)" is active NAV angle |
```

**Comparison against ITM-10 context:** Fragment C §4.10 and Fragment E §10.6 documented the Unit Selections table. The new extraction shows **5 full parameter categories** with complete option lists — a structured markdown table with all entries readable. This is significantly cleaner than what the original extraction produced (ITM-10 flagged partial category listing). ITM-10 full resolution is a C3 review concern, but the new extraction provides the signal needed to evaluate it.

## Deviations from Prompt

| Item | Deviation | Impact |
|------|-----------|--------|
| Page count | Prompt estimated ~310 pages; actual = 330 | No impact — PDF has front matter and back matter not counted in the body page numbering. The script handles any page count. |
| Elapsed time | Prompt estimated 5–15 min; actual = 2.5 min | No impact — faster than expected. Agentic tier ran faster on this document. |
| `parsing_instruction` deprecation | SDK emits warning that `parsing_instruction` is deprecated; behavior unchanged | No impact — extraction completed normally. Next version of this script could migrate to `system_prompt`/`user_prompt`. |
| `page_094.md` spot check | Prompt specifies checking page_094.md for Unit Selections; actual content is on page_098.md (physical vs. logical page numbering offset). `page_094.md` contains "Airport Runway Criteria" (footer: 2-54). | No impact — Unit Selections was located and verified. The physical-vs-logical offset is expected and noted for C3 review agents. |
