# CC Task Prompt: Dependency Audit of Retired Asset Paths

**Location:** `docs/tasks/dependency_audit_01_prompt.md`
**Task ID:** DEPENDENCY-AUDIT-01
**Spec:** None (deliverable is an audit report)
**Depends on:** None — `assets/retired/README.md` exists and lists everything in scope; `assets/gnx375_llama_extract/` and `assets/gnx375_pymupdf_v1_0_1/` are the active replacement directories
**Priority:** P1 (per `docs/todos/priority_task_list.md`)
**Estimated scope:** Medium — recursive grep across the entire repo + classification + report writing
**Task type:** docs-only
**Source of truth:**
- `assets/retired/README.md` — authoritative description of what's retired and why
- `docs/decisions/D-12-pivot-to-gnx375-as-primary.md` (or successor) — GNX 375 pivot rationale
- This prompt
**Audit level:** self-check only — single mechanical CC task; deliverable is an informational report with no state-changing side effects

---

## Pre-flight Verification

**Execute these checks before writing the report. If any check fails, STOP and write a deviation report.**

1. Verify the retired README exists and is readable:
   ```
   ls -la assets/retired/README.md
   head -10 assets/retired/README.md
   ```
   Expected: file exists, opens with `# Retired Assets` and a 2026-04-30 created-date.

2. Verify the retired directories exist (CC will be searching for references *to* these paths, not modifying them):
   ```
   ls -d assets/retired/gnc355_pdf_extracted/
   ls -d assets/retired/gnc355_reference/
   ```

3. Verify active replacement directories exist:
   ```
   ls -d assets/gnx375_llama_extract/
   ls -d assets/gnx375_pymupdf_v1_0_1/
   ls assets/gnx375_llama_extract/pages/ | head -5
   ls assets/gnx375_pymupdf_v1_0_1/
   ```

4. Verify the repo root layout for grep targets:
   ```
   ls -d docs/ scripts/ src/ tests/ config/ 2>/dev/null
   ls CLAUDE.md claude-conventions.md cc_safety_discipline.md claude-memory-edits.md 2>/dev/null
   ```
   Note which directories/files are absent — those are skipped automatically (e.g., `src/` and `tests/` may not exist yet for flight-sim).

**If any check fails:** Write `docs/tasks/dependency_audit_01_prompt_deviation.md` with the deviation report structure (see `docs/templates/CC_Task_Prompt_Template.md`). Stage, commit, ntfy, and STOP.

---

## Phase 0: Source-of-Truth Audit

Before any implementation work:

1. Read `assets/retired/README.md` in full.
2. Read this prompt's "Inventory targets" and "Classification rubric" sections in full.
3. Cross-reference: every retired path enumerated in `assets/retired/README.md` must appear in this prompt's grep-pattern table (or be explicitly noted as out of scope).
4. If ALL paths are covered: print `Phase 0: all retired paths covered` and proceed.
5. If uncovered paths are found:
   - Write `docs/tasks/dependency_audit_01_prompt_phase0_deviation.md` listing the gaps.
   - Stage, commit, ntfy.
   - Print: `Phase 0 BLOCKED — uncovered retired paths found. Awaiting continuation file.`
   - STOP.

---

## Instructions

Produce a single deliverable: `docs/tasks/dependency_audit_01_report.md`. The report inventories every reference in the repo to retired or pre-retirement asset paths, classifies each reference, and recommends an action.

This is a **read-only audit**. CC must not modify any file outside `docs/tasks/dependency_audit_01_report.md` (and the standard prompt-deviation/completion report files). The report's recommendations are reviewed by CD — patches and salvage actions land in subsequent CD or CC turns, not this one.

**Read this entire prompt before writing any code or running any greps.**

**Also read `CLAUDE.md`** for project conventions, safety rules, and commit-message format (D-29).

---

## Integration Context

**Runtime:**
- Windows 11 host; PowerShell 5.x is the operator's shell. CC runs greps via its own bash/git shell on the project root.
- All grep work uses `git grep` for repo-relative searching (respects `.gitignore`, fast, line-numbered output). Fall back to plain `grep -rn` only if a target file is gitignored but in scope (rare; the project-instruction files are all tracked).
- All paths in this prompt are repo-relative from the project root: `C:/Users/artroom/projects/flight-sim-project/flight-sim/`.

**Encoding:** All text I/O is UTF-8. Audit report is plain markdown.

**Deterministic ordering:** sort findings tables by (path, line number) ascending so re-running the audit produces stable output (modulo content changes).

---

## Inventory targets

### Grep patterns (each pattern in the leftmost column should be searched as a literal string match)

| Pattern | Origin | Notes |
|---|---|---|
| `assets/retired/gnc355_pdf_extracted` | Current retired location | Any reference under this prefix |
| `assets/retired/gnc355_reference` | Current retired location | Any reference under this prefix |
| `assets/gnc355_pdf_extracted` | Pre-retirement path (now under `retired/`) | Old references not yet patched |
| `assets/gnc355_reference` | Pre-retirement path (now under `retired/`) | Old references not yet patched |
| `gnc355_pdf_extracted` | Bare directory name (catches references that drop `assets/`) | False-positive prone — verify each match in context |
| `gnc355_reference` | Bare directory name | False-positive prone |
| `llamaparse_agentic_v1` | Defective extraction subdirectory | Per README: "330 pages, defective" |
| `text_by_page.json` | Pre-LlamaParse PyMuPDF JSON | Now under `assets/retired/gnc355_pdf_extracted/` |
| `land-data-symbols.png` | Steve's manual PDF pull; possibly cited in V1 fragments | Salvage candidate per README |
| `gnc355_pdf_extract` | Older archive subdirectory name (catches `Path/gnc355_pdf_extract*`) | Possibly absent now; include for completeness |

**Search command pattern (run once per grep pattern):**

```bash
git grep -n -F "<pattern>" -- ':(top)'
```

The `-F` flag treats the pattern as a literal string (not regex), `-n` adds line numbers, `:(top)` anchors the search to repo root.

If any pattern has zero hits, record `(no matches)` in the report rather than omitting the row — readers should be able to confirm absence as well as presence.

### Out-of-scope grep patterns (do not search; explain in report why)

- `assets/gnx375_llama_extract` — active path; references are correct, not findings
- `assets/gnx375_pymupdf_v1_0_1` — active path; references are correct, not findings
- `gnx375_*` — active naming; references are correct, not findings
- Generic `assets/` mentions — too broad; not informative

---

## Classification rubric

For each match found, classify the file containing the reference into one of five categories. The category determines the recommended action.

| Category | File location pattern | Default action | Rationale |
|---|---|---|---|
| **A. Active spec/doc** | `docs/specs/*.md` (excluding `lifecycle/`), `docs/specs/fragments/*.md`, `docs/knowledge/*.md`, `docs/standards/*.md`, `docs/templates/*.md`, `docs/commands/*.md` | **Patch** to current equivalent path, or **flag** if no current equivalent | These docs are read by current and future work; stale paths mislead readers and downstream tooling |
| **B. Active task/todo** | `docs/tasks/*.md` (NOT `completed/`), `docs/todos/*.md` (open issue index, priority list) | **Patch** to current equivalent, or **flag** if salvage required | Active task and todo files drive ongoing work |
| **C. Project-instruction file** | `CLAUDE.md`, `claude-conventions.md`, `cc_safety_discipline.md`, `claude-memory-edits.md` | **Patch** to current equivalent, or **flag** | These are the highest-traffic files in the project; stale paths here mislead every CD/CC session |
| **D. Historical / immutable** | `docs/tasks/completed/*.md`, `docs/decisions/*.md`, `docs/todos/issue_index_resolved.md`, `project-status/*.md`, `_crp_work/` (if any) | **Leave** with annotation in audit report explaining why | Decisions, completed task records, archived checkpoints, and resolved issues are audit-trail artifacts of contemporaneous work; modifying them rewrites history |
| **E. Code / config / scripts** | `scripts/*`, `src/*`, `tests/*`, `config/*` | **Patch** if functional dependency; **flag** if comment-only and code is for a retired-data-using task | Functional code dependencies on retired paths will fail at runtime |

**Edge cases:**

- A reference inside `docs/tasks/dependency_audit_01_*.md` (this prompt + its deliverables) is **F. Self-reference** — leave; meta-references to the audit itself are correct.
- A reference inside `assets/retired/README.md` itself is **G. Retired-doc internal** — leave; documenting retired contents is its purpose.
- A reference in a file that is itself in `assets/retired/` is **G. Retired-doc internal** — leave; the retired material is read-only.
- If a reference's category is ambiguous (e.g., a doc that's part-active part-historical), classify by the **dominant** purpose and add a short note in the audit report.

---

## Active replacement-path table

For each retired path, the report should propose this replacement when patches are recommended:

| Retired path | Active replacement | Notes |
|---|---|---|
| `assets/retired/gnc355_pdf_extracted/text_by_page.json` | `assets/gnx375_llama_extract/full_markdown.md` (full-doc) or `assets/gnx375_llama_extract/pages/page_NNN.md` (per-page) | Different format (markdown not JSON); patch may need rewording, not pure replace |
| `assets/retired/gnc355_pdf_extracted/llamaparse_agentic_v1/pages/page_NNN.md` | `assets/gnx375_llama_extract/pages/page_NNN.md` | Same per-page markdown structure; physical page numbers match per D-30 |
| `assets/retired/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json` | `assets/gnx375_pymupdf_v1_0_1/page_number_map.json` | New schema (v2.0); not a drop-in replacement structurally |
| `assets/retired/gnc355_pdf_extracted/images/page_NNNN_img_NN.bin` | `assets/gnx375_llama_extract/images_layout/` or `images_screenshot/` | Per-image filename mapping not 1:1; case-by-case |
| `assets/retired/gnc355_pdf_extracted/extraction_report.md` | (no replacement; historical artifact) | If cited, the citing reference should be updated to point to the active extraction's documentation if any, or to the retired path with a "(retired/historical)" annotation |
| `assets/retired/gnc355_reference/land-data-symbols.png` | **Salvage candidate — TBD.** Check `assets/gnx375_llama_extract/images_layout/page_125_*.png` and `images_screenshot/page_125_*.png` for an equivalent | Per README: "possibly cited by V1 spec at `assets/gnc355_reference/land-data-symbols.png`"; Fragment B §4.2 is a known referrer |
| `assets/retired/gnc355_pdf_extracted/land-data-symbols.png` | (twin of above; same salvage logic) | Per README: same image as the gnc355_reference twin |

The CC task should consult this table when proposing actions for matches but is not required to mechanically apply patches — the report is informational.

---

## Implementation Order

**Execute phases sequentially.** Do NOT parallelize phases or launch subagents.

### Phase A — Inventory: run all grep patterns

For each pattern in the "Grep patterns" table (Section "Inventory targets"):

1. Run `git grep -n -F "<pattern>" -- ':(top)'` from the repo root.
2. Capture every match: `path:line:content`.
3. Build a per-pattern findings table: pattern, total match count, distinct file count.

If a pattern returns zero matches, record `(no matches)` and continue.

### Phase B — Classify: assign each match a category

For each match collected in Phase A:

1. Determine the category (A/B/C/D/E/F/G) using the classification rubric.
2. For matches in category A, B, C, or E that point to a retired path with an active replacement (from the "Active replacement-path table"), record the proposed replacement.
3. For matches in category A, B, C, or E that point to a retired path without an active replacement (e.g., `extraction_report.md`), flag as **needs-decision** with a short rationale.
4. For matches in category D, F, G, no replacement is proposed — record only the classification.

### Phase C — Salvage assessment for `land-data-symbols.png`

The README flags this as a salvage candidate. Specifically:

1. Confirm whether `assets/retired/gnc355_reference/land-data-symbols.png` and `assets/retired/gnc355_pdf_extracted/land-data-symbols.png` exist on disk and report file sizes (note: these are binary files — DO NOT read or hash; just `ls -l`).
2. List candidate equivalents in the active extraction:
   ```
   ls assets/gnx375_llama_extract/images_layout/ | grep -i "page_125"
   ls assets/gnx375_llama_extract/images_screenshot/ | grep -i "page_125"
   ```
3. List the V1 fragments that reference `land-data-symbols.png` (use the inventory output from Phase A).
4. Recommend one of three salvage paths:
   - **Salvage in place**: relocate to `assets/gnx375_reference/land-data-symbols.png` (new dir) and patch references
   - **Replace from extraction**: identify a specific `images_*` candidate and patch references to point there
   - **Defer**: flag for human decision; the image content matters and CC cannot determine which active candidate is the right substitute without visual inspection

Recommend **defer** if the active candidates are numerous, ambiguous, or require visual inspection — salvage decisions involving image content are CD/Steve's call, not CC's.

### Phase D — Report assembly

Produce `docs/tasks/dependency_audit_01_report.md` with this structure:

```markdown
---
Created: <iso8601>
Source: docs/tasks/dependency_audit_01_prompt.md
Purpose: Inventory of references to retired asset paths; classification; recommended actions
---

# DEPENDENCY-AUDIT-01: Retired Asset Path Reference Audit

## Executive summary

- Total references found: <N> across <M> distinct files
- Patch-recommended (categories A, B, C, E with active replacement): <N>
- Flag-for-decision (no active replacement, or salvage required): <N>
- Leave-as-is (categories D, F, G): <N>
- Salvage assessment for `land-data-symbols.png`: <recommendation>
- Side-finding: `assets/retired/README.md` references "D-26 (pending)" but D-26 is on disk as of 2026-04-30. README needs updating. (Or: README is current — note as appropriate.)

## Methodology

<one paragraph describing the grep patterns used, the classification rubric applied, and any deviations from the prompt>

## Findings by retired path

### `assets/retired/gnc355_pdf_extracted/`

#### Subpath: `llamaparse_agentic_v1/`

| File | Line | Content snippet | Category | Recommended action |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

#### Subpath: `images/`

(table)

#### Subpath: `text_by_page.json`

(table)

#### Subpath: `land-data-symbols.png`

(table; cross-ref Phase C salvage assessment)

### `assets/retired/gnc355_reference/`

(tables organized similarly)

### Bare-name matches (`gnc355_pdf_extracted`, `gnc355_reference`, `llamaparse_agentic_v1`)

(table; these may be context-dependent — note any that turned out to be false positives, e.g., a string match inside an unrelated word)

## Salvage assessment: `land-data-symbols.png`

<Phase C output>

## Recommended actions summary

### Patch list (categories A, B, C, E with active replacement)

| File | Line(s) | Current path | Proposed path | Notes |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

### Flag list (needs CD decision)

| File | Line(s) | Current path | Issue | Notes |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

### Leave-as-is summary (categories D, F, G)

<one paragraph noting category D file paths and total match counts; no per-line table required>

## Side findings

<any observations outside the audit's primary scope: stale README references, broken links, etc.>
```

The report should be readable end-to-end by Steve in 5–10 minutes. Tables should be sortable (sort findings by path-then-line ascending). Use code-formatted snippets sparingly — short content excerpts only, not multi-line copies.

---

## Self-check before writing the completion report

Before considering this task complete:

1. Every grep pattern from the "Inventory targets" table appears in the report (zero-match patterns explicitly noted).
2. Every match has a category assignment.
3. Every category-A/B/C/E match either has a proposed replacement or is in the flag list.
4. The Phase C salvage assessment is present and produces a concrete recommendation (in-place / replace-from-extraction / defer).
5. The report's executive summary numbers add up: `patch-recommended + flag-for-decision + leave-as-is == total references`.
6. The audit performed no destructive operations; no files outside `docs/tasks/dependency_audit_01_*.md` were modified.

---

## Completion Protocol

1. Write completion report to `docs/tasks/dependency_audit_01_completion.md`. Include:
   - Phase 0 result (`all retired paths covered` or deviation file reference)
   - Pre-flight check results (each numbered check + outcome)
   - Per-phase outcome summary (Phase A: patterns run + total matches; Phase B: classification distribution; Phase C: salvage recommendation; Phase D: report file size + section counts)
   - Final empirical numbers from the report's executive summary
   - Any deviations from this prompt (e.g., a grep pattern that needed special handling, a category that turned out to be ambiguous and how it was resolved)

2. Stage and commit (D-29 simple format):
   ```
   git add docs/tasks/dependency_audit_01_prompt.md docs/tasks/dependency_audit_01_report.md docs/tasks/dependency_audit_01_completion.md
   ```

   Commit message:
   ```
   git commit -m "DEPENDENCY-AUDIT-01: inventory references to retired asset paths [AI commit]" -m "Read-only audit producing docs/tasks/dependency_audit_01_report.md. <N> total references across <M> files; <N> patch-recommended, <N> flag-for-decision, <N> leave-as-is. Salvage assessment for land-data-symbols.png: <recommendation>." -m "Refs: D-12, D-30"
   ```

3. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "DEPENDENCY-AUDIT-01 completed [flight-sim]"
   ```

4. **Do not push** — Steve pushes manually after CD review.

---

## Out of scope for this task

- **Patching any references.** This audit produces the patch list; CD reviews it; subsequent turns apply patches. No file outside `docs/tasks/dependency_audit_01_*.md` is modified by this task.
- **Salvage execution for `land-data-symbols.png`.** This audit recommends a salvage path; CD/Steve makes the call; subsequent turns execute.
- **`assets/retired/` move-out.** The retired directory's eventual relocation out of the project is gated on this audit completing PLUS all patches landing PLUS salvage decisions executed. Out of scope here.
- **Updates to `Spec_Tracker.md`, `CC_Task_Prompts_Status.md`, `priority_task_list.md`, `Task_flow_plan_with_current_status.md`** — those are CD-maintained; CC does not modify them.
- **Any `assets/retired/README.md` updates** — the README is the canonical retired-assets description; if the audit finds it stale (e.g., D-26 status), flag in side findings; CD decides whether to update.
