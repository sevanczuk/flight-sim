# Purple Briefing — Flight-Sim GNC 355 Project

**Created:** 2026-04-20T10:10:00-04:00
**Source:** Purple Turn 59 — context handoff to next Purple session before compaction
**Read this:** at session start, alongside the latest checkpoint file

---

## Current state in 60 seconds

We're prepping to build a GNC 355 touchscreen GPS/COM Air Manager instrument. The work has three parallel knowledge-gathering streams (A=AMAPI docs, B=instrument-sample patterns, C=Garmin Pilot's Guide PDF). All three streams are nearly done; the last critical-path task is **B3 (pattern analysis)** which is currently running in CC.

When B3 completes, the workflow is:
1. Check completions on B3 (D-05 shorthand: assess `*_completion.md`)
2. B4 readiness review (small CD task)
3. **ITM-01 fires** → file movement batch (CC task to move ~10 completed task file sets to `docs/tasks/completed/`)
4. **C2 GNC 355 Functional Spec authoring** begins

That's the critical path. Everything else is housekeeping or future scope.

---

## What B3 is producing

**Task:** AMAPI-PATTERNS-01 (Stream B3)
**Prompt:** `docs/tasks/amapi_patterns_prompt.md`
**Expected wall-clock:** 1.5–3 hours from launch
**CRP work directory:** `_crp_work/amapi_patterns_01/` — has `_status.json` for resume if needed

CC is reading 6 Tier 1 + 8 Tier 2 instrument samples, extracting common idioms, producing:
- `docs/knowledge/amapi_patterns.md` — the pattern catalog (target 15–30 patterns)
- `docs/knowledge/amapi_patterns_sample_appendix.md` — per-sample summaries

Each pattern entry must cross-link to `docs/reference/amapi/by_function/{Page}.md` (Stream A2's output) using `../reference/amapi/by_function/` relative paths. Pattern catalog complements A3 use-case index (use-case = "which function"; pattern catalog = "how to use it").

### Anticipated patterns (calibration)

When you assess B3's output, expect these (from spot-reading two samples during prompt authoring):

1. **Triple-dispatch pattern** — every pilot button fires `xpl_command` + `fsx_event` + `msfs_event` for cross-sim portability. Will be the most common.
2. **Parallel subscription pattern** — same callback wired to `xpl_dataref_subscribe` + `fsx_variable_subscribe` + `msfs_variable_subscribe`.
3. **Long-press detection** — `timer_start(1500ms)` in press callback; `timer_stop` in release; if timer fires, long-press; if released first, short-press.
4. **Multi-instance device-ID** — `user_prop_add_integer("Device ID", ...)` + string concatenation into command names for supporting 2+ panels.
5. **Detent-type user prop** — `user_prop_add_enum` for rotary-encoder detent type, mapped to `TYPE_N_DETENT_PER_PULSE` constant.

If these are absent from B3's catalog, that's surprising and worth flagging. If they're present, that's confirmation the analysis is sound.

---

## Stream completion status

| Stream | Wave 1 | Wave 2 | Status |
|---|---|---|---|
| A (AMAPI knowledge base) | ✓ A1 crawler+bugfixes (D-04 through bugfix-03) | ✓ A2 parser, ✓ A3 use-case index | **READY for design phase** |
| B (Instrument samples) | ✓ B1 rename+manifest (45 samples) | ✓ B2 selection (6+8+26 tiers), **B3 in flight** | B3 → B4 pending |
| C (GNC 355 PDF) | ✓ C1 extraction (310 pages) + manual eyeball | C2 spec draft pending | Waiting on Streams A+B ready |

---

## Pending items by priority

### Immediate (when you wake up)

1. **Check whether B3 has completed.** Look for:
   - `docs/tasks/amapi_patterns_completion.md` — if present, B3 is done; assess via D-05 shorthand
   - `_crp_work/amapi_patterns_01/_phase_E_complete.md` — confirms all phases done
   - If neither: B3 is still running or failed. Check `_crp_work/amapi_patterns_01/_status.json` for current phase.
   - If failed: read the deviation file (`docs/tasks/amapi_patterns_prompt_deviation.md` or `_phase0_deviation.md`) and diagnose.

2. **If B3 complete and PASSED:**
   - Note Stream B reaches "ready for design phase" — both A and B now ready
   - **Trigger ITM-01:** draft a CC task to batch-move completed task files to `docs/tasks/completed/`. List of ~10 task file pairs in `docs/todos/issue_index.md` under ITM-01.
   - After ITM-01 lands: draft **C2 prompt** (GNC 355 Functional Spec). This is the big one.

### Cross-stream pending

- **ITM-01** (file movement batch): see above. Detailed list in `docs/todos/issue_index.md`.
- **FE-01** (parser argument-cell links): low priority; deferred. Don't act unless asked.
- **Refresh flags pending Steve action:** `CLAUDE.md.needs_refresh`, `claude-conventions.md.needs_refresh`. Steve re-uploads to Claude.ai project Files when convenient. No CD action needed.

---

## How CD operates in this project

- **Hard CD/CC boundary:** CD designs/plans/coordinates; CC implements/tests/files. CD never executes code or runs tests; CD never deep-dives into multi-file code tracing — package as CC task.
- **D-04 commit policy:** every commit has trailers (`Task-Id`, `Authored-By-Instance`, optional `Refs`/`Decision`/`Fixes`/`Supersedes`/`Co-Authored-By`). CD drafts commits; Steve executes; only Steve pushes. Memory slots #23 and #24.
- **D-04 mechanics:** commits via `git commit -F <file>` (NOT multi-`-m` — PowerShell swallows empty `-m ""`). Write message via `[System.IO.File]::WriteAllText` with `Join-Path $PWD ".git\COMMIT_EDITMSG_cd"` (NOT `Out-File` — adds BOM). Always provide two code blocks: stage + commit. See `claude-conventions.md` §Git Commit Trailers for the canonical pattern.
- **D-05 shorthand:** Steve says "assess `*_filename.md`" → trigger the protocol matching the filename suffix. `*_completion.md` → check completions; `*_compliance.md` → check compliance; `*_validation.md` → check validation; `*_review.md` → spec review triage. Memory slot #25.
- **Decision logging:** any prescriptive language ("X should Y", "the lesson is Y") or revision of prior conventions = log as D-{n} in `docs/decisions/` SAME TURN. Tripwire is real, not habit. Memory slot #9.
- **Turn header:** every CD response begins with `## Purple Turn N - YYYY-MM-DDTHH:MM:SS-04:00 ET` from system command (never guessed). Get via `bash_tool` with `TZ="America/New_York" date "+%Y-%m-%dT%H:%M:%S%:z"`.
- **CC launch format:** two code blocks, tab title + CC prompt, separately, with task-slug labels. See `claude-conventions.md` §CC Launch Format.
- **ntfy completion notification:** every CC task ends with `Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "{TASK-ID} completed [flight-sim]"`. CC handles this in its own completion protocol; CD doesn't trigger it.

---

## Where the goods live

| What | Where |
|---|---|
| Project root | `C:\Users\artroom\projects\flight-sim-project\flight-sim\` |
| Decision log | `docs/decisions/D-NN-*.md` (D-01 through D-06) |
| Active issue tracker | `docs/todos/issue_index.md` (ITM-01, FE-01) |
| AMAPI reference docs (CC-generated) | `docs/reference/amapi/by_function/*.md` (~214 files) |
| AMAPI use-case index (CD-authored) | `docs/knowledge/amapi_by_use_case.md` |
| AMAPI function inventory | `docs/knowledge/amapi_function_inventory.md` |
| Instrument sample manifest | `docs/knowledge/instrument_samples_index.md` |
| B2 selection rationale | `docs/knowledge/instrument_samples_b2_subset_selection.md` |
| GNC 355 reference asset | `assets/gnc355_reference/land-data-symbols.png` (curated from PDF page 125) |
| Pipeline implementation plan | `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` |
| Conventions (full) | `claude-conventions.md` (project root) |
| CC safety | `cc_safety_discipline.md` (project root) |
| Memory mirror | `claude-memory-edits.md` (25 slots, in sync with live memory) |

---

## Recent decisions (D-04 through D-06 most relevant)

- **D-01** project scope: X-Plane primary, MSFS secondary, near-term GNC 355
- **D-02** GNC 355 prep three-stream scoping (A/B/C)
- **D-03** AMAPI crawler DB schema + URL normalization rules
- **D-04** commit trailer policy (the big one — applies to every commit)
- **D-05** "assess" shorthand
- **D-06** gitignore PDF extraction output (precedent for gitignoring regenerable artifacts)

---

## Open questions / future-Purple watchpoints

1. **C2 spec format.** When you draft C2, decide: monolithic (single doc) or piecewise (parts + manifest)? GNC 355 functional spec will likely be 1500+ lines — piecewise + manifest is probably the right call. Reference the spec lifecycle workflow in `claude-conventions.md` §Spec Creation → Review Lifecycle.

2. **C2 will reference everything.** It pulls from Stream A reference docs, Stream B pattern catalog, and Stream C extracted PDF content. The provenance webs will be substantial.

3. **A3 was scoped down to a CD doc per Steve direction (Turn 53).** No CC task for A3. Stream A is complete via A2+A3 even though there was no formal A4 review — the use-case index serves as the readiness signal.

4. **Push policy:** Steve has been pushing manually after each significant commit batch. CD doesn't push. CC doesn't push. Don't suggest pushing.

5. **Manual task completion (page 125 land-data-symbols):** completed; don't re-raise.

---

## Don't forget

- Check `_crp_work/amapi_patterns_01/_status.json` first if B3 status is unclear
- D-04 commit format MUST be used for any CD-drafted commit
- Use D-05 shorthand on assessment-type filenames
- Log decisions same-turn or you'll lose them to compaction
- End substantive turns with "→ Decision log: wrote D-{seq}" or "→ no decisions this turn"
