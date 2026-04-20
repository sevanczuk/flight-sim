"""Diagnostic for AMAPI crawler post-fetch state.

Reads crawl.sqlite3 and reports:
  - Sample of wiki-other URLs (are we missing API content?)
  - The 3 failed URLs and their errors
  - Category distribution of everything we fetched
  - Any URL patterns in the seed list that never got a row

Run: python scripts/crawl_diagnostic_turn43.py
"""
import sqlite3
from collections import Counter
from pathlib import Path

DB = Path("assets/air_manager_api/crawl.sqlite3")
OUT = Path("assets/air_manager_api/crawl_diagnostic_turn43.txt")

def main():
    conn = sqlite3.connect(DB)
    conn.row_factory = sqlite3.Row
    report = []

    # 1. Total row counts by (category, status)
    report.append("=" * 72)
    report.append("1. ROW COUNTS BY (category, status)")
    report.append("=" * 72)
    rows = conn.execute("""
        SELECT category, status, COUNT(*) AS n
        FROM urls
        GROUP BY category, status
        ORDER BY category, status
    """).fetchall()
    for r in rows:
        report.append(f"  {r['category']:30s} {r['status']:15s} {r['n']:>6d}")

    # 2. Sample of wiki-other URLs (titles only)
    report.append("")
    report.append("=" * 72)
    report.append("2. SAMPLE OF wiki-other URLs (first 60 by title)")
    report.append("=" * 72)
    rows = conn.execute("""
        SELECT title, url
        FROM urls
        WHERE category = 'wiki-other'
        ORDER BY title
        LIMIT 60
    """).fetchall()
    for r in rows:
        title_display = r['title'] if r['title'] else '(no title)'
        report.append(f"  {title_display}")

    # 3. Failed URLs
    report.append("")
    report.append("=" * 72)
    report.append("3. FAILED URLs (status = 'failed' OR http_status >= 400)")
    report.append("   [redlink=1 flagged — MediaWiki redlinks always 404 by design]")
    report.append("=" * 72)
    rows = conn.execute("""
        SELECT url, http_status, last_error, attempts
        FROM urls
        WHERE status = 'failed' OR (http_status IS NOT NULL AND http_status >= 400)
        ORDER BY url
    """).fetchall()
    if not rows:
        report.append("  (none)")
    for r in rows:
        flag = " [REDLINK]" if 'redlink=1' in (r['url'] or '') else ""
        report.append(f"  {r['url']}{flag}")
        report.append(f"    http_status={r['http_status']} attempts={r['attempts']} last_error={r['last_error']}")

    # 3b. Redlink URLs across all statuses
    report.append("")
    report.append("=" * 72)
    report.append("3b. REDLINK URLs across entire DB (query contains 'redlink=1')")
    report.append("=" * 72)
    rows = conn.execute("""
        SELECT url, status, http_status, category
        FROM urls
        WHERE url LIKE '%redlink=1%'
        ORDER BY url
    """).fetchall()
    if not rows:
        report.append("  (none)")
    else:
        report.append(f"  Total redlink URLs: {len(rows)}")
        report.append("")
        # Count by (status, http_status)
        status_counter = Counter()
        for r in rows:
            key = f"{r['status']}/{r['http_status']}"
            status_counter[key] += 1
        report.append("  Breakdown by status/http_status:")
        for k, v in sorted(status_counter.items()):
            report.append(f"    {k:30s} {v:>4d}")
        report.append("")
        report.append("  First 20 redlink URLs:")
        for r in rows[:20]:
            report.append(f"    [{r['status']:15s} {str(r['http_status']):>5s}] {r['url']}")
        if len(rows) > 20:
            report.append(f"    ... and {len(rows) - 20} more")

    # 3c. Duplicate-check: is any redlink URL's NON-redlink variant also in the DB?
    report.append("")
    report.append("=" * 72)
    report.append("3c. NORMALIZATION IMPACT: do redlink URLs have non-redlink twins?")
    report.append("    (if yes, we're wasting frontier slots on duplicates)")
    report.append("=" * 72)
    rows = conn.execute("SELECT url FROM urls WHERE url LIKE '%redlink=1%'").fetchall()
    twin_count = 0
    for r in rows:
        url = r['url']
        # Construct the non-redlink variant by stripping redlink=1
        stripped = url.replace('&redlink=1', '').replace('?redlink=1&', '?').replace('?redlink=1', '')
        if stripped == url:
            continue
        twin_exists = conn.execute(
            "SELECT 1 FROM urls WHERE url = ? LIMIT 1", (stripped,)
        ).fetchone()
        if twin_exists:
            twin_count += 1
    report.append(f"  Redlink URLs with a non-redlink twin in the DB: {twin_count}")

    # 4. First-token prefix distribution of wiki-other titles
    # (to find patterns in what's being treated as non-API)
    report.append("")
    report.append("=" * 72)
    report.append("4. FIRST-TOKEN PREFIX DISTRIBUTION of wiki-other titles")
    report.append("   (useful for spotting API prefixes we missed)")
    report.append("=" * 72)
    prefix_counter = Counter()
    rows = conn.execute("SELECT title FROM urls WHERE category = 'wiki-other'").fetchall()
    for r in rows:
        t = r['title'] or ''
        prefix = t.split('_', 1)[0] if '_' in t else t
        prefix_counter[prefix] += 1
    for prefix, count in prefix_counter.most_common(40):
        report.append(f"  {prefix:40s} {count:>6d}")

    # 5. Did every seed URL end up in the DB?
    report.append("")
    report.append("=" * 72)
    report.append("5. SEED URL ACCOUNTING")
    report.append("=" * 72)
    seeds_file = Path("assets/air_manager_api/air_manager_wiki_urls.txt")
    with open(seeds_file) as f:
        seed_lines = [line.strip() for line in f if line.strip()]
    report.append(f"  Seed file: {len(seed_lines)} non-blank lines, {len(set(seed_lines))} unique")

    # 6. Sample of successfully fetched pages — byte sizes (sanity check)
    report.append("")
    report.append("=" * 72)
    report.append("6. BYTE SIZES of 20 randomly-sampled successfully-fetched pages")
    report.append("   (tiny values would suggest redirect/login pages, not content)")
    report.append("=" * 72)
    rows = conn.execute("""
        SELECT title, content_bytes
        FROM urls
        WHERE status='fetched' AND source='seed'
        ORDER BY RANDOM()
        LIMIT 20
    """).fetchall()
    for r in rows:
        report.append(f"  {r['content_bytes']:>8d} bytes  {r['title']}")

    # 7. Page size distribution for all fetched URLs
    report.append("")
    report.append("=" * 72)
    report.append("7. CONTENT BYTE SIZE DISTRIBUTION (all fetched)")
    report.append("=" * 72)
    rows = conn.execute("""
        SELECT content_bytes FROM urls WHERE status='fetched' AND content_bytes IS NOT NULL
    """).fetchall()
    sizes = sorted([r['content_bytes'] for r in rows])
    if sizes:
        n = len(sizes)
        report.append(f"  Count: {n}")
        report.append(f"  Min:   {sizes[0]:>8d}")
        report.append(f"  p25:   {sizes[n//4]:>8d}")
        report.append(f"  p50:   {sizes[n//2]:>8d}")
        report.append(f"  p75:   {sizes[3*n//4]:>8d}")
        report.append(f"  Max:   {sizes[-1]:>8d}")

    text = '\n'.join(report)
    OUT.write_text(text)
    print(text)
    print()
    print(f"Report saved to: {OUT}")

if __name__ == "__main__":
    main()
