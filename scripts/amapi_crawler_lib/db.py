"""Database connection, schema, and upsert helpers for the AMAPI crawler (per D-03 §Schema)."""
import sqlite3
from datetime import datetime, timezone, timedelta


EXPECTED_TABLES = {
    'urls': {
        'url_id', 'url', 'url_raw', 'title', 'category', 'source', 'status',
        'fetched_at', 'http_status', 'content_bytes', 'content_sha256',
        'local_path', 'attempts', 'last_error', 'next_retry_at',
        'first_seen_run_id', 'last_fetched_run_id',
    },
    'edges': {'edge_id', 'from_url_id', 'to_url_id', 'anchor_text'},
    'crawl_runs': {
        'run_id', 'started_at', 'ended_at', 'seed_url_count',
        'fetched_this_run', 'discovered_this_run', 'failed_this_run', 'notes',
    },
}

EXPECTED_INDEXES = {
    'idx_urls_status', 'idx_urls_category', 'idx_urls_fetched_at',
    'idx_edges_to', 'idx_edges_from',
}


def connect(db_path: str) -> sqlite3.Connection:
    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    conn.execute('PRAGMA foreign_keys = ON')
    conn.execute('PRAGMA journal_mode = WAL')
    return conn


def ensure_schema(conn: sqlite3.Connection) -> None:
    """Create tables and indexes if absent; raise on column mismatch."""
    conn.executescript("""
        CREATE TABLE IF NOT EXISTS crawl_runs (
            run_id                INTEGER PRIMARY KEY AUTOINCREMENT,
            started_at            TEXT NOT NULL,
            ended_at              TEXT,
            seed_url_count        INTEGER,
            fetched_this_run      INTEGER NOT NULL DEFAULT 0,
            discovered_this_run   INTEGER NOT NULL DEFAULT 0,
            failed_this_run       INTEGER NOT NULL DEFAULT 0,
            notes                 TEXT
        );

        CREATE TABLE IF NOT EXISTS urls (
            url_id              INTEGER PRIMARY KEY AUTOINCREMENT,
            url                 TEXT    NOT NULL UNIQUE,
            url_raw             TEXT,
            title               TEXT,
            category            TEXT,
            source              TEXT    NOT NULL
                                CHECK (source IN ('seed', 'discovered', 'pre-existing')),
            status              TEXT    NOT NULL DEFAULT 'pending'
                                CHECK (status IN ('pending', 'fetched', 'failed', 'skipped', 'out-of-scope')),
            fetched_at          TEXT,
            http_status         INTEGER,
            content_bytes       INTEGER,
            content_sha256      TEXT,
            local_path          TEXT,
            attempts            INTEGER NOT NULL DEFAULT 0,
            last_error          TEXT,
            next_retry_at       TEXT,
            first_seen_run_id   INTEGER REFERENCES crawl_runs(run_id),
            last_fetched_run_id INTEGER REFERENCES crawl_runs(run_id)
        );

        CREATE TABLE IF NOT EXISTS edges (
            edge_id     INTEGER PRIMARY KEY AUTOINCREMENT,
            from_url_id INTEGER NOT NULL REFERENCES urls(url_id),
            to_url_id   INTEGER NOT NULL REFERENCES urls(url_id),
            anchor_text TEXT,
            UNIQUE (from_url_id, to_url_id)
        );

        CREATE INDEX IF NOT EXISTS idx_urls_status     ON urls(status);
        CREATE INDEX IF NOT EXISTS idx_urls_category   ON urls(category);
        CREATE INDEX IF NOT EXISTS idx_urls_fetched_at ON urls(fetched_at);
        CREATE INDEX IF NOT EXISTS idx_edges_to        ON edges(to_url_id);
        CREATE INDEX IF NOT EXISTS idx_edges_from      ON edges(from_url_id);
    """)
    conn.commit()

    # Verify schema matches expectations
    for table, expected_cols in EXPECTED_TABLES.items():
        rows = conn.execute(f'PRAGMA table_info({table})').fetchall()
        if not rows:
            raise RuntimeError(f'Table {table!r} missing after schema creation')
        actual_cols = {row['name'] for row in rows}
        missing = expected_cols - actual_cols
        if missing:
            raise RuntimeError(f'Table {table!r} missing columns: {missing}')


def _now_iso() -> str:
    return datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')


def start_crawl_run(conn: sqlite3.Connection, notes: str = '') -> int:
    cur = conn.execute(
        'INSERT INTO crawl_runs (started_at, notes) VALUES (?, ?)',
        (_now_iso(), notes),
    )
    conn.commit()
    return cur.lastrowid


def end_crawl_run(conn: sqlite3.Connection, run_id: int, notes: str = '') -> None:
    existing = conn.execute('SELECT notes FROM crawl_runs WHERE run_id = ?', (run_id,)).fetchone()
    combined = (existing['notes'] or '') + (f'\n{notes}' if notes else '')
    conn.execute(
        'UPDATE crawl_runs SET ended_at = ?, notes = ? WHERE run_id = ?',
        (_now_iso(), combined.strip(), run_id),
    )
    conn.commit()


def update_run_counts(conn: sqlite3.Connection, run_id: int, *,
                      fetched_delta: int = 0, discovered_delta: int = 0,
                      failed_delta: int = 0, seed_url_count: int | None = None) -> None:
    if seed_url_count is not None:
        conn.execute(
            'UPDATE crawl_runs SET seed_url_count = ? WHERE run_id = ?',
            (seed_url_count, run_id),
        )
    if fetched_delta or discovered_delta or failed_delta:
        conn.execute(
            '''UPDATE crawl_runs SET
               fetched_this_run = fetched_this_run + ?,
               discovered_this_run = discovered_this_run + ?,
               failed_this_run = failed_this_run + ?
               WHERE run_id = ?''',
            (fetched_delta, discovered_delta, failed_delta, run_id),
        )


def upsert_url(conn: sqlite3.Connection, *, url: str, url_raw: str, title: str | None,
               category: str, source: str, status: str = 'pending',
               run_id: int) -> tuple[int, bool]:
    """Upsert a URL row. Returns (url_id, was_inserted).

    On conflict: existing status/source are preserved; only first_seen_run_id is
    backfilled if currently NULL.
    """
    existing = conn.execute('SELECT url_id, first_seen_run_id FROM urls WHERE url = ?', (url,)).fetchone()
    if existing:
        if existing['first_seen_run_id'] is None:
            conn.execute('UPDATE urls SET first_seen_run_id = ? WHERE url_id = ?',
                         (run_id, existing['url_id']))
        return existing['url_id'], False

    cur = conn.execute(
        '''INSERT INTO urls
           (url, url_raw, title, category, source, status, first_seen_run_id)
           VALUES (?, ?, ?, ?, ?, ?, ?)''',
        (url, url_raw, title, category, source, status, run_id),
    )
    return cur.lastrowid, True


def record_fetch_success(conn: sqlite3.Connection, *, url_id: int, fetched_at: str,
                         http_status: int, content_bytes: int, content_sha256: str,
                         local_path: str, run_id: int) -> None:
    conn.execute(
        '''UPDATE urls SET
           status = 'fetched', fetched_at = ?, http_status = ?,
           content_bytes = ?, content_sha256 = ?, local_path = ?,
           last_fetched_run_id = ?, attempts = 0, last_error = NULL, next_retry_at = NULL
           WHERE url_id = ?''',
        (fetched_at, http_status, content_bytes, content_sha256, local_path, run_id, url_id),
    )


_BACKOFF_SECONDS = [60, 300, 1800]  # 60s, 5 min, 30 min


def record_fetch_failure(conn: sqlite3.Connection, *, url_id: int, error: str, now: str) -> None:
    row = conn.execute('SELECT attempts FROM urls WHERE url_id = ?', (url_id,)).fetchone()
    new_attempts = (row['attempts'] if row else 0) + 1

    if new_attempts >= 3:
        new_status = 'failed'
        next_retry_at = None
    else:
        new_status = 'pending'
        backoff = _BACKOFF_SECONDS[new_attempts - 1]
        dt = datetime.now(timezone.utc) + timedelta(seconds=backoff)
        next_retry_at = dt.strftime('%Y-%m-%dT%H:%M:%SZ')

    conn.execute(
        '''UPDATE urls SET attempts = ?, last_error = ?, status = ?, next_retry_at = ?
           WHERE url_id = ?''',
        (new_attempts, error[:500], new_status, next_retry_at, url_id),
    )


def upsert_edge(conn: sqlite3.Connection, *, from_url_id: int,
                to_url_id: int, anchor_text: str) -> None:
    conn.execute(
        '''INSERT OR IGNORE INTO edges (from_url_id, to_url_id, anchor_text)
           VALUES (?, ?, ?)''',
        (from_url_id, to_url_id, anchor_text),
    )


def next_pending_url(conn: sqlite3.Connection, now: str) -> sqlite3.Row | None:
    return conn.execute(
        '''SELECT url_id, url, title, category FROM urls
           WHERE status = 'pending'
             AND (next_retry_at IS NULL OR next_retry_at <= ?)
           ORDER BY url_id ASC
           LIMIT 1''',
        (now,),
    ).fetchone()
