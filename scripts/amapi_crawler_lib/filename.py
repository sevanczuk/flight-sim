"""Bidirectional mapping between canonical wiki URL and local filename.

Convention (from wget --restrict-file-names=windows):
  ? -> @
  : in title -> %3A
  / in title -> %2F
  Other characters remain as-is or percent-encoded as needed.
"""
from urllib.parse import urlparse, parse_qs, quote, unquote


def url_to_filename(url: str) -> str:
    """Convert a canonical wiki URL to a local filename (relative, no directory prefix).

    Example: https://wiki.siminnovations.com/index.php?title=Xpl_command
             -> index.php@title=Xpl_command
    """
    parsed = urlparse(url)
    path_part = parsed.path.lstrip('/')  # e.g., 'index.php'

    if not parsed.query:
        return path_part

    qs = parse_qs(parsed.query, keep_blank_values=True)
    if 'title' not in qs:
        # Non-title URL — encode ? as @
        return path_part + '@' + parsed.query

    title = qs['title'][0]
    # In the filename: encode characters that are invalid in filenames
    # Letters, digits, underscore, hyphen, period are safe; colon and slash are not
    safe_in_filename = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-.'
    encoded_title = quote(title, safe=safe_in_filename)

    # Build remaining query params (title first, then any others)
    other_params = {k: v[0] for k, v in qs.items() if k != 'title'}
    if other_params:
        from urllib.parse import urlencode
        other = '&' + urlencode(other_params)
    else:
        other = ''

    return f'{path_part}@title={encoded_title}{other}'


def filename_to_url(filename: str, base_url: str = 'https://wiki.siminnovations.com') -> str:
    """Convert a local filename back to a raw URL (before normalization).

    Example: index.php@title=Xpl_command
             -> https://wiki.siminnovations.com/index.php?title=Xpl_command
    """
    # Replace first @ with ? to reconstruct query string
    raw = filename.replace('@', '?', 1)
    return f'{base_url.rstrip("/")}/{raw}'
