# CC Task Prompt: GNX375-PAGEMAP-REBUILD-01 — Rebuild page_number_map against gnx375_llama_extract

**Location:** `docs/tasks/gnx375_pagemap_rebuild_prompt.md`
**Created:** 2026-04-30T11:43:00-04:00
**Source:** CD Purple session — Turn 31 (2026-04-30); follows the discovery in Turn 30 that the source PDF has 310 pages (Steve confirmed via Adobe Acrobat), making `gnx375_llama_extract/` the source-PDF-aligned canonical extraction and the original 330-page `gnc355_pdf_extracted/llamaparse_agentic_v1/` defective.
**Task ID:** GNX375-PAGEMAP-REBUILD-01
**Priority:** P0 — Steve has explicitly requested this task be run NOW before anything else.
**Task type:** code (Python script invocation + sanity check + commit)
**Estimated scope:** Small — ~3–5 min CC wall-clock.
**Audit level:** self-check — sanity-check the JSON output structure post-production.

**Source of truth:**
- `scripts/build_page_number_map.py` — already exists from GNX375-PAGEMAP-01; do NOT modify in this task
- `assets/gnx375_llama_extract/pages/` — 310 source-PDF-aligned page markdown files (this rebuild's input)

---

## Background

Quick context for CC:

- An earlier task (GNX375-PAGEMAP-01) produced `scripts/build_page_number_map.py` and ran it against `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages/` (330 pages), producing `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json`.
- After that, CD discovered (a) the project's canonical extraction is `assets/gnx375_llama_extract/` not the gnc355 path, and (b) the source PDF actually has 310 pages, not 330. The 330-page old extraction has 20 phantom pages and is defective.
- This task rebuilds the page_number_map against the source-PDF-aligned 310-page extraction at `assets/gnx375_llama_extract/`.
- A separate "corrections" prompt (Steve will provide it shortly) will fix the script's hardcoded defaults and verification logic. **This task does NOT modify the script.** It just runs it against the corrected input path.

---

## Pre-flight Verification

Execute these checks before running the rebuild. If any fails, STOP and write a deviation report.

1. Verify the script exists and is the expected version:
   ```powershell
   Test-Path "scripts\build_page_number_map.py"
   ```
   Should be `True`.

2. Verify the new pages directory exists with 310 page files:
   ```powershell
   (Get-ChildItem "assets\gnx375_llama_extract\pages\page_*.md").Count
   ```
   Should be `310`.

3. Verify Python is callable:
   ```powershell
   python --version
   ```
   Expect Python 3.x.

4. Verify the destination output file does NOT yet exist (don't clobber by accident):
   ```powershell
   Test-Path "assets\gnx375_llama_extract\page_number_map.json"
   ```
   Should be `False`. (If `True`, halt and ask CD what to do.)

If any check fails, write `docs/tasks/gnx375_pagemap_rebuild_prompt_deviation.md` and STOP.

---

## Known Script Defects (do NOT fix in this task)

These are documented here so CC can ignore expected anomalies. **None of these block this task.** They are addressed by Steve's separate corrections prompt.

| Defect | Impact on this task |
|--------|---------------------|
| `--pages-dir` default points at old path | Bypassed by CLI override |
| `--output` default points at old path | Bypassed by CLI override |
| `metadata.extraction_dir` in output is hardcoded in `main()` | Output JSON's metadata field will be wrong (says `gnc355_pdf_extracted/llamaparse_agentic_v1`); document in completion report; do NOT manually patch |
| `--verify` V1 check expects `total == 330` | Would fail against 310-page input; **do NOT use `--verify`** |
| `--verify` V5 iterates `range(1, 331)` | Would fail or produce incorrect output; **do NOT use `--verify`** |
| `ANCHOR_CITATIONS` expectations at pp. 80, 82, 98, 129 | May or may not hold; not relevant since `--verify` is skipped |

---

## Instructions

### Phase 1: Run the rebuild

```powershell
python scripts\build_page_number_map.py `
  --pages-dir assets\gnx375_llama_extract\pages `
  --output assets\gnx375_llama_extract\page_number_map.json `
  --verbose
```

**Important:** do NOT pass `--verify`. The script's verification logic is hardcoded for the 330-page old extraction and will fail spuriously against the 310-page new extraction; those failures are expected defects, not real problems with this task's output.

Capture all stdout. The expected exit code is `0` (without `--verify`, the script exits 0 unconditionally on successful run).

### Phase 2: Sanity-check the produced JSON

After the run completes, sanity-check the output file. Use a Python script saved to disk (per project convention — never inline `python -c`):

Save to `scripts/_tmp_sanity_check_pagemap.py`:

```python
"""Sanity-check the rebuilt page_number_map.json. Read-only; no writes."""
import json
import sys
from pathlib import Path

OUTPUT = Path("assets/gnx375_llama_extract/page_number_map.json")

if not OUTPUT.exists():
    print(f"FAIL: output file does not exist: {OUTPUT}")
    sys.exit(1)

data = json.loads(OUTPUT.read_text(encoding="utf-8"))

p2l = data["physical_to_logical"]
l2p = data["logical_to_physical"]
unp = data["unparseable_pages"]
dups = data.get("logical_duplicates", [])
meta = data["metadata"]

n_p2l = len(p2l)
n_parsed = sum(1 for v in p2l.values() if v != "unparseable")
n_unparseable = sum(1 for v in p2l.values() if v == "unparseable")

print(f"physical_to_logical entries: {n_p2l}")
print(f"  of which parsed:           {n_parsed}")
print(f"  of which unparseable:      {n_unparseable}")
print(f"unparseable_pages list:      {len(unp)}")
print(f"logical_to_physical entries: {len(l2p)}")
print(f"logical_duplicates:          {len(dups)}")
print()
print(f"metadata.physical_page_count: {meta.get('physical_page_count')}")
print(f"metadata.parsed_count:        {meta.get('parsed_count')}")
print(f"metadata.unparseable_count:   {meta.get('unparseable_count')}")
print(f"metadata.extraction_dir:      {meta.get('extraction_dir')}")
print(f"metadata.generated:           {meta.get('generated')}")

# Sanity expectations:
checks = []
checks.append(("p2l has 310 entries", n_p2l == 310))
checks.append(("p2l + unparseable accounting", n_parsed + n_unparseable == 310))
checks.append(("metadata.physical_page_count == 310", meta.get("physical_page_count") == 310))
checks.append(("logical_duplicates is a list", isinstance(dups, list)))

print()
print("Sanity checks:")
all_ok = True
for label, ok in checks:
    print(f"  {'PASS' if ok else 'FAIL'}: {label}")
    if not ok:
        all_ok = False

# Print a sample of the mapping for the completion report
print()
print("Sample p2l entries (first 10 parsed pages):")
shown = 0
for phys in sorted(p2l.keys(), key=int):
    if p2l[phys] != "unparseable":
        print(f"  page_{int(phys):03d}: {p2l[phys]}")
        shown += 1
        if shown >= 10:
            break

# Specific anchors of interest (from ITM-11) — for reporting only, not pass/fail
print()
print("ITM-11 anchor lookup (informational; values may differ from old map):")
for phys in [80, 82, 98, 129]:
    print(f"  page_{phys:03d}: {p2l.get(str(phys), 'MISSING')}")

sys.exit(0 if all_ok else 1)
```

Run it:

```powershell
python scripts\_tmp_sanity_check_pagemap.py
```

Capture all stdout for the completion report.

### Phase 3: Clean up the temp script

```powershell
Remove-Item scripts\_tmp_sanity_check_pagemap.py
```

### Phase 4: Completion report

Write `docs/tasks/gnx375_pagemap_rebuild_completion.md` with this structure:

```markdown
---
Created: {ISO 8601 timestamp}
Source: docs/tasks/gnx375_pagemap_rebuild_prompt.md
---

# GNX375-PAGEMAP-REBUILD-01 Completion Report

**Task ID:** GNX375-PAGEMAP-REBUILD-01
**Outputs:**
- `assets/gnx375_llama_extract/page_number_map.json` ({N} bytes)

## Pre-flight Verification Results
{table of the 4 pre-flight checks}

## Phase 1: Rebuild Run
**Command:**
{command line}

**Exit code:** {n}

**Captured stdout:**
{paste full stdout from the script run, indented in a code block}

## Phase 2: Sanity Check Results
**Command:**
{command line}

**Captured stdout:**
{paste full stdout from the sanity check, indented in a code block}

**Verdict:** {PASS | FAIL — explain}

## Known Defects Carried Forward (per prompt §Known Script Defects)

| Field | Expected (correct) | Actual (in output) |
|-------|--------------------|--------------------|
| `metadata.extraction_dir` | `assets/gnx375_llama_extract` | {whatever the script wrote} |

These are addressed by a separate corrections prompt; not fixed here.

## ITM-11 Anchor Lookup (Informational)

| Physical | Logical (this map) |
|----------|--------------------|
| 80 | {value} |
| 82 | {value} |
| 98 | {value} |
| 129 | {value} |

(Old map's anchor expectations from ITM-11: 80→2-42, 82→2-44, 98→2-58, 129→3-15. CD will compare against this map's values once corrections are applied.)

## Deviations from Prompt
{table; "None" if none}
```

### Phase 5: Commit

`git add` the new file:
```powershell
git add assets\gnx375_llama_extract\page_number_map.json docs\tasks\gnx375_pagemap_rebuild_prompt.md docs\tasks\gnx375_pagemap_rebuild_completion.md
```

Commit with D-04 trailer format. **CRITICAL: use the BOM-free `[System.IO.File]::WriteAllText` + `git -F` PowerShell pattern per `claude-conventions.md` §Git Commit Trailers §CD commit execution mechanics. Do NOT use `Out-File -Encoding utf8` (it emits UTF-8 with BOM, which leaks into the commit subject — see ITM-13).**

Subject: `GNX375-PAGEMAP-REBUILD-01: rebuild page_number_map against gnx375_llama_extract`

Trailers:
```
Task-Id: GNX375-PAGEMAP-REBUILD-01
Authored-By-Instance: cc
Refs: ITM-11, ITM-13, D-25, D-26
Co-Authored-By: Claude Code <noreply@anthropic.com>
```

After commit, verify the subject is BOM-free:
```powershell
git log -1 --format="%s" | Format-Hex | Select-Object -First 5
```
The first byte should NOT be `EF BB BF`. If it is, amend with the BOM-free pattern (per claude-conventions.md). **Avoiding the BOM defect on this task is the second of two consecutive clean commits needed to close ITM-13.**

### Phase 6: Notify

```powershell
Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-PAGEMAP-REBUILD-01 completed [flight-sim]"
```

**Do NOT git push.** Steve pushes manually.

---

## What CD will do with this output

1. Compare the new map's logical IDs at the ITM-11 anchor positions (80, 82, 98, 129) against the old map's expectations. Differences are diagnostic data — they tell us where the old extraction's 20 phantom pages were inserted.
2. Apply Steve's corrections prompt to fix the script's hardcoded defaults, the `metadata.extraction_dir` field, and the verification logic (V1, V2, V5 hardcoded 330 → parameterized).
3. Re-run with `--verify` against the corrected script to confirm the new map's anchor citations.
4. Once verified, the new map at `assets/gnx375_llama_extract/page_number_map.json` becomes the canonical page map and the old one (in the soon-to-be-retired `gnc355_pdf_extracted/`) is retired with the rest of that directory.
