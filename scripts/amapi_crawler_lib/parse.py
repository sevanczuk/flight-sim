"""HTML link extraction using BeautifulSoup."""
from bs4 import BeautifulSoup
from urllib.parse import urljoin


def extract_links(html: bytes | str, base_url: str) -> list[tuple[str, str]]:
    """Parse HTML and return list of (absolute_url, anchor_text) tuples.

    Only returns href links from <a> tags; skips mailto:, javascript:, empty hrefs.
    """
    try:
        soup = BeautifulSoup(html, 'lxml')
    except Exception:
        soup = BeautifulSoup(html, 'html.parser')

    results = []
    for tag in soup.find_all('a', href=True):
        href = tag['href'].strip()
        if not href or href.startswith(('mailto:', 'javascript:', '#')):
            continue
        absolute = urljoin(base_url, href)
        anchor = tag.get_text(strip=True)[:500]
        results.append((absolute, anchor))
    return results
