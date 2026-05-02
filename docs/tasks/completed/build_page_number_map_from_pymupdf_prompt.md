# CC Task Prompt: Build page_number_map.json from PyMuPDF page_metadata.json

**Location:** `docs/tasks/build_page_number_map_from_pymupdf_prompt.md`
**Task ID:** GNX375-PAGEMAP-PYMUPDF-01
**Spec:** None (schema is defined inline in this prompt)
**Depends on:** None — `page_metadata.json` already exists at `assets/gnx375_pymupdf_v1_0_1/page_metadata.json`
**Priority:** Critical-path; unblocks ITM-11 closure and downstream V1 spec citation validation
**Estimated scope:** Small — ~80–120 line script + small JSON output + built-in sanity checks
**Task type:** code
**Source of truth:**
- `docs/decisions/D-28-page-2-pap-recycling-code-not-page-number.md`
- This prompt (defines the v2.0 page_number_map.json schema)
**Audit level:** self-check only — single new script, deterministic mechanical transform, sanity checks built into the script
**Phase 0 scope:** D-28 in full; this prompt's "Schema and semantics" + "Sanity checks" sections

---

## Pre-flight Verification

**Execute these checks before writing any code. If any check fails, STOP and write a deviation report.**

1. Verify input file exists and is non-empty:
   ```
   ls -la assets/gnx375_pymupdf_v1_0_1/page_metadata.json
   ```
   Expected: file exists, ~30–60 KB.

2. Verify input file schema by reading the first 25 lines:
   ```
   head -n 25 assets/gnx375_pymupdf_v1_0_1/page_metadata.json
   ```
   Expected: top-level keys `extracted_at`, `source_pdf`, `page_count`, `footer_ratio`, `header_ratio`, `pages`. Inside `pages`, the value for key `"1"` is an object with fields `footer_text_raw`, `printed_page_number`, `parse_warning`. The value for key `"2"` has `printed_page_number: null` (per D-28).

3. Verify override file exists:
   ```
   ls -la assets/gnx375_pymupdf_v1_0_1/page_overrides.json
   ```
   Expected: file exists, contains an `overrides` object with key `"2"`.

4. Verify D-28 exists:
   ```
   ls -la docs/decisions/D-28-page-2-pap-recycling-code-not-page-number.md
   ```

5. Verify scripts/ directory exists:
   ```
   ls -d scripts/
   ```
   If absent, create it: `mkdir -p scripts/`.

6. **Test baseline:** flight-sim has no established pytest infrastructure (CLAUDE.md `Tests: TBD`). This task does not run a baseline test suite. Sanity checks are built into the script's execution and serve as the verification gate.

**If any check fails:** Write `docs/tasks/build_page_number_map_from_pymupdf_prompt_deviation.md` with the deviation report structure (see CC_Task_Prompt_Template.md). Stage, commit, ntfy, and STOP.

---

## Phase 0: Source-of-Truth Audit

Before any implementation work:

1. Read `docs/decisions/D-28-page-2-pap-recycling-code-not-page-number.md` in full.
2. Read this prompt's "Schema and semantics" and "Sanity checks" sections in full.
3. Extract all actionable requirements:
   - From D-28: page 2 must remain `null`; the transform must support an override-file mechanism (path #2 in D-28); override audit trail must be preserved in the output.
   - From this prompt: schema_version "2.0"; null sentinel (not "unparseable"); top-level `extras` block; per-page `footer_text_raw` and `parse_warning` preserved; metadata block carries extraction provenance + override audit; deterministic key ordering; all 8 sanity checks must run and pass.
4. Cross-reference each requirement against the implementation phases in this prompt.
5. If ALL requirements are covered: print `Phase 0: all source requirements covered` and proceed.
6. If uncovered requirements are found:
   - Write `docs/tasks/build_page_number_map_from_pymupdf_prompt_phase0_deviation.md`.
   - Stage, commit, ntfy.
   - Print: `Phase 0 BLOCKED — uncovered requirements found. Awaiting continuation file before proceeding.`
   - STOP.

---

## Instructions

Implement `scripts/build_page_number_map_from_pymupdf.py` per the schema and semantics specified below. The script is a deterministic mechanical transform: read inputs, apply overrides, build maps, write output, run sanity checks.

**Read this entire prompt before writing any code.** Follow it literally.

**Also read `CLAUDE.md`** for project conventions, safety rules, and commit-message format.

---

## Integration Context

**Runtime:**
- Windows 11 host; PowerShell 5.x is the operator's shell. Script invoked via `python scripts\build_page_number_map_from_pymupdf.py`.
- Python 3.11+ is the project standard.

**File paths (all repo-relative from project root `C:/Users/artroom/projects/flight-sim-project/flight-sim/`):**
- **Input — page metadata:** `assets/gnx375_pymupdf_v1_0_1/page_metadata.json`
- **Input — overrides (optional):** `assets/gnx375_pymupdf_v1_0_1/page_overrides.json`
- **Output — page number map:** `assets/gnx375_pymupdf_v1_0_1/page_number_map.json`
- **Script:** `scripts/build_page_number_map_from_pymupdf.py`

**Encoding:** All JSON I/O is UTF-8 with `ensure_ascii=False` (so smart quotes and other unicode in `footer_text_raw` are preserved as-is, not escaped).

**Determinism:** Same inputs must produce byte-identical output across runs. No timestamps in primary maps; `metadata.generated` is the only time-varying field and uses the script's invocation time in ISO 8601 with timezone offset.

**Key files this task creates:**
- `scripts/build_page_number_map_from_pymupdf.py`
- `assets/gnx375_pymupdf_v1_0_1/page_number_map.json`

---

## Schema and semantics

### Output: `page_number_map.json` (schema_version 2.0)

Top-level structure (in this exact order — emit as an `OrderedDict` or use Python 3.7+ insertion-ordered dicts):

```json
{
  "schema_version": "2.0",
  "physical_to_logical": { ... },
  "logical_to_physical": { ... },
  "unparseable_pages": [ ... ],
  "logical_duplicates": [ ... ],
  "metadata": { ... },
  "extras": { ... }
}
```

**`physical_to_logical`** — dict keyed by stringified physical page number (e.g., `"1"`, `"2"`, ... `"310"`). Value is the parsed `printed_page_number` from `page_metadata.json` (after override application), or `null` if unparseable. Key order: ascending by integer interpretation of the key.

**`logical_to_physical`** — dict keyed by printed page identifier (e.g., `"i"`, `"ii"`, `"1-1"`, `"9-4"`). Value is the integer physical page number. Only includes parsed entries (skip nulls). Key order: by ascending physical page number (so reading top-to-bottom matches the order pages appear in the manual).

**`unparseable_pages`** — list of integer physical page numbers where `printed_page_number` is null. Sorted ascending.

**`logical_duplicates`** — list of duplicate-detection records. Each record: `{"printed_page_number": <string>, "physical_pages": [<int>, ...]}`. Empty list if no duplicates. Sorted by the duplicate identifier string.

**`metadata`** — provenance and audit block:

```json
{
  "schema_version": "2.0",
  "extraction_dir": "assets/gnx375_pymupdf_v1_0_1/",
  "extraction_tool": "pymupdf-extract V1.0.1",
  "physical_page_count": 310,
  "parsed_count": 306,
  "unparseable_count": 4,
  "generated": "<iso8601 with offset, e.g. 2026-05-02T07:35:12-04:00>",
  "source_pdf_path": "<verbatim from page_metadata.json.source_pdf>",
  "extracted_at": "<verbatim from page_metadata.json.extracted_at>",
  "footer_ratio": 0.07,
  "header_ratio": 0.0,
  "overrides_file": "assets/gnx375_pymupdf_v1_0_1/page_overrides.json",
  "overrides_applied": [
    {"physical_page": 2, "field": "printed_page_number", "to": null, "rationale": "PAP 22 paper recycling code, not a page identifier", "decision_ref": "D-28"}
  ]
}
```

If the overrides file does not exist: `overrides_file: null`, `overrides_applied: []`.

**`extras`** — dict keyed by stringified physical page number (same key set and ordering as `physical_to_logical`). Per-page record:

```json
{
  "footer_text_raw": "<verbatim from page_metadata.json>",
  "parse_warning": "<verbatim from page_metadata.json>"
}
```

If an override was applied to that page, add two extra fields:

```json
{
  "footer_text_raw": "...",
  "parse_warning": null,
  "override_applied": true,
  "override_rationale_ref": "D-28"
}
```

### Override semantics

For each entry in `page_overrides.json["overrides"]`:

1. The key is a stringified physical page number.
2. The value is an object with field overrides; for v1 of this script, only `printed_page_number` is recognized. Unknown override fields trigger a warning but are not fatal.
3. If the physical page key exists in `page_metadata.json["pages"]`:
   - Replace `printed_page_number` with the override value (which may be `null`).
   - Record an entry in `metadata.overrides_applied` regardless of whether the override changed the value (the contract is "override processed," not "override changed the result").
   - Set `extras[key].override_applied = true` and `extras[key].override_rationale_ref = override.decision_ref`.
4. If the physical page key does NOT exist in `page_metadata.json["pages"]`:
   - Print a warning to stderr. Do not fail.
   - Do not record in `overrides_applied`.

For this run, the override at key `"2"` will match `page_metadata.json` page 2's existing `null` value (Steve already edited the source file directly per D-28 path #1). The override is recorded as applied; defense-in-depth.

### Counts

- `physical_page_count` = total entries in `page_metadata.json["pages"]` = 310.
- `parsed_count` = entries with non-null `printed_page_number` after override application.
- `unparseable_count` = entries with null `printed_page_number` after override application.
- For this dataset: parsed = 306, unparseable = 4 (pages 1, 2, 309, 310).

---

## Implementation Order

**Execute phases sequentially.** Do NOT parallelize phases or launch subagents.

### Phase A — Read inputs

1. Read `assets/gnx375_pymupdf_v1_0_1/page_metadata.json` with `json.load(open(..., encoding='utf-8'))`. Bind to `metadata_in`.
2. Try to read `assets/gnx375_pymupdf_v1_0_1/page_overrides.json`. If present, bind to `overrides_in`. If absent, `overrides_in = {"overrides": {}}` and print `WARN: page_overrides.json not found; proceeding with no overrides`.
3. Validate input schema:
   - `metadata_in` has top-level keys `extracted_at`, `source_pdf`, `page_count`, `footer_ratio`, `header_ratio`, `pages`.
   - `metadata_in["page_count"] == len(metadata_in["pages"])`.
   - Each page record has `footer_text_raw`, `printed_page_number`, `parse_warning`.

### Phase B — Apply overrides and build maps

1. Initialize empty dicts/lists: `physical_to_logical`, `logical_to_physical`, `unparseable_pages`, `extras`, `overrides_applied`.
2. Iterate `metadata_in["pages"]` items (key is string physical page, value is record):
   - Determine effective `printed_page_number`: start with the value from page_metadata.json, then apply override if present (per "Override semantics" above).
   - If the physical page key has an override, append the audit entry to `overrides_applied` and mark the extras record.
   - Add to `physical_to_logical[key]` as the effective value (or null).
   - If effective value is non-null: add to `logical_to_physical[effective]` mapping to int(key); also detect duplicates (if `effective` is already in `logical_to_physical`, append to a duplicates tracker).
   - If effective value is null: append int(key) to `unparseable_pages`.
   - Build `extras[key]` record with `footer_text_raw`, `parse_warning`, and override fields if applicable.
3. Iterate `overrides_in["overrides"]` and warn about any keys not present in `metadata_in["pages"]`.
4. Build `logical_duplicates` from the duplicates tracker.

### Phase C — Sort and assemble output

1. Sort `physical_to_logical` keys by `int(k)`.
2. Sort `logical_to_physical` entries by their integer value (physical page) ascending.
3. Sort `unparseable_pages` ascending.
4. Sort `logical_duplicates` by the duplicate identifier string.
5. Sort `extras` keys by `int(k)`.
6. Build `metadata` block per the schema, including:
   - `generated`: current local time in ISO 8601 with offset (use `datetime.now().astimezone().isoformat(timespec='seconds')`).
   - `source_pdf_path` and `extracted_at`: verbatim from `metadata_in`.
   - `overrides_file`: relative path string if file exists, else `None`.
   - `overrides_applied`: the list built in Phase B.

### Phase D — Write output

1. Build the top-level dict in the order specified ("Schema and semantics" → top-level structure).
2. Write to `assets/gnx375_pymupdf_v1_0_1/page_number_map.json` with:
   ```python
   json.dump(out, f, indent=2, ensure_ascii=False, sort_keys=False)
   f.write('\n')  # trailing newline
   ```
   Note: `sort_keys=False` because we've already sorted dicts in insertion order; built-in `sort_keys=True` would sort string keys lexicographically (breaking the int-ordered physical_to_logical and extras).

### Phase E — Sanity checks

Run all 8 checks against the in-memory output dict (don't re-read from disk). Print `OK` or `FAIL` per check. Exit with status 1 if any FAIL.

1. **Schema completeness:** all 7 top-level keys present (`schema_version`, `physical_to_logical`, `logical_to_physical`, `unparseable_pages`, `logical_duplicates`, `metadata`, `extras`); `schema_version == "2.0"`.
2. **Page count:** `len(physical_to_logical) == metadata.physical_page_count == 310`.
3. **Conservation:** `metadata.parsed_count + metadata.unparseable_count == metadata.physical_page_count` and arithmetic equals `306 + 4 == 310`.
4. **Unparseable list:** `len(unparseable_pages) == metadata.unparseable_count == 4`; all entries are ints; sorted set equals `{1, 2, 309, 310}`.
5. **Forward-inverse roundtrip:**
   - For every `(phys_str, logical)` in `physical_to_logical` where `logical is not None`: `logical_to_physical[logical] == int(phys_str)`.
   - For every `(logical, phys_int)` in `logical_to_physical`: `physical_to_logical[str(phys_int)] == logical`.
6. **No unexpected duplicates:** `logical_duplicates == []`.
7. **Spot checks:**
   - `physical_to_logical["3"] == "i"`
   - `physical_to_logical["4"] == "ii"`
   - `physical_to_logical["308"] == "9-4"`
   - `logical_to_physical["i"] == 3`
   - `logical_to_physical["9-4"] == 308`
8. **Override audit:**
   - `len(metadata.overrides_applied) == 1`.
   - `metadata.overrides_applied[0]["physical_page"] == 2`.
   - `metadata.overrides_applied[0]["decision_ref"] == "D-28"`.
   - `extras["2"]["override_applied"] == true` and `extras["2"]["override_rationale_ref"] == "D-28"`.
   - Count of extras records with `override_applied == true` equals `len(metadata.overrides_applied)`.

If all 8 pass, print:
```
All 8 sanity checks passed. page_number_map.json written.
```
and exit 0.

If any fail, print which checks failed with their assertion details and exit 1.

### Phase F — Run the script

1. Invoke: `python scripts\build_page_number_map_from_pymupdf.py`
2. Capture stdout and confirm "All 8 sanity checks passed" appears.
3. Verify the output file exists at `assets/gnx375_pymupdf_v1_0_1/page_number_map.json`.
4. `head -n 30` of the output to spot-check structure.
5. Quick eyeball: confirm the first dozen `physical_to_logical` entries match expectations: `"1": null, "2": null, "3": "i", "4": "ii", "5": "iii", "6": "iv", "7": "v", "8": "vi", "9": "vii", "10": "viii", ...`.

---

## Completion Protocol

1. Write completion report to `docs/tasks/build_page_number_map_from_pymupdf_completion.md`. Include:
   - Phase 0 result (`all source requirements covered` or deviation file reference)
   - Pre-flight check results (each numbered check + outcome)
   - Each phase's outcome (what got built / written)
   - Sanity check results (8/8 with each check listed)
   - Final empirical counts (310 / 306 / 4) verified against the output file
   - File outputs and their byte sizes
   - Any warnings or unexpected observations

2. Stage and commit:
   ```
   git add scripts/build_page_number_map_from_pymupdf.py assets/gnx375_pymupdf_v1_0_1/page_number_map.json docs/tasks/build_page_number_map_from_pymupdf_prompt.md docs/tasks/build_page_number_map_from_pymupdf_completion.md
   ```

   Commit message (D-04 trailer format):
   ```
   GNX375-PAGEMAP-PYMUPDF-01: build page_number_map.json from PyMuPDF metadata

   Mechanical transform from assets/gnx375_pymupdf_v1_0_1/page_metadata.json
   to assets/gnx375_pymupdf_v1_0_1/page_number_map.json (schema v2.0).
   Applies overrides from page_overrides.json (D-28 PAP 22 entry on page 2).
   8/8 built-in sanity checks pass; 310 total / 306 parsed / 4 unparseable.

   Task-Id: GNX375-PAGEMAP-PYMUPDF-01
   Authored-By-Instance: cc
   Refs: D-28
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

3. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-PAGEMAP-PYMUPDF-01 completed [flight-sim]"
   ```

4. **Do not push** — Steve pushes manually after CD review.

---

## Out of scope for this task

- ITM-11 closure verification (separate CD-direct turn after the new map exists).
- Building the dependency-audit for retired logical IDs (DEPENDENCY-AUDIT-01 — separate task).
- Any modification to `commons/pymupdf-extract` (out of flight-sim scope).
- Updates to `Spec_Tracker.md`, `CC_Task_Prompts_Status.md`, `priority_task_list.md`, `Task_flow_plan_with_current_status.md` (CD-maintained; CC does not update).
