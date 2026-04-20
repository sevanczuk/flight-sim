"""Single HTTP fetch with user agent and politeness delay."""
import time
import requests

_session: requests.Session | None = None
_last_fetch_at: float = 0.0


def _get_session(user_agent: str) -> requests.Session:
    global _session
    if _session is None:
        _session = requests.Session()
        _session.headers.update({'User-Agent': user_agent})
    return _session


def fetch_page(url: str, user_agent: str, min_delay_seconds: float = 1.0,
               verify: bool | str = True) -> tuple[int, bytes]:
    """Fetch a URL. Enforces minimum delay since last fetch.

    Returns (status_code, body_bytes). Raises on network error.
    verify: True = certifi bundle, False = skip verification, str = path to CA bundle.
    """
    global _last_fetch_at
    elapsed = time.monotonic() - _last_fetch_at
    wait = min_delay_seconds - elapsed
    if wait > 0:
        time.sleep(wait)

    session = _get_session(user_agent)
    resp = session.get(url, timeout=30, allow_redirects=True, verify=verify)
    _last_fetch_at = time.monotonic()
    return resp.status_code, resp.content
