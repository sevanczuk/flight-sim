"""One-shot DB migration: fix source labeling per AMAPI-CRAWLER-BUGFIX-01 item 1.

Rows inserted as source='pre-existing' during Pass 2 of import_mirror were
link-discovered URLs, not files on disk. Per D-03, source='pre-existing' is
reserved for URLs whose HTML file physically exists in the mirror. This script
corrects the labels: seed URLs → 'seed', everything else → 'discovered'.

Idempotent: the WHERE clause (source='pre-existing' AND local_path IS NULL)
selects nothing on a second run since updated rows get the correct source.
"""
import sys
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from amapi_crawler_lib.normalize import normalize
from amapi_crawler_lib.db import connect

SEEDS_PATH = 'assets/air_manager_api/air_manager_wiki_urls.txt'
DB_PATH = 'assets/air_manager_api/crawl.sqlite3'


def load_seed_set(seeds_path: str) -> set:
    seed_set: set = set()
    with open(seeds_path, 'r', encoding='utf-8') as f:
        for line in f:
            raw = line.strip()
            if not raw or raw.startswith('#'):
                continue
            canonical = normalize(raw)
            if canonical:
                seed_set.add(canonical)
    return seed_set


def print_counts(conn, label: str) -> None:
    print(f'\n{label}:')
    for row in conn.execute(
        'SELECT source, status, COUNT(*) FROM urls GROUP BY source, status ORDER BY source, status'
    ):
        print(f'  {row[0]}|{row[1]}: {row[2]}')


def main() -> None:
    conn = connect(DB_PATH)
    seed_set = load_seed_set(SEEDS_PATH)
    print(f'Loaded {len(seed_set)} seed URLs')

    print_counts(conn, 'Before migration')

    rows = conn.execute(
        "SELECT url_id, url FROM urls WHERE source='pre-existing' AND local_path IS NULL"
    ).fetchall()

    if not rows:
        print('\nNothing to migrate — already idempotent.')
        return

    seed_count = sum(1 for r in rows if r['url'] in seed_set)
    discovered_count = len(rows) - seed_count
    print(f'\nRows to migrate: {len(rows)} total')
    print(f'  -> seed:       {seed_count}')
    print(f'  -> discovered: {discovered_count}')

    now = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
    with conn:
        for row in rows:
            new_source = 'seed' if row['url'] in seed_set else 'discovered'
            conn.execute(
                'UPDATE urls SET source=? WHERE url_id=?',
                (new_source, row['url_id']),
            )
        conn.execute(
            'INSERT INTO crawl_runs (started_at, ended_at, notes) VALUES (?, ?, ?)',
            (now, now, 'source-labeling migration per AMAPI-CRAWLER-BUGFIX-01 item 1'),
        )

    print_counts(conn, 'After migration')

    remaining = conn.execute(
        "SELECT COUNT(*) FROM urls WHERE source='pre-existing' AND local_path IS NULL"
    ).fetchone()[0]
    print(f"\nVerification: pre-existing rows with local_path IS NULL: {remaining} (expect 0)")


if __name__ == '__main__':
    main()
