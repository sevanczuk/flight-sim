"""Convert parsed AMAPI records to markdown."""

import re


def _resolve_internal_link(page_name: str, display_text: str, known_pages: set, is_redlink: bool = False) -> str:
    if is_redlink or page_name not in known_pages:
        return f'[{display_text}](./{page_name}.md) [missing]'
    return f'[{display_text}](./{page_name}.md)'


def _transform_description_links(description: str, known_pages: set) -> str:
    """Transform [text](page_name) internal links to live .md links."""
    def _replace(m):
        text = m.group(1)
        target = m.group(2)
        if target.startswith('http://') or target.startswith('https://'):
            return f'[{text}]({target})'
        suffix = ' [missing]' if target not in known_pages else ''
        return f'[{text}](./{target}.md){suffix}'

    return re.sub(r'\[([^\]]+)\]\(([^)]+)\)', _replace, description)


def render_function_markdown(record: dict, known_pages: set) -> str:
    """Render a parsed function record to markdown."""
    lines = []

    # Provenance frontmatter
    lines.append('---')
    lines.append(f'Created: {record.get("parsed_at", "2026-04-20T00:00:00-04:00")}')
    lines.append('Source: scripts/amapi_parser.py (parser-generated)')
    lines.append(f'Canonical name: {record["canonical_name"]}')
    ns = record.get("namespace_prefix") or "unprefixed"
    lines.append(f'Namespace: {ns}')
    lines.append(f'Source URL: {record["source_url"]}')
    if record.get('revision_id'):
        lines.append(f'Revision: {record["revision_id"]}')
    lines.append('---')
    lines.append('')

    # Title
    lines.append(f'# {record["display_name"]}')
    lines.append('')

    # Signature
    if record.get('signature'):
        lines.append('## Signature')
        lines.append('')
        lines.append('```')
        lines.append(record['signature'])
        lines.append('```')
        lines.append('')

    # Description
    if record.get('description'):
        lines.append('## Description')
        lines.append('')
        desc = _transform_description_links(record['description'], known_pages)
        lines.append(desc)
        lines.append('')

    # Return value
    rv = record.get('return_value', {})
    if rv and rv.get('text'):
        lines.append('## Return value')
        lines.append('')
        lines.append(rv['text'])
        lines.append('')

    # Arguments
    args = record.get('arguments', [])
    if args:
        lines.append('## Arguments')
        lines.append('')
        lines.append('| # | Argument | Type | Description |')
        lines.append('|---|----------|------|-------------|')
        for arg in args:
            pos = arg.get('position', '')
            name = f'`{arg.get("name", "")}`'
            typ = arg.get('type', '')
            desc = arg.get('description', '')
            lines.append(f'| {pos} | {name} | {typ} | {desc} |')
        lines.append('')

    # Examples
    examples = record.get('examples', [])
    if examples:
        lines.append('## Examples')
        lines.append('')
        for ex in examples:
            label = ex.get('section_label', 'Example')
            lang = ex.get('language', 'lua')
            code = ex.get('code', '')
            lines.append(f'### {label}')
            lines.append('')
            lines.append(f'```{lang}')
            lines.append(code)
            lines.append('```')
            lines.append('')

    # See also
    see_also = record.get('see_also', [])
    if see_also:
        lines.append('## See also')
        lines.append('')
        for ref in see_also:
            pn = ref['page_name']
            dt = ref.get('display_text', pn.replace('_', ' '))
            is_redlink = ref.get('is_redlink', False)
            lines.append(f'- {_resolve_internal_link(pn, dt, known_pages, is_redlink)}')
        lines.append('')

    # External references
    ext_refs = record.get('external_references', [])
    if ext_refs:
        lines.append('## External references')
        lines.append('')
        for ref in ext_refs:
            url = ref.get('url', '')
            dt = ref.get('display_text', url)
            lines.append(f'- [{dt}]({url})')
        lines.append('')

    return '\n'.join(lines)


def render_index_markdown(index: dict) -> str:
    """Render _index.json to a human-readable catalog markdown."""
    lines = []

    total_fn = len(index.get('functions', []))
    total = index.get('total_pages_processed', 0)

    lines.append('---')
    lines.append(f'Created: {index.get("generated_at", "2026-04-20T00:00:00-04:00")}')
    lines.append('Source: scripts/amapi_parser.py (parser-generated)')
    lines.append(f'Total functions: {total_fn}')
    lines.append(f'Total pages: {total}')
    lines.append('---')
    lines.append('')
    lines.append('# AMAPI Reference — Catalog Index')
    lines.append('')
    lines.append(f'Generated from `assets/air_manager_api/parsed/_index.json`.')
    lines.append('')

    # Group functions by namespace
    functions = index.get('functions', [])
    ns_map: dict = {}
    unprefixed = []
    for fn in functions:
        ns = fn.get('namespace_prefix')
        if ns:
            ns_map.setdefault(ns, []).append(fn)
        else:
            unprefixed.append(fn)

    lines.append('## By namespace')
    lines.append('')
    for ns in sorted(ns_map.keys()):
        fns = ns_map[ns]
        lines.append(f'### {ns} ({len(fns)} functions)')
        lines.append('')
        for fn in sorted(fns, key=lambda x: x['page_name']):
            pn = fn['page_name']
            sig = fn.get('signature', '')
            if sig:
                sig_str = f'`{sig}`'
            else:
                sig_str = ''
            desc = fn.get('one_line_description', '')
            parts = [f'- [{pn}](by_function/{pn}.md)']
            if sig_str:
                parts.append(f'— {sig_str}')
            if desc:
                parts.append(f'— {desc}')
            lines.append(' '.join(parts))
        lines.append('')

    if unprefixed:
        lines.append(f'## Unprefixed API functions ({len(unprefixed)})')
        lines.append('')
        for fn in sorted(unprefixed, key=lambda x: x['page_name']):
            pn = fn['page_name']
            sig = fn.get('signature', '')
            sig_str = f'`{sig}`' if sig else ''
            desc = fn.get('one_line_description', '')
            parts = [f'- [{pn}](by_function/{pn}.md)']
            if sig_str:
                parts.append(f'— {sig_str}')
            if desc:
                parts.append(f'— {desc}')
            lines.append(' '.join(parts))
        lines.append('')

    # Catalog pages
    catalogs = index.get('catalogs', [])
    if catalogs:
        lines.append(f'## Catalog pages ({len(catalogs)})')
        lines.append('')
        for cat in catalogs:
            pn = cat['page_name']
            n = len(cat.get('sections', []))
            lines.append(f'- [{pn}](by_function/{pn}.md) — {n} entries.')
        lines.append('')

    return '\n'.join(lines)
