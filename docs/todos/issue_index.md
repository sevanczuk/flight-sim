# Issue Index — Open

**Created:** 2026-04-20T09:10:00-04:00
**Source:** Purple Turn 37 — first issue logged triggered creation of this index
**Purpose:** Master cross-reference of all open tracked items (ITM-, G-, O-, FE-). Paired with `issue_index_resolved.md` which holds closed items.
**Maintained by:** CD

| ID | Severity | Type | Title | Source | Notes |
|----|----------|------|-------|--------|-------|
| ITM-01 | Low | Process / housekeeping | File movement reminder — after Streams A and B complete | Purple Turn 37 | CD raises this when A4 and B4 are both done; see details below |
| FE-01 | Low | Future enhancement | AMAPI parser: preserve `<a>` links inside Arguments-table cells | Purple Turn 52 | Parser currently strips `<a>` in argument description cells (~20-30 cells across corpus). Fix: same markdown-link preservation logic already used for Description text. See details below. |

---

## ITM-01: File movement reminder — after Streams A and B complete

**Created:** 2026-04-20T09:10:00-04:00
**Source:** Purple Turn 37 — Steve asked to be reminded when Streams A and B are complete so we can batch the file-movement step
**Status:** Open
**Severity:** Low (process / housekeeping)
**Owner:** CD (Purple is primary; any CD instance can action)

### Description

Per the check-completions protocol, after a task's compliance passes, CC moves task-related files (prompt, completion report, compliance prompt, compliance report) to `docs/tasks/completed/`. During the flurry of Wave-1 execution (AMAPI-CRAWLER-01, SAMPLES-RENAME-01, GNC355-EXTRACT-01, BUGFIX-01, BUGFIX-02), this movement has been deferred.

Steve's preference (Turn 37): defer file movement until Streams A and B are both complete, then do a single batch move.

### Triggers

CD should raise this reminder when:

- Stream A reaches "ready for design phase" (A4 complete, AMAPI reference docs produced)
- AND Stream B reaches "ready for design phase" (B4 complete, pattern catalog drafted)

At that point CD should produce a consolidated file-movement CC task covering all completed-but-not-yet-moved task file sets:

- AMAPI-CRAWLER-01 (prompt + completion)
- AMAPI-CRAWLER-BUGFIX-01 (prompt + completion + compliance prompt + compliance report — when generated)
- AMAPI-CRAWLER-BUGFIX-02 (prompt + completion + compliance prompt + compliance report — when generated)
- A2, A3 (when their tasks complete)
- SAMPLES-RENAME-01 (prompt + completion)
- B2 outputs (CD work, no files to move — selection doc stays in `docs/knowledge/`)
- B3, B4 (when their tasks complete)

### Notes

- Stream C (GNC 355) is tracked separately from this reminder; its file movement is independent and can happen whenever C's own cadence allows
- The completed-task files are harmless where they are — this is cleanup, not a correctness issue
- Once triggered, the file-movement CC task should also produce a final commit in the D-04 trailer format
- MANUAL_gnc355_eyeball_low_confidence_pages.md stays in `docs/tasks/` by design — it's Steve's active work list; moves only after Steve saves the results file

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
