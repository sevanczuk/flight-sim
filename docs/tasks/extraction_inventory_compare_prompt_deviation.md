---
Created: 2026-04-30T11:15:00-04:00
Source: docs/tasks/extraction_inventory_compare_prompt.md
---

# EXTRACTION-INVENTORY-COMPARE-01 Pre-flight Deviation Report

**Task ID:** EXTRACTION-INVENTORY-COMPARE-01
**Deviation type:** Pre-flight check failure — halt per task instructions
**Filed by:** CC (claude-sonnet-4-6)
**Date:** 2026-04-30

---

## Failed Check: Pre-flight Step 2 — Page count mismatch

The task prompt requires both `pages/` directories to contain exactly 330 `.md` files. Actual counts:

| Directory | Expected | Actual |
|-----------|----------|--------|
| `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages/` | 330 | **330** ✓ |
| `assets/gnx375_llama_extract/pages/` | 330 | **310** ✗ |

The retirement **target** (`gnx375_llama_extract/pages/`) has only 310 pages, 20 fewer than expected.

All other pre-flight checks passed:

| Check | Result |
|-------|--------|
| Both directories exist | ✓ PASS |
| Old pages count == 330 | ✓ PASS (330) |
| New pages count == 330 | ✗ FAIL (310) |
| No conflicting outputs exist | ✓ PASS |
| Python callable | ✓ PASS (Python 3.12.10) |

---

## Root Cause Investigation

Both extractions were run against the **same source PDF**:

```
assets/Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf
```

Yet the two LlamaParse runs returned different page counts. Key extraction log data:

### Old extraction (`gnc355_pdf_extracted/llamaparse_agentic_v1/`)
```json
{
  "parse_mode": "parse_page_with_agent",
  "result_type": "markdown",
  "page_count": 330,
  "elapsed_seconds": 148.7,
  "completed_at": "2026-04-24T10:31:37-0400",
  "llama_parse_version": "0.6.94"
}
```
No `images_to_save` parameter. No `formats_requested` list.

### New extraction (`gnx375_llama_extract/`)
```json
{
  "tier": "agentic",
  "formats_requested": ["markdown", "items"],
  "images_requested": ["screenshot", "embedded", "layout"],
  "page_count_returned": 310,
  "elapsed_seconds": 600.11,
  "completed_at": "2026-04-25T12:27:51Z",
  "sdk_name": "llama-cloud",
  "sdk_version": "2.4.1"
}
```
Uses newer `llama-cloud` SDK 2.4.1 (vs. `llama_parse` 0.6.94). Includes image extraction parameters.

### Key difference
- Old: `llama_parse` 0.6.94, `parse_page_with_agent` mode, no images → 330 pages
- New: `llama-cloud` SDK 2.4.1, `agentic` tier, images included → 310 pages, elapsed 600s (vs 149s)

The new run took 4× longer (600s vs 149s) and returned 20 fewer pages. This is likely caused by one of:
1. **SDK version change:** `llama-cloud` 2.4.1 vs `llama_parse` 0.6.94 may handle page splitting differently.
2. **Page merging:** The newer agentic tier may merge short or blank pages with their neighbors, reducing the page count.
3. **Incomplete run:** The new run may have been truncated (though `error: null` in the log suggests otherwise).
4. **Page numbering difference:** The new run's 310 pages may correspond to a different page numbering convention (e.g., skipping blank pages, numbering differently across a multi-section document).

The page file ranges are:
- Old: `page_001.md` through `page_330.md` (contiguous)
- New: `page_001.md` through `page_310.md` (contiguous)

---

## Implication for the Task's Gating Decision

Per the task's decision rules, **OLD_ONLY count > 0 forces REBUILD**:

> IF (OLD_ONLY count > 0) → **REBUILD**. Some page exists in the retirement candidate but not the target; the map references a page the target doesn't have.

If CC proceeds as-is, the comparison script will find 20 OLD_ONLY pages (page_311.md through page_330.md) and output `REBUILD`. However, this finding may be misleading if the 310-page new extraction is actually complete (i.e., the PDF content from pages 311–330 in the old extraction has been merged into earlier pages by the newer SDK).

---

## CD Decision Required

Before CC proceeds, CD should determine which of the following applies:

### Option A: Proceed with comparison as-is (most likely path)
- CC runs the comparison script. The gating decision will be **REBUILD** due to OLD_ONLY pages.
- CD reviews the per-page detail to understand whether the 20 missing pages represent genuinely absent content or page-merging by the newer SDK.
- If page-merging: CD notes this in the retirement plan and proceeds with REBUILD (safe; correct).
- If genuinely absent content: CD investigates before retiring the old directory.

**Recommended.** The task's REBUILD path is the conservative and safe choice regardless.

### Option B: Investigate the 20 missing pages first (before running the script)
- CD inspects `page_311.md` through `page_330.md` in the old extraction to understand their content.
- Checks whether that content appears embedded in earlier pages of the new extraction.
- If yes: the new extraction is complete; REBUILD is still the right call.
- If no: the new extraction may be genuinely incomplete; a re-extraction may be warranted.

### Option C: Accept that 310 is the correct canonical count
- If CD confirms the GNX 375 manual has 310 logical pages (in the newer SDK's view), update the pre-flight expected count to 310 and update the task prompt accordingly.
- CC proceeds; the comparison will show OLD_ONLY for pages 311–330.

---

## Immediate Data Available for CD Review

To quickly assess Option B, CD can inspect the old extraction's last few pages:
- `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages/page_311.md` through `page_330.md`
- Compare against `assets/gnx375_llama_extract/pages/page_310.md` (last page in new extraction)

---

## Recommended Next Step

CD authorizes one of Options A/B/C above. CC is halted pending that decision.

If the answer is Option A (most likely), CC can resume immediately with the task as written; the script will naturally detect and report the 20 OLD_ONLY pages, and the REBUILD verdict will be appropriate and documented.
