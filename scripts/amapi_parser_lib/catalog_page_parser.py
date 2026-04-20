"""Parse AMAPI catalog pages (Device_list, Hardware_id_list) into structured dicts."""

import re
from bs4 import BeautifulSoup, NavigableString, Tag

_RLCONF_RE = re.compile(r'RLCONF\s*=\s*\{.*?', re.DOTALL)
_ARTICLE_ID_RE = re.compile(r'"wgArticleId"\s*:\s*(\d+)')
_REVISION_ID_RE = re.compile(r'"wgCurRevisionId"\s*:\s*(\d+)')


def _extract_meta(html: str) -> dict:
    article_id = _ARTICLE_ID_RE.search(html)
    revision_id = _REVISION_ID_RE.search(html)
    return {
        'article_id': int(article_id.group(1)) if article_id else None,
        'revision_id': int(revision_id.group(1)) if revision_id else None,
    }


def _kv_from_p(p_elem) -> dict:
    """Extract key-value pairs from <p> text like 'Type: VALUE\\nVendor ID: 0x1234'."""
    props = {}
    text = p_elem.get_text(separator='\n')
    for line in text.splitlines():
        m = re.match(r'^([A-Za-z][A-Za-z0-9_ ]*?)\s*:\s*(.+)$', line.strip())
        if m:
            key = m.group(1).strip()
            val = m.group(2).strip()
            props[key] = val
    return props


def parse_catalog_page(html: str, title: str, url: str, local_path: str) -> dict:
    """Parse a catalog page into a structured dict."""
    meta = _extract_meta(html)
    soup = BeautifulSoup(html, 'lxml')

    h1 = soup.find('h1', id='firstHeading')
    display_name = h1.get_text(strip=True) if h1 else title.replace('_', ' ')

    content_div = soup.find('div', class_='mw-parser-output')
    cross_refs = []
    ext_refs = []
    sections = []
    warnings = []

    if content_div:
        current_section_id = None
        current_heading = None
        current_p_elements = []
        current_html_len = 0

        def _flush_section():
            if current_section_id is None:
                return
            props = {}
            for p in current_p_elements:
                props.update(_kv_from_p(p))
            sections.append({
                'section_id': current_section_id,
                'heading': current_heading,
                'properties': props,
                'raw_html_length': current_html_len,
            })

        for elem in content_div.children:
            if isinstance(elem, NavigableString):
                continue
            if elem.name == 'h2':
                _flush_section()
                span = elem.find('span', class_='mw-headline')
                if span:
                    current_section_id = span.get('id') or span.get_text(strip=True)
                    current_heading = span.get_text(strip=True)
                else:
                    txt = elem.get_text(strip=True)
                    current_section_id = txt
                    current_heading = txt
                current_p_elements = []
                current_html_len = 0
            elif current_section_id is not None:
                current_html_len += len(str(elem))
                if elem.name == 'p':
                    current_p_elements.append(elem)
                # Collect cross-references
                for a in elem.find_all('a', href=True):
                    href = a.get('href', '')
                    display_text = a.get_text(strip=True)
                    is_ext = href.startswith('http') or href.startswith('https')
                    if is_ext:
                        if not any(r.get('url') == href for r in ext_refs):
                            ext_refs.append({'url': href, 'display_text': display_text})
                    else:
                        import re as _re
                        m = _re.search(r'[?/]title=([^&]+)', href)
                        if m:
                            pn = m.group(1).replace('+', '_')
                            is_redlink = 'redlink=1' in href
                            ref = {'page_name': pn, 'display_text': display_text}
                            if is_redlink:
                                ref['is_redlink'] = True
                            if not any(r.get('page_name') == pn for r in cross_refs):
                                cross_refs.append(ref)

        _flush_section()

    # Skip the TOC-heading section (mw-toc-heading)
    sections = [s for s in sections if s.get('section_id') not in ('mw-toc-heading', 'Contents')]

    parse_status = 'complete' if sections else 'partial'
    if not sections:
        warnings.append('no sections extracted')

    return {
        'schema_version': '1.0',
        'page_name': title,
        'display_name': display_name,
        'page_shape': 'catalog',
        'article_id': meta.get('article_id'),
        'revision_id': meta.get('revision_id'),
        'source_url': url,
        'local_path': local_path,
        'sections': sections,
        'cross_references': cross_refs,
        'external_references': ext_refs,
        'parse_status': parse_status,
        'parse_warnings': warnings,
        'parse_notes': 'Catalog page; sections extracted with property key-value pairs where detectable.',
    }
