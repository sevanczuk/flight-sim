"""AMAPI Parser — extract structured API reference from fetched HTML.

Usage:
  python scripts/amapi_parser.py [--dry-run] [--filter PATTERN] [--output-dir DIR]
"""

import argparse
import json
import os
import re
import sqlite3
import sys
from datetime import datetime, timezone

# Allow importing from scripts/amapi_parser_lib when run as a script
_SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
if _SCRIPT_DIR not in sys.path:
    sys.path.insert(0, _SCRIPT_DIR)

from amapi_parser_lib.page_classifier import classify_page
from amapi_parser_lib.function_page_parser import parse_function_page
from amapi_parser_lib.catalog_page_parser import parse_catalog_page
from amapi_parser_lib.markdown_renderer import render_function_markdown, render_index_markdown

_PROJECT_ROOT = os.path.dirname(_SCRIPT_DIR)
_DB_PATH = os.path.join(_PROJECT_ROOT, 'assets', 'air_manager_api', 'crawl.sqlite3')
_DEFAULT_OUTPUT_DIR = os.path.join(_PROJECT_ROOT, 'assets', 'air_manager_api', 'parsed')
_DOCS_DIR = os.path.join(_PROJECT_ROOT, 'docs', 'reference', 'amapi')

_SKIP_CATEGORIES = frozenset({'file', 'special', 'redlink', 'external', 'youtube'})

_PROVENANCE_TS = '2026-04-20T00:00:00-04:00'


def _now_iso() -> str:
    return _PROVENANCE_TS


def _write_json(path: str, data: dict, dry_run: bool = False) -> None:
    if dry_run:
        return
    os.makedirs(os.path.dirname(path), exist_ok=True)
    tmp = path + '.tmp'
    with open(tmp, 'w', encoding='utf-8') as f:
        json.dump(data, f, sort_keys=True, indent=2, ensure_ascii=False)
    os.replace(tmp, path)


def _write_text(path: str, content: str, dry_run: bool = False) -> None:
    if dry_run:
        return
    os.makedirs(os.path.dirname(path), exist_ok=True)
    tmp = path + '.tmp'
    with open(tmp, 'w', encoding='utf-8') as f:
        f.write(content)
    os.replace(tmp, path)


def _one_line_description(record: dict) -> str:
    """Extract a one-line description from a function record."""
    desc = record.get('description', '')
    if not desc:
        return ''
    # Take first sentence
    m = re.match(r'([^.!?]+[.!?])', desc)
    if m:
        return m.group(1).strip()
    return desc[:120].strip()


def run(dry_run: bool = False, filter_pattern: str = None, output_dir: str = None):
    if output_dir is None:
        output_dir = _DEFAULT_OUTPUT_DIR

    by_fn_dir = os.path.join(output_dir, 'by_function')
    docs_by_fn_dir = os.path.join(_DOCS_DIR, 'by_function')

    conn = sqlite3.connect(_DB_PATH)
    rows = conn.execute(
        "SELECT title, url, local_path, category FROM urls WHERE status = 'fetched'"
    ).fetchall()
    conn.close()

    # Filter out skip categories and apply optional pattern filter
    rows = [r for r in rows if (r[3] or '') not in _SKIP_CATEGORIES]
    if filter_pattern:
        pat = re.compile(filter_pattern, re.IGNORECASE)
        rows = [r for r in rows if r[0] and pat.search(r[0])]

    print(f'Processing {len(rows)} pages...')

    all_records = []
    function_records = []
    catalog_records = []
    tutorial_records = []
    non_content_records = []
    unknown_records = []
    warnings_list = []

    for title, url, local_path, category in rows:
        if not title:
            title = os.path.basename(local_path or '').replace('index.php@title=', '')

        full_path = os.path.join(_PROJECT_ROOT, 'assets', 'air_manager_api', local_path) if local_path else None
        if not full_path or not os.path.exists(full_path):
            print(f'  SKIP (file not found): {title}')
            continue

        with open(full_path, encoding='utf-8', errors='replace') as f:
            html = f.read()

        classification = classify_page(html, title, category or '')
        shape = classification['shape']

        if shape == 'function':
            record = parse_function_page(html, title, url or '', local_path or '')
            record['category'] = category or record.get('category', '')
            record['parsed_at'] = _now_iso()
            function_records.append(record)
            all_records.append(record)
            if record.get('parse_warnings'):
                for w in record['parse_warnings']:
                    warnings_list.append({'page_name': title, 'warning': w})
            json_path = os.path.join(by_fn_dir, f'{title}.json')
            _write_json(json_path, record, dry_run)

        elif shape == 'catalog':
            record = parse_catalog_page(html, title, url or '', local_path or '')
            record['parsed_at'] = _now_iso()
            catalog_records.append(record)
            all_records.append(record)
            json_path = os.path.join(by_fn_dir, f'{title}.json')
            _write_json(json_path, record, dry_run)

        elif shape == 'tutorial':
            stub = {
                'schema_version': '1.0',
                'page_name': title,
                'page_shape': 'tutorial',
                'category': category or '',
                'source_url': url or '',
                'local_path': local_path or '',
                'parsed_at': _now_iso(),
                'parse_status': 'skipped-tutorial',
                'parse_notes': 'Tutorial/manual page; not parsed in depth.',
            }
            tutorial_records.append(stub)
            all_records.append(stub)

        elif shape == 'non-content':
            stub = {
                'schema_version': '1.0',
                'page_name': title,
                'page_shape': 'non-content',
                'category': category or '',
                'source_url': url or '',
                'local_path': local_path or '',
                'parsed_at': _now_iso(),
                'parse_status': 'skipped-non-content',
            }
            non_content_records.append(stub)
            all_records.append(stub)

        else:
            stub = {
                'schema_version': '1.0',
                'page_name': title,
                'page_shape': 'unknown',
                'category': category or '',
                'source_url': url or '',
                'local_path': local_path or '',
                'parsed_at': _now_iso(),
                'parse_status': 'skipped-unknown',
                'signals': classification.get('signals', []),
            }
            unknown_records.append(stub)
            all_records.append(stub)

    # Build known pages set for link resolution
    known_pages = {r['page_name'] for r in all_records if r.get('page_name')}

    # --- Render markdown for function pages ---
    for record in function_records:
        md = render_function_markdown(record, known_pages)
        md_path = os.path.join(docs_by_fn_dir, f'{record["page_name"]}.md')
        _write_text(md_path, md, dry_run)

    # --- Render markdown for catalog pages ---
    for record in catalog_records:
        # Lightweight catalog markdown
        lines = [
            '---',
            f'Created: {_now_iso()}',
            'Source: scripts/amapi_parser.py (parser-generated)',
            f'Page: {record["page_name"]}',
            '---',
            '',
            f'# {record["display_name"]}',
            '',
            f'Catalog page with {len(record.get("sections", []))} sections.',
            '',
        ]
        for sec in record.get('sections', []):
            lines.append(f'## {sec["heading"]}')
            lines.append('')
            for k, v in sec.get('properties', {}).items():
                lines.append(f'- **{k}:** {v}')
            lines.append('')
        md_path = os.path.join(docs_by_fn_dir, f'{record["page_name"]}.md')
        _write_text(md_path, '\n'.join(lines), dry_run)

    # --- Build _index.json ---
    counts_by_shape = {
        'function': len(function_records),
        'catalog': len(catalog_records),
        'tutorial': len(tutorial_records),
        'non-content': len(non_content_records),
        'unknown': len(unknown_records),
    }

    ns_counter: dict = {}
    for r in function_records:
        ns = r.get('namespace_prefix') or 'unprefixed'
        ns_counter[ns] = ns_counter.get(ns, 0) + 1

    index = {
        'schema_version': '1.0',
        'generated_at': _now_iso(),
        'generator': 'scripts/amapi_parser.py',
        'total_pages_processed': len(all_records),
        'counts_by_shape': counts_by_shape,
        'counts_by_namespace': ns_counter,
        'functions': [
            {
                'page_name': r['page_name'],
                'canonical_name': r.get('canonical_name', r['page_name'].lower()),
                'namespace_prefix': r.get('namespace_prefix'),
                'category': r.get('category', ''),
                'parse_status': r.get('parse_status', ''),
                'signature': r.get('signature', ''),
                'one_line_description': _one_line_description(r),
            }
            for r in function_records
        ],
        'catalogs': [
            {
                'page_name': r['page_name'],
                'sections': r.get('sections', []),
                'parse_status': r.get('parse_status', ''),
            }
            for r in catalog_records
        ],
        'tutorials': [
            {'page_name': r['page_name'], 'category': r.get('category', '')}
            for r in tutorial_records
        ],
        'warnings': warnings_list,
    }

    index_path = os.path.join(output_dir, '_index.json')
    _write_json(index_path, index, dry_run)

    # --- Render _index.md ---
    index_md = render_index_markdown(index)
    _write_text(os.path.join(_DOCS_DIR, '_index.md'), index_md, dry_run)

    # --- Write _parser_report.md ---
    _write_parser_report(index, function_records, catalog_records, tutorial_records,
                         non_content_records, unknown_records, warnings_list, dry_run)

    print(f'\nDone. Pages processed: {len(all_records)}')
    print(f'  Functions: {len(function_records)}')
    print(f'  Catalogs:  {len(catalog_records)}')
    print(f'  Tutorials: {len(tutorial_records)}')
    print(f'  Non-content: {len(non_content_records)}')
    print(f'  Unknown:   {len(unknown_records)}')
    print(f'  Warnings:  {len(warnings_list)}')

    return index


def _write_parser_report(index, function_records, catalog_records, tutorial_records,
                         non_content_records, unknown_records, warnings_list, dry_run):
    lines = [
        '---',
        f'Created: {_now_iso()}',
        'Source: scripts/amapi_parser.py (parser-generated)',
        '---',
        '',
        '# AMAPI Parser Report',
        '',
        '## Summary',
        '',
        '| Metric | Count |',
        '|--------|-------|',
        f'| Total pages processed | {index["total_pages_processed"]} |',
        f'| Functions (complete) | {sum(1 for r in function_records if r.get("parse_status") == "complete")} |',
        f'| Functions (partial) | {sum(1 for r in function_records if r.get("parse_status") == "partial")} |',
        f'| Catalogs | {len(catalog_records)} |',
        f'| Tutorials/docs | {len(tutorial_records)} |',
        f'| Non-content | {len(non_content_records)} |',
        f'| Unknown | {len(unknown_records)} |',
        f'| Parse warnings | {len(warnings_list)} |',
        '',
    ]

    # Anomalies
    if warnings_list:
        lines += [
            '## Anomalies',
            '',
            '| Page | Warning |',
            '|------|---------|',
        ]
        for w in warnings_list:
            lines.append(f'| {w["page_name"]} | {w["warning"]} |')
        lines.append('')

    # Unprefixed functions coverage
    unprefixed_fns = [r for r in function_records if r.get('namespace_prefix') is None]
    if unprefixed_fns:
        lines += [
            '## Unprefixed functions coverage',
            '',
            '| Function | Parse status |',
            '|----------|-------------|',
        ]
        for r in sorted(unprefixed_fns, key=lambda x: x['page_name']):
            lines.append(f'| {r["page_name"]} | {r.get("parse_status", "?")} |')
        lines.append('')

    # Cross-reference density
    ref_counter: dict = {}
    for r in function_records:
        for ref in r.get('see_also', []) + r.get('cross_references', []):
            pn = ref.get('page_name', '')
            if pn:
                ref_counter[pn] = ref_counter.get(pn, 0) + 1
    if ref_counter:
        top = sorted(ref_counter.items(), key=lambda x: -x[1])[:20]
        lines += [
            '## Cross-reference density (top 20)',
            '',
            '| Page | Inbound links |',
            '|------|---------------|',
        ]
        for pn, cnt in top:
            lines.append(f'| {pn} | {cnt} |')
        lines.append('')

    # Non-function pages
    lines += [
        '## Non-function pages',
        '',
        f'Tutorials/docs: {len(tutorial_records)}',
        f'Non-content: {len(non_content_records)}',
        f'Unknown: {len(unknown_records)}',
        '',
    ]
    if tutorial_records:
        lines.append('### Tutorials')
        lines.append('')
        for r in sorted(tutorial_records, key=lambda x: x['page_name']):
            lines.append(f'- {r["page_name"]} ({r.get("category", "")})')
        lines.append('')

    _write_text(os.path.join(_DOCS_DIR, '_parser_report.md'), '\n'.join(lines), dry_run)


def main():
    parser = argparse.ArgumentParser(description='AMAPI HTML → structured JSON parser')
    parser.add_argument('--dry-run', action='store_true', help='Parse but do not write output files')
    parser.add_argument('--filter', dest='filter_pattern', help='Regex filter on page title')
    parser.add_argument('--output-dir', default=None, help='Override JSON output directory')
    args = parser.parse_args()
    run(dry_run=args.dry_run, filter_pattern=args.filter_pattern, output_dir=args.output_dir)


if __name__ == '__main__':
    main()
