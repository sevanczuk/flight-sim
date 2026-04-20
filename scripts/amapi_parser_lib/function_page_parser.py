"""Parse canonical AMAPI function pages into structured dicts."""

import html as html_lib
import re
from bs4 import BeautifulSoup, NavigableString, Tag

from amapi_parser_lib.page_classifier import classify_page

_RLCONF_RE = re.compile(r'RLCONF\s*=\s*(\{.*?\});', re.DOTALL)
_ARTICLE_ID_RE = re.compile(r'"wgArticleId"\s*:\s*(\d+)')
_REVISION_ID_RE = re.compile(r'"wgCurRevisionId"\s*:\s*(\d+)')
_PAGE_NAME_RE = re.compile(r'"wgPageName"\s*:\s*"([^"]+)"')
_RETURN_TYPE_RE = re.compile(r'\bReturns?\s+(?:a\s+)?(\w+)', re.IGNORECASE)


def _extract_rlconf(html: str) -> dict:
    m = _RLCONF_RE.search(html)
    if not m:
        return {}
    blob = m.group(0)
    article_id = _ARTICLE_ID_RE.search(blob)
    revision_id = _REVISION_ID_RE.search(blob)
    page_name = _PAGE_NAME_RE.search(blob)
    return {
        'article_id': int(article_id.group(1)) if article_id else None,
        'revision_id': int(revision_id.group(1)) if revision_id else None,
        'wg_page_name': page_name.group(1) if page_name else None,
    }


def _parse_sections(content_div) -> dict:
    """Return ordered dict of section_id → list[Tag]."""
    sections = {}
    current_id = '__pre_section__'
    sections[current_id] = []
    for elem in content_div.children:
        if isinstance(elem, NavigableString):
            continue
        if elem.name == 'h2':
            span = elem.find('span', class_='mw-headline')
            if span:
                sec_id = span.get('id') or span.get_text(strip=True)
            else:
                sec_id = elem.get_text(strip=True)
            current_id = sec_id
            sections[current_id] = []
        else:
            sections.setdefault(current_id, []).append(elem)
    return sections


def _section_text(elements) -> str:
    """Extract clean text from a list of elements."""
    parts = []
    for elem in elements:
        if isinstance(elem, NavigableString):
            parts.append(str(elem))
        elif hasattr(elem, 'get_text'):
            if elem.name in ('div', 'script', 'style'):
                continue
            if elem.name == 'p':
                parts.append(elem.get_text(separator=' ', strip=True))
    return ' '.join(p for p in parts if p).strip()


def _normalize_whitespace(s: str) -> str:
    return re.sub(r'\s+', ' ', s).strip()


def _link_to_ref(a_tag):
    href = a_tag.get('href', '')
    display_text = a_tag.get_text(strip=True)
    is_external = href.startswith('http://') or href.startswith('https://')

    if is_external:
        return {'type': 'external', 'url': href, 'display_text': display_text}

    # Internal: extract page title
    page_name = None
    is_redlink = 'redlink=1' in href
    m = re.search(r'[?/]title=([^&]+)', href)
    if m:
        page_name = m.group(1).replace('+', '_')
    else:
        m2 = re.search(r'/index\.php/([^?]+)', href)
        if m2:
            page_name = m2.group(1)
    if not page_name:
        return None
    ref = {'page_name': page_name, 'display_text': display_text}
    if is_redlink:
        ref['is_redlink'] = True
    return ref


def _extract_description(p_elements, cross_refs: list, ext_refs: list) -> tuple:
    """Return (description_text, description_html) from <p> elements."""
    texts = []
    htmls = []
    for p in p_elements:
        if not isinstance(p, Tag) or p.name != 'p':
            continue
        # Collect cross-references from links in this paragraph
        for a in p.find_all('a', href=True):
            ref = _link_to_ref(a)
            if ref is None:
                continue
            if ref.get('type') == 'external':
                if not any(r.get('url') == ref['url'] for r in ext_refs):
                    ext_refs.append({'url': ref['url'], 'display_text': ref['display_text']})
            else:
                ref.pop('type', None)
                if not any(r.get('page_name') == ref['page_name'] for r in cross_refs):
                    cross_refs.append(ref)
        # Build inline-link text
        raw_parts = []
        for node in p.children:
            if isinstance(node, NavigableString):
                raw_parts.append(str(node))
            elif node.name == 'a':
                ref = _link_to_ref(node)
                if ref and ref.get('type') != 'external':
                    target = ref.get('page_name', '')
                    raw_parts.append(f'[{node.get_text()}]({target})')
                elif ref and ref.get('type') == 'external':
                    raw_parts.append(f'[{node.get_text()}]({ref["url"]})')
                else:
                    raw_parts.append(node.get_text())
            elif node.name in ('b', 'i', 'code'):
                raw_parts.append(node.get_text())
            else:
                raw_parts.append(node.get_text() if hasattr(node, 'get_text') else str(node))
        texts.append(_normalize_whitespace(''.join(raw_parts)))
        htmls.append(str(p))

    description = ' '.join(t for t in texts if t)
    description_html = '\n'.join(htmls)
    return description, description_html


def _parse_arguments_table(table) -> list:
    """Parse a wikitable of arguments into a list of dicts."""
    args = []
    rows = table.find_all('tr')
    # Skip header row
    for row in rows[1:]:
        cols = row.find_all('td')
        if len(cols) < 3:
            continue
        position = _normalize_whitespace(cols[0].get_text())
        name = _normalize_whitespace(cols[1].get_text())
        type_ = _normalize_whitespace(cols[2].get_text())
        desc = _normalize_whitespace(cols[3].get_text()) if len(cols) > 3 else ''
        args.append({'position': position, 'name': name, 'type': type_, 'description': desc})
    return args


def _parse_return_table(table) -> dict:
    """Parse a return value wikitable (some pages use tables for return value)."""
    rows = table.find_all('tr')
    for row in rows[1:]:
        cols = row.find_all('td')
        if cols:
            desc = _normalize_whitespace(cols[0].get_text())
            return {'text': desc, 'type': None}
    return {'text': '', 'type': None}


def _extract_examples(elements) -> list:
    """Extract code examples from a list of elements (h2 section or h3 sub-sections)."""
    examples = []
    current_label = 'Example'
    for elem in elements:
        if not isinstance(elem, Tag):
            continue
        if elem.name == 'h3':
            span = elem.find('span', class_='mw-headline')
            if span:
                current_label = span.get('id', '') or span.get_text(strip=True)
                # Convert encoded label: Example_(single_dataref) → Example (single dataref)
                current_label = current_label.replace('_', ' ')
        elif elem.name == 'pre':
            code_tag = elem.find('code')
            if code_tag:
                lang_class = code_tag.get('class', [''])[0].replace(' todo', '').strip() if code_tag.get('class') else 'lua'
                code = html_lib.unescape(code_tag.get_text())
                examples.append({'section_label': current_label, 'language': lang_class, 'code': code})
    return examples


def _infer_return_type(text: str):
    if not text:
        return None
    m = _RETURN_TYPE_RE.search(text)
    if m:
        candidate = m.group(1)
        if candidate.lower() not in ('any', 'the', 'this', 'a', 'an', 'nothing', 'no'):
            return candidate
    return None


def parse_function_page(html: str, title: str, url: str, local_path: str) -> dict:
    """Parse a canonical function page. Returns a structured dict."""
    meta = _extract_rlconf(html)
    soup = BeautifulSoup(html, 'lxml')

    # Display name
    h1 = soup.find('h1', id='firstHeading')
    display_name = h1.get_text(strip=True) if h1 else title.replace('_', ' ')

    # Namespace prefix
    if '_' in title:
        namespace_prefix = title.split('_')[0]
    else:
        namespace_prefix = None

    # Canonical name
    canonical_name = title.lower()

    # Category: pass through from DB (caller supplies it); use namespace_prefix as fallback
    # We use title-level inference here; the main parser overwrites from DB
    category = namespace_prefix if namespace_prefix else 'unprefixed-api'

    # Content area
    content_div = soup.find('div', class_='mw-parser-output')

    # Quick sanity check via classifier
    classification = classify_page(html, title, category)
    if classification['shape'] != 'function':
        return {
            'schema_version': '1.0',
            'page_name': title,
            'display_name': display_name,
            'canonical_name': canonical_name,
            'namespace_prefix': namespace_prefix,
            'category': category,
            'article_id': meta.get('article_id'),
            'revision_id': meta.get('revision_id'),
            'source_url': url,
            'local_path': local_path,
            'signature': '',
            'description': '',
            'description_html': '',
            'return_value': {'text': '', 'type': None},
            'arguments': [],
            'examples': [],
            'see_also': [],
            'cross_references': [],
            'external_references': [],
            'parse_status': 'skipped-wrong-shape',
            'parse_warnings': [f'classifier: shape={classification["shape"]}'],
            'parse_notes': '',
        }

    if not content_div:
        return _empty_record(title, display_name, canonical_name, namespace_prefix, category, meta, url, local_path,
                             'skipped-wrong-shape', ['no mw-parser-output div found'])

    sections = _parse_sections(content_div)

    # --- Signature ---
    signature = ''
    # Try to find the first <pre><b> in the whole content
    first_pre = content_div.find('pre')
    if first_pre:
        b_tag = first_pre.find('b')
        if b_tag:
            signature = _normalize_whitespace(html_lib.unescape(first_pre.get_text()))

    # --- Description ---
    cross_refs = []
    ext_refs = []
    description = ''
    description_html = ''
    desc_elements = sections.get('Description', [])
    if desc_elements:
        p_elements = [e for e in desc_elements if isinstance(e, Tag) and e.name == 'p']
        description, description_html = _extract_description(p_elements, cross_refs, ext_refs)

    # --- Return value ---
    return_value = {'text': '', 'type': None}
    for rv_key in ('Return_value', 'Return value'):
        rv_elems = sections.get(rv_key, [])
        if rv_elems:
            rv_table = next((e for e in rv_elems if isinstance(e, Tag) and e.name == 'table'), None)
            if rv_table:
                return_value = _parse_return_table(rv_table)
            else:
                rv_p = next((e for e in rv_elems if isinstance(e, Tag) and e.name == 'p'), None)
                if rv_p:
                    rv_text = _normalize_whitespace(rv_p.get_text())
                    return_value = {'text': rv_text, 'type': _infer_return_type(rv_text)}
            break

    # --- Arguments ---
    arguments = []
    warnings = []
    arg_table = None

    # Look for Arguments at h2 level first
    for arg_key in ('Arguments', 'Arguments_2'):
        arg_elems = sections.get(arg_key, [])
        arg_table = next((e for e in arg_elems if isinstance(e, Tag) and e.name == 'table'), None)
        if arg_table:
            break

    # Fall back: look for Arguments at h3 level inside any h2 section
    if not arg_table:
        for sec_elems in sections.values():
            for elem in sec_elems:
                if isinstance(elem, Tag) and elem.name == 'h3':
                    span = elem.find('span', class_='mw-headline')
                    if span and 'argument' in (span.get_text() or '').lower():
                        # Collect siblings after this h3 until next h3 or end
                        idx = sec_elems.index(elem)
                        for following in sec_elems[idx + 1:]:
                            if isinstance(following, Tag) and following.name in ('h2', 'h3'):
                                break
                            if isinstance(following, Tag) and following.name == 'table':
                                arg_table = following
                                break
                        if arg_table:
                            break
            if arg_table:
                break

    if arg_table:
        arguments = _parse_arguments_table(arg_table)
    else:
        warnings.append('no arguments table found')

    # --- Examples ---
    examples = []

    # Look for direct Example_ sections (h2 level)
    example_keys = [k for k in sections if k.startswith('Example') or k.startswith('example')]
    for key in example_keys:
        elems = sections[key]
        # Direct <pre><code> in this section
        for elem in elems:
            if isinstance(elem, Tag) and elem.name == 'pre':
                code_tag = elem.find('code')
                if code_tag:
                    lang = (code_tag.get('class') or ['lua'])[0].replace(' todo', '').strip()
                    code = html_lib.unescape(code_tag.get_text())
                    label = key.replace('_', ' ')
                    examples.append({'section_label': label, 'language': lang, 'code': code})

    # Look for "Examples" h2 with h3 sub-sections
    examples_section = sections.get('Examples', [])
    if examples_section and not examples:
        examples = _extract_examples(examples_section)

    # Also look for single "Example" h2 section
    if not examples:
        single_example = sections.get('Example', [])
        if single_example:
            examples = _extract_examples(single_example)

    # --- See also ---
    see_also = []
    for sa_key in ('See_also', 'See also'):
        sa_elems = sections.get(sa_key, [])
        if sa_elems:
            for elem in sa_elems:
                if isinstance(elem, Tag) and elem.name == 'ul':
                    for a in elem.find_all('a', href=True):
                        ref = _link_to_ref(a)
                        if ref and ref.get('type') != 'external':
                            ref.pop('type', None)
                            see_also.append(ref)
            break

    # --- Parse status ---
    parse_status = 'complete'
    if not signature:
        warnings.append('no signature found')
        parse_status = 'partial'
    if not description:
        warnings.append('no description text found')
        parse_status = 'partial'
    if warnings and parse_status == 'complete':
        parse_status = 'partial'

    return {
        'schema_version': '1.0',
        'page_name': title,
        'display_name': display_name,
        'canonical_name': canonical_name,
        'namespace_prefix': namespace_prefix,
        'category': category,
        'article_id': meta.get('article_id'),
        'revision_id': meta.get('revision_id'),
        'source_url': url,
        'local_path': local_path,
        'signature': signature,
        'description': description,
        'description_html': description_html,
        'return_value': return_value,
        'arguments': arguments,
        'examples': examples,
        'see_also': see_also,
        'cross_references': cross_refs,
        'external_references': ext_refs,
        'parse_status': parse_status,
        'parse_warnings': warnings,
        'parse_notes': '',
    }


def _empty_record(title, display_name, canonical_name, namespace_prefix, category, meta, url, local_path,
                  status, warnings):
    return {
        'schema_version': '1.0',
        'page_name': title,
        'display_name': display_name,
        'canonical_name': canonical_name,
        'namespace_prefix': namespace_prefix,
        'category': category,
        'article_id': meta.get('article_id'),
        'revision_id': meta.get('revision_id'),
        'source_url': url,
        'local_path': local_path,
        'signature': '',
        'description': '',
        'description_html': '',
        'return_value': {'text': '', 'type': None},
        'arguments': [],
        'examples': [],
        'see_also': [],
        'cross_references': [],
        'external_references': [],
        'parse_status': status,
        'parse_warnings': warnings,
        'parse_notes': '',
    }
