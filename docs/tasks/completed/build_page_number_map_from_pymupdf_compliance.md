---
Created: 2026-05-02T07:57:00-04:00
Source: docs/tasks/build_page_number_map_from_pymupdf_compliance_prompt.md
---

# GNX375-PAGEMAP-PYMUPDF-01 Compliance Report

**Verified:** 2026-05-02T07:57:02-04:00
**Verdict:** ALL PASS

## Summary
- Total checks: 17
- Passed: 17
- Failed: 0
- Partial: 0

## Results

### S. Schema compliance

**S1. PASS** — Top-level keys in exact spec order.
`list(data.keys()) == ["schema_version", "physical_to_logical", "logical_to_physical", "unparseable_pages", "logical_duplicates", "metadata", "extras"]` (7 keys confirmed).

**S2. PASS** — `data["schema_version"] == "2.0"` (str); `data["metadata"]["schema_version"] == "2.0"` (str). Neither is a float.

**S3. PASS** — All 13 required fields present in `metadata`: `['extracted_at', 'extraction_dir', 'extraction_tool', 'footer_ratio', 'generated', 'header_ratio', 'overrides_applied', 'overrides_file', 'parsed_count', 'physical_page_count', 'schema_version', 'source_pdf_path', 'unparseable_count']`. No missing or extra fields.

**S4. PASS** — `set(data["physical_to_logical"].keys()) == set(data["extras"].keys())` and both have exactly 310 entries.

### L. Logic / Behavioral

**L1. PASS** — All 8 spot checks pass:
- `p2l["1"]` is None ✓
- `p2l["2"]` is None ✓ (override applied: D-28 PAP 22)
- `p2l["3"] == "i"` ✓
- `p2l["4"] == "ii"` ✓
- `p2l["308"] == "9-4"` ✓
- `p2l["310"]` is None ✓
- `l2p["i"] == 3` ✓
- `l2p["9-4"] == 308` ✓

**L2. PASS** — Forward roundtrip: sampled every 30th non-null physical page (`["3", "33", "63", "93", "123", "153", "183", "213", "243", "273"]`) — all `l2p[logical] == int(phys_str)`. Reverse roundtrip: sampled every 30th l2p entry (`["i", "1-17", "2-27", "2-57", "3-13", "3-43", "3-73", "4-5", "5-21", "6-3"]`) — all `p2l[str(phys_int)] == logical`.

**L3. PASS** — `non_null_count=306 == metadata.parsed_count==306`; `null_count=4 == metadata.unparseable_count==4`; `total=310 == metadata.physical_page_count==310`.

**L4. PASS** — All 9 override checks pass:
- `len(overrides_applied) == 1` ✓
- `overrides_applied[0]["physical_page"] == 2` ✓
- `overrides_applied[0]["field"] == "printed_page_number"` ✓
- `overrides_applied[0]["to"]` is None ✓
- `overrides_applied[0]["decision_ref"] == "D-28"` ✓
- `extras["2"]["override_applied"] is True` ✓
- `extras["2"]["override_rationale_ref"] == "D-28"` ✓
- `extras["2"]["footer_text_raw"] == "22\nPAP"` ✓ (literal newline preserved)
- Count of extras records with `override_applied is True` == 1 ✓

**L5. PASS** — UTF-8 encoding preserved for pages 3, 4, 5, 7. The "Pilot's Guide" footer text (containing U+2019 RIGHT SINGLE QUOTATION MARK `'`) is byte-for-byte identical between `page_metadata.json` and `page_number_map.json["extras"]` for all 4 pages. Example:
- page 3: `'190-02488-01 Rev. C\nPilot’s Guide\ni'` — match=True
- page 4: `'ii\nPilot’s Guide\n190-02488-01 Rev. C\n...'` — match=True
- page 5: `'190-02488-01 Rev. C\nPilot’s Guide\niii'` — match=True
- page 7: `'190-02488-01 Rev. C\nPilot’s Guide\nv\n...'` — match=True

### A. Sort ordering

**A1. PASS** — First 12 keys: `["1","2","3","4","5","6","7","8","9","10","11","12"]` (integer-sorted, not lexicographic). Last 3 keys: `["308","309","310"]`.

**A2. PASS** — All 306 `logical_to_physical` values are monotonically non-decreasing (first=3, last=308).

**A3. PASS** — `unparseable_pages == [1, 2, 309, 310]` in exact order (list, not set).

### N. Negative / Source integrity

**N1. PASS** — Commit `5da0afd41304a5b87fcb39a188752d6252d01335` (`git log -1 --name-only --pretty=format: 5da0afd`) does NOT touch any prohibited source files. Prohibited files absent from changeset: `assets/gnx375_pymupdf_v1_0_1/page_metadata.json` ✓, `assets/gnx375_pymupdf_v1_0_1/page_overrides.json` ✓, `docs/decisions/D-28-page-2-pap-recycling-code-not-page-number.md` ✓.

Full changeset:
```
assets/gnx375_pymupdf_v1_0_1/page_number_map.json
docs/tasks/build_page_number_map_from_pymupdf_completion.md
docs/tasks/build_page_number_map_from_pymupdf_prompt.md
scripts/build_page_number_map_from_pymupdf.py
```

(Note: `build_page_number_map_from_pymupdf_prompt.md` was committed alongside the implementation — 4 files vs. the 3 listed in the compliance prompt. This is not a violation; the prompt file is not prohibited.)

### D. Determinism

**D1. PASS** — Re-run script (`python scripts/build_page_number_map_from_pymupdf.py`). Script completed with exit 0; all 8 sanity checks passed. Recursive diff found exactly 1 differing path:
```
metadata.generated: '2026-05-02T07:49:39-04:00' -> '2026-05-02T07:57:02-04:00'
```
No other paths differ. The on-disk file is now the post-rerun canonical version.

### G. Git / Commit compliance

**G1. PASS** — Commit message verified via `git log -1 --grep="GNX375-PAGEMAP-PYMUPDF-01:" --format="%H%n%n%B"`:
- Subject begins with `GNX375-PAGEMAP-PYMUPDF-01:` ✓ — `"GNX375-PAGEMAP-PYMUPDF-01: build page_number_map.json from PyMuPDF metadata"`
- `Task-Id: GNX375-PAGEMAP-PYMUPDF-01` ✓
- `Authored-By-Instance: cc` ✓
- `Refs: D-28` ✓
- `Co-Authored-By: Claude Code <noreply@anthropic.com>` ✓
- No BOM or invisible characters: `od -c` of first 50 chars starts `G N X 3 7 5 - P A G E M A P - P Y M U P D F - 0 1 : b u i l d p a g e _ n u m b e r _ m a p . j` — clean ASCII ✓

### C. Script-level checks

**C1. PASS** — `grep -n 'json.dump' scripts/build_page_number_map_from_pymupdf.py`:
```
213:        json.dump(out, f, indent=2, ensure_ascii=False, sort_keys=False)
```
All three required parameters present: `indent=2` ✓, `ensure_ascii=False` ✓, `sort_keys=False` ✓.

**C2. PASS** — Phase E (`run_sanity_checks`) uses a `check(label, cond, detail)` helper that appends `label` to `failures` list when `cond` is False. After all 8 checks, `main()` calls `sys.exit(1)` if `failures` is non-empty (script:366-368). Three representative implementations:

1. **Check 2 — Page count** (script:251-254):
   ```python
   check("2. Page count", len(p2l) == meta["physical_page_count"] == 310, ...)
   ```

2. **Check 5 — Forward-inverse roundtrip** (script:275-285):
   ```python
   roundtrip_ok = True
   for phys_str, logical in p2l.items():
       if logical is not None:
           if l2p.get(logical) != int(phys_str):
               roundtrip_ok = False; break
   for logical, phys_int in l2p.items():
       if p2l.get(str(phys_int)) != logical:
           roundtrip_ok = False; break
   check("5. Forward-inverse roundtrip", roundtrip_ok)
   ```

3. **Check 8 — Override audit** (script:306-320):
   ```python
   override_ok = (len(ov_applied) == 1
       and ov_applied[0]["physical_page"] == 2
       and ov_applied[0]["decision_ref"] == "D-28"
       and extras.get("2", {}).get("override_applied") is True
       and extras.get("2", {}).get("override_rationale_ref") == "D-28"
       and len(extras_with_override) == len(ov_applied))
   check("8. Override audit", override_ok, ...)
   ```

Exit gate (script:366-368): `if failures: print(...); sys.exit(1)` — confirmed non-zero exit on any failure.

## Notes

- **N1 extra file:** The commit includes `docs/tasks/build_page_number_map_from_pymupdf_prompt.md` (4 files total vs. 3 listed in the compliance prompt expected changeset). This is benign — the prompt file is read-only documentation, not a prohibited source file.
- **D1 re-run:** All 8 built-in sanity checks passed on re-run, confirming script correctness is independent of environment state.
- **L5 display note:** The U+2019 smart apostrophe in "Pilot's Guide" renders correctly in the JSON file; some terminal emulators may display it as a replacement character (`?`) but the bytes are preserved correctly.
