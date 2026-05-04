# CC Task Prompt: Audit Cleanup — Bookkeeping Archives + Side Finding #4 Fix + land-data-symbols.png Removal

**Location:** `docs/tasks/audit_cleanup_01_prompt.md`
**Task ID:** AUDIT-CLEANUP-01
**Spec:** None
**Depends on:** DEPENDENCY-AUDIT-01 archived 2026-05-02 (PASS WITH NOTES); patch list and flag list in `docs/tasks/completed/dependency_audit_01_report.md`
**Priority:** P1 (clears bookkeeping debt; biggest tidiness win)
**Estimated scope:** Small-Medium — mechanical file moves + 3-line script edit + targeted spec-text excisions + binary deletion + aggregate regeneration
**Task type:** code (one script file edited; spec part files edited; rest is `git mv` / `git rm` / script invocation)
**Source of truth:**
- `docs/tasks/completed/dependency_audit_01_report.md` (Patch list + Flag list + Side Findings)
- This prompt (specifies which audit findings are addressed and how)
**Audit level:** self-check only — mechanical operations with verifiable end states

**Revision note:** This prompt supersedes an earlier draft (Purple Turn 24) that treated `land-data-symbols.png` as a salvage candidate per the audit's framing. Steve's directive (Purple Turn 25): the asset isn't needed — remove references and delete. Phase D below.

---

## Pre-flight Verification

**Execute these checks before any move or edit. If any check fails, STOP and write a deviation report.**

1. Verify the audit report is in the completed/ directory:
   ```
   ls -la docs/tasks/completed/dependency_audit_01_report.md
   ```

2. Verify the source files this task will move are all on disk:

   ```
   ls docs/tasks/build_page_number_map_prompt.md \
      docs/tasks/build_page_number_map_completion.md \
      docs/tasks/gnx375_pagemap_rebuild_prompt.md \
      docs/tasks/gnx375_pagemap_rebuild_completion.md \
      docs/tasks/pdf_reextraction_llamaparse_prompt.md \
      docs/tasks/pdf_reextraction_llamaparse_completion.md \
      docs/tasks/extraction_inventory_compare_prompt.md \
      docs/tasks/extraction_inventory_compare_prompt_deviation.md \
      docs/tasks/MANUAL_gnc355_eyeball_low_confidence_pages.md \
      docs/tasks/dependency_audit_prompt.md \
      docs/tasks/image_extraction_briefing.md
   ```

   All 11 files must exist.

3. Verify the script files this task will move are all on disk:

   ```
   ls scripts/c22_c_pdf_integrity_check.py \
      scripts/c22_d_compliance_pdf_check.py \
      scripts/c22c_check_pdf.py \
      scripts/c22c_check_s12_s13.py \
      scripts/c22c_check_s14_s15.py \
      scripts/compliance_s12_overlays.py \
      scripts/compliance_s13_tabs.py \
      scripts/compliance_s14_fpl_columns.py \
      scripts/verify_fragment_a_page_refs.py \
      scripts/compliance/c22_f/check_json_pages.py \
      scripts/compliance/c22_f/check_json_structure.py \
      scripts/compliance/c22_f/read_pdf_pages.py \
      scripts/compliance/c22_f/read_pdf_pages_fixed.py \
      scripts/compliance/c22_f/read_pdf_pages_utf8.py \
      scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse.py \
      scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse_with_images.py
   ```

   All 16 files must exist.

4. Verify `scripts/build_page_number_map.py` exists and contains the cited stale defaults:

   ```
   sed -n '325,335p' scripts/build_page_number_map.py
   sed -n '358,362p' scripts/build_page_number_map.py
   ```

   Lines 327, 332, and 360 should contain `assets/gnc355_pdf_extracted/llamaparse_agentic_v1`. If they don't, the line numbers may have shifted; STOP and adjust.

5. Verify Phase D source-file targets exist and contain the path string:

   ```
   git grep -n -F "assets/gnc355_reference/land-data-symbols.png"
   ```

   Expected at least: Fragment A line 463; Fragment B line 252-area; GNX375 outline lines 252 and 1448; GNX375 aggregate lines 457 and 758; GNC355 outline lines 247 and 1306; GNX375 Prep V2 line 159. (The aggregate matches will be resolved by regeneration in Phase D Phase 5; do not edit it directly.)

6. Verify both binary files exist:

   ```
   ls -la assets/retired/gnc355_reference/land-data-symbols.png \
          assets/retired/gnc355_pdf_extracted/land-data-symbols.png
   ```

   Both should exist at 65,861 bytes each.

7. Verify destination directories exist or can be created:

   ```
   ls -d docs/tasks/completed/ scripts/archived/ 2>/dev/null
   ```

   `docs/tasks/completed/` must already exist. `scripts/archived/` may or may not exist; if absent, create it as the first action of Phase B.

8. Verify the assembly script exists:

   ```
   ls scripts/assemble_gnx375_spec.py
   ls docs/specs/GNX375_Functional_Spec_V1_manifest.json 2>/dev/null || ls docs/specs/*manifest*.json
   ```

   The script and a manifest file are required for Phase D step 5 (aggregate regeneration).

**If any check fails:** Write `docs/tasks/audit_cleanup_01_prompt_deviation.md` with the deviation report structure. Stage, commit, ntfy, and STOP.

---

## Phase 0: Source-of-Truth Audit

Before any implementation work:

1. Read `docs/tasks/completed/dependency_audit_01_report.md` — specifically the "Recommended actions summary" section (Patch list and Flag list), the "Compliance review notes" section, and the Salvage assessment.
2. Read this prompt's "Operations" section in full.
3. Cross-reference: every operation in this prompt traces to one of:
   - A flag-list "Move to `docs/tasks/completed/`" recommendation (Phase A)
   - A flag-list "Archive or delete" recommendation for compliance scripts (Phase B)
   - Side Finding #4 stale-defaults issue (Phase C)
   - The `image_extraction_briefing.md` archival (Phase A item #11; carved out from the audit's patch recommendation per Purple Turn 15's image-extraction-retired status)
   - The land-data-symbols.png removal (Phase D; Steve's directive at Purple Turn 25 supersedes the audit's salvage-defer recommendation)
4. If ALL operations trace correctly, print `Phase 0: all operations trace to audit findings or Steve directive` and proceed.
5. If any operation does not trace, write `docs/tasks/audit_cleanup_01_prompt_phase0_deviation.md`. STOP.

---

## Instructions

This is a **mechanical cleanup task** addressing the bookkeeping subset of DEPENDENCY-AUDIT-01's flag list, Side Finding #4, and Steve's directive on land-data-symbols.png. Four operation classes:

1. **Move 11 task files** from `docs/tasks/` to `docs/tasks/completed/`.
2. **Move 16 compliance scripts** from `scripts/` (and subdirs) to `scripts/archived/`.
3. **Edit `scripts/build_page_number_map.py`** at lines 327, 332, and 360 — replace retired-path defaults.
4. **Remove all `assets/gnc355_reference/land-data-symbols.png` references** from active docs; delete both binary files; regenerate the aggregate spec.

**Read this entire prompt before executing any operation.** Read `CLAUDE.md` for project conventions including the D-29 commit format.

This task is **not** comprehensive cleanup of the audit's flag list. Specifically excluded:
- Active-content patches other than the land-data-symbols removal (the rest of the 13 patch-list entries) — separate work
- Genuinely "needs CD decision" residual flags after this task closes the bookkeeping subset

---

## Integration Context

**Runtime:**
- Windows 11 host; PowerShell 5.x. CC runs operations via its own bash/git shell.
- All paths repo-relative from project root: `C:/Users/artroom/projects/flight-sim-project/flight-sim/`.
- Use `git mv` for all file moves (preserves history, single-step move + stage).
- Use `git rm` for binary deletions (preserves history record of removal, single-step delete + stage).

**Encoding:** UTF-8 throughout. Edits to text files must preserve existing line endings and encoding (no BOM addition, no LF→CRLF or CRLF→LF flip).

---

## Operations

### Phase A — Move 11 task files to `docs/tasks/completed/`

For each file, run `git mv <source> <dest>`.

| # | Source | Destination |
|---|---|---|
| 1 | `docs/tasks/build_page_number_map_prompt.md` | `docs/tasks/completed/build_page_number_map_prompt.md` |
| 2 | `docs/tasks/build_page_number_map_completion.md` | `docs/tasks/completed/build_page_number_map_completion.md` |
| 3 | `docs/tasks/gnx375_pagemap_rebuild_prompt.md` | `docs/tasks/completed/gnx375_pagemap_rebuild_prompt.md` |
| 4 | `docs/tasks/gnx375_pagemap_rebuild_completion.md` | `docs/tasks/completed/gnx375_pagemap_rebuild_completion.md` |
| 5 | `docs/tasks/pdf_reextraction_llamaparse_prompt.md` | `docs/tasks/completed/pdf_reextraction_llamaparse_prompt.md` |
| 6 | `docs/tasks/pdf_reextraction_llamaparse_completion.md` | `docs/tasks/completed/pdf_reextraction_llamaparse_completion.md` |
| 7 | `docs/tasks/extraction_inventory_compare_prompt.md` | `docs/tasks/completed/extraction_inventory_compare_prompt.md` |
| 8 | `docs/tasks/extraction_inventory_compare_prompt_deviation.md` | `docs/tasks/completed/extraction_inventory_compare_prompt_deviation.md` |
| 9 | `docs/tasks/MANUAL_gnc355_eyeball_low_confidence_pages.md` | `docs/tasks/completed/MANUAL_gnc355_eyeball_low_confidence_pages.md` |
| 10 | `docs/tasks/dependency_audit_prompt.md` | `docs/tasks/completed/dependency_audit_prompt.md` |
| 11 | `docs/tasks/image_extraction_briefing.md` | `docs/tasks/completed/image_extraction_briefing.md` |

**Note on #10 and #11:**
- #10 is the predecessor draft superseded by `dependency_audit_01_prompt.md`. Archive preserves audit trail.
- #11 is archived rather than patched. Image extraction (Approach A and Approach B) was retired per Purple Turn 15; the briefing is no longer actionable. Archiving is the correct disposition.

After all 11 moves, verify:

```
ls docs/tasks/build_page_number_map_prompt.md 2>&1 | grep -q "No such" && echo "MOVED" || echo "FAILED"
```

### Phase B — Move 16 compliance scripts to `scripts/archived/`

If `scripts/archived/` does not exist, create it first:

```
mkdir -p scripts/archived
```

For each file, run `git mv <source> scripts/archived/<basename>`. The `scripts/compliance/c22_f/` and `scripts/pdf_reextraction/` subdirectories are flattened — all archived files land directly in `scripts/archived/` regardless of original subdirectory. Rationale: archive taxonomy doesn't need to mirror active taxonomy.

**Collision check** (run before moving — should output nothing):

```
echo c22_c_pdf_integrity_check.py c22_d_compliance_pdf_check.py c22c_check_pdf.py c22c_check_s12_s13.py c22c_check_s14_s15.py compliance_s12_overlays.py compliance_s13_tabs.py compliance_s14_fpl_columns.py verify_fragment_a_page_refs.py check_json_pages.py check_json_structure.py read_pdf_pages.py read_pdf_pages_fixed.py read_pdf_pages_utf8.py reextract_gnc355_pdf_llamaparse.py reextract_gnc355_pdf_llamaparse_with_images.py | tr ' ' '\n' | sort | uniq -d
```

If anything outputs, there's a name collision; preserve subdirectory structure for the colliding files.

| # | Source | Destination |
|---|---|---|
| 1 | `scripts/c22_c_pdf_integrity_check.py` | `scripts/archived/c22_c_pdf_integrity_check.py` |
| 2 | `scripts/c22_d_compliance_pdf_check.py` | `scripts/archived/c22_d_compliance_pdf_check.py` |
| 3 | `scripts/c22c_check_pdf.py` | `scripts/archived/c22c_check_pdf.py` |
| 4 | `scripts/c22c_check_s12_s13.py` | `scripts/archived/c22c_check_s12_s13.py` |
| 5 | `scripts/c22c_check_s14_s15.py` | `scripts/archived/c22c_check_s14_s15.py` |
| 6 | `scripts/compliance_s12_overlays.py` | `scripts/archived/compliance_s12_overlays.py` |
| 7 | `scripts/compliance_s13_tabs.py` | `scripts/archived/compliance_s13_tabs.py` |
| 8 | `scripts/compliance_s14_fpl_columns.py` | `scripts/archived/compliance_s14_fpl_columns.py` |
| 9 | `scripts/verify_fragment_a_page_refs.py` | `scripts/archived/verify_fragment_a_page_refs.py` |
| 10 | `scripts/compliance/c22_f/check_json_pages.py` | `scripts/archived/check_json_pages.py` |
| 11 | `scripts/compliance/c22_f/check_json_structure.py` | `scripts/archived/check_json_structure.py` |
| 12 | `scripts/compliance/c22_f/read_pdf_pages.py` | `scripts/archived/read_pdf_pages.py` |
| 13 | `scripts/compliance/c22_f/read_pdf_pages_fixed.py` | `scripts/archived/read_pdf_pages_fixed.py` |
| 14 | `scripts/compliance/c22_f/read_pdf_pages_utf8.py` | `scripts/archived/read_pdf_pages_utf8.py` |
| 15 | `scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse.py` | `scripts/archived/reextract_gnc355_pdf_llamaparse.py` |
| 16 | `scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse_with_images.py` | `scripts/archived/reextract_gnc355_pdf_llamaparse_with_images.py` |

**Not moved** (retained in `scripts/`):
- `scripts/gnc355_pdf_extract.py` — per the audit: "Retain for regenerability (D-06) but annotate as superseded." Annotation is out of scope.
- `scripts/build_page_number_map.py` — actively edited in Phase C.
- All other scripts — not in scope.

After all 16 moves, attempt to remove now-empty subdirectories:

```
rmdir scripts/compliance/c22_f/ 2>/dev/null
rmdir scripts/pdf_reextraction/ 2>/dev/null
```

Verify `scripts/compliance/c22_e/` is still intact:

```
ls scripts/compliance/c22_e/
```

Should still show `check_ufffd.ps1` and `check_ufffd.py`.

### Phase C — Fix Side Finding #4: `scripts/build_page_number_map.py` stale defaults

Three single-line edits, all in the same file:

**Edit 1 (line 327):**
- Before: `        default="assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages",`
- After: `        default="assets/gnx375_llama_extract/pages",`

**Edit 2 (line 332):**
- Before: `        default="assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json",`
- After: `        default="assets/gnx375_pymupdf_v1_0_1/page_number_map.json",`

**Edit 3 (line 360):**
- Before: `            "extraction_dir": "assets/gnc355_pdf_extracted/llamaparse_agentic_v1",`
- After: `            "extraction_dir": "assets/gnx375_llama_extract",`

After the three edits, verify zero remaining matches in the script:

```
grep -n "gnc355_pdf_extracted" scripts/build_page_number_map.py
```

Expected: empty output.

**Caveat:** the script may not produce useful output for the new active extraction (the LlamaParse markdown footers may differ from what the script expects). This task does not test or revalidate the script — it just removes the runtime-regression hazard documented in Side Finding #4.

### Phase D — Remove `land-data-symbols.png` references and delete binaries

This phase has 6 distinct steps. Execute in order.

#### D-Step 1: Edit Fragment A `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`

**Edit at line 463 (Sparse pages list table row):**

- Before:
  ```
  | **p. 125** | **Sparse** | **Land data symbols — image-only; text labels extracted but symbols absent. Supplement: `assets/gnc355_reference/land-data-symbols.png`. See §4.2 (C2.2-B).** |
  ```
- After:
  ```
  | **p. 125** | **Sparse** | **Land data symbols — image-only; text labels extracted but symbols absent. See §4.2 (C2.2-B).** |
  ```

**Edit at line ~503 (Significant content gap line in Appendix C body):**

The Phase A grep (`git grep -n -F "supplement"` on Fragment A) will show this line. Surgical edit:

- Before (approx line 503): `**Significant content gap:** p. 125 land data symbols — supplement available (see C.1).`
- After: `**Significant content gap:** p. 125 land data symbols (see C.1).`

This rewording removes the now-obsolete "supplement available" framing. The substantive claim that p. 125 is a content gap remains.

#### D-Step 2: Edit Fragment B `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`

The `### Land data symbols [p. 125 — sparse; see supplement]` subsection contains three references to be excised. Apply three surgical edits (target text follows; line numbers approximate):

**Edit B-1: subsection heading** (approx line 248):
- Before: `#### Land data symbols [p. 125 — sparse; see supplement]`
- After: `#### Land data symbols [p. 125 — sparse]`

**Edit B-2: replace the supplement-attribution paragraph with a list-only intro.** The original text is two lines (combined here for clarity):

- Before:
  ```
  Pilot's Guide p. 125 is sparse (image-only; text labels extracted but symbol graphics absent).
  The authoritative source for the enumerated land symbol list is the supplement at
  `assets/gnc355_reference/land-data-symbols.png`. Symbols include:
  ```
- After:
  ```
  Pilot's Guide p. 125 is sparse (image-only; text labels extracted but symbol graphics absent).
  Symbols include:
  ```

**Edit B-3: delete the trailing implementation directive sentence.**

- Before: `Implementation must reference the supplement image for accurate symbol representation.`
- After: (delete entirely; remove the line and any blank line collapsed by the deletion)

After these three edits, the subsection should read:

```
#### Land data symbols [p. 125 — sparse]

Land data symbols are depicted on the map basemap at appropriate map detail levels.
Pilot's Guide p. 125 is sparse (image-only; text labels extracted but symbol graphics absent).
Symbols include:

- Railroad
- National highway
- Freeway
- Local highway
- Local road
- River and lake boundaries
- State and province borders
- Small, medium, and large city symbols

[next subsection follows]
```

#### D-Step 3: Edit `docs/specs/GNX375_Functional_Spec_V1_outline.md`

Two references at lines 252 and 1448 (per audit). Apply the surgical pattern: identify the substring `assets/gnc355_reference/land-data-symbols.png` and the immediately enclosing supplement clause; remove the clause; preserve surrounding prose.

For each, use `sed -n '<line-25>,<line+5>p'` to read context first, then craft a precise edit. Document each before/after pair in the completion report.

If the line is structurally similar to Fragment A line 463 (table cell with "Supplement: <path>." clause), apply the same pattern: drop "Supplement: \`<path>\`. ".

If the line is structurally similar to Fragment B (paragraph with "supplement at <path>. <list intro>" pattern), apply the Fragment B pattern: drop the supplement attribution; keep the list intro.

If the line is a section heading containing "see supplement", drop "see supplement" or "; see supplement".

If the line is a list of significant content gaps, replace "supplement available" with a neutral phrase or drop it entirely.

#### D-Step 4: Edit `docs/specs/GNC355_Functional_Spec_V1_outline.md`

Two references at lines 247 and 1306. Apply the same surgical pattern as D-Step 3. This is the shelved 355 spec; same surgical discipline applies.

#### D-Step 5: Edit `docs/specs/GNX375_Prep_Implementation_Plan_V2.md`

One reference at line 159. Per audit: "...curated supplement assets/gnc355_reference/land-data-symbols.png". Surgical excision: drop the "curated supplement <path>" clause and any sibling clause that becomes orphaned (e.g., a comma joining two clauses).

#### D-Step 6: Delete both binary copies

```
git rm assets/retired/gnc355_reference/land-data-symbols.png
git rm assets/retired/gnc355_pdf_extracted/land-data-symbols.png
```

#### D-Step 7: Regenerate the aggregate spec

The aggregate at `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` is a derived artifact regenerated from the part files. After Fragment A and Fragment B are edited, regenerate:

```
python scripts/assemble_gnx375_spec.py
```

Inspect the script's `--help` output and the existing aggregate's invocation pattern (header should indicate the manifest path used). If the script needs an explicit manifest argument, supply it. The exact command form depends on the script's CLI; if invocation differs from the bare command above, document the actual command used in the completion report.

After regeneration, verify the aggregate no longer contains the path:

```
grep -c "assets/gnc355_reference/land-data-symbols.png" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```

Expected: `0`.

#### D-Step 8: Final verification

Run a global grep to confirm all references to the removed path are gone from active content:

```
git grep -n -F "assets/gnc355_reference/land-data-symbols.png" -- ':!docs/tasks/completed/' ':!docs/decisions/' ':!project-status/' ':!assets/retired/'
```

Expected: empty output (or only matches in this task's prompt + the completion report being written).

References in `docs/tasks/completed/`, `docs/decisions/`, `project-status/`, and `assets/retired/` are historical/immutable per the audit's Category D classification and remain.

### Phase E — Self-check

Before considering this task complete:

1. **Phase A check:** sample one move; `ls docs/tasks/completed/build_page_number_map_prompt.md` returns the file.
2. **Phase B check:** `ls scripts/archived/` lists 16+ entries; `ls scripts/compliance/c22_f/` returns empty or "No such file or directory"; `ls scripts/compliance/c22_e/check_ufffd.py` returns the file.
3. **Phase C check:** `grep -c "gnc355_pdf_extracted" scripts/build_page_number_map.py` returns `0`.
4. **Phase D check:**
   - `ls assets/retired/gnc355_reference/land-data-symbols.png` returns "No such file or directory" (after `git rm`)
   - `ls assets/retired/gnc355_pdf_extracted/land-data-symbols.png` returns "No such file or directory"
   - `git grep -F "assets/gnc355_reference/land-data-symbols.png" -- ':!docs/tasks/completed/' ':!docs/decisions/' ':!project-status/' ':!assets/retired/'` returns empty (excluding this task's own files which may still contain the string in pre-edit form during execution)
5. **Reproducibility check:** `git status --porcelain` shows expected renames (R), expected modifications (M), expected deletions (D). No untracked files appearing in scope, no unexpected deletions.

---

## Completion Protocol

1. Write completion report to `docs/tasks/audit_cleanup_01_completion.md`. Include:
   - Phase 0 result
   - Pre-flight check results (8 numbered checks)
   - Each phase's outcome:
     - Phase A: 11 moves
     - Phase B: 16 moves + subdirectory cleanups
     - Phase C: 3 edits
     - Phase D: D-Step 1 (2 edits to Fragment A), D-Step 2 (3 edits to Fragment B), D-Step 3 (N edits to GNX375 outline with before/after pairs), D-Step 4 (N edits to GNC355 outline with before/after pairs), D-Step 5 (1 edit to Prep V2 with before/after pair), D-Step 6 (2 binary deletions), D-Step 7 (aggregate regeneration with command form used), D-Step 8 (final grep verification)
   - Final state: list of files now in `docs/tasks/completed/` (just the 11 new entries), list of files now in `scripts/archived/`, the three updated lines in `scripts/build_page_number_map.py`, every before/after edit pair from Phase D
   - Any deviations

2. Stage and commit (D-29 simple format):

   ```
   git add docs/tasks/audit_cleanup_01_prompt.md docs/tasks/audit_cleanup_01_completion.md scripts/build_page_number_map.py docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md docs/specs/GNX375_Functional_Spec_V1_outline.md docs/specs/GNC355_Functional_Spec_V1_outline.md docs/specs/GNX375_Prep_Implementation_Plan_V2.md docs/specs/GNX375_Functional_Spec_V1_aggregate.md
   ```

   Note: `git mv` and `git rm` already stage the moved/deleted files. Confirm `git status --porcelain` shows the renames as `R  source -> dest` and the deletions as `D  path` before committing.

   Commit message:
   ```
   git commit -m "AUDIT-CLEANUP-01: archive completed tasks + retired compliance scripts; fix build_page_number_map defaults; remove land-data-symbols.png and references [AI commit]" -m "11 task files moved to docs/tasks/completed/; 16 compliance scripts moved to scripts/archived/. scripts/build_page_number_map.py defaults at lines 327/332/360 updated from retired gnc355_pdf_extracted/llamaparse_agentic_v1 paths to active gnx375_llama_extract/gnx375_pymupdf_v1_0_1 paths (Side Finding #4 closure). image_extraction_briefing.md archived rather than patched (image extraction retired Turn 15). land-data-symbols.png references removed from V1 spec (Fragment A, Fragment B, outline), GNC 355 outline, and GNX 375 Prep V2; both binary copies deleted; aggregate regenerated (Steve directive Turn 25)." -m "Refs: DEPENDENCY-AUDIT-01, D-30"
   ```

3. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "AUDIT-CLEANUP-01 completed [flight-sim]"
   ```

4. **Do not push** — Steve pushes manually after CD review.

---

## Out of scope for this task

- **Active-content patches** other than the land-data-symbols removal (the rest of the 13 patch-list entries). Separate work.
- **Annotation of `scripts/gnc355_pdf_extract.py`** as superseded. Trivial; deferred.
- **The retired README's "(forthcoming)" timeline language.** Steve's call when ready to retire `assets/retired/`.
- **`assets/retired/` move-out.** Gated on all patches landing.
- **Updates to `Spec_Tracker.md`, `CC_Task_Prompts_Status.md`, `priority_task_list.md`, `Task_flow_plan_with_current_status.md`** — CD-maintained.
- **Any V1 spec restructuring beyond the surgical land-data-symbols removal.** V1 is V1; V2 amendment territory.
