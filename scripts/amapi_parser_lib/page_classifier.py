"""Classify fetched AMAPI wiki pages by shape."""

import re
from bs4 import BeautifulSoup

_CANONICAL_SECTIONS = frozenset({
    'Description', 'Return_value', 'Return value', 'Arguments',
    'See_also', 'See also',
})

_KNOWN_CATALOG_TITLES = frozenset({'Device_list', 'Hardware_id_list'})

_CATALOG_TYPE_RE = re.compile(r'^\s*(Type|Vendor\s*ID)\s*:', re.IGNORECASE)


def classify_page(html: str, title: str, category: str) -> dict:
    """Return {'shape': ..., 'signals': [...], 'confidence': float}."""
    signals = []

    # Non-content: title prefix (MediaWiki namespaces that aren't API content)
    _NON_CONTENT_PREFIXES = ('File:', 'Special:', 'Talk:', 'User_talk:', 'User:',
                              'Template:', 'Category:', 'Help:', 'MediaWiki:')
    if title and any(title.startswith(p) for p in _NON_CONTENT_PREFIXES):
        return {'shape': 'non-content', 'signals': ['title_prefix_file_or_special'], 'confidence': 1.0}

    # Non-content: category
    if category in ('file', 'special'):
        return {'shape': 'non-content', 'signals': ['category_file_or_special'], 'confidence': 1.0}

    # Known catalog titles (checked before HTML parse for speed)
    if title in _KNOWN_CATALOG_TITLES:
        signals.append('known_catalog_title')
        return {'shape': 'catalog', 'signals': signals, 'confidence': 1.0}

    soup = BeautifulSoup(html, 'lxml')
    content_div = soup.find('div', class_='mw-parser-output')
    if not content_div:
        return {'shape': 'non-content', 'signals': ['no_mw_parser_output'], 'confidence': 0.7}

    # Function signal 1: <pre><b> — canonical API function signature block
    first_pre = content_div.find('pre')
    has_pre_bold = bool(first_pre and first_pre.find('b'))
    if has_pre_bold:
        signals.append('has_pre_bold_signature')

    # Function signal 2: canonical h2 section headers
    h2_ids = []
    for h2 in content_div.find_all('h2'):
        span = h2.find('span', class_='mw-headline')
        if span:
            h2_ids.append(span.get('id', '') or span.get_text())
    canonical_count = sum(1 for hid in h2_ids if hid in _CANONICAL_SECTIONS)
    if canonical_count >= 2:
        signals.append(f'canonical_sections:{canonical_count}')
    elif canonical_count == 1:
        signals.append(f'canonical_sections:1')

    # Catalog signal: "Type: VALUE" in <p> text (Device_list pattern)
    p_texts = [p.get_text() for p in content_div.find_all('p')]
    has_catalog_kv = any(_CATALOG_TYPE_RE.match(t) for t in p_texts)
    if has_catalog_kv:
        signals.append('has_catalog_type_kv')
        return {'shape': 'catalog', 'signals': signals, 'confidence': 0.9}

    # Function classification
    if has_pre_bold and canonical_count >= 1:
        return {'shape': 'function', 'signals': signals, 'confidence': 0.95}
    if has_pre_bold:
        return {'shape': 'function', 'signals': signals, 'confidence': 0.85}
    if canonical_count >= 2:
        return {'shape': 'function', 'signals': signals, 'confidence': 0.80}

    # Tutorial: lots of h3 content (FAQ / manual style), no function markers
    h3_count = len(content_div.find_all('h3'))
    if h3_count >= 3:
        signals.append(f'h3_count:{h3_count}')
        return {'shape': 'tutorial', 'signals': signals, 'confidence': 0.75}

    # Tutorial: multiple h2 headings but no function markers (release notes, manuals, etc.)
    if len(h2_ids) >= 3:
        signals.append(f'h2_count:{len(h2_ids)}')
        return {'shape': 'tutorial', 'signals': signals, 'confidence': 0.70}

    # Tutorial: only free-form paragraphs
    has_any_pre = bool(content_div.find('pre'))
    if not has_any_pre and not h2_ids:
        signals.append('no_structure')
        return {'shape': 'tutorial', 'signals': signals, 'confidence': 0.6}

    # Catch-all: any non-function content is treated as tutorial
    if not has_pre_bold:
        signals.append('no_function_markers')
        return {'shape': 'tutorial', 'signals': signals, 'confidence': 0.55}

    return {'shape': 'unknown', 'signals': signals, 'confidence': 0.5}
