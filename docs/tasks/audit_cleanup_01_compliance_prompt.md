# CC Task Prompt: AUDIT-CLEANUP-01 Compliance Verification

**Task ID:** AUDIT-CLEANUP-01-COMPLIANCE
**Verifying:** AUDIT-CLEANUP-01 (completed 2026-05-04)
**Prompt:** `docs/tasks/audit_cleanup_01_prompt.md`
**Completion:** `docs/tasks/audit_cleanup_01_completion.md`
**Source of truth:** `docs/tasks/completed/dependency_audit_01_report.md`, the prompt above

---

## Instructions

This is a **read-only verification task**. Do NOT modify any source files. The only file you write is the compliance report at `docs/tasks/audit_cleanup_01_compliance.md`.

Read `CLAUDE.md` for project conventions (D-29 commit format). Per CLAUDE.md, never use inline `python -c` — save multi-step Python checks to `.py` files in a temp scratch directory.

For each checklist item below, report **PASS** / **FAIL** / **PARTIAL** with concrete evidence (command output, line content, file paths). Quote specific lines that prove compliance.

---

## Checklist

### M. Move verification

**M1. Phase A — 11 task files moved.** For each of the 11 source paths, run:
```bash
ls docs/tasks/<basename> 2>&1 | grep -q "No such" && echo "MOVED: <basename>" || echo "STILL PRESENT: <basename>"
ls docs/tasks/completed/<basename> 2>&1 | grep -q "No such" && echo "MISSING IN DEST: <basename>" || echo "PRESENT IN DEST: <basename>"
```

11 sources to verify:
- `build_page_number_map_prompt.md`
- `build_page_number_map_completion.md`
- `gnx375_pagemap_rebuild_prompt.md`
- `gnx375_pagemap_rebuild_completion.md`
- `pdf_reextraction_llamaparse_prompt.md`
- `pdf_reextraction_llamaparse_completion.md`
- `extraction_inventory_compare_prompt.md`
- `extraction_inventory_compare_prompt_deviation.md`
- `MANUAL_gnc355_eyeball_low_confidence_pages.md`
- `dependency_audit_prompt.md`
- `image_extraction_briefing.md`

PASS if all 11 source paths report MOVED and all 11 destination paths report PRESENT. FAIL on any single mismatch.

**M2. Phase B — 16 compliance scripts moved.** Run:
```bash
ls scripts/archived/
```

PASS if the listing contains all 16 expected basenames (per AUDIT-CLEANUP-01 prompt Phase B table). FAIL if any are missing or if there are unexpected files. Quote the full `ls` output.

**M3. Phase B subdirectory state.**
- `scripts/pdf_reextraction/` should NOT exist (CC reported it was removed). Verify with `ls -d scripts/pdf_reextraction 2>&1`.
- `scripts/compliance/c22_f/` SHOULD exist and contain only `check_encoding.py`. Verify with `ls scripts/compliance/c22_f/`.
- `scripts/compliance/c22_e/` SHOULD exist with both `check_ufffd.ps1` and `check_ufffd.py` intact. Verify with `ls scripts/compliance/c22_e/`.

PASS if all three states match expectations. FAIL otherwise.

### C. Phase C edits

**C1. Three edited lines read what completion claims.** Run:
```bash
sed -n '325,335p' scripts/build_page_number_map.py
sed -n '358,362p' scripts/build_page_number_map.py
```

Verify:
- Line 327 contains `default="assets/gnx375_llama_extract/pages",`
- Line 332 contains `default="assets/gnx375_pymupdf_v1_0_1/page_number_map.json",`
- Line 360 contains `"extraction_dir": "assets/gnx375_llama_extract",`
- Line numbers may have shifted ±1 due to whitespace; ±2 acceptable.

PASS if all three correct values appear at expected lines. FAIL otherwise. Quote the actual lines.

**C2. Zero remaining matches in the script.** Run:
```bash
grep -n "gnc355_pdf_extracted" scripts/build_page_number_map.py
```

PASS if empty output. FAIL if any matches.

### D. Phase D content edits and deletions

**D1. Binary files deleted.** Run:
```bash
ls assets/retired/gnc355_reference/land-data-symbols.png 2>&1
ls assets/retired/gnc355_pdf_extracted/land-data-symbols.png 2>&1
```

PASS if both return "No such file or directory". FAIL if either still exists.

**D2. Active references gone (precise path).** Run:
```bash
git grep -n -F "assets/gnc355_reference/land-data-symbols.png" -- ':!docs/tasks/completed/' ':!docs/decisions/' ':!project-status/' ':!assets/retired/'
```

PASS if empty output (or only matches inside `docs/tasks/audit_cleanup_01_*.md`, the task's own files). FAIL on any active match outside that exemption.

**D3. Active references gone (broader patterns — catches missed variants).** Run each:
```bash
git grep -n -i "land-data-symbols" -- ':!docs/tasks/completed/' ':!docs/decisions/' ':!project-status/' ':!assets/retired/' ':!docs/tasks/audit_cleanup_01_*'
git grep -n -i "see supplement" -- ':!docs/tasks/completed/' ':!docs/decisions/' ':!project-status/' ':!assets/retired/' ':!docs/tasks/audit_cleanup_01_*'
git grep -n -i "supplement available" -- ':!docs/tasks/completed/' ':!docs/decisions/' ':!project-status/' ':!assets/retired/' ':!docs/tasks/audit_cleanup_01_*'
git grep -n -i "supplement at" -- ':!docs/tasks/completed/' ':!docs/decisions/' ':!project-status/' ':!assets/retired/' ':!docs/tasks/audit_cleanup_01_*'
```

PASS if all four return empty (or only innocent matches that don't reference the deleted asset). FAIL if any match references the deleted asset. Quote any non-empty results in evidence.

**D4. Fragment A edits applied as claimed.** Read context around lines 463, 503, and 514:
```bash
sed -n '460,470p' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
sed -n '500,510p' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
sed -n '511,520p' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
```

Verify each edit's "After" text appears at expected location. PASS if all three present. FAIL if any pre-edit text remains.

**D5. Fragment B edits applied as claimed.** Read the Land data symbols subsection in full:
```bash
sed -n '245,265p' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md
```

Verify all of:
- Heading is `#### Land data symbols [p. 125 — sparse]` (no "; see supplement")
- The two-paragraph supplement-attribution structure is gone; replaced with `Symbols include:` directly after sparse-frame sentence
- The "Implementation must reference the supplement image" sentence is absent

PASS if all three. FAIL if any pre-edit text remains.

**D6. GNX375 outline edits applied.** Read context around lines 248, 252, 1448:
```bash
sed -n '245,255p' docs/specs/GNX375_Functional_Spec_V1_outline.md
sed -n '1440,1455p' docs/specs/GNX375_Functional_Spec_V1_outline.md
```

Verify:
- Line ~248 reads `- Land data symbols [p. 125 — sparse]` (no "; see supplement")
- The NOTE bullet referencing `assets/gnc355_reference/land-data-symbols.png` is gone
- The Supplement/Impact bullets in 1448–1449 vicinity are gone

PASS if all three. FAIL otherwise.

**D7. GNC355 outline edits applied.** Read context around lines 243, 247, 1306:
```bash
sed -n '240,250p' docs/specs/GNC355_Functional_Spec_V1_outline.md
sed -n '1300,1315p' docs/specs/GNC355_Functional_Spec_V1_outline.md
```

Verify same pattern as D6 for the GNC355 file. PASS if all three changes present.

**D8. Prep V2 edit applied.** Read context around line 159:
```bash
sed -n '155,165p' docs/specs/GNX375_Prep_Implementation_Plan_V2.md
```

Verify the "curated supplement assets/gnc355_reference/land-data-symbols.png (page 125 was image-only; hand-curated)" clause is excised, and surrounding sentences flow correctly. PASS if excised cleanly.

### A. Aggregate regeneration

**A1. Aggregate exists and is the expected size.** Run:
```bash
wc -l docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```

PASS if line count is within 10 of completion's claimed 4430 (acceptable variance for line-counting noise). FAIL if substantially different. Quote the count.

**A2. Aggregate has no land-data-symbols references.** Run:
```bash
grep -c "land-data-symbols\|see supplement\|supplement available\|supplement at" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```

PASS if `0`. FAIL if any matches. Quote any matches found.

**A3. Aggregate Fragment A content reflects edits.** Run:
```bash
grep -n "p\. 125.*Sparse\|p\. 125.*sparse\|Significant content gap" docs/specs/GNX375_Functional_Spec_V1_aggregate.md | head -5
```

Verify the rows/lines match the post-edit Fragment A wording (no "Supplement: \`<path>\`. ", no "supplement available"). PASS if matches show post-edit text. FAIL if pre-edit text appears.

**A4. Aggregate Fragment B content reflects edits.** Run:
```bash
grep -n "Land data symbols.*sparse" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```

PASS if exactly one match showing `[p. 125 — sparse]` (no "; see supplement"). FAIL otherwise.

### G. Git / Commit compliance

**G1. Commit message uses D-29 simple format.** Run:
```bash
git log -1 --grep="AUDIT-CLEANUP-01:" --format="%H%n%n%B" HEAD
```

Verify:
- Subject begins with `AUDIT-CLEANUP-01:`
- Subject ends with ` [AI commit]`
- Subject contains no D-04-style trailers (`Task-Id:`, `Authored-By-Instance:`)
- Body paragraph(s) describe the work
- A `Refs:` line appears as a final paragraph

PASS if all hold. FAIL on any violation.

**G2. No BOM in commit subject.** Run:
```bash
git log -1 --grep="AUDIT-CLEANUP-01:" --format="%s" | head -c 50 | od -c | head -2
```

Verify the first byte is the ASCII letter `A` (0x41), not the BOM sequence (0xEF 0xBB 0xBF). PASS if clean.

**G3. Changeset is the expected scope.** Run:
```bash
git log -1 --grep="AUDIT-CLEANUP-01:" --name-status HEAD
```

Verify the changeset contains:
- Exactly 11 renames (R) under `docs/tasks/` → `docs/tasks/completed/`
- Exactly 16 renames (R) under `scripts/` → `scripts/archived/`
- Exactly 2 deletions (D) for the `land-data-symbols.png` files in `assets/retired/`
- Exactly 7 modifications (M) for: `scripts/build_page_number_map.py`, `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`, `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`, `docs/specs/GNX375_Functional_Spec_V1_outline.md`, `docs/specs/GNC355_Functional_Spec_V1_outline.md`, `docs/specs/GNX375_Prep_Implementation_Plan_V2.md`, `docs/specs/GNX375_Functional_Spec_V1_aggregate.md`
- 1 added (A) for `docs/tasks/audit_cleanup_01_prompt.md` if it wasn't already in HEAD before the cleanup commit (Steve committed the prompt at Turn 25; check whether it's in HEAD before this verification commit)
- 1 added (A) for `docs/tasks/audit_cleanup_01_completion.md`

PASS if changeset matches. PARTIAL if minor differences (e.g., the prompt was already committed pre-cleanup, so its A entry would be absent here — this is fine). FAIL if major files are missing or unexpected files appear.

---

## Output

Write the compliance report to `docs/tasks/audit_cleanup_01_compliance.md` with this structure:

```markdown
---
Created: <iso8601>
Source: docs/tasks/audit_cleanup_01_compliance_prompt.md
---

# AUDIT-CLEANUP-01 Compliance Report

**Verified:** <timestamp>
**Verdict:** <ALL PASS | PASS WITH NOTES | FAILURES FOUND>

## Summary
- Total checks: 17 (M1, M2, M3, C1, C2, D1, D2, D3, D4, D5, D6, D7, D8, A1, A2, A3, A4, G1, G2, G3 — 20 if D3 split per pattern; treat as 17 atomic outcomes)
- Passed: <N>
- Failed: <N>
- Partial: <N>

## Results

### M. Move verification
M1. <PASS|FAIL|PARTIAL> — <evidence>
M2. ...
M3. ...

### C. Phase C edits
C1. ...
C2. ...

### D. Phase D content edits and deletions
D1. ...
D2. ...
D3. ...
D4. ...
D5. ...
D6. ...
D7. ...
D8. ...

### A. Aggregate regeneration
A1. ...
A2. ...
A3. ...
A4. ...

### G. Git / Commit compliance
G1. ...
G2. ...
G3. ...

## Notes

<Observations, edge cases, recommendations.>
```

---

## Completion Protocol

1. Write compliance report to `docs/tasks/audit_cleanup_01_compliance.md`.

2. Stage and commit (D-29 simple format):

   ```
   git add docs/tasks/audit_cleanup_01_compliance_prompt.md docs/tasks/audit_cleanup_01_compliance.md
   ```

   Commit message:
   ```
   git commit -m "AUDIT-CLEANUP-01-COMPLIANCE: verification report [AI commit]" -m "Verifies AUDIT-CLEANUP-01 against prompt requirements. <N>/17 checks passed. Move verification, Phase C edits, Phase D content edits and binary deletions, aggregate regeneration content checks, and D-29 commit-format compliance covered." -m "Refs: AUDIT-CLEANUP-01, DEPENDENCY-AUDIT-01"
   ```

3. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "AUDIT-CLEANUP-01-COMPLIANCE completed [flight-sim]"
   ```

4. **Do NOT git push.** Steve pushes after CD reviews compliance.
