# Issue Index — Open

**Created:** 2026-04-20T09:10:00-04:00
**Source:** Purple Turn 37 — first issue logged triggered creation of this index
**Purpose:** Master cross-reference of all open tracked items (ITM-, G-, O-, FE-). Paired with `issue_index_resolved.md` which holds closed items.
**Maintained by:** CD

**Prefix glossary:**
- **ITM-** — Item (general housekeeping, cleanup, process followup; default catchall)
- **G-** — Gap (spec review finding: missing requirement, unaddressed scenario, etc.)
- **O-** — Opportunity (spec review finding: improvement that's nice-to-have, not required)
- **FE-** — Future Enhancement (deferred work item; not blocking; revisit when prioritized)

| ID | Severity | Type | Title | Source | Notes |
|----|----------|------|-------|--------|-------|
| ITM-02 | Low | Cleanup / docs | AMAPI patterns: add Tier 2 columns to function_usage_matrix | Purple Turn 3 (B3 compliance) | Phase C step 3 of AMAPI-PATTERNS-01 was missed. Matrix is `_crp_work/` scratch — discharge per D-07. See details below. |
| ITM-03 | Low | Cleanup / docs | AMAPI patterns: convert plain-text `hw_dial_add` to markdown links in Patterns 20/21 | Purple Turn 3 (B3 compliance) | Completion report claimed `Hw_dial_add.md` was missing; file actually exists. See details below. |
| ITM-04 | Low | Process / template | CC task prompt template: add "verify completion-report claims" step | Purple Turn 3 (D-08) | Per D-08, completion reports must re-verify numerical/existence claims at submission time. Update `docs/templates/CC_Task_Prompt_Template.md`. See details below. |
| ITM-05 | Low | Process / template | Compliance Verification Guide: reference D-10 skip criteria | Purple Turn 8 (D-10) | Per D-10, mechanical/self-verifying tasks may skip compliance. Update `docs/templates/Compliance_Verification_Guide.md` to reference D-10. See details below. |
| FE-01 | Low | Future enhancement | AMAPI parser: preserve `<a>` links inside Arguments-table cells | Purple Turn 52 | Parser currently strips `<a>` in argument description cells (~20-30 cells across corpus). Fix: same markdown-link preservation logic already used for Description text. See details below. |
| ITM-08 | Low | Cleanup / docs | Fragment C Coupling Summary — over-claims 4 glossary terms absent from Fragment A Appendix B | Purple Turn 14 (C2.2-C compliance X17) | Coupling Summary lists TSO-C151c, EPU, HFOM/VFOM, HDOP as Appendix B backward-refs; these terms are not in Appendix B. Coupling Summary is coordination metadata (stripped on assembly per D-18); zero downstream impact. Tracking to detect recurrence. Fragment D's authoring-phase grep-verify prevented recurrence (confirmed Purple Turn 22 C2.2-D compliance F11 PASS). See details below. |
| ITM-10 | Low | Cleanup / docs | Fragment C §4.10 Unit Selections vs. PDF p. 94 discrepancy — watchpoint | Purple Turn 3 post-session-reset, 2026-04-23 (C2.2-E compliance S6 + N2) | Fragment C §4.10 lists 7 unit-selection types (distance/speed, altitude, VSI, nav angle, wind, pressure, temperature); omits Fuel and Magnetic Variation (present on PDF p. 94). Pre-existing condition in archived Fragment C, not a Fragment E issue. Low severity; carry as watchpoint for any future Fragment C review or for the C3 full-spec `/spec-review` pass. See details below. |
| ITM-13 | Low | Process / convention | CC commit subject contains UTF-8 BOM (U+FEFF) — `claude-conventions.md` BOM-free pattern not followed | Purple Turn 12, 2026-04-30 (C2.2-ASSEMBLE-COMPLIANCE P1 FAIL) | CC's commit `7ae84a9` for C2.2-ASSEMBLE has `0xEF 0xBB 0xBF` prefixed to the subject line. All required trailers present and correct; only the BOM is the deviation. Convention specified at `claude-conventions.md` §Git Commit Trailers §CD commit execution mechanics requires `[System.IO.File]::WriteAllText` (BOM-free) rather than `Out-File -Encoding utf8` (BOM-emitting). CC needs to internalize the BOM-free pattern for future commits. See details below. |
| ITM-14 | Low | Feature gap | `assemble_gnx375_spec.py` `--partial` mode does not skip section-numbering continuity for missing-fragment ranges | Purple Turn 12, 2026-04-30 (C2.2-ASSEMBLE-COMPLIANCE S7 PARTIAL) | The C2.2-ASSEMBLE prompt specified three behaviors for `--partial`: (a) placeholder block insertion, (b) skip continuity check for missing-fragment section ranges, (c) warning print + non-failing exit. CC implemented (a) and (c); (b) was missed. Practical impact: zero today (all 7 fragments archived); only matters for hypothetical mid-authoring partial assemblies. Fix is ~20 lines: derive a missing-fragment coverage map and exclude those sections from `verify_section_numbering`. Defer until partial-assembly workflow is actually needed. See details below. |

## ITM-02: AMAPI patterns — add Tier 2 columns to function_usage_matrix

**Created:** 2026-04-20T18:41:01-04:00
**Source:** Purple Turn 3 — AMAPI-PATTERNS-01 compliance check, finding V3
**Status:** Open
**Severity:** Low (cleanup; affects scratch artifact only)
**Owner:** CC when batched (CD drafts the task prompt)

### Description

AMAPI-PATTERNS-01 Phase C step 3 explicitly required: "Update the function-usage matrix to include Tier 2 columns." CC executed Phase C's pattern-confirmation work but did not update the matrix. Current state at `_crp_work/amapi_patterns_01/function_usage_matrix.md` has 6 columns (Tier 1 only). Expected: 14 columns (6 T1 + 8 T2).

### Discharge rationale

Per D-07, the matrix is a `_crp_work/` scratch artifact, not a published deliverable. The pattern catalog (the actual deliverable) correctly cites Tier 2 sample counts and exemplars — Phase C's analysis succeeded; only the matrix update was skipped. Tracking as ITM rather than blocking on bug-fix task.

### Fix

A small CC task: re-run a function-call grep across the 8 Tier 2 logic.lua files, append 8 new columns to the matrix table. Estimated 10–15 min CC work. Could be batched with ITM-03.

### Related

- AMAPI-PATTERNS-01 compliance report (`docs/tasks/completed/amapi_patterns_compliance.md` §V3)
- D-07 (compliance triage rubric for `_crp_work/` failures)

---

## ITM-03: AMAPI patterns — convert plain-text `hw_dial_add` to markdown links in Patterns 20 and 21

**Created:** 2026-04-20T18:41:01-04:00
**Source:** Purple Turn 3 — AMAPI-PATTERNS-01 compliance check, finding VIII1/VIII2
**Status:** Open
**Severity:** Low (cosmetic; affects 2 link references)
**Owner:** CC when batched (CD drafts the task prompt)

### Description

Pattern 20 and Pattern 21 in `docs/knowledge/amapi_patterns.md` reference `hw_dial_add` as plain-text backticks rather than markdown links to `../reference/amapi/by_function/Hw_dial_add.md`. CC chose this defensive form because the completion report (incorrectly) believed the reference file was missing. Compliance check confirmed `Hw_dial_add.md` exists (2007 bytes, present before AMAPI-PATTERNS-01 ran).

### Fix

In `docs/knowledge/amapi_patterns.md`:

- Pattern 20 "Functions used" entry (~line 623): `` `hw_dial_add` — registers a hardware rotary encoder binding (see Pattern 21)`` → `` [hw_dial_add](../reference/amapi/by_function/Hw_dial_add.md) — registers a hardware rotary encoder binding (see Pattern 21)``
- Pattern 21 "Functions used" entry (~line 663): `` `hw_dial_add` — binds a named hardware encoder to a callback; args: name, detent type, step, callback`` → `` [hw_dial_add](../reference/amapi/by_function/Hw_dial_add.md) — binds a named hardware encoder to a callback; args: name, detent type, step, callback``

Estimated 5 min CC work. Naturally batched with ITM-02.

### Related

- AMAPI-PATTERNS-01 compliance report (`docs/tasks/completed/amapi_patterns_compliance.md` §VIII)
- D-08 (completion report verification — root cause for the false-positive gap claim)

---

## ITM-04: CC task prompt template — add "verify completion-report claims" step

**Created:** 2026-04-20T18:41:01-04:00
**Source:** Purple Turn 3 — D-08 implementation followup
**Status:** Open
**Severity:** Low (process / template change; benefits all future tasks)
**Owner:** CD (template is CD-maintained; small enough to do inline rather than CC task)

### Description

Per D-08, CC completion reports must verify numerical and existence claims against current file state before submission rather than relying on in-progress estimates from earlier phases. The CC task prompt template at `docs/templates/CC_Task_Prompt_Template.md` should be updated to include this requirement explicitly in its Completion Protocol section.

### Fix

Add to `docs/templates/CC_Task_Prompt_Template.md` Completion Protocol section, before "Write completion report":

> **Verify report claims against actual state.** Before writing the completion report, re-derive every numerical and existence claim from a fresh grep / ls / wc command. Quote the commands and their output inline in the report. Do NOT carry numerical estimates from intermediate phase markers (`_phase_X_complete.md`) verbatim — those are often estimated mid-flight and drift from final state.

Also strengthen the "Deviations from prompt" section instructions: cross-check the report body against every numbered step in the prompt's Completion Protocol section. If any step lacks an inline confirmation, list it as a deviation OR add the inline confirmation.

### Related

- D-08 (completion report claim verification — the decision this implements)
- AMAPI-PATTERNS-01 completion report (the case study showing why this is needed)

---

## ITM-05: Compliance Verification Guide — reference D-10 skip criteria

**Created:** 2026-04-21T06:41:13-04:00
**Source:** Purple Turn 8 — D-10 implementation followup
**Status:** Open
**Severity:** Low (process / template change)
**Owner:** CD (template is CD-maintained; small enough to do inline rather than CC task)

### Description

Per D-10, CD may skip the formal compliance step for CC tasks meeting all five criteria (mechanical, self-verifying, fully reversible, completion report meets D-08, no code or content changes to other deliverables). The Compliance Verification Guide at `docs/templates/Compliance_Verification_Guide.md` should be updated to reference D-10 in its "When to Use" section so future CD sessions discover the skip-criteria when reading the guide.

### Fix

Add to `docs/templates/Compliance_Verification_Guide.md` "When to Use" section, after the existing "After every 'check completions' review" line:

> **Exception:** Per D-10, CD may skip the formal compliance step for tasks meeting the mechanical/self-verifying criteria. See `docs/decisions/D-10-skip-compliance-for-mechanical-self-verifying-tasks.md` for the five required criteria and the lightweight CD-side checks that replace formal compliance for skip-eligible tasks.

### Related

- D-10 (skip-compliance criteria — the decision this implements)
- ITM-04 (companion: same kind of template-update followup, for CC task prompt template per D-08)

---

## FE-01: AMAPI parser — preserve `<a>` links inside Arguments-table cells

**Created:** 2026-04-20T09:50:02-04:00
**Source:** Purple Turn 52 — post-AMAPI-PARSER-01 diagnostic surfaced the gap
**Status:** Open (future enhancement; not blocking)
**Severity:** Low
**Owner:** CC when prioritized (CD drafts the task prompt)

### Description

AMAPI-PARSER-01 correctly extracts inline wiki-internal links from the Description section (preserving them as `[display_text](page_name)` markdown syntax). However, the SAME links appearing inside `<table class="wikitable">` argument-description cells are stripped to plain text.

Examples from the current corpus:
- `Fi_gauge_add`: argument #2 description says "Gauge type. See Flight Illusion Gauges for available gauges." — source HTML has `<a href="/index.php?title=Flight_Illusion_Gauges">Flight Illusion Gauges</a>` wrapping "Flight Illusion Gauges".
- `Xpl_dataref_subscribe`: argument #1 description says "Reference to a dataref from X-Plane (see X-Plane DataRefs)" — source HTML has `<a href="https://developer.x-plane.com/datarefs/">X-Plane DataRefs</a>`.

### Impact

- 20–30 argument cells across the 214-function corpus lose their hyperlinks in the rendered markdown output
- Cosmetic degradation; reference docs are still functional for spec authoring (primary info — function name, signature, args, examples — is all captured)
- `cross_references` JSON field under-counts real cross-references because it doesn't pick up links hidden in argument cells

### Fix sketch

In `scripts/amapi_parser_lib/function_page_parser.py`, the argument-description cell extraction currently does something equivalent to `cell.get_text()`. Instead, it should use the same link-preserving transform the Description section uses — iterating the cell's children, converting `<a>` elements to `[text](href-as-page-name)`, preserving other inline formatting.

### Decision to defer

Deferred because (a) impact is cosmetic only, (b) downstream consumers (GNC 355 spec authoring, B3 pattern analysis) don't depend on argument-cell links, (c) a fix would require re-running the full parser and regenerating all 214 markdown files. Revisit if we do a parser V2 or if spec-authoring actually needs these links.

### Related

- AMAPI-PARSER-01 task and completion
- Turn-52 diagnostic: `scripts/diagnostic_parser_xref_check.py` (shows cross-reference coverage stats)

---

## ITM-07: GNX 375 outline — §4 length estimates inconsistent

**Resolved 2026-04-21T13:30:00-04:00 by D-18 — moved to `issue_index_resolved.md`.**

---

## ITM-08: Fragment C Coupling Summary — over-claims 4 glossary terms absent from Fragment A Appendix B

**Created:** 2026-04-22T20:32:25-04:00
**Source:** Purple Turn 14 (C2.2-C compliance, finding X17 PARTIAL)
**Status:** Open (observational; no fix required now). **Discipline validated at C2.2-D:** Fragment D's authoring-phase grep-verify prevented recurrence (C2.2-D compliance F11 PASS — 25/25 terms verified present; 4 excluded terms correctly omitted).
**Severity:** Low (coordination metadata only; stripped on assembly)
**Owner:** CD (observation-level tracking)

### Description

Fragment C's Coupling Summary "Backward cross-references" section lists TSO-C151c, EPU, HFOM/VFOM, and HDOP as glossary entries in Fragment A's Appendix B. Compliance check X17 grep-confirmed that none of these four terms appear in Fragment A Appendix B.

These terms appear in Fragment C spec body as:
- **EPU, HFOM/VFOM, HDOP:** display field labels in §4.10 GPS Status page (line 619). They are GPS accuracy/integrity measurement abbreviations that are self-explanatory in the context of a "GPS Status" page field listing.
- **TSO-C151c:** terrain database certification reference cited in §4.9 Terrain (line 500: "Not all-inclusive; not TSO-C151c certified. For situational awareness only...").

### Impact

**Zero functional impact on the assembled spec.** Per D-18, the Coupling Summary block is coordination metadata and is stripped during assembly. The assembled spec contains only spec-body content, which uses these terms accurately in context.

### Watchpoint status (updated 2026-04-23, Purple Turn 22)

The C2.2-D prompt added a Phase G "grep-verify against Fragment A Appendix B" step as a hard constraint. Fragment D's completion report documented 25 verified-present terms and 4 excluded terms (EPU, HFOM/VFOM, HDOP, TSO-C151c) — the exact pattern. C2.2-D compliance F11 independently re-grep'd Fragment A Appendix B and confirmed all 25 terms present, with the 4 excluded terms correctly absent from the backward-refs list. **The authoring-phase grep-verify discipline is validated.**

Carry-forward recommendation for C2.2-E, F, G prompts: continue the Phase G grep-verify hard constraint.

### No fix required

No edit to Fragment C. The fragment is archivable as-is. ITM-08 remains open as an observational tracker in case the pattern recurs despite the discipline.

### Related

- C2.2-C compliance report (`docs/tasks/completed/c22_c_compliance.md` §X17)
- C2.2-D compliance report (`docs/tasks/c22_d_compliance.md` §F11) — validates discipline
- D-18 (Coupling Summary stripped-on-assembly convention)
- D-21 (multi-fragment sequential drafting)


---

## ITM-10: Fragment C §4.10 Unit Selections vs. PDF p. 94 discrepancy — watchpoint

**Created:** 2026-04-23T15:25:07-04:00
**Source:** Purple Turn 3 post-session-reset (C2.2-E compliance S6 + N2)
**Status:** Open (observational; no fix required). Low-severity watchpoint carried to C3 full-spec `/spec-review` or any future Fragment C revision.
**Severity:** Low (pre-existing condition in archived Fragment C; does not block Fragment F/G)
**Owner:** CD (observation-level tracking)

### Description

Fragment C §4.10 Settings/System display pages authors a 7-type list of quantities for Unit Selections:

> distance, speed, altitude, VSI, nav angle, wind, pressure, temperature

PDF p. 94 (the Unit Selections display page in the GNC 355 Pilot's Guide) shows a partially different list of categories:

- Distance/Speed (Nautical Miles, Statute Miles)
- Fuel (Gallons, Imperial Gallons, Kilograms, Liters, Pounds)
- Temperature (Celsius, Fahrenheit)
- NAV Angle (Magnetic, True, User)
- Magnetic Variation (sub-option available only when NAV Angle = User)

**Deltas:**
- PDF has **Fuel** as an explicit category — Fragment C omits
- PDF has **Magnetic Variation** as a distinct entry (as User-NAV-Angle sub-option) — Fragment C omits
- Fragment C has **Altitude, VSI, Wind, Pressure** — PDF p. 94 does not show these on the page snapshot

Fragment E §10.6 Unit Selections was authored to match Fragment C §4.10 (7 types, same list + KM/KPH expansion in Distance/Speed). Per C2.2-E compliance S6 decision rule — Fragment E matches Fragment C → PASS — the governing comparison. The Fragment C §4.10 vs. PDF p. 94 divergence is a **pre-existing condition in archived Fragment C**, not a Fragment E failure.

### Likely explanation

PDF p. 94 appears to be a single-page snapshot showing a partial subset of the Unit Selections settings page. Real Garmin GPS navigators have unit selections for Altitude, VSI, Wind, and Pressure — these are almost certainly present in the full PDF coverage (possibly on adjacent pages, in a settings overview table, or in the Appendix). The PDF extraction's page-by-page structure may have bounded the p. 94 content more narrowly than the authoritative settings inventory.

Fragment C §4.10 likely pulled from a broader settings inventory or from the outline's composite enumeration, which was informed by the PDF's more comprehensive coverage.

### Impact

**Zero functional impact on current spec correctness.** Fragment C and Fragment E are consistent with each other. The spec's Unit Selections inventory is more complete than PDF p. 94's partial snapshot. No downstream fragment depends on the omitted Fuel or Magnetic Variation categories.

### No fix required at Fragment E stage

The C2.2-E compliance S6 decision rule correctly ruled that consistency with the established spec (Fragment C) governs over re-litigating a PDF partial-page snapshot. ITM-10 is logged as an observational watchpoint.

### Potential future actions (do not execute now)

At C3 full-spec `/spec-review` (or any future Fragment C revision), the reviewer may choose to:
- Verify whether Fuel and Magnetic Variation should be added to Fragment C §4.10 (requires reading more PDF pages than p. 94)
- Verify whether the Fragment C list (Altitude, VSI, Wind, Pressure) is supported by other PDF pages or is spec-authored beyond the PDF
- Decide whether to update Fragment C's §4.10 inventory, update Fragment E's §10.6 sub-section to match, and re-archive both fragments

None of this is blocking for Fragment F or Fragment G drafting.

### Related

- C2.2-E compliance report (`docs/tasks/completed/c22_e_compliance.md` §S6 + §N2)
- Fragment C §4.10 (`docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` line 568)
- Fragment E §10.6 (`docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md` lines 488–511)
- D-18 (Coupling Summary stripped-on-assembly convention — not directly relevant but contextual)
- PDF source at `assets/gnc355_pdf_extracted/text_by_page.json` page 94 entry

---

## ITM-11: Page-number offset between new LlamaParse extraction and archived fragment citations

**Opened:** 2026-04-24T10:41:03-04:00 (Purple Turn 19)
**Severity:** Low (watchpoint for C3 review tooling)
**Status:** Open
**Related:** D-22 §(1) (source-of-truth policy); PDF re-extraction completion report (`docs/tasks/pdf_reextraction_llamaparse_completion.md`)

### Summary

The new LlamaParse extraction at `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages/page_NNN.md` uses **physical PDF page numbering** (cover = page 1). The original `text_by_page.json` extraction and all archived fragment citations use **Garmin logical page numbering** (1-based from body; cover and front matter have non-numeric markers like "A", "i", etc., then body starts at p. 1).

Concrete observed offsets:

| Content | Garmin logical page | New extraction physical page | Offset |
|---------|---------------------|------------------------------|--------|
| XPDR Modes (§11.4 source) | p. 78 | `page_080.md` | +2 |
| VFR Key + IDENT (§11.6 source) | p. 80 | `page_082.md` | +2 |
| Unit Selections (§4.10 source) | p. 94 | `page_098.md` | +4 |
| Land Data Symbols (§4.X source) | p. 125 | `page_129.md` | +4 |

Offset varies by section because Garmin's logical page numbering resets at section boundaries (e.g., "Section 2 Get Started" starts at its own page 1 — rendered as "2-1" in footers). The new extraction uses monotonic physical page numbering throughout.

### Impact

- C3 spec review agents (spec-pdf-source-fidelity-reviewer in particular) must resolve citations like `[p. 78]` in archived fragments to the corresponding physical page in the new extraction. A naive match would fail.
- Post-archive authoring work (C2.2-G, Design Spec D1/D2, future revisions) should cite the new extraction by physical page number in prose **or** by Garmin logical page number with explicit prefix (e.g., `[p. 2-42]` or `[p. 78 logical]`), and the chosen convention should be consistent within a given document.

### Required follow-up (at or before C3 launches)

Write `scripts/build_page_number_map.py` or similar that:
1. Reads each `page_NNN.md` in the new extraction
2. Parses the Garmin logical page footer (e.g., "2-42 Pilot's Guide 190-02488-01 Rev. C") to extract section-qualified logical page
3. Builds a bidirectional mapping: physical ↔ logical
4. Writes `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json`

The `spec-pdf-source-fidelity-reviewer` agent (D-22 §(2) item 1) should consume this map when verifying citations.

### Non-required but useful follow-up

Consider whether post-archive authoring should switch to citing physical-page numbers, Garmin logical-page numbers, or both. The tradeoffs are:
- **Physical page:** maps 1:1 to the new extraction file structure; easy for automated verification.
- **Garmin logical page:** matches what a pilot reading the actual Pilot's Guide would see; matches all archived fragment citations for consistency.
- **Both:** most informative but verbose.

Recommendation: continue citing Garmin logical pages in prose (consistency with archived fragments), but require the page-number map in agent tooling.

### Related

- D-22 §(1) source-of-truth policy
- `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/` (new extraction)
- `assets/gnc355_pdf_extracted/text_by_page.json` (original extraction with logical page numbering)
- ITM-10 (Fragment C §4.10 vs. PDF p. 94 — the new extraction provides cleaner evidence that may partially resolve ITM-10 at C3 review time)

---

## ITM-13: CC commit subject contains UTF-8 BOM — BOM-free pattern not followed

**Opened:** 2026-04-30T09:53:25-04:00 (Purple Turn 14 — carrying forward C2.2-ASSEMBLE-COMPLIANCE P1 finding from Turn 12)
**Severity:** Low (process/convention; cosmetic git history defect)
**Status:** Open
**Related:** `claude-conventions.md` §Git Commit Trailers §CD commit execution mechanics; D-04; commit `7ae84a9`; `docs/tasks/completed/c22_assemble_gnx375_compliance.md` §P1

### Summary

CC's commit `7ae84a9` for C2.2-ASSEMBLE has the three-byte UTF-8 BOM (`0xEF 0xBB 0xBF`, U+FEFF) prefixed to the subject line. The compliance check P1 detected this via `git log -1 --format="%s" | xxd`. All required commit trailers (Task-Id, Authored-By-Instance, Refs, Co-Authored-By) are present and correctly formatted; only the BOM is the deviation.

### Root cause

PowerShell 5.x's `Out-File -Encoding utf8` writes UTF-8 **with** BOM by default. When CC writes a commit message file via this path and runs `git commit -F <file>`, git takes the leading three bytes as part of the commit subject. The convention at `claude-conventions.md` §Git Commit Trailers §CD commit execution mechanics specifies the BOM-free pattern:

```powershell
[System.IO.File]::WriteAllText(".git\COMMIT_EDITMSG_cd", $msg)
```

`[System.IO.File]::WriteAllText` writes UTF-8 without BOM by default — this is the canonical pattern. CC apparently used a BOM-emitting writer instead.

### Practical impact

Minimal. The BOM is invisible in `git log --oneline` and most everyday git tooling. It surfaces in `git log --format=fuller` viewer output and in any tool that does byte-level subject matching (e.g., regex matching against subject line for automation). Functionally git accepts the commit and applies it normally.

### Resolution path

**Option 1 — leave the commit as-is, fix going forward (RECOMMENDED).** The existing commit is already pushed-eligible; rewriting history with `git commit --amend` to strip the BOM has its own cost (force-push, history mismatch with already-fetched copies). Going forward, CC must use `[System.IO.File]::WriteAllText` per the documented pattern. Track via this ITM until the next CC commit demonstrates compliance.

**Option 2 — amend.** `git commit --amend -F .git\COMMIT_EDITMSG_clean` with a BOM-free file would replace the subject. Force-push required. Disproportionate for an invisible-character fix.

### Required follow-up

1. Verify the next CC task's commit is BOM-free at the subject. Report PASS/FAIL in the next compliance review's P1 check.
2. If a second BOM occurrence appears, escalate — CC's PowerShell convention is materially drifting and the task prompt template may need a reminder paragraph about the BOM-free writer.
3. If two consecutive next-CC commits are BOM-free, close ITM-13 as resolved.

### Related

- D-04 commit trailer policy
- `claude-conventions.md` §Git Commit Trailers §CD commit execution mechanics (canonical BOM-free pattern reference)
- `docs/tasks/completed/c22_assemble_gnx375_compliance.md` §P1 (the finding that opened this ITM)

---

## ITM-14: `assemble_gnx375_spec.py` `--partial` mode does not skip continuity check

**Opened:** 2026-04-30T09:53:25-04:00 (Purple Turn 14 — carrying forward C2.2-ASSEMBLE-COMPLIANCE S7 PARTIAL finding from Turn 12)
**Severity:** Low (feature gap; zero impact on current workflow)
**Status:** Open
**Related:** `scripts/assemble_gnx375_spec.py`; D-18 §Assembly readiness; `docs/tasks/completed/c22_assemble_gnx375_compliance.md` §S7

### Summary

The C2.2-ASSEMBLE prompt specified three behaviors for `--partial` mode:

| (a) | Substitute a placeholder block where each missing fragment would go |
| (b) | **Skip section-numbering continuity check for ranges within missing fragments** |
| (c) | Print a warning listing missing fragments; exit code 0 unless other verification fails |

CC implemented (a) and (c) correctly. **(b) was not implemented** — if `--partial` is run with one or more fragments genuinely missing, `verify_section_numbering` will detect the gap in §§ and report a continuity failure even though the missing range is expected.

### Practical impact

Zero, today. All 7 fragments are archived; full assembly is the only path exercised. The gap matters only for these hypothetical scenarios:

- Mid-authoring preview assembly (e.g., A–E archived, F–G in flight, want to see what the partial spec looks like)
- CI/automated continuity checks before all fragments land
- Re-assembling if a fragment is temporarily withdrawn for revision (e.g., post-review patch in flight)

None of these are active workflows. D-18 + D-22 lock in piecewise authoring with all-or-nothing assembly at the end.

### Fix outline (if/when needed)

~20 lines:

1. Build a static map: `FRAGMENT_COVERAGE = {'A': [1, 2, 3, 'B', 'C'], 'B': [4], 'C': [4], 'D': [5, 6, 7], ...}` enumerating which sections each fragment is responsible for.
2. In `--partial` runs, collect the set of missing sections from the missing fragments' coverage values: `missing_sections = set().union(*(FRAGMENT_COVERAGE[L] for L in missing_letters))`.
3. Pass `missing_sections` to `verify_section_numbering` and have it subtract from the expected-section set before computing gap diffs.

No other verification check needs partial-awareness logic; only section-numbering continuity is gap-sensitive.

### Required follow-up

None required until partial-assembly is needed. If/when a use case arises (e.g., a downstream Fragment H is added in V2 and pre-assembly preview is wanted before its archive), implement the fix at that time. Until then, document this ITM as the known limitation.

### Related

- `scripts/assemble_gnx375_spec.py` lines 471–491 (current `--partial` implementation)
- D-18 §Assembly readiness (assembly contract)
- `docs/tasks/completed/c22_assemble_gnx375_compliance.md` §S7 (finding that opened this ITM)
