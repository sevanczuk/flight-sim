# CC Compliance Prompt: AMAPI Crawler BUGFIX-01 + BUGFIX-02

**Location:** `docs/tasks/amapi_crawler_bugfix_combined_compliance_prompt.md`
**Task ID:** AMAPI-CRAWLER-BUGFIX-COMBINED-COMPLIANCE
**Verifying:** AMAPI-CRAWLER-BUGFIX-01 (completed 2026-04-20) + AMAPI-CRAWLER-BUGFIX-02 (completed 2026-04-20)

**Prompts:**
- `docs/tasks/amapi_crawler_bugfix_01_prompt.md`
- `docs/tasks/amapi_crawler_bugfix_02_prompt.md`

**Completion reports:**
- `docs/tasks/amapi_crawler_bugfix_01_completion.md`
- `docs/tasks/amapi_crawler_bugfix_02_completion.md`

---

## Instructions

This is a **read-only verification task**. Do NOT modify any source files. Verify that the BUGFIX-01 and BUGFIX-02 implementations match their respective prompts by gathering concrete evidence from the source code and DB state.

Read `CLAUDE.md` for project conventions. Note the D-04 commit trailer format — this task's commit will use the format.

For each checklist item below, report:
- **PASS** — with evidence (file, line number, relevant snippet)
- **FAIL** — with what was expected vs. what was found
- **PARTIAL** — with explanation of what's present and what's missing

Use `grep -n` liberally. Quote the specific lines that prove compliance.

**Two-bugfix combined compliance** — check BUGFIX-01 items first, then BUGFIX-02 items. Overlapping code paths (e.g., the fetch loop touching both the robots.txt check from B01 and the verify parameter from B02) should pass both classes of check.

---

## Checklist

### S. BUGFIX-01 — Source Labeling Fix

S1. `scripts/amapi_crawler_lib/importer.py` — `_load_seed_set()` helper exists and reads the seed URL file; returns a Python `set` of normalized URLs.

S2. `import_mirror` in `importer.py` accepts a `seeds_path` parameter (kwarg with default None acceptable).

S3. In the Pass-2 link-parsing loop of `import_mirror`, when upserting a discovered URL, the `source` value is `'seed'` if the URL is in the seed set, `'discovered'` otherwise. **No discovered URL is labeled `'pre-existing'`.** Grep for `source=` and `'pre-existing'` in `importer.py` to confirm.

S4. `scripts/amapi_crawler.py` — the call to `import_mirror(...)` passes the seeds path (either explicitly as a kwarg or via the args object).

S5. One-shot migration script `scripts/amapi_crawler_migrate_source.py` exists and:
- Loads the seed set identically to `_load_seed_set` (same normalization)
- UPDATE statement targets `WHERE source='pre-existing' AND local_path IS NULL`
- Single transaction
- Adds a `crawl_runs` row with note referencing the migration
- Idempotent (WHERE clause finds nothing on second run)

S6. DB verification: query the current `urls` table and confirm `source='pre-existing'` appears ONLY on rows with `local_path IS NOT NULL`. Count should be ~54 (matching the 54 on-disk HTML files).
```sql
SELECT COUNT(*) FROM urls WHERE source='pre-existing' AND local_path IS NULL;
-- Expected: 0
```

### R. BUGFIX-01 — robots.txt Check

R1. `scripts/amapi_crawler.py` — function `_load_robots_parser(user_agent, log_path)` exists and:
- Fetches `https://wiki.siminnovations.com/robots.txt` via `requests.get`
- Parses response with `urllib.robotparser.RobotFileParser`
- Returns `None` on 404 / empty / network error (fail-open)
- Logs result to `crawl_log.txt` (found / not-found / fetch-warning)

R2. `scripts/amapi_crawler.py` — function `_check_robots(parser, user_agent, url, url_id, conn, log_path)` exists and:
- Returns `True` when `parser is None` (fail-open)
- Calls `parser.can_fetch(user_agent, url)` when parser is set
- When disallowed: updates the URL row to `status='out-of-scope'`, sets `last_error='robots.txt: disallowed'`, logs `SKIPPED (robots.txt) <url>`, returns False

R3. The fetch loop in `main()` calls `_load_robots_parser` ONCE before the loop (not per URL) and `_check_robots` BEFORE each URL's `fetch_page` call.

R4. Transient robots.txt fetch errors do NOT stop the crawl. A network error on the robots.txt fetch logs a warning and the crawler proceeds without restrictions. Look for this behavior in the code and log format.

### P. BUGFIX-01 — Phase E.5 Progress Reporting

P1. `--progress-refresh-seconds` argument exists in `scripts/amapi_crawler.py` `argparse` with default `60`.

P2. A `_build_progress_line` (or similarly-named) function exists and produces a single-line string matching the specified format:
```
[HH:MM:SS elapsed] fetched: <N> new / <M> total  |  HTTP: 200=<a> ...  |  queue: <P> pending  |  discovered: <D> new  |  rate: <R>/min
```

P3. Progress display refreshes driven by a time-check INSIDE the main loop (not a background thread). Grep for thread creation — none should exist for this purpose.

P4. HTTP status counters pulled from the DB each refresh via a query like:
```sql
SELECT http_status, COUNT(*) FROM urls WHERE last_fetched_run_id = ? GROUP BY http_status
```

P5. Network-level errors (no http_status) tracked via in-memory counter incremented in the failure handler.

P6. Progress line written to stderr with `'\r' + line` (carriage return, no newline) per refresh.

P7. Final line written with `'\n'` terminator and `| STOPPED: <reason>` suffix when the fetch loop exits.

P8. When `--progress-refresh-seconds=0`, the progress display is skipped entirely.

### M. BUGFIX-01 — Mirror File Reconciliation (documented)

M1. `docs/tasks/amapi_crawler_bugfix_01_completion.md` contains the 54-vs-78 breakdown documenting what was filtered and why. This is a documentation-only check — confirm the section exists and the math adds up to 78.

M2. The breakdown identifies four filter categories: directories skipped, non-content meta-files, File:/Special: pages, and the Main_Page action-variant deduplication.

### F. BUGFIX-02 — PEM File Placement

F1. `assets/air_manager_api/wiki-cert-chain.pem` exists with a nonzero byte size.

F2. The PEM file contains exactly 3 `-----BEGIN CERTIFICATE-----` markers (leaf + intermediate + root). `grep -c` on the PEM file should return `3`.

F3. `assets/air_manager_api/wiki-cert-chain.README.md` exists and:
- Documents the cert chain contents (leaf `*.siminnovations.com`, Sectigo intermediate, USERTrust root)
- Documents regeneration steps referencing the Turn 32 diagnostic
- Includes a provenance header per project convention

### T. BUGFIX-02 — TLS Configuration Flags

T1. `scripts/amapi_crawler.py` `argparse` has two new flags:
- `--ca-bundle PATH` (type=str, default None)
- `--insecure` (store_true, default False)

T2. Function `resolve_verify(args, log_path)` exists and implements the priority chain:
1. If `--insecure` → returns `False`, logs warning, writes stderr notice, suppresses `InsecureRequestWarning`
2. If `--ca-bundle PATH` → validates path exists (SystemExit if not), returns path as str
3. If project PEM at `assets/air_manager_api/wiki-cert-chain.pem` exists → returns path as str
4. Otherwise → returns `True`

T3. `--insecure` AND `--ca-bundle` both specified: `--insecure` wins, warning logged about both being specified.

T4. `resolve_verify` is called ONCE at startup; result stored in a `verify` variable; passed through to every `requests`-using call in the crawler.

T5. `_load_robots_parser` accepts the `verify` parameter and passes it to its `requests.get` call.

T6. `fetch_page` in `scripts/amapi_crawler_lib/fetch.py` accepts `verify` kwarg and passes it through to `requests.Session.get` or `requests.get`.

T7. No stray `requests.get(...)` or `requests.post(...)` calls exist without a `verify=` argument. Audit: `grep -rn "requests\." scripts/ | grep -v verify=`. Should show only the functions that plumbed it through.

T8. `urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)` is called ONLY when `--insecure` is active (inside `resolve_verify`), not unconditionally at module load.

### X. Tests

X1. `tests/test_amapi_crawler.py` test count is **106 passed** (97 baseline + 9 new from BUGFIX-02 + 5 new from BUGFIX-01 = wait, math check: 92 baseline before BUGFIX-01, 97 after BUGFIX-01 adds 5, 106 after BUGFIX-02 adds 9). Confirm via `python -m pytest tests/test_amapi_crawler.py --collect-only -q | grep -c "::"`. Expected: 106.

X2. BUGFIX-01's 5 new tests exist with these class/method names:
- `TestImporterSourceLabeling::test_discovered_links_not_labeled_pre_existing`
- `TestImporterSourceLabeling::test_pre_existing_fetched_not_demoted_by_link_discovery`
- `TestRobotsCheck::test_disallowed_url_marked_out_of_scope`
- `TestRobotsCheck::test_allowed_url_returns_true`
- `TestRobotsCheck::test_none_parser_always_allows`

X3. BUGFIX-02's 9 new tests exist with these class/method names:
- `TestResolveVerify::test_insecure_flag_returns_false`
- `TestResolveVerify::test_insecure_wins_over_ca_bundle`
- `TestResolveVerify::test_ca_bundle_flag_returns_path`
- `TestResolveVerify::test_ca_bundle_missing_file_exits`
- `TestResolveVerify::test_project_pem_fallback`
- `TestResolveVerify::test_certifi_default_fallback`
- `TestFetchVerifyParameter::test_verify_true_passed_through`
- `TestFetchVerifyParameter::test_verify_path_passed_through`
- `TestFetchVerifyParameter::test_verify_false_passed_through`

X4. Full test suite passes: `python -m pytest tests/test_amapi_crawler.py -v` reports 106 passed, 0 failed.

### D. Database Post-Migration State

D1. `sqlite3 assets/air_manager_api/crawl.sqlite3` is readable.

D2. Query: count URLs by (source, status) — report the table. Expected pattern approximately:
```
pre-existing|fetched:       54  (the 54 on-disk HTML files)
seed|fetched:              <N>  (seed URLs successfully fetched in smoke tests)
seed|pending:             <M>   (seed URLs still queued)
discovered|fetched:       <N2>  (links discovered and fetched)
discovered|pending:       <M2>  (links discovered and queued)
discovered|out-of-scope: ~239   (external/special/file pages discovered)
seed|out-of-scope:        ~63   (seed URLs that were File:/Special:)
```
No `source='pre-existing'` rows with `local_path IS NULL` (verified in S6 above).

D3. Query: count rows in `crawl_runs`. Expected: ≥ 5 rows (one per smoke test + migration + initial import). Confirm `notes` column shows the migration run and the smoke-test runs.

### N. Negative Checks

N1. No files in `assets/air_manager_api/wiki.siminnovations.com/` were modified or deleted by the bugfix tasks. Verify via `git status` — no changes to the mirror directory.

N2. `assets/instrument-samples/` is untouched (this bugfix doesn't relate to Stream B; this is defensive spot-check).

N3. `scripts/amapi_crawler_lib/__init__.py` is still empty (no accidental code leaks into the package marker).

---

## Output

Write the compliance report to `docs/tasks/amapi_crawler_bugfix_combined_compliance.md` with this structure:

```markdown
---
Created: <ISO 8601 UTC>
Source: docs/tasks/amapi_crawler_bugfix_combined_compliance_prompt.md
---

# AMAPI-CRAWLER-BUGFIX-COMBINED Compliance Report

**Verified:** [timestamp]
**Verdict:** [ALL PASS / PASS WITH NOTES / FAILURES FOUND]

## Summary
- Total checks: [N]
- Passed: [N]
- Failed: [N]
- Partial: [N]

## Results

### S. BUGFIX-01 — Source Labeling Fix
S1. [PASS/FAIL/PARTIAL] — [evidence]
...

### R. BUGFIX-01 — robots.txt Check
...

### P. BUGFIX-01 — Phase E.5 Progress Reporting
...

### M. BUGFIX-01 — Mirror File Reconciliation
...

### F. BUGFIX-02 — PEM File Placement
...

### T. BUGFIX-02 — TLS Configuration Flags
...

### X. Tests
...

### D. Database Post-Migration State
...

### N. Negative Checks
...

## Notes

[Observations, minor deviations, or recommendations that don't rise to FAIL level but are worth documenting.]
```

---

## Completion Protocol

1. Write compliance report to `docs/tasks/amapi_crawler_bugfix_combined_compliance.md`

2. `git add -A`

3. Commit using the D-04 trailer format via a message file. **Per D-04 Turn-37 mechanics: write message via `[System.IO.File]::WriteAllText` with `Join-Path $PWD "..."` absolute path. Do NOT use multi-`-m` (PowerShell swallows empty `-m ""`).** Use bash equivalent on CC's shell — for CC, just write a temp file and `git commit -F <file>`, CC's shell doesn't have PowerShell's quirks.
   
   Message structure (subject + blank line + trailer block):
   ```
   AMAPI-CRAWLER-BUGFIX-COMBINED-COMPLIANCE: verification report for BUGFIX-01 + BUGFIX-02

   Task-Id: AMAPI-CRAWLER-BUGFIX-COMBINED-COMPLIANCE
   Authored-By-Instance: cc
   Refs: D-04, AMAPI-CRAWLER-BUGFIX-01, AMAPI-CRAWLER-BUGFIX-02
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

4. Send completion notification:
   ```
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "AMAPI-CRAWLER-BUGFIX-COMBINED-COMPLIANCE completed [flight-sim]"
   ```

**Do NOT git push.** Steve pushes manually.
