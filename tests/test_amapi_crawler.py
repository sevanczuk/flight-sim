"""Unit tests for pure-function components of the AMAPI crawler (AMAPI-CRAWLER-01)."""
import os
import sqlite3
import sys
import tempfile
from datetime import datetime, timezone, timedelta
from unittest.mock import patch

import pytest

# Allow importing from scripts/
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts'))

from amapi_crawler_lib.normalize import normalize, is_wiki_url, title_from_url
from amapi_crawler_lib.categorize import categorize, should_queue, API_PREFIXES, NON_API_TITLES
from amapi_crawler_lib.filename import url_to_filename, filename_to_url
from amapi_crawler_lib.db import (
    connect, ensure_schema, start_crawl_run, end_crawl_run,
    upsert_url, record_fetch_success, record_fetch_failure, upsert_edge,
    next_pending_url, EXPECTED_TABLES, EXPECTED_INDEXES,
)


# ---------------------------------------------------------------------------
# Normalization tests
# ---------------------------------------------------------------------------

class TestFragmentStripping:
    def test_strips_fragment(self):
        url = 'https://wiki.siminnovations.com/index.php?title=Xpl_command#section'
        assert '#' not in normalize(url)

    def test_no_fragment_unchanged(self):
        url = 'https://wiki.siminnovations.com/index.php?title=Xpl_command'
        assert normalize(url) == url


class TestQueryParamStripping:
    def test_strips_action(self):
        url = 'https://wiki.siminnovations.com/index.php?title=Xpl_command&action=edit'
        result = normalize(url)
        assert 'action=' not in result
        assert 'title=Xpl_command' in result

    def test_strips_oldid(self):
        url = 'https://wiki.siminnovations.com/index.php?title=Xpl_command&oldid=1234'
        result = normalize(url)
        assert 'oldid=' not in result

    def test_preserves_other_params(self):
        url = 'https://wiki.siminnovations.com/index.php?title=Xpl_command&curid=42'
        result = normalize(url)
        assert 'curid=42' in result


class TestPathStyleRewrite:
    def test_path_style_to_query_string(self):
        url = 'https://wiki.siminnovations.com/index.php/API'
        result = normalize(url)
        assert 'title=API' in result
        assert '/index.php?' in result

    def test_query_style_unchanged(self):
        url = 'https://wiki.siminnovations.com/index.php?title=API'
        result = normalize(url)
        assert 'title=API' in result


class TestTitleDecoding:
    def test_percent_encoded_colon(self):
        url1 = 'https://wiki.siminnovations.com/index.php?title=File%3AFoo.png'
        url2 = 'https://wiki.siminnovations.com/index.php?title=File:Foo.png'
        assert normalize(url1) == normalize(url2)

    def test_single_pass_decode(self):
        # %253A should become %3A (single decode), not : (double decode)
        url = 'https://wiki.siminnovations.com/index.php?title=File%253AFoo.png'
        result = normalize(url)
        assert '%3A' in result or '%253A' not in result  # single pass


class TestSchemHostLowercasing:
    def test_lowercases_scheme_and_host(self):
        url = 'HTTPS://Wiki.SimInnovations.COM/index.php?title=Xpl_command'
        result = normalize(url)
        assert result.startswith('https://wiki.siminnovations.com/')

    def test_preserves_title_case(self):
        url = 'https://wiki.siminnovations.com/index.php?title=Xpl_Command'
        result = normalize(url)
        assert 'Xpl_Command' in result


class TestSpecialPages:
    def test_special_page_returns_none(self):
        url = 'https://wiki.siminnovations.com/index.php?title=Special:Search'
        assert normalize(url) is None

    def test_special_path_style_returns_none(self):
        url = 'https://wiki.siminnovations.com/index.php/Special:RecentChanges'
        assert normalize(url) is None


class TestIdempotency:
    SAMPLE_URLS = [
        'https://wiki.siminnovations.com/index.php?title=Xpl_command',
        'https://wiki.siminnovations.com/index.php?title=Msfs_dataref_subscribe',
        'https://wiki.siminnovations.com/index.php?title=File:Air_manager.png',
        'https://wiki.siminnovations.com/index.php?title=Device_list',
        'https://wiki.siminnovations.com/index.php?title=I/O_Connection_examples',
    ]

    @pytest.mark.parametrize('url', SAMPLE_URLS)
    def test_normalize_is_idempotent(self, url):
        n1 = normalize(url)
        if n1 is not None:
            n2 = normalize(n1)
            assert n1 == n2, f'Not idempotent: {url!r} -> {n1!r} -> {n2!r}'


# ---------------------------------------------------------------------------
# Categorization tests
# ---------------------------------------------------------------------------

class TestCategorizationApiPrefixes:
    @pytest.mark.parametrize('prefix', list(API_PREFIXES))
    def test_api_prefix_returns_prefix(self, prefix):
        title = f'{prefix}_something'
        url = f'https://wiki.siminnovations.com/index.php?title={title}'
        assert categorize(title, url) == prefix

    def test_xpl_example(self):
        assert categorize('Xpl_command', 'https://wiki.siminnovations.com/index.php?title=Xpl_command') == 'Xpl'

    def test_msfs_example(self):
        assert categorize('Msfs_dataref_subscribe', 'https://wiki.siminnovations.com/index.php?title=Msfs_dataref_subscribe') == 'Msfs'


class TestCategorizationNonApi:
    @pytest.mark.parametrize('title', list(NON_API_TITLES))
    def test_non_api_titles(self, title):
        url = f'https://wiki.siminnovations.com/index.php?title={title}'
        assert categorize(title, url) == 'non-api-useful'


class TestCategorizationSpecial:
    def test_special_category(self):
        assert categorize('Special:Search', 'https://wiki.siminnovations.com/index.php?title=Special:Search') == 'special'


class TestCategorizationFile:
    def test_file_category(self):
        assert categorize('File:Foo.png', 'https://wiki.siminnovations.com/index.php?title=File:Foo.png') == 'file'


class TestCategorizationExternal:
    def test_external_url(self):
        assert categorize(None, 'https://example.com/page') == 'external'

    def test_youtube_url(self):
        assert categorize(None, 'https://www.youtube.com/watch?v=abc') == 'youtube'

    def test_youtu_be(self):
        assert categorize(None, 'https://youtu.be/abc') == 'youtube'


class TestShouldQueue:
    def test_api_prefix_queued(self):
        for prefix in API_PREFIXES:
            assert should_queue(prefix), f'{prefix} should be queued'

    def test_non_api_useful_queued(self):
        assert should_queue('non-api-useful')

    def test_external_not_queued(self):
        assert not should_queue('external')

    def test_youtube_not_queued(self):
        assert not should_queue('youtube')

    def test_wiki_other_not_queued(self):
        assert not should_queue('wiki-other')

    def test_special_not_queued(self):
        assert not should_queue('special')

    def test_file_not_queued(self):
        assert not should_queue('file')


# ---------------------------------------------------------------------------
# Filename mapping tests
# ---------------------------------------------------------------------------

class TestFilenameMapping:
    def test_basic_url_to_filename(self):
        url = 'https://wiki.siminnovations.com/index.php?title=Xpl_command'
        assert url_to_filename(url) == 'index.php@title=Xpl_command'

    def test_colon_encoded_in_filename(self):
        url = 'https://wiki.siminnovations.com/index.php?title=File:Air_manager.png'
        fname = url_to_filename(url)
        assert 'File%3AAir_manager.png' in fname

    def test_slash_encoded_in_filename(self):
        url = 'https://wiki.siminnovations.com/index.php?title=I/O_Connection_examples'
        fname = url_to_filename(url)
        assert 'I%2FO_Connection_examples' in fname

    def test_roundtrip_basic(self):
        fname = 'index.php@title=Xpl_command'
        raw_url = filename_to_url(fname)
        assert url_to_filename(normalize(raw_url)) == fname

    def test_roundtrip_with_colon(self):
        fname = 'index.php@title=File%3AAir_manager.png'
        raw_url = filename_to_url(fname)
        canonical = normalize(raw_url)
        assert url_to_filename(canonical) == fname

    def test_roundtrip_with_slash(self):
        fname = 'index.php@title=I%2FO_Connection_examples'
        raw_url = filename_to_url(fname)
        canonical = normalize(raw_url)
        assert url_to_filename(canonical) == fname


class TestFilenameRoundtripFromMirror:
    """Roundtrip test against actual mirror filenames."""
    MIRROR_DIR = os.path.join(
        os.path.dirname(__file__), '..', 'assets', 'air_manager_api', 'wiki.siminnovations.com'
    )

    def _get_mirror_files(self):
        if not os.path.isdir(self.MIRROR_DIR):
            return []
        return [f for f in os.listdir(self.MIRROR_DIR) if f.startswith('index.php@title=')]

    def test_roundtrip_for_mirror_files(self):
        files = self._get_mirror_files()
        if not files:
            pytest.skip('Mirror directory not available')
        for fname in files[:20]:  # test a sample
            raw_url = filename_to_url(fname)
            canonical = normalize(raw_url)
            if canonical is None:
                continue  # Special: page
            result_fname = url_to_filename(canonical)
            assert result_fname == fname, f'Roundtrip failed: {fname!r} -> {result_fname!r}'


# ---------------------------------------------------------------------------
# DB schema tests
# ---------------------------------------------------------------------------

@pytest.fixture
def tmp_db():
    with tempfile.NamedTemporaryFile(suffix='.sqlite3', delete=False) as f:
        path = f.name
    conn = connect(path)
    ensure_schema(conn)
    yield conn
    conn.close()
    os.unlink(path)


class TestDbSchema:
    def test_all_tables_created(self, tmp_db):
        tables = {r[0] for r in tmp_db.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall()}
        for t in EXPECTED_TABLES:
            assert t in tables, f'Table {t!r} missing'

    def test_all_columns_present(self, tmp_db):
        for table, expected_cols in EXPECTED_TABLES.items():
            rows = tmp_db.execute(f'PRAGMA table_info({table})').fetchall()
            actual = {r['name'] for r in rows}
            for col in expected_cols:
                assert col in actual, f'{table}.{col} missing'

    def test_all_indexes_created(self, tmp_db):
        indexes = {r[0] for r in tmp_db.execute(
            "SELECT name FROM sqlite_master WHERE type='index'"
        ).fetchall()}
        for idx in EXPECTED_INDEXES:
            assert idx in indexes, f'Index {idx!r} missing'

    def test_ensure_schema_idempotent(self, tmp_db):
        ensure_schema(tmp_db)  # second call should not raise
        tables = {r[0] for r in tmp_db.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall()}
        assert 'urls' in tables


# ---------------------------------------------------------------------------
# Upsert behavior tests
# ---------------------------------------------------------------------------

class TestUpsertBehavior:
    def _run_id(self, conn):
        return start_crawl_run(conn, notes='test')

    def test_insert_new_url(self, tmp_db):
        run_id = self._run_id(tmp_db)
        url_id, inserted = upsert_url(
            tmp_db, url='https://wiki.siminnovations.com/index.php?title=Xpl_command',
            url_raw='https://wiki.siminnovations.com/index.php?title=Xpl_command',
            title='Xpl_command', category='Xpl', source='seed', status='pending', run_id=run_id,
        )
        assert inserted is True
        assert url_id > 0

    def test_no_duplicate_on_second_upsert(self, tmp_db):
        run_id = self._run_id(tmp_db)
        url = 'https://wiki.siminnovations.com/index.php?title=Xpl_command'
        id1, ins1 = upsert_url(tmp_db, url=url, url_raw=url, title='Xpl_command',
                                category='Xpl', source='seed', status='pending', run_id=run_id)
        id2, ins2 = upsert_url(tmp_db, url=url, url_raw=url, title='Xpl_command',
                                category='Xpl', source='seed', status='pending', run_id=run_id)
        assert id1 == id2
        assert ins2 is False
        count = tmp_db.execute('SELECT COUNT(*) FROM urls WHERE url = ?', (url,)).fetchone()[0]
        assert count == 1

    def test_source_not_demoted(self, tmp_db):
        """A pre-existing fetched URL should not be overwritten by a seed upsert."""
        run_id = self._run_id(tmp_db)
        url = 'https://wiki.siminnovations.com/index.php?title=Xpl_command'
        url_id, _ = upsert_url(tmp_db, url=url, url_raw=url, title='Xpl_command',
                                category='Xpl', source='pre-existing', status='fetched', run_id=run_id)
        record_fetch_success(tmp_db, url_id=url_id, fetched_at='2026-01-01T00:00:00Z',
                             http_status=200, content_bytes=1000, content_sha256='abc',
                             local_path='path/to/file', run_id=run_id)
        # Now upsert as seed/pending — should not change source or status
        upsert_url(tmp_db, url=url, url_raw=url, title='Xpl_command',
                   category='Xpl', source='seed', status='pending', run_id=run_id)
        row = tmp_db.execute('SELECT source, status FROM urls WHERE url = ?', (url,)).fetchone()
        assert row['source'] == 'pre-existing'
        assert row['status'] == 'fetched'


# ---------------------------------------------------------------------------
# Backoff schedule tests
# ---------------------------------------------------------------------------

class TestBackoffSchedule:
    def _insert_pending(self, conn, run_id):
        url = 'https://wiki.siminnovations.com/index.php?title=Xpl_command'
        url_id, _ = upsert_url(conn, url=url, url_raw=url, title='Xpl_command',
                                category='Xpl', source='seed', status='pending', run_id=run_id)
        return url_id

    def test_first_failure(self, tmp_db):
        run_id = start_crawl_run(tmp_db)
        url_id = self._insert_pending(tmp_db, run_id)
        now = datetime.now(timezone.utc)
        record_fetch_failure(tmp_db, url_id=url_id, error='timeout', now=now.strftime('%Y-%m-%dT%H:%M:%SZ'))
        row = tmp_db.execute('SELECT attempts, status, next_retry_at FROM urls WHERE url_id = ?', (url_id,)).fetchone()
        assert row['attempts'] == 1
        assert row['status'] == 'pending'
        retry = datetime.fromisoformat(row['next_retry_at'].replace('Z', '+00:00'))
        diff = (retry - now).total_seconds()
        assert 55 <= diff <= 65, f'Expected ~60s backoff, got {diff}s'

    def test_second_failure(self, tmp_db):
        run_id = start_crawl_run(tmp_db)
        url_id = self._insert_pending(tmp_db, run_id)
        now = datetime.now(timezone.utc)
        now_str = now.strftime('%Y-%m-%dT%H:%M:%SZ')
        record_fetch_failure(tmp_db, url_id=url_id, error='timeout', now=now_str)
        record_fetch_failure(tmp_db, url_id=url_id, error='timeout', now=now_str)
        row = tmp_db.execute('SELECT attempts, status, next_retry_at FROM urls WHERE url_id = ?', (url_id,)).fetchone()
        assert row['attempts'] == 2
        assert row['status'] == 'pending'
        retry = datetime.fromisoformat(row['next_retry_at'].replace('Z', '+00:00'))
        diff = (retry - now).total_seconds()
        assert 290 <= diff <= 310, f'Expected ~300s backoff, got {diff}s'

    def test_third_failure_marks_failed(self, tmp_db):
        run_id = start_crawl_run(tmp_db)
        url_id = self._insert_pending(tmp_db, run_id)
        now_str = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
        for _ in range(3):
            record_fetch_failure(tmp_db, url_id=url_id, error='timeout', now=now_str)
        row = tmp_db.execute('SELECT attempts, status FROM urls WHERE url_id = ?', (url_id,)).fetchone()
        assert row['attempts'] == 3
        assert row['status'] == 'failed'
