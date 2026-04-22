# Purple Briefing — Flight-Sim GNX 375 Project

**Created:** 2026-04-22T11:00:00-04:00
**Source:** Purple Turn 36 — context handoff at clean session seam (C2.2-A complete + manifest + D-19; C2.2-B drafting NEXT UP)
**Read this:** at session start, alongside `flight-sim-2026-04-22-1100-purple.md` (the structured checkpoint)

---

## Current state in 60 seconds

The GNX 375 functional spec is in active body authoring (C2.2). Of 7 piecewise fragments per D-18, **Fragment A is complete and archived**, the **manifest exists**, and **C2.2-B drafting is the immediate next task**. The remaining 6 fragments (B–G) follow a sequential lifecycle: CD draft prompt → CC author → CD check-completions → CC compliance → CD check-compliance → archive → next.

The C2.1-375 outline (1,477 lines, 18 divisions, archived Turn 29) is the authoritative blueprint. D-18 partitions C2.2 into 7 fragments; D-19 sets per-fragment line-count targets at ~1.35× outline expansion.

When you wake up: draft C2.2-B prompt. Scope §§4.1–4.6 (Home, Map, FPL, Direct-to, Waypoint Info, Nearest pages). Target ~720 lines per D-19. Use `docs/tasks/completed/c22_a_prompt.md` as the structural template. Note: §4.2 Map page is the heaviest sub-section with B4 Gap 1 (Map rendering architecture) as a major design open question — explicitly direct CC NOT to resolve B4 Gap 1 in spec body.

---

## What just happened (Turns 27–35)

The session executed C2.1-375 compliance + archive (Turns 27–29), the D-18 format decision (Turn 30), and the entire C2.2-A lifecycle (Turns 31–35) plus D-19.

**C2.1-375 compliance:** PASS WITH NOTES, 16/17. The one DISCREPANCY (item 12, §4 length-estimate inconsistency) was logged as ITM-07 and resolved inline by D-18 (adopted the §4 sub-section sum ~1,090 as authoritative; revised total spec body from ~2,860 to ~3,180).

**D-18 format decision:** piecewise + manifest, 7 fragments, sequential delivery. One more fragment than the C2.1-375 completion report's 6-task recommendation — the 7th task split addresses the revised §4 estimate by cleaving display pages at §4.6/§4.7 and consolidates the entire XPDR content block (§11 + §12.9 + §13.9) into a single task (C2.2-F).

**C2.2-A lifecycle:** task prompt drafted Turn 31 (~445-line target, 8 hard framing constraints). CC delivered 545 lines (+22% over target), explicitly flagged as deviation. Phase 1 review clean — all 8 framing commitments honored. Phase 2 compliance verified 17/17 PASS or CONFIRMED. Compliance breakdown of the line overage attributed every excess line to PDF-sourced content or prompt-mandated structure (glossary tables, sparse-page tables, Coupling Summary). No invention. CD accepted overage as-is.

**D-19:** lesson learned — the ~1.15× expansion ratio I baked into C2.2-A was too tight for fragments containing structured tables. New ratio: ~1.35×. Per-task adjusted targets: B=720, C=575, D=750, E=455, F=540, G=300. D-18's partition + spec-body total estimate (~3,180) remain authoritative; D-19 is delivery quality-of-life only.

**Manifest:** `docs/specs/GNX375_Functional_Spec_V1.md` created Turn 35. 7-row fragment table, A archived, B–G ⚪ Not yet drafted. Status legend, assembly instructions, status journal.

---

## Critical path from here

Roughly 16 sequential CD turns remain to C3 kick-off, plus 6 CC executions and 6 CC compliance runs. Per-fragment cycle is ~3 CD turns: prompt drafting → check-completions → check-compliance + archive.

| Step | Owner | Estimated turns/duration |
|------|-------|--------------------------|
| C2.2-B drafting | CD | 1 turn |
| C2.2-B execution | CC | 60–90 min wall-clock |
| C2.2-B Phase 1 + Phase 2 | CD + CC | 2 CD turns + 20–30 min CC |
| C2.2-B archive + manifest update | CD | 0.5 turn |
| **Repeat for C2.2-C through C2.2-G** | both | ~3 CD turns + 1.5 hours CC each |
| Aggregate via assembly script | CD writes script + Steve runs | 1 CD turn |
| C3 `/spec-review` V1 launch | CD + CC | 1 CD turn + multi-hour CC |
| C3 triage | CD | 1–2 turns |
| C4 iteration cycles to implementation-ready | CD + CC | 1–3 cycles, varies |

---

## Pending items by priority

### Immediate (when you wake up)

1. **Draft C2.2-B task prompt.** Use `docs/tasks/completed/c22_a_prompt.md` as the structural template. Adjust:
   - Scope: §§4.1–4.6 (Home, Map, FPL, Direct-to, Waypoint Info, Nearest pages)
   - Target: ~720 lines per D-19
   - Section coverage list: pull from outline (lines for §§4.1–4.6, see line numbers below)
   - Hard framing constraints: carry forward "no internal VDI" (relevant to §4.6 Nearest? probably not — but worth scanning), "no COM on GNX 375" (not relevant to §4 display pages directly)
   - Coupling Summary: backward-refs to Fragment A (glossary terms, knob behavior); forward-refs to §§5–7 (FPL editing, Direct-to ops, Procedures) in Fragment D
   - **B4 Gap 1 framing for §4.2 Map page** — explicitly direct CC NOT to resolve canvas vs. Map_add vs. video streaming in spec body; document the page structure and behavior contract only

2. **Provide CC launch sequence** (tab title + prompt block) for the new prompt.

### After C2.2-B archives

3. Update manifest: flip B from ⚪ to ✅ Archived.
4. Draft C2.2-C prompt (§§4.7–4.10, ~575 lines per D-19). The §4.9 Hazard Awareness sub-section is where ADS-B framing flips and TSAA aural alerts appear — major coupling forward to §11 (in Fragment F).

### Cross-stream pending

- **ITM-02, ITM-03, ITM-04, ITM-05** — all Low severity, batch-ready housekeeping. None blocking. See `docs/todos/issue_index.md`. Don't act unless asked.
- **FE-01** — AMAPI parser argument-cell links. Low priority, deferred. Don't act unless asked.
- **Refresh flags pending Steve action:** `CLAUDE.md.needs_refresh`, `claude-conventions.md.needs_refresh`, `claude-project-description.txt.needs_refresh`. Steve re-uploads when convenient. No CD action needed.

---

## Where the goods live (updated)

| What | Where |
|------|-------|
| Project root | `C:\Users\artroom\projects\flight-sim-project\flight-sim\` |
| **Authoritative outline** | `docs/specs/GNX375_Functional_Spec_V1_outline.md` (1,477 lines; archive — do NOT modify) |
| **Manifest (NEW)** | `docs/specs/GNX375_Functional_Spec_V1.md` (7-row fragment table; assembly instructions) |
| **Fragment A (NEW)** | `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` (545 lines; archived task at `docs/tasks/completed/c22_a_*.md`) |
| Decision log | `docs/decisions/D-NN-*.md` (D-01 through D-19) |
| **Latest decisions** | D-17 (Task flow plan as 4th status doc), D-18 (C2.2 format), D-19 (fragment expansion ratio) |
| Active issue tracker | `docs/todos/issue_index.md` (ITM-02, ITM-03, ITM-04, ITM-05, FE-01) |
| Resolved issues | `docs/todos/issue_index_resolved.md` (ITM-01, ITM-06, ITM-07) |
| Task flow plan (CD-maintained) | `docs/tasks/Task_flow_plan_with_current_status.md` |
| Spec tracker (CD-maintained) | `docs/specs/Spec_Tracker.md` |
| CC task prompts status (CD-maintained) | `docs/tasks/CC_Task_Prompts_Status.md` |
| Priority task list (CD-maintained) | `docs/todos/priority_task_list.md` |
| Harvest map | `docs/knowledge/355_to_375_outline_harvest_map.md` |
| Turn 20 research (display architecture) | `docs/knowledge/gnx375_ifr_navigation_role_research.md` |
| Turn 21 research (XPDR/ADS-B) | `docs/knowledge/gnx375_xpdr_adsb_research.md` |
| Implementation plan V2 | `docs/specs/GNX375_Prep_Implementation_Plan_V2.md` |
| Pivot rationale | `docs/specs/pivot_355_to_375_rationale.md` |
| AMAPI use-case index | `docs/knowledge/amapi_by_use_case.md` |
| AMAPI pattern catalog | `docs/knowledge/amapi_patterns.md` |
| AMAPI function reference (CC-generated) | `docs/reference/amapi/by_function/*.md` (~214 files) |
| Stream B readiness | `docs/knowledge/stream_b_readiness_review.md` |
| GNC 355 outline (SHELVED per D-12) | `docs/specs/GNC355_Functional_Spec_V1_outline.md` |
| PDF extraction (310 pages) | `assets/gnc355_pdf_extracted/text_by_page.json` |
| Page 125 supplement | `assets/gnc355_reference/land-data-symbols.png` |
| Conventions (full) | `claude-conventions.md` (project root) |
| CC safety | `cc_safety_discipline.md` (project root) |
| Memory mirror | `claude-memory-edits.md` |

---

## Recent decisions (D-12 through D-19)

- **D-12** Pivot from GNC 355 to GNX 375 as primary instrument (Turn ~14)
- **D-13** C2.2 format still deferred for 375 *(superseded by D-18)*
- **D-14** Procedural fidelity coverage additions (Turn 19 audit; items 11–25)
- **D-15** GNX 375 display architecture — internal vs. external instruments (Turn 20 research; **no internal VDI**)
- **D-16** GNX 375 XPDR + ADS-B scope corrections (Turn 21 research; TSO-C112e, 18-sec IDENT, 3 modes only, external altitude source)
- **D-17** Task_flow_plan as 4th CD-maintained status doc
- **D-18** C2.2 format decision — piecewise + manifest, 7-task partition, sequential delivery
- **D-19** Fragment prompt line-count targets — use ~1.35× outline expansion ratio (NEW this session)

---

## How CD operates in this project (carry-forward)

Same as the prior briefing — no changes. Quick reminders:

- **Hard CD/CC boundary.** CD designs/plans/coordinates; CC implements/tests/files. CD never executes code or runs tests; CD never deep-dives into multi-file code tracing — package as CC task.
- **D-04 commit policy.** Every commit has trailers (`Task-Id`, `Authored-By-Instance`, optional `Refs`/`Decision`/`Fixes`/`Supersedes`/`Co-Authored-By`). CD drafts; Steve executes; only Steve pushes.
- **D-09 commit mechanics.** `git commit -F <file>` (NOT multi-`-m`). Write message via `[System.IO.File]::WriteAllText` with `Join-Path $PWD ".git\COMMIT_EDITMSG_cd"` (NOT `Out-File` — adds BOM). Provide single one-line PowerShell command for Steve to execute.
- **D-05 "assess" shorthand.** `*_completion.md` → check completions; `*_compliance.md` → check compliance; `*_validation.md` → check validation; `*_review.md` → spec review triage.
- **Decision logging tripwire.** Prescriptive language ("X should Y", "the lesson is Y") or revision of prior conventions = log as D-{n} same turn. Memory slot #9.
- **Turn header.** Every CD response begins with `## Purple Turn N - YYYY-MM-DDTHH:MM:SS-04:00 ET` from system command. No bash_tool currently in this Purple session — substitute reasonable timestamp from session context if bash unavailable.
- **CC launch format.** Two code blocks (tab title + CC prompt), separately, with task-slug labels. See `claude-conventions.md` §CC Launch Format.
- **ntfy completion notification.** Every CC task ends with the ntfy POST. CC handles in own completion protocol.
- **Same-turn status doc updates per D-17.** When task status changes, update `Task_flow_plan_with_current_status.md` same turn.

---

## C2.2 fragment lifecycle (the cycle you'll repeat 6 more times)

For each of B, C, D, E, F, G:

1. **Draft prompt** at `docs/tasks/c22_{X}_prompt.md`. Use `docs/tasks/completed/c22_a_prompt.md` as the structural template. Adjust scope, line target (per D-19), hard constraints, and Coupling Summary backward/forward refs.
2. **Update Task flow plan:** mark drafting Done; mark execution READY TO LAUNCH.
3. **Provide CC launch sequence** (two code blocks).
4. **CC executes**, produces fragment + completion report, commits, ntfys.
5. **Check completions (Phase 1):** read prompt + completion report; cross-reference against fragment file; generate compliance prompt at `docs/tasks/c22_{X}_compliance_prompt.md`. Update Task flow plan.
6. **Provide CC launch sequence for compliance.**
7. **CC executes compliance**, produces report, commits, ntfys.
8. **Check compliance (Phase 2):** read compliance report; triage per D-07; archive 4 files to `docs/tasks/completed/`; **update manifest** (flip status to ✅ Archived); update Task flow plan; draft next prompt.

Per-fragment CD cost: ~3 turns. Per-fragment CC cost: ~1.5–2 hours wall-clock total.

---

## Open questions / future-Purple watchpoints

1. **B4 Gap 1 (Map rendering architecture)** is the biggest spec-body open question, surfacing in C2.2-B (§4.2 Map). Spec must document page structure and behavior contract — NOT the rendering technology choice (canvas vs. Map_add API vs. video streaming). That's a design-phase decision. The C2.2-B prompt must explicitly direct CC to defer.

2. **§7 procedural augmentations (7.A–7.M, ~50 lines net) in C2.2-D** — D-19 flagged C2.2-D at ~750 lines as right at the 700-line soft ceiling. Monitor during drafting; if the prompt itself grows beyond ~10K words including instructions, consider splitting §7's procedural-fidelity augmentations into a sub-task.

3. **§11 XPDR + ADS-B in C2.2-F** — the most-coupled task. §11 (14 sub-sections per D-16) + §12.9 XPDR Annunciations + §13.9 XPDR Advisories all in one fragment. Forward-refs to §14.1 (persistent state) and §15 (datarefs) in C2.2-G. Backward-refs to §4.9 (ADS-B In display consumers in Fragment C) and §7.9 (approach-phase XPDR in Fragment D). The Coupling Summary for C2.2-F will be the densest of the seven.

4. **Manifest assembly script** — `scripts/assemble_gnx375_spec.py` to be authored at C2.2-G archive (per D-18). Trivial script (~50 lines) — concatenates fragments, strips YAML + H1 headers + Coupling Summary blocks, validates section numbering. Don't write it before C2.2-G archives — the script's structure depends on the final fragment file shapes.

5. **Push policy unchanged.** Steve pushes manually after each significant commit batch. CD doesn't push. CC doesn't push.

6. **Refresh flags currently pending:** Steve will refresh Claude.ai project files when convenient. No CD action.

---

## Don't forget

- C2.2-A is the structural template for B–G; clone it, don't reinvent.
- D-19 line targets: B=720, C=575, D=750, E=455, F=540, G=300.
- §4.2 Map page B4 Gap 1 framing for C2.2-B prompt (explicit "do not resolve in spec body").
- Update manifest after every fragment archives.
- Update Task flow plan same turn as status changes (D-17).
- Log decisions same turn or compaction risk.
- End substantive turns with "→ Decision log: wrote D-{seq}" or "→ no decisions this turn".
- One-line PowerShell commits per D-09.
- ITM-07 is RESOLVED (in `issue_index_resolved.md`); don't re-raise.
- D-13 is SUPERSEDED by D-18; reference D-18 for format authority.
