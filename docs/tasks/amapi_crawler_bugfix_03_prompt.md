# CC Task Prompt: AMAPI Crawler Whitelist Expansion + Redlink Handling

**Location:** `docs/tasks/amapi_crawler_bugfix_03_prompt.md`
**Task ID:** AMAPI-CRAWLER-BUGFIX-03
**Parent tasks:** AMAPI-CRAWLER-01, AMAPI-CRAWLER-BUGFIX-01, AMAPI-CRAWLER-BUGFIX-02 (all complete)
**Depends on:** All three prior tasks must be complete (they are)
**Priority:** Blocks Stream A2 (AMAPI parser) — parser needs the full API inventory
**Estimated scope:** Medium — 30–60 min development; 5–10 min backfill crawl; verification
**Task type:** code
**Source of truth:**
- `docs/decisions/D-03-amapi-crawler-db-schema.md` (schema + URL normalization rules)
- `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` §4.5 (title-pattern whitelist)
- `docs/tasks/amapi_crawler_prompt.md` (original crawler task — categorization logic)
- `docs/tasks/amapi_crawler_bugfix_01_prompt.md` + `_bugfix_02_prompt.md` (prior bugfix context)
- `assets/air_manager_api/crawl_diagnostic_turn43.txt` (diagnostic report driving this task)
**Supporting assets:**
- `assets/air_manager_api/crawl.sqlite3` — existing DB with 225 fetched URLs
- `assets/air_manager_api/wiki.siminnovations.com/index.php@title=API` — the authoritative API catalog page (to be parsed)
- `assets/air_manager_api/air_manager_wiki_urls.txt` — seed URL list (384 lines, 238 unique)
- `scripts/amapi_crawler.py` + `scripts/amapi_crawler_lib/` — existing crawler
- `tests/test_amapi_crawler.py` — existing tests (106 passing)
**Audit level:** self-check only — rationale: targeted expansion of already-reviewed code; DB changes are re-categorizations (idempotent, reversible by re-running)

---

## Pre-flight Verification

**Execute these checks before writing any code. If any check fails, STOP and write a deviation report.**

1. Verify source-of-truth docs and prior-task artifacts exist:
   - `ls docs/decisions/D-03-amapi-crawler-db-schema.md`
   - `ls docs/specs/GNC355_Prep_Implementation_Plan_V1.md`
   - `ls docs/tasks/amapi_crawler_prompt.md`
   - `ls docs/tasks/amapi_crawler_bugfix_01_prompt.md`
   - `ls docs/tasks/amapi_crawler_bugfix_02_prompt.md`
   - `ls assets/air_manager_api/crawl_diagnostic_turn43.txt`
2. Verify the AMAPI catalog page exists in the fetched mirror:
   - `ls "assets/air_manager_api/wiki.siminnovations.com/index.php@title=API"`
3. Verify existing crawler code:
   - `ls scripts/amapi_crawler.py`
   - `ls scripts/amapi_crawler_lib/normalize.py`
   - `ls scripts/amapi_crawler_lib/categorize.py`
   - `ls scripts/amapi_crawler_lib/importer.py`
4. Verify DB is present and parseable:
   - `python -c "import sqlite3; c=sqlite3.connect('assets/air_manager_api/crawl.sqlite3'); print(c.execute('SELECT COUNT(*) FROM urls').fetchone())"`
   - Should report ~700 total rows.
5. Verify test baseline: `python -m pytest tests/test_amapi_crawler.py -v` — expect 106 passed.
6. Verify SSL works (TLS setup from BUGFIX-02):
   - `python -c "import requests; r=requests.get('https://wiki.siminnovations.com/', verify='assets/air_manager_api/wiki-cert-chain.pem'); print(r.status_code)"`
   - Should print 200.

**If any check fails:** Write `docs/tasks/amapi_crawler_bugfix_03_prompt_deviation.md` and STOP.

---

## Phase 0: Source-of-Truth Audit

Before any implementation work:

1. Read all source-of-truth documents listed in the prompt header.

**Definition — Actionable requirement:** A statement that, if not implemented, would make the task incomplete.

2. Extract actionable requirements relevant to this task, with particular attention to:
   - D-03 §URL Normalization (6 rules — we're adding a 7th via redlink stripping)
   - D-03 §Schema (category column, status column semantics)
   - Plan §4.5 (current API_PREFIXES whitelist)
   - Turn-43 diagnostic findings (missing unprefixed functions, redlink volume)
3. **SEED-LIST INCLUSION VERIFICATION (blocking gate):** This task's Phase A cannot proceed until we verify that EVERY normalized seed URL has a corresponding row in the `urls` table. Details in Phase A.0 below.
4. Cross-reference each requirement against this prompt's implementation phases.
5. If ALL covered: print "Phase 0: all source requirements covered" and proceed.
6. If uncovered: write `docs/tasks/amapi_crawler_bugfix_03_prompt_phase0_deviation.md` and STOP.

---

## Instructions

Three-part fix:
1. **Expand the API whitelist.** Parse the AMAPI catalog page for the authoritative function inventory; add missing prefixes AND unprefixed function families; re-categorize existing DB rows; queue newly-valid URLs.
2. **Handle redlinks.** Add `redlink=1` to the URL normalization strip list; add a `redlink=1` short-circuit to categorization that marks such URLs `out-of-scope` with category `redlink`; migrate existing DB redlink rows.
3. **Run the backfill crawl.** Fetch the newly-queued URLs. Report results.

**Also read `CLAUDE.md`** for conventions including the D-04 commit trailer policy. **Also read `claude-conventions.md`** §Git Commit Trailers for the exact commit format.

---

## Integration Context

- **Platform:** Windows PowerShell. Python in `.py` files only.
- **Python env:** Existing from prior tasks. No new dependencies.
- **Key files this task modifies:**
  - MODIFIED: `scripts/amapi_crawler_lib/normalize.py` — add `redlink` to strip list
  - MODIFIED: `scripts/amapi_crawler_lib/categorize.py` — expand API_PREFIXES, add UNPREFIXED_API_FUNCTIONS set, add redlink short-circuit
  - MODIFIED: `scripts/amapi_crawler.py` — no functional change expected; may need re-import if category logic changes
  - MODIFIED: `tests/test_amapi_crawler.py` — add tests for new categorization behaviors
  - NEW: `scripts/amapi_crawler_recategorize.py` — one-shot migration to re-categorize existing DB rows
  - NEW: `scripts/amapi_crawler_parse_api_index.py` — parses the API catalog page; prints the inventory
  - NEW: `docs/knowledge/amapi_function_inventory.md` — human-readable catalog from Phase A (provenance header required)
  - MODIFIED: `assets/air_manager_api/crawl.sqlite3` — re-categorized rows + new pending URLs + backfill fetch
  - NEW: `assets/air_manager_api/crawl_backfill_complete.md` — backfill crawl summary (provenance header required)
- **The AMAPI catalog page:** Already fetched at `assets/air_manager_api/wiki.siminnovations.com/index.php@title=API`. This is the authoritative function index. Do NOT re-fetch it for this task — we already have the content.

---

## Implementation Order

**Execute phases sequentially. Do NOT parallelize.**

Run tests after each phase that adds code and do not proceed if tests fail.

---

### Phase A: Authoritative whitelist from AMAPI catalog page

#### A.0: Seed-list inclusion verification (blocking gate)

Before doing any whitelist work, verify every seed URL has a row in the DB. This confirms the DB's frontier is complete.

1. Load seed URLs: read `assets/air_manager_api/air_manager_wiki_urls.txt`, skip blanks, normalize each via `scripts/amapi_crawler_lib/normalize.py`.
2. Drop None results (Special: pages normalized-away).
3. Deduplicate → set of canonical URLs.
4. For each canonical seed URL, query the DB: `SELECT url_id FROM urls WHERE url = ?`. Count misses.
5. If misses == 0: print `"Seed inclusion verified: N unique normalized seeds all present in DB"` and proceed.
6. If misses > 0:
   - List the missing URLs and their raw (pre-normalization) seed-file values.
   - Write `docs/tasks/amapi_crawler_bugfix_03_seed_gap.md` with findings.
   - STOP. Do not proceed until CD investigates.

**Expected result based on current state:** 0 misses. Seed URLs are in the DB from earlier crawl runs. This is a safety check, not a discovery check.

#### A.1: Parse the API catalog page

1. Create `scripts/amapi_crawler_parse_api_index.py`. Reads `assets/air_manager_api/wiki.siminnovations.com/index.php@title=API` via BeautifulSoup.
2. Extract every wiki-internal link from the page content:
   - Select `<a>` elements within `#mw-content-text` (the article body, not sidebar/nav)
   - For each, extract `href` and the link text
   - Filter: links pointing to `/index.php?title=` OR `/index.php/` (wiki-internal page references)
   - Filter out: links with `class="new"` or `redlink=1` in href (redlinks — intentional "wanted pages" that don't exist)
3. Normalize each link URL via `normalize()` and extract its title.
4. Group the extracted titles by their "first-underscore" prefix (same rule `categorize()` uses).
5. Output to stdout:
   - Every unique prefix found on the catalog page + count
   - Every title with NO underscore (these are the unprefixed function names)
6. Also save the full extracted title list to `docs/knowledge/amapi_function_inventory.md` with:
   - Provenance header (Created, Source)
   - "Generated by: scripts/amapi_crawler_parse_api_index.py"
   - "Source page: index.php?title=API (local mirror)"
   - Table: Title | First-token prefix | Fetched? (Y/N from DB join) | Category (current DB value)
   - Grouped sections: "Prefixed API functions" (those with underscore), "Unprefixed API functions" (those without)

#### A.2: Derive the augmented whitelist

Based on A.1's output:

1. Compare the prefix set found on the API catalog page against the current `API_PREFIXES` in `scripts/amapi_crawler_lib/categorize.py`.
2. Identify NEW prefixes (on the catalog page but not in the whitelist). These are Category 1 additions.
3. Identify unprefixed titles from the catalog page. These are Category 2 additions — to go into a new `UNPREFIXED_API_FUNCTIONS` set.
4. Document the proposed additions in `docs/knowledge/amapi_function_inventory.md` under a new section "Whitelist Additions (Phase A)".

**Do NOT yet modify `categorize.py`.** The whitelist changes happen in Phase C after Phase B contributes its candidates.

---

### Phase B: Candidate backfill from diagnostic output

1. Read the Turn-43 diagnostic output at `assets/air_manager_api/crawl_diagnostic_turn43.txt`.
2. Extract Section 4 (first-token prefix distribution of wiki-other titles).
3. For each prefix with count ≥ 3 (signal threshold to avoid noise):
   - Reject obvious non-API prefixes: `Talk:`, `Main`, `Air`, `Android`, `IPad`, `Flight`, `Sim`, `Running`, `Knobster`, `Professional`, `Connection`, `Create`, `Aspen`, `Cessna` (manufacturer/aircraft names), `VEMD`, `KnobFS`, `KnobXP`, `Arduino`, `Hardware`, `Instrument_Creation_Tutorial` (the tutorial, not functions)
   - If prefix matches a function-naming pattern (`PascalCase_with_underscore_function`) or is a single PascalCase word (like `Arc`, `Circle`, `Ellipse`, `Fill`) → candidate for whitelist
4. Produce candidate list B.
5. Dedupe candidate list B against Phase A's Categories 1 and 2:
   - Items in B that are already in A's additions: report as "duplicate (already from catalog)"
   - Items in B but NOT in A's additions: report as "diagnostic-only candidate"
6. For each "diagnostic-only candidate":
   - Sample 1–2 actual URLs from the DB with that prefix/name
   - Fetch one sample page content (from the mirror if already there, or via crawler if not)
   - Spot-check: does the page content look like an API function reference?
   - Document findings in `docs/knowledge/amapi_function_inventory.md` under "Whitelist Additions (Phase B — diagnostic candidates)"

---

### Phase C: Whitelist update + normalization + categorization + DB migration

#### C.1: Update `normalize.py`

Add `redlink` to the stripped query parameters. Current strip list is `action` and `oldid`; add `redlink`.

```python
# Before normalization, remove these query parameters:
_STRIP_QUERY_PARAMS = {'action', 'oldid', 'redlink'}
```

Add a test to `tests/test_amapi_crawler.py`:
- `test_redlink_stripped`: `normalize('https://wiki.siminnovations.com/index.php?title=Foo&redlink=1')` returns `https://wiki.siminnovations.com/index.php?title=Foo`
- `test_redlink_with_other_params`: `normalize('...?title=Foo&redlink=1&action=view')` returns `?title=Foo` (both stripped)

#### C.2: Update `categorize.py`

1. Add the new prefixes from Phase A.2 Category 1 to `API_PREFIXES`.
2. Create a new set `UNPREFIXED_API_FUNCTIONS` containing Phase A.2 Category 2 titles AND Phase B diagnostic-confirmed titles.
3. Update `categorize()` logic order (existing logic preserved where possible):
   - If title starts with `Special:` → `'special'`
   - If title is in `UNPREFIXED_API_FUNCTIONS` → return `'unprefixed-api'` (new category string)
   - If title is in `NON_API_TITLES` → `'non-api-useful'`
   - If title starts with `File:` → `'file'`
   - If first-underscore token in `API_PREFIXES` → that prefix as category
   - Otherwise → `'wiki-other'`
4. Update `should_queue()` to return True for API_PREFIXES, `'non-api-useful'`, AND `'unprefixed-api'`.
5. Note: redlink detection happens at normalization time (C.1), so by the time categorization runs, the `redlink=1` suffix is gone. If we later decide redlink URLs should be identifiable post-normalization, we'd need a separate mechanism — not required for this bugfix.

Add tests:
- Each newly-added prefix returns its prefix as category and `should_queue` returns True
- Each entry in `UNPREFIXED_API_FUNCTIONS` returns `'unprefixed-api'` and `should_queue` returns True
- Titles that look like function names but aren't in either set still return `'wiki-other'` (avoid false positives)

#### C.3: Re-categorize existing DB rows

Create `scripts/amapi_crawler_recategorize.py`. One-shot migration:

1. Connect to DB.
2. For every row in `urls`, re-run `categorize()` on its title + url.
3. If the new category differs from the current:
   - If old was `out-of-scope` and new is queue-eligible AND the row is NOT currently `fetched` (i.e., it was marked out-of-scope without being fetched) → set `status='pending'`, update `category`.
   - If old was queue-eligible and new is `out-of-scope` → set `status='out-of-scope'`, update `category`.
   - If already fetched: just update the category column; do NOT re-fetch.
4. Wrap all updates in a single transaction.
5. Print summary: "re-categorized N rows (P promoted to pending, D demoted to out-of-scope, U category-only update)".
6. Idempotent: second run finds no changes.
7. Add a `crawl_runs` row with notes referencing this migration.

#### C.4: Tests

Run full test suite: `python -m pytest tests/test_amapi_crawler.py -v`.
Expected: 106 baseline + new tests from C.1 + new tests from C.2. All pass.

---

### Phase D: Backfill crawl

1. Query DB for current pending count: `SELECT COUNT(*) FROM urls WHERE status='pending'`.
2. If zero: print `"No new pending URLs after recategorization. Whitelist expansion added zero new fetches."` and skip to Phase E. (This is a valid outcome — possible if A and B found nothing that wasn't already covered.)
3. If nonzero: run the crawler with a reasonable wall-clock cap:
   ```
   python scripts/amapi_crawler.py --max-wall-clock-hours 0.25
   ```
   0.25 hours = 15 minutes. Enough for ~800 URLs at 1s each; far more than we'll need.
4. When complete: read `assets/air_manager_api/crawl_complete.md`. Copy its summary into `assets/air_manager_api/crawl_backfill_complete.md` with a provenance header pointing at this prompt. Leave the original `crawl_complete.md` untouched as a historical record of the first full run.
5. Verify: `python scripts/crawl_diagnostic_turn43.py` again. Copy the new output to `assets/air_manager_api/crawl_diagnostic_turn45.txt`. Compare pre/post on:
   - `wiki-other` count (should be smaller)
   - API-prefix bucket counts (should be larger where prefixes were added)
   - `unprefixed-api` count (new category, should be non-zero if Phase A or B found anything)

---

### Phase E: Completion

Write completion report `docs/tasks/amapi_crawler_bugfix_03_completion.md` with:

1. Provenance header (Created, Source=this prompt path)
2. Phase A results:
   - A.0: seed-inclusion verification result (expected: 0 misses)
   - A.1: prefixes found on catalog page + count; unprefixed functions list
   - A.2: proposed whitelist additions (Categories 1 and 2)
3. Phase B results:
   - Candidate list from diagnostic
   - Duplicates vs Phase A
   - Diagnostic-only candidates confirmed as API functions (spot-checked)
4. Phase C results:
   - normalize.py changes (redlink strip)
   - categorize.py changes (API_PREFIXES additions, UNPREFIXED_API_FUNCTIONS additions)
   - Re-categorization summary: N rows changed, P promoted, D demoted
5. Phase D results:
   - Backfill crawl duration
   - URLs fetched; categories
   - Pre/post diagnostic comparison table
6. Full test count (expected 106 baseline + new tests)
7. Any deviations from this prompt with rationale

---

## Completion Protocol

1. Run final test suite: `python -m pytest tests/test_amapi_crawler.py -v`
2. Write completion report per Phase E
3. `git add -A`
4. Commit using the D-04 trailer format via a message file (CC has shell access; write to temp file and `git commit -F <file>`). Message structure:
   ```
   AMAPI-CRAWLER-BUGFIX-03: expand API whitelist, add unprefixed functions, handle redlinks

   Task-Id: AMAPI-CRAWLER-BUGFIX-03
   Authored-By-Instance: cc
   Refs: D-03, D-04, AMAPI-CRAWLER-01, AMAPI-CRAWLER-BUGFIX-01, AMAPI-CRAWLER-BUGFIX-02
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```
5. **Flag refresh check:** This task does not modify `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`. Do NOT create refresh flags.
6. Send completion notification:
   ```
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "AMAPI-CRAWLER-BUGFIX-03 completed [flight-sim]"
   ```

**Do NOT git push.** Steve pushes manually.
