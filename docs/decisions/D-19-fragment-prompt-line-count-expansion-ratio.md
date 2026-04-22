---
Created: 2026-04-22T10:30:00-04:00
Source: Purple Turn 35 — lesson learned from C2.2-A compliance result
---

# D-19: Fragment Prompt Line-Count Targets — Use ~1.35× Outline Expansion Ratio

**Date:** 2026-04-22
**Status:** Active
**Refs:** D-18 (C2.2 format decision establishing per-task estimates), GNX375-SPEC-C22-A (the compliance run that surfaced the issue)
**Affects:** C2.2-B through C2.2-G task prompts (drafted by CD)

---

## Context

The C2.2-A task prompt (Turn 31) set a line-count target of ~445 lines based on a ~1.15× expansion ratio over D-18's ~380-line outline-section sum (50 + 150 + 80 + 65 + 35). CC delivered 545 lines (+22% over target), which CC explicitly flagged as a deviation in its completion report. Compliance verification (Turn 34) classified the entire overage as PDF-sourced or prompt-mandated content with no padding or scope creep, and recommended accepting as-is. CD accepted (Turn 35).

The root cause: my ~1.15× expansion ratio assumption in the C2.2-A prompt was too tight when the fragment contains structured tables (glossary tables, sparse-page tables, Coupling Summary block). Tables have higher line-per-content overhead than prose. The actual ratio for C2.2-A came in at ~1.43× (545 / 380).

---

## Decision

**For C2.2-B through C2.2-G task prompts, set line-count targets using a ~1.35× outline expansion ratio** (instead of ~1.15×). Apply this to the per-task estimates from D-18:

| Task | D-18 estimate (outline sum) | Adjusted prompt target (×1.35) | Rationale |
|------|------------------------------|--------------------------------|-----------|
| C2.2-B | ~610 | ~720 | Map page tables, FPL data column tables, AMAPI cross-ref blocks |
| C2.2-C | ~480 | ~575 | Hazard awareness 3-page detail, FIS-B product enumeration, traffic alerting parameters |
| C2.2-D | ~630 | ~750 | Procedure type tables (LNAV/LP/LPV/etc.), 7.A–7.M augmentation blocks, autopilot output detail |
| C2.2-E | ~380 | ~455 | Settings page tables (CDI scale, units, brightness modes), GPS status detail |
| C2.2-F | ~450 | ~540 | XPDR mode table, advisory message tables, annunciation states |
| C2.2-G | ~250 | ~300 | Family-delta comparison table, dataref/event tables, persistent state table |
| **Total** | **~2,800** | **~3,340** | (vs. D-18's ~3,180) |

The ~160-line difference between D-18's ~3,180 and the adjusted ~3,340 is **delivery overhead** (table formatting, fragment headers, Coupling Summaries, AMAPI cross-ref blocks) — not additional spec content. It does not invalidate D-18's spec-body length estimate.

### Exception: 550-line reassessment threshold

If a future fragment prompt's adjusted target exceeds ~700 lines, also reassess whether it should be split into two prompts. The 700-line limit is a soft ceiling chosen to keep CC's output reliably under context limits with margin for the completion report. C2.2-D at ~750 is right at this limit — flag for monitoring during drafting; if the prompt itself grows beyond ~10K words including all instructions, consider splitting §7's procedural augmentations (7.A–7.M, ~50 lines net) into a sub-task.

---

## Rationale

### Why ~1.35× instead of ~1.15×

Per the C2.2-A compliance breakdown:
- **Glossary tables** (B.1, B.1 additions, B.2, B.3): 35 + 15 + 8 + 6 = 64 entries. Each table row = 1 line. Plus header + separator = ~70 lines for the four tables alone.
- **Sparse-page table** (C.1): 13 entries. ~20 lines including header and the "XPDR pages CLEAN" note.
- **Coupling Summary block**: ~20 lines including 5 forward-ref bullets.
- **Per-section scope paragraph + AMAPI notes block**: ~5 lines per ### sub-section. With 28 sub-sections in Fragment A: ~140 lines of overhead beyond bullet-list expansion.

Pure prose expansion of outline bullets averaged ~1.15× as I assumed. The above structural overhead is what pushes the ratio to ~1.35×.

### Why not just update D-18's estimates

D-18's estimates are the **authoritative spec contract** — they represent how much of the spec body each task delivers. The expansion ratio is a **delivery quality-of-life adjustment** for the fragment file (which includes the Coupling Summary block that gets stripped on assembly, plus structural overhead like fragment headers and YAML front-matter).

Updating D-18 would conflate "how much spec content this task delivers" with "how many lines the fragment file totals." The compliance flow already handles this distinction: CC reports both the fragment line count and (implicitly via Coupling Summary section length) the deliverable spec-content count.

### Why the explicit per-task table

Listing the adjusted targets explicitly in this decision saves CD from recomputing the ratio for every task prompt. Each future C2.2 prompt can cite "per D-19, line-count target ~XXX" without recomputation.

---

## Non-decisions (intentionally not changed)

- **D-18's task partition remains authoritative.** 7 fragments, A through G, sequential delivery, manifest assembly. Section coverage per task is unchanged.
- **D-18's total spec-body estimate (~3,180 lines) remains the contract for what the spec contains.** The aggregate after assembly should land near ~3,180 (after stripping Coupling Summary blocks and fragment headers).
- **Compliance bar is unchanged.** Future fragment compliance still treats line-count overage as a triage prompt for "PDF-sourced / outline-expansion / invented" classification, not an automatic FAIL.

---

## Application

**This turn (Turn 35):** Task flow plan footer notes the lesson and the C2.2-B prompt target adjustment.

**Next turn (Turn 36):** When drafting the C2.2-B prompt, use ~720 as the target line count (per the table above). Note the D-19 reference in the prompt header so CC understands the rationale.

**Future maintenance:** If any future fragment delivers under target (e.g., comes in at ~580 when target was ~720), the under-delivery is also a compliance concern (suggests under-coverage of outline content). The ~1.35× ratio is a target with ±10% tolerance.

---

## Related

- D-18 (C2.2 format decision — establishes the partition this decision refines)
- `docs/tasks/completed/c22_a_completion.md` (CC's deviation report flagging the line-count overage)
- `docs/tasks/completed/c22_a_compliance.md` (compliance breakdown of overage by content category)
- `docs/specs/GNX375_Functional_Spec_V1.md` (manifest — tracks fragment delivery counts)
