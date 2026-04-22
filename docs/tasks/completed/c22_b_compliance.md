---
Created: 2026-04-22T16:25:52-04:00
Source: docs/tasks/c22_b_compliance_prompt.md
---

# C2.2-B Compliance Report

**Verified:** 2026-04-22T16:25:52-04:00
**Verdict:** ALL PASS

## Summary
- Total checks: 23
- Passed: 23
- Failed: 0
- Partial: 0

## Results

### F. Framing Commitments

**F1. PASS** — B4 Gap 1 (Map rendering architecture) preserved as unresolved. Line 341 in fragment B: "**Implementation architecture choice (Map_add API vs. canvas vs. video streaming): major design decision deferred to design phase.**" Lines 341–347 enumerate candidate approaches and explicitly state the choice "must be resolved during the design phase before implementation." Behavioral check: §4.2 AMAPI notes (line 333) mention `Map_add` API and canvas drawing APIs as candidates, not commitments; no sentence in the §4.2 spec body commits to a specific rendering technology.

**F2. PASS** — B4 Gap 2 (scrollable list implementation) preserved as unresolved. Lines 511–516: "**Scrollable list implementation mechanism: B4 Gap 2 design decision; spec must commit in design phase.**" Prose documents the list's behavior (row content, scrolling, coloring, active-leg highlighting) without committing to an implementation mechanism. AMAPI notes (line 504) cite B4 Gap 2 explicitly.

**F3. PASS** — OPEN QUESTION 1 (altitude constraints on FPL legs) preserved. Lines 517–523: "**OPEN QUESTION 1: Altitude constraints on flight plan legs.**" VCALC-is-separate framing present at line 520: "VCALC is a separate pilot-input planning tool for computing vertical profiles; it is not an automatic display of procedure-coded altitude constraints." Behavior flagged as unknown; deferred to design-phase research.

**F4. PASS** — XPDR app icon framed as GNX 375-only. Line 59: `| **XPDR** | **XPDR Control Panel** | **§11** | **✓ (GNX 375 only)** | — | — |`. Lines 63–64: "The XPDR icon is **GNX 375-only** and opens the XPDR Control Panel. It is not present on GPS 175 or GNC 355/355A. For XPDR Control Panel internals, see §11 (Fragment F)." All 8 XPDR matches appear in: (a) §4.1 icon inventory and scope prose (lines 21, 36, 46, 59, 63–64), (b) Coupling Summary forward-refs (lines 769, 779). Zero matches describe XPDR modes, squawk code entry, IDENT, or other §11 internals.

**F5. PASS** — GPS NAV Status indicator key framed as GNX 375 / GPS 175 only. Sub-section heading at line 470: "#### GPS NAV Status indicator key (GNX 375 / GPS 175 only — NOT GNC 355) [p. 158]". Three states documented in table (lines 478–481) with trigger conditions and display contents:

| State | Trigger | Display |
|-------|---------|---------|
| No flight plan | No active flight plan | Page icon; underscores |
| Active route display | Plan present, CDI not active | From/to/next identifiers and leg types |
| CDI scale active | Plan present, CDI active | From and to waypoints only (space-constrained) |

**F6. PASS** — Flight Plan User Field omission correctly handled. Lines 498–502: heading "#### Flight Plan User Field — NOT present on GNX 375" followed by a 2-sentence omission note: "The Flight Plan User Field (available on GNC 355/355A, documented at p. 155) is **not present on the GNX 375**. Route display customization on the GNX 375 is provided by the Map page data corner fields (§4.2) and the FPL page's three data columns above." No field behavior is documented (no options, configuration, or use-case prose).

**F7. PASS** — §4.5 Airport Weather tab FIS-B built-in receiver framing. Lines 603–608 (scope): "The Airport Weather tab on the GNX 375 is served by the **built-in dual-link ADS-B In receiver** (FIS-B), providing METAR and TAF data without external hardware. The GPS 175 has no built-in ADS-B In receiver..." Lines 649–653 (tab description): "On the GNX 375, FIS-B weather is available from the **built-in dual-link ADS-B In receiver** without any external hardware." Contrast with GPS 175 and GNC 355/355A explicit. Open question preserved at lines 704–710: "Airport Weather tab behavior when no FIS-B uplink is available."

**F8. PASS** — No COM present-tense on GNX 375. The grep for `COM radio|COM standby|COM volume|COM frequency|COM monitoring|VHF COM` returned one match: line 24–25 ("§4.11 (COM Standby Control Panel, GNC 355/355A only) is omitted entirely; the GNX 375 has no VHF COM radio"). This is in the §4 scope statement as an omission notice — never "the GNX 375 has [COM feature]." No COM icon appears in the §4.1 app icon inventory.

**F9. PASS** — §4.2 Default Map user fields per-unit distinction. Lines 110–118 contain a 3-row table: GNX 375, GPS 175, and GNC 355/355A. GNX 375 and GPS 175 share Field 4 = "Distance/bearing from destination airport". GNC 355/355A Field 4 = "From, to, and next waypoints." Prose at lines 116–118 explicitly states: "The GNX 375 and GPS 175 share the same default set; GNC 355/355A has a different default for the fourth field."

**F10. PASS** — §4.2 Land data symbols supplement referenced. Line 252: "The authoritative source for the enumerated land symbol list is the supplement at `assets/gnc355_reference/land-data-symbols.png`." Lines 250–251 acknowledge p. 125 sparseness: "Pilot's Guide p. 125 is sparse (image-only; text labels extracted but symbol graphics absent)." Both expected conditions satisfied.

**F11. PASS** — No internal VDI framing in spec body. The grep for `VDI|vertical deviation indicator` returned one match: line 754 in the Coupling Summary ("Fragment A §1 (Overview): GNX 375 baseline framing, TSO-C112e, **no-internal-VDI**..."). This is in the coordination metadata (Coupling Summary), not the spec body, and correctly records that Fragment A established the no-internal-VDI framing. Zero spec-body sentences imply the GNX 375 renders VDI internally.

---

### S. Source Fidelity

**S12. PASS** — All 4 extras are PDF-sourced from pp. 116–139:
- "Lightning": FOUND on pages [116, 133, 134, 136]
- "METAR": FOUND on pages [116, 133, 134, 136]
- "Airways": FOUND on pages [116, 121, 133, 135]
- "Obstacles": FOUND on pages [123, 127, 133, 135]

All 4 extra overlays (beyond the outline's 7) are verifiably present in the Pilot's Guide map-setup pages. The fragment's 11-overlay enumeration is PDF-sourced, not invented.

**S13. PASS** — Fragment's 6-tab structure is PDF-accurate. PDF pp. 169–171 confirm:
- "Recent": FOUND p. 170
- "Nearest": FOUND pp. 169, 170
- "Flight Plan": FOUND pp. 169, 170
- "User": FOUND p. 171
- "Search by Name": FOUND p. 171 (labeled "SEARCH BY NAME" in PDF)
- "Search by City": FOUND p. 171 (labeled "SEARCH BY CITY" in PDF)
- "Search by Facility Name": NOT FOUND in pp. 169–171

The correct Pilot's Guide term is "Search by City" (PDF p. 171: "SEARCH BY CITY"). The outline used "Search by Facility Name" which does not appear in this page range. The fragment correctly uses "Search by City", making the fragment more PDF-accurate than the outline on this term.

**S14. PASS** — All 6 FPL data column codes and defaults confirmed from PDF p. 149. PDF text of page 149 contains:
- All 6 codes: CUM, DIS, DTK, ESA, ETA, ETE — all FOUND
- Default assignments explicitly stated in PDF: "Column 1: DTK / Column 2: DIS / Column 3: CUM" — all FOUND

The fragment's enumeration (lines 413–424) and defaults (line 424: "Column 1 = DTK, Column 2 = DIS, Column 3 = CUM") are exact matches to the PDF source.

**S15. PASS** — All 9 sampled outline page citations present and correctly cited:

| Expected citation | Expected location | Fragment line | Status |
|-------------------|-------------------|--------------|--------|
| `[pp. 17, 28–29, 86]` | §4.1 heading | Line 33 | ✓ |
| `[pp. 113–139]` | §4.2 heading | Line 94 | ✓ |
| `[p. 124]` | Aviation data symbols | Line 218 | ✓ |
| `[p. 125]` | Land data symbols | Line 247 | ✓ |
| `[pp. 140–157]` | §4.3 heading | Line 357 | ✓ |
| `[p. 158]` | GPS NAV Status heading | Line 470 | ✓ |
| `[pp. 159–164]` | §4.4 heading | Line 527 | ✓ |
| `[pp. 165–178]` | §4.5 heading | Line 600 | ✓ |
| `[pp. 179–180]` | §4.6 heading | Line 714 | ✓ |

No missing or miscited ranges.

---

### X. Cross-Reference Fidelity

**X16. PASS** — All Fragment A backward-refs in prose resolve to real sub-sections. In-prose backward refs (lines 1–746, excluding Coupling Summary):
- §2.6 (line 68) → `### 2.6 Page navigation labels (locater bar)` in Fragment A ✓
- §2.4 (line 71) → `### 2.4 Keys and UI primitives` ✓
- §2.1 (line 73) → `### 2.1 Bezel components` ✓
- §2.7 (line 79) → `### 2.7 Knob shortcuts` ✓
- §2.3 (line 268) → `### 2.3 Touchscreen gestures` ✓
- §2.7 (line 532) — second reference in §4.4 scope ✓
- Appendix B.3 (line 678) → `### B.3 Garmin-specific terms` ✓

Zero dangling backward-refs.

**X17. PASS** — Coupling Summary backward-refs enumerate all in-prose citations. All in-prose refs (§2.1, §2.3, §2.4, §2.6, §2.7, Appendix B.3) appear in the Coupling Summary's "Backward cross-references" section. Minor over-enumeration noted: (a) the Summary cites Fragment A §1 as providing GNX 375 baseline framing, which is implicit in the prose but never explicitly cited as "see §1"; (b) the Summary cites §2.5–2.6 as a range, but prose only explicitly cites §2.6. Both are acceptable per the "minor over-enumeration is acceptable" criterion.

**X18. PASS** — All forward-ref targets in the Coupling Summary exist in the outline. Forward-ref targets enumerated from Coupling Summary lines 768–786:

| Target | Outline location | Status |
|--------|-----------------|--------|
| §5 | `## 5. Flight Plan Editing` (outline line ~577) | ✓ |
| §6 | `## 6. Direct-to Operation` | ✓ |
| §7 | `## 7. Procedures` | ✓ |
| §8 | `## 8. Nearest Functions` | ✓ |
| §9 | `## 9. Waypoint Information Pages` | ✓ |
| §10 | `## 10. Settings / System Pages` | ✓ |
| §11 | `## 11. Transponder + ADS-B Operation` | ✓ |
| §11.7 | `### 11.7 Transponder Status Indications` | ✓ |
| §11.11 | `### 11.11 ADS-B In (Built-in Dual-link Receiver)` | ✓ |
| §14 | `## 14. Persistent State` | ✓ |
| §4.9 | `### 4.9 Hazard Awareness Pages` | ✓ |

Zero dangling forward-refs.

---

### C. Fragment File Conventions

**C19. PASS** — YAML front-matter, fragment header, and heading levels all correct.
- YAML front-matter at lines 1–6: `Created`, `Source`, `Fragment`, `Covers` all present.
- `Source: docs/tasks/c22_b_prompt.md` ✓
- `Fragment: B` ✓
- `Covers: §§4.1–4.6 (Home, Map, FPL, Direct-to, Waypoint Info, Nearest pages)` ✓
- Fragment header at line 8: `# GNX 375 Functional Spec V1 — Fragment B` ✓
- Top-level spec heading at line 15: `## 4. Display Pages` ✓
- Sub-section headings: `### 4.1` (line 33), `### 4.2` (line 94), `### 4.3` (line 357), `### 4.4` (line 527), `### 4.5` (line 600), `### 4.6` (line 714) — all use triple `###` ✓
- Harvest-category marker check: `grep -nE '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])'` returns zero matches ✓

**C20. PASS** — Coupling Summary correctly delineated as coordination metadata.
- `## Coupling Summary` heading at line 747 ✓
- Lines 748–750: "This section is authored per D-18 for CD/CC coordination across the 7-fragment spec. It is not part of the spec body and is **stripped on assembly**." Both D-18 attribution and "stripped on assembly" language present ✓
- Coupling Summary appears after the last spec-body sub-section (§4.6 ends at line ~745) and is preceded by a `---` horizontal rule separator ✓

---

### N. Negative Checks

**N21. PASS** — `grep -c '^## 4\. Display Pages'` returns exactly 1. The §4 parent scope is authored exactly once at line 15.

**N22. PASS** — `grep -nE '^### 4\.(7|8|9|10)'` returns zero matches. No §§4.7–4.10 content leaked from Fragment C scope. Section after §4.6 (line 714) is followed directly by the `## Coupling Summary` heading at line 747.

**N23. PASS** — No §11 XPDR-panel internals, no §§5–15 operational workflow detail, no Appendix A content in spec body. Spot-check of §§4.1–4.6:
- XPDR: only 6 mentions, all in §4.1 icon inventory / scope context; no squawk, modes, IDENT, or Extended Squitter detail.
- §5 scope (FPL editing workflows): deferred at lines 284, 362, 468, 502.
- §6 scope (Direct-to workflows): deferred at lines 533, 591.
- §7 scope (Procedure workflows): deferred at lines 536, 639 (Procedures tab).
- §9 scope (Waypoint management): deferred at lines 668, 786.
- §10 scope (Settings): deferred at lines 668, 739.
- §14 scope (Persistent state): deferred at line 451.
- No dataref/event listings, no Settings configuration detail, no family-delta comparison tables.

---

## Notes

**S13 — Search by City vs. Search by Facility Name:** The outline uses "Search by Facility Name" but the PDF Pilot's Guide (pp. 169–171) consistently uses "SEARCH BY CITY." The fragment correctly uses "Search by City." This is a case where the fragment is more PDF-accurate than the outline. No corrective action needed; the outline entry may be updated during a future outline maintenance pass.

**X17 — Minor Coupling Summary over-enumeration:** The Coupling Summary's backward-refs section lists Fragment A §1 as providing framing "referenced throughout §§4.1–4.6," and lists "§2.5–2.6" as a pair. In the spec body, §1 is not explicitly cited (the framing is applied implicitly), and only §2.6 appears as an explicit citation (not §2.5). These are minor documentation over-enumerations that don't affect spec accuracy or fragment assembly.

**F4 — AMAPI notes mention Map_add API:** The §4.2 AMAPI notes block (line 333) references `Map_add` API as one candidate approach alongside canvas drawing, within a B4 Gap 1 marker. This is correct framing — the AMAPI notes section is a developer pointer, not a spec commitment, and the sentence explicitly defers the architectural choice to the B4 Gap 1 open question.

**Line count:** Fragment B is 799 lines (CC completion report stated 798 — off by one from a trailing newline difference). No material discrepancy.
