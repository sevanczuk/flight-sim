"""Tests for AMAPI parser (AMAPI-PARSER-01)."""

import json
import os
import sys

import pytest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts'))

from amapi_parser_lib.page_classifier import classify_page
from amapi_parser_lib.function_page_parser import parse_function_page
from amapi_parser_lib.catalog_page_parser import parse_catalog_page
from amapi_parser_lib.markdown_renderer import render_function_markdown, render_index_markdown

MIRROR_DIR = os.path.join(
    os.path.dirname(__file__), '..',
    'assets', 'air_manager_api', 'wiki.siminnovations.com',
)


def _load(title: str) -> str:
    path = os.path.join(MIRROR_DIR, f'index.php@title={title}')
    with open(path, encoding='utf-8') as f:
        return f.read()


# ---------------------------------------------------------------------------
# Phase A — Page Classifier
# ---------------------------------------------------------------------------

class TestPageClassifier:
    def test_function_xpl_dataref_subscribe(self):
        html = _load('Xpl_dataref_subscribe')
        r = classify_page(html, 'Xpl_dataref_subscribe', 'Xpl')
        assert r['shape'] == 'function'
        assert r['confidence'] >= 0.85

    def test_function_hw_button_add(self):
        html = _load('Hw_button_add')
        r = classify_page(html, 'Hw_button_add', 'Hw')
        assert r['shape'] == 'function'
        assert r['confidence'] >= 0.80

    def test_function_rotate_unprefixed(self):
        html = _load('Rotate')
        r = classify_page(html, 'Rotate', 'Rotate')
        assert r['shape'] == 'function'

    def test_catalog_device_list(self):
        html = _load('Device_list')
        r = classify_page(html, 'Device_list', 'non-api-useful')
        assert r['shape'] == 'catalog'
        assert r['confidence'] >= 0.9

    def test_tutorial_faq(self):
        html = _load('Air_Manager_FAQ')
        r = classify_page(html, 'Air_Manager_FAQ', 'wiki-other')
        assert r['shape'] == 'tutorial'

    def test_non_content_file_title(self):
        r = classify_page('<html></html>', 'File:Lightbulb.png', 'file')
        assert r['shape'] == 'non-content'

    def test_non_content_special_title(self):
        r = classify_page('<html></html>', 'Special:UserLogin', 'special')
        assert r['shape'] == 'non-content'


# ---------------------------------------------------------------------------
# Phase B — Function Page Parser
# ---------------------------------------------------------------------------

class TestFunctionPageParser:
    def test_xpl_dataref_subscribe(self):
        html = _load('Xpl_dataref_subscribe')
        url = 'https://wiki.siminnovations.com/index.php?title=Xpl_dataref_subscribe'
        local_path = 'assets/air_manager_api/wiki.siminnovations.com/index.php@title=Xpl_dataref_subscribe'
        r = parse_function_page(html, 'Xpl_dataref_subscribe', url, local_path)
        assert r['page_name'] == 'Xpl_dataref_subscribe'
        assert r['canonical_name'] == 'xpl_dataref_subscribe'
        assert r['namespace_prefix'] == 'Xpl'
        assert 'xpl_dataref_subscribe' in r['signature']
        assert len(r['arguments']) >= 3
        assert len(r['examples']) >= 3
        assert r['parse_status'] in ('complete', 'partial')

    def test_hw_button_add(self):
        html = _load('Hw_button_add')
        url = 'https://wiki.siminnovations.com/index.php?title=Hw_button_add'
        local_path = 'assets/air_manager_api/wiki.siminnovations.com/index.php@title=Hw_button_add'
        r = parse_function_page(html, 'Hw_button_add', url, local_path)
        assert r['page_name'] == 'Hw_button_add'
        assert 'hw_button_add' in r['signature']
        assert len(r['arguments']) >= 1
        assert r['parse_status'] in ('complete', 'partial')

    def test_msfs_variable_subscribe_examples(self):
        html = _load('Msfs_variable_subscribe')
        url = 'https://wiki.siminnovations.com/index.php?title=Msfs_variable_subscribe'
        local_path = 'assets/air_manager_api/wiki.siminnovations.com/index.php@title=Msfs_variable_subscribe'
        r = parse_function_page(html, 'Msfs_variable_subscribe', url, local_path)
        assert len(r['examples']) >= 1
        assert r['parse_status'] in ('complete', 'partial')

    def test_unprefixed_circle_or_rotate(self):
        html = _load('Rotate')
        url = 'https://wiki.siminnovations.com/index.php?title=Rotate'
        local_path = 'assets/air_manager_api/wiki.siminnovations.com/index.php@title=Rotate'
        r = parse_function_page(html, 'Rotate', url, local_path)
        assert r['namespace_prefix'] is None
        assert r['category'] in ('unprefixed-api', 'Rotate', 'wiki-other')

    def test_zero_example_function(self):
        html = _load('Xpl_connected')
        url = 'https://wiki.siminnovations.com/index.php?title=Xpl_connected'
        local_path = 'assets/air_manager_api/wiki.siminnovations.com/index.php@title=Xpl_connected'
        r = parse_function_page(html, 'Xpl_connected', url, local_path)
        assert isinstance(r['examples'], list)

    def test_missing_arguments_section(self):
        # Synthesize a function page with no arguments table
        html = '''<!DOCTYPE html><html><head>
        <script>RLCONF={"wgPageName":"Test_func","wgTitle":"Test func","wgCurRevisionId":1,"wgArticleId":999};</script>
        </head><body>
        <h1 id="firstHeading">Test func</h1>
        <div id="mw-content-text"><div class="mw-parser-output">
        <h2><span class="mw-headline" id="Description">Description</span></h2>
        <pre><b>test_func()</b></pre>
        <p>This is a test function.</p>
        <h2><span class="mw-headline" id="Return_value">Return value</span></h2>
        <p>Returns nothing.</p>
        </div></div></body></html>'''
        r = parse_function_page(html, 'Test_func',
                                'https://wiki.siminnovations.com/index.php?title=Test_func',
                                'assets/air_manager_api/wiki.siminnovations.com/index.php@title=Test_func')
        assert r['parse_status'] == 'partial'
        assert any('arguments' in w.lower() for w in r['parse_warnings'])


# ---------------------------------------------------------------------------
# Phase C — Catalog Page Parser
# ---------------------------------------------------------------------------

class TestCatalogPageParser:
    def test_device_list_sections(self):
        html = _load('Device_list')
        url = 'https://wiki.siminnovations.com/index.php?title=Device_list'
        local_path = 'assets/air_manager_api/wiki.siminnovations.com/index.php@title=Device_list'
        r = parse_catalog_page(html, 'Device_list', url, local_path)
        assert r['page_name'] == 'Device_list'
        assert r['page_shape'] == 'catalog'
        assert len(r['sections']) >= 17
        # First section
        first = r['sections'][0]
        assert first['section_id'] == 'Octavi_IFR_1'
        # Property Type present
        assert first['properties'].get('Type') == 'OCTAVI_IFR_1'
        assert r['parse_status'] == 'complete'


# ---------------------------------------------------------------------------
# Phase E — Markdown Renderer
# ---------------------------------------------------------------------------

class TestMarkdownRenderer:
    def _make_record(self):
        return {
            'schema_version': '1.0',
            'page_name': 'Test_func',
            'display_name': 'Test func',
            'canonical_name': 'test_func',
            'namespace_prefix': 'Test',
            'category': 'Test',
            'article_id': 1,
            'revision_id': 100,
            'source_url': 'https://wiki.siminnovations.com/index.php?title=Test_func',
            'local_path': 'assets/.../index.php@title=Test_func',
            'signature': 'test_func(a, b)',
            'description': 'This is a test function.',
            'description_html': '<p>This is a test function.</p>',
            'return_value': {'text': 'Returns a Number.', 'type': 'Number'},
            'arguments': [
                {'position': '1', 'name': 'a', 'type': 'String', 'description': 'First arg'},
                {'position': '2', 'name': 'b', 'type': 'Number', 'description': 'Second arg'},
            ],
            'examples': [
                {'section_label': 'Example', 'language': 'lua', 'code': 'test_func("hello", 42)'},
            ],
            'see_also': [
                {'page_name': 'Other_func', 'display_text': 'Other func'},
            ],
            'cross_references': [],
            'external_references': [],
            'parse_status': 'complete',
            'parse_warnings': [],
            'parse_notes': '',
        }

    def test_render_function_markdown_structure(self):
        record = self._make_record()
        known_pages = {'Test_func', 'Other_func'}
        md = render_function_markdown(record, known_pages)
        assert '# Test func' in md
        assert '## Signature' in md
        assert 'test_func(a, b)' in md
        assert '## Description' in md
        assert '## Return value' in md
        assert '## Arguments' in md
        assert '| 1 |' in md
        assert '## Examples' in md
        assert '```lua' in md
        assert '## See also' in md
        assert './Other_func.md' in md

    def test_render_index_markdown(self):
        index = {
            'schema_version': '1.0',
            'generated_at': '2026-04-20T00:00:00-04:00',
            'generator': 'scripts/amapi_parser.py',
            'total_pages_processed': 10,
            'counts_by_shape': {'function': 8, 'catalog': 1, 'tutorial': 1},
            'counts_by_namespace': {'Test': 2},
            'functions': [
                {
                    'page_name': 'Test_func',
                    'canonical_name': 'test_func',
                    'namespace_prefix': 'Test',
                    'category': 'Test',
                    'parse_status': 'complete',
                    'signature': 'test_func(a, b)',
                    'one_line_description': 'A test function.',
                },
            ],
            'catalogs': [],
            'tutorials': [],
            'warnings': [],
        }
        md = render_index_markdown(index)
        assert '# AMAPI Reference' in md
        assert 'Test_func' in md
