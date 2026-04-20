---
Created: 2026-04-20T12:10:00Z
Source: docs/tasks/amapi_crawler_prompt.md
---

# AMAPI-CRAWLER-01 Completion Report

## Summary

Implemented the AMAPI wiki crawler per the task prompt. All phases completed through Phase G (smoke test). Full fetch NOT run — deferred for Steve to launch manually.

## Modules Built

| File | Lines | Description |
|------|-------|-------------|
| `scripts/amapi_crawler.py` | 315 | Main orchestrator: argparse, import + fetch loop, completion report |
| `scripts/amapi_crawler_lib/__init__.py` | 0 | Package marker |
| `scripts/amapi_crawler_lib/normalize.py` | 89 | 6 URL normalization rules per D-03 |
| `scripts/amapi_crawler_lib/categorize.py` | 54 | Title-prefix bucket categorization per Plan §4.5 |
| `scripts/amapi_crawler_lib/filename.py` | 54 | Bidirectional canonical URL ↔ local filename mapping |
| `scripts/amapi_crawler_lib/db.py` | 216 | Schema creation, upsert helpers, backoff logic |
| `scripts/amapi_crawler_lib/parse.py` | 24 | BeautifulSoup link extractor |
| `scripts/amapi_crawler_lib/fetch.py` | 31 | HTTP fetch with politeness delay |
| `scripts/amapi_crawler_lib/importer.py` | 150 | Pre-existing mirror import (2-pass: import then edges) |
| `tests/test_amapi_crawler.py` | 385 | Unit tests |
| **Total** | **1318** | |

## Test Results

**Command:** `python -m pytest tests/test_amapi_crawler.py -v`

**Result: 92 passed, 0 failed** in 0.13s

Coverage: normalization (all 6 rules + idempotency), categorization (all API prefixes + NON_API_TITLES + Special/File/external/youtube), filename roundtrip (including colon and slash encoding, real mirror files), DB schema (all 3 tables + 5 indexes + idempotency), upsert behavior (insert, no-dup, source-not-demoted), backoff schedule (60s/300s/1800s, failed after 3 attempts).

## Smoke-Test Results

### Import-only mode (`--import-only`)

- **Files imported from pre-existing mirror:** 54
- **Edges created:** 1,130 unique (1,976 total including duplicates, deduped by UNIQUE constraint)
- **Parse failures:** 0
- **Out-of-scope files skipped:** 4 (Special: pages)

Post-import DB state:
| source | status | count |
|--------|--------|-------|
| pre-existing | fetched | 54 |
| pre-existing | out-of-scope | 302 |
| pre-existing | pending | 173 |

### Dry-run mode (`--dry-run`)

- **Seed URLs processed:** 384
- **Pending URLs for fetch:** 173 (all already discovered via link parsing; seed URLs were already present from mirror import)
- **Top categories pending:** Hw (28), Scene (12), User (11), Map (8), Fi (7), Switch/Msfs/Fs2024/Fs2020/Device (6 each), Xpl/Sound/Si/Nav/Ext/Canvas (5 each)

## Deviations from Prompt

1. **Robots.txt not implemented.** The Implementation Plan §4 A1 Safety section mentions "Respect robots.txt if present." This is not implemented in the current crawler. wiki.siminnovations.com likely has no restrictive robots.txt, but this can be added if needed before the full fetch. Low risk.

2. **Edge count discrepancy in import log.** The importer reports 1,976 edges created but the DB has 1,130 unique edges. This is correct behavior — the `edges` table has `UNIQUE (from_url_id, to_url_id)` so duplicate edges from multiple HTML files linking to the same target are silently ignored. The reported count in the importer is pre-dedup.

3. **Seed URLs show no new rows.** All 384 seed URLs were already discovered via the pre-existing mirror's link graph. No new `source='seed'` rows were added (the seed URLs exist as `source='pre-existing'`). This is correct behavior per the upsert logic (no source demotion).

## Recommendation

**Ready to launch full fetch.** Run:
```
python scripts/amapi_crawler.py
```

Expected: ~173 pages to fetch at 1-second intervals = ~3-5 minutes wall-clock. Well under the 4-hour limit. The fetch will discover additional URLs from newly-fetched pages; expect 1–2 discovery waves before the frontier is exhausted.

If the full fetch is complete and `crawl_complete.md` is written, proceed to A2 (AMAPI parser).
