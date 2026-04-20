"""AMAPI wiki crawler — resumable, polite, SQLite-backed (AMAPI-CRAWLER-01)."""
import argparse
import hashlib
import os
import sys
import time
import traceback
import urllib.robotparser
from datetime import datetime, timezone
from pathlib import Path

# Allow running as script from any CWD
sys.path.insert(0, str(Path(__file__).parent))

from amapi_crawler_lib.db import (
    connect, ensure_schema, start_crawl_run, end_crawl_run, update_run_counts,
    upsert_url, record_fetch_success, record_fetch_failure, upsert_edge,
    next_pending_url,
)
from amapi_crawler_lib.normalize import normalize, title_from_url
from amapi_crawler_lib.categorize import categorize, should_queue
from amapi_crawler_lib.filename import url_to_filename
from amapi_crawler_lib.fetch import fetch_page
from amapi_crawler_lib.importer import import_mirror
from amapi_crawler_lib.parse import extract_links


def _now_iso() -> str:
    return datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')


def _sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def _log(msg: str, log_path: str) -> None:
    ts = _now_iso()
    line = f'[{ts}] {msg}'
    print(line)
    with open(log_path, 'a', encoding='utf-8') as f:
        f.write(line + '\n')


def _write_completion_report(path: str, stats: dict) -> None:
    ts = _now_iso()
    lines = [
        '---',
        f'Created: {ts}',
        f'Source: docs/tasks/amapi_crawler_prompt.md',
        '---',
        '',
        '# AMAPI Crawler Completion Report',
        '',
        f'**Stop reason:** {stats.get("stop_reason", "unknown")}',
        f'**Duration:** {stats.get("duration_str", "?")}',
        '',
        '## URL counts by source and status',
        '',
    ]
    for row in stats.get('source_status', []):
        lines.append(f'- source={row[0]}, status={row[1]}: {row[2]}')
    lines += [
        '',
        f'## Top 10 categories',
        '',
    ]
    for row in stats.get('top_categories', []):
        lines.append(f'- {row[0]}: {row[1]}')
    lines += [
        '',
        f'**Total bytes this run:** {stats.get("total_bytes", 0):,}',
        f'**Discovered this run:** {stats.get("discovered", 0)}',
        f'**Failed this run:** {stats.get("failed", 0)}',
    ]
    with open(path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines) + '\n')


def _collect_stats(conn, run_id: int, start_time: float, stop_reason: str,
                   total_bytes: int, discovered: int, failed: int) -> dict:
    elapsed = time.monotonic() - start_time
    minutes, seconds = divmod(int(elapsed), 60)
    hours, minutes = divmod(minutes, 60)
    duration_str = f'{hours}h {minutes}m {seconds}s'

    source_status = conn.execute(
        'SELECT source, status, COUNT(*) as n FROM urls GROUP BY source, status ORDER BY source, status'
    ).fetchall()
    top_categories = conn.execute(
        'SELECT category, COUNT(*) as n FROM urls GROUP BY category ORDER BY n DESC LIMIT 10'
    ).fetchall()

    return {
        'stop_reason': stop_reason,
        'duration_str': duration_str,
        'source_status': [(r['source'], r['status'], r['n']) for r in source_status],
        'top_categories': [(r['category'], r['n']) for r in top_categories],
        'total_bytes': total_bytes,
        'discovered': discovered,
        'failed': failed,
    }


def _load_robots_parser(user_agent: str, log_path: str, verify: bool | str = True):
    """Fetch robots.txt and return a RobotFileParser, or None if not found / unreachable."""
    import requests
    robots_url = 'https://wiki.siminnovations.com/robots.txt'
    try:
        resp = requests.get(robots_url, headers={'User-Agent': user_agent}, timeout=10, verify=verify)
        if resp.status_code == 404 or not resp.content.strip():
            _log('robots.txt: not found — no restrictions apply', log_path)
            return None
        rfp = urllib.robotparser.RobotFileParser()
        rfp.parse(resp.text.splitlines())
        num_entries = len(rfp.entries) if hasattr(rfp, 'entries') else '?'
        _log(f'robots.txt: loaded; {num_entries} rules applied', log_path)
        return rfp
    except Exception as e:
        _log(f'robots.txt: fetch warning ({type(e).__name__}) — proceeding without restrictions', log_path)
        return None


def _check_robots(parser, user_agent: str, url: str, url_id: int, conn,
                  log_path: str | None) -> bool:
    """Return True if URL may be fetched. If disallowed: mark out-of-scope in DB, return False."""
    if parser is None or parser.can_fetch(user_agent, url):
        return True
    if log_path:
        _log(f'SKIPPED (robots.txt) {url}', log_path)
    conn.execute(
        "UPDATE urls SET status='out-of-scope', last_error='robots.txt: disallowed' WHERE url_id=?",
        (url_id,),
    )
    conn.commit()
    return False


def _build_progress_line(conn, run_id: int, start_time: float, fetched_this_run: int,
                         discovered_this_run: int, http_counts: dict, net_errors: int) -> str:
    elapsed = time.monotonic() - start_time
    hours, rem = divmod(int(elapsed), 3600)
    mins, secs = divmod(rem, 60)
    elapsed_str = f'{hours}:{mins:02d}:{secs:02d}'

    total_fetched = conn.execute("SELECT COUNT(*) FROM urls WHERE status='fetched'").fetchone()[0]
    pending = conn.execute("SELECT COUNT(*) FROM urls WHERE status='pending'").fetchone()[0]
    discovered_new = conn.execute(
        "SELECT COUNT(*) FROM urls WHERE first_seen_run_id=? AND source='discovered'",
        (run_id,),
    ).fetchone()[0]

    http_parts = [f'{code}={cnt}' for code, cnt in sorted(http_counts.items())]
    if net_errors:
        http_parts.append(f'err={net_errors}')
    http_str = ' '.join(http_parts) if http_parts else 'none'

    elapsed_min = elapsed / 60
    rate = round(fetched_this_run / elapsed_min, 1) if elapsed_min > 0 else 0.0

    return (
        f'[{elapsed_str} elapsed] fetched: {fetched_this_run} new / {total_fetched} total  |  '
        f'HTTP: {http_str}  |  queue: {pending} pending  |  '
        f'discovered: {discovered_new} new  |  rate: {rate}/min'
    )


def resolve_verify(args, log_path: str) -> bool | str:
    """Determine the effective TLS verify value from CLI flags.

    Priority: --insecure > --ca-bundle > project PEM > certifi default.
    Returns False (skip verification), a path string (CA bundle), or True (certifi).
    """
    import sys as _sys
    project_pem = Path('assets/air_manager_api/wiki-cert-chain.pem')

    if args.insecure and args.ca_bundle:
        _log('WARNING: both --insecure and --ca-bundle specified; --insecure wins', log_path)

    if args.insecure:
        _log('WARNING: TLS certificate verification DISABLED via --insecure flag', log_path)
        import urllib3
        urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
        _sys.stderr.write('WARNING: running with --insecure; TLS verification is OFF\n')
        return False

    if args.ca_bundle:
        bundle_path = Path(args.ca_bundle)
        if not bundle_path.exists():
            raise SystemExit(f'ERROR: --ca-bundle path does not exist: {bundle_path}')
        _log(f'TLS: using CA bundle from {bundle_path}', log_path)
        return str(bundle_path)

    if project_pem.exists():
        _log(f'TLS: using project CA bundle at {project_pem}', log_path)
        return str(project_pem)

    _log('TLS: using certifi default CA bundle', log_path)
    return True


def main() -> None:
    parser = argparse.ArgumentParser(description='AMAPI wiki crawler')
    parser.add_argument('--db', default='assets/air_manager_api/crawl.sqlite3')
    parser.add_argument('--mirror', default='assets/air_manager_api/wiki.siminnovations.com')
    parser.add_argument('--seeds', default='assets/air_manager_api/air_manager_wiki_urls.txt')
    parser.add_argument('--user-agent-file', default='assets/air_manager_api/user-agent.txt')
    parser.add_argument('--log', default='assets/air_manager_api/crawl_log.txt')
    parser.add_argument('--max-wall-clock-hours', type=float, default=4.0)
    parser.add_argument('--min-delay-seconds', type=float, default=1.0)
    parser.add_argument('--import-only', action='store_true',
                        help='Import pre-existing mirror and seeds, then exit without fetching')
    parser.add_argument('--dry-run', action='store_true',
                        help='Show pending URL counts without fetching')
    parser.add_argument('--progress-refresh-seconds', type=float, default=60.0,
                        help='Seconds between stderr progress-line refreshes (0 to disable)')
    parser.add_argument('--ca-bundle', type=str, default=None,
                        help='Path to a CA bundle PEM file for TLS verification')
    parser.add_argument('--insecure', action='store_true', default=False,
                        help='Disable TLS certificate verification (last-resort escape hatch)')
    args = parser.parse_args()

    log_path = args.log
    os.makedirs(os.path.dirname(log_path), exist_ok=True)

    verify = resolve_verify(args, log_path)

    with open(args.user_agent_file, 'r', encoding='utf-8') as f:
        user_agent = f.read().strip()

    conn = connect(args.db)
    ensure_schema(conn)

    _log('Crawler started', log_path)

    # Determine if this is the first run (no prior crawl_runs rows)
    prior_runs = conn.execute('SELECT COUNT(*) FROM crawl_runs').fetchone()[0]
    is_first_run = prior_runs == 0

    if is_first_run or args.import_only:
        _log('Running pre-existing mirror import...', log_path)
        import_run_id = start_crawl_run(conn, notes='pre-existing mirror import')
        import_counts = import_mirror(conn, args.mirror, import_run_id, log_path, args.seeds)
        end_crawl_run(conn, import_run_id, notes=(
            f'imported={import_counts["imported"]}, edges={import_counts["edges_created"]}, '
            f'failures={import_counts["parse_failures"]}'
        ))
        print('\n=== Import Summary ===')
        for row in conn.execute('SELECT source, status, COUNT(*) as n FROM urls GROUP BY source, status'):
            print(f'  source={row["source"]}, status={row["status"]}: {row["n"]}')

    # Seed URL import
    run_id = start_crawl_run(conn, notes='seed import and fetch loop')
    _log(f'New crawl run: run_id={run_id}', log_path)

    seed_count = 0
    with open(args.seeds, 'r', encoding='utf-8') as f:
        for line in f:
            raw_url = line.strip()
            if not raw_url or raw_url.startswith('#'):
                continue
            canonical = normalize(raw_url)
            if canonical is None:
                continue
            title = title_from_url(canonical)
            cat = categorize(title, canonical)
            status = 'pending' if should_queue(cat) else 'out-of-scope'
            upsert_url(conn, url=canonical, url_raw=raw_url, title=title,
                       category=cat, source='seed', status=status, run_id=run_id)
            seed_count += 1

    conn.commit()
    update_run_counts(conn, run_id, seed_url_count=seed_count)
    conn.commit()
    _log(f'Seeds imported: {seed_count} URLs processed', log_path)

    if args.import_only:
        end_crawl_run(conn, run_id, notes='stopped: --import-only flag')
        _log('--import-only: exiting without fetching', log_path)
        return

    if args.dry_run:
        print('\n=== Dry-run: pending URL counts by category ===')
        for row in conn.execute(
            "SELECT category, COUNT(*) as n FROM urls WHERE status='pending' GROUP BY category ORDER BY n DESC"
        ):
            print(f'  {row["category"]}: {row["n"]}')
        total = conn.execute("SELECT COUNT(*) FROM urls WHERE status='pending'").fetchone()[0]
        print(f'  TOTAL pending: {total}')
        end_crawl_run(conn, run_id, notes='stopped: --dry-run flag')
        return

    # Fetch loop
    start_time = time.monotonic()
    max_seconds = args.max_wall_clock_hours * 3600
    total_bytes = 0
    fetched_this_run = 0
    discovered_count = 0
    failed_count = 0
    net_error_count = 0
    http_counts: dict = {}
    stop_reason = 'frontier empty'
    progress_interval = args.progress_refresh_seconds
    last_progress_time = start_time

    robots_parser = _load_robots_parser(user_agent, log_path, verify=verify)

    try:
        while True:
            elapsed = time.monotonic() - start_time
            if elapsed > max_seconds:
                stop_reason = f'wall-clock limit ({args.max_wall_clock_hours}h)'
                break

            row = next_pending_url(conn, _now_iso())
            if row is None:
                stop_reason = 'frontier empty'
                break

            url = row['url']
            url_id = row['url_id']

            if not _check_robots(robots_parser, user_agent, url, url_id, conn, log_path):
                continue

            _log(f'FETCH {url}', log_path)

            try:
                status_code, body = fetch_page(url, user_agent, args.min_delay_seconds, verify=verify)
            except Exception as e:
                error_str = f'{type(e).__name__}: {e}'
                _log(f'FETCH_ERROR {url}: {error_str}', log_path)
                record_fetch_failure(conn, url_id=url_id, error=error_str, now=_now_iso())
                update_run_counts(conn, run_id, failed_delta=1)
                conn.commit()
                failed_count += 1
                net_error_count += 1
                continue

            fetched_at = _now_iso()
            http_counts[status_code] = http_counts.get(status_code, 0) + 1

            if 200 <= status_code < 400:
                # Determine filename and write atomically
                fname = url_to_filename(url)
                local_file = os.path.join(args.mirror, fname)
                tmp_file = local_file + '.tmp'
                os.makedirs(os.path.dirname(local_file) if os.path.dirname(local_file) else args.mirror, exist_ok=True)
                with open(tmp_file, 'wb') as f:
                    f.write(body)
                os.replace(tmp_file, local_file)

                sha = _sha256(body)
                local_path = os.path.relpath(local_file, start=os.path.dirname(args.mirror)).replace('\\', '/')
                record_fetch_success(
                    conn,
                    url_id=url_id,
                    fetched_at=fetched_at,
                    http_status=status_code,
                    content_bytes=len(body),
                    content_sha256=sha,
                    local_path=local_path,
                    run_id=run_id,
                )
                total_bytes += len(body)
                fetched_this_run += 1
                update_run_counts(conn, run_id, fetched_delta=1)

                # Parse and queue discovered URLs
                new_links = 0
                try:
                    links = extract_links(body, url)
                    for raw_link, anchor in links:
                        canonical_link = normalize(raw_link)
                        if canonical_link is None:
                            continue
                        title_link = title_from_url(canonical_link)
                        cat_link = categorize(title_link, canonical_link)
                        status_link = 'pending' if should_queue(cat_link) else 'out-of-scope'
                        to_id, was_inserted = upsert_url(
                            conn,
                            url=canonical_link,
                            url_raw=raw_link,
                            title=title_link,
                            category=cat_link,
                            source='discovered',
                            status=status_link,
                            run_id=run_id,
                        )
                        upsert_edge(conn, from_url_id=url_id, to_url_id=to_id, anchor_text=anchor)
                        if was_inserted:
                            new_links += 1
                            discovered_count += 1
                except Exception as e:
                    _log(f'PARSE_ERROR {url}: {e}', log_path)

                update_run_counts(conn, run_id, discovered_delta=new_links)
                conn.commit()
                _log(f'FETCHED {url} ({len(body)} bytes, {new_links} new links)', log_path)
            else:
                error_str = f'HTTP {status_code}'
                _log(f'FETCH_FAIL {url}: {error_str}', log_path)
                record_fetch_failure(conn, url_id=url_id, error=error_str, now=_now_iso())
                update_run_counts(conn, run_id, failed_delta=1)
                conn.commit()
                failed_count += 1

            # Progress display (carriage-return, stderr)
            if progress_interval > 0 and time.monotonic() - last_progress_time >= progress_interval:
                line = _build_progress_line(conn, run_id, start_time, fetched_this_run,
                                            discovered_count, http_counts, net_error_count)
                sys.stderr.write('\r' + line)
                sys.stderr.flush()
                last_progress_time = time.monotonic()

    except KeyboardInterrupt:
        stop_reason = 'interrupted by user'
        _log('KeyboardInterrupt — ending crawl run cleanly', log_path)

    except Exception as exc:
        stop_reason = f'crashed: {type(exc).__name__}: {exc}'
        _log(f'CRASH: {stop_reason}', log_path)
        _log(traceback.format_exc(), log_path)
        end_crawl_run(conn, run_id, notes=stop_reason)
        raise

    if progress_interval > 0:
        final_line = _build_progress_line(conn, run_id, start_time, fetched_this_run,
                                          discovered_count, http_counts, net_error_count)
        sys.stderr.write('\r' + final_line + f'  |  STOPPED: {stop_reason}\n')
        sys.stderr.flush()

    end_crawl_run(conn, run_id, notes=stop_reason)
    _log(f'Crawl ended: {stop_reason}', log_path)

    stats = _collect_stats(conn, run_id, start_time, stop_reason, total_bytes, discovered_count, failed_count)
    completion_path = os.path.join(os.path.dirname(args.log), 'crawl_complete.md')
    _write_completion_report(completion_path, stats)
    _log(f'Completion report written to {completion_path}', log_path)

    print('\n=== Crawl Summary ===')
    print(f'  Stop reason: {stop_reason}')
    print(f'  Duration: {stats["duration_str"]}')
    print(f'  Bytes this run: {total_bytes:,}')
    print(f'  Discovered: {discovered_count}')
    print(f'  Failed: {failed_count}')


if __name__ == '__main__':
    main()
