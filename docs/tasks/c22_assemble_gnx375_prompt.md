# CC Task Prompt: C2.2-ASSEMBLE — Author and run `scripts/assemble_gnx375_spec.py`

**Location:** `docs/tasks/c22_assemble_gnx375_prompt.md`
**Created:** 2026-04-25T09:56:56-04:00
**Source:** CD Purple session — Turn 4 (2026-04-25); gated on C2.2-G archive per D-18
**Task ID:** GNX375-SPEC-C22-ASSEMBLE
**Spec:** `docs/specs/GNX375_Functional_Spec_V1.md` (manifest); fragments in `docs/specs/fragments/`
**Depends on:** All seven fragments archived (A–F: ✅ archived; G: pending compliance — this task does NOT execute until C2.2-G is fully archived to `docs/tasks/completed/`)
**Priority:** Critical-path — first post-V1-body work; unblocks manifest pre-flight, Review Priority Guide prepend, and C3 spec review per D-22.
**Estimated scope:** Small — one Python script (~150–250 lines), one aggregate spec output, one quick verification pass. ~30–45 min CC wall-clock.
**Task type:** code (Python script + verification)
**Source of truth:**
- `docs/decisions/D-18-c22-format-decision-piecewise-manifest.md` — assembly contract (PRIMARY)
- `docs/specs/GNX375_Functional_Spec_V1.md` — fragment manifest with assembly notes
- `docs/specs/fragments/GNX375_Functional_Spec_V1_part_{A..G}.md` — input fragments

**Audit level:** self-check only — single Python script with deterministic output; verification by inspecting the assembled aggregate against the seven fragments.

---

## Pre-flight Verification

**Execute these checks before writing any code. If any check fails, STOP and write a deviation report.**

1. Verify all seven fragments exist:
   ```powershell
   foreach ($letter in 'A','B','C','D','E','F','G') {
     Test-Path "docs\specs\fragments\GNX375_Functional_Spec_V1_part_$letter.md"
   }
   ```
   Expect all seven `True`.

2. Verify all four C2.2-G files have been archived to `docs/tasks/completed/`:
   ```powershell
   Test-Path "docs\tasks\completed\c22_g_prompt.md"
   Test-Path "docs\tasks\completed\c22_g_completion.md"
   Test-Path "docs\tasks\completed\c22_g_compliance_prompt.md"
   Test-Path "docs\tasks\completed\c22_g_compliance.md"
   ```
   All four must be `True`. If C2.2-G is not yet archived, STOP — this task is gated on C2.2-G archive.

3. Verify manifest exists and has the assembly notes section:
   ```powershell
   Test-Path "docs\specs\GNX375_Functional_Spec_V1.md"
   Select-String -Path "docs\specs\GNX375_Functional_Spec_V1.md" -Pattern "## Assembly"
   ```

4. Verify no conflicting output exists:
   ```powershell
   Test-Path "scripts\assemble_gnx375_spec.py"
   Test-Path "docs\specs\GNX375_Functional_Spec_V1_aggregate.md"
   ```
   Both should be `False`. If either exists, STOP and note in deviation report.

5. Verify Python is callable:
   ```powershell
   python --version
   ```
   Expect Python 3.x.

If any check fails, write `docs/tasks/c22_assemble_gnx375_prompt_deviation.md` and STOP.

---

## Phase 0: Source-of-Truth Audit

Before writing the script:

1. Read `docs/decisions/D-18-c22-format-decision-piecewise-manifest.md` in full — particularly §"Fragment file conventions", §"Coupling summary convention", and §"Assembly readiness".

2. Read `docs/specs/GNX375_Functional_Spec_V1.md` §Assembly section in full. The manifest's existing "Assembly" prose lists six steps; this script implements them. Specifically:
   - Concatenate fragments in manifest order (A → G)
   - Strip each fragment's YAML front-matter
   - Strip each fragment's H1 fragment header (`# GNX 375 Functional Spec V1 — Fragment X`)
   - Strip each fragment's `## Coupling Summary` section (everything from `## Coupling Summary` through end of file)
   - Add a single H1 to the assembled file: `# GNX 375 Functional Spec V1`
   - Verify section numbering is continuous (no duplicates, no gaps): §1 → §15 + Appendices A → C
   - Verify all internal cross-references resolve

3. Read the existing assembly notes in the manifest:
   - **§4 parent-scope note:** Fragment B authors `## 4. Display Pages`. Fragment C opens directly with `### 4.7 Procedures Pages` (no duplicate `## 4.` header). Concatenation must yield a single continuous §4 section.
   - **§7 sub-section ordering note:** Fragment D presents §7.1 → §7.2 → ... → §7.9 (numeric) → §7.A → §7.B → ... → §7.M (lettered). This order is preserved on concatenation.

4. Read the YAML front-matter and H1 of one fragment (e.g., `part_A.md`) to understand the exact strip boundaries:
   - Front-matter starts at line 1 with `---` and ends at the next `---`.
   - The H1 fragment header is `# GNX 375 Functional Spec V1 — Fragment X` where X is one of A–G.
   - The Coupling Summary block starts at a line matching `^## Coupling Summary\s*$` (preceded by a `---` separator the script may also strip).

5. Print "Phase 0: all source requirements covered" and proceed.

---

## Instructions

Author `scripts/assemble_gnx375_spec.py` and use it to produce `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` from the seven fragment files. Then verify the aggregate matches expectations.

### Implementation requirements

#### Script structure

The script must be self-contained, depend only on the Python standard library, and be runnable from the project root via:

```powershell
python scripts\assemble_gnx375_spec.py
```

Default behavior assembles all seven fragments to the aggregate path. Support these flags:

- `--manifest <path>` — path to manifest spec (default: `docs/specs/GNX375_Functional_Spec_V1.md`)
- `--fragments-dir <path>` — directory containing fragment files (default: `docs/specs/fragments`)
- `--output <path>` — aggregate output path (default: `docs/specs/GNX375_Functional_Spec_V1_aggregate.md`)
- `--partial` — allow assembly with fewer than seven fragments (for partial-assembly mode per the manifest's existing language); print which fragments are missing and emit placeholder notices for missing ones
- `--check` — assemble in memory and print the verification summary without writing the output file
- `--verbose` — print per-fragment line counts and strip statistics

The script must exit with code 0 on success, non-zero on any verification failure.

#### Strip rules per fragment (in order)

For each fragment file:

1. **Strip YAML front-matter:** if line 1 is `---`, find the next `---` and skip everything through that line (inclusive).
2. **Strip the H1 fragment header line:** find the first line matching `^# GNX 375 Functional Spec V1 — Fragment [A-G]\s*$` (em-dash; en-dash; or hyphen — accept any of `—`, `–`, or `-`) and skip it. Also skip any blank lines and the immediately following intro paragraph block ONLY if that block is the standard "This is the {Nth} of seven piecewise..." preamble that appears in archived fragments. Heuristic: if the first non-blank content after the H1 strip starts with "This is " or "This fragment ", strip the entire paragraph (until the next blank line). Otherwise, retain content as-is. **Be conservative — when in doubt, retain.**
3. **Strip the trailing Coupling Summary block:** find the first line matching `^## Coupling Summary\s*$` and strip from that line through end of file. Also strip any preceding `---` separator on the immediately prior line if present.
4. **Trim trailing blank lines** from the surviving body.

#### Concatenation rules

After stripping each fragment:

1. Order: A → B → C → D → E → F → G (manifest order — read order from the manifest table; do NOT hardcode).
2. Insert a single blank line between fragments.
3. **Do NOT add per-fragment headers, separators, or boundary markers in the aggregate.** The aggregate is a clean continuous document.
4. Prepend a single H1 + provenance block at the top:
   ```markdown
   # GNX 375 Functional Spec V1

   <!-- Assembled from seven part files via scripts/assemble_gnx375_spec.py.
        Source manifest: docs/specs/GNX375_Functional_Spec_V1.md
        Fragments: GNX375_Functional_Spec_V1_part_{A..G}.md
        Generated: {ISO 8601 timestamp at assembly time} -->

   ```

#### Verification (mandatory; runs after assembly, before write)

Compute and report (always to stdout; gate exit code on failures):

1. **Section-numbering continuity:** §1, §2, ..., §15 each appear at H2 level (`^## N\. `); no §16 or higher; no duplicate `^## N\.` for the same N. Appendix A, B, C each appear at H2. Print PASS/FAIL.
2. **Sub-section integrity (spot-checks):**
   - §4 must include sub-sections §4.1 through §4.10 (Fragment B authors §4.1–§4.6; Fragment C authors §4.7–§4.10)
   - §7 must include §7.1 through §7.9 (numeric) followed by §7.A through §7.M (lettered) in that order
   - §14 must have 6 sub-sections; §15 must have 7 sub-sections; Appendix A must have 5 sub-sections
3. **No duplicate H2 headings.** Print any duplicates found.
4. **No `## Coupling Summary` heading anywhere in the aggregate.** Print PASS/FAIL.
5. **No `# GNX 375 Functional Spec V1 — Fragment` heading anywhere in the aggregate.** Print PASS/FAIL.
6. **No YAML front-matter `---` blocks anywhere except possibly inside fenced code blocks.** Print PASS/FAIL.
7. **Cross-reference resolution:** find all `see §N`, `§N.x`, `Appendix X` patterns; for each unique target, verify a corresponding heading exists in the aggregate. Print a count of unresolved refs (target: 0). Print the first 10 unresolved refs if any.
8. **Total line count:** print final line count of the aggregate.

If any verification fails (sections 1–6), exit non-zero with a summary. Section 7 unresolved cross-refs print as warnings but do not gate exit code (some refs may be intentionally textual rather than navigational).

#### Partial-assembly mode (`--partial`)

When fragments are missing:
- Substitute a placeholder block where the missing fragment would go:
  ```markdown
  <!-- Fragment {LETTER} ({covers}) not yet authored. Placeholder. -->
  ```
- Skip section-numbering continuity check for ranges within missing fragments; still check structure for present fragments.
- Print a warning to stdout listing missing fragments.
- Exit code 0 unless other verification fails.

### Phase B: Run the script

After authoring:

1. Run with verbose output:
   ```powershell
   python scripts\assemble_gnx375_spec.py --verbose
   ```
2. Capture stdout to the completion report.
3. Run `--check` mode to verify deterministic output:
   ```powershell
   python scripts\assemble_gnx375_spec.py --check
   ```
4. If both pass, the aggregate is written to `docs/specs/GNX375_Functional_Spec_V1_aggregate.md`.

### Phase C: Manual spot-check verification

Independent of the script's self-verification, manually confirm:

1. **First 50 lines of aggregate** — H1 present, provenance comment present, §1 Overview begins cleanly with no Fragment A YAML or H1 leakage.
2. **Fragment boundary inspection** — at the §3/§4 boundary (A→B), §4.6/§4.7 boundary (B→C), §4.10/§5 boundary (C→D), §7.M/§8 boundary (D→E), §10/§11 boundary (E→F), §13/§14 boundary (F→G): no orphaned Coupling Summary fragments, no duplicate §N headings, no fragment-header text leaking through.
3. **§7 sub-section ordering** — `grep -nE '^### 7\.' aggregate.md` lists §7.1 → §7.9 → §7.A → §7.M in that order.
4. **Appendix B and C** — present at the end (Fragment A authors them; they appear after §15 in Fragment A's body, but in the assembled aggregate they should be at the end after Appendix A from Fragment G). NOTE: this is a known structural quirk — Appendix B and C are authored in Fragment A but logically belong at the spec end. The script's default behavior puts them in concatenation order (after §3, before §4), which may be acceptable for V1 or may require special handling. **Document the actual placement in the completion report and flag for CD review** — do NOT attempt to reorder appendices without explicit decision authority. If the placement is wrong, CD will decide whether to amend the script or move appendix authoring in a future revision.

### Phase D: Tests

This is a small standalone script. No formal pytest required, but include in completion report:
- A unit-test-style verification that running the script twice produces byte-identical output (deterministic output check).
- A line-count summary: input fragment line counts, stripped line counts, aggregate line count.

---

## Completion Protocol

1. Run final verification: `python scripts\assemble_gnx375_spec.py --verbose`
2. Capture stdout.
3. Run `--check` mode to confirm deterministic output.
4. Write completion report to `docs/tasks/c22_assemble_gnx375_completion.md` with this structure:

   ```markdown
   ---
   Created: {ISO 8601 timestamp}
   Source: docs/tasks/c22_assemble_gnx375_prompt.md
   ---

   # C2.2-ASSEMBLE Completion Report — GNX 375 Functional Spec V1 Aggregate

   **Task ID:** GNX375-SPEC-C22-ASSEMBLE
   **Outputs:**
   - `scripts/assemble_gnx375_spec.py` ({N} lines)
   - `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` ({N} lines)

   ## Pre-flight Verification Results
   {table of the 5 pre-flight checks}

   ## Phase 0 Audit Results
   {summary of D-18 + manifest §Assembly read; strip-rule confirmation}

   ## Script Behavior Summary
   {flags supported; default behavior; partial-mode behavior}

   ## Strip Statistics (per fragment)
   | Fragment | Input lines | YAML stripped | H1 stripped | Coupling Summary stripped | Body lines |
   |----------|------------|---------------|-------------|---------------------------|------------|
   | A | {n} | {y} | {y} | {y} | {n} |
   | ... | | | | | |

   ## Aggregate Metrics
   | Metric | Value |
   |--------|-------|
   | Aggregate file | `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` |
   | Total line count | {n} |
   | H1 count | 1 |
   | H2 count | {n} |
   | H3 count | {n} |

   ## Verification Results
   {table of the 8 in-script verification checks}

   ## Manual Spot-Check Results
   {results of Phase C manual checks; note the Appendix B/C placement question}

   ## Deterministic Output Check
   {confirmation that two runs produce byte-identical output}

   ## Open Questions / CD Review Items
   {Appendix B/C placement; any cross-ref unresolved warnings}

   ## Deviations from Prompt
   {table; "None" if none}
   ```

5. `git add -A`

6. `git commit` with D-04 trailer format (use the BOM-free `WriteAllText` + `git -F` pattern):

   ```
   GNX375-SPEC-C22-ASSEMBLE: author scripts/assemble_gnx375_spec.py and produce V1 aggregate

   Authors the assembly script per D-18 §"Assembly readiness". Script
   strips YAML front-matter, H1 fragment headers, and trailing Coupling
   Summary blocks from each part file, concatenates A→G in manifest
   order, prepends single H1 + provenance comment. Default output:
   docs/specs/GNX375_Functional_Spec_V1_aggregate.md.

   In-script verification: section-numbering continuity, no duplicate
   H2s, no Coupling Summary leakage, no fragment-header leakage, no
   YAML leakage, cross-reference resolution count.

   Aggregate stats: {N} lines from {N} fragments; verification: all
   gating checks PASS; cross-ref unresolved warnings: {count}.

   Open question for CD: Appendix B/C placement (currently appears
   after §3 per Fragment A authoring order, not at spec end).

   Task-Id: GNX375-SPEC-C22-ASSEMBLE
   Authored-By-Instance: cc
   Refs: D-18, D-22, GNX375_Functional_Spec_V1.md
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

7. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-ASSEMBLE completed [flight-sim]"
   ```

8. **Do NOT git push.** Steve pushes manually.

---

## What CD will do with this report

1. Verify the aggregate visually (CD-side spot-check).
2. Decide on Appendix B/C placement (in-fragment-A-order vs. logical-end). If the latter, draft a small amendment task or CD-direct edit to Fragment A.
3. Move forward with `verify_gnx375_manifest.py` authoring, Review Priority Guide prepend, then domain-specific reviewer agent drafts per D-22 §2 — culminating in C3 spec review.

## Estimated duration

CC wall-clock: ~30–45 min (per D-20 LLM calibration: ~200-line code task with deterministic output requirement; first-of-pattern ×2 multiplier doesn't apply because the strip rules are mechanically simple; verification logic adds ~10 min).
