# CC Task Prompt: Rename Instrument Samples to Safe Names

**Location:** `docs/tasks/rename_instrument_samples_prompt.md`
**Task ID:** SAMPLES-RENAME-01
**Spec:** N/A — guidance lives in decision records and the implementation plan; see Source of truth below.
**Depends on:** None
**Priority:** Stream B Wave 1 (one of three parallel Wave-1 tasks under `docs/specs/GNC355_Prep_Implementation_Plan_V1.md`)
**Estimated scope:** Small — 30 min script development; minutes to run; 15 min verification
**Task type:** code
**Source of truth:**
- `docs/decisions/D-02-gnc355-prep-scoping.md` (especially §Stream B item 5)
- `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` §5 Stream B (B1 section)
**Supporting assets:**
- `assets/instrument-samples/` — 45 UUID-named directories, each containing `info.xml`, `logic.lua`, `preview.png`, `lib/`, `resources/`
- `assets/instrument-samples/config.sqlite3` — Air Manager local config DB (DO NOT TOUCH)
**Audit level:** self-check only — rationale: small, contained, read-only on originals, output is a clean new directory. Low risk.

---

## Pre-flight Verification

**Execute these checks before writing any code. If any check fails, STOP and write a deviation report.**

1. Verify source-of-truth docs exist and are readable:
   - `ls docs/decisions/D-02-gnc355-prep-scoping.md`
   - `ls docs/specs/GNC355_Prep_Implementation_Plan_V1.md`
2. Verify supporting assets exist:
   - `ls -d assets/instrument-samples/`
   - `ls assets/instrument-samples/config.sqlite3`
   - Count UUID directories: `ls -d assets/instrument-samples/*/` and confirm ~45 directories (expected: 45)
3. Verify no `assets/instrument-samples-named/` directory already exists. If it does, this is not automatic failure — the rename script must be idempotent — but note its existence in the deviation report.
4. Verify Python 3 is available. No external packages required for this task (uses standard library only).
5. Verify test baseline: document current test count as baseline. Running `python -m pytest tests/ --collect-only -q` should report an existing test count (expected to include `test_amapi_crawler.py` if AMAPI-CRAWLER-01 completed; may be empty otherwise).
6. Verify no blocking issues: read `docs/todos/issue_index.md` if it exists — confirm no unresolved CRITICAL/HIGH items reference this task. Continue if file does not exist.

**If any check fails:** Write `docs/tasks/rename_instrument_samples_prompt_deviation.md` with this structure:

```
# SAMPLES-RENAME-01 Pre-flight Deviation Report

**Date:** [timestamp]
**Prompt:** `docs/tasks/rename_instrument_samples_prompt.md`

## Deviations Found

### 1. {Check that failed}
**Expected:** {what was expected}
**Found:** {what was actually found}
**Impact:** {can the task proceed with modifications, or must it wait?}

## Recommendation
{PROCEED WITH MODIFICATIONS / BLOCKED — explain}
```

Then `git add docs/tasks/rename_instrument_samples_prompt_deviation.md && git commit -m "SAMPLES-RENAME-01: pre-flight deviation report"`. **Do not proceed with implementation until CD reviews the deviation report.**

---

## Phase 0: Source-of-Truth Audit

Before any implementation work:

1. Read both source-of-truth documents. Extract all actionable requirements for Stream B1.

**Definition — Actionable requirement:** A statement that, if not implemented, would make the task incomplete. Includes: behavioral requirements, data model constraints, integration contracts, error handling specifications. Excludes: background/rationale, rejected alternatives, future considerations, cross-references, informational notes.

2. Key requirements to verify coverage of:
   - D-02 §Stream B item 5: rename strategy = COPY (not move, not symlink, not rename in place); originals never modified
   - Plan §5 B1: safe name format `{slugified_aircraft}_{slugified_type}_{first_8_chars_of_uuid}`; slugify rules; collision handling
   - Plan §5 B1: manifest at `docs/knowledge/instrument_samples_index.md`
   - Plan §5 B1: preserve all files per directory (info.xml, logic.lua, preview.png, lib/, resources/)
   - Plan §5 B1: script is idempotent
3. Cross-reference against this prompt's implementation phases below.
4. If ALL requirements covered: print "Phase 0: all source requirements covered" and proceed.
5. If uncovered: write `docs/tasks/rename_instrument_samples_prompt_phase0_deviation.md` with each uncovered requirement; commit; notify; STOP.

---

## Instructions

Build a script that copies each UUID-named instrument directory under `assets/instrument-samples/` to a new directory `assets/instrument-samples-named/` using a human-readable safe name derived from the `info.xml` metadata. Originals are never modified. The script is idempotent — re-running over existing output does not corrupt state. A manifest markdown file at `docs/knowledge/instrument_samples_index.md` records the mapping plus per-instrument metadata.

**Also read `CLAUDE.md`** for project conventions, safety rules, test requirements, and git/ntfy protocol. **Also read `cc_safety_discipline.md`** at the project root — especially §Core Rules "Never modify original source files". **Also read `claude-conventions.md`** for Python-file discipline (no `python -c` inline commands) and Filesystem MCP patterns.

---

## Integration Context

- **Platform:** Windows; PowerShell. Python scripts in `.py` files; never inline `python -c`.
- **Python environment:** Standard library only. `xml.etree.ElementTree`, `shutil.copytree`, `pathlib`, `re`, `json`. No external packages.
- **`config.sqlite3` at `assets/instrument-samples/config.sqlite3`:** Air Manager's own config database. Per D-02 §Stream B item 5, AM's config may reference the UUID directory names. We leave originals untouched to avoid breaking any AM install that points at this directory. Do NOT read, copy, or modify `config.sqlite3`.
- **Key files this task creates or modifies:**
  - NEW: `scripts/rename_instrument_samples.py`
  - NEW: `assets/instrument-samples-named/` (entire directory tree copied from originals with safe names)
  - NEW: `docs/knowledge/instrument_samples_index.md` — manifest
  - NEW: `tests/test_rename_instrument_samples.py`
- **File provenance:** `docs/knowledge/instrument_samples_index.md` MUST include a provenance header (Created, Source=this prompt path). `scripts/` and `assets/` do not require provenance headers.
- **Safety:** The script's primary correctness property is that `assets/instrument-samples/` is never modified. Enforce this by design: the script reads from originals and writes only to `assets/instrument-samples-named/`. A unit test verifies source files are unchanged after running.

---

## Implementation Order

**Execute phases sequentially in the order specified. Do NOT parallelize phases or launch subagents.**

Run tests after Phase D and do not proceed to Phase E if tests fail.

### Phase A: Slugify and safe-name derivation

Create `scripts/rename_instrument_samples.py`. At the top, implement:

1. `slugify(s: str) -> str`:
   - Lowercase
   - Replace runs of whitespace with single `-`
   - Strip accents if present (use `unicodedata.normalize('NFKD', s)` and drop combining marks)
   - Keep only `[a-z0-9_-]`; drop everything else
   - Collapse runs of `-` into single `-`
   - Strip leading/trailing `-`
   - If result is empty: return `'unknown'`
   - Examples:
     - `"Cessna 172"` → `"cessna-172"`
     - `"ADF"` → `"adf"`
     - `"G1000 (Perspective+)"` → `"g1000-perspective"`
     - `""` or `"   "` → `"unknown"`

2. `safe_name(aircraft: str, inst_type: str, uuid: str) -> str`:
   - Returns `f"{slugify(aircraft)}_{slugify(inst_type)}_{uuid[:8]}"`
   - Example: aircraft=`"Cessna 172"`, type=`"ADF"`, uuid=`"04a6aa5d-7aad-42e4-9ed7-ca313b0e2edb"` → `"cessna-172_adf_04a6aa5d"`

3. Collision resolution (returns the final safe name to use):
   - Compute initial safe name using 8-char UUID prefix
   - If name already taken by a different UUID: try 12-char UUID prefix
   - If still colliding: append `_2`, `_3`, ... until unique
   - Track collision history in the manifest

### Phase B: info.xml parsing

Implement `parse_info_xml(path: Path) -> dict` that reads an `info.xml` file and returns:

```python
{
    'uuid': str,
    'aircraft': str,              # <aircraft>
    'type': str,                  # <type>
    'author': str,                # <author>; '' if missing
    'description': str,           # <description>; '' if missing; strip leading/trailing whitespace
    'version': int,               # <version> as int; -1 if missing or unparseable
    'plugin_interface_version': int,  # <pluginInterfaceVersion>; -1 if missing
    'pref_width': int,            # <prefWidth>; -1 if missing
    'pref_height': int,           # <prefHeight>; -1 if missing
    'source': str,                # <source>; '' if missing
    'compatible_fsx': bool,       # <compatibleFSX>
    'compatible_p3d': bool,       # <compatibleP3D>
    'compatible_xpl': bool,       # <compatibleXPL>
    'compatible_fs2': bool,       # <compatibleFS2>
    'compatible_fs2020': bool,    # <compatibleFS2020>
    'compatible_fs2024': bool,    # <compatibleFS2024>
    'platforms': list[str],       # <platforms><platform>…
    'tiers': list[str],           # <tiers><tier>…
}
```

Robustness:
- `<aircraft>` and `<type>` are required; raise ValueError with the path if either is missing or empty
- `<uuid>` is required; raise ValueError if missing. Compare against the directory name — mismatch is a warning (log it, continue with the XML value as truth)
- Boolean fields: `'true'`/`'false'` (case-insensitive); missing or unrecognized → False
- Integer fields: missing or unparseable → -1
- List fields (`<platforms>`, `<tiers>`): missing → empty list

### Phase C: Copy logic

Implement `copy_instrument(src_dir: Path, dst_dir: Path)` that uses `shutil.copytree(src_dir, dst_dir, dirs_exist_ok=False)`.

Idempotency strategy:
- Before copying, check if `dst_dir` already exists
- If it exists and contains a `.source_manifest.json` with a matching UUID (same source), skip the copy with a "already present, skipping" log message
- If it exists but the manifest is missing or UUID mismatches: raise an error — this indicates a partial or corrupted prior run; require manual cleanup
- After a successful copy, write `.source_manifest.json` inside the destination directory with: `source_uuid`, `source_path` (relative to project root), `copied_at` (ISO 8601)

### Phase D: Main script flow

`main()`:

1. Parse args with `argparse`:
   - `--source` (default `assets/instrument-samples`)
   - `--destination` (default `assets/instrument-samples-named`)
   - `--manifest` (default `docs/knowledge/instrument_samples_index.md`)
   - `--dry-run` flag
2. Resolve source directory; enumerate all subdirectories (skip files — `config.sqlite3` is at the top level and must be skipped, which it will be because it's not a directory; still, verify by checking `.is_dir()`)
3. For each source subdir:
   - Verify it's a UUID-shaped name (regex check). If not a UUID, log warning and skip.
   - Verify `info.xml` exists. If not, log error for that directory; record in manifest as an error entry; continue.
   - Parse info.xml
   - Compute safe name via collision resolution (track used names across the whole run)
   - If `--dry-run`: log `would copy <src> -> <dst>`; continue
   - Copy to destination
   - Record entry for manifest
4. Write manifest file at `--manifest` path — see Phase E for format
5. Print summary: total source dirs, copied, skipped-idempotent, errored, total collisions resolved

### Phase E: Manifest generation

`docs/knowledge/instrument_samples_index.md` format:

```markdown
# Instrument Samples Index

**Created:** <ISO 8601 timestamp>
**Source:** docs/tasks/rename_instrument_samples_prompt.md
**Generated by:** scripts/rename_instrument_samples.py
**Total samples:** <N>
**Copy destination:** `assets/instrument-samples-named/`
**Originals (never modified):** `assets/instrument-samples/`

## Summary

- Copied this run: <N>
- Already present (idempotent skip): <N>
- Errored: <N>
- Collisions resolved (beyond 8-char prefix): <N>

## Samples

| Safe name | UUID | Aircraft | Type | Author | Sim compat | Dimensions | Version |
|-----------|------|----------|------|--------|------------|------------|---------|
| <safe_name> | <full uuid> | <aircraft> | <type> | <author> | <comma-separated sims> | <WxH> | <version> |
| ...         | ...        | ...        | ...   | ...    | ...                    | ...     | ...     |

## Errors

<If no errors: "None.">
<Otherwise, one section per errored entry with directory name, error message, and any partial metadata recovered.>

## Collision history

<If no collisions beyond 8-char prefix: "None.">
<Otherwise, one line per collision: original-attempted-name → final-resolved-name (reason).>

## Sim compatibility legend

| Abbrev | Platform |
|--------|----------|
| FSX | Microsoft Flight Simulator X |
| P3D | Prepar3D |
| XPL | X-Plane |
| FS2 | Flight Simulator 2004 |
| FS2020 | Microsoft Flight Simulator (2020) |
| FS2024 | Microsoft Flight Simulator (2024) |

## Raw data

Structured JSON at `assets/instrument-samples-named/_index.json` for programmatic access. Same data as the table above plus description text.
```

Also emit `assets/instrument-samples-named/_index.json` — a JSON array with one object per sample containing all fields from `parse_info_xml` plus `safe_name` and `source_uuid_dir`.

Sort the samples table alphabetically by safe_name (deterministic output).

Sim compatibility column format: comma-separated list of abbreviations for each True flag, e.g., `XPL, FS2020, FS2024`.

Dimensions column: `{pref_width}x{pref_height}`; if either is -1, show `?`.

### Phase F: Tests

Create `tests/test_rename_instrument_samples.py`. Use tmp directories (via `tmp_path` pytest fixture) — do NOT test against real `assets/instrument-samples/`.

Required test coverage:

1. **slugify:**
   - `"Cessna 172"` → `"cessna-172"`
   - `"ADF"` → `"adf"`
   - `"G1000 (Perspective+)"` → `"g1000-perspective"`
   - `""` → `"unknown"`
   - `"   "` → `"unknown"`
   - `"á é í ó ú"` → `"a-e-i-o-u"` (accent stripping)
   - Idempotent: `slugify(slugify(s)) == slugify(s)` for a sample of inputs

2. **safe_name:**
   - Known example: `safe_name("Cessna 172", "ADF", "04a6aa5d-7aad-42e4-9ed7-ca313b0e2edb")` == `"cessna-172_adf_04a6aa5d"`

3. **Collision resolution:**
   - Two UUIDs with same aircraft+type produce different 8-char suffixes → no collision
   - Force a collision (mock identical 8-char prefixes) → second one uses 12-char prefix
   - Force further collision → `_2` suffix appears

4. **info.xml parsing:**
   - Valid minimal XML → correct dict
   - Missing `<aircraft>` → ValueError
   - Missing `<type>` → ValueError
   - Missing `<uuid>` → ValueError
   - UUID-in-xml vs directory-name mismatch → warning (capture log), XML wins
   - Boolean parsing: `"true"`, `"True"`, `"TRUE"` → True; `"false"`, `""`, missing → False
   - Integer parsing: valid int → int; `"abc"` → -1; missing → -1
   - List fields missing → empty list

5. **Copy logic + idempotency:**
   - First copy creates destination; `.source_manifest.json` written
   - Second copy with same source UUID: skipped, no error
   - Second copy with different source UUID into same destination name: raises error
   - Destination directory is byte-identical to source (same files, same content)

6. **Source immutability:**
   - After running the main flow against a tmp source, read checksums of all source files; compare to checksums taken before. Must be identical. This is the critical invariant.

Test command: `python -m pytest tests/test_rename_instrument_samples.py -v`.

### Phase G: Smoke-test run

1. Dry run first:
   ```
   python scripts/rename_instrument_samples.py --dry-run
   ```
   Verify it reports 45 source directories and would-copy actions for all; no errors.

2. Real run:
   ```
   python scripts/rename_instrument_samples.py
   ```
   Verify: 45 destinations created under `assets/instrument-samples-named/`, manifest file written, JSON index written, originals unchanged (spot-check the first UUID directory's file sizes before and after).

3. Idempotency check:
   ```
   python scripts/rename_instrument_samples.py
   ```
   Re-run the same command. Verify it reports 45 already-present skips, 0 copies, 0 errors, and does not modify any file.

---

## Completion Protocol

1. Run full test suite for this task: `python -m pytest tests/test_rename_instrument_samples.py -v`
2. Record final test count and pass/fail status
3. Capture smoke-test output into the completion report
4. Write completion report to `docs/tasks/rename_instrument_samples_completion.md` with:
   - Provenance header (Created, Source=this prompt path)
   - Summary of what was built (module list)
   - Test results (count, pass/fail)
   - Smoke-test results (source count, copied count, errors, collisions, idempotency confirmation)
   - Sample of the manifest (first 5 rows of the samples table)
   - Any deviations from this prompt with rationale
5. `git add -A`
6. `git commit -m "SAMPLES-RENAME-01: copy instrument samples with safe names and generate manifest [refs: D-02, GNC355_Prep_Implementation_Plan_V1]"`
7. **Flag refresh check:** This task does not modify `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`. Do NOT create refresh flags.
8. Send completion notification:
   ```
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "SAMPLES-RENAME-01 completed [flight-sim]"
   ```

**Do NOT git push.** Steve pushes manually.
