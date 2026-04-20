"""
Copy UUID-named instrument sample directories to human-readable safe names.
"""

import argparse
import json
import logging
import re
import shutil
import unicodedata
import xml.etree.ElementTree as ET
from datetime import datetime, timezone
from pathlib import Path

logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
log = logging.getLogger(__name__)

UUID_RE = re.compile(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    re.IGNORECASE,
)


# ---------------------------------------------------------------------------
# Phase A: slugify and safe-name derivation
# ---------------------------------------------------------------------------

def slugify(s: str) -> str:
    s = unicodedata.normalize('NFKD', s)
    s = ''.join(c for c in s if not unicodedata.combining(c))
    s = s.lower()
    s = re.sub(r'\s+', '-', s)
    s = re.sub(r'[^a-z0-9_-]', '', s)
    s = re.sub(r'-+', '-', s)
    s = s.strip('-')
    return s if s else 'unknown'


def safe_name(aircraft: str, inst_type: str, uuid: str) -> str:
    return f"{slugify(aircraft)}_{slugify(inst_type)}_{uuid[:8]}"


def resolve_collision(aircraft: str, inst_type: str, uuid: str, used: dict) -> tuple[str, str | None]:
    """
    Returns (final_safe_name, collision_note | None).
    used: dict mapping safe_name -> uuid that claimed it.
    """
    base = f"{slugify(aircraft)}_{slugify(inst_type)}"
    candidate = f"{base}_{uuid[:8]}"
    if candidate not in used or used[candidate] == uuid:
        used[candidate] = uuid
        return candidate, None

    collision_note = f"{candidate} (8-char clash with {used[candidate][:8]})"
    candidate12 = f"{base}_{uuid[:12]}"
    if candidate12 not in used or used[candidate12] == uuid:
        used[candidate12] = uuid
        note = f"{collision_note} → {candidate12} (used 12-char prefix)"
        return candidate12, note

    suffix = 2
    while True:
        candidate_n = f"{candidate12}_{suffix}"
        if candidate_n not in used or used[candidate_n] == uuid:
            used[candidate_n] = uuid
            note = f"{collision_note} → {candidate_n} (appended _{suffix})"
            return candidate_n, note
        suffix += 1


# ---------------------------------------------------------------------------
# Phase B: info.xml parsing
# ---------------------------------------------------------------------------

def _text(elem, tag: str, default: str = '') -> str:
    child = elem.find(tag)
    if child is None or child.text is None:
        return default
    return child.text.strip()


def _bool_field(elem, tag: str) -> bool:
    val = _text(elem, tag, '').lower()
    return val == 'true'


def _int_field(elem, tag: str) -> int:
    raw = _text(elem, tag, '')
    try:
        return int(raw)
    except (ValueError, TypeError):
        return -1


def _list_field(elem, container_tag: str, item_tag: str) -> list:
    container = elem.find(container_tag)
    if container is None:
        return []
    return [c.text.strip() for c in container.findall(item_tag) if c.text]


def parse_info_xml(path: Path) -> dict:
    tree = ET.parse(path)
    root = tree.getroot()

    uuid_val = _text(root, 'uuid')
    if not uuid_val:
        raise ValueError(f"Missing <uuid> in {path}")

    dir_name = path.parent.name
    if uuid_val.lower() != dir_name.lower():
        log.warning("UUID mismatch: XML says %s but directory is %s — using XML value", uuid_val, dir_name)

    aircraft = _text(root, 'aircraft')
    if not aircraft:
        raise ValueError(f"Missing or empty <aircraft> in {path}")

    inst_type = _text(root, 'type')
    if not inst_type:
        raise ValueError(f"Missing or empty <type> in {path}")

    return {
        'uuid': uuid_val,
        'aircraft': aircraft,
        'type': inst_type,
        'author': _text(root, 'author'),
        'description': _text(root, 'description'),
        'version': _int_field(root, 'version'),
        'plugin_interface_version': _int_field(root, 'pluginInterfaceVersion'),
        'pref_width': _int_field(root, 'prefWidth'),
        'pref_height': _int_field(root, 'prefHeight'),
        'source': _text(root, 'source'),
        'compatible_fsx': _bool_field(root, 'compatibleFSX'),
        'compatible_p3d': _bool_field(root, 'compatibleP3D'),
        'compatible_xpl': _bool_field(root, 'compatibleXPL'),
        'compatible_fs2': _bool_field(root, 'compatibleFS2'),
        'compatible_fs2020': _bool_field(root, 'compatibleFS2020'),
        'compatible_fs2024': _bool_field(root, 'compatibleFS2024'),
        'platforms': _list_field(root, 'platforms', 'platform'),
        'tiers': _list_field(root, 'tiers', 'tier'),
    }


# ---------------------------------------------------------------------------
# Phase C: copy logic
# ---------------------------------------------------------------------------

def copy_instrument(src_dir: Path, dst_dir: Path, uuid: str, project_root: Path) -> str:
    """
    Returns 'copied' or 'skipped'.
    Raises RuntimeError if destination exists with a different UUID.
    """
    manifest_path = dst_dir / '.source_manifest.json'

    if dst_dir.exists():
        if manifest_path.exists():
            with open(manifest_path, encoding='utf-8') as f:
                existing = json.load(f)
            if existing.get('source_uuid') == uuid:
                log.info("Already present, skipping: %s", dst_dir.name)
                return 'skipped'
            raise RuntimeError(
                f"Destination {dst_dir} exists with UUID {existing.get('source_uuid')} "
                f"but source UUID is {uuid}. Manual cleanup required."
            )
        raise RuntimeError(
            f"Destination {dst_dir} exists but .source_manifest.json is missing. "
            "Partial or corrupted prior run. Manual cleanup required."
        )

    shutil.copytree(src_dir, dst_dir, dirs_exist_ok=False)

    manifest = {
        'source_uuid': uuid,
        'source_path': str(src_dir.relative_to(project_root)),
        'copied_at': datetime.now(timezone.utc).isoformat(),
    }
    with open(manifest_path, 'w', encoding='utf-8') as f:
        json.dump(manifest, f, indent=2)

    return 'copied'


# ---------------------------------------------------------------------------
# Phase D: main script flow
# ---------------------------------------------------------------------------

def _sim_compat(info: dict) -> str:
    abbrevs = []
    if info['compatible_fsx']:
        abbrevs.append('FSX')
    if info['compatible_p3d']:
        abbrevs.append('P3D')
    if info['compatible_xpl']:
        abbrevs.append('XPL')
    if info['compatible_fs2']:
        abbrevs.append('FS2')
    if info['compatible_fs2020']:
        abbrevs.append('FS2020')
    if info['compatible_fs2024']:
        abbrevs.append('FS2024')
    return ', '.join(abbrevs)


def _dims(info: dict) -> str:
    w = info['pref_width']
    h = info['pref_height']
    if w == -1 or h == -1:
        return '?'
    return f"{w}x{h}"


def main():
    parser = argparse.ArgumentParser(description="Copy instrument samples with safe names")
    parser.add_argument('--source', default='assets/instrument-samples')
    parser.add_argument('--destination', default='assets/instrument-samples-named')
    parser.add_argument('--manifest', default='docs/knowledge/instrument_samples_index.md')
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()

    project_root = Path(__file__).parent.parent
    src_root = project_root / args.source
    dst_root = project_root / args.destination
    manifest_path = project_root / args.manifest

    subdirs = sorted([d for d in src_root.iterdir() if d.is_dir()])

    used_names: dict[str, str] = {}
    entries = []
    error_entries = []
    collision_history = []
    n_copied = 0
    n_skipped = 0
    n_errored = 0

    for src_dir in subdirs:
        dir_name = src_dir.name

        if not UUID_RE.match(dir_name):
            log.warning("Skipping non-UUID directory: %s", dir_name)
            continue

        info_xml = src_dir / 'info.xml'
        if not info_xml.exists():
            log.error("Missing info.xml in %s", dir_name)
            error_entries.append({'dir': dir_name, 'error': 'Missing info.xml', 'partial': {}})
            n_errored += 1
            continue

        try:
            info = parse_info_xml(info_xml)
        except (ValueError, ET.ParseError) as exc:
            log.error("Failed to parse info.xml in %s: %s", dir_name, exc)
            error_entries.append({'dir': dir_name, 'error': str(exc), 'partial': {}})
            n_errored += 1
            continue

        name, collision_note = resolve_collision(info['aircraft'], info['type'], info['uuid'], used_names)
        if collision_note:
            collision_history.append(collision_note)
            log.warning("Collision resolved: %s", collision_note)

        dst_dir = dst_root / name

        if args.dry_run:
            log.info("Would copy %s -> %s", src_dir, dst_dir)
            entries.append({**info, 'safe_name': name, 'source_uuid_dir': dir_name})
            continue

        try:
            result = copy_instrument(src_dir, dst_dir, info['uuid'], project_root)
        except RuntimeError as exc:
            log.error("Copy failed for %s: %s", dir_name, exc)
            error_entries.append({'dir': dir_name, 'error': str(exc), 'partial': info})
            n_errored += 1
            continue

        if result == 'copied':
            n_copied += 1
        else:
            n_skipped += 1

        entries.append({**info, 'safe_name': name, 'source_uuid_dir': dir_name})

    if not args.dry_run:
        _write_manifest(
            manifest_path, dst_root, entries, error_entries, collision_history,
            n_copied, n_skipped, n_errored,
        )
        _write_json_index(dst_root, entries)

    print(f"\nSummary:")
    print(f"  Source dirs processed: {len(subdirs)}")
    print(f"  Copied:                {n_copied}")
    print(f"  Skipped (idempotent):  {n_skipped}")
    print(f"  Errored:               {n_errored}")
    print(f"  Collisions resolved:   {len(collision_history)}")
    if args.dry_run:
        print(f"  Would copy:            {len(entries)}")


# ---------------------------------------------------------------------------
# Phase E: manifest generation
# ---------------------------------------------------------------------------

def _write_manifest(
    manifest_path: Path,
    dst_root: Path,
    entries: list,
    error_entries: list,
    collision_history: list,
    n_copied: int,
    n_skipped: int,
    n_errored: int,
) -> None:
    now = datetime.now(timezone.utc).isoformat()
    sorted_entries = sorted(entries, key=lambda e: e['safe_name'])

    lines = [
        "# Instrument Samples Index",
        "",
        f"**Created:** {now}",
        "**Source:** docs/tasks/rename_instrument_samples_prompt.md",
        "**Generated by:** scripts/rename_instrument_samples.py",
        f"**Total samples:** {len(entries)}",
        "**Copy destination:** `assets/instrument-samples-named/`",
        "**Originals (never modified):** `assets/instrument-samples/`",
        "",
        "## Summary",
        "",
        f"- Copied this run: {n_copied}",
        f"- Already present (idempotent skip): {n_skipped}",
        f"- Errored: {n_errored}",
        f"- Collisions resolved (beyond 8-char prefix): {len(collision_history)}",
        "",
        "## Samples",
        "",
        "| Safe name | UUID | Aircraft | Type | Author | Sim compat | Dimensions | Version |",
        "|-----------|------|----------|------|--------|------------|------------|---------|",
    ]

    for e in sorted_entries:
        sim = _sim_compat(e)
        dims = _dims(e)
        lines.append(
            f"| {e['safe_name']} | {e['uuid']} | {e['aircraft']} | {e['type']} "
            f"| {e['author']} | {sim} | {dims} | {e['version']} |"
        )

    lines += [
        "",
        "## Errors",
        "",
    ]
    if error_entries:
        for err in error_entries:
            lines.append(f"### {err['dir']}")
            lines.append(f"**Error:** {err['error']}")
            if err.get('partial'):
                lines.append(f"**Partial metadata:** {err['partial']}")
            lines.append("")
    else:
        lines.append("None.")
        lines.append("")

    lines += ["## Collision history", ""]
    if collision_history:
        for note in collision_history:
            lines.append(f"- {note}")
    else:
        lines.append("None.")
    lines.append("")

    lines += [
        "## Sim compatibility legend",
        "",
        "| Abbrev | Platform |",
        "|--------|----------|",
        "| FSX | Microsoft Flight Simulator X |",
        "| P3D | Prepar3D |",
        "| XPL | X-Plane |",
        "| FS2 | Flight Simulator 2004 |",
        "| FS2020 | Microsoft Flight Simulator (2020) |",
        "| FS2024 | Microsoft Flight Simulator (2024) |",
        "",
        "## Raw data",
        "",
        "Structured JSON at `assets/instrument-samples-named/_index.json` for programmatic access. Same data as the table above plus description text.",
        "",
    ]

    manifest_path.parent.mkdir(parents=True, exist_ok=True)
    manifest_path.write_text('\n'.join(lines), encoding='utf-8')
    log.info("Manifest written to %s", manifest_path)


def _write_json_index(dst_root: Path, entries: list) -> None:
    sorted_entries = sorted(entries, key=lambda e: e['safe_name'])
    dst_root.mkdir(parents=True, exist_ok=True)
    index_path = dst_root / '_index.json'
    index_path.write_text(json.dumps(sorted_entries, indent=2), encoding='utf-8')
    log.info("JSON index written to %s", index_path)


if __name__ == '__main__':
    main()
