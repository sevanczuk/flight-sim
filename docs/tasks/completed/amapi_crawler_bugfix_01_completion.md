---
Created: 2026-04-20T12:31:00Z
Source: docs/tasks/amapi_crawler_bugfix_01_prompt.md
---

# AMAPI-CRAWLER-BUGFIX-01 Completion Report

## Summary Table

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | Fix source labeling semantics (importer) | FIXED | Migration applied; DB verified |
| 2 | robots.txt check | FIXED | Added; fail-open on network error |
| 3 | Phase E.5 live progress reporting | IMPLEMENTED | Was not present; implemented per spec |
| 4 | Test suite (baseline 92 + new tests) | VERIFIED | 97 passed (92 baseline + 5 new) |
| 5 | 54 vs ~78 mirror file discrepancy | DOCUMENTED | See Phase G section below |
| 6 | Completion report edge-count phrasing | FIXED | See Phase F section below |

---

## Item 1: Source Labeling Fix

### Problem
475 URLs (302 out-of-scope + 173 pending) were marked `source='pre-existing'` despite having no HTML file on disk. They were discovered via link parsing of the 54 real pre-existing files. Per D-03, `source='pre-existing'` means the URL's HTML file is physically on disk.

### Importer Fix
`scripts/amapi_crawler_lib/importer.py`:
- Added `_load_seed_set(seeds_path)` helper
- Added `seeds_path: str | None = None` parameter to `import_mirror`
- Pass 2 (link parsing) now uses `'seed'` if the discovered URL is in the seed set, `'discovered'` otherwise — never `'pre-existing'`

`scripts/amapi_crawler.py`:
- Updated `import_mirror(...)` call to pass `args.seeds`

### Migration Script
`scripts/amapi_crawler_migrate_source.py` — one-shot migration that corrects existing DB rows:
- WHERE `source='pre-existing' AND local_path IS NULL`
- Updates to `'seed'` if URL in seed set, `'discovered'` otherwise
- Single transaction; idempotent (WHERE clause finds nothing on second run)
- Adds `crawl_runs` row with migration note

### DB State Before Migration
```
pre-existing|fetched:      54
pre-existing|out-of-scope: 302
pre-existing|pending:      173
```

### DB State After Migration
```
discovered|out-of-scope: 239
discovered|pending:         6
pre-existing|fetched:      54
seed|out-of-scope:         63
seed|pending:             167
```

Migration moved 475 rows: 230 → `seed`, 245 → `discovered`. The 54 `pre-existing|fetched` rows are untouched (they have `local_path` set — correct label).

**Idempotency verification:** Second run of migration script outputs `"Nothing to migrate — already idempotent."` ✓

---

## Item 2: robots.txt Check

**Implementation:** Added to `scripts/amapi_crawler.py`:
- `_load_robots_parser(user_agent, log_path)`: fetches robots.txt via `requests`, parses with `urllib.robotparser.RobotFileParser`. Returns None if 404/empty/unreachable. Logs result to `crawl_log.txt`.
- `_check_robots(parser, user_agent, url, url_id, conn, log_path)`: per-URL check. If disallowed: marks `status='out-of-scope'`, sets `last_error='robots.txt: disallowed'`, logs `SKIPPED (robots.txt)`, returns False.
- Called before the fetch loop (one robots.txt fetch per crawl run) and inside the loop before each URL is fetched.
- Fail-open: network error on robots.txt fetch logs a warning and proceeds without restrictions.

**Smoke test result:** robots.txt fetch got an SSL certificate verification error (Windows dev environment — CA chain not in Python trust store). Crawler logged: `robots.txt: fetch warning (SSLError) — proceeding without restrictions`. Correct fail-open behavior.

---

## Item 3: Phase E.5 Progress Reporting

**Verdict:** Was NOT present in the original implementation. Implemented per spec.

**Implementation in `scripts/amapi_crawler.py`:**
- Added `--progress-refresh-seconds` argument (default 60; set to 0 to disable)
- Added `_build_progress_line(conn, run_id, start_time, fetched_this_run, discovered_this_run, http_counts, net_errors)` helper
- In fetch loop: tracks `fetched_this_run` and `net_error_count` separately; `http_counts` dict keyed by status code
- Progress refresh: time-check inside the main loop (not a background thread)
- Final line written with `\n` and `STOPPED: <reason>` suffix

**Rendered progress line from smoke test:**
```
[0:01:12 elapsed] fetched: 0 new / 54 total  |  HTTP: err=186  |  queue: 173 pending  |  discovered: 0 new  |  rate: 0.0/min  |  STOPPED: wall-clock limit (0.02h)
```

Note: The smoke test environment (Windows + Python without the wiki's CA cert) produced 186 network-level SSL errors. The progress line correctly grouped these under `err=186`. In the full-fetch environment this would show HTTP 200 counts instead.

---

## Item 4: Test Suite Results

**Baseline:** 92 passed

**New tests added (5 tests in 3 new test classes):**

`TestImporterSourceLabeling`:
- `test_discovered_links_not_labeled_pre_existing` — verifies links discovered in Pass 2 get `'seed'` or `'discovered'` labels, not `'pre-existing'`
- `test_pre_existing_fetched_not_demoted_by_link_discovery` — verifies a URL already in DB as `pre-existing/fetched` is not demoted when re-encountered as a discovered link

`TestRobotsCheck`:
- `test_disallowed_url_marked_out_of_scope` — mocks `can_fetch` returning False; verifies DB status becomes `'out-of-scope'` and `last_error` contains `'robots.txt'`
- `test_allowed_url_returns_true` — mocks `can_fetch` returning True; verifies function returns True
- `test_none_parser_always_allows` — verifies None parser allows all URLs

**Final result: 97 passed, 0 failed**

---

## Item 5: Mirror File Count (54 vs ~78 Discrepancy)

**Mirror directory total entries:** 78 (via `ls | wc -l`)

**Category breakdown:**

| Category | Count | Disposition |
|----------|-------|-------------|
| Directories (extensions/, images/, resources/, skins/) | 4 | Skipped — `os.path.isfile()` check |
| Non-content meta-files (api.php@action=rsd, opensearch_desc.php, load.php×2) | 4 | Skipped — unrecognized filename pattern |
| File: media pages (index.php@title=File%3A*.png, *.jpg) | 9 | Skipped — extension filter (`.png`, `.jpg` in `_SKIP_EXTENSIONS`) |
| Special: pages (Special%3ARandom, Special%3ARecentChanges&feed=atom, Special%3ASpecialPages, Special%3AUserLogin&returnto=Main+Page) | 4 | Skipped — `normalize()` returns None for Special: pages |
| Main_Page action/oldid variants (Main_Page&action=edit, &action=history, &action=info, &oldid=5980) | 4 files | All normalize to same canonical URL → 1 import, 3 upserts (no-op) |
| root page (index.html → https://wiki.siminnovations.com/) | 1 | Imported |
| Content pages (index.php@title=API, Air_Manager_*, …, VEMD_H120) | 52 | Imported |
| **Total imported** | **54** | 1 root + 1 Main_Page + 52 content |

**Expected 54 after filtering — discrepancy is fully explained.** No pages were accidentally excluded.

---

## Item 6: Completion Report Phrasing Fix

Edited `docs/tasks/amapi_crawler_completion.md`:

1. **Edge count deviation reworded:**
   Old: `"Edge count discrepancy in import log. The importer reports 1,976 edges created but the DB has 1,130 unique edges."`
   New: `"1,130 unique edges stored (deduped from 1,976 link references via UNIQUE (from_url_id, to_url_id) constraint — the 1,976 number reflects raw parse output before dedup)."`

2. **Post-remediation note added** at the top of the Deviations section:
   `"Post-remediation: items 1, 3 (labeling + robots.txt) addressed by AMAPI-CRAWLER-BUGFIX-01 on 2026-04-20."`

---

## Smoke Test Output (Phase E)

**Dry-run:** 173 pending URLs, category breakdown unchanged from original smoke test. ✓

**Short fetch (--max-wall-clock-hours 0.02):**
- Duration: 1m 12s
- 186 URLs attempted, all failed with `SSLCertVerificationError` (Windows dev environment — Python 3.12 trust store does not include the wiki's CA)
- robots.txt fetch: fail-open with warning logged ✓
- Progress display rendered correctly on stderr ✓
- Final line with STOPPED reason written ✓
- DB state post-run: 173 still pending (no successful fetches, as expected for SSL environment)

**SSL note for full fetch:** Steve will need to either (a) install the wiki's CA cert into the Windows system trust store, or (b) run `python -m certifi` / configure `requests` to use `verify=False` for this site. The failure is environmental, not a bug in the crawler.

---

## Deviations from This Prompt

None. All 6 items addressed as specified.

---

## Recommendation

**Bug-fix complete, ready to launch full fetch.** Before launching:
1. Resolve SSL certificate issue on the target machine (see Smoke Test note above)
2. Run: `python scripts/amapi_crawler.py`

Expected: ~173 pages pending, 1–2 discovery waves before frontier exhausted.
