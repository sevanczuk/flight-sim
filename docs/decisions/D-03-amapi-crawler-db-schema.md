# D-03: AMAPI crawler tracking DB — schema decision

**Created:** 2026-04-20T07:23:51-04:00
**Source:** Purple Turns 11–12 — schema proposal and acceptance for Stream A1 crawler tracking DB
**Decision type:** architecture / data model

## Decision

Stream A1 (AMAPI crawler) uses a SQLite database at `assets/air_manager_api/crawl.sqlite3` to track the URL frontier, fetch state, link graph, and crawl-run history. Replaces the originally-proposed flat `crawl_log.txt` as the authoritative state store. Flat log retained as append-only human-readable audit stream.

## Schema

Three tables: `urls` (frontier + metadata), `edges` (link graph), `crawl_runs` (invocation history).

### Table: urls

```sql
CREATE TABLE urls (
  url_id              INTEGER PRIMARY KEY AUTOINCREMENT,
  url                 TEXT    NOT NULL UNIQUE,          -- normalized canonical form
  url_raw             TEXT,                              -- original form as seen (audit)
  title               TEXT,                              -- wiki page title, URL-decoded
  category            TEXT,                              -- prefix bucket: Xpl, Msfs, Hw, Si, Viewport, Img, non-api, external, youtube
  source              TEXT    NOT NULL
                      CHECK (source IN ('seed', 'discovered', 'pre-existing')),
  status              TEXT    NOT NULL DEFAULT 'pending'
                      CHECK (status IN ('pending', 'fetched', 'failed', 'skipped', 'out-of-scope')),
  fetched_at          TEXT,                              -- ISO 8601; file mtime for pre-existing, fetch time for new
  http_status         INTEGER,                           -- HTTP response code; 200 assumed for pre-existing
  content_bytes       INTEGER,                           -- response body size
  content_sha256      TEXT,                              -- hash of response body
  local_path          TEXT,                              -- relative path inside wiki.siminnovations.com/
  attempts            INTEGER NOT NULL DEFAULT 0,
  last_error          TEXT,                              -- short error string from most recent failure
  next_retry_at       TEXT,                              -- ISO 8601; crawler skips until this passes
  first_seen_run_id   INTEGER REFERENCES crawl_runs(run_id),
  last_fetched_run_id INTEGER REFERENCES crawl_runs(run_id)
);

CREATE INDEX idx_urls_status      ON urls(status);
CREATE INDEX idx_urls_category    ON urls(category);
CREATE INDEX idx_urls_fetched_at  ON urls(fetched_at);
```

### Table: edges

Full link graph. Each row records one link from one page to another. `referrer_url_id` in the original proposal is subsumed by this table — the inbound-edge set of a URL is richer and more honest than a single-referrer column.

```sql
CREATE TABLE edges (
  edge_id     INTEGER PRIMARY KEY AUTOINCREMENT,
  from_url_id INTEGER NOT NULL REFERENCES urls(url_id),
  to_url_id   INTEGER NOT NULL REFERENCES urls(url_id),
  anchor_text TEXT,                                      -- link's visible text; useful for context
  UNIQUE (from_url_id, to_url_id)
);

CREATE INDEX idx_edges_to   ON edges(to_url_id);
CREATE INDEX idx_edges_from ON edges(from_url_id);
```

### Table: crawl_runs

One row per crawler invocation. Enables resumable crawls and per-run reporting.

```sql
CREATE TABLE crawl_runs (
  run_id                INTEGER PRIMARY KEY AUTOINCREMENT,
  started_at            TEXT NOT NULL,                   -- ISO 8601
  ended_at              TEXT,                            -- NULL until run completes
  seed_url_count        INTEGER,                         -- URLs in the frontier at run start
  fetched_this_run      INTEGER NOT NULL DEFAULT 0,
  discovered_this_run   INTEGER NOT NULL DEFAULT 0,
  failed_this_run       INTEGER NOT NULL DEFAULT 0,
  notes                 TEXT                             -- free-form: stop reason, interruption cause, etc.
);
```

## URL Normalization

Codified in crawler logic. Both `urls.url` (canonical) and `edges` comparisons use the normalized form. Rules:

1. Strip fragment identifier (`#foo`)
2. Strip `&action=...` and `&oldid=...` query parameters (editor/history views, not content)
3. Rewrite path-style titles to query-string form: `/index.php/{Title}` → `/index.php?title={Title}`
4. URL-decode the title parameter once so `File%3A...` and `File:...` collide correctly
5. Drop `Special:...` pages from the frontier (mark as `status='out-of-scope'`) — not content
6. Lowercase the scheme and host; preserve title case in the title parameter

`url_raw` preserves the original form as first seen, for audit.

## Pre-existing Mirror Reconstruction

The ~75 HTML files already in `assets/air_manager_api/wiki.siminnovations.com/` were fetched by a prior wget run that did not preserve referrer provenance.

**Approach adopted:**
- Insert one `urls` row per pre-existing HTML file with `source='pre-existing'`, `status='fetched'`, `fetched_at` = file mtime, `http_status=200`, `content_bytes` from file size, `content_sha256` computed from file content, `local_path` set, `first_seen_run_id` = first crawl-runs row (the import run)
- `attempts` and the error fields stay NULL/0
- Parse every pre-existing HTML file for outbound links; populate `edges` accordingly. Every inbound link becomes an edge, not a single designated referrer. Single-column `referrer_url_id` is NOT added to `urls`.

This gives a full link graph over pre-existing content at the cost of one extra parse pass (seconds for ~75 files).

## Indexes, Location, Version Control

- Indexes as shown in the schema above
- Location: `assets/air_manager_api/crawl.sqlite3`
- Gitignored: `.gitignore` adds `assets/air_manager_api/crawl.sqlite3` and `assets/air_manager_api/crawl.sqlite3.bak`
- Rationale for gitignore: DB is regenerable from the HTML mirror + the seed URL file. Keeping it out of git avoids bloat and noisy diffs.

## What Was Explicitly Rejected

- Storing full HTML content in the DB — we have files on disk; `local_path` bridges the two
- Storing structured parse output in the DB — that's Stream A2's concern; parsing and crawling stay separate
- Storing full HTTP response headers — low value; can be captured separately if ever needed
- Single `referrer_url_id` column on `urls` — superseded by the `edges` table per this decision

## Consequences

- A1 task prompt will specify:
  - Creating and populating the DB
  - Importing the pre-existing mirror as a first step (one crawl_runs row, source='pre-existing')
  - Parsing pre-existing HTML for edges
  - Applying URL normalization at every insert
  - Using `status='pending'` as the frontier queue
  - Writing `crawl.sqlite3` alongside the existing flat `crawl_log.txt` (log retained as human-readable audit)
- Plan document `GNC355_Prep_Implementation_Plan_V1.md` updated (Stream A1 section) to reference this DB
- `.gitignore` updated
- A2 (parser) will read the DB to know which files to parse and to record parse outcomes against `url_id`
- A3 (reference doc generation) will join `urls` + parse output for category indices

## Related

- D-02 (GNC 355 prep-work scoping)
- Plan: `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` §4 Stream A
- Future: A1 task prompt at `docs/tasks/amapi_crawler_prompt.md`
