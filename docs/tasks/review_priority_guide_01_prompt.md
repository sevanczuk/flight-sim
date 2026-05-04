# CC Task Prompt: Review Priority Guide — Author Source File + Wire `--review-priority-guide` Flag into Assembly Script

**Location:** `docs/tasks/review_priority_guide_01_prompt.md`
**Task ID:** REVIEW-PRIORITY-GUIDE-01
**Spec:** `docs/decisions/D-22-c3-spec-review-customization-for-gnx375-functional-spec.md` §5
**Depends on:** `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` exists (regenerated 2026-05-04 per AUDIT-CLEANUP-01); `scripts/assemble_gnx375_spec.py` exists with argparse-based CLI
**Priority:** P1 (pre-C3 prerequisite — first of three P1 items per D-22 implementation checklist)
**Estimated scope:** Small-Medium — one new markdown source file (~50 lines) + one Python script edit (argparse flag + prepend logic) + assembly run + verification
**Task type:** code (script edit + new markdown file + regenerated derived artifact)
**Source of truth:**
- This prompt (Phase A specifies the priority guide content verbatim per D-22 §5; the table and bucketing are authoritative)
- `docs/decisions/D-22-c3-spec-review-customization-for-gnx375-functional-spec.md` §5 (background rationale; not required to read but useful)
- `scripts/assemble_gnx375_spec.py` (the script being modified)
- `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` (target artifact for regeneration)
**Audit level:** standard — code edit + new authored content; warrants a compliance review

**Mechanism choice context:** D-22 §5 did not specify whether the priority guide should be a CD-direct edit to the aggregate or an assembly-script-baked artifact. CD chose the assembly-script-flag approach (Purple session, 2026-05-04) because the aggregate is a derived artifact regenerated from fragments + manifest; a CD-direct prepend would be blown away on next regeneration. The flag-and-source-file approach preserves regeneration parity.

---

## Pre-flight Verification

Execute these checks before any phase work. If any check fails, STOP and write a deviation report per the bottom of this section.

1. Verify the assembly script exists and inspect its current CLI:
   ```
   ls scripts/assemble_gnx375_spec.py
   python scripts/assemble_gnx375_spec.py --help
   ```
   Help output must list at least these flags: `--verbose`, `--check`, `--manifest`, `--fragments-dir`, `--output`. If `--review-priority-guide` already appears in `--help`, STOP — task is partially complete; deviation report.

2. Verify the manifest exists at the expected path:
   ```
   ls docs/specs/GNX375_Functional_Spec_V1.md
   ```

3. Verify the fragments directory contains exactly 7 part files:
   ```
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_*.md
   ```
   Expected: 7 files, parts A through G.

4. Verify the current aggregate exists and record the baseline line count:
   ```
   ls docs/specs/GNX375_Functional_Spec_V1_aggregate.md
   wc -l docs/specs/GNX375_Functional_Spec_V1_aggregate.md
   ```
   Record the line count — Phase C will compare post-regeneration count against this baseline.

5. Verify the priority guide source file does NOT yet exist (idempotency check):
   ```
   ls docs/specs/fragments/_review_priority_guide.md 2>/dev/null && echo "EXISTS" || echo "ABSENT"
   ```
   Expected: `ABSENT`. If `EXISTS`, STOP — partial completion from a prior attempt; deviation report.

6. Verify D-22 is on disk for optional context-reading:
   ```
   ls docs/decisions/D-22-c3-spec-review-customization-for-gnx375-functional-spec.md
   ```

7. Verify the working tree is clean (no uncommitted edits to the files this task touches):
   ```
   git status --porcelain scripts/assemble_gnx375_spec.py docs/specs/GNX375_Functional_Spec_V1_aggregate.md docs/specs/fragments/
   ```
   Expected: empty output. If any modifications, STOP — uncommitted state could conflict with this task's commits; deviation report.

**On pre-flight failure:** Write `docs/tasks/review_priority_guide_01_prompt_deviation.md` with the structure:
- Which check failed
- Actual output observed
- Recommended remediation
- What CC has done so far (should be nothing)

Stage the deviation file, commit with subject `REVIEW-PRIORITY-GUIDE-01: pre-flight deviation [AI commit]`, send ntfy `REVIEW-PRIORITY-GUIDE-01 deviation [flight-sim]`, STOP.

---

## Phase 0: Source-of-Truth Audit

1. Read this prompt in full. Phase A below contains the verbatim P1/P2/P3 section assignments per D-22 §5. The bucketing and the inline rationale notes are authoritative — do not paraphrase or restructure.

2. Optionally read D-22 §5 directly for context. The framing rationale (correctness-critical vs functionality-critical vs quality/polish, and the functional-fidelity test in §3) helps explain why each section is bucketed where it is, but is not required for this task's mechanical execution.

3. Read the current aggregate header to confirm the structural insertion point:
   ```
   sed -n '1,15p' docs/specs/GNX375_Functional_Spec_V1_aggregate.md
   ```
   Current shape (verbatim from the file as of 2026-05-04T07:36:16-04:00 regeneration):
   ```
   # GNX 375 Functional Spec V1

   <!-- Assembled from seven part files via scripts/assemble_gnx375_spec.py.
        Source manifest: docs/specs/GNX375_Functional_Spec_V1.md
        Fragments: GNX375_Functional_Spec_V1_part_{A..G}.md
        Generated: 2026-05-04T07:36:16-04:00 -->

   ---

   ## 1. Overview
   ```

   Target shape after this task (priority guide inserted between the HTML comment and the `---` separator):
   ```
   # GNX 375 Functional Spec V1

   <!-- Assembled from seven part files via scripts/assemble_gnx375_spec.py. ... -->

   ## Review Priority Guide

   [guide content — H3 sections for P1/P2/P3]

   ---

   ## 1. Overview
   ```

4. Read the assembly script's argparse setup and the function that composes/writes the assembled output:
   ```
   sed -n '1,80p' scripts/assemble_gnx375_spec.py
   grep -n "argparse\|add_argument\|def main\|write_text\|--output" scripts/assemble_gnx375_spec.py
   ```
   Identify (a) where to add the new flag and (b) where in the output composition to inject the guide content. The injection point is "after the H1 + HTML-comment block, before the `---` separator." If the script composes the output as a list of lines, find the index of the `---` line and insert before it. If the script composes the output via string concatenation of well-defined blocks, prepend the guide content as its own block before whichever block produces the `---` line.

---

## Phase A: Author the priority guide source file

### A.1: Create the source file

Path: `docs/specs/fragments/_review_priority_guide.md`

The leading underscore distinguishes this file from the seven canonical fragment parts (`GNX375_Functional_Spec_V1_part_A.md` through `_part_G.md`). The manifest does not list this file, so the assembly script's manifest parser will not treat it as a fragment.

File content (verbatim — write exactly this; no provenance comment, no front matter, no extra blank lines):

```markdown
## Review Priority Guide

This guide directs C3 spec review attention. Sections are bucketed by their fidelity-criticality to the real GNX 375 device behavior as documented in Garmin Pilot's Guide 190-02488-01 Rev. C. Reviewers should weight scrutiny accordingly: P1 sections warrant the deepest review; P3 sections warrant verification-only sweeps unless an issue surfaces.

### P1 — Correctness-critical

These sections describe the GNX 375's signature features, output contracts to host simulators, and behaviors where a spec defect would produce a non-fidelity instrument. Findings here are accepted into V2 if they pass the functional-fidelity test (see D-22 §3).

- **§11 — Transponder + ADS-B.** Signature feature differentiating the GNX 375 from sibling units. D-16 framing (three transponder modes; built-in dual-link ADS-B In/Out; TSAA traffic alerting; Remote G3X Touch v1 integration out of scope) must be honored throughout.
- **§15 — External I/O.** Output contracts to X-Plane and MSFS host simulators. OPEN QUESTIONS 4 and 5 sit here.
- **§4.9 — Hazard Awareness.** Alert behaviors (TAWS, traffic, terrain, weather). OPEN QUESTION 6 sits here.
- **§7 — Procedures.** Approach state machine. D-15 framing (no internal VDI; vertical guidance presented to external display only) must be honored.

### P2 — Functionality-critical

These sections describe core navigation and editing behaviors. Findings should be accepted if functional-fidelity-test positive; rejected with documentation otherwise.

- **§§5–6 — Flight plan editing + Direct-to.**
- **§§8–10 — Nearest, Waypoint Information, Settings.**
- **§14 — Persistent State.**
- **§12 — Audio / Alerts.**
- **§13 — Messages.**

### P3 — Quality / polish

These sections are largely PDF transcription and stable. Verify-only sweeps are sufficient unless an issue surfaces.

- **§§1–4 — Overview, Physical / Controls, Power-On, Display Pages.**
- **Appendices A, B, C.**

---

**Triage reminder (per D-22 §3):** every finding must pass a functional-fidelity test to be accepted into V2. A finding that says "the spec doesn't document behavior X that the real device has" is functional. A finding that says "the spec could be more consistent in cross-referencing §A and §B" is editorial. Even HIGH-severity findings fall into both buckets.
```

### A.2: Verify the source file

```
wc -l docs/specs/fragments/_review_priority_guide.md
head -1 docs/specs/fragments/_review_priority_guide.md
tail -1 docs/specs/fragments/_review_priority_guide.md
```

Record:
- Line count (expected ~32 lines including blank lines and the closing triage-reminder block).
- First line: must be `## Review Priority Guide`.
- Last line: must be the triage-reminder paragraph (or a trailing blank line — either is fine; the assembly script's prepend logic handles the boundary).

---

## Phase B: Add `--review-priority-guide` flag to the assembly script

### B.1: Inspect the script

Re-read the relevant sections of `scripts/assemble_gnx375_spec.py`:
```
grep -n "argparse\|add_argument\|--output\|--manifest\|--fragments-dir" scripts/assemble_gnx375_spec.py
```

Identify the argparse setup block (where existing flags are added) and the output-composition block (where the assembled lines are written).

### B.2: Add the argparse flag

In the same argparse block where `--manifest`, `--fragments-dir`, and `--output` are defined, add:

```python
parser.add_argument(
    "--review-priority-guide",
    metavar="PATH",
    type=str,
    default=None,
    help="Path to a markdown file to prepend to the assembled aggregate. "
         "If supplied, the file's content is inserted between the H1 metadata block "
         "(H1 title + HTML assembly comment) and the '---' separator. "
         "If absent, no priority guide is prepended (default).",
)
```

Match the existing argparse style for consistency (indentation, whether the arguments are on separate lines, etc.).

### B.3: Add the prepend logic

Locate the function or code block that produces the assembled output. The current shape is approximately:
- An H1 line is written first.
- Then a multi-line HTML comment with assembly metadata.
- Then a blank line.
- Then a `---` separator on its own line.
- Then a blank line.
- Then the first fragment's body content.

The injection point is between the trailing blank line of the HTML comment block and the `---` separator. Two implementation patterns are acceptable; pick whichever is cleaner given the existing code:

**Pattern 1 (line-based):** if the script composes the output as a list of lines, find the index of the `---` line and insert the guide content lines just before it (with appropriate blank-line padding to maintain markdown well-formedness).

**Pattern 2 (block-based):** if the script composes the output as a sequence of string blocks (header_block, separator, fragment_blocks, ...), insert the guide content as a new block between header_block and separator.

Implementation requirements:
- The flag's value is a path; read its content with `Path(args.review_priority_guide).read_text(encoding="utf-8")` (or the existing read pattern in the script).
- Strip trailing whitespace from the loaded content; ensure exactly one blank line precedes and follows the inserted content in the final output.
- The guide file already begins with `## Review Priority Guide`; do not add another header. Insert verbatim.
- When the flag is `None` (default), the assembly output is byte-identical to the pre-flag behavior.

### B.4: Update the script's module docstring

The current docstring includes a usage line listing the existing flags. Add `--review-priority-guide <path>` to that line family. Pattern (illustrative — match the existing style):

```
Run from project root:
  python scripts/assemble_gnx375_spec.py [--verbose] [--check] [--partial]
                                          [--manifest <path>] [--fragments-dir <path>]
                                          [--output <path>]
                                          [--review-priority-guide <path>]
```

### B.5: Backward-compatibility smoke test (flag absent)

Run without the new flag to confirm zero regression:
```
python scripts/assemble_gnx375_spec.py --check
```

If `--check` validates fragment integrity without writing output, this must pass. If `--check` mode does not exist or doesn't apply here, run a full assembly to a scratch path and diff against the current aggregate's first 30 lines:
```
python scripts/assemble_gnx375_spec.py --output /tmp/aggregate_smoke_no_flag.md
diff <(head -30 docs/specs/GNX375_Functional_Spec_V1_aggregate.md) <(head -30 /tmp/aggregate_smoke_no_flag.md)
```
Expected: zero diff (the new flag, when absent, must not change output).

If smoke test fails: STOP and write a deviation report. Do not proceed to Phase C.

---

## Phase C: Run assembly with the flag + verify

### C.1: Run assembly with the flag

```
python scripts/assemble_gnx375_spec.py --review-priority-guide docs/specs/fragments/_review_priority_guide.md
```

This regenerates `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` with the priority guide prepended.

### C.2: Verify output structure

Run all six checks below. All must pass. If any fails, STOP and document in deviation report.

**1. Header structure:**
```
sed -n '1,40p' docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
Visually verify the shape:
- Line 1: `# GNX 375 Functional Spec V1`
- Lines 2–N: HTML comment block + a blank line
- A `## Review Priority Guide` H2 section
- The full guide content (P1, P2, P3 buckets + triage reminder)
- The `---` separator on its own line
- A blank line
- `## 1. Overview` (start of Fragment A content)

**2. Guide presence (exactly one occurrence of the H2):**
```
grep -c "^## Review Priority Guide" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
Expected: `1`.

**3. Fragment content intact (each P1 section header still present once):**
```
grep -c "^## 1\. Overview" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
grep -c "^## 11\." docs/specs/GNX375_Functional_Spec_V1_aggregate.md
grep -c "^## 15\." docs/specs/GNX375_Functional_Spec_V1_aggregate.md
grep -c "^### 4\.9" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
grep -c "^## 7\." docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
All expected: `1` each. (Confirms the seven fragments are all assembled and the priority guide didn't displace section headers.)

**4. Line-count delta:**
```
wc -l docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
Expected: baseline (recorded in pre-flight check 4) + approximately 32–36 lines for the inserted guide. Document the exact delta in the completion report.

**5. No double H1:**
```
grep -c "^# GNX 375 Functional Spec V1" docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```
Expected: `1`. (Confirms the guide content didn't introduce a second H1; if guide content begins with H1, this would catch the bug.)

**6. Idempotency:** run assembly twice consecutively and compare hashes:
```
python scripts/assemble_gnx375_spec.py --review-priority-guide docs/specs/fragments/_review_priority_guide.md
md5sum docs/specs/GNX375_Functional_Spec_V1_aggregate.md > /tmp/agg_md5_1.txt
python scripts/assemble_gnx375_spec.py --review-priority-guide docs/specs/fragments/_review_priority_guide.md
md5sum docs/specs/GNX375_Functional_Spec_V1_aggregate.md > /tmp/agg_md5_2.txt
diff /tmp/agg_md5_1.txt /tmp/agg_md5_2.txt
```
Expected: `diff` produces no output (the regeneration timestamp in the HTML comment may differ; if it does, the script is non-deterministic with respect to that field, which is expected — note in completion report and consider the idempotency check satisfied if all non-timestamp content is identical).

If the timestamp changes between runs, perform a content-only idempotency check:
```
diff <(grep -v "Generated:" /tmp/agg_run1.md) <(grep -v "Generated:" /tmp/agg_run2.md)
```

---

## Phase D: Completion report + commit + ntfy

### D.1: Status updates (none)

CC must NOT update CD-maintained status files (`Spec_Tracker.md`, `CC_Task_Prompts_Status.md`, `priority_task_list.md`, `Task_flow_plan_with_current_status.md`). CD updates these on the `check updates` cycle.

### D.2: Completion report

Write `docs/tasks/review_priority_guide_01_completion.md` containing:

- **Pre-flight check results** — all 7 numbered checks with their actual output/status.
- **Phase A** — source file path, line count, first-line and last-line confirmation.
- **Phase B** — script edits with concrete details:
  - Line numbers where the new argparse flag was added (before/after if helpful).
  - Line numbers where the prepend logic was added (before/after, or a code excerpt of the new block).
  - Docstring change (before/after).
  - Backward-compatibility smoke test result.
- **Phase C** — all 6 verification check results with actual output values, including the line-count delta.
- **Final state** —
  - New file: `docs/specs/fragments/_review_priority_guide.md` (line count).
  - Modified file: `scripts/assemble_gnx375_spec.py` (count of lines added/removed).
  - Regenerated: `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` (baseline line count → new line count, delta).
- **Any deviations** — anything CC encountered that differed from this prompt's expectations, with the resolution chosen.

### D.3: Stage and commit (D-29 simple format)

```
git add docs/tasks/review_priority_guide_01_prompt.md \
        docs/tasks/review_priority_guide_01_completion.md \
        docs/specs/fragments/_review_priority_guide.md \
        scripts/assemble_gnx375_spec.py \
        docs/specs/GNX375_Functional_Spec_V1_aggregate.md
```

```
git commit -m "REVIEW-PRIORITY-GUIDE-01: author guide source + add --review-priority-guide flag to assembly script + regenerate aggregate [AI commit]" -m "Adds docs/specs/fragments/_review_priority_guide.md with P1/P2/P3 section bucketing per D-22 §5. Adds --review-priority-guide flag to scripts/assemble_gnx375_spec.py; flag-absent invocation is byte-identical to pre-flag behavior. Regenerates aggregate with guide prepended between H1 metadata block and the --- separator. C3 spec review V1 prerequisite #1 of 3 (verify_gnx375_manifest.py + three Sonnet agents pending separately)." -m "Refs: D-22"
```

### D.4: Send completion notification

```
Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "REVIEW-PRIORITY-GUIDE-01 completed [flight-sim]"
```

### D.5: Do not push

CC commits but does NOT push. Steve pushes manually after CD review (`check completions` → `check compliance`).

---

## Out of scope for this task

- **`scripts/verify_gnx375_manifest.py`** — separate P1 task (the manifest pre-flight verifier). Will be authored as its own CC task.
- **Three Sonnet agents at `.claude/agents/`** (`spec-pdf-source-fidelity-reviewer`, `spec-cross-fragment-coupling-reviewer`, `spec-sibling-unit-consistency-reviewer`) — separate P1 task or tasks.
- **C3 spec review itself** — gated on all three P1 items.
- **CD-maintained status file updates** — CD performs on `check updates`.
- **Any modification of the assembly script's existing behavior** beyond adding the new flag and the conditional prepend logic. The flag-absent path must be byte-identical to current behavior.
- **D-22 amendment or follow-on decisions** — none anticipated; this task implements §5 verbatim. If CC notices an ambiguity in §5 that requires a decision, escalate via deviation report rather than improvising.
