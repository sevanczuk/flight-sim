"""Pre-existing mirror import logic (per D-03 §Pre-existing Mirror Reconstruction)."""
import hashlib
import os
from datetime import datetime, timezone

from .normalize import normalize, title_from_url
from .categorize import categorize, should_queue
from .filename import filename_to_url
from .parse import extract_links
from .db import upsert_url, record_fetch_success, upsert_edge

_SKIP_EXTENSIONS = {'.png', '.jpg', '.jpeg', '.gif', '.svg', '.ico', '.webp', '.css', '.js',
                    '.txt', '.log', '.md', '.sqlite3', '.bak'}


def _file_mtime_iso(path: str) -> str:
    mtime = os.path.getmtime(path)
    return datetime.fromtimestamp(mtime, tz=timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')


def _sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def import_mirror(conn, mirror_dir: str, run_id: int, log_path: str | None = None) -> dict:
    """Import all pre-existing mirror HTML files into the DB.

    Returns counts: {imported, edges_created, parse_failures}
    """
    counts = {'imported': 0, 'edges_created': 0, 'parse_failures': 0}

    def _log(msg: str) -> None:
        print(msg)
        if log_path:
            with open(log_path, 'a', encoding='utf-8') as f:
                f.write(msg + '\n')

    mirror_abs = os.path.abspath(mirror_dir)
    all_files = sorted(os.listdir(mirror_abs))

    file_url_map: dict[str, tuple[int, str]] = {}  # fname -> (url_id, canonical_url)

    # Pass 1: import each HTML file as a fetched URL
    for fname in all_files:
        fpath = os.path.join(mirror_abs, fname)
        if not os.path.isfile(fpath):
            continue
        if fname.startswith('.'):
            continue
        _, ext = os.path.splitext(fname.lower())
        if ext in _SKIP_EXTENSIONS:
            continue

        if fname == 'index.html':
            raw_url = 'https://wiki.siminnovations.com/'
            canonical = normalize(raw_url) or raw_url
        elif fname.startswith('index.php@title='):
            raw_url = filename_to_url(fname)
            canonical = normalize(raw_url)
            if canonical is None:
                _log(f'SKIP (out-of-scope): {fname}')
                continue
        else:
            continue  # unrecognized pattern

        try:
            with open(fpath, 'rb') as f:
                content = f.read()
        except OSError as e:
            _log(f'ERROR reading {fname}: {e}')
            counts['parse_failures'] += 1
            continue

        title = title_from_url(canonical)
        cat = categorize(title, canonical)
        fetched_at = _file_mtime_iso(fpath)
        sha = _sha256(content)
        size = len(content)
        # Store path relative to assets/ parent of mirror_dir
        local_path = os.path.relpath(fpath, start=os.path.dirname(mirror_abs)).replace('\\', '/')

        url_id, inserted = upsert_url(
            conn,
            url=canonical,
            url_raw=raw_url,
            title=title,
            category=cat,
            source='pre-existing',
            status='fetched',
            run_id=run_id,
        )
        record_fetch_success(
            conn,
            url_id=url_id,
            fetched_at=fetched_at,
            http_status=200,
            content_bytes=size,
            content_sha256=sha,
            local_path=local_path,
            run_id=run_id,
        )
        file_url_map[fname] = (url_id, canonical)
        if inserted:
            counts['imported'] += 1
            _log(f'IMPORT: {canonical} ({size} bytes)')

    conn.commit()

    # Pass 2: parse outbound links from each file and populate edges
    for fname, (from_id, from_url) in file_url_map.items():
        fpath = os.path.join(mirror_abs, fname)
        try:
            with open(fpath, 'rb') as f:
                content = f.read()
        except OSError:
            continue

        try:
            links = extract_links(content, from_url)
        except Exception as e:
            _log(f'PARSE_ERROR {fname}: {e}')
            counts['parse_failures'] += 1
            continue

        for raw_link, anchor in links:
            canonical_link = normalize(raw_link)
            if canonical_link is None:
                continue
            title_link = title_from_url(canonical_link)
            cat_link = categorize(title_link, canonical_link)
            status_link = 'pending' if should_queue(cat_link) else 'out-of-scope'

            to_id, _ = upsert_url(
                conn,
                url=canonical_link,
                url_raw=raw_link,
                title=title_link,
                category=cat_link,
                source='pre-existing',
                status=status_link,
                run_id=run_id,
            )
            upsert_edge(conn, from_url_id=from_id, to_url_id=to_id, anchor_text=anchor)
            counts['edges_created'] += 1

    conn.commit()
    summary = (f'IMPORT SUMMARY: {counts["imported"]} files imported, '
               f'{counts["edges_created"]} edges, {counts["parse_failures"]} failures')
    _log(summary)
    return counts
