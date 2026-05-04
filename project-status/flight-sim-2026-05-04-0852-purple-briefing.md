# Flight-Sim Briefing for New Purple Session — 2026-05-04T08:52 ET

**Purpose:** Continuity package for the next CD Purple session, per Steve's Turn 32 request. The current session (Purple Turns 11–32, 2026-05-02 + 2026-05-04) cleared the entire DEPENDENCY-AUDIT-01 lifecycle and the ITM-11/D-30/cleanup chapter. Next session should kick off **pre-C3 P1 work** per the recommendation at end of Turn 31.

---

## Where the project stands

**Stream C status:** All 7 V1 fragments archived. Assembly script + aggregate (`docs/specs/GNX375_Functional_Spec_V1_aggregate.md`, ~4430 lines) done at C2.2-ASSEMBLE (2026-04-30). Page number map (`assets/gnx375_pymupdf_v1_0_1/page_number_map.json` schema v2.0; 310 / 306 parsed / 4 unparseable) done by GNX375-PAGEMAP-PYMUPDF-01 (2026-05-02).

**Cleanup chapter complete (this session, 2026-05-02 + 2026-05-04):**
- ITM-11 closed by D-30 (V1 citations cite physical PDF pages, zero offset to extraction)
- ITM-13 closed by D-29 (commit policy simplification supersedes D-04)
- D-30, D-31, D-32 logged
- DEPENDENCY-AUDIT-01: full lifecycle, archived PASS WITH NOTES (304 references catalogued; Side Findings #1–#5)
- AUDIT-CLEANUP-01: full lifecycle, archived PASS WITH NOTES (11 task moves + 16 script moves + Side Finding #4 fix + land-data-symbols.png deletion + aggregate regenerated)
- AUDIT-PATCH-01: CD-direct sweep (10 surgical edits across 10 files; no formal task lifecycle); committed Turn 31
- `assets/retired/` move-out: pending Steve's execution of the Turn 32 commands; will move `gnc355_pdf_extracted/` and `gnc355_reference/` to `C:\Users\artroom\projects\flight-sim-project\archive\` (non-tracked sibling)

---

## Decisions logged this session

| ID | Title | Where |
|---|---|---|
| D-30 | V1 fragment citations use absolute physical PDF page numbers | `docs/decisions/D-30-v1-fragment-citations-use-physical-pdf-page-numbers.md` |
| D-31 | Drop backup step from check_updates (git history is the canonical safety net) | `docs/decisions/D-31-drop-backup-step-from-check-updates.md` |
| D-32 | Compliance prompts recounting post-commit grep audits must pin to audit commit + exclude audit outputs | `docs/decisions/D-32-compliance-prompts-pin-to-audit-commit-and-exclude-audit-outputs.md` |

D-29 was logged before this session (2026-05-02 by Yellow per memory) but its supersession of D-04 became effective during this session.

---

## ITMs

**Closed this session:**
- ITM-11 (page-number offset; misdiagnosed) — closed by D-30 verification, 13/13 V1 citations
- ITM-13 (BOM in commit subject) — closed by D-29 (file-based commit pattern dropped)

**Open (low severity):**
- ITM-02, ITM-03 (AMAPI patterns matrix + link cleanup) — `_crp_work/` scratch; batch when prioritized
- ITM-04, ITM-05 (CC task prompt template + Compliance Verification Guide minor template updates)
- ITM-08 (Fragment C Coupling Summary glossary over-claim — residual; discipline has prevented recurrence in D/E/F/G)
- ITM-10 (Fragment C §4.10 vs PDF p. 94 watchpoint) — carry to C3 review
- ITM-14 (`assemble_gnx375_spec.py` `--partial` continuity-skip not implemented) — defer until partial-assembly workflow is needed
- FE-01 (AMAPI parser link preservation) — defer

---

## Active vs retired path map

**Active (current sources of truth):**
- `assets/gnx375_llama_extract/` — LlamaParse markdown body extraction (310 pages); per-page files at `pages/page_NNN.md`; full extraction at `full_markdown.md`
- `assets/gnx375_pymupdf_v1_0_1/` — PyMuPDF metadata extraction; `page_number_map.json` (schema v2.0); `page_metadata.json`; `page_overrides.json` (D-28 PAP 22 entry on page 2)
- `assets/Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf` — primary PDF (310 physical pages)
- `assets/Supplemental Airplane Flight Manual - Garmin GPS 175, GNC 355, or GNX 375 GPS-COM-XPDR Navigation System - 190-02207-a3_03.pdf` — supplemental AFM (50 pages); deferred V2 amendment work

**Retired (and post-move-out, archived externally):**
- `assets/retired/gnc355_pdf_extracted/` → `C:\Users\artroom\projects\flight-sim-project\archive\gnc355_pdf_extracted\` (after move-out)
- `assets/retired/gnc355_reference/` → `C:\Users\artroom\projects\flight-sim-project\archive\gnc355_reference\` (after move-out)

---

## Next session — Pre-C3 P1 work

Three items per `docs/todos/priority_task_list.md` P1, all gated as prerequisites to C3 spec review:

### 1. `scripts/verify_gnx375_manifest.py` authoring (per D-22 §6)

**What:** A pre-flight verification script for the V1 manifest. Per D-22, before C3 review launches, this script verifies:
- All 7 fragment files exist at expected paths
- Per-fragment line counts match manifest expectations (or are within tolerance)
- Section headers are continuous (no gaps in numbering across fragment boundaries)
- No duplicate sections across fragments
- Coupling Summary forward-refs resolve (referenced fragments exist; cross-section refs point to authored content)

**Where:** Most likely `scripts/verify_gnx375_manifest.py`. Manifest is `docs/specs/GNX375_Functional_Spec_V1.md` (note: `.md`, not `.json` — confirmed during AUDIT-CLEANUP-01).

**Authoring approach:** CD-authored CC task prompt → CC executes → check completions + compliance lifecycle. Reference D-22 §6 for the contract; reference `scripts/assemble_gnx375_spec.py` for the existing manifest-parsing patterns (the assembly script reads the manifest already; verify_manifest can reuse that parser).

**Estimated scope:** Medium. Probably ~250–400 lines of Python with structured error reporting. Several gating checks; needs to fail loud and detailed for C3 readiness.

### 2. Review Priority Guide prepend to aggregate (per D-22 §5)

**What:** A P1/P2/P3 prioritization table prepended to the aggregate spec, instructing C3 reviewers which sections warrant the most scrutiny.

**Per D-22 §5:**
- **P1:** §§11 (XPDR + ADS-B), 15 (External I/O), 4.9 (Hazard Awareness), 7 (Procedures)
- **P2:** §§5–6 (FPL editing, Direct-to), 8–10 (Nearest, Waypoints, Settings), 14 (Persistent State), 12 (Audio/Alerts), 13 (Messages)
- **P3:** §§1–4 (Overview, Physical, Power-On, Display Pages), Appendices A/B/C

**Where:** Prepended to `docs/specs/GNX375_Functional_Spec_V1_aggregate.md`. Decision needed: is this a CD-direct edit to the aggregate, or does the assembly script gain a `--review-priority-guide` flag that bakes the table in at assembly time? D-22 didn't specify mechanically; either works. CD-direct is faster; assembly-script-baked is more reproducible.

**Estimated scope:** Small. ~30–50 lines of markdown table + framing prose.

### 3. Three domain-specific Sonnet agents (per D-22 §2)

**What:** Three custom spec-review agents at `.claude/agents/`, each ~60 lines (Sonnet model):
- `spec-pdf-source-fidelity-reviewer.md` — verifies that V1 spec claims trace to PDF source content; flags unsupported assertions and unresolvable citations. Should consume `assets/gnx375_pymupdf_v1_0_1/page_number_map.json` for citation resolution and `assets/gnx375_llama_extract/pages/page_NNN.md` for content verification.
- `spec-cross-fragment-coupling-reviewer.md` — verifies that cross-fragment references (e.g., Fragment B §4.1 referencing §11) resolve to authored content; flags broken or ambiguous coupling. Should be informed by D-18 (Coupling Summary stripped on assembly) so it doesn't get confused by the absence of Coupling Summary blocks in the aggregate.
- `spec-sibling-unit-consistency-reviewer.md` — verifies that GPS 175 / GNC 355 / GNX 375 sibling-unit framing is consistent across fragments (e.g., what's marked "GNX 375 only" vs "GPS 175 + GNX 375 only"). Per D-22, scoped to GNX 375 V1 only; not a standing convention.

**Where:** `.claude/agents/spec-*-reviewer.md`. The directory exists with default agents; new agent files added there are picked up by `/spec-review` when invoked with `--with <agent-slug>`.

**Reference templates:** Look at existing agents in `.claude/agents/` for the format and metadata structure. Per D-22, these three are added to the customized agent roster (with the 7 `--without` defaults already specified there).

**Estimated scope:** Medium. ~60 lines × 3 = ~180 lines of agent prompt content. Authoring discipline matters more than line count — each agent's review focus must be sharply scoped.

### Recommended order

1. **Review Priority Guide first** (smallest; gives reviewers immediate context for the rest of the spec; can be CD-direct or a small CC edit)
2. **`verify_gnx375_manifest.py` second** (medium scope; CC task; archives independent of agents)
3. **Three Sonnet agents third** (largest; each is its own draft + review cycle, but they're parallelizable in different CC sessions if Steve wants)

After all three P1 items land, **C3 spec review V1 (quick tier)** is unblocked.

### What's NOT next session's job

- C3 spec review itself — gated on P1 items above
- Post-V1 Supplemental AFM amendment (V2 track) — separate work, deferred until V1 is implementation-ready
- GNC 355 workstream — deferred per D-12 until GNX 375 completes
- Design phase (D1/D2) — gated on C4 implementation-ready V1
- Implementation phase (I1/I2/I3) — gated on Design phase

---

## Workflow conventions reminder

**For new session:** all D-29 / D-30 / D-31 / D-32 conventions are now active. Specifically:

- **D-29 commits:** `git commit -m "TASK-ID: subject [AI commit]" -m "body" -m "Refs: D-XX"`. Plain. No Task-Id/Authored-By trailers, no Co-Authored-By. CC and CD both commit; only Steve pushes.
- **D-30 V1 citations:** `[p. N]` in V1 fragments resolves directly to physical PDF page; zero offset to `gnx375_llama_extract/pages/page_NNN.md`. Garmin section-prefixed citations like `[printed p. 2-42]` use `page_number_map.json` for resolution.
- **D-31 check_updates:** four steps, no backup step.
- **D-32 compliance recounts:** if ever doing a grep-based compliance check that recounts an audit, pin to the audit's commit ref and exclude the audit's own output files.
- **`assess` shorthand:** triggers protocol matching the filename (`*_completion.md` → check completions; `*_compliance.md` → check compliance; `*_validation.md` → check validation; `*_review.md` → spec review triage). Literal trigger phrase without filename → process ALL unprocessed files of that type.

**ntfy channel:** `1668651d-48ae-4104-b09e-f742b559e205` (CC sends post-commit notifications; CD-emit-Steve-runs blocks omit ntfy).

**CC launch:** `$env:CLAUDE_CODE_DISABLE_TERMINAL_TITLE = "1"; $host.UI.RawUI.WindowTitle = "{label}"; claude --dangerously-skip-permissions --model opusplan`

---

## Session continuity notes

- **Current date when briefing written:** 2026-05-04T08:52 ET. There was a date jump from 2026-05-02 to 2026-05-04 mid-session (Turn 26→27) when CC ran AUDIT-CLEANUP-01 offline.
- **Memory state:** `claude-memory-edits.md` slots 23/24 carry the D-29 commit policy. D-30/D-31/D-32 may not be in memory yet — verify in next session and add if missing. The userMemories block in this conversation's system prompt is from before this session and lists ITM-10/ITM-11/ITM-12 as open; ITM-11 is closed (D-30); ITM-13 should appear in slots; "D-25 patch (CD verification and context-trace convention): needs to be applied on the Windows machine" is stale (D-26 has been on disk since 2026-04-30).
- **No CC tasks running:** all CC work archived. Next session can start cold with no CC ambient state.
