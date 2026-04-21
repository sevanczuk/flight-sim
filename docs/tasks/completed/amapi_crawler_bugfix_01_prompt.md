# CC Task Prompt: AMAPI Crawler Bug Fixes + Verification

**Location:** `docs/tasks/amapi_crawler_bugfix_01_prompt.md`
**Task ID:** AMAPI-CRAWLER-BUGFIX-01
**Parent task:** AMAPI-CRAWLER-01 (completed 2026-04-20 — see `docs/tasks/amapi_crawler_completion.md`)
**Depends on:** AMAPI-CRAWLER-01 (must be complete; this task modifies its output)
**Priority:** Blocks full fetch launch; required before proceeding to AMAPI-CRAWLER-01 full-run phase
**Estimated scope:** Small — 30–45 min; 5 targeted fixes + 1 verification item
**Task type:** code
**Source of truth:**
- `docs/decisions/D-03-amapi-crawler-db-schema.md` (schema semantics — especially `source` column meaning)
- `docs/tasks/amapi_crawler_prompt.md` (original task prompt — see Phase D importer logic and Phase E.5 progress reporting)
- `docs/tasks/amapi_crawler_completion.md` (completion report being remediated)
**Supporting assets:**
- `assets/air_manager_api/crawl.sqlite3` — existing DB from AMAPI-CRAWLER-01 smoke test
- `assets/air_manager_api/wiki.siminnovations.com/` — HTML mirror (unchanged)
- `assets/air_manager_api/air_manager_wiki_urls.txt` — seed URLs list
- `scripts/amapi_crawler.py` + `scripts/amapi_crawler_lib/` — existing code
- `tests/test_amapi_crawler.py` — existing tests
**Audit level:** self-check only — rationale: targeted fixes to already-reviewed code, no new architecture. Low risk.

---

## Pre-flight Verification

**Execute these checks before writing any code. If any check fails, STOP and write a deviation report.**

1. Verify parent task artifacts exist:
   - `ls docs/tasks/amapi_crawler_prompt.md`
   - `ls docs/tasks/amapi_crawler_completion.md`
   - `ls scripts/amapi_crawler.py`
   - `ls -d scripts/amapi_crawler_lib/`
   - `ls tests/test_amapi_crawler.py`
   - `ls assets/air_manager_api/crawl.sqlite3`
2. Verify D-03 decision record exists: `ls docs/decisions/D-03-amapi-crawler-db-schema.md`
3. Verify test baseline: `python -m pytest tests/test_amapi_crawler.py -v` — expect 92 passed (per completion report). Record actual count.
4. Capture current DB state for before/after comparison:
   ```
   sqlite3 assets/air_manager_api/crawl.sqlite3 "SELECT source, status, COUNT(*) FROM urls GROUP BY source, status ORDER BY source, status"
   ```
   Save output to `docs/tasks/amapi_crawler_bugfix_01_db_before.txt` (temporary file; delete at end of task).

**If any check fails:** Write `docs/tasks/amapi_crawler_bugfix_01_prompt_deviation.md` and STOP.

---

## Phase 0: Source-of-Truth Audit

Read the three source-of-truth documents listed above. Extract actionable requirements for each of the six items below. Cross-reference against the Implementation Phases. If any source requirement is uncovered, write `docs/tasks/amapi_crawler_bugfix_01_prompt_phase0_deviation.md` and STOP.

---

## Instructions

Six items. Items 1–3 are code fixes; items 4–5 are verification; item 6 is a documentation fix. Execute in the order below.

**Also read `CLAUDE.md`** for conventions. **Also read `cc_safety_discipline.md`** — especially that `assets/air_manager_api/wiki.siminnovations.com/` originals are never modified. **Also read `claude-conventions.md`**.

---

## Integration Context

- **Platform:** Windows PowerShell. Python in `.py` files only.
- **Python environment:** Existing install from parent task. No new dependencies expected. If `urllib.robotparser` is needed for Item 2, it's standard library.
- **Key files this task modifies:**
  - MODIFIED: `scripts/amapi_crawler_lib/importer.py` — source-labeling fix (Item 1)
  - MODIFIED: `scripts/amapi_crawler.py` — robots.txt check (Item 2); possibly Phase E.5 progress reporting (Item 3, if not already present)
  - POSSIBLY MODIFIED: `scripts/amapi_crawler_lib/fetch.py` — progress reporting may live here (Item 3)
  - MODIFIED: `tests/test_amapi_crawler.py` — additional tests for fixes
  - NEW: `scripts/amapi_crawler_migrate_source.py` — one-shot DB migration script (Item 1)
  - MODIFIED: `assets/air_manager_api/crawl.sqlite3` — migration applied (Item 1)
  - MODIFIED: `docs/tasks/amapi_crawler_completion.md` — edge count phrasing fix (Item 6)
  - NEW: `docs/tasks/amapi_crawler_bugfix_01_completion.md` — this task's completion report

---

## Implementation Order

**Execute phases sequentially.**

### Phase A — Item 1: Fix source labeling semantics (importer)

**Problem:** In the parent task's smoke-test output, 475 URLs are marked `source='pre-existing'` despite having no HTML file on disk. They were discovered via parsing outbound links in the 54 real pre-existing HTML files. Per D-03, `source='pre-existing'` means "inferred from on-disk mirror" — i.e., the URL's own HTML file is in `assets/air_manager_api/wiki.siminnovations.com/`. URLs merely linked-to from those files are NOT pre-existing; they are either `'seed'` (if listed in the seed URL file) or `'discovered'` (if not).

**Fix, two parts:**

1. **Correct the importer logic going forward** (in `scripts/amapi_crawler_lib/importer.py`):
   - The first pass inserts rows for each HTML file on disk with `source='pre-existing'` — that stays.
   - The second pass parses each pre-existing HTML file for outbound links. For each discovered link URL:
     - If the normalized URL is in the seed URL set → upsert with `source='seed'`
     - Otherwise → upsert with `source='discovered'`
     - NEVER use `source='pre-existing'` for URLs discovered via link parsing — that label is reserved for URLs whose HTML file is physically on disk.
   - The seed URL set should be loaded once at the start of `import_mirror` (read `assets/air_manager_api/air_manager_wiki_urls.txt`, normalize each URL, build a Python `set`). Pass the set to the link-parsing loop.
   - For the upsert-source-priority rule in D-03: if an existing row has `source='pre-existing'` and `status='fetched'`, it must NOT be demoted to `'seed'` or `'discovered'` just because a pre-existing file links to it. Verify the upsert logic already handles this; add a test if not.

2. **Author a one-shot DB migration** at `scripts/amapi_crawler_migrate_source.py`:
   - Loads the same seed URL set
   - For every row in `urls` where `source='pre-existing'` AND `local_path IS NULL` (i.e., no file on disk):
     - If the URL is in the seed set → update `source='seed'`
     - Otherwise → update `source='discovered'`
   - Wraps the update in a single transaction
   - Prints before/after counts by source and status
   - Idempotent: running twice produces no further changes (the WHERE clause ensures this)
   - Adds a row to `crawl_runs` with `notes='source-labeling migration per AMAPI-CRAWLER-BUGFIX-01 item 1'`

**Run the migration** against the existing DB:
```
python scripts/amapi_crawler_migrate_source.py
```
Verify via SQL query that `source='pre-existing'` now appears only on rows with `local_path IS NOT NULL`. Save the post-migration state to `docs/tasks/amapi_crawler_bugfix_01_db_after.txt` (temporary, deleted at end of task).

### Phase B — Item 2: robots.txt check

In `scripts/amapi_crawler.py`, at the start of the fetch loop (before any URL is fetched):

1. Fetch `https://wiki.siminnovations.com/robots.txt` via `requests` using the same user agent as the crawler.
2. Parse with `urllib.robotparser.RobotFileParser`.
3. Log the result to `crawl_log.txt`:
   - If 404 or empty: `"robots.txt: not found — no restrictions apply"`
   - If loaded: `"robots.txt: loaded; <N> rules applied"`
4. For each URL before fetching, call `parser.can_fetch(user_agent_string, url)`. If False:
   - Set `status='out-of-scope'` for that URL in the DB
   - Add a `last_error` of `"robots.txt: disallowed"`
   - Log to `crawl_log.txt`: `SKIPPED (robots.txt) <url>`
   - Do NOT fetch
5. Failure to reach robots.txt (network error, not 404): log a warning and proceed WITHOUT robots restrictions — do NOT block the crawl on a transient robots.txt fetch failure.

Add one unit test in `tests/test_amapi_crawler.py`:
- Mock `RobotFileParser.can_fetch` to return False for a URL
- Verify the URL's status is set to `'out-of-scope'` and it's not fetched (use the existing fetch-loop structure with mocked HTTP)

### Phase C — Item 3: Verify or implement Phase E.5 (live progress reporting)

The parent task prompt (as updated mid-execution) included a Phase E.5 for single-line live progress reporting. The completion report does not explicitly confirm whether this was implemented.

**First, check:**
1. Read `scripts/amapi_crawler.py` and `scripts/amapi_crawler_lib/fetch.py` for any progress-display code (carriage-return writes to stderr, HTTP status counting, refresh cadence).
2. If implemented: note in the completion report that Phase E.5 was verified present. Skip to Phase D.
3. If NOT implemented: implement per the specification below.

**Phase E.5 specification** (reproduced here verbatim for self-contained execution; also in the updated parent prompt):

Add a single-line, carriage-return-refreshed progress display to the fetch loop. Does NOT use newlines — the line rewrites itself in place.

Requirements:

1. Refresh cadence: every `--progress-refresh-seconds` seconds (default 60). Set to `0` to disable.
2. Output channel: `sys.stderr.write('\r' + line)` followed by `sys.stderr.flush()`.
3. Display format (one line, no line wrap — keep under ~180 chars):
   ```
   [HH:MM:SS elapsed] fetched: <N> new / <M> total  |  HTTP: 200=<a> 301=<b> 404=<c> 5xx=<d> err=<e>  |  queue: <P> pending  |  discovered: <D> new  |  rate: <R>/min
   ```
   - `<N> new` = URLs fetched during THIS crawl_run
   - `<M> total` = URLs with `status='fetched'` across all runs
   - HTTP counters: current totals BY http_status for URLs fetched this run only. Group 5xx into a single `5xx` bucket; group network errors (timeouts, DNS, connection refused) into `err`. List every distinct status code observed this run in ascending order, plus `5xx` and `err` if non-zero.
   - `<P> pending` = `SELECT COUNT(*) FROM urls WHERE status='pending'`
   - `<D> new` = URLs with `first_seen_run_id = current_run_id` and `source='discovered'`
   - `<R>/min` = fetches-this-run ÷ elapsed-minutes (rounded to 1 decimal)
4. Drive refresh from a simple time check inside the main fetch loop, not a background thread.
5. Print a final line with `\n` (newline-terminated) when the fetch loop exits, including stop reason as trailing suffix: `| STOPPED: <reason>`.
6. HTTP status counters derived from the DB each refresh via:
   ```sql
   SELECT http_status, COUNT(*) FROM urls
   WHERE last_fetched_run_id = ?
   GROUP BY http_status
   ```
   Network-level error count: in-memory counter incremented in `record_fetch_failure` (since network errors have no http_status).
7. If `--progress-refresh-seconds=0`, skip the progress display entirely.
8. `crawl_log.txt` is unaffected — it keeps per-event lines.

Example rendered line:
```
[0:47:12 elapsed] fetched: 142 new / 217 total  |  HTTP: 200=138 301=2 404=2 err=0  |  queue: 61 pending  |  discovered: 18 new  |  rate: 3.0/min
```

Add the `--progress-refresh-seconds` flag to argparse if not already present (default `60`).

No unit test required for the progress display itself (I/O-bound, time-dependent). Verify rendering in smoke test Phase E below.

### Phase D — Run the existing test suite

```
python -m pytest tests/test_amapi_crawler.py -v
```

Expect at least the baseline count (92) plus any tests added in Phases A and B. All must pass.

### Phase E — Smoke-test the fixes

1. Dry run to verify the migration didn't break anything:
   ```
   python scripts/amapi_crawler.py --dry-run
   ```
   Check: pending count still ~173 (exact number may differ slightly after the re-labeling if any edge cases shift). Category breakdown sane.

2. Progress-display smoke test — run a very short fetch to see the progress line render. Run with a tiny wall-clock limit that will fetch only a handful of URLs:
   ```
   python scripts/amapi_crawler.py --max-wall-clock-hours 0.02
   ```
   That's ~72 seconds — enough for ~70 fetches at 1s each. Watch stderr for the progress line updating every ~60 seconds. Expected: one mid-run refresh plus the newline-terminated final line with STOPPED reason.
   
   After this smoke run: inspect the DB to confirm the fetched rows look right, then note any behavior deviations in the completion report.

3. DO NOT run the full fetch. That's still reserved for Steve to launch after reviewing this bug-fix completion.

### Phase F — Item 6: Fix completion report phrasing

Edit `docs/tasks/amapi_crawler_completion.md`:

1. In the Deviations section, item 2 currently says "1,976 edges created" vs "1,130 unique edges". Reword for clarity: `"1,130 unique edges stored (deduped from 1,976 link references via UNIQUE (from_url_id, to_url_id) constraint — the 1,976 number reflects raw parse output before dedup)."`
2. Add a short note at the top of the Deviations section: `"Post-remediation: items 1, 3 (labeling + robots.txt) addressed by AMAPI-CRAWLER-BUGFIX-01 on <date>. See docs/tasks/amapi_crawler_bugfix_01_completion.md."`

### Phase G — Item 5: Confirm 54 vs ~75 mirror file discrepancy

In the completion report for THIS task, include a section documenting why only 54 files were imported when the wiki mirror directory appears to contain ~75 entries.

1. Enumerate the mirror directory's top-level contents:
   ```
   ls assets/air_manager_api/wiki.siminnovations.com/ | wc -l
   ```
2. Categorize what was skipped by the importer:
   - `.DS_Store` (macOS metadata)
   - `api.php@action=rsd`, `opensearch_desc.php` (non-content meta-pages)
   - `load.php@...` (MediaWiki asset bundle — CSS/JS, not content)
   - `extensions/`, `images/`, `resources/`, `skins/` (directories — not files; importer correctly skips)
   - `index.html` (root page, may or may not have been imported — verify)
   - `index.php@title=*` (these are the content pages)
3. Expected: 54 content pages after filtering. If the math doesn't add up, investigate. If it does, document the categories and move on.

The goal is not to import the excluded files — it's to make the "54 vs ~75" discrepancy explicit and expected in the completion report.

---

## Completion Protocol

1. Run final test suite: `python -m pytest tests/test_amapi_crawler.py -v`. Record count and pass/fail.
2. Clean up temporary files: `rm docs/tasks/amapi_crawler_bugfix_01_db_before.txt docs/tasks/amapi_crawler_bugfix_01_db_after.txt` (incorporate their summary content into the completion report first).
3. Write completion report to `docs/tasks/amapi_crawler_bugfix_01_completion.md` with:
   - Provenance header (Created, Source=this prompt path)
   - Summary table listing each of the 6 items with status (FIXED / VERIFIED / DOCUMENTED)
   - Item 1: DB state before and after migration (source × status grouped counts for both)
   - Item 2: robots.txt fetch result from smoke test (found / not found / rule count)
   - Item 3: Phase E.5 was-it-already-there verdict, with code locations if implementing new; rendered progress-line example from smoke test
   - Item 4: final test count (baseline 92 + additions)
   - Item 5: mirror directory enumeration with per-category counts
   - Item 6: the edited wording in the parent completion report
   - Smoke-test output from Phase E
   - Any deviations from this prompt with rationale
   - Recommendation to Steve: "bug-fix complete, ready to launch full fetch" OR "issue found, requires further attention"
4. `git add -A`
5. `git commit -m "AMAPI-CRAWLER-BUGFIX-01: fix source labeling, add robots.txt check, verify Phase E.5 [refs: D-03, AMAPI-CRAWLER-01]"`
6. **Flag refresh check:** This task does not modify CLAUDE.md, claude-project-instructions.md, claude-conventions.md, cc_safety_discipline.md, or claude-memory-edits.md. Do NOT create refresh flags.
7. Send completion notification:
   ```
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "AMAPI-CRAWLER-BUGFIX-01 completed [flight-sim]"
   ```

**Do NOT git push.** Steve pushes manually.
