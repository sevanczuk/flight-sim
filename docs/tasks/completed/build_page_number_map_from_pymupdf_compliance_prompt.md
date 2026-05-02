# CC Task Prompt: GNX375-PAGEMAP-PYMUPDF-01 Compliance Verification

**Task ID:** GNX375-PAGEMAP-PYMUPDF-01-COMPLIANCE
**Verifying:** GNX375-PAGEMAP-PYMUPDF-01 (completed 2026-05-02)
**Prompt:** `docs/tasks/build_page_number_map_from_pymupdf_prompt.md`
**Completion:** `docs/tasks/build_page_number_map_from_pymupdf_completion.md`
**Source of truth:** `docs/decisions/D-28-page-2-pap-recycling-code-not-page-number.md` and the prompt above

---

## Instructions

This is a **read-only verification task** with one exception: check **D1** requires running the transform script a second time, which by design overwrites `assets/gnx375_pymupdf_v1_0_1/page_number_map.json`. That re-run is expected and intentional. Do NOT modify any other source files.

Read `CLAUDE.md` for project conventions. Per CLAUDE.md, never use inline `python -c` — save multi-step Python checks to `.py` files in a temp scratch directory (e.g., `/tmp/compliance_check_*.py` or equivalent) and invoke them via `python <path>`.

For each checklist item below, report:

- **PASS** — with evidence (file path, line numbers, relevant snippet, command output)
- **FAIL** — with what was expected vs. what was found
- **PARTIAL** — with explanation of what's present and what's missing

Use `grep -n` and Python read-checks. Quote specific lines that prove compliance. Read `page_number_map.json` once into a Python dict for reuse across checks.

---

## Checklist

### S. Schema compliance (page_number_map.json structure)

**S1. Top-level keys in exact spec order.** Read `page_number_map.json` with Python's `json.load` (preserves insertion order in Python 3.7+) and verify `list(data.keys())` equals `["schema_version", "physical_to_logical", "logical_to_physical", "unparseable_pages", "logical_duplicates", "metadata", "extras"]` (7 keys, in that exact order).

**S2. schema_version value.** `data["schema_version"] == "2.0"` (string, not number `2.0`). Also verify `data["metadata"]["schema_version"] == "2.0"`.

**S3. metadata block has all 13 required fields.** Required field names: `schema_version`, `extraction_dir`, `extraction_tool`, `physical_page_count`, `parsed_count`, `unparseable_count`, `generated`, `source_pdf_path`, `extracted_at`, `footer_ratio`, `header_ratio`, `overrides_file`, `overrides_applied`. Report any missing or extra fields.

**S4. extras key set matches physical_to_logical key set.** `set(data["physical_to_logical"].keys()) == set(data["extras"].keys())` AND both have exactly 310 entries.

### L. Logic / Behavioral

**L1. Eight specific spot checks.** Verify each:

- `data["physical_to_logical"]["1"]` is null
- `data["physical_to_logical"]["2"]` is null
- `data["physical_to_logical"]["3"] == "i"`
- `data["physical_to_logical"]["4"] == "ii"`
- `data["physical_to_logical"]["308"] == "9-4"`
- `data["physical_to_logical"]["310"]` is null
- `data["logical_to_physical"]["i"] == 3`
- `data["logical_to_physical"]["9-4"] == 308`

**L2. Forward-inverse roundtrip on a 10-entry sample.** Pick 10 entries from `physical_to_logical` with non-null values (use a deterministic sample: every 30th non-null entry across the dataset). For each `(phys_str, logical)`, verify `data["logical_to_physical"][logical] == int(phys_str)`. Then pick 10 entries from `logical_to_physical` (same approach) and verify the reverse direction `data["physical_to_logical"][str(phys_int)] == logical`.

**L3. Counts match metadata.** Compute from the data:

- `non_null_count = sum(1 for v in data["physical_to_logical"].values() if v is not None)`
- `null_count = sum(1 for v in data["physical_to_logical"].values() if v is None)`
- `total = len(data["physical_to_logical"])`

Verify `non_null_count == data["metadata"]["parsed_count"] == 306`, `null_count == data["metadata"]["unparseable_count"] == 4`, `total == data["metadata"]["physical_page_count"] == 310`.

**L4. Override audit (multi-field).** Verify all of:

- `len(data["metadata"]["overrides_applied"]) == 1`
- `data["metadata"]["overrides_applied"][0]["physical_page"] == 2`
- `data["metadata"]["overrides_applied"][0]["field"] == "printed_page_number"`
- `data["metadata"]["overrides_applied"][0]["to"]` is null
- `data["metadata"]["overrides_applied"][0]["decision_ref"] == "D-28"`
- `data["extras"]["2"]["override_applied"] is True`
- `data["extras"]["2"]["override_rationale_ref"] == "D-28"`
- `data["extras"]["2"]["footer_text_raw"] == "22\nPAP"` (the raw footer text from page_metadata.json — preserve the literal `\n`)
- Count of `extras` records with `override_applied is True` equals 1 (matches `len(metadata.overrides_applied)`)

**L5. Encoding preservation.** Read `page_metadata.json` and `page_number_map.json` both with UTF-8. For physical pages 3, 4, 5, 7 (which contain "Pilot's Guide" with the smart apostrophe character U+2019), verify `page_number_map.json["extras"][k]["footer_text_raw"]` equals `page_metadata.json["pages"][k]["footer_text_raw"]` byte-for-byte. Quote the actual characters in your evidence (the smart apostrophe should appear as `'`, not `&#8217;` or `\u2019`).

### A. Sort ordering

**A1. physical_to_logical key order is integer-sorted, not lexicographic.** Verify `list(data["physical_to_logical"].keys())[:12] == ["1","2","3","4","5","6","7","8","9","10","11","12"]`. (Lexicographic sort would give `["1","10","100","101",...]` — that's the failure mode being checked for.) Also verify the last 3 keys are `["308","309","310"]`.

**A2. logical_to_physical values are monotonically non-decreasing.** `vals = list(data["logical_to_physical"].values())`; verify `all(vals[i] <= vals[i+1] for i in range(len(vals)-1))`.

**A3. unparseable_pages == [1, 2, 309, 310]** in that exact order (list, not set).

### N. Negative / Source integrity

**N1. Source files untouched by the GNX375-PAGEMAP-PYMUPDF-01 commit.** Run `git log -1 --name-only --pretty=format: <commit-sha>` for the GNX375-PAGEMAP-PYMUPDF-01 commit (find via `git log --grep="GNX375-PAGEMAP-PYMUPDF-01:" -1 --format=%H`). The changeset must NOT include any of: `assets/gnx375_pymupdf_v1_0_1/page_metadata.json`, `assets/gnx375_pymupdf_v1_0_1/page_overrides.json`, `docs/decisions/D-28-page-2-pap-recycling-code-not-page-number.md`. Expected changeset (allowed entries): `scripts/build_page_number_map_from_pymupdf.py`, `assets/gnx375_pymupdf_v1_0_1/page_number_map.json`, `docs/tasks/build_page_number_map_from_pymupdf_completion.md`. Quote the full file list in evidence.

### D. Determinism

**D1. Re-run script and confirm only `metadata.generated` changes.** Steps:

1. Read `assets/gnx375_pymupdf_v1_0_1/page_number_map.json` into `before` (Python dict).
2. Run `python scripts/build_page_number_map_from_pymupdf.py` (this overwrites the file — expected).
3. Read the new `page_number_map.json` into `after`.
4. Walk both dicts recursively. Collect every path where `before` and `after` differ.
5. PASS condition: the only differing path is `metadata.generated`. Any other path differing is FAIL.
6. After this check completes, the on-disk file is the post-rerun version. That's the canonical state going forward — no need to restore the prior version.

Save the diff-walking script as a `.py` file in a scratch directory (per CLAUDE.md: never inline `python -c`).

### G. Git / Commit compliance

**G1. Commit message has D-04 trailers in the correct format.** Run `git log -1 --grep="GNX375-PAGEMAP-PYMUPDF-01:" --format=fuller` (or use `--format="%H%n%n%B"` for the raw message). Verify all of:

- Subject begins with `GNX375-PAGEMAP-PYMUPDF-01:`
- `Task-Id: GNX375-PAGEMAP-PYMUPDF-01` trailer present
- `Authored-By-Instance: cc` trailer present
- `Refs:` trailer present and includes `D-28`
- `Co-Authored-By: Claude Code <noreply@anthropic.com>` trailer present
- No leading BOM or invisible characters in the subject line (sanity-check via `git log -1 --format="%s" | head -c 50 | od -c | head -2`)

### C. Script-level checks (build_page_number_map_from_pymupdf.py)

**C1. json.dump call uses required parameters.** `grep -n 'json.dump' scripts/build_page_number_map_from_pymupdf.py`. The output-write call must include `indent=2`, `ensure_ascii=False`, AND `sort_keys=False` (the last is critical — `sort_keys=True` would break the int-ordered keys). Quote the full `json.dump(...)` line.

**C2. Sanity checks are real assertions, not print-only.** Read the Phase E section of the script. For each of the 8 sanity checks, confirm there is a real conditional that can fail (e.g., `assert`, `if not <cond>:`, comparison-based check) and that the script exits with non-zero status on any failure. Quote at least 3 different sanity-check implementations to demonstrate. A passing C2 means: if the data were corrupt, the script would actually fail rather than print "OK" regardless.

---

## Output

Write the compliance report to `docs/tasks/build_page_number_map_from_pymupdf_compliance.md` with this structure:

```markdown
---
Created: <iso8601>
Source: docs/tasks/build_page_number_map_from_pymupdf_compliance_prompt.md
---

# GNX375-PAGEMAP-PYMUPDF-01 Compliance Report

**Verified:** <timestamp>
**Verdict:** <ALL PASS | PASS WITH NOTES | FAILURES FOUND>

## Summary
- Total checks: 17
- Passed: <N>
- Failed: <N>
- Partial: <N>

## Results

### S. Schema compliance
S1. <PASS|FAIL|PARTIAL> — <evidence>
... (S1 through S4)

### L. Logic / Behavioral
... (L1 through L5)

### A. Sort ordering
... (A1 through A3)

### N. Negative / Source integrity
... (N1)

### D. Determinism
... (D1)

### G. Git / Commit compliance
... (G1)

### C. Script-level checks
... (C1, C2)

## Notes

<Any observations, minor deviations, or recommendations that don't rise to FAIL level but are worth documenting.>
```

---

## Completion Protocol

1. Write compliance report to `docs/tasks/build_page_number_map_from_pymupdf_compliance.md`.

2. Stage and commit:
   ```
   git add docs/tasks/build_page_number_map_from_pymupdf_compliance_prompt.md docs/tasks/build_page_number_map_from_pymupdf_compliance.md assets/gnx375_pymupdf_v1_0_1/page_number_map.json
   ```
   (The `page_number_map.json` is included because D1's re-run will have changed `metadata.generated`. That's the only intended change. If anything else differs, D1 should have reported FAIL.)

   Commit message (D-29 simple format):
   ```
   git commit -m "GNX375-PAGEMAP-PYMUPDF-01-COMPLIANCE: verification report [AI commit]" -m "Verifies the GNX375-PAGEMAP-PYMUPDF-01 implementation against the prompt requirements and D-28. <N>/17 checks passed." -m "Refs: GNX375-PAGEMAP-PYMUPDF-01, D-28"
   ```

3. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-PAGEMAP-PYMUPDF-01-COMPLIANCE completed [flight-sim]"
   ```

4. **Do NOT git push.** Steve pushes after CD reviews compliance.
