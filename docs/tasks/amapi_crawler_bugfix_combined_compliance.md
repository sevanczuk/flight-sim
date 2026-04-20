---
Created: 2026-04-20T00:00:00Z
Source: docs/tasks/amapi_crawler_bugfix_combined_compliance_prompt.md
---

# AMAPI-CRAWLER-BUGFIX-COMBINED Compliance Report

**Verified:** 2026-04-20
**Verdict:** PASS WITH NOTES

## Summary
- Total checks: 41
- Passed: 40
- Failed: 0
- Partial: 1 (P4 — HTTP status counts from in-memory dict, not DB query)

## Results

### S. BUGFIX-01 — Source Labeling Fix

**S1. PASS** — `_load_seed_set(seeds_path: str) -> set` exists at `scripts/amapi_crawler_lib/importer.py:16–30`. Reads the seed file line by line, applies `normalize()`, returns a Python `set` of canonical URLs. Handles OSError (returns empty set).

**S2. PASS** — `import_mirror` signature at `importer.py:42–43`:
```python
def import_mirror(conn, mirror_dir: str, run_id: int, log_path: str | None = None,
                  seeds_path: str | None = None) -> dict:
```
`seeds_path` is a kwarg with default `None`. ✓

**S3. PASS** — In Pass 2 (`importer.py:151,159`):
```python
discovered_source = 'seed' if canonical_link in seed_set else 'discovered'
...
source=discovered_source,
```
`'pre-existing'` appears only once in the file (`importer.py:107`), inside Pass 1 for the mirror file itself. No discovered URL can receive `'pre-existing'`. ✓

**S4. PASS** — `amapi_crawler.py:242`:
```python
import_counts = import_mirror(conn, args.mirror, import_run_id, log_path, args.seeds)
```
`args.seeds` (the seeds path) is passed as the 5th positional argument. ✓

**S5. PASS** — `scripts/amapi_crawler_migrate_source.py` exists. Loads seed set via `load_seed_set()` with identical `normalize()` call (`migrate_source.py:24–34`). Selects rows via `WHERE source='pre-existing' AND local_path IS NULL` (`line 53`). Executes all updates in a single `with conn:` transaction (`line 67`). Inserts a `crawl_runs` row with `notes='source-labeling migration per AMAPI-CRAWLER-BUGFIX-01 item 1'` (`lines 74–77`). Idempotent: on second run, `rows` list is empty and the script prints `"Nothing to migrate — already idempotent."` early-return at `line 57`.

Note: The `UPDATE` statement targets by `url_id=?` (not the compound WHERE clause directly), but only rows pre-selected by `source='pre-existing' AND local_path IS NULL` are passed to it — functionally equivalent and idempotent.

**S6. PASS** — DB query confirms:
```
SELECT COUNT(*) FROM urls WHERE source='pre-existing' AND local_path IS NULL;
→ 0
```
Only `pre-existing|fetched: 54` rows exist; all have `local_path` set. ✓

---

### R. BUGFIX-01 — robots.txt Check

**R1. PASS** — `_load_robots_parser(user_agent: str, log_path: str, verify: bool | str = True)` at `amapi_crawler.py:104–120`. Fetches `https://wiki.siminnovations.com/robots.txt` via `requests.get` (`line 109`). Parses with `urllib.robotparser.RobotFileParser` (`lines 113–114`). Returns `None` on 404/empty (`line 110`) and on any `Exception` (`line 119`). Logs: `'robots.txt: not found — no restrictions apply'`, `'robots.txt: loaded; N rules applied'`, or `'robots.txt: fetch warning (ExcType) — proceeding without restrictions'`. ✓

**R2. PASS** — `_check_robots(parser, user_agent, url, url_id, conn, log_path)` at `amapi_crawler.py:123–135`. Returns `True` when `parser is None` (short-circuit on line 126: `if parser is None or parser.can_fetch(...)`). Calls `parser.can_fetch(user_agent, url)` when parser is set. When disallowed: updates DB via `UPDATE urls SET status='out-of-scope', last_error='robots.txt: disallowed'` (`lines 130–133`), logs `'SKIPPED (robots.txt) <url>'` (`line 129`), returns `False` (`line 135`). ✓

**R3. PASS** — `robots_parser = _load_robots_parser(user_agent, log_path, verify=verify)` called once at `amapi_crawler.py:305`, before the `while True:` loop. `_check_robots(robots_parser, ...)` called at `line 322`, before `fetch_page` at `line 328`. ✓

**R4. PASS** — `except Exception as e:` at `amapi_crawler.py:118–119` catches all network errors; logs the warning and returns `None`. Crawl proceeds without restrictions. Completion report confirms this behavior: "robots.txt: fetch warning (SSLError) — proceeding without restrictions." ✓

---

### P. BUGFIX-01 — Phase E.5 Progress Reporting

**P1. PASS** — `amapi_crawler.py:214–215`:
```python
parser.add_argument('--progress-refresh-seconds', type=float, default=60.0,
                    help='Seconds between stderr progress-line refreshes (0 to disable)')
```
✓

**P2. PASS** — `_build_progress_line` at `amapi_crawler.py:138–164`. Output format:
```
[H:MM:SS elapsed] fetched: N new / M total  |  HTTP: 200=a ...  |  queue: P pending  |  discovered: D new  |  rate: R/min
```
Matches the specified format. Confirmed by smoke-test output in completion report. ✓

**P3. PASS** — Time-check at `amapi_crawler.py:408`:
```python
if progress_interval > 0 and time.monotonic() - last_progress_time >= progress_interval:
```
Inside the `while True:` main loop. No thread creation (`grep` for `threading` or `Thread` in scripts returns nothing). ✓

**P4. PARTIAL** — `_build_progress_line` receives `http_counts: dict` as a parameter (the in-memory dict built up in the main loop), not by querying the DB. The DB is queried for `total_fetched`, `pending`, and `discovered_new` (`amapi_crawler.py:145–150`), but HTTP status counts come from the in-memory `http_counts` dict (`line 152`). The compliance prompt specifies:
```sql
SELECT http_status, COUNT(*) FROM urls WHERE last_fetched_run_id = ? GROUP BY http_status
```
The in-memory approach achieves functionally equivalent results (counts are updated on every fetch before the next progress refresh), but does not perform a DB query as specified. Functional behavior is correct; implementation deviates from spec.

**P5. PASS** — `amapi_crawler.py:337`:
```python
net_error_count += 1
```
Inside the `except Exception as e:` block in the fetch-error handler. Passed through to `_build_progress_line` as `net_errors`. ✓

**P6. PASS** — `amapi_crawler.py:411`:
```python
sys.stderr.write('\r' + line)
```
Carriage return, no newline, written to stderr. ✓

**P7. PASS** — `amapi_crawler.py:429`:
```python
sys.stderr.write('\r' + final_line + f'  |  STOPPED: {stop_reason}\n')
```
`'\n'` terminator and `STOPPED: <reason>` suffix. ✓

**P8. PASS** — In-loop refresh (`line 408`): `if progress_interval > 0 and ...` — skips when 0. Final line (`line 426`): `if progress_interval > 0:` — also skips when 0. Progress display fully suppressed. ✓

---

### M. BUGFIX-01 — Mirror File Reconciliation

**M1. PASS** — `docs/tasks/amapi_crawler_bugfix_01_completion.md` contains "Item 5: Mirror File Count (54 vs ~78 Discrepancy)" with category table. Math: 4 + 4 + 9 + 4 + 4 + 1 + 52 = 78. ✓

**M2. PASS** — All four filter categories documented:
1. Directories (4 items) — skipped via `os.path.isfile()` ✓
2. Non-content meta-files (4 items) — unrecognized filename pattern ✓
3. File:/Special: pages — listed as two sub-entries (9 File: media pages + 4 Special: pages) ✓
4. Main_Page action-variant deduplication (4 files → 1 import, 3 no-op upserts) ✓

File: and Special: are listed separately in the completion report rather than combined, but both categories are fully accounted for. ✓

---

### F. BUGFIX-02 — PEM File Placement

**F1. PASS** — `assets/air_manager_api/wiki-cert-chain.pem` exists; size: 6,739 bytes. ✓

**F2. PASS** — `grep -c "BEGIN CERTIFICATE" wiki-cert-chain.pem` → 3. Exactly 3 certificates (leaf + intermediate + root). ✓

**F3. PASS** — `assets/air_manager_api/wiki-cert-chain.README.md` exists. Documents:
- Chain contents: `*.siminnovations.com` leaf (valid 2026-05-26), Sectigo RSA Domain Validation intermediate, USERTrust RSA Certification Authority root ✓
- Regeneration steps referencing "Turn 32 diagnostic" (`docs/tasks/amapi_crawler_bugfix_02_prompt.md`) ✓
- Provenance header: `Created: 2026-04-20T00:00:00Z` + `Source: docs/tasks/amapi_crawler_bugfix_02_prompt.md` ✓

---

### T. BUGFIX-02 — TLS Configuration Flags

**T1. PASS** — `amapi_crawler.py:216–219`:
```python
parser.add_argument('--ca-bundle', type=str, default=None, ...)
parser.add_argument('--insecure', action='store_true', default=False, ...)
```
✓

**T2. PASS** — `resolve_verify(args, log_path)` at `amapi_crawler.py:167–198`. Priority chain:
1. `if args.insecure:` → returns `False`, logs warning, writes to stderr, calls `urllib3.disable_warnings(InsecureRequestWarning)` ✓
2. `if args.ca_bundle:` → validates path with `bundle_path.exists()` (raises `SystemExit` if missing), returns `str(bundle_path)` ✓
3. `if project_pem.exists():` → returns `str(project_pem)` ✓
4. else → returns `True` (certifi default) ✓

**T3. PASS** — `amapi_crawler.py:176–177`:
```python
if args.insecure and args.ca_bundle:
    _log('WARNING: both --insecure and --ca-bundle specified; --insecure wins', log_path)
```
Then falls through to `if args.insecure:` which returns `False`. `--insecure` wins. ✓

**T4. PASS** — `verify = resolve_verify(args, log_path)` at `amapi_crawler.py:225`. Result passed to `_load_robots_parser(user_agent, log_path, verify=verify)` at `line 305` and `fetch_page(..., verify=verify)` at `line 328`. ✓

**T5. PASS** — `_load_robots_parser` signature at `amapi_crawler.py:104`:
```python
def _load_robots_parser(user_agent: str, log_path: str, verify: bool | str = True):
```
Passes it to `requests.get(robots_url, ..., verify=verify)` at `line 109`. ✓

**T6. PASS** — `fetch_page` in `scripts/amapi_crawler_lib/fetch.py:17–18`:
```python
def fetch_page(url: str, user_agent: str, min_delay_seconds: float = 1.0,
               verify: bool | str = True) -> tuple[int, bytes]:
```
Passed to `session.get(url, timeout=30, allow_redirects=True, verify=verify)` at `fetch.py:31`. ✓

**T7. PASS** — `grep -rn "requests\." scripts/` returns one match:
```
amapi_crawler.py:109: resp = requests.get(robots_url, ..., verify=verify)
```
The `fetch.py` module uses `session.get(...)` (not `requests.get` directly); it includes `verify=verify`. No stray `requests.get/post` calls without `verify=`. ✓

**T8. PASS** — `urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)` appears only at `amapi_crawler.py:182`, inside `if args.insecure:` inside `resolve_verify`. Not called at module load. ✓

---

### X. Tests

**X1. PASS** — `python -m pytest tests/test_amapi_crawler.py --collect-only -q` reports `106 tests collected`. ✓

**X2. PASS** — All 5 BUGFIX-01 tests confirmed at `tests/test_amapi_crawler.py`:
- `TestImporterSourceLabeling::test_discovered_links_not_labeled_pre_existing` (line 401) ✓
- `TestImporterSourceLabeling::test_pre_existing_fetched_not_demoted_by_link_discovery` (line 442) ✓
- `TestRobotsCheck::test_disallowed_url_marked_out_of_scope` (line 481) ✓
- `TestRobotsCheck::test_allowed_url_returns_true` (line 504) ✓
- `TestRobotsCheck::test_none_parser_always_allows` (line 513) ✓

**X3. PASS** — All 9 BUGFIX-02 tests confirmed at `tests/test_amapi_crawler.py`:
- `TestResolveVerify::test_insecure_flag_returns_false` (line 541) ✓
- `TestResolveVerify::test_insecure_wins_over_ca_bundle` (line 546) ✓
- `TestResolveVerify::test_ca_bundle_flag_returns_path` (line 555) ✓
- `TestResolveVerify::test_ca_bundle_missing_file_exits` (line 562) ✓
- `TestResolveVerify::test_project_pem_fallback` (line 567) ✓
- `TestResolveVerify::test_certifi_default_fallback` (line 576) ✓
- `TestFetchVerifyParameter::test_verify_true_passed_through` (line 593) ✓
- `TestFetchVerifyParameter::test_verify_path_passed_through` (line 604) ✓
- `TestFetchVerifyParameter::test_verify_false_passed_through` (confirmed via --collect-only output) ✓

**X4. PASS** — `python -m pytest tests/test_amapi_crawler.py -q` reports `106 passed in 0.25s`. ✓

---

### D. Database Post-Migration State

**D1. PASS** — `assets/air_manager_api/crawl.sqlite3` is readable via sqlite3. ✓

**D2. PASS** — URL counts by (source, status):
```
discovered|out-of-scope: 357
discovered|pending:         6
pre-existing|fetched:      54
seed|fetched:              88
seed|out-of-scope:         63
seed|pending:              79
```
- `pre-existing|fetched: 54` ✓ (the 54 on-disk HTML files)
- `seed|fetched: 88` ✓ (seed URLs fetched in smoke tests after BUGFIX-02 TLS fix)
- `seed|pending: 79` ✓ (seed URLs still queued; 167 - 88 = 79)
- `seed|out-of-scope: 63` ✓ (matches expected)
- `discovered|pending: 6` ✓
- `discovered|out-of-scope: 357` — higher than expected ~239; accounts for additional crawl runs after BUGFIX-01 that discovered more out-of-scope links
- No `source='pre-existing'` rows with `local_path IS NULL` (count: 0) ✓

**D3. PASS** — `crawl_runs` has 9 rows (≥ 5). Migration run at `run_id=4`, `notes='source-labeling migration per AMAPI-CRAWLER-BUGFIX-01 item 1'` ✓. Smoke-test runs visible at run_ids 6, 7, 8, 9 with wall-clock stop reason ✓.

---

### N. Negative Checks

**N1. PASS** — `git status --short assets/air_manager_api/wiki.siminnovations.com/` produces no output. Mirror directory is untouched. ✓

**N2. PASS** — `git status --short assets/instrument-samples/` produces no output. Instrument-samples directory is untouched. ✓

**N3. PASS** — `scripts/amapi_crawler_lib/__init__.py` is empty (zero bytes, no content). ✓

---

## Notes

1. **P4 deviation (in-memory HTTP counters):** The compliance prompt specifies HTTP status counts should be pulled from the DB each refresh via `SELECT http_status, COUNT(*) FROM urls WHERE last_fetched_run_id = ? GROUP BY http_status`. The implementation instead passes an in-memory `http_counts: dict` to `_build_progress_line`. This dict is updated on every successful/failed fetch before the next progress refresh, so the displayed values are correct and current. The deviation is an implementation choice (lower DB overhead) with equivalent functional behavior. No action required.

2. **S5 UPDATE mechanics:** The migration script selects rows with `WHERE source='pre-existing' AND local_path IS NULL`, then updates each by `url_id=?`. The per-row UPDATE does not repeat the compound WHERE — but this is safe because the rows are pre-filtered. Idempotency is preserved because `source` is changed away from `'pre-existing'` so the SELECT finds nothing on second run.

3. **D2 discovered|out-of-scope count (357 vs ~239):** The higher count reflects additional crawl runs conducted as smoke tests after BUGFIX-02 was applied (runs 7–9). Each run discovers additional external/Special/File links that are immediately marked out-of-scope. This is expected behavior.

4. **discovered|fetched: 0:** All short smoke-test runs (0.01–0.02h wall-clock) exhausted time fetching seed URLs before reaching any discovered URLs. No concern — the crawler prioritizes correctly and will pick up discovered URLs in a full run.
