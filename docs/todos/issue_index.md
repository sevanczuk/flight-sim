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

---

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
