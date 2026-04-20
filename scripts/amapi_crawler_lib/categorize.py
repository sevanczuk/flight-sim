"""Title-prefix bucket categorization per Implementation Plan §4.5."""
from urllib.parse import urlparse

API_PREFIXES = {
    'Xpl', 'Fsx', 'P3d', 'Msfs', 'Fs2020', 'Fs2024',
    'Hw', 'Si', 'Ext',
    'Viewport', 'Canvas', 'Scene', 'Img', 'Txt', 'Fi', 'Video',
    'Mouse', 'Touch', 'Slider', 'Scrollwheel',
    'Rotate', 'Move', 'Visible', 'Opacity', 'Z',
    'Variable', 'Var', 'Request', 'Persist', 'Timer', 'Switch', 'Group',
    'Sound', 'Nav', 'Map', 'Instrument', 'Device', 'User',
}

NON_API_TITLES = {
    'API', 'Instrument_Creation_Tutorial', 'Device_list',
    'Hardware_id_list', 'I/O_Connection_examples',
}


def categorize(title: str | None, url: str) -> str:
    """Return category string for a URL/title pair."""
    try:
        host = urlparse(url).netloc.lower()
    except Exception:
        host = ''

    if host != 'wiki.siminnovations.com':
        if 'youtube.com' in host or 'youtu.be' in host:
            return 'youtube'
        return 'external'

    if title is None:
        return 'wiki-other'

    if title.startswith('Special:'):
        return 'special'

    if title in NON_API_TITLES:
        return 'non-api-useful'

    if title.startswith('File:'):
        return 'file'

    # Check first underscore-separated token against API_PREFIXES
    first_token = title.split('_')[0]
    if first_token in API_PREFIXES:
        return first_token

    return 'wiki-other'


def should_queue(category: str) -> bool:
    """True if this URL should be fetched (queued as pending)."""
    return category in API_PREFIXES or category == 'non-api-useful'
