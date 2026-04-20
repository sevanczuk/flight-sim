"""One-shot migration: re-categorize all DB rows using the updated categorize() logic.

Usage:
    python scripts/amapi_crawler_recategorize.py [--dry-run]

Idempotent — a second run finds zero changes.
"""
import argparse
import sqlite3
import sys
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from amapi_crawler_lib.categorize import categorize, should_queue
from amapi_crawler_lib.normalize import title_from_url

DB_PATH = Path("assets/air_manager_api/crawl.sqlite3")


def run(dry_run: bool = False) -> None:
    con = sqlite3.connect(str(DB_PATH))
    con.row_factory = sqlite3.Row

    rows = con.execute(
        "SELECT url_id, url, title, category, status FROM urls"
    ).fetchall()

    promoted = 0   # out-of-scope → pending (was never fetched)
    demoted = 0    # queue-eligible → out-of-scope
    cat_only = 0   # category updated, status unchanged (already fetched)
    unchanged = 0

    updates: list[tuple[str, str, int]] = []  # (new_category, new_status, url_id)

    for row in rows:
        url_id = row["url_id"]
        url = row["url"]
        old_cat = row["category"] or ""
        old_status = row["status"]

        title = row["title"] or title_from_url(url)
        new_cat = categorize(title, url)

        if new_cat == old_cat:
            unchanged += 1
            continue

        new_status = old_status
        if old_status == "out-of-scope" and should_queue(new_cat):
            new_status = "pending"
            promoted += 1
        elif old_status not in ("out-of-scope", "fetched", "failed") and not should_queue(new_cat):
            new_status = "out-of-scope"
            demoted += 1
        else:
            cat_only += 1

        updates.append((new_cat, new_status, url_id))

    # --- Legacy redlink URL migration ---
    # Pre-normalization-fix entries may have redlink=1 in their stored URL.
    # Pending ones will never succeed (MediaWiki returns 404 for wanted pages).
    redlink_rows = con.execute(
        "SELECT url_id, url, status FROM urls WHERE url LIKE '%redlink=1%'"
    ).fetchall()
    redlink_updates: list[tuple[int]] = []
    for row in redlink_rows:
        if row["status"] == "pending":
            redlink_updates.append((row["url_id"],))

    print(
        f"Re-categorization plan: {promoted} promoted to pending, "
        f"{demoted} demoted to out-of-scope, "
        f"{cat_only} category-only updates, "
        f"{unchanged} unchanged"
    )
    print(f"Legacy redlink-URL migration: {len(redlink_updates)} pending redlink URLs -> out-of-scope")

    if dry_run:
        print("(dry-run — no changes written)")
        con.close()
        return

    with con:
        for new_cat, new_status, url_id in updates:
            con.execute(
                "UPDATE urls SET category = ?, status = ? WHERE url_id = ?",
                (new_cat, new_status, url_id),
            )

        for (url_id,) in redlink_updates:
            con.execute(
                "UPDATE urls SET status = 'out-of-scope', category = 'redlink' WHERE url_id = ?",
                (url_id,),
            )

        # Record migration in crawl_runs
        now = datetime.now(timezone.utc).isoformat()
        con.execute(
            """INSERT INTO crawl_runs
               (started_at, ended_at, seed_url_count, fetched_this_run,
                discovered_this_run, failed_this_run, notes)
               VALUES (?, ?, 0, 0, 0, 0, ?)""",
            (
                now, now,
                f"AMAPI-CRAWLER-BUGFIX-03 recategorization: "
                f"{promoted} promoted, {demoted} demoted, {cat_only} cat-only, "
                f"{len(redlink_updates)} legacy-redlinks out-of-scope",
            ),
        )

    total = promoted + demoted + cat_only
    print(f"re-categorized {total} rows ({promoted} promoted to pending, {demoted} demoted to out-of-scope, {cat_only} category-only update)")
    print(f"legacy redlink migration: {len(redlink_updates)} rows marked out-of-scope")


def main() -> None:
    parser = argparse.ArgumentParser(description="Re-categorize all DB rows")
    parser.add_argument("--dry-run", action="store_true", help="Print plan without writing")
    args = parser.parse_args()
    run(dry_run=args.dry_run)


if __name__ == "__main__":
    main()
