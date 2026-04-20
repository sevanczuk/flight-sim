# CC Task Prompt: AMAPI Pattern Analysis from Tier 1 Instrument Samples

**Location:** `docs/tasks/amapi_patterns_prompt.md`
**Task ID:** AMAPI-PATTERNS-01 (Stream B3)
**Parent tasks:** SAMPLES-RENAME-01 (B1, complete), AMAPI-PARSER-01 (A2, complete)
**Depends on:** B2 subset selection (CD work, complete) at `docs/knowledge/instrument_samples_b2_subset_selection.md`; A2 reference docs at `docs/reference/amapi/by_function/`; A3 use-case index at `docs/knowledge/amapi_by_use_case.md`
**Priority:** Critical-path — blocks Stream B readiness review (B4) and eventual GNC 355 Design Spec (Stream C2)
**Estimated scope:** Large — 1.5–3 hours; read 6 Tier 1 + 8 Tier 2 sample logic.lua files; extract idioms; produce pattern catalog with cross-links
**Task type:** docs-only (no code changes; reads only)
**CRP applicability:** YES — multi-phase, expected output >500 lines, estimated >15 min. Apply CRP per `docs/standards/compaction-resilience-protocol-v1.md`.
**Source of truth:**
- `docs/knowledge/instrument_samples_b2_subset_selection.md` (which samples to study, and why)
- `docs/knowledge/amapi_by_use_case.md` (task-oriented AMAPI index — cross-reference target)
- `docs/reference/amapi/by_function/*.md` (per-function reference — cross-reference target for every pattern)
- `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` §6.B.3 (pattern analysis phase description)
- `docs/knowledge/instrument_samples_index.md` (B1 manifest with all 45 sample metadata)
**Supporting assets:**
- `assets/instrument-samples-named/{safe_name}/logic.lua` — one per sample (read-only)
- `assets/instrument-samples-named/{safe_name}/info.xml` — instrument metadata (read-only)
- `assets/instrument-samples-named/{safe_name}/resources/` — images/sounds (read-only; do not parse)
- `assets/instrument-samples-named/{safe_name}/lib/` — shared Lua libs (read if referenced from logic.lua)
**Audit level:** self-check + spot-check — rationale: pattern identification involves judgment calls. After completion, CD will spot-check 5 patterns against source samples.

---

## Pre-flight Verification

**Execute these checks before writing any content. If any check fails, STOP and write a deviation report.**

1. Verify source-of-truth docs exist:
   - `ls docs/knowledge/instrument_samples_b2_subset_selection.md`
   - `ls docs/knowledge/amapi_by_use_case.md`
   - `ls docs/knowledge/instrument_samples_index.md`
2. Verify Tier 1 sample directories exist and each has a logic.lua:
   - `generic_garmin-gtn-650_1ae7feb5` (Tier 1 primary)
   - `generic_garmin-gns-530_72b0d55c`
   - `generic_garmin-gns-430_24038c68`
   - `generic_bendixking-kap-140-autopilot-system_da394c59`
   - `generic_bendixking-kx-165a-ts0-com1nav1_a6f6d3b9`
   - `generic_garmin-gfc-500-autopilot_c154321a`
3. Verify A2 reference docs directory exists and has expected function coverage:
   - `ls docs/reference/amapi/by_function/ | wc -l` — expect ~214
   - `ls docs/reference/amapi/by_function/Xpl_dataref_subscribe.md` — sanity check one
4. Verify no conflicting output exists:
   - `ls docs/knowledge/amapi_patterns.md` — should FAIL (new file). If it already exists, note in deviation report.

**If any check fails:** Write `docs/tasks/amapi_patterns_prompt_deviation.md` and STOP.

---

## Phase 0: Source-of-Truth Audit

Before any analysis work:

1. Read all source-of-truth documents listed in the prompt header.

**Definition — Actionable requirement:** A statement that, if not implemented, would make the task incomplete.

2. Extract actionable requirements relevant to this task, with particular attention to:
   - B2's Tier 1 / Tier 2 boundaries (what gets deep-dissected vs. referenced)
   - B2's 10 selection criteria (touchscreen, knobs, multi-page, sim subscribe, sim write, persist, canvas, portability, hardware, audio)
   - B2's "open items for B3 prompt" notes (§final section)
   - The A3 use-case index structure (18 sections; cross-reference target)
3. Cross-reference each requirement against this prompt's Implementation Order below.
4. If ALL covered: print "Phase 0: all source requirements covered" and proceed.
5. If any requirement is uncovered: write `docs/tasks/amapi_patterns_prompt_phase0_deviation.md` and STOP.

---

## CRP Configuration

**Work directory:** `_crp_work/amapi_patterns_01/`

**Status file:** `_crp_work/amapi_patterns_01/_status.json`:

```json
{
  "task_id": "AMAPI-PATTERNS-01",
  "phases": {
    "A": {"status": "complete|in-progress|pending", "started": "<iso>", "completed": "<iso>", "artifacts": ["..."]},
    "B": {...},
    ...
  },
  "current_phase": "A|B|C|D|E",
  "last_updated": "<iso>"
}
```

**Phase completion markers:** `_crp_work/amapi_patterns_01/_phase_{A|B|C|D|E}_complete.md` at phase end.

**Intermediate output scratch:** `_crp_work/amapi_patterns_01/raw_notes_{sample_safe_name}.md` — one notes file per Tier 1 sample, accumulated during Phase B. These become source material for Phase C's pattern extraction. Retain through Phase D; CD cleans up after compliance verification.

**Resume protocol:** On session start, read `_status.json`; resume from first phase whose status != "complete".

---

## Instructions

Produce a pattern catalog derived from reading the 6 Tier 1 instrument `logic.lua` files (with Tier 2 as a secondary reference pool). Each pattern entry describes an idiom that appears in multiple samples, explains when and why to use it, cross-links to the AMAPI reference docs for every function involved, and provides a minimal, idiomatic code sketch.

**Primary output:** `docs/knowledge/amapi_patterns.md`

**Design principles:**
- **Patterns emerge from repetition.** A "pattern" is an idiom that appears in 2+ Tier 1 samples. Single-occurrence idioms are noted as "sample-specific techniques" in an appendix, not elevated to patterns.
- **Every pattern cross-links.** Each pattern entry links to the AMAPI reference doc for every function it mentions (`docs/reference/amapi/by_function/Xxx.md`) AND to the source samples that exemplify it.
- **Code sketches, not code copies.** Show the idiomatic skeleton (10–25 lines per pattern typically), not full source dumps. Include a "full example" pointer to the source sample for readers who want more.
- **Dual-simulator emphasis.** The GNC 355 scope is X-Plane + MSFS. When a pattern has different shapes for single-sim vs. multi-sim, document both; mark the multi-sim variant as preferred for the GNC 355.
- **Source-traceable.** Every claim about "samples commonly do X" must reference at least two Tier 1 samples by name. If a pattern is seen in only one Tier 1 sample, it's a candidate for a pattern but must be validated by a search across the full 45-sample corpus (see Phase C.3).
- **Non-destructive.** This task reads only. Never modifies any instrument sample file.

**Also read `CLAUDE.md`** for conventions including D-04 commit trailer policy. **Also read `claude-conventions.md`** §Git Commit Trailers for the exact commit format.

---

## Integration Context

- **Platform:** Windows PowerShell. Python allowed in `.py` files for text processing but not strictly required (grep/find/rg across the samples-named tree is often sufficient).
- **Python env:** Existing. No new dependencies.
- **Key files this task creates:**
  - NEW: `docs/knowledge/amapi_patterns.md` — the primary pattern catalog
  - NEW: `docs/knowledge/amapi_patterns_sample_appendix.md` — per-sample summary notes (one short section per Tier 1 sample, for reference)
  - INTERNAL: `_crp_work/amapi_patterns_01/raw_notes_*.md` — per-sample raw notes (CC's scratch work; retained; CD cleans up later)
- **Sample files (READ ONLY):**
  - `assets/instrument-samples-named/{safe_name}/logic.lua` is the main file
  - `assets/instrument-samples-named/{safe_name}/info.xml` has metadata (aircraft, sim compat, dimensions)
  - `assets/instrument-samples-named/{safe_name}/resources/` contains images — do NOT parse; just note presence / naming for pattern examples
  - `assets/instrument-samples-named/{safe_name}/lib/*.lua` — shared helpers; read if referenced from logic.lua (search for `require`/`dofile` at top of each logic.lua)
- **A2 reference docs (READ ONLY):** `docs/reference/amapi/by_function/` — every pattern cross-links here. Link form: `[xpl_dataref_subscribe](../reference/amapi/by_function/Xpl_dataref_subscribe.md)` (relative from `docs/knowledge/`).
- **A3 use-case index (READ ONLY):** `docs/knowledge/amapi_by_use_case.md` — sibling document; pattern catalog should complement it (use-case index says WHICH function; pattern catalog says HOW to use it).

---

## Implementation Order

**Execute phases sequentially.** Update `_crp_work/amapi_patterns_01/_status.json` after each phase.

---

### Phase A: Per-sample reading and raw-notes capture (Tier 1)

For each of the 6 Tier 1 samples, in this exact order:

1. `generic_garmin-gtn-650_1ae7feb5`
2. `generic_garmin-gns-530_72b0d55c`
3. `generic_garmin-gns-430_24038c68`
4. `generic_bendixking-kap-140-autopilot-system_da394c59`
5. `generic_bendixking-kx-165a-ts0-com1nav1_a6f6d3b9`
6. `generic_garmin-gfc-500-autopilot_c154321a`

For each sample:

1. Read `info.xml` — extract: aircraft, instrument type, sim compat list, dimensions, version.
2. Read `logic.lua` in full.
3. If `logic.lua` contains `require(...)` or `dofile(...)` referencing files in `lib/`, read those too.
4. Write raw notes to `_crp_work/amapi_patterns_01/raw_notes_{safe_name}.md` with:
   - Metadata block (from info.xml)
   - **Structural outline:** top-level sections of logic.lua (usually delimited by `-- comment blocks` or by blank-line groupings). For each section, one-line summary.
   - **API call inventory:** every distinct AMAPI function called, with call-site count. Example:
     ```
     xpl_command: 12 calls
     fsx_event: 12 calls
     msfs_event: 12 calls
     button_add: 8 calls
     dial_add: 3 calls
     xpl_dataref_subscribe: 1 call
     ...
     ```
   - **Notable idioms observed:** free-form list of patterns, tricks, conventions — things that might generalize. Examples: "triple-dispatch to XPL+FSX+MSFS for every pilot action", "long-press implemented via timer_start with 1500ms delay", "active/standby frequency swap via a toggle variable".
   - **Sim-portability approach:** does the sample call XPL-specific, MSFS-specific, and FSX-specific APIs in parallel? Or does it use the generic `variable_subscribe`? Or does it check `msfs_connected()` and branch? Note the approach.
   - **Questions / anomalies:** things you didn't understand; things that look like bugs; things that look like they'd break on one sim.

**Do NOT yet synthesize patterns.** Phase A is raw observation per sample.

**Phase A complete marker:** write `_crp_work/amapi_patterns_01/_phase_A_complete.md` with:
- Samples read (6 expected)
- Total distinct AMAPI functions observed across Tier 1
- First pass of pattern candidates (list with counts per-sample — no cross-sample matching yet)

---

### Phase B: Cross-sample pattern extraction

With all 6 raw-notes files in hand, now synthesize patterns.

1. **Build a function-usage matrix.** Rows: AMAPI functions observed. Columns: the 6 Tier 1 samples. Cells: number of calls in that sample's logic.lua. Save as `_crp_work/amapi_patterns_01/function_usage_matrix.md`.

2. **Identify pattern candidates.** A candidate pattern is a group of 2+ functions that appear together repeatedly across samples. Examples:
   - If `button_add` + `xpl_command` + `fsx_event` + `msfs_event` co-occur in 4+ samples → "triple-dispatch button click" pattern.
   - If `user_prop_add_integer` + `user_prop_get` + `xpl_command` + string concatenation + `device_id` co-occur → "multi-instance device ID" pattern.
   - If `timer_start` with nested `timer_stop` + two `button_add` callbacks (press, release) → "long-press detection" pattern.

3. **Validate pattern candidates.** For each candidate, count the Tier 1 samples exhibiting it. Candidates appearing in 2+ Tier 1 samples are confirmed patterns. Candidates appearing in only 1 Tier 1 sample are moved to the "sample-specific techniques" appendix (Phase E output), OR validated against the full 45-sample corpus by grepping for the pattern's signature functions; if it appears in 3+ samples total, it's still a pattern but noted as "Tier-2/3-weighted".

4. **Cluster related patterns.** Group the confirmed patterns by category matching the A3 use-case index structure where possible (Reading sim state / Writing to sim / Touchscreen input / Knob input / Canvas drawing / Persistence / etc.) so the pattern catalog maps cleanly to the use-case index.

**Phase B complete marker:** write `_crp_work/amapi_patterns_01/_phase_B_complete.md` with:
- Confirmed pattern count
- Pattern-candidates-rejected count (with rationale)
- Cluster assignments (category → pattern count)

---

### Phase C: Tier 2 reference pass

For each of the 8 Tier 2 samples:

1. `cessna-172_heading_079a54d1`
2. `cessna-172_altimeter_cf5829f6`
3. `cessna-172_vor-nav1ils_94a0e896`
4. `cessna-172_adf_04a6aa5d`
5. `cessna-172_switch-panel_0fb7ea63`
6. `generic_garmin-340-audio-panel_d30c0bb4`
7. `generic_garmin-gma-1347d-audio-panel_965144b1`
8. `cessna-172_turn-coordinator_487838a2`

Read each `logic.lua` in SURVEY mode (not deep-dissect):

1. Confirm or refute the patterns identified in Phase B. For each confirmed Phase-B pattern, note whether this Tier 2 sample also exhibits it. Example: does `cessna-172_altimeter` use triple-dispatch? Does `cessna-172_heading` use the multi-instance device-ID pattern?
2. **Catch new patterns.** If a Tier 2 sample exhibits a clear idiom NOT seen in Tier 1 (e.g., audio-panel-specific patterns in the Garmin 340 sample), note as a new pattern candidate. Validate via: does it also appear in another Tier 2 sample or in any Tier 1 sample? If yes, promote to full pattern. If no, move to sample-specific techniques.
3. **Update the function-usage matrix** to include Tier 2 columns.

**Phase C complete marker:** write `_crp_work/amapi_patterns_01/_phase_C_complete.md` with:
- Tier-2 patterns confirmed
- New patterns discovered from Tier 2
- Updated final pattern count

---

### Phase D: Pattern catalog authoring

Write `docs/knowledge/amapi_patterns.md` with this structure:

```markdown
---
Created: <ISO 8601>
Source: docs/tasks/amapi_patterns_prompt.md
---

# AMAPI Pattern Catalog

**Derived from:** 6 Tier 1 + 8 Tier 2 instrument samples per `docs/knowledge/instrument_samples_b2_subset_selection.md`.
**Companion documents:**
- [AMAPI by Use Case](amapi_by_use_case.md) — task-oriented function index
- [AMAPI Function Inventory](amapi_function_inventory.md) — authoritative function list
- Per-function reference: `docs/reference/amapi/by_function/`

## How to use this document

Each pattern describes an idiom used in practice by real AMAPI instruments. The pattern entry includes: the problem it solves, a code sketch, live cross-references to every AMAPI function used, a list of exemplar samples, and notes on variants or caveats.

When authoring the GNC 355 Design Spec, reach for this catalog when you need HOW — for WHICH function to use in the first place, see the [use-case index](amapi_by_use_case.md).

## Pattern index

[Numbered table of contents with links to each pattern section below. Group by category (matching A3 use-case sections where possible). Each entry: pattern name + one-line description + count of samples exhibiting it.]

---

## Category: [name matching A3 use-case section]

### Pattern N.M: [Pattern name]

**Problem.** [1–2 sentences stating what the pattern addresses.]

**Solution.** [1–3 sentences describing the idiom.]

**Code sketch.**
```lua
-- Minimal idiomatic example, 10-25 lines typically
-- All function calls that would appear in practice
-- Variables named suggestively (e.g., btn_home, not x)
[code here]
```

**Functions used.**
- [`function_a`](../reference/amapi/by_function/Function_a.md) — [role in the pattern]
- [`function_b`](../reference/amapi/by_function/Function_b.md) — [role in the pattern]
- ...

**Exemplars.** The following samples use this pattern:
- `generic_garmin-gtn-650_1ae7feb5` — [brief context, e.g., "every pilot-action button uses triple-dispatch"]
- `cessna-172_altimeter_cf5829f6` — [brief context]
- ... (minimum 2 samples; list all that apply from Tier 1 + Tier 2)

**Variants.** [Optional; note differences between exemplars. e.g., "GTN 650 adds device_id suffix for multi-panel support; altimeter omits this since there's only one altimeter."]

**Caveats.** [Optional; note gotchas. e.g., "On XPL-only instruments, the fsx_event and msfs_event calls are dead code but harmless. On MSFS-only instruments, the xpl_command call is dead code."]

**GNC 355 relevance.** [1–2 sentences: when does the GNC 355 design spec need this pattern? What will it look like in the spec?]

---

[Repeat for each pattern]

---

## Pattern cross-reference

[A table or list: for each AMAPI namespace used in any pattern, list the patterns that use it. This lets a reader who starts at the A3 use-case index find relevant patterns.]

## What this catalog does NOT cover

- **Sample-specific techniques.** Idioms that appeared in only one Tier 1 sample and didn't validate against the corpus. See the companion [sample appendix](amapi_patterns_sample_appendix.md).
- **Hardware patterns (`Hw_*`).** The GNC 355 is currently scoped as software-only; hardware-panel binding patterns are observed but deprioritized.
- **3D scene patterns (`Scene_*`).** The GNC 355 is 2D-only.
- **Flight Illusion hardware (`Fi_*`).** Not applicable.
- **Device catalog (`Device_*`).** Applies to integrated avionics panels, not standalone instruments.
```

**Target pattern count:** 15–30 patterns. Fewer than 15 suggests the analysis missed idioms; more than 30 suggests sample-specific techniques are being elevated. If the count falls outside this band, investigate and document the reason in the completion report.

**Phase D complete marker:** write `_crp_work/amapi_patterns_01/_phase_D_complete.md` with:
- Final pattern count
- Total cross-references from pattern catalog to `docs/reference/amapi/by_function/` (should be in the dozens to low hundreds)
- Categories covered vs. A3 use-case sections

---

### Phase E: Sample appendix

Write `docs/knowledge/amapi_patterns_sample_appendix.md` with:

1. **Per-Tier-1-sample summary (6 sections).** For each Tier 1 sample: metadata block; 1-paragraph functional description; list of patterns it exhibits (cross-linked to the pattern catalog); list of sample-specific techniques (idioms that didn't generalize).
2. **Per-Tier-2-sample summary (8 sections, shorter).** Metadata + 1 sentence functional description + list of patterns confirmed.
3. **Sample-specific techniques catalog.** Any pattern candidate that was rejected because it appears in only one sample. Keep entries short; main value is completeness for future reference.

**Phase E complete marker:** write `_crp_work/amapi_patterns_01/_phase_E_complete.md`.

---

## Completion Protocol

1. Verify outputs exist:
   - `docs/knowledge/amapi_patterns.md`
   - `docs/knowledge/amapi_patterns_sample_appendix.md`
   - `_crp_work/amapi_patterns_01/_status.json` with all phases `"status": "complete"`
   - All 6 `_crp_work/amapi_patterns_01/raw_notes_*.md` files
   - `_crp_work/amapi_patterns_01/function_usage_matrix.md`

2. Verify cross-reference integrity by spot-checking 5 random pattern-catalog links:
   - Pick 5 AMAPI function references from the pattern catalog
   - Confirm each target file exists under `docs/reference/amapi/by_function/`
   - Confirm each exemplar sample directory exists under `assets/instrument-samples-named/`
   - Record spot-check results in the completion report

3. Write completion report `docs/tasks/amapi_patterns_completion.md` with:
   - Provenance header
   - Phase summary table (A–E status + artifacts)
   - Pattern count (target 15–30)
   - Pattern-by-category breakdown (aligned to A3 use-case sections)
   - Cross-reference count (pattern catalog → function reference docs)
   - Samples analyzed (6 Tier 1 deep + 8 Tier 2 survey)
   - Notable pattern-category gaps: categories from A3 with few or no patterns (may indicate missing samples; worth flagging)
   - Sample-specific techniques count (expected: 5–15)
   - Spot-check results
   - Any deviations from this prompt with rationale

4. Commit using the D-04 trailer format via a message file. Message structure:
   ```
   AMAPI-PATTERNS-01: pattern catalog from Tier 1+2 instrument samples

   Task-Id: AMAPI-PATTERNS-01
   Authored-By-Instance: cc
   Refs: SAMPLES-RENAME-01, AMAPI-PARSER-01, GNC355_Prep_Implementation_Plan_V1
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```
   CC writes the message to a temp file and uses `git commit -F <file>`. Do NOT use multi-`-m` (Steve's PowerShell setup has issues with that; consistent patterns across CC/CD matter).

5. **Flag refresh check:** This task does not modify `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`. Do NOT create refresh flags.

6. Send completion notification:
   ```
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "AMAPI-PATTERNS-01 completed [flight-sim]"
   ```

**Do NOT git push.** Steve pushes manually.

---

## What This Unblocks

- **B4 readiness review:** after CD check-completions on this task. Trivial if PASS.
- **Stream A + Stream B both "ready for design phase"**, triggering **ITM-01** file-movement batch.
- **Stream C2 (GNC 355 Functional Spec draft):** can now be authored, referencing the pattern catalog extensively.

---

## Anticipated Observations (to calibrate expectations)

Based on spot-reading two Tier 1 samples during prompt authoring:

- **Triple-dispatch pattern will dominate.** Every pilot-action button in Garmin GTN 650 and Cessna altimeter fires `xpl_command` + `fsx_event` + `msfs_event` in sequence. Expect this to be the most common pattern across Tier 1.
- **Parallel subscription pattern for reading state.** Altimeter subscribes via `xpl_dataref_subscribe` + `fsx_variable_subscribe` + `msfs_variable_subscribe` all wired to the same callback. Probably in 4+ of 6 Tier 1 samples.
- **Long-press via timer.** GTN 650 uses `timer_start(1500, nil, callback)` inside a button's press callback, then `timer_stop` in the release callback to distinguish short vs. long press. Look for this elsewhere.
- **Multi-instance pattern.** GTN 650 has a `Device ID` user prop for supporting 2+ GTN 650s on one panel. Look for this pattern elsewhere; confirm whether it's Garmin-specific or broader.
- **Detent-type user prop pattern.** Altimeter uses `user_prop_add_enum` to let the user pick rotary-encoder detent type, then maps the string to a `TYPE_N_DETENT_PER_PULSE` constant. Look for this in other knob-heavy samples.

These are anticipated, not guaranteed. CC's analysis supersedes these predictions. If these anticipated patterns are NOT found, note it in the completion report — the absence would be itself informative.
