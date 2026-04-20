"""Tests for scripts/rename_instrument_samples.py"""

import hashlib
import json
import logging
import textwrap
from pathlib import Path

import pytest

from scripts.rename_instrument_samples import (
    copy_instrument,
    parse_info_xml,
    resolve_collision,
    safe_name,
    slugify,
)


# ---------------------------------------------------------------------------
# 1. slugify
# ---------------------------------------------------------------------------

class TestSlugify:
    def test_cessna_172(self):
        assert slugify("Cessna 172") == "cessna-172"

    def test_adf(self):
        assert slugify("ADF") == "adf"

    def test_g1000_perspective(self):
        assert slugify("G1000 (Perspective+)") == "g1000-perspective"

    def test_empty_string(self):
        assert slugify("") == "unknown"

    def test_whitespace_only(self):
        assert slugify("   ") == "unknown"

    def test_accent_stripping(self):
        assert slugify("á é í ó ú") == "a-e-i-o-u"

    def test_idempotent(self):
        samples = ["Cessna 172", "ADF", "G1000 (Perspective+)", "á é", ""]
        for s in samples:
            assert slugify(slugify(s)) == slugify(s)


# ---------------------------------------------------------------------------
# 2. safe_name
# ---------------------------------------------------------------------------

class TestSafeName:
    def test_known_example(self):
        result = safe_name("Cessna 172", "ADF", "04a6aa5d-7aad-42e4-9ed7-ca313b0e2edb")
        assert result == "cessna-172_adf_04a6aa5d"


# ---------------------------------------------------------------------------
# 3. Collision resolution
# ---------------------------------------------------------------------------

class TestCollisionResolution:
    def test_different_uuids_no_collision(self):
        used = {}
        name1, note1 = resolve_collision("Cessna 172", "ADF", "04a6aa5d-0000-0000-0000-000000000000", used)
        name2, note2 = resolve_collision("Cessna 172", "ADF", "ffffffff-0000-0000-0000-000000000000", used)
        assert name1 != name2
        assert note1 is None
        assert note2 is None

    def test_same_8char_prefix_forces_12char(self):
        # Craft two UUIDs with identical first 8 chars but different chars at positions 9-12
        uuid1 = "abcdef12-aaaa-0000-0000-000000000000"
        uuid2 = "abcdef12-bbbb-0000-0000-000000000000"
        used = {}
        name1, note1 = resolve_collision("Cessna", "ADF", uuid1, used)
        name2, note2 = resolve_collision("Cessna", "ADF", uuid2, used)
        assert name1 == "cessna_adf_abcdef12"
        assert note1 is None
        # Second one must differ — uses 12-char prefix
        assert name2 != name1
        assert "12-char" in note2
        # Prefix of name2 should include "abcdef12-bbb" normalized (no hyphens after slugify)
        assert name2.startswith("cessna_adf_")

    def test_further_collision_uses_numeric_suffix(self):
        # Force three UUIDs to have same 8-char AND same 12-char prefix
        uuid1 = "abcdef12-3456-0000-0000-000000000001"
        uuid2 = "abcdef12-3456-0000-0000-000000000002"
        uuid3 = "abcdef12-3456-0000-0000-000000000003"
        used = {}
        name1, _ = resolve_collision("X", "Y", uuid1, used)
        name2, note2 = resolve_collision("X", "Y", uuid2, used)
        name3, note3 = resolve_collision("X", "Y", uuid3, used)
        # All three must be unique
        assert len({name1, name2, name3}) == 3
        # Third should have _2 suffix somewhere
        assert "_2" in name3 or "_2" in name2


# ---------------------------------------------------------------------------
# 4. info.xml parsing
# ---------------------------------------------------------------------------

MINIMAL_XML = """\
<?xml version="1.0" encoding="utf-8"?>
<pluginstrument>
  <aircraft>Cessna 172</aircraft>
  <type>ADF</type>
  <uuid>04a6aa5d-7aad-42e4-9ed7-ca313b0e2edb</uuid>
  <author>Jane Doe</author>
  <description>  A test instrument  </description>
  <compatibleFSX>true</compatibleFSX>
  <compatibleP3D>false</compatibleP3D>
  <compatibleXPL>True</compatibleXPL>
  <compatibleFS2>FALSE</compatibleFS2>
  <compatibleFS2020>TRUE</compatibleFS2020>
  <compatibleFS2024>true</compatibleFS2024>
  <version>42</version>
  <pluginInterfaceVersion>100</pluginInterfaceVersion>
  <prefWidth>512</prefWidth>
  <prefHeight>512</prefHeight>
  <source>ONLINE</source>
  <platforms>
    <platform>WINDOWS</platform>
    <platform>MAC</platform>
  </platforms>
  <tiers>
    <tier>HOME_USE_STANDARD</tier>
  </tiers>
</pluginstrument>
"""


def write_xml(tmp_path: Path, xml_text: str, dir_name: str = "04a6aa5d-7aad-42e4-9ed7-ca313b0e2edb") -> Path:
    d = tmp_path / dir_name
    d.mkdir(parents=True, exist_ok=True)
    p = d / "info.xml"
    p.write_text(xml_text, encoding="utf-8")
    return p


class TestParseInfoXml:
    def test_valid_minimal(self, tmp_path):
        p = write_xml(tmp_path, MINIMAL_XML)
        info = parse_info_xml(p)
        assert info['aircraft'] == "Cessna 172"
        assert info['type'] == "ADF"
        assert info['uuid'] == "04a6aa5d-7aad-42e4-9ed7-ca313b0e2edb"
        assert info['author'] == "Jane Doe"
        assert info['description'] == "A test instrument"
        assert info['version'] == 42
        assert info['plugin_interface_version'] == 100
        assert info['pref_width'] == 512
        assert info['pref_height'] == 512
        assert info['compatible_fsx'] is True
        assert info['compatible_p3d'] is False
        assert info['compatible_xpl'] is True
        assert info['compatible_fs2'] is False
        assert info['compatible_fs2020'] is True
        assert info['compatible_fs2024'] is True
        assert info['platforms'] == ['WINDOWS', 'MAC']
        assert info['tiers'] == ['HOME_USE_STANDARD']

    def test_missing_aircraft_raises(self, tmp_path):
        xml = MINIMAL_XML.replace("<aircraft>Cessna 172</aircraft>", "")
        p = write_xml(tmp_path, xml)
        with pytest.raises(ValueError, match="aircraft"):
            parse_info_xml(p)

    def test_missing_type_raises(self, tmp_path):
        xml = MINIMAL_XML.replace("<type>ADF</type>", "")
        p = write_xml(tmp_path, xml)
        with pytest.raises(ValueError, match="type"):
            parse_info_xml(p)

    def test_missing_uuid_raises(self, tmp_path):
        xml = MINIMAL_XML.replace("<uuid>04a6aa5d-7aad-42e4-9ed7-ca313b0e2edb</uuid>", "")
        p = write_xml(tmp_path, xml)
        with pytest.raises(ValueError, match="uuid"):
            parse_info_xml(p)

    def test_uuid_mismatch_warns_uses_xml(self, tmp_path, caplog):
        # Directory name differs from UUID in XML
        p = write_xml(tmp_path, MINIMAL_XML, dir_name="ffffffff-0000-0000-0000-000000000000")
        with caplog.at_level(logging.WARNING):
            info = parse_info_xml(p)
        assert info['uuid'] == "04a6aa5d-7aad-42e4-9ed7-ca313b0e2edb"
        assert "mismatch" in caplog.text.lower()

    def test_boolean_true_variants(self, tmp_path):
        xml = MINIMAL_XML.replace("<compatibleFSX>true</compatibleFSX>", "<compatibleFSX>TRUE</compatibleFSX>")
        p = write_xml(tmp_path, xml)
        info = parse_info_xml(p)
        assert info['compatible_fsx'] is True

    def test_boolean_false_for_missing(self, tmp_path):
        xml = MINIMAL_XML.replace("<compatibleFS2>FALSE</compatibleFS2>", "")
        p = write_xml(tmp_path, xml)
        info = parse_info_xml(p)
        assert info['compatible_fs2'] is False

    def test_int_invalid_returns_neg1(self, tmp_path):
        xml = MINIMAL_XML.replace("<version>42</version>", "<version>abc</version>")
        p = write_xml(tmp_path, xml)
        info = parse_info_xml(p)
        assert info['version'] == -1

    def test_int_missing_returns_neg1(self, tmp_path):
        xml = MINIMAL_XML.replace("<prefWidth>512</prefWidth>", "")
        p = write_xml(tmp_path, xml)
        info = parse_info_xml(p)
        assert info['pref_width'] == -1

    def test_list_missing_returns_empty(self, tmp_path):
        xml = MINIMAL_XML.replace(
            "<platforms>\n    <platform>WINDOWS</platform>\n    <platform>MAC</platform>\n  </platforms>",
            ""
        )
        p = write_xml(tmp_path, xml)
        info = parse_info_xml(p)
        assert info['platforms'] == []


# ---------------------------------------------------------------------------
# 5. Copy logic + idempotency
# ---------------------------------------------------------------------------

def make_src(tmp_path: Path, uuid: str, aircraft: str = "Cessna 172", inst_type: str = "ADF") -> Path:
    src = tmp_path / "src" / uuid
    src.mkdir(parents=True)
    (src / "info.xml").write_text(
        f"<?xml version='1.0'?><pluginstrument>"
        f"<aircraft>{aircraft}</aircraft><type>{inst_type}</type>"
        f"<uuid>{uuid}</uuid></pluginstrument>",
        encoding="utf-8"
    )
    (src / "logic.lua").write_text("-- lua", encoding="utf-8")
    (src / "preview.png").write_bytes(b"\x89PNG")
    (src / "lib").mkdir()
    (src / "lib" / "helper.lua").write_text("-- helper", encoding="utf-8")
    (src / "resources").mkdir()
    return src


class TestCopyInstrument:
    def test_first_copy_creates_destination(self, tmp_path):
        uuid = "04a6aa5d-7aad-42e4-9ed7-ca313b0e2edb"
        src = make_src(tmp_path, uuid)
        dst = tmp_path / "dst" / "cessna-172_adf_04a6aa5d"
        result = copy_instrument(src, dst, uuid, tmp_path)
        assert result == 'copied'
        assert dst.exists()
        manifest_file = dst / '.source_manifest.json'
        assert manifest_file.exists()
        manifest = json.loads(manifest_file.read_text())
        assert manifest['source_uuid'] == uuid

    def test_second_copy_same_uuid_skipped(self, tmp_path):
        uuid = "04a6aa5d-7aad-42e4-9ed7-ca313b0e2edb"
        src = make_src(tmp_path, uuid)
        dst = tmp_path / "dst" / "cessna-172_adf_04a6aa5d"
        copy_instrument(src, dst, uuid, tmp_path)
        result = copy_instrument(src, dst, uuid, tmp_path)
        assert result == 'skipped'

    def test_different_uuid_into_same_dest_raises(self, tmp_path):
        uuid1 = "04a6aa5d-7aad-42e4-9ed7-ca313b0e2edb"
        uuid2 = "ffffffff-0000-0000-0000-000000000000"
        src1 = make_src(tmp_path, uuid1)
        dst = tmp_path / "dst" / "cessna-172_adf_04a6aa5d"
        copy_instrument(src1, dst, uuid1, tmp_path)
        src2 = make_src(tmp_path / "src2", uuid2)
        with pytest.raises(RuntimeError):
            copy_instrument(src2, dst, uuid2, tmp_path)

    def test_destination_byte_identical_to_source(self, tmp_path):
        uuid = "04a6aa5d-7aad-42e4-9ed7-ca313b0e2edb"
        src = make_src(tmp_path, uuid)
        dst = tmp_path / "dst" / "cessna-172_adf_04a6aa5d"
        copy_instrument(src, dst, uuid, tmp_path)

        def checksum_dir(d: Path) -> dict:
            result = {}
            for f in sorted(d.rglob('*')):
                if f.is_file() and f.name != '.source_manifest.json':
                    rel = f.relative_to(d)
                    result[str(rel)] = hashlib.sha256(f.read_bytes()).hexdigest()
            return result

        assert checksum_dir(src) == checksum_dir(dst)


# ---------------------------------------------------------------------------
# 6. Source immutability
# ---------------------------------------------------------------------------

class TestSourceImmutability:
    def test_source_files_unchanged_after_copy(self, tmp_path):
        uuid = "04a6aa5d-7aad-42e4-9ed7-ca313b0e2edb"
        src = make_src(tmp_path, uuid)

        def checksums(d: Path) -> dict:
            return {
                str(f.relative_to(d)): hashlib.sha256(f.read_bytes()).hexdigest()
                for f in sorted(d.rglob('*')) if f.is_file()
            }

        before = checksums(src)
        dst = tmp_path / "dst" / "cessna-172_adf_04a6aa5d"
        copy_instrument(src, dst, uuid, tmp_path)
        after = checksums(src)

        assert before == after, "Source files were modified during copy"
