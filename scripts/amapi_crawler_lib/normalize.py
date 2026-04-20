"""URL normalization for the AMAPI wiki crawler (rules per D-03 §URL Normalization)."""
from urllib.parse import urlparse, urlunparse, parse_qs, urlencode, unquote, quote


def normalize(url: str) -> str | None:
    """Normalize a URL to canonical form. Returns None for Special: pages (out-of-scope)."""
    try:
        parsed = urlparse(url)
    except Exception:
        return None

    # Rule 6: lowercase scheme and host
    scheme = parsed.scheme.lower()
    netloc = parsed.netloc.lower()

    # Only apply wiki-specific rules to wiki.siminnovations.com
    if netloc != 'wiki.siminnovations.com':
        # Rule 1: strip fragment for non-wiki URLs too
        return urlunparse((scheme, netloc, parsed.path, parsed.params, parsed.query, ''))

    path = parsed.path

    # Rule 3: rewrite path-style to query-string: /index.php/Foo -> /index.php?title=Foo
    if path.startswith('/index.php/') and len(path) > len('/index.php/'):
        title_from_path = path[len('/index.php/'):]
        path = '/index.php'
        # Merge with existing query string if any
        existing_qs = parse_qs(parsed.query, keep_blank_values=True)
        existing_qs['title'] = [title_from_path]
        query = urlencode({k: v[0] for k, v in existing_qs.items()}, quote_via=quote)
    else:
        query = parsed.query

    # Parse query parameters
    qs = parse_qs(query, keep_blank_values=True)

    # Rule 2: strip action= and oldid= parameters
    qs.pop('action', None)
    qs.pop('oldid', None)

    # Rule 4: URL-decode the title parameter once; preserve case
    title = None
    if 'title' in qs:
        raw_title = qs['title'][0]
        title = unquote(raw_title)  # single-pass decode
        # Rule 5: drop Special: pages
        if title.startswith('Special:'):
            return None
        # Re-encode minimally: keep letters, digits, _, -, ., :, / (wiki-safe chars)
        encoded_title = quote(title, safe='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-.:/')
        qs['title'] = [encoded_title]

    # Rebuild query string (title first for consistency)
    if qs:
        ordered = {}
        if 'title' in qs:
            ordered['title'] = qs.pop('title')[0]
        for k, v in qs.items():
            ordered[k] = v[0]
        new_query = urlencode(ordered, quote_via=quote)
    else:
        new_query = ''

    # Rule 1: strip fragment
    return urlunparse((scheme, netloc, path, '', new_query, ''))


def is_wiki_url(url: str) -> bool:
    """True if host is wiki.siminnovations.com."""
    try:
        return urlparse(url).netloc.lower() == 'wiki.siminnovations.com'
    except Exception:
        return False


def title_from_url(url: str) -> str | None:
    """Extract the title query param, URL-decoded once. Returns None if not present."""
    try:
        parsed = urlparse(url)
        qs = parse_qs(parsed.query, keep_blank_values=True)
        if 'title' in qs:
            return unquote(qs['title'][0])
        # Handle path-style: /index.php/Foo
        path = parsed.path
        if path.startswith('/index.php/') and len(path) > len('/index.php/'):
            return unquote(path[len('/index.php/'):])
        return None
    except Exception:
        return None
