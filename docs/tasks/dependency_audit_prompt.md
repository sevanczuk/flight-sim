# CC Task Prompt: DEPENDENCY-AUDIT-01 — Audit completed work for dependencies on retired material

**Location:** `docs/tasks/dependency_audit_prompt.md`
**Created:** 2026-04-30T12:05:00-04:00
**Source:** CD Purple session — Turn 32 (2026-04-30). Steve has moved `gnc355_pdf_extracted/` and `gnc355_reference/` into `assets/retired/`. Before he moves these directories out of the project entirely, we need a comprehensive audit of (a) every in-repo reference to those paths, (b) every piece of completed work that depended on data from them, and (c) every item inside them that may be unique and worth salvaging. This task is the audit; the cleanup follows in CD-direct turns and possibly small follow-on CC tasks.
**Task ID:** DEPENDENCY-AUDIT-01
**Priority:** P0 — Steve has explicitly framed the dependency-audit portion as "most important" and "don't treat it superficially."
**Task type:** code (Python audit script + JSON output + markdown summary; some bash grep)
**Estimated scope:** Medium — ~25–40 min CC wall-clock. ~250-line script; multiple grep passes; per-file inspection of completed/ tasks; structured report production.
**Audit level:** independent — verification by cross-referencing the script's findings against manual spot checks at the end.

**Source-of-truth paths (READ-ONLY):**
- `assets/retired/gnc355_pdf_extracted/` — defective old extraction; 330-file `pages/` subdir; PyMuPDF-era images and text_by_page.json; partial cache-test scaffolding
- `assets/retired/gnc355_reference/` — manually-curated reference assets (land-data-symbols.png + README)
- `assets/gnx375_llama_extract/` — canonical 310-page LlamaParse v2 extraction
- `assets/Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf` — source PDF (310 pages, authoritative)

**Audit-target paths (CONTENT TO BE READ AND ANALYZED):**
- `docs/tasks/completed/*.md` — all completed task prompts and reports
- `docs/specs/` — all spec files including the V1 aggregate, fragments, and trackers
- `docs/decisions/*.md` — decision log
- `docs/todos/*.md` — issue indexes
- `docs/standards/*.md`, `docs/templates/*.md` — convention and template docs
- `scripts/*.py`, `scripts/*.sh` — any executable script
- `src/**`, `tests/**`, `config/**` — application code (likely empty or near-empty at this point)
- `CLAUDE.md`, `claude-conventions.md`, `cc_safety_discipline.md` — project root convention files

**Output paths:**
- `_audit/dependency_audit.json` — machine-readable structured report
- `_audit/dependency_audit_summary.md` — human-readable narrative + recommendations
- `scripts/dependency_audit.py` — the audit script itself

---

## Background

In Turn 30 (2026-04-30), Steve confirmed via Adobe Acrobat that the source PDF has 310 pages. The older LlamaParse extraction at `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/` produced 330 pages — 20 phantom pages whose locations within the document are unknown. The newer extraction at `assets/gnx375_llama_extract/` produced 310 pages and is source-PDF-aligned.

Steve has already moved both `gnc355_pdf_extracted/` and `gnc355_reference/` into `assets/retired/`. He plans to move them out of the project entirely once dependencies are reconciled. This audit produces the reconciliation plan.

The three audit dimensions:

1. **Reference patching.** Every in-repo path reference to `assets/gnc355_pdf_extracted` or `assets/gnc355_reference` (with old, no-`retired/` prefix) needs to be either updated to the new canonical path (`assets/gnx375_llama_extract` or a renamed reference dir), removed if obsolete, or annotated if it's intentionally describing historical state (e.g., a decision-log entry recording past behavior). The audit produces the patch list; CD applies the patches.

2. **Work-dependency audit (CRITICAL).** Some completed tasks consumed data from the now-retired old extraction. The most important risk is that a completed C2.2 fragment quoted text or cited content that was hallucinated/duplicated by the defective old extraction and isn't actually present in the source PDF. We need to identify every completed task that reads from retired paths, inspect what data it consumed, and verify the consumed data is preserved (1:1 or behaviorally-equivalent) in the canonical new extraction. **Don't treat this superficially.** A spec fragment quoting non-existent content is a correctness defect that propagates into the rest of the project.

3. **Preservation check.** Some items inside `assets/retired/` may be unique and non-regenerable from the new canonical extraction — the canonical example is `gnc355_reference/land-data-symbols.png`, which Steve manually pulled to fill a gap. The audit identifies what survives the move-out as a salvage candidate.

---

## Pre-flight Verification

**Execute these checks before writing any code. If any fails, STOP and write a deviation report.**

1. Verify retired directories exist:
   ```powershell
   Test-Path "assets\retired\gnc355_pdf_extracted"
   Test-Path "assets\retired\gnc355_reference"
   ```
   Both should be `True`.

2. Verify the canonical extraction exists with 310 pages:
   ```powershell
   (Get-ChildItem "assets\gnx375_llama_extract\pages\page_*.md").Count
   ```
   Should be `310`.

3. Verify the source PDF exists:
   ```powershell
   Test-Path "assets\Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf"
   ```
   Should be `True`.

4. Verify no conflicting outputs exist:
   ```powershell
   Test-Path "scripts\dependency_audit.py"
   Test-Path "_audit\dependency_audit.json"
   Test-Path "_audit\dependency_audit_summary.md"
   ```
   All should be `False`.

5. Verify Python is callable:
   ```powershell
   python --version
   ```
   Expect Python 3.x.

If any check fails, write `docs/tasks/dependency_audit_prompt_deviation.md` and STOP.

---

## Phase 0: Source-of-Truth Audit

Before writing the script:

1. Read `assets/retired/README.md` to confirm CD's framing of what's in the retired directories and why.
2. List the contents of both retired directories at one level of depth:
   ```powershell
   Get-ChildItem -Force "assets\retired\gnc355_pdf_extracted"
   Get-ChildItem -Force "assets\retired\gnc355_reference"
   ```
3. List the contents of the canonical extraction at one level of depth:
   ```powershell
   Get-ChildItem -Force "assets\gnx375_llama_extract"
   ```
4. List the contents of `docs/tasks/completed/`:
   ```powershell
   Get-ChildItem "docs\tasks\completed\*.md" | Select-Object Name
   ```
5. Print "Phase 0: source-of-truth audit complete" and proceed.

---

## Instructions

### Phase 1: Reference search across the repo

**Goal:** find every in-repo path reference to either of the two retired directory names. References to the new path under `assets/retired/` are also captured (so we know the audit found everything; some references already correctly point to retired).

Use bash grep across these scoped directories. Note: the retired directories themselves should be **excluded** from the search — their internal cross-references aren't actionable.

```bash
# Old paths, anywhere except inside the retired tree itself
grep -rniE "(assets/)?gnc355_pdf_extracted" \
  docs/ scripts/ src/ tests/ config/ \
  CLAUDE.md claude-conventions.md cc_safety_discipline.md \
  --include="*.md" --include="*.py" --include="*.sh" --include="*.json" \
  --include="*.yml" --include="*.yaml" --include="*.txt" --include="*.toml" \
  2>/dev/null

grep -rniE "(assets/)?gnc355_reference" \
  docs/ scripts/ src/ tests/ config/ \
  CLAUDE.md claude-conventions.md cc_safety_discipline.md \
  --include="*.md" --include="*.py" --include="*.sh" --include="*.json" \
  --include="*.yml" --include="*.yaml" --include="*.txt" --include="*.toml" \
  2>/dev/null
```

For each match, record: file path, line number, line content (truncate to 200 chars), and which retired directory it references.

**Classification of each reference** (best-effort; CD reviews):

| Reference type | Suggested disposition |
|----------------|-----------------------|
| Live source-of-truth file (e.g., spec, ITM, decision log) referencing the path as a still-active resource | **PATCH** to canonical new path (`assets/gnx375_llama_extract` or salvage target) |
| Historical/decision/retrospective record describing past behavior (e.g., a decision-log entry explaining why the path was abandoned) | **ANNOTATE** if needed; usually keep as-is because it's documenting history |
| Comment or docstring describing legacy behavior | **REVIEW** — patch only if the comment will mislead future readers |
| Already-pointing under `assets/retired/` | **NO ACTION** — already correctly retired |
| Self-reference inside a retired-area README | **NO ACTION** — not in scope |

Group findings by file in the JSON output.

### Phase 2: Work-dependency audit (CRITICAL)

**Goal:** identify every piece of completed work whose correctness depends on data that lived in the now-retired directories, and verify that the data the work depended on is preserved in the canonical new extraction.

**Step 2a: Enumerate completed tasks.**

For each `docs/tasks/completed/*_completion.md` and its companion `*_prompt.md`:
- Record the task ID (from the prompt's `Task ID:` field or the filename slug)
- Record the deliverables listed (search for `Outputs:` or "delivers")
- Search the prompt and completion for any mention of `gnc355_pdf_extracted`, `gnc355_reference`, `text_by_page.json`, `extraction_report.md`, `pages/page_*.md` paths under the old root, or specific page numbers (`page_NNN.md`)
- Classify each task by data-consumption pattern:
  - **NO_DEPENDENCY:** task didn't read from any retired path or use page-number-derived data
  - **PATH_REFERENCE_ONLY:** task referenced a retired path but only structurally (e.g., a setup task creating the directory); no content consumed
  - **CONTENT_CONSUMED:** task read content from a retired path and used it in a deliverable

**Step 2b: For CONTENT_CONSUMED tasks, perform content-preservation verification.**

For each CONTENT_CONSUMED task, identify what data was consumed and verify it exists in the canonical new extraction (or is otherwise preserved). The C2.2 spec fragments are the highest-priority cases — they likely quote text from the old extraction's pages.

For each fragment task (e.g., `c22_a`, `c22_b`, ..., `c22_g`, `c22_assemble_gnx375`):

1. Read the fragment's completion report to identify any quoted text or specific page citations.
2. For each quoted text excerpt: search `assets/gnx375_llama_extract/full_markdown.md` for a substring match. If present, content is preserved (likely at a different physical page number). If absent, the text may have been hallucinated by the defective old extraction; flag as **CONTENT_NOT_PRESERVED** for CD review.
3. For each cited page number: classify whether it's a Garmin logical page (e.g., "p. 2-42", "section 4-15") or a physical extraction page (e.g., "page_080.md", "physical p. 80"). Logical citations are preserved by definition (they're properties of the source PDF, not the extraction). Physical citations are at risk because the new extraction has different physical numbering.

Output for each completed task: `task_id`, `dependency_class`, `consumed_paths`, `quoted_text_excerpts` (with preservation status), `page_citation_classification` (logical vs physical), `risk_level` (NONE / LOW / MEDIUM / HIGH / CRITICAL).

**Step 2c: Specifically inspect the V1 spec aggregate and fragments for risk.**

Read the V1 spec aggregate at `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` (and the fragment parts under `docs/specs/fragments/` if present). For each `[p. N]`-style citation, classify it as logical (Garmin section-prefixed like `2-42`, or simple integer that's likely Garmin-logical) vs physical (explicitly references an extraction file). Report counts and sample citations. **The big question this answers is: are any of the V1 spec's page citations now broken by the new extraction's different physical numbering?**

### Phase 3: Preservation check

**Goal:** identify every item inside the retired directories that is not present in (or not regenerable from) the canonical extraction, and recommend salvage destinations.

For each file/directory inside `assets/retired/`:

| Class | Definition | Disposition |
|-------|-----------|-------------|
| REGENERABLE | Same content present in canonical extraction (or trivially derivable from it) | RETIRE (move out of project) |
| SUPERSEDED | Different format but same information; canonical version is preferred | RETIRE |
| UNIQUE_PRESERVE | Content is non-regenerable and still useful | SALVAGE — recommend new path under `assets/` |
| UNIQUE_DROP | Content is non-regenerable but no longer useful (e.g., scratch artifacts) | RETIRE with note |

Specifically check:

**`assets/retired/gnc355_reference/land-data-symbols.png`**
- Compare against any PNG/JPG in `assets/gnx375_llama_extract/images_layout/` or `images_screenshot/` whose filename or page metadata indicates source page 125. (Filenames include the page number; e.g., a file named `page_125_image_*` is a candidate.)
- If a same-or-better image exists in the canonical extraction → REGENERABLE → RETIRE.
- If no equivalent exists or quality is worse → UNIQUE_PRESERVE → recommend salvage to `assets/gnx375_reference/land-data-symbols.png` (or whatever rename matches project conventions).

**`assets/retired/gnc355_pdf_extracted/extraction_report.md`**
- Historical PyMuPDF-era audit; not regenerable from the canonical extraction. CD may want to keep a copy as project history. Classify UNIQUE_PRESERVE if it contains substantive narrative (read it and quote a few representative lines); UNIQUE_DROP if it's just numerical summary.

**`assets/retired/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json`**
- Defective per Turn 30 finding. UNIQUE_DROP — defective derived data; nothing to salvage.

**`assets/retired/gnc355_pdf_extracted/text_by_page.json`**
- Pre-LlamaParse PyMuPDF text-by-page. Likely SUPERSEDED by `gnx375_llama_extract/full_markdown.md`. Confirm size and format; if structurally redundant, classify SUPERSEDED → RETIRE.

**`assets/retired/gnc355_pdf_extracted/images/`**
- ~400 PyMuPDF-era binary image extracts. Likely SUPERSEDED by `gnx375_llama_extract/images_layout/` and `images_screenshot/`. Confirm coverage by counting old-extraction pages with images vs. new-extraction pages with images.

**`assets/retired/gnc355_pdf_extracted/llamaparse_agentic_v1_with_images/`**
- Cache-test scaffolding. Read `CACHE_TEST_RESULT.md` (small file). Likely UNIQUE_DROP. Quote the result file in the report.

**`assets/retired/gnc355_pdf_extracted/llamaparse_agentic_v1/`** (the rest)
- The pages/, full_markdown.md, extraction_log.json, etc. SUPERSEDED by canonical extraction → RETIRE.

### Phase 4: ITM-13 BOM-status verification

**Goal:** verify whether the recent CC commits (GNX375-PAGEMAP-01 and GNX375-PAGEMAP-REBUILD-01) had BOM-free commit subjects.

Run:

```powershell
git log --grep="GNX375-PAGEMAP" --format="%H %s" -n 10 | Format-Hex
```

Or inspect the first byte of each commit subject by piping `git log -1 --format="%s" <commit>` through `Format-Hex` and reading the leading bytes.

Report:
- For GNX375-PAGEMAP-01 commit: BOM present? (yes/no/unknown)
- For GNX375-PAGEMAP-REBUILD-01 commit: BOM present? (yes/no/unknown)
- ITM-13 closure status: "Two consecutive BOM-free commits achieved" if both clean; otherwise "ITM-13 remains open."

### Phase 5: Output structure

`_audit/dependency_audit.json`:

```json
{
  "metadata": {
    "generated": "<ISO 8601 timestamp>",
    "audit_script_version": "1.0",
    "retired_directories_audited": ["assets/retired/gnc355_pdf_extracted", "assets/retired/gnc355_reference"],
    "canonical_extraction": "assets/gnx375_llama_extract",
    "source_pdf_page_count": 310
  },
  "phase_1_references": {
    "summary": {
      "total_files_with_refs": <int>,
      "total_lines_with_refs": <int>,
      "by_classification": {
        "patch": <int>,
        "annotate": <int>,
        "review": <int>,
        "no_action": <int>
      }
    },
    "by_file": {
      "<file_path>": [
        {
          "line": <int>,
          "content": "...",
          "retired_dir_referenced": "gnc355_pdf_extracted | gnc355_reference",
          "suggested_classification": "patch | annotate | review | no_action",
          "rationale": "..."
        }
      ]
    }
  },
  "phase_2_work_dependencies": {
    "summary": {
      "total_completed_tasks_audited": <int>,
      "by_dependency_class": {
        "no_dependency": <int>,
        "path_reference_only": <int>,
        "content_consumed": <int>
      },
      "by_risk_level": {
        "none": <int>,
        "low": <int>,
        "medium": <int>,
        "high": <int>,
        "critical": <int>
      }
    },
    "per_task": [
      {
        "task_id": "...",
        "prompt_path": "...",
        "completion_path": "...",
        "dependency_class": "no_dependency | path_reference_only | content_consumed",
        "consumed_paths": [...],
        "quoted_text_excerpts": [
          {
            "excerpt": "<truncated 200 chars>",
            "found_in_canonical_full_markdown": <bool>
          }
        ],
        "page_citations": {
          "logical": <int>,
          "physical": <int>,
          "ambiguous": <int>
        },
        "risk_level": "none | low | medium | high | critical",
        "notes": "..."
      }
    ],
    "v1_spec_citation_audit": {
      "total_citations_found": <int>,
      "logical_count": <int>,
      "physical_count": <int>,
      "ambiguous_count": <int>,
      "sample_logical": [...],
      "sample_physical": [...],
      "sample_ambiguous": [...],
      "verdict": "all_logical | mixed | physical_present"
    }
  },
  "phase_3_preservation": {
    "summary": {
      "total_items_inventoried": <int>,
      "by_classification": {
        "regenerable": <int>,
        "superseded": <int>,
        "unique_preserve": <int>,
        "unique_drop": <int>
      }
    },
    "items": [
      {
        "path": "assets/retired/...",
        "classification": "...",
        "rationale": "...",
        "salvage_recommendation": "...",
        "salvage_target": "..."
      }
    ]
  },
  "phase_4_itm13_bom_check": {
    "gnx375_pagemap_01_bom_free": <bool | "unknown">,
    "gnx375_pagemap_rebuild_01_bom_free": <bool | "unknown">,
    "itm13_status_recommendation": "close | keep_open"
  }
}
```

`_audit/dependency_audit_summary.md`:

A human-readable narrative with these sections:

1. **Executive Summary** — top-line answers: (a) how many references need patching; (b) is any completed work at risk of having consumed phantom content; (c) is any retired item worth salvaging; (d) ITM-13 status.
2. **Phase 1: Reference Patch List** — table grouped by file path, with suggested classification per reference.
3. **Phase 2: Work-Dependency Audit** — per-task summary table with risk level; deep dive on any task at MEDIUM/HIGH/CRITICAL risk; V1 spec citation audit with verdict.
4. **Phase 3: Salvage Recommendations** — per-item table with classification and salvage target if applicable.
5. **Phase 4: ITM-13 BOM Status.**
6. **Recommended next steps for CD** — ordered list.

### Phase 6: Manual spot-check verification (Phase C-equivalent for this task)

Independent of the script's automated findings:

1. Pick one CONTENT_CONSUMED task at random and manually verify the script's quoted-text-preservation finding by reading the source completion report and grepping the canonical extraction's full_markdown.md.
2. Pick three Phase 1 references at random and manually verify the suggested classification.
3. For the `land-data-symbols.png` preservation question, manually check whether `assets/gnx375_llama_extract/images_layout/page_125_*` (or similar) actually exists, and report file size + a brief description of what it depicts (CC can read PNGs as images via the `view` tool if available, or just report metadata).

Report each in the completion report's Phase C table.

### Phase 7: Read-only safety

The script must NOT write to either retired directory or the canonical extraction directory. The only outputs are `_audit/dependency_audit.json`, `_audit/dependency_audit_summary.md`, and `scripts/dependency_audit.py`.

If `_audit/` does not exist, create it (one-time directory creation is acceptable).

---

## Completion Protocol

1. Run final audit: `python scripts\dependency_audit.py --verbose`
2. Capture stdout. The first thing the script must print is a clearly-marked executive summary block:
   ```
   === EXECUTIVE SUMMARY ===
   Phase 1: <N> references in <M> files (<K> need patching)
   Phase 2: <N> tasks audited; <K> at MEDIUM+ risk; V1 spec citations: <verdict>
   Phase 3: <N> items inventoried; <K> recommend salvage
   Phase 4: ITM-13 BOM-free streak: <N>/<2 needed>
   =========================
   ```
3. Confirm `_audit/dependency_audit.json` and `_audit/dependency_audit_summary.md` both exist and are valid (JSON parses; markdown is well-formed).
4. Write completion report to `docs/tasks/dependency_audit_completion.md` with the standard structure (pre-flight results, phase-by-phase results, per-phase verdicts, manual spot-check table, deviations).
5. `git add -A` (excluding any temp scripts you created and removed)
6. `git commit` with D-04 trailer format. **CRITICAL: use the BOM-free `[System.IO.File]::WriteAllText` + `git -F` PowerShell pattern per `claude-conventions.md` §Git Commit Trailers §CD commit execution mechanics. Do NOT use `Out-File -Encoding utf8` (it emits UTF-8 with BOM, which leaks into the commit subject — see ITM-13).**

   Subject: `DEPENDENCY-AUDIT-01: audit completed work for dependencies on retired material`

   Trailers:
   ```
   Task-Id: DEPENDENCY-AUDIT-01
   Authored-By-Instance: cc
   Refs: ITM-11, ITM-13, D-12, D-25, D-26
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

   After commit, verify the subject is BOM-free:
   ```powershell
   git log -1 --format="%s" | Format-Hex | Select-Object -First 5
   ```
   First byte should NOT be `EF BB BF`. If it is, amend with the BOM-free pattern.

7. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "DEPENDENCY-AUDIT-01 completed [flight-sim]"
   ```

8. **Do NOT git push.** Steve pushes manually.

---

## What CD will do with this report

1. Review the executive summary first.
2. Phase 1: apply the reference patches (CD-direct turn).
3. Phase 2: for any MEDIUM+ risk task, investigate the specific finding and decide whether to (a) leave as-is if the content is preserved at a different page, (b) revise the spec fragment if content is not preserved, or (c) re-run the relevant fragment authoring task against the canonical extraction.
4. Phase 3: apply the salvage recommendations (CD-direct turn or small CC task).
5. Phase 4: close ITM-13 if BOM-free streak achieved.
6. Once all four phases are reconciled, Steve can move `assets/retired/` out of the project entirely.

## Estimated duration

CC wall-clock: ~25–40 min (per D-20 LLM calibration: ~250-line script; multiple grep passes; ~60 completed tasks to inspect; structured JSON + markdown output; plus manual spot-check verification at the end).
