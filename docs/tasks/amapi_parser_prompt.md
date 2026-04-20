# CC Task Prompt: AMAPI Parser — Extract Structured API Reference from Fetched HTML

**Location:** `docs/tasks/amapi_parser_prompt.md`
**Task ID:** AMAPI-PARSER-01 (Stream A2)
**Parent tasks:** AMAPI-CRAWLER-01, AMAPI-CRAWLER-BUGFIX-01/02/03 (all complete)
**Depends on:** Clean fetched HTML mirror at `assets/air_manager_api/wiki.siminnovations.com/` + function inventory at `docs/knowledge/amapi_function_inventory.md`
**Priority:** Blocks Stream A3 (reference doc generation) and eventual GNC 355 Design Spec
**Estimated scope:** Medium-large — 1–2 hours; multi-phase parser build with per-function JSON extraction, catalog JSON aggregation, and human-readable per-function markdown generation
**Task type:** code
**CRP applicability:** YES — multi-phase, expected output >500 lines across many files, estimated >15 min. Apply CRP per `docs/standards/compaction-resilience-protocol-v1.md`.
**Source of truth:**
- `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` §6.A.2 (parser phase description)
- `docs/knowledge/amapi_function_inventory.md` (canonical function list)
- `docs/decisions/D-03-amapi-crawler-db-schema.md` (DB schema the parser reads from)
- `docs/tasks/amapi_crawler_prompt.md` (original crawler context)
- `docs/tasks/amapi_crawler_bugfix_03_prompt.md` (recent whitelist + normalization work)
**Supporting assets:**
- `assets/air_manager_api/crawl.sqlite3` — DB with URL→local_path mapping
- `assets/air_manager_api/wiki.siminnovations.com/*` — fetched HTML pages (~270 files)
- `scripts/amapi_crawler_lib/` — existing lib with normalize/categorize/db modules to reuse
- `tests/test_amapi_crawler.py` — existing test baseline (212 passing)
**Audit level:** self-check + spot-check — rationale: new code with no prior review; moderate risk. After completion, CD will spot-check 3-5 random function outputs against source HTML.

---

## Pre-flight Verification

**Execute these checks before writing any code. If any check fails, STOP and write a deviation report.**

1. Verify source-of-truth docs exist:
   - `ls docs/specs/GNC355_Prep_Implementation_Plan_V1.md`
   - `ls docs/knowledge/amapi_function_inventory.md`
   - `ls docs/decisions/D-03-amapi-crawler-db-schema.md`
2. Verify DB is present and has post-BUGFIX-03 state:
   - `python -c "import sqlite3; c=sqlite3.connect('assets/air_manager_api/crawl.sqlite3'); print('fetched:', c.execute(\"SELECT COUNT(*) FROM urls WHERE status='fetched'\").fetchone()[0])"`
   - Should report a count close to 270 (exact count depends on post-BUGFIX-03 state). Record actual.
3. Verify fetched mirror directory:
   - Count files: `ls assets/air_manager_api/wiki.siminnovations.com/index.php@title=* | wc -l`
   - Should be close to 270.
4. Verify existing lib code:
   - `ls scripts/amapi_crawler_lib/normalize.py`
   - `ls scripts/amapi_crawler_lib/categorize.py`
   - `ls scripts/amapi_crawler_lib/db.py`
5. Verify test baseline: `python -m pytest tests/test_amapi_crawler.py -v` — expect 212 passed.
6. Verify BeautifulSoup available: `python -c "from bs4 import BeautifulSoup; print(BeautifulSoup.__module__)"`.

**If any check fails:** Write `docs/tasks/amapi_parser_prompt_deviation.md` and STOP.

---

## Phase 0: Source-of-Truth Audit

Before any implementation work:

1. Read all source-of-truth documents listed in the prompt header.

**Definition — Actionable requirement:** A statement that, if not implemented, would make the task incomplete.

2. Extract actionable requirements relevant to this task, with particular attention to:
   - Plan §6.A.2 output format expectations
   - D-03 schema (which DB columns you'll consume)
   - Function inventory structure (what prefixed vs. unprefixed categories you must handle)
3. Cross-reference each requirement against this prompt's Implementation Order below.
4. If ALL covered: print "Phase 0: all source requirements covered" and proceed.
5. If any requirement is uncovered: write `docs/tasks/amapi_parser_prompt_phase0_deviation.md` and STOP.

---

## CRP Configuration

**Work directory:** `_crp_work/amapi_parser_01/`

**Status file:** `_crp_work/amapi_parser_01/_status.json` — updated after each phase with schema:
```json
{
  "task_id": "AMAPI-PARSER-01",
  "phases": {
    "A": {"status": "complete|in-progress|pending", "started": "<iso>", "completed": "<iso>", "artifacts": ["..."]},
    "B": {...},
    ...
  },
  "current_phase": "A|B|C|D|E|F",
  "last_updated": "<iso>"
}
```

**Phase completion markers:** `_crp_work/amapi_parser_01/_phase_{A|B|C|D|E|F}_complete.md` written at phase end.

**Resume protocol:** On session start, read `_status.json`; resume from first phase whose status != "complete".

---

## Instructions

Build a parser that converts the fetched MediaWiki HTML into structured JSON per function + per-function markdown reference docs + an aggregated catalog index. The output is the knowledge base that Stream A3 and the GNC 355 Design Spec will consume.

**Output artifacts (summary — see phases for detail):**
- `assets/air_manager_api/parsed/_index.json` — catalog index listing all functions with metadata + cross-references
- `assets/air_manager_api/parsed/by_function/{function_name}.json` — one JSON per function with structured fields
- `docs/reference/amapi/by_function/{function_name}.md` — one human-readable markdown per function
- `docs/reference/amapi/_index.md` — human-readable catalog
- `docs/reference/amapi/_parser_report.md` — parser diagnostic report (anomalies, skipped pages, unparseable sections)

**Design principles:**
- **Deterministic:** parsing the same HTML twice produces byte-identical output. No timestamps inside JSON bodies (timestamps only in provenance headers).
- **Forgiving:** pages that don't match the canonical function-page schema are recorded with `parse_status: 'partial'` or `'non-function'` rather than skipped. Diagnostic report lists anomalies.
- **Source-traceable:** every parsed function record includes `source_url`, `local_path`, `parsed_at`.
- **Non-destructive:** reads from HTML mirror; never writes to it.

**Also read `CLAUDE.md`** for conventions including D-04 commit trailer policy. **Also read `claude-conventions.md`** §Git Commit Trailers for the exact commit format.

---

## Integration Context

- **Platform:** Windows PowerShell. Python in `.py` files only.
- **Python env:** Existing. Uses `beautifulsoup4` (already installed) and `lxml` (may need install).
- **Key files this task creates:**
  - NEW: `scripts/amapi_parser.py` — main entry point; iterates DB, calls parser per page, writes outputs
  - NEW: `scripts/amapi_parser_lib/__init__.py` — empty
  - NEW: `scripts/amapi_parser_lib/page_classifier.py` — decides page shape (function / catalog / tutorial / other)
  - NEW: `scripts/amapi_parser_lib/function_page_parser.py` — parses canonical function pages into structured dict
  - NEW: `scripts/amapi_parser_lib/catalog_page_parser.py` — parses catalog/reference pages (Device_list, Hardware_id_list)
  - NEW: `scripts/amapi_parser_lib/markdown_renderer.py` — converts parsed dicts to markdown
  - NEW: `tests/test_amapi_parser.py` — test suite (will be added to main pytest discovery)
  - NEW: directory `assets/air_manager_api/parsed/` — JSON outputs (parser-generated; to be gitignored — see Phase F)
  - NEW: directory `docs/reference/amapi/` — human-readable markdown outputs (tracked)
- **DB usage:** READ ONLY. Query `urls` table for `(title, url, local_path, category)` tuples. Do not modify DB.
- **HTML mirror:** READ ONLY. Never write into `assets/air_manager_api/wiki.siminnovations.com/`.

---

## Canonical Function Page Structure (reference for parser)

The canonical function page (example: `Xpl_dataref_subscribe`) has this structure in the `<div id="mw-content-text"><div class="mw-parser-output">` container:

1. **Table of Contents** — `<div id="toc">`. Skip.
2. **Section headers** — `<h2><span class="mw-headline" id="Section_Name">Section Name</span></h2>`. Canonical sections include: `Description`, `Return_value`, `Arguments`, `Example`, `Example_(single_...)`, `Example_(multi_...)`, `See_also`.
3. **Signature block** — First `<pre><b>`*`signature()`*`</b></pre>` typically appears right after the `Description` header. Contains the function signature in bold.
4. **Description text** — `<p>` elements following the signature, before next `<h2>`.
5. **Return value text** — `<p>` elements under the `Return_value` section.
6. **Arguments table** — `<table class="wikitable">` under the `Arguments` section. Columns: `#`, `Argument`, `Type`, `Description`. Rows contain parameter entries.
7. **Code examples** — `<pre><code class="lua todo">...</code></pre>` under `Example_*` sections. One code block per example section.
8. **See also** — `<ul>` of wiki links under `See_also` section (if present).

Page metadata is available from:
- `<h1 id="firstHeading">` — display name (e.g., "Xpl dataref subscribe")
- `RLCONF` JS object in `<head>` — contains `wgPageName` (underscored), `wgArticleId`, `wgCurRevisionId`

Content end marker: `<!-- NewPP limit report -->` HTML comment (anything after is MediaWiki footer).

**Known deviations from the canonical structure:**
- `Device_list`, `Hardware_id_list` — catalog pages with nested product-spec tables. Different parser path.
- `File:` pages — image description pages. Skip (not API content).
- `Special:` pages — search/login pages. Skip.
- User manual / FAQ / tutorial pages (e.g., `Air_Manager_FAQ`, `Instrument_Creation_Tutorial`) — free-form documentation. Record as `page_shape: 'tutorial'` but don't attempt deep parsing.

---

## Implementation Order

**Execute phases sequentially.** Update `_crp_work/amapi_parser_01/_status.json` after each phase.

---

### Phase A: Parser library skeleton + page classifier

1. Create `scripts/amapi_parser_lib/__init__.py` (empty).
2. Create `scripts/amapi_parser_lib/page_classifier.py`:
   - Function: `classify_page(html: str, title: str, category: str) -> dict`
   - Returns a dict: `{"shape": "function" | "catalog" | "tutorial" | "non-content" | "unknown", "signals": [...], "confidence": 0.0-1.0}`
   - Classification signals:
     - Has `<pre><b>` within first 500 chars of content → function (high confidence)
     - Has section headers matching `Arguments`, `Return value`, `Description` → function (high confidence)
     - Has nested product spec tables (look for patterns like "Type:" "Vendor ID:" in tables) → catalog
     - Has only free-form `<p>` and `<ul>` with no canonical function markers → tutorial
     - Title starts with `File:` or `Special:` → non-content
     - Else → unknown
3. Tests: `tests/test_amapi_parser.py::TestPageClassifier` — classify 5+ sample pages, assert expected shape.

**Phase A complete marker:** write `_crp_work/amapi_parser_01/_phase_A_complete.md` with summary.

---

### Phase B: Function page parser

1. Create `scripts/amapi_parser_lib/function_page_parser.py`:
   - Function: `parse_function_page(html: str, title: str, url: str, local_path: str) -> dict`
   - Returns the canonical function record (schema below).
   - Reuses `page_classifier.classify_page` for sanity check; if shape != 'function', return a stub record with `parse_status: 'skipped-wrong-shape'`.

**Canonical function record schema:**

```json
{
  "schema_version": "1.0",
  "page_name": "Xpl_dataref_subscribe",
  "display_name": "Xpl dataref subscribe",
  "canonical_name": "xpl_dataref_subscribe",
  "namespace_prefix": "Xpl",
  "category": "Xpl",
  "article_id": 11,
  "revision_id": 5103,
  "source_url": "https://wiki.siminnovations.com/index.php?title=Xpl_dataref_subscribe",
  "local_path": "assets/air_manager_api/wiki.siminnovations.com/index.php@title=Xpl_dataref_subscribe",
  "signature": "xpl_dataref_subscribe(dataref,type,...,callback_function)",
  "description": "xpl_dataref_subscribe is used to subscribe to one or more X-Plane datarefs. You can find the available datarefs here.",
  "description_html": "<p><b>xpl_dataref_subscribe</b> is used to subscribe...",
  "return_value": {
    "text": "This function won't return any value.",
    "type": null
  },
  "arguments": [
    {
      "position": "1 .. n",
      "name": "dataref",
      "type": "String",
      "description": "Reference to a dataref from X-Plane"
    },
    {
      "position": "2 .. n",
      "name": "type",
      "type": "String",
      "description": "Data type of the DataRef, can be INT,FLOAT,DOUBLE,INT[n],FLOAT[n],DOUBLE[n], BYTE[n] or STRING"
    },
    {
      "position": "last",
      "name": "callback_function",
      "type": "Function",
      "description": "The function to call when new data is available"
    }
  ],
  "examples": [
    {
      "section_label": "Example (single dataref)",
      "language": "lua",
      "code": "-- This function will be called when new data is available from X-Plane\nfunction new_altitude_callback(altitude)\n  print(\"New altitude: \" .. altitude)\nend\n\n-- subscribe X-Plane datarefs\nxpl_dataref_subscribe(\"sim/cockpit2/gauges/indicators/altitude_ft_pilot\", \"FLOAT\", new_altitude_callback)"
    }
  ],
  "see_also": [
    {"page_name": "Xpl_command", "display_text": "Xpl command"}
  ],
  "cross_references": [
    {"page_name": "Msfs_variable_subscribe", "context": "body_link"}
  ],
  "external_references": [
    {"url": "https://developer.x-plane.com/datarefs/", "display_text": "X-Plane DataRefs"}
  ],
  "parse_status": "complete",
  "parse_warnings": [],
  "parse_notes": ""
}
```

**Field semantics:**
- `canonical_name`: lowercase function name as used in Lua code (e.g., `xpl_dataref_subscribe`). For functions without a clear Lua name in the signature, equals `page_name.lower()`.
- `namespace_prefix`: the first-underscore token (e.g., `Xpl`, `Hw`, `Msfs`). For unprefixed functions (Arc, Circle, Fill), this is `null`.
- `signature`: the full signature text from the `<pre><b>...</b></pre>` block, with HTML decoded.
- `description`: plaintext (HTML stripped, whitespace normalized).
- `description_html`: preserves inline formatting (links, bold, code) for later rendering.
- `return_value.type`: if the description mentions a type (e.g., "Returns a Number"), extract; else null.
- `arguments`: ordered list; each entry has position, name, type, description. Empty list is valid for zero-arg functions.
- `examples`: ordered list; each entry has section label (from the heading text in parens), language (from `<code class="...">`), code (HTML-decoded).
- `see_also` vs `cross_references`: `see_also` comes specifically from a `See_also` / `See also` section. `cross_references` is any other wiki-internal link found in the body (Description, Arguments, Examples).
- `external_references`: non-wiki URLs found in the body.
- `parse_status`: `"complete"` (all expected sections found), `"partial"` (some sections missing but function identity clear), `"skipped-wrong-shape"` (page doesn't match function structure).
- `parse_warnings`: list of warning strings (e.g., "no arguments table found", "signature parse fallback used").
- `parse_notes`: freeform note from parser; usually empty.

2. Tests: `tests/test_amapi_parser.py::TestFunctionPageParser` — at minimum:
   - Parse `Xpl_dataref_subscribe` (zero-arg style in nothing — multi-dataref function); assert signature, at least 3 arguments, 3 examples.
   - Parse `Hw_button_add`; assert signature matches expected, at least one argument.
   - Parse `Msfs_variable_subscribe`; assert examples are present.
   - Parse an unprefixed function like `Circle`; assert `namespace_prefix` is null, `category` is `unprefixed-api`.
   - Parse a zero-example function; assert `examples: []` (empty list, not crash).
   - Parse a function with a missing Arguments section; assert `parse_status: 'partial'` with appropriate warning.

**Phase B complete marker:** write `_crp_work/amapi_parser_01/_phase_B_complete.md` with summary.

---

### Phase C: Catalog page parser (light)

1. Create `scripts/amapi_parser_lib/catalog_page_parser.py`:
   - Function: `parse_catalog_page(html: str, title: str, url: str, local_path: str) -> dict`
   - Returns a simpler record for catalog pages like `Device_list`, `Hardware_id_list`.

**Catalog record schema (lighter than function):**

```json
{
  "schema_version": "1.0",
  "page_name": "Device_list",
  "display_name": "Device list",
  "page_shape": "catalog",
  "article_id": 500,
  "revision_id": 5982,
  "source_url": "https://wiki.siminnovations.com/index.php?title=Device_list",
  "local_path": "assets/air_manager_api/wiki.siminnovations.com/index.php@title=Device_list",
  "sections": [
    {
      "section_id": "Octavi_IFR_1",
      "heading": "Octavi IFR 1",
      "properties": {
        "Type": "OCTAVI_IFR_1"
      },
      "raw_html_length": 1234
    }
  ],
  "cross_references": [...],
  "external_references": [...],
  "parse_status": "complete",
  "parse_warnings": [],
  "parse_notes": "Catalog page; sections extracted with property key-value pairs where detectable."
}
```

2. Scope the catalog parser conservatively — extract section headings + simple key-value pairs (`Type: FOO`, `Vendor ID: 0x1234`). Don't try to extract embedded code tables or deeply nested product specs — those can be retrieved from `raw_html` at consumption time.

3. Tests: `tests/test_amapi_parser.py::TestCatalogPageParser` — parse `Device_list`; assert 17 sections extracted; first section is `Octavi_IFR_1`; property `Type` has value `OCTAVI_IFR_1`.

**Phase C complete marker:** write `_crp_work/amapi_parser_01/_phase_C_complete.md`.

---

### Phase D: Main parser entry point + full-corpus run

1. Create `scripts/amapi_parser.py`:
   - CLI: `python scripts/amapi_parser.py [--dry-run] [--filter PATTERN] [--output-dir DIR]`
   - Workflow:
     1. Open DB; query rows WHERE `status = 'fetched'` AND `category NOT IN ('file', 'special', 'redlink', 'external', 'youtube')`.
     2. For each row: read the local HTML file; run `page_classifier.classify_page(...)`; dispatch to the appropriate parser (`function_page_parser`, `catalog_page_parser`, or skip with note).
     3. Write parsed record to `assets/air_manager_api/parsed/by_function/{page_name}.json`.
     4. Aggregate records into `assets/air_manager_api/parsed/_index.json`.
     5. Write diagnostic report `docs/reference/amapi/_parser_report.md`.
2. `_index.json` schema:
```json
{
  "schema_version": "1.0",
  "generated_at": "2026-04-20T00:00:00-04:00",
  "generator": "scripts/amapi_parser.py",
  "total_pages_processed": 275,
  "counts_by_shape": {
    "function": 220,
    "catalog": 2,
    "tutorial": 15,
    "non-content": 30,
    "unknown": 8
  },
  "counts_by_namespace": {
    "Xpl": 5,
    "Msfs": 6,
    "Hw": 28,
    ...
  },
  "functions": [
    {
      "page_name": "Xpl_dataref_subscribe",
      "canonical_name": "xpl_dataref_subscribe",
      "namespace_prefix": "Xpl",
      "category": "Xpl",
      "parse_status": "complete",
      "signature": "xpl_dataref_subscribe(dataref,type,...,callback_function)",
      "one_line_description": "Subscribe to one or more X-Plane datarefs."
    },
    ...
  ],
  "catalogs": [...],
  "tutorials": [...],
  "warnings": [
    {"page_name": "Foo_bar", "warning": "no arguments table found"}
  ]
}
```

3. `_parser_report.md` structure:
   - Provenance header
   - Summary table: total pages, by-shape counts, by-status counts
   - Anomalies: list of pages with `parse_status != 'complete'` and their warnings
   - Unprefixed functions coverage: list of Phase-A/B-added unprefixed functions from BUGFIX-03 and whether they parsed cleanly
   - Cross-reference density: most-linked-from functions (useful for A3)
   - Non-function pages: list of pages classified as catalog/tutorial/non-content with counts by shape

4. Output should be byte-deterministic given same input. Write keys in sorted order in JSON; use `sort_keys=True` and `indent=2`.

**Phase D complete marker:** write `_crp_work/amapi_parser_01/_phase_D_complete.md` with:
- pages processed count
- shape counts
- warnings count

---

### Phase E: Markdown renderer + per-function docs

1. Create `scripts/amapi_parser_lib/markdown_renderer.py`:
   - Function: `render_function_markdown(record: dict) -> str` — takes a parsed function dict; returns markdown.
   - Function: `render_index_markdown(index: dict) -> str` — takes `_index.json`; returns the catalog index markdown.

**Per-function markdown structure:**

```markdown
---
Created: <ISO 8601 timestamp>
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: xpl_dataref_subscribe
Namespace: Xpl
Source URL: https://wiki.siminnovations.com/index.php?title=Xpl_dataref_subscribe
Revision: 5103
---

# Xpl dataref subscribe

## Signature

```
xpl_dataref_subscribe(dataref,type,...,callback_function)
```

## Description

xpl_dataref_subscribe is used to subscribe to one or more X-Plane datarefs.
You can find the available datarefs at X-Plane DataRefs.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 .. n | `dataref` | String | Reference to a dataref from X-Plane |
| 2 .. n | `type` | String | Data type of the DataRef, can be INT, FLOAT, ... |
| last | `callback_function` | Function | The function to call when new data is available |

## Examples

### Example (single dataref)

```lua
-- This function will be called when new data is available from X-Plane
function new_altitude_callback(altitude)
  print("New altitude: " .. altitude)
end

-- subscribe X-Plane datarefs
xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/altitude_ft_pilot", "FLOAT", new_altitude_callback)
```

## See also

- [Xpl_command](Xpl_command.md)
- [Msfs_variable_subscribe](Msfs_variable_subscribe.md)

## External references

- [X-Plane DataRefs](https://developer.x-plane.com/datarefs/)
```

**Index markdown structure:**

```markdown
---
Created: <ISO 8601>
Source: scripts/amapi_parser.py (parser-generated)
Total functions: 220
Total pages: 275
---

# AMAPI Reference — Catalog Index

Generated from `assets/air_manager_api/parsed/_index.json`.

## By namespace

### Xpl (5 functions)

- [Xpl_command](by_function/Xpl_command.md) — `xpl_command(...)` — Execute an X-Plane command.
- [Xpl_command_subscribe](by_function/Xpl_command_subscribe.md) — `xpl_command_subscribe(...)` — Subscribe to X-Plane commands.
...

### Msfs (6 functions)
...

## Unprefixed API functions (9)

- [Arc](by_function/Arc.md) — `arc(...)` — Draw an arc.
...

## Catalog pages (2)

- [Device_list](by_function/Device_list.md) — 17 product entries.
- [Hardware_id_list](by_function/Hardware_id_list.md) — hardware identifier catalog.
```

2. Integrate into `scripts/amapi_parser.py`:
   - After writing JSON records in Phase D, invoke `render_function_markdown` for each and write to `docs/reference/amapi/by_function/{page_name}.md`.
   - After writing `_index.json`, invoke `render_index_markdown` and write to `docs/reference/amapi/_index.md`.
3. Tests: `tests/test_amapi_parser.py::TestMarkdownRenderer` — render a synthetic function record and assert key structural elements (title, signature block, arguments table, example code blocks).

**Phase E complete marker:** write `_crp_work/amapi_parser_01/_phase_E_complete.md`.

---

### Phase F: Output placement, gitignore, cleanup

1. JSON outputs at `assets/air_manager_api/parsed/` are large and regenerable. Add a `.gitignore` entry:
   ```
   # AMAPI parser JSON output — regenerable from HTML mirror + scripts/amapi_parser.py (D-06 pattern)
   assets/air_manager_api/parsed/
   ```
   Note: this is a D-06-pattern decision (gitignore regenerable extraction output). CD will log a formal decision if this is the first such decision for the parser; for now, just add the .gitignore entry and document the reasoning inline.

2. Markdown outputs at `docs/reference/amapi/` ARE tracked (they're human-readable reference docs; small text files). No gitignore needed.

3. Provenance headers on every generated markdown file: Created, Source (`scripts/amapi_parser.py (parser-generated)`). Note: `docs/` files per project convention need provenance.

4. `_crp_work/amapi_parser_01/` — CC leaves this in place on successful completion; CD can clean up after compliance verification.

**Phase F complete marker:** write `_crp_work/amapi_parser_01/_phase_F_complete.md`.

---

## Completion Protocol

1. Run full test suite: `python -m pytest tests/ -v`. Expected: 212 baseline + new tests from test_amapi_parser.py. All pass.

2. Write completion report `docs/tasks/amapi_parser_completion.md` with:
   - Provenance header (Created, Source=this prompt path)
   - Phase summary table (A–F status + artifacts)
   - Statistics: total pages processed, counts by shape, functions with clean parse, functions with warnings, catalog pages, skipped non-content
   - File inventory: JSON files count, markdown files count, largest function by arg count, any anomalies
   - Spot-check table: 5 function parses verified manually against source HTML (CC picks diverse examples: Xpl_, Msfs_, Hw_, unprefixed, Fs2020_)
   - Parser report location: `docs/reference/amapi/_parser_report.md`
   - Any deviations from this prompt with rationale

3. `git add -A` then commit using the D-04 trailer format via a message file. Message structure:
   ```
   AMAPI-PARSER-01: extract structured API reference from fetched HTML

   Task-Id: AMAPI-PARSER-01
   Authored-By-Instance: cc
   Refs: D-03, D-04, D-06, AMAPI-CRAWLER-01, AMAPI-CRAWLER-BUGFIX-03
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

4. **Flag refresh check:** This task does not modify `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`. Do NOT create refresh flags.

5. Send completion notification:
   ```
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "AMAPI-PARSER-01 completed [flight-sim]"
   ```

**Do NOT git push.** Steve pushes manually.

---

## Expected Final Output Quantities

These are ballpark targets to confirm the task is "done" — actual counts may vary ±10%:

- JSON records: ~270 (one per fetched content page)
- Function records with `parse_status: complete`: ~210
- Catalog records: 2 (Device_list, Hardware_id_list)
- Tutorial/non-content records: ~30–40
- Markdown files in `docs/reference/amapi/by_function/`: one per JSON record = ~270
- Index files: 2 (`_index.md`, `_parser_report.md`)
- Test count: 212 baseline + ~30 new = ~242 total passing

If final counts are wildly outside this range, investigate and document in the completion report before finalizing.

---

## What This Unblocks

- **Stream A3:** generation of supplementary reference docs (e.g., by-namespace index, cookbook patterns). Consumes `_index.json` + per-function JSON.
- **Stream C2 (GNC 355 Functional Spec):** GNC 355 spec will cite specific AMAPI functions. Parsed reference docs are the authoritative citation source.
- **Future D-01 scope:** MSFS support. Parser treats Msfs_ pages identically to Xpl_ pages, so MSFS reference docs come for free when we switch simulators.
