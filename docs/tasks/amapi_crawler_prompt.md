# CC Task Prompt: AMAPI Wiki Crawler

**Location:** `docs/tasks/amapi_crawler_prompt.md`
**Task ID:** AMAPI-CRAWLER-01
**Spec:** N/A — this task has no standalone spec. Authoritative guidance lives in two decision records and the implementation plan; see Source of truth below.
**Depends on:** None
**Priority:** Stream A Wave 1 (first of three parallel Wave-1 tasks under `docs/specs/GNC355_Prep_Implementation_Plan_V1.md`)
**Estimated scope:** Large — 45–60 min script development; 2–4 hours wall-clock fetch (background); 30 min verification
**Task type:** code
**Source of truth:**
- `docs/decisions/D-03-amapi-crawler-db-schema.md` (DB schema, normalization rules, pre-existing mirror reconstruction)
- `docs/decisions/D-02-gnc355-prep-scoping.md` (scoping context — especially §Stream A)
- `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` §4 Stream A (A1 section)
**Supporting assets:**
- `assets/air_manager_api/air_manager_wiki_urls.txt` — seed URLs (386 lines, 238 unique)
- `assets/air_manager_api/user-agent.txt` — exact user agent string to send
- `assets/air_manager_api/wiki.siminnovations.com/` — pre-existing mirror of ~75 fetched HTML pages
**Audit level:** cross-instance — rationale: code task with external network I/O, file-system writes to a shared assets directory, and a new DB schema being populated for the first time. Worth a separate CD instance audit of the prompt before launch.

---

## Pre-flight Verification

**Execute these checks before writing any code. If any check fails, STOP and write a deviation report.**

1. Verify source-of-truth docs exist and are readable:
   - `ls docs/decisions/D-03-amapi-crawler-db-schema.md`
   - `ls docs/decisions/D-02-gnc355-prep-scoping.md`
   - `ls docs/specs/GNC355_Prep_Implementation_Plan_V1.md`
2. Verify supporting assets exist:
   - `ls assets/air_manager_api/air_manager_wiki_urls.txt`
   - `ls assets/air_manager_api/user-agent.txt`
   - `ls -d assets/air_manager_api/wiki.siminnovations.com/`
3. Verify no `crawl.sqlite3` already exists at `assets/air_manager_api/crawl.sqlite3` (fresh-run expectation for the first invocation). If it exists, this is not automatically a failure — the crawler is designed to be idempotent and resumable — but note the existence in the deviation report so CD can decide whether to archive or continue.
4. Verify Python 3 is available and `pip install --break-system-packages` works for package installation.
5. Verify no blocking issues: read `docs/todos/issue_index.md` if it exists — confirm no unresolved CRITICAL/HIGH items reference this task or Stream A. If the file does not exist (early project state), continue.
6. Verify test baseline: project does not yet have a pytest suite (`TBD` in CLAUDE.md). For this task, the test baseline is "no existing tests"; the task will ADD tests. Document the baseline test count as 0 if no `tests/` files exist.

**If any check fails:** Write `docs/tasks/amapi_crawler_prompt_deviation.md` with this structure:

```
# AMAPI-CRAWLER-01 Pre-flight Deviation Report

**Date:** [timestamp]
**Prompt:** `docs/tasks/amapi_crawler_prompt.md`

## Deviations Found

### 1. {Check that failed}
**Expected:** {what was expected}
**Found:** {what was actually found}
**Impact:** {can the task proceed with modifications, or must it wait?}

## Recommendation
{PROCEED WITH MODIFICATIONS / BLOCKED — explain}
```

Then `git add docs/tasks/amapi_crawler_prompt_deviation.md && git commit -m "AMAPI-CRAWLER-01: pre-flight deviation report"`. **Do not proceed with implementation until CD reviews the deviation report.**

---

## Phase 0: Source-of-Truth Audit

Before any implementation work:

1. Read all three source-of-truth documents listed in the prompt header, plus both supporting decision records.

**Definition — Actionable requirement:** A statement that, if not implemented, would make the task incomplete. Includes: behavioral requirements, data model constraints, integration contracts, error handling specifications. Excludes: background/rationale, rejected alternatives, future considerations, cross-references, informational notes.

2. For each document, extract all actionable requirements relevant to Stream A1 (the crawler task). Pay special attention to:
   - D-03 §Schema (tables `urls`, `edges`, `crawl_runs` with exact columns, types, constraints, indexes)
   - D-03 §URL Normalization (6 normalization rules)
   - D-03 §Pre-existing Mirror Reconstruction (import process, edges parsing)
   - D-02 §Stream A items 2, 3, 4 (crawl discovery, fetch politeness, YouTube handling)
   - Implementation Plan §4.5 (title-pattern whitelist)
3. Cross-reference each requirement against this prompt's implementation phases (below).
4. If ALL requirements are covered: print "Phase 0: all source requirements covered" and proceed.
5. If uncovered requirements are found:
   a. Write `docs/tasks/amapi_crawler_prompt_phase0_deviation.md` listing each uncovered requirement with source doc + section + why it's not covered in the current prompt
   b. `git add` and `git commit -m "AMAPI-CRAWLER-01: Phase 0 deviation — uncovered requirements"`
   c. Send notification (see Completion Protocol)
   d. Print: "Phase 0 BLOCKED — uncovered requirements found. Awaiting continuation file before proceeding."
   e. STOP — do not proceed until CD produces a continuation file at `docs/tasks/amapi_crawler_prompt_phase0_continue.md`.

---

## Instructions

Build a resumable, polite web crawler for the Air Manager wiki at `https://wiki.siminnovations.com/`. The crawler maintains its state in a SQLite database, fetches new HTML pages, parses them for outbound links, queues newly-discovered URLs that match the API-page whitelist, and stops cleanly on frontier exhaustion, wall-clock limit, or manual interruption.

**Also read `CLAUDE.md`** for project conventions, safety rules, test requirements, and git/ntfy protocol. **Also read `cc_safety_discipline.md`** at the project root for the full safety discipline — especially the reversibility rules and audit trail requirements. **Also read `claude-conventions.md`** at the project root for PowerShell conventions (Python in `.py` files, `curl.exe` not `curl`, etc.) and Filesystem MCP patterns.

---

## Integration Context

- **Platform:** Windows; PowerShell. Path separators are backslashes when invoking shell commands; Python code uses forward slashes or `pathlib`.
- **Python environment:** System Python 3 with `pip install --break-system-packages` per project convention. Required packages: `requests`, `beautifulsoup4`, `lxml` (for speed). Install with `pip install --break-system-packages requests beautifulsoup4 lxml`.
- **Network:** Single-threaded fetch with ≥1 second delay between requests. This is non-negotiable — politeness is a core requirement.
- **User agent:** Exact string from `assets/air_manager_api/user-agent.txt`. Do not modify or substitute.
- **Pre-existing mirror:** `assets/air_manager_api/wiki.siminnovations.com/` contains ~75 HTML files fetched by a prior wget run. Filenames follow `index.php@title=Foo_bar` convention (wget's `--restrict-file-names=windows` maps `?` to `@`). DO NOT modify, delete, or overwrite any file in this directory except to add new fetches.
- **Existing `wget-log` and `wget.txt`:** Legacy files from manual download. Leave them alone.
- **Key files this task creates or modifies:**
  - NEW: `scripts/amapi_crawler.py` — main crawler script
  - NEW: `scripts/amapi_crawler_lib/` — helper modules (see Phase A)
  - NEW: `assets/air_manager_api/crawl.sqlite3` — tracking DB (gitignored per D-03)
  - MODIFIED (append-only): `assets/air_manager_api/crawl_log.txt` — human-readable events
  - NEW: `assets/air_manager_api/crawl_complete.md` — completion summary (written when crawl finishes)
  - NEW (adds files only): `assets/air_manager_api/wiki.siminnovations.com/index.php@title=*` — newly-fetched HTML pages
  - NEW: `tests/test_amapi_crawler.py` — unit tests for the crawler's pure-function components
- **File provenance:** Files under `scripts/` do NOT get provenance headers per project convention (`git blame` covers them). Files under `assets/` do not get provenance headers either. The only doc this task writes under `docs/` is the completion report, which must include a provenance header.

---

## Implementation Order

**Execute phases sequentially in the order specified. Do NOT parallelize phases or launch subagents** — phase ordering reflects real dependencies.

Run tests after Phase E (the tests phase) and do not proceed to Phase F if tests fail.

### Phase A: Module structure

Create `scripts/amapi_crawler_lib/` with these modules:

1. `scripts/amapi_crawler_lib/__init__.py` (empty)
2. `scripts/amapi_crawler_lib/normalize.py` — URL normalization (6 rules from D-03 §URL Normalization)
3. `scripts/amapi_crawler_lib/categorize.py` — title-prefix bucket derivation (per Implementation Plan §4.5 whitelist)
4. `scripts/amapi_crawler_lib/filename.py` — bidirectional mapping between canonical URL and local filename (`index.php@title=Foo_bar` convention)
5. `scripts/amapi_crawler_lib/db.py` — schema creation, connection helpers, upsert helpers
6. `scripts/amapi_crawler_lib/parse.py` — HTML parsing for outbound links (BeautifulSoup); returns a list of `(raw_url, anchor_text)` tuples
7. `scripts/amapi_crawler_lib/fetch.py` — single HTTP fetch with correct user agent and politeness delay
8. `scripts/amapi_crawler_lib/importer.py` — pre-existing mirror import logic

The main script `scripts/amapi_crawler.py` orchestrates but contains no business logic that would be worth unit-testing independently.

### Phase B: Database initialization

In `scripts/amapi_crawler_lib/db.py`:

1. `connect(db_path: str) -> sqlite3.Connection` — opens with `row_factory = sqlite3.Row`, `PRAGMA foreign_keys = ON`, `PRAGMA journal_mode = WAL`
2. `ensure_schema(conn)` — creates the three tables and five indexes exactly as specified in D-03 §Schema. If tables already exist, verify their schema matches expected (`PRAGMA table_info`) and raise a clear error on mismatch — do not silently migrate.
3. `start_crawl_run(conn, notes: str = '') -> int` — inserts a `crawl_runs` row with `started_at=now`, returns the `run_id`
4. `end_crawl_run(conn, run_id: int, notes: str = '')` — sets `ended_at=now`; appends `notes` to any existing notes
5. `upsert_url(conn, *, url: str, url_raw: str, title: str, category: str, source: str, status: str = 'pending', run_id: int) -> tuple[int, bool]` — upserts a row by canonical `url`; returns `(url_id, was_inserted)`. On conflict, existing row is preserved (no source demotion); only `first_seen_run_id` is populated if currently NULL.
6. `record_fetch_success(conn, *, url_id: int, fetched_at: str, http_status: int, content_bytes: int, content_sha256: str, local_path: str, run_id: int)` — updates the URL to `status='fetched'` with all fetch metadata; sets `last_fetched_run_id`; resets `attempts=0` and `last_error=NULL`, `next_retry_at=NULL`
7. `record_fetch_failure(conn, *, url_id: int, error: str, now: str)` — increments `attempts`, sets `last_error`, sets `next_retry_at` based on backoff schedule (60s for attempt 1, 5 min for attempt 2, 30 min for attempt 3). After `attempts >= 3`, set `status='failed'`.
8. `upsert_edge(conn, *, from_url_id: int, to_url_id: int, anchor_text: str)` — upserts an edge row
9. `next_pending_url(conn, now: str) -> sqlite3.Row | None` — returns the next URL to fetch (`status='pending'` AND (`next_retry_at IS NULL OR next_retry_at <= now`)), ordered by `url_id` (FIFO within priority). Returns None if none.

### Phase C: URL normalization and categorization

In `scripts/amapi_crawler_lib/normalize.py`, implement `normalize(url: str) -> str | None`:

Rules per D-03 §URL Normalization:
1. Strip fragment (`#foo`)
2. Strip `action=` and `oldid=` query parameters (remove just those keys; preserve others like `title`)
3. Rewrite `/index.php/Foo` → `/index.php?title=Foo` (path-style → query-string)
4. URL-decode the `title` parameter once (single pass; do not double-decode); re-encode with a minimal safe set for the canonical form (keep `:` as `:` to match mirror file behavior — examine existing mirror filenames to confirm)
5. Drop `Special:` titled pages: return None so the caller can mark `status='out-of-scope'` and skip
6. Lowercase scheme and host; preserve the `title` value's case

Also implement:
- `is_wiki_url(url: str) -> bool` — True if host is `wiki.siminnovations.com`
- `title_from_url(url: str) -> str | None` — extracts the `title` query param (URL-decoded once)

In `scripts/amapi_crawler_lib/categorize.py`, implement `categorize(title: str | None, url: str) -> str`:

Whitelist of API-page prefixes (Plan §4.5):
```
API_PREFIXES = {
    'Xpl', 'Fsx', 'P3d', 'Msfs', 'Fs2020', 'Fs2024',
    'Hw', 'Si', 'Ext',
    'Viewport', 'Canvas', 'Scene', 'Img', 'Txt', 'Fi', 'Video',
    'Mouse', 'Touch', 'Slider', 'Scrollwheel',
    'Rotate', 'Move', 'Visible', 'Opacity', 'Z',
    'Variable', 'Var', 'Request', 'Persist', 'Timer', 'Switch', 'Group',
    'Sound', 'Nav', 'Map', 'Instrument', 'Device', 'User',
}
NON_API_TITLES = {  # Known useful non-API pages — fetch but do not categorize as API
    'API', 'Instrument_Creation_Tutorial', 'Device_list',
    'Hardware_id_list', 'I/O_Connection_examples',
}
```

Categorization logic:
- If URL is not on `wiki.siminnovations.com` and host is `youtube.com` → `'youtube'`
- If URL is not on `wiki.siminnovations.com` → `'external'`
- If title is None → `'wiki-other'`
- If title starts with `Special:` → `'special'` (caller treats as out-of-scope)
- If title is in `NON_API_TITLES` → `'non-api-useful'`
- If title starts with `File:` → `'file'` (caller treats as out-of-scope for now)
- If title's first underscore-separated token is in `API_PREFIXES` → return that prefix (e.g., `'Xpl'`, `'Msfs'`, `'Hw'`)
- Otherwise → `'wiki-other'`

`should_queue(category: str) -> bool`: returns True only for categories in `API_PREFIXES` plus `'non-api-useful'`. Everything else gets `status='out-of-scope'` in the DB.

### Phase D: Pre-existing mirror import

In `scripts/amapi_crawler_lib/importer.py`:

1. `import_mirror(conn, mirror_dir: str, run_id: int) -> dict` — main entry. Returns counts dict `{imported, edges_created, parse_failures}`.
2. Iterate every file in `mirror_dir` whose name starts with `index.php@title=`:
   - Skip any `.DS_Store`, images, or non-HTML files
   - Reconstruct the canonical URL from the filename (inverse of the filename module's forward mapping)
   - Read the file; compute `content_sha256`, `content_bytes` (file size), `fetched_at` (file mtime as ISO 8601 local tz or UTC — pick one and be consistent; recommend UTC for DB storage)
   - Categorize the URL
   - `upsert_url` with `source='pre-existing'`, `status='fetched'`, metadata populated, `first_seen_run_id=run_id`, `last_fetched_run_id=run_id`, `local_path` relative to project root
   - Parse the file for outbound links via `parse.extract_links`
   - For each outbound link: normalize, check scope, upsert the target URL (as `'pre-existing'` if it was only seen inbound-from-pre-existing; leave status `'pending'` unless it's already `'fetched'`), then upsert an edge
3. Handle the `index.html` root file specially (it's the main page, not a `?title=` URL).
4. Log to stdout and `crawl_log.txt`: one line per file imported and a summary at end.

### Phase E: Seed URL import and main fetch loop

In `scripts/amapi_crawler.py`:

1. Argument parsing (use `argparse`):
   - `--db` (default `assets/air_manager_api/crawl.sqlite3`)
   - `--mirror` (default `assets/air_manager_api/wiki.siminnovations.com`)
   - `--seeds` (default `assets/air_manager_api/air_manager_wiki_urls.txt`)
   - `--user-agent-file` (default `assets/air_manager_api/user-agent.txt`)
   - `--log` (default `assets/air_manager_api/crawl_log.txt`)
   - `--max-wall-clock-hours` (default `4.0`)
   - `--min-delay-seconds` (default `1.0`)
   - `--import-only` flag (run the pre-existing mirror import and seed import, then exit without fetching)
   - `--dry-run` flag (show what would be fetched; no actual HTTP requests)
   - `--progress-refresh-seconds` (default `60`) — controls live progress line refresh cadence; set to `0` to disable
2. Main flow:
   a. Open DB, `ensure_schema`
   b. If any `--import-only`-style signal or if this is the first run (no crawl_runs rows), run `import_mirror`
   c. Start a new `crawl_runs` row (`notes='seed import and fetch loop'`)
   d. Read seed URLs from `--seeds` file; normalize; categorize; upsert with `source='seed'`, `status='pending'` if category `should_queue`, else `'out-of-scope'`. If an upsert targets a URL already `status='fetched'` or `source='pre-existing'`, keep the existing source/status.
   e. Commit the seed import; log summary
   f. If `--dry-run`: print pending-URL count by category and exit
   g. Fetch loop:
      - Record `start_time = now()`
      - Loop:
        * Check wall-clock: if `(now - start_time) > max_wall_clock_hours`, break with stop reason `'wall-clock limit'`
        * Fetch next pending URL via `next_pending_url`. If None, break with stop reason `'frontier empty'`
        * Sleep `max(0, min_delay_seconds - (now - last_fetch_at))` seconds
        * Call `fetch.fetch_page(url, user_agent)` — returns `(status_code, body_bytes)` or raises
        * On 2xx:
          - Write body to disk at the reconstructed filename in `mirror_dir`; atomic write (write to `.tmp` then rename)
          - Compute sha256, byte length
          - `record_fetch_success`
          - Parse body for outbound links; for each: normalize, categorize, upsert target, upsert edge
          - Commit
          - Log: `FETCHED <url> (<bytes> bytes, <N> new links discovered)`
        * On 3xx: log redirect; do not follow automatically — treat as content, record success with the redirect target as an edge, then upsert the redirect target
          - NOTE: `requests` with `allow_redirects=True` (default) handles this transparently; we record the final URL. If the final URL differs from the requested URL, upsert both and create an edge.
        * On 4xx/5xx or network error: `record_fetch_failure`
        * Commit per URL (each iteration is its own transaction)
   h. `end_crawl_run` with stop reason in notes
   i. Write `crawl_complete.md` with summary:
      - URL counts by `source` and `status`
      - Total bytes downloaded this run
      - Discovered URL count (new during this run)
      - Failed URL count
      - Top 10 categories by URL count
      - Wall-clock duration
      - Stop reason
3. Error handling:
   - Catch `KeyboardInterrupt`: end the current crawl_run cleanly with `notes='interrupted by user'`, print summary, exit 0
   - Catch any other exception: log the exception to `crawl_log.txt`, attempt to end the crawl_run with `notes='crashed: <exception>'`, re-raise

### Phase E.5: Live progress reporting

Add a single-line, carriage-return-refreshed progress display to the fetch loop. Does NOT use newlines — the line rewrites itself in place.

**Requirements:**

1. Refresh cadence: every `--progress-refresh-seconds` seconds (default 60). Set to `0` to disable.
2. Output channel: `sys.stderr.write('\r' + line)` followed by `sys.stderr.flush()`. Using stderr so it doesn't pollute stdout (which may be redirected to a log file). The `\r` (carriage return, no newline) makes the terminal rewrite the same line.
3. Display format (one line, no line wrap — keep under ~180 chars):
   ```
   [HH:MM:SS elapsed] fetched: <N> new / <M> total  |  HTTP: 200=<a> 301=<b> 404=<c> 5xx=<d> err=<e>  |  queue: <P> pending  |  discovered: <D> new  |  rate: <R>/min
   ```
   - `<N> new` = URLs fetched during THIS crawl_run
   - `<M> total` = URLs with `status='fetched'` across all runs (includes pre-existing)
   - HTTP counters: current totals BY http_status for URLs fetched this run only. Group 5xx into a single `5xx` bucket; group all network-level errors (timeouts, DNS, connection refused, etc.) into `err`. List every distinct status code observed this run in ascending order, plus `5xx` and `err` if non-zero.
   - `<P> pending` = `SELECT COUNT(*) FROM urls WHERE status='pending'`
   - `<D> new` = URLs with `first_seen_run_id = current_run_id` and `source='discovered'` (i.e., discovered during this run)
   - `<R>/min` = fetches-this-run ÷ elapsed-minutes (rounded to 1 decimal)
4. Thread safety: the fetch loop is single-threaded, so no concurrency concerns. But the progress refresh should be driven by a simple time check inside the main loop, not a background thread — simpler, no thread coordination needed.
5. Print a final line with `\n` (newline-terminated) when the fetch loop exits, so the next log output starts cleanly on its own line. The final line uses the same format but includes the stop reason in a trailing suffix: `| STOPPED: <reason>`.
6. HTTP status counters are derived from the DB each refresh — no in-memory duplicate state to keep in sync. One query:
   ```sql
   SELECT http_status, COUNT(*) FROM urls
   WHERE last_fetched_run_id = ?
   GROUP BY http_status
   ```
   Network-level errors don't have an `http_status`; count them separately via `COUNT(*) WHERE last_error IS NOT NULL AND last_fetched_run_id = ?` — actually, simpler: track a small in-memory counter `self.error_count_this_run` incremented in the failure handler, since `record_fetch_failure` is the one place that handles network errors without an HTTP status.
7. If `--progress-refresh-seconds=0`, skip the progress display entirely; only print the per-URL log lines that already go to `crawl_log.txt`.
8. The `crawl_log.txt` append-only log is unaffected by this feature — it keeps its per-event lines. Progress display is stderr-only and stateless.

**Example rendered line:**
```
[0:47:12 elapsed] fetched: 142 new / 217 total  |  HTTP: 200=138 301=2 404=2 err=0  |  queue: 61 pending  |  discovered: 18 new  |  rate: 3.0/min
```

**Test:** No unit test required for the progress display (I/O-bound, time-dependent, not worth mocking). Smoke-test Phase G verifies it renders without errors.

### Phase F: Tests

Create `tests/test_amapi_crawler.py`. Tests cover the **pure-function components only** (no network, no disk I/O beyond temp files). Do NOT test the fetch loop end-to-end — that requires network mocking which is overkill for a one-off crawler.

Required test coverage:

1. **Normalization (test class per rule):**
   - Fragment stripping
   - `action=` and `oldid=` removal; other query params preserved
   - Path-style → query-string rewrite
   - Title URL-decoding (`File%3AFoo.png` ↔ `File:Foo.png`)
   - Scheme/host lowercasing
   - `Special:` returns None
   - Idempotency: `normalize(normalize(url)) == normalize(url)` for a sample of representative URLs

2. **Categorization:**
   - Each API prefix in `API_PREFIXES` returns the expected category
   - `NON_API_TITLES` entries return `'non-api-useful'`
   - `Special:` returns `'special'`
   - `File:` returns `'file'`
   - External URLs return `'external'` or `'youtube'`
   - `should_queue` returns True for API prefixes and `'non-api-useful'`; False for everything else

3. **Filename mapping:**
   - `url_to_filename('https://wiki.siminnovations.com/index.php?title=Xpl_command') == 'index.php@title=Xpl_command'`
   - Roundtrip: `url_to_filename(filename_to_url(f)) == f` for a sample of existing mirror filenames
   - Handles `File:Foo.png` (colon encoding) consistently with the existing mirror

4. **DB schema:**
   - `ensure_schema` creates all three tables with the expected columns (use `PRAGMA table_info`)
   - All five indexes exist after schema creation
   - Running `ensure_schema` twice is a no-op; second call does not error

5. **Upsert behavior:**
   - `upsert_url` inserts a new URL correctly
   - Second upsert of the same URL does not create a duplicate; returns `was_inserted=False`
   - Source priority: a URL with `source='pre-existing'` and `status='fetched'` is not demoted by a later upsert with `source='seed'`, `status='pending'`

6. **Backoff schedule:**
   - After 1 failure: `attempts=1`, `next_retry_at` is 60s from now, `status='pending'`
   - After 2 failures: `attempts=2`, `next_retry_at` is 5 min from now, `status='pending'`
   - After 3 failures: `attempts=3`, `status='failed'`

Test command: `python -m pytest tests/test_amapi_crawler.py -v`

Install pytest first if needed: `pip install --break-system-packages pytest`.

Aim for clean runs with all tests passing. Mock `datetime.now()` where needed for deterministic timestamps.

### Phase G: Smoke-test run (import + small fetch)

1. Run the crawler in `--import-only` mode first:
   ```
   python scripts/amapi_crawler.py --import-only
   ```
   Verify `crawl.sqlite3` is created with pre-existing rows populated. Print a quick summary via a throwaway SQL query (e.g., `SELECT source, status, COUNT(*) FROM urls GROUP BY source, status`).

2. Run the crawler in `--dry-run` mode:
   ```
   python scripts/amapi_crawler.py --dry-run
   ```
   Verify the pending URL count matches expectations (roughly: total unique URLs in seed file MINUS URLs already fetched from the mirror).

3. **Do NOT run the full fetch as part of this task.** The full fetch is a long background operation that Steve will launch manually once CD reviews the smoke-test results. The task completes at the smoke-test milestone.

---

## Completion Protocol

1. Run full test suite for this task: `python -m pytest tests/test_amapi_crawler.py -v`
2. Record final test count and pass/fail status
3. Capture smoke-test output (import-only summary + dry-run summary) into the completion report
4. Write completion report to `docs/tasks/amapi_crawler_completion.md` with:
   - Provenance header (Created, Source=this prompt path)
   - Summary of what was built (module list with line counts)
   - Test results (count, pass/fail)
   - Smoke-test results: rows imported from pre-existing mirror, edges created, pending-URL count by category
   - Any deviations from this prompt with rationale
   - Recommendation for Steve: "ready to launch full fetch" OR "blocking issue found"
5. `git add -A`
6. `git commit -m "AMAPI-CRAWLER-01: implement AMAPI wiki crawler with tracking DB [refs: D-03, GNC355_Prep_Implementation_Plan_V1]"`
7. **Flag refresh check:** This task does not modify `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`. Do NOT create refresh flags.
8. Send completion notification:
   ```
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "AMAPI-CRAWLER-01 completed [flight-sim]"
   ```

**Do NOT git push.** Steve pushes manually.
