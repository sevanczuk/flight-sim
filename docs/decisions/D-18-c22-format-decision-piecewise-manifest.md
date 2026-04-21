---
Created: 2026-04-21T13:30:00-04:00
Source: Purple Turn 30 — resolves D-11 + D-13 deferred format decision; resolves ITM-07 inline
---

# D-18: C2.2 Delivery Format — Piecewise + Manifest, 7-Task Partition

**Date:** 2026-04-21
**Status:** Active
**Supersedes:** D-13 (deferral closed by this decision)
**Refs:** D-11 (outline-first rationale), D-13 (format deferred pending outline), D-12 (GNX 375 pivot), GNX375-SPEC-OUTLINE-01 (authoritative outline), ITM-07 (§4 estimate discrepancy — resolved inline)

---

## Context

D-11 established that the C2 functional-spec phase should produce an outline first, then defer the format of the spec-body authoring (C2.2) until the outline's size and structure were known. D-13 extended that deferral specifically for the GNX 375 pivot.

C2.1-375 is now complete (Turn 29 archive). The authoritative outline is `docs/specs/GNX375_Functional_Spec_V1_outline.md` (1,477 lines; 18 divisions). The completion report recommended piecewise + manifest with 6-task grouping. Compliance verification (PASS WITH NOTES) surfaced ITM-07: §4 length estimates are inconsistent across three locations (~800 / ~740 / ~1,090), with the sub-section sum being the most reliable.

This decision (a) adopts the piecewise + manifest format, (b) resolves ITM-07 by adopting the sub-section sum as authoritative, (c) locks in a 7-task partition (1 more than the completion report recommended, to address the larger §4), and (d) specifies the manifest, coupling-summary, and delivery-order conventions.

---

## Decision

### Format: Piecewise + manifest

C2.2 will be decomposed into 7 CC sub-tasks (C2.2-A through C2.2-G), each producing a separate spec-body fragment file under `docs/specs/fragments/GNX375_Functional_Spec_V1_part_{A-G}.md`. A top-level manifest at `docs/specs/GNX375_Functional_Spec_V1.md` will include an ordered list of fragments and assembly instructions. Assembly = concatenation in declared order, with fragment-header YAML stripped.

### Authoritative section length estimates (resolves ITM-07)

The §4 sub-section sum (~1,090) is adopted as authoritative. Revised section estimates:

| Section | Estimate | Source |
|---------|----------|--------|
| §1 Overview | ~50 | outline field |
| §2 Physical Layout & Controls | ~150 | outline field |
| §3 Power-On, Self-Test, Startup | ~80 | outline field |
| §4 Display Pages | **~1,090** | **revised: sub-section sum** |
| §5 Flight Plan Editing | ~200 | outline field |
| §6 Direct-to Operation | ~80 | outline field |
| §7 Procedures | ~350 | outline field |
| §8 Nearest Functions | ~60 | outline field |
| §9 Waypoint Information | ~120 | outline field |
| §10 Settings / System Pages | ~200 | outline field |
| §11 Transponder + ADS-B | ~200 | outline field |
| §12 Audio, Alerts, Annunciators | ~100 | outline field |
| §13 Messages | ~150 | outline field |
| §14 Persistent State | ~50 | outline field |
| §15 External I/O | ~50 | outline field |
| Appendix A (Family Delta) | ~150 | outline field |
| Appendix B (Glossary) | ~65 | outline field |
| Appendix C (Extraction Gaps) | ~35 | outline field |
| **Total** | **~3,180** | vs. outline header's ~2,860 |

Revised total: ~3,180 lines (≈350 lines more than the outline header claim). The outline header estimate fields are not updated inline; this decision document is the authoritative source going forward. If future revision of the outline is warranted for other reasons, the estimate fields may be reconciled at that time.

### Task partition — 7 tasks

| Task ID | Sections covered | Estimate | Category | Coupling notes |
|---------|------------------|----------|----------|----------------|
| **C2.2-A** | §§1–3 + Appendices B, C | ~445 | Foundation | Self-contained. Appendix B (glossary) should be authored last within this task after §§1–3 are drafted so XPDR/ADS-B terms used in §1.1 are glossary-consistent. |
| **C2.2-B** | §4.1–4.6 (Home, Map, FPL, Direct-to, Waypoint Info, Nearest pages) | ~610 | Display pages part 1 | §4.2 Map is the largest single sub-section (~200) and has major B4 Gap 1 design decisions (canvas vs. Map_add vs. video). §4.3 FPL has GPS NAV Status indicator key + omitted Flight Plan User Field. Forward-ref §5 (FPL editing workflows) and §6 (Direct-to ops) as "see §§5–6 for operational detail." |
| **C2.2-C** | §4.7–4.10 (Procedures, Planning, Hazard Awareness, Settings display pages) | ~480 | Display pages part 2 | §4.9 Hazard Awareness has the ADS-B framing flip and TSAA aural alerts — couples forward to §11 (source of ADS-B In) and §12.4 (aural delivery). §4.10 CDI On Screen couples forward to §15.6 (external CDI output contract). Forward-refs: "see §7 for procedures ops; §11 for XPDR/ADS-B mechanism; §12 for aural alert hierarchy." |
| **C2.2-D** | §§5–7 (FPL editing, Direct-to op, Procedures) | ~630 | GPS operational | §7 is the largest section at ~350 lines; includes the 7.A–7.M augmentations (D-14 items) and §7.9 XPDR-interaction sub-section. §7.9 cross-refs §11 (XPDR) and §4.9 (traffic display). §7 references D-15 for no-internal-VDI constraint and external CDI/VDI output. |
| **C2.2-E** | §§8–10 (Nearest, Waypoint Info, Settings) | ~380 | GPS configuration | §10.12 ADS-B Status couples forward to §11 (source). §10.13 Logs mentions GNX 375-only ADS-B traffic logging. §10.1 CDI On Screen toggle couples forward to §15.6 (external output). Otherwise self-contained. |
| **C2.2-F** | §11 (XPDR + ADS-B) + §§12–13 (Audio/Alerts, Messages) | ~450 | XPDR + alert system | **Highest-coupling task.** §11 is the new section (14 sub-sections per D-16). §12.9 XPDR Annunciations replaces COM Annunciations; §13.9 XPDR Advisories replaces COM Radio Advisories. §12.4 aural alerts references TSAA (§11 / §4.9). Backward-refs to §4.9 (ADS-B In display consumers) and §7.9 (approach-phase XPDR). Forward-ref to §14.1 (persistent state) and §15 (datarefs). |
| **C2.2-G** | §§14–15 + Appendix A | ~250 | Persistence + I/O + family delta | §14.1 XPDR State + §15 XPDR datarefs close the loop on §11. §15.6 external CDI/VDI output contract closes the loop on §4.10, §7.G, §10.1. Appendix A family delta needs all prior sections authored for cross-references to resolve. **Must be authored last.** |

**Task count rationale:** The completion report recommended 6 tasks. The revised §4 estimate (~1,090 vs. ~740) means the original C2.2-B and C2.2-C would each grow to ~650–700 lines. Splitting §4 at §4.6/§4.7 (natural boundary between display-pages-part-1 and display-pages-part-2) keeps each task in the 380–630 line range and gives the heaviest task (C2.2-D at ~630) the procedural content where careful authoring matters most. 7 tasks also aligns §11 with §12/§13 in a single task (C2.2-F), which reduces cross-task coupling for the XPDR-content block — previously the completion report's proposed C2.2-E and C2.2-F both carried XPDR coupling.

### Delivery order

C2.2-A → C2.2-B → C2.2-C → C2.2-D → C2.2-E → C2.2-F → C2.2-G.

The order is top-down through the outline with one exception: Appendix B (glossary) lives in C2.2-A rather than C2.2-G so that later tasks can reference Appendix B terms without forward-referring to unauthored content. Appendix A (family delta) and Appendix C (extraction gaps) are placed at their natural end position in C2.2-G.

**Sequential, not parallel.** Although nothing in the piecewise + manifest format mechanically prevents parallelizing CC tasks, coupling notes require prior-task output as source material for later tasks. Running sequentially ensures each task's prompt can cite the actually-authored fragment file path for its backward-refs.

### Manifest file

`docs/specs/GNX375_Functional_Spec_V1.md` is the manifest. It is authored by CD once C2.2-A is archived and updated incrementally as each fragment archives. Structure:

```markdown
---
Created: <date>
Source: D-18 C2.2 format decision
---

# GNX 375 Functional Spec V1

**Status:** <Draft | Ready-for-review | V1-locked>
**Source outline:** `docs/specs/GNX375_Functional_Spec_V1_outline.md`
**Format decision:** D-18 (piecewise + manifest, 7 fragments)

## Fragment manifest

| Order | Task ID | Fragment file | Covers | Status |
|-------|---------|--------------|--------|--------|
| 1 | C2.2-A | `fragments/GNX375_Functional_Spec_V1_part_A.md` | §§1–3, App. B, App. C | <status> |
| 2 | C2.2-B | `fragments/GNX375_Functional_Spec_V1_part_B.md` | §§4.1–4.6 | <status> |
| ... | | | | |

## Assembly

To produce the single-file spec for review (C3) or implementation reference (C4+):

1. Concatenate fragments in manifest order.
2. Strip each fragment's YAML front-matter (already included in the manifest header).
3. Ensure section numbering is continuous (no duplicates, no gaps).
4. Verify all cross-references (`see §N.x`) resolve to existing targets after concatenation.

An assembly script (`scripts/assemble_gnx375_spec.py`) will be provided at C2.2-G archive.
```

### Coupling summary convention

Each C2.2 task prompt must include a **Coupling Summary** section listing:
- Backward cross-references: sections this task references that were authored in prior tasks; include the actual fragment file path so CC can load and read the prior content.
- Forward cross-references: sections this task writes that will be referenced by later tasks; CC authors placeholder cross-refs as "see §N.x" without further qualification.
- Outline coupling footprint: the list of outline §N.x sub-sections this task must draw content from. Since the outline is the shared source of truth for all tasks, CC always reads the outline itself; the coupling summary tells CC which *other fragments* (from prior tasks) it must also read.

### Fragment file conventions

- Path: `docs/specs/fragments/GNX375_Functional_Spec_V1_part_{A-G}.md`
- YAML front-matter required: `Created`, `Source` (the task prompt), `Fragment`, `Covers`
- Heading levels: `#` reserved for fragment header (repeats across fragments; manifest strips on assembly); `##` for top-level sections (§1, §2, etc.); `###` for sub-sections
- Line-count target: match or slightly exceed the estimate in the task partition table; under-delivery is a completion-report finding

---

## Rationale

### Why piecewise + manifest (vs. monolithic CRP or per-section)

**Monolithic CRP rejected:** A ~3,180-line spec body exceeds CC's reliable single-task output range (~600–800 lines for technical content authored carefully). Compaction-resilient protocol helps with long sessions but does not raise the per-task output ceiling. A monolithic task would either be truncated or hit low-quality tail sections.

**Per-section (18 tasks) rejected:** Too granular. Many sections are 50–80 lines and share tight coupling (§6 Direct-to ops shares §5's FPL editing context). The coordination overhead (18 task prompts, 18 compliance cycles) dominates the productive work.

**Piecewise + manifest chosen:** 7 tasks is the Goldilocks point. Each task is ~250–630 lines (well within CC's reliable output range), yet each task covers enough coupled sections to make the internal cross-referencing natural. Manifest+concatenation assembly is mechanically simple.

### Why 7 tasks (vs. completion report's 6)

The completion report's 6-task grouping was based on the ~740-line §4 estimate. With the revised ~1,090-line estimate, tasks C2.2-B and C2.2-C under the 6-task plan would each be ~650 lines. Still in-range but at the upper end. Splitting §4 at §4.6/§4.7 (display-pages-part-1 / display-pages-part-2) distributes the load more evenly (610 / 480 lines) and reduces tail-risk for §4.7 Procedures display pages, which has dense content and XPDR-interaction framing.

The 7-task split also consolidates the entire XPDR content block (§11) with §12–13 alert/messages content in a single task (C2.2-F). Under the 6-task plan, XPDR coupling was split across C2.2-E (contained §11) and C2.2-F (contained §12 + §13). The new C2.2-F contains §11 + §12 + §13 together, so XPDR annunciations (§12.9), XPDR advisories (§13.9), and XPDR core (§11) are authored in one coherent pass.

### Why sequential rather than parallel

Forward references are unavoidable (§11 ↔ §4.9 ↔ §12 ↔ §13 ↔ §14 ↔ §15). A sequential order lets each task's prompt give CC the actual prior fragment content as "here's what you're cross-referencing" input. Parallel execution forces all cross-refs to be placeholder "see §N.x" without knowing whether the target will be authored consistent with this task's framing. Sequential is slower wall-clock but higher-quality.

### Why Appendix B (glossary) lives in C2.2-A

Most later tasks use XPDR/ADS-B terminology (Mode S, 1090 ES, UAT, TSAA, FIS-B, TIS-B, IDENT, etc.). If Appendix B is written last (in C2.2-G), then every task up through C2.2-F must define these terms inline or forward-reference a not-yet-written appendix. Putting Appendix B in C2.2-A means later tasks can assume the glossary exists and reference it, keeping their prose tight. The downside is that C2.2-A grows from ~350 to ~445 lines; acceptable given the alternative.

### Why Appendix A (family delta) lives in C2.2-G

Appendix A is explicitly comparative and references every section's 375-specific content. It cannot be authored sensibly before the other sections exist. Natural placement: last.

---

## Resolution of ITM-07

ITM-07 (§4 length estimate inconsistency) is **resolved by adoption** in this decision. The sub-section sum (~1,090) is authoritative. The outline's §4 top-level estimate field and nav-aids header remain at ~740 and ~800 respectively — these are not updated because the outline is archival and reflects the state at C2.1-375 archive. Going forward, any reference to §4 length defers to this decision doc's table.

Mark ITM-07 resolved in `docs/todos/issue_index.md` → move to `issue_index_resolved.md` with resolution note pointing here.

---

## Follow-up actions (this turn + subsequent)

### This turn (Turn 30):
- [x] Write D-18 (this file)
- [ ] Resolve ITM-07 — move from `issue_index.md` to `issue_index_resolved.md`
- [ ] Update `Task_flow_plan_with_current_status.md`: mark D-18 ✅ Done; C2.2-A task prompt drafting as 🔶 NEXT UP
- [ ] Update `Spec_Tracker.md` and `CC_Task_Prompts_Status.md` with the 7-task C2.2 plan
- [ ] Write commit message via Filesystem MCP

### Next turns (pending):
- Turn 31+: Draft C2.2-A task prompt. One CD turn per task prompt, 7 total = 7 CD turns for drafting.
- Interleave: CC executes each task → CD check-completions → CC compliance → CD check-compliance → archive → next task. Expect ~1.5–2 CD turns per task for the full cycle (draft + 2 reviews).
- Total C2.2 cost to fragments-complete: ~15 CD turns + 7 CC executions + 7 CC compliance runs.
- After C2.2-G archive: manifest file written, assembly script written, aggregate review pass → C3 `/spec-review` V1.

---

## Non-decisions (intentionally deferred)

- **Assembly script implementation language:** Python assumed; final decision at C2.2-G close. Script is trivial (~50 lines) so language choice is low-stakes.
- **Manifest status tracking mechanism:** The manifest table includes a Status column but its values (Draft / Ready / Archived) are informal for now. A formal lifecycle for per-fragment status may be added later if the `/spec-review` V1 process demands it; this is a C3-phase concern, not a C2.2 concern.
- **Whether to assemble a full-document intermediate for partial review:** Not needed during C2.2. If a reviewer wants a single-file view before C2.2-G is archived, the assembly script can be run against whatever fragments exist, producing a partial spec with placeholder notices for unfinished sections. This is a tool-use decision, not a format decision.

---

## Related

- D-11: Outline-first approach (rationale for why C2.1 exists before C2.2)
- D-13: C2.2 format deferred (superseded by this decision)
- D-12: GNX 375 pivot (scope context for why the 375 spec is authored)
- D-14 / D-15 / D-16: Scope corrections that inform §7, §11, §15 content
- D-17: Task_flow_plan as CD-maintained status doc (mechanism for tracking C2.2 progress)
- `docs/specs/GNX375_Functional_Spec_V1_outline.md` — authoritative outline
- `docs/tasks/completed/c2_1_375_outline_completion.md` — original 6-task proposal
- `docs/tasks/completed/c2_1_375_outline_compliance.md` — ITM-07 origin
- `docs/todos/issue_index.md` — ITM-07 entry (to be moved to resolved)
