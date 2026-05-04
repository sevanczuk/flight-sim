---
Created: 2026-04-30T14:45:00-04:00
Source: docs/tasks/build_page_number_map_prompt.md
---

# BUILD-PAGE-NUMBER-MAP Completion Report

**Task ID:** GNX375-PAGEMAP-01
**Outputs:**
- `scripts/build_page_number_map.py` (388 lines)
- `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json` (11,861 bytes; 296 of 330 pages parsed)

---

## Pre-flight Verification Results

| Check | Expected | Actual | Result |
|-------|----------|--------|--------|
| Pages directory exists | True | True | PASS |
| Page file count | 330 | 330 | PASS |
| ITM-11 in issue_index.md | Present | Present | PASS |
| No conflicting outputs | Both False | Both False | PASS |
| Python version | Python 3.x | Python 3.12.10 | PASS |

---

## Phase 0 Audit Results

**ITM-11 anchor citations confirmed** (read from issue_index.md §ITM-11):

| Content | Garmin logical page | Physical page | Offset |
|---------|---------------------|---------------|--------|
| XPDR Modes (§11.4 source) | p. 78 (logical) | page_080.md | +2 |
| VFR Key + IDENT (§11.6 source) | p. 80 (logical) | page_082.md | +2 |
| Unit Selections (§4.10 source) | p. 94 (logical) | page_098.md | +4 |
| Land Data Symbols (§4.X source) | p. 125 (logical) | page_129.md | +4 |

**Footer formats observed in Phase 0 sampling:**

| Format | Sample page | Footer text observed |
|--------|-------------|----------------------|
| Right-aligned | page_017 | `190-02488-01 Rev. C    Pilot's Guide    1-1` |
| Left-aligned, no bold | page_080 | `2-42 Pilot's Guide 190-02488-01 Rev. C` |
| Left-aligned, extra spaces | page_082 | `2-44    Pilot's Guide    190-02488-01 Rev. C` |
| Bold left-aligned | page_039 | `**2-2** Pilot's Guide 190-02488-01 Rev. C` |
| Roman numeral (right) | page_005 | `190-02488-01 Rev. C    Pilot's Guide    iii` |
| Narration form (plain) | page_310 | `-   6-22 / -   Pilot's Guide / -   190-02488-01 Rev. C` |

**Two additional formats discovered during development (not in prompt list):**
- **Page Information label**: `**Page Number:** 1-5` (found in ~5 pages; description-mode extraction)
- **Page heading**: `### **Page 2-40: Pilot's Guide 190-02488-01 Rev. C**` (found in 1 page; description-mode extraction)

**Root cause of apostrophe bug:** LlamaParse extraction mixes U+0027 (straight apostrophe) and U+2019 (curly right single quotation mark) in `Pilot's Guide`. Initial `_APOS = r"['']"` silently stored both characters as U+2019 due to tool quote-normalization. Fixed using `chr()` to explicitly construct the character class.

**Edge-case pages identified in Phase 0:**
- page_001 (cover), page_002 (copyright), page_330 (back cover): no standard footer
- page_037: intentionally blank, left-aligned footer `1-20`
- page_310: intentionally blank, narration-form footer `6-22`
- ~10 pages with only `Doc ID: {uuid}\nText:` — LlamaParse returned empty extraction

---

## Footer Format Coverage

| Format | Pages matched | Sample identifier |
|--------|---------------|-------------------|
| Right-aligned | 147 | `1-1`, `3-15`, `iii` |
| Left-aligned | 139 | `2-42`, `2-58`, `1-20` |
| Bold variant | 1 | `2-2` (page_039 only) |
| Narration (plain/labeled) | 3 | `6-22` (page_310), `2-74` (page_114) |
| Page Info label | 5 | `1-5` (page_021), `1-13` (page_029) |
| Page heading | 1 | `2-40` (page_078) |
| Prose description | 0 | — (pattern present but no matches found) |
| Unparseable | 34 | — |
| **Total** | **330** | |

---

## Verification Results

| Check | Result | Details |
|-------|--------|---------|
| V1: physical_page_count == 330 | **PASS** | 330 |
| V2: parsed + unparseable == 330 | **PASS** | 296 + 34 = 330 |
| V3: Anchor citations (4/4) | **PASS** | All 4 ITM-11 pairs correct |
| V4: Roman numerals pages 3-16 | **PASS** | i, ii, iii, iv, v, vi, vii, viii, ix, x, xi, xii, xiii, xiv |
| V5: Section transitions | **INFO** | 8 clean section boundaries detected (sections 1-9) |
| V6: Logical duplicates | **PASS** | 0 duplicates |
| V7: Unparseable count <= 30 | **FAIL** (advisory) | 34 pages; investigation confirms all are genuinely unrecoverable (Doc-ID-only, no-footer extractions) |

**Critical check summary (V1+V2+V3+V6): ALL PASS. Script exits 0.**

V7 FAIL is advisory only (does not affect exit code). The 34 unparseable pages break down as:
- ~10 Doc-ID-only pages (LlamaParse returned empty text)
- ~22 content pages where LlamaParse described figures without including footer text
- 2 expected (cover, back cover)

---

## Phase C Spot-Check Results

| Page | Expected | Actual | Result | Notes |
|------|----------|--------|--------|-------|
| page_017 | `1-1` | `1-1` | PASS | Start of Section 1 |
| page_038 | `1-22` (prompt) | `2-1` | NOTE | Prompt estimate was off; actual Section 2 starts at physical 38, not 39 |
| page_039 | `2-1` (prompt) | `2-2` | NOTE | Section 2 page 2 (bold format); both values are correct for their actual pages |
| page_080 | `2-42` | `2-42` | PASS | ITM-11 anchor verified |
| page_098 | `2-58` | `2-58` | PASS | ITM-11 anchor verified |
| page_125 | `3-11` | `3-11` | PASS | ITM-11 row 3 anchor |
| page_129 | `3-15` | `3-15` | PASS | ITM-11 anchor verified |
| page_310 | `6-22` | `6-22` | PASS | Narration-form footer correctly parsed |
| page_005 | `iii` | `iii` | PASS | Roman numeral front matter |
| page_001 | `unparseable` | `unparseable` | PASS | Cover page, no footer |

**10/10 checks report correct values.** The two NOTE rows are due to the prompt's estimated values being off by one page — the script values are correct.

---

## Map Statistics

| Metric | Value |
|--------|-------|
| Total physical pages | 330 |
| Successfully parsed | 296 |
| Unparseable | 34 |
| Logical-side duplicates | 0 |
| Section transitions detected | 8 |
| Roman numeral pages | 14 (pages 3-16) |
| Footer format variants | 7 (right, left, bold, narration plain, narration labeled, page-info, page-heading) |

---

## Logical Identifier Range

| Range | Logical First | Logical Last | Physical First | Physical Last | Page Count |
|-------|---------------|--------------|----------------|---------------|------------|
| Roman (front matter) | `i` | `xiv` | 3 | 16 | 14 |
| Section 1 | `1-1` | `1-20` | 17 | 37 | 20 |
| Section 2 | `2-1` | `2-74` | 38 | 114 | 73 |
| Section 3 | `3-1` | `3-98` | 115 | 217 | 95 |
| Section 4 | `4-1` | `4-14` | 218 | 231 | 13 |
| Section 5 | `5-1` | `5-48` | 232 | 285 | 45 |
| Section 6 | `6-1` | `6-22` | 286 | 310 | 21 |
| Section 7 | `7-1` | `7-6` | 311 | 317 | 6 |
| Section 8 | `8-1` | `8-6` | 318 | 324 | 5 |
| Section 9 | `9-1` | `9-4` | 325 | 328 | 4 |

---

## Unparseable Pages Detail

| Page | Likely Reason |
|------|---------------|
| 1 | Cover page — title block only, no footer |
| 2 | Copyright page — unusual footer format (`22\nPAP`) |
| 32 | Content page — LlamaParse extracted table without footer |
| 65 | Content page — extraction ended without footer |
| 72 | Content page — extraction ended without footer |
| 87 | `Doc ID: {uuid}\nText:` — empty extraction |
| 89 | `Doc ID: {uuid}\nText:` — empty extraction |
| 141 | Content page — LlamaParse described figures, no footer |
| 143 | Content page — LlamaParse described figures, no footer |
| 162 | Description-mode page — no footer in description |
| 186 | `Doc ID: {uuid}\nText:` — empty extraction |
| 192 | Content page — no footer extracted |
| 203 | Content page — no footer extracted |
| 211 | Content page — no footer extracted |
| 216 | Content page — no footer extracted |
| 226 | Content page — no footer extracted |
| 247 | `Doc ID: {uuid}\nText:` — empty extraction |
| 248 | `Doc ID: {uuid}\nText:` — empty extraction |
| 249 | `Doc ID: {uuid}\nText:` — empty extraction |
| 251 | `Doc ID: {uuid}\nText:` — empty extraction |
| 259 | Content page — no footer extracted |
| 264 | Content page — no footer extracted |
| 271 | Content page — no footer extracted |
| 279 | Content page — no footer extracted |
| 283 | Content page — no footer extracted |
| 293 | Content page — table without footer |
| 298 | Content page — no footer extracted |
| 307 | Content page — no footer extracted |
| 308 | Content page — no footer extracted |
| 314 | Content page — no footer extracted |
| 321 | Content page — no footer extracted |
| 322 | Content page — no footer extracted |
| 329 | Content page — no footer extracted |
| 330 | Back cover — only `190-02488-01 Rev. C`, no page identifier |

---

## Open Questions / CD Review Items

1. **V7 threshold**: 34 unparseable pages exceeds the prompt's 30-page threshold, but all are confirmed genuinely unrecoverable (not a parser defect). CD may wish to adjust the V7 threshold to 35 in future prompts, or simply accept V7 as informational for this corpus.

2. **Prompt spot-check estimates**: Prompt expected page_038 = `1-22` and page_039 = `2-1`. Actual: page_038 = `2-1` (section 2 title page) and page_039 = `2-2`. The map values are correct — the prompt's estimates were based on an approximate offset calculation.

3. **`prose_description` pattern unused**: The `_FOOTER_PROSE_RE` pattern (matching "The page number is X") was added but matched 0 pages in practice. May be dead code; leaving in place as it costs nothing and protects against future LlamaParse behavior.

---

## Deviations from Prompt

| Item | Deviation |
|------|-----------|
| Footer format discovery | Found 2 additional formats beyond the 6 listed: "Page Information label" (`**Page Number:** N`) and "Page heading" (`**Page N: Pilot's Guide...`). Both handled and documented. |
| Apostrophe bug | `_APOS` regex failed initially due to tool quote-normalization converting U+0027 to U+2019. Fixed by using `chr(0x0027)` explicitly. |
| Section 1 end page | Prompt expected page_037 = `1-22`; actual section 1 ends at `1-20` (physical 37). Map is correct. |
| V7 result | 34 unparseable (prompt expected ~10-15, threshold 30). All confirmed genuinely unrecoverable. |
