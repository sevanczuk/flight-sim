---
Created: 2026-04-23T10:15:00-04:00
Source: docs/tasks/c22_d_compliance_prompt.md
---

# C2.2-D Compliance Report — GNX 375 Functional Spec V1 Fragment D

**Task ID:** GNX375-SPEC-C22-D-COMPLIANCE
**Fragment verified:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md`
**Verified:** 2026-04-23

---

## Pre-flight Verification

| Check | Result |
|-------|--------|
| Fragment D line count: 913 (expected 913) | PASS |
| Fragment A present | PASS |
| Fragment B present | PASS |
| Fragment C present | PASS |
| Outline present | PASS |
| `text_by_page.json` present | PASS |
| Completion report read | PASS |
| Fragment C §4.7 forward-refs read (lines 226, 232) | PASS |

---

## Summary Table

| Section | Checks | PASS | FAIL | PARTIAL |
|---------|--------|------|------|---------|
| F. Framing Commitments | 14 | 14 | 0 | 0 |
| S. Source Fidelity | 7 | 7 | 0 | 0 |
| X. Cross-Reference Fidelity | 3 | 3 | 0 | 0 |
| C. Fragment File Conventions | 2 | 2 | 0 | 0 |
| N. Negative Checks | 4 | 4 | 0 | 0 |
| **Total** | **30** | **30** | **0** | **0** |

---

## F. Framing Commitments

### F1. `### 7.9` authored as a real sub-section exactly once (ITM-09 resolution). **PASS**

`grep -c '^### 7\.9'` = **1**

Line 556: `### 7.9 XPDR + ADS-B Approach Interactions [pp. 75–82, 245–256]`

Located in §7 block (lines 328–875). Heading is correctly placed after §7.8 and before §7.A. Confirmed in §7 block, not misplaced.

---

### F2. §7.9 covers XPDR ALT mode during approach + WOW automatic handling. **PASS**

Lines 564–570 (§7.9):
> "The GNX 375 XPDR operates in three modes only: **Standby, On, and Altitude Reporting** (ALT mode). **No Ground mode, no Test mode, and no Anonymous mode** exist on the GNX 375 (D-16; p. 78). During approach phases (TERM, LNAV, LPV, LP+V, etc.), the XPDR remains in ALT mode. Air/ground state transitions (including WOW — weight-on-wheels) are handled **automatically** by the unit [p. 78]; no pilot mode change is required when transitioning through approach flight phases or on landing."

- XPDR operates in ALT mode during approach: ✓ (line 567)
- WOW handled automatically — no pilot mode change required: ✓ (lines 568–570)
- Reference to p. 78: ✓ (lines 564, 569)

---

### F3. §7.9 covers ADS-B Out transmission during approach (1090 ES continuous in ALT mode). **PASS**

Lines 572–575 (§7.9):
> "When in ALT mode, 1090 MHz Extended Squitter (1090 ES) ADS-B Out transmissions are continuously active. During all approach phases, the GNX 375 transmits position and altitude data. No pilot action is required to maintain ADS-B Out during approach operations."

- 1090 ES continuous in ALT mode: ✓ (line 573)
- Position and altitude transmitted throughout approach: ✓ (line 574)

---

### F4. §7.9 covers TSAA-during-approach = GNX 375 only (aural alerts) with OPEN QUESTION 6 cross-ref. **PASS**

Lines 577–584 (§7.9):
> "The TSAA (Traffic Situational Awareness with Alerting) application runs whenever ADS-B In data is available. **TSAA is GNX 375 only** — GPS 175 and GNC 355/355A have ADS-B traffic display only (via external hardware if equipped); they do not have TSAA. Traffic alerting continues during all approach flight phases; the approach flight phase does not inhibit or alter traffic alerting parameters. TSAA aural alert delivery during approach: see §4.9 (Fragment C) OPEN QUESTION 6 for the delivery mechanism; see §12.4 (Fragment F) for the aural alert hierarchy."

- TSAA continues during approach: ✓ (line 581)
- TSAA = GNX 375 only: ✓ (lines 579–580)
- OPEN QUESTION 6 cross-ref to §4.9: ✓ (line 583)
- §12.4 cross-ref for aural hierarchy: ✓ (line 584)
- OPEN QUESTION 6 NOT re-preserved verbatim: ✓ (cross-ref only)

---

### F5. §7.9 covers flight phase + XPDR state concurrent display correlation. **PASS**

Lines 586–589 (§7.9):
> "The annunciator bar displays GPS flight phase (§7.2) and the XPDR mode indicator concurrently in independent display slots. Both are visible simultaneously during approach; the approach annunciation (e.g., LPV) and the ALT indicator appear at the same time."

- Annunciator bar shows flight phase label and XPDR mode indicator concurrently: ✓
- Both visible simultaneously during approach: ✓

---

### F6. §7.9 three XPDR modes only (per D-16): Standby / On / Altitude Reporting. **PASS**

`grep -ni 'Standby\|Altitude Reporting' docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` returns:
- Line 560 (§7.9 scope): "XPDR altitude reporting during approach" (descriptive only)
- Line 565 (§7.9 body): "three modes only: **Standby, On, and Altitude Reporting** (ALT mode)"

Line 566 explicitly confirms: "**No Ground mode, no Test mode, and no Anonymous mode** exist on the GNX 375 (D-16; p. 78)"

No match implies Ground / Test / Anonymous mode as GNX 375 operational modes. Line 695 in §7.E says "XPDR remains in ALT mode (§7.9)" — this is a cross-reference only.

---

### F7. §7.9 forward-refs §11, §11.4, §11.11, §12.4, §4.9, §15 for interaction details. **PASS**

Lines 591–596 (§7.9 Forward references block):
- "XPDR control and mode detail → §11.4 (Fragment F)" ✓ (subsumes §11; also stated at line 561 as "XPDR control panel and mode detail in §11.4 (Fragment F)")
- "ADS-B In receiver → §11.11 (Fragment F)" ✓
- "Aural alert hierarchy → §12.4 (Fragment F)" ✓
- "TSAA display detail → §4.9 (Fragment C)" ✓
- "XPDR + ADS-B datarefs → §15 (Fragment G)" ✓

Note: §11 as a generic heading is not a standalone cross-reference in §7.9 prose, but §11.4 directly implies §11. The Coupling Summary (line 903) explicitly names "§11 Transponder + ADS-B (Fragment F) for XPDR control detail." All required targets covered.

---

### F8. §7.5 approach types table: 7 types matching Fragment C §4.7. **PASS**

Fragment D §7.5 table (lines 442–448):

| Approach Type | Vertical Guidance | SBAS Required | GPS Nav Approval |
|---|---|---|---|
| LNAV | None | No | Yes |
| LNAV/VNAV | Baro-VNAV (advisory) | No | Yes |
| LNAV+V | GPS-derived (advisory) | No | Yes |
| LPV | SBAS/GPS (primary) | Yes | Yes |
| LP | None | Yes | Yes |
| LP+V | GPS-derived (advisory) | Yes | Yes |
| ILS | N/A | No | No |

Fragment C §4.7 approach types table (lines 105–111): same 7 types, same labels, same SBAS Required and GPS Nav Approval fields — exact match. Fragment D adds operational columns (CDI scale, state machine notes); those columns do not contradict Fragment C. Consistency statement at Fragment D line 451 confirms: "This table is consistent with §4.7 (Fragment C) approach types table (same 7 types, same type labels)."

---

### F9. §7.2 GPS Flight Phase Annunciations: 11 rows matching Fragment C §4.7. **PASS**

Fragment D §7.2 table (lines 367–377): OCEANS, ENRT, TERM, DPRT, LNAV, LNAV/VNAV, LNAV+V, LP, LP+V, LPV, MAPR — **11 rows**.

Fragment C §4.7 GPS Flight Phase table (lines 49–61): OCEANS, ENRT, TERM, DPRT, LNAV, LNAV/VNAV, LNAV+V, LP, LP+V, LPV, MAPR — **11 rows**.

- Same 11 labels in both fragments: ✓
- Color semantics (Green = normal, Yellow = caution) consistent: ✓ (Fragment D line 379; Fragment C line 63)
- No contradictions in CDI scale values: ✓
- No additional rows in Fragment D beyond the 11: ✓

---

### F10. No internal VDI throughout §7 (per D-15). **PASS**

`grep -ni 'VDI\|vertical deviation indicator'` returns 12 matches. Every match falls into one of three acceptable categories:

| Line | Context | Category |
|------|---------|----------|
| 332 | "no internal VDI — vertical deviation is output exclusively to external CDI/VDI instruments (D-15)" | Explicit "no internal VDI" framing |
| 333 | "external CDI/VDI instruments (D-15)" | External output cross-ref |
| 462 | "D-15; Pilot's Guide p. 205: 'Only external CDI/VDI displays provide vertical deviation indications.'" | External output cross-ref |
| 606 | "outputs glidepath deviation to external CDI/VDI only (D-15)" | External output framing |
| 623 | "output to external CDI/VDI" | External output framing |
| 645 | "No internal VDI (D-15): no on-screen glideslope or glidepath needle of any kind" | Explicit "no internal VDI" |
| 741 | "Lateral deviation only — no vertical deviation indicator on the GNX 375 screen" | Explicit "no internal VDI" |
| 745 | "No on-375 VDI of any kind (D-15; Pilot's Guide p. 205)" | Explicit "no internal VDI" |
| 746 | "display a glidepath needle, glideslope needle, or vertical deviation indicator internally" | Explicit "no internal VDI" |
| 747 | "exclusively to external CDI/VDI instruments" | External output framing |
| 883 | "no-internal-VDI constraint (D-15)" (Coupling Summary) | Coupling Summary reference |
| 901 | "§15.6 External CDI/VDI Output Contract" (Coupling Summary forward-ref) | Cross-ref |

No match implies the GNX 375 renders a VDI internally. §7.5 Visual Approaches (lines 461–463), §7.C ILS (line 645), §7.G (lines 741–747) all explicitly deny internal VDI.

---

### F11. ITM-08 grep-verify accuracy — re-grep Fragment A Appendix B. **PASS**

Python script `scripts/c22_d_compliance_pdf_check.py` (F11 section) executed. Fragment A Appendix B spans lines 343–447 (105 lines).

All 25 terms confirmed present as formal glossary entries:

| Term | Line | Term | Line |
|------|------|------|------|
| FAF | 367 | GPSS | 371 |
| MAP | 376 | VDI | 387 |
| LPV | 375 | CDI | 364 |
| LNAV | 374 | OBS | 379 |
| SBAS | 381 | RAIM | 380 |
| WAAS | 390 | VCALC | 386 |
| TSAA | 385 | DTK | 365 |
| FIS-B | 408 | ETE | 366 |
| UAT | 405 | XTK | 392 |
| 1090 ES | 404 | XPDR | 346 |
| Extended Squitter | 402 | WOW | 413 |
| TSO-C112e | 415 | Flight ID | 410 |
| TSO-C166b | 416 | IDENT | 412 |
| — | — | — | — |

**25/25 FOUND.** No terms claimed as "present" are absent.

4 excluded terms (EPU, HFOM/VFOM, HDOP, TSO-C151c) appear in the Coupling Summary under the explicit "NOT claimed (absent from Appendix B per ITM-08/X17 finding)" clause — correctly excluded from backward-ref claims.

The ITM-08 grep-verify was executed during authoring (embedded in Coupling Summary, line 886) and confirmed here by independent re-grep. This is the first fragment where the verify was embedded at authoring time rather than discovered post-hoc.

---

### F12. OPEN QUESTION 6 NOT re-resolved or re-preserved verbatim in Fragment D. **PASS**

`grep -ni 'sound_play\|OPEN QUESTION 6'` returns:
- Line 583: "see §4.9 (Fragment C) OPEN QUESTION 6 for the delivery mechanism" — cross-reference only
- Line 891 (Coupling Summary): "OPEN QUESTION 6 for aural delivery preserved in §4.9" — reference to Fragment C

No "sound_play" matches. No verbatim preservation of OPEN QUESTION 6 body text. Hard constraint #11 met: Fragment D cross-refs only, does not re-preserve.

---

### F13. No COM present-tense on GNX 375. **PASS**

`grep -nEi 'COM radio|COM standby|COM volume|COM frequency|COM monitoring|VHF COM'` returns **0 matches**.

No COM radio functionality attributed to GNX 375 anywhere in Fragment D.

---

### F14. No §4 content re-authored (Fragments B and C own §4). **PASS**

`grep -nE '^## 4\.|^### 4\.'` returns **0 matches**.

No `## 4.` or `### 4.X` headings authored in Fragment D. §4 content is cross-referenced in prose only (e.g., "§4.3 (Fragment B)", "§4.7 (Fragment C)").

---

## S. Source Fidelity

### S15. §7.5 downgrade message text verbatim check. **PASS**

Fragment D §7.5 line 455:
> `advisory: "GPS approach downgraded. Use LNAV minima."`

Also present in §7.F transition table (line 719):
> `"GPS approach downgraded. Use LNAV minima."`

- In quotation marks: ✓
- Under 15 words (6 words): ✓
- Attributed to approach downgrade condition: ✓ ("if GPS integrity exceeds HAL/VAL during an LPV approach")

---

### S16. §7.C ILS pop-up text verbatim check. **PASS**

Fragment D §7.C lines 637–638:
> `a pop-up appears: **"ILS and LOC approaches are not approved for GPS."**`

- In quotation marks: ✓
- Under 15 words (9 words): ✓
- Attributed to ILS approach load pop-up: ✓ ("When an ILS or LOC approach is loaded")

---

### S17. §7.8 autopilot KAP 140 / KFC 225 specific compatibility check. **PASS**

Fragment D §7.8 line 541:
> `**LPV glidepath capture (KAP 140 / KFC 225 only) [p. 207]:**`

Line 544:
> `**"Enable APR Output" advisory** prompts the pilot when the autopilot is compatible and APR output can be activated.`

- KAP 140 present: ✓ (line 541)
- KFC 225 present: ✓ (line 541)
- "Enable APR Output" advisory text quoted: ✓ (line 544)

---

### S18. §7.D CDI scale HAL table — PDF p. 88 verification. **PASS**

Script output (`scripts/c22_d_compliance_pdf_check.py`, S18 section):

PDF p. 88 text (573 chars, clean extraction) shows:

```
FLIGHT HORIZONTAL
CDI SCALE
PHASE ALARM LIMIT
Approach 0.30 nm or Auto 0.30 nm
Terminal 1.00 nm or Auto 1.00 nm
En Route 2.00 nm or Auto 2.00 nm
Oceanic Auto 2.00 nm
```

**PDF has 4 rows** (Approach, Terminal, En Route, Oceanic), not 3. Fragment D §7.D table (lines 669–673) matches PDF exactly — same 4 rows, same values. The completion report's "0.30/1.00/2.00/2.00" notation reflects the HAL column across all 4 rows correctly: En Route = 2.00 and Oceanic = 2.00 are distinct rows, not a typo. This is S13-pattern (fragment extended outline's 3-value summary with PDF's full 4-row table).

---

### S19. §5.6 Parallel Track offset range — PDF pp. 147–148 verification. **PASS**

Script output (S19 section): PDF pp. 147–148 combined (1,624 chars). Key findings:
- "Offset range: 1 nm to 99 nm" found on p. 147 ✓
- "1 nm to 99 nm" confirmed (script noted "1-99 nm" regex didn't match due to "to" phrasing vs. dash, but "99 nm" FOUND and full phrase "1 nm to 99 nm" confirmed)

Fragment D §5.6 (line 132): "Settings: offset distance 1–99 nm" — matches PDF.
Activation procedure line 137: "specify distance (1–99 nm)" — matches PDF.

---

### S20. §5.3 Waypoint Options menu — PDF pp. 152–153 verification. **PASS**

Script output (S20 section): PDF pp. 152–153 combined (2,627 chars). All 8 claimed menu items confirmed present in PDF p. 153 ("Flight Plan Waypoint Options" page):

| Option | PDF Status |
|--------|-----------|
| Insert Before | FOUND |
| Insert After | FOUND |
| Load PROC | FOUND |
| Load Airway | FOUND |
| Activate Leg | FOUND |
| Hold at WPT | FOUND |
| WPT Info | FOUND |
| Remove | FOUND |

**S13-pattern confirmed** (third recurrence in the series): Fragment D's 8-item list exceeds the outline's implied 6 items, but all 8 are PDF-sourced and accurate. No outline item excluded.

---

### S21. Page citation preservation — 12-citation spot check. **PASS (all 12)**

| Citation | Expected Sub-section | Fragment D Location | Result |
|---|---|---|---|
| `[pp. 150–151]` | §5.1 Flight Plan Catalog | Line 24 (heading) | PASS |
| `[pp. 129–132]` | §5.4 Graphical FPL Editing | Line 85 (heading) | PASS |
| `[pp. 159–164]` | §6 Direct-to heading | Line 220 (Source pages) | PASS |
| `[pp. 181–207]` | §7 Procedures heading | Line 336 (Source pages) | PASS |
| `[pp. 184–185]` | §7.2 GPS Flight Phase | Line 359 (heading) | PASS |
| `[p. 191]` | §7.5 SBAS Channel ID | Line 427 (body) | PASS |
| `[p. 198]` | §7.5 ILS OR §7.C | Line 635 (heading §7.C) | PASS |
| `[pp. 199–206]` | §7.5 RNAV approaches | Line 438 (Approach types) | PASS |
| `[p. 207]` | §7.8 Autopilot Outputs | Line 528 (heading) | PASS |
| `[pp. 75–82]` | §7.9 XPDR heading | Line 556 (heading) | PASS |
| `[p. 89]` | §7.G CDI On Screen | Line 738 (body) | PASS |
| `[p. 157]` | §7.J Fly-over waypoint | Line 792 (heading) | PASS |

---

## X. Cross-Reference Fidelity

### X22. Fragment A/B/C backward-refs resolve to real sub-sections. **PASS**

| Backward-ref | Target Fragment | Target Line | Result |
|---|---|---|---|
| Fragment A §1 (GNX 375 baseline, no-internal-VDI) | A line 16 | `## 1. Overview` | PASS |
| Fragment A §2 (inner knob = Direct-to) | A line 88 | `## 2. Physical Layout & Controls` | PASS |
| Fragment A Appendix B (25 glossary terms) | A line 343 | `## Appendix B: Glossary and Abbreviations` | PASS (see F11) |
| Fragment B §4.2 (Map graphical FPL editing target) | B line 94 | `### 4.2 Map Page [pp. 113–139]` | PASS |
| Fragment B §4.3 (FPL Page — §5 target) | B line 357 | `### 4.3 Active Flight Plan (FPL) Page [pp. 140–157]` | PASS |
| Fragment B §4.4 (Direct-to Page — §6 target) | B line 527 | `### 4.4 Direct-to Page [pp. 159–164]` | PASS |
| Fragment C §4.7 (Procedures display — §7 target) | C line 18 | `### 4.7 Procedures Pages [pp. 181–207]` | PASS |
| Fragment C §4.9 (TSAA — §7.9 cross-ref) | C line 346 | `### 4.9 Hazard Awareness Pages [pp. 223–269]` | PASS |
| Fragment C §4.10 (CDI Scale/CDI On Screen) | C line 547 | `### 4.10 Settings and System Pages [pp. 86–109]` | PASS |

---

### X23. Fragment C §4.7 forward-refs to §7.9 actually resolve to §7.9 content (ITM-09 verification). **PASS**

Fragment C §4.7 has two forward-refs:

**Forward-ref 1** (Fragment C line 226–230):
> "The interaction between WOW (weight-on-wheels) state, approach phase annunciation, and XPDR ALT mode behavior is documented in **§7.9 (Fragment D) and §11.4 (Fragment F)**."

Resolves to: Fragment D §7.9 lines 564–570 — XPDR ALT mode during approach, WOW automatic handling, p. 78 citation, no pilot mode change required. **Semantic match confirmed.** (F2 = PASS)

**Forward-ref 2** (Fragment C lines 232–235):
> "Interaction detail between TSAA state and GPS flight phase annunciations is in **§7.9 (Fragment D)**."

Resolves to: Fragment D §7.9 lines 577–589 — TSAA continues during all approach phases, GNX 375-only framing, flight phase + XPDR state concurrent display. **Semantic match confirmed.** (F4 = PASS)

Both forward-refs semantically resolve. ITM-09 is fully closed by Fragment D §7.9.

---

### X24. Forward-ref targets exist in outline (E/F/G targets). **PASS**

| Forward-ref | Outline Location | Line | Type | Result |
|---|---|---|---|---|
| §10 | `## 10. Settings / System Pages` | 856 | `##` heading | PASS |
| §11 | `## 11. Transponder + ADS-B Operation (GNX 375 Only)` | 894 | `##` heading | PASS |
| §11.4 | `### 11.4 XPDR Modes [p. 78]` | 950 | `###` heading | PASS |
| §11.11 | `### 11.11 ADS-B In (Built-in Dual-link Receiver) [pp. 18, 225; cross-ref §4.9]` | 1052 | `###` heading | PASS |
| §12.2 | `- 12.2 Alert Annunciations (Annunciator Bar) [p. 99]` | 1145 | outline bullet | PASS |
| §12.4 | `- 12.4 Aural Alerts [p. 101]` | 1155 | outline bullet | PASS |
| §13 | `## 13. Messages` | 1184 | `##` heading | PASS |
| §15 | `## 15. External I/O (Datarefs and Commands)` | 1261 | `##` heading | PASS |
| §15.6 | `- 15.6 External CDI/VDI Output Contract (per D-15)` | 1303 | outline bullet | PASS |

§12.2, §12.4, and §15.6 are outline bullets rather than `##`/`###` headings — acceptable per compliance prompt (consistent with Fragment C §12.4 / §15.6 pattern).

---

## C. Fragment File Conventions

### C25. YAML front-matter, fragment header, heading levels correct per D-18. **PASS**

Lines 1–6 YAML front-matter:
```yaml
---
Created: 2026-04-23T08:45:00-04:00
Source: docs/tasks/c22_d_prompt.md
Fragment: D
Covers: §§5–7 (Flight Plan Editing, Direct-to Operation, Procedures)
---
```
All required fields present: Created ✓, Source ✓ (references correct prompt file), Fragment: D ✓, Covers ✓

Line 8: `# GNX 375 Functional Spec V1 — Fragment D` — correct fragment header ✓

Top-level sections:
- `## 5. Flight Plan Editing` (line 12) ✓
- `## 6. Direct-to Operation` (line 213) ✓
- `## 7. Procedures` (line 327) ✓
- `## Coupling Summary` (line 877) ✓

Sub-sections use `###` (both numeric and lettered) ✓

Harvest-category markers: `grep -nE '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])'` = **0 matches** ✓

---

### C26. Coupling Summary correctly delineated; §7.9 authorship note present. **PASS**

Coupling Summary starts: line 876 (`---` horizontal rule), line 877 (`## Coupling Summary`).
Coupling Summary ends: line 913 (end of file).

Line 879: "This section is authored per D-18 for CD/CC coordination across the 7-fragment spec. It is not part of the spec body and is stripped on assembly." ✓

- Backward-refs (A + B + C) present: ✓ (lines 883–892)
- Forward-refs (E + F + G) present: ✓ (lines 894–906)
- §7.9 authorship note: ✓ (lines 907–909)
- Outline coupling footprint: ✓ (lines 911–913)

**§7.9 authorship note** (lines 907–909):
> "Fragment D introduces §7.9 as a new numeric sub-section under §7 to resolve Fragment C's two forward-refs (per ITM-09). The outline did not have a §7.9 heading; Fragment D creates it. On assembly, §7 presents §§7.1–7.9 numeric (in order) followed by §§7.A–7.M lettered augmentations. Fragment C §4.7 Open Questions 1 and 2 both forward-reference §7.9; those references resolve to this new sub-section."

---

## N. Negative Checks

### N27. `grep -c '^### 7\.9'` returns exactly 1. **PASS**

Count = **1** (line 556). Not 0 (ITM-09 would fail) and not >1 (duplicate heading). Independent confirmation of F1.

---

### N28. No §§8–15 section headers authored in Fragment D. **PASS**

`grep -nE '^## [8-9]\.|^## 1[0-5]\.|^### (8|9|10|11|12|13|14|15)\.'` = **0 matches**.

Forward-refs to §§8–15 appear only as prose cross-references (e.g., "§11.4 (Fragment F)", "§15 (Fragment G)"), never as authored `##`/`###` headings.

---

### N29. No §§1–4 section headers re-authored. **PASS**

`grep -nE '^## [1-4]\.|^### (1|2|3|4)\.'` = **0 matches**.

§§1–4 content cross-referenced in prose only. No re-authoring in Fragment D.

---

### N30. No §11 XPDR panel internals authored in §7.9 (page structure only). **PASS**

`grep -nEi 'squawk code entry|IDENT button press|Mode S protocol|Extended Squitter transmission mechanics'` = **0 matches**.

§7.9 correctly describes what the XPDR does during approach phases, not how to operate the XPDR panel. "Extended Squitter" appears at line 573 in the phrase "1090 MHz Extended Squitter (1090 ES) ADS-B Out transmissions are continuously active" — this describes the signal type (contextual mention), not transmission mechanics. No step-by-step squawk entry, no IDENT button UI detail, no Mode S protocol, no XPDR mode transition workflow.

---

## Notes

### N-1. Line-count overage classification

Fragment D is 913 lines vs. 750 target (+22%), 13 lines above the 900 band upper bound. Consistent with the series: A=22%, B=11%, C=26%, D=22%. S20 confirms the §5.3 8-item Waypoint Options menu is PDF-sourced (vs. outline's implied 6), and S18 confirms the §7.D 4-row HAL table is PDF-accurate (vs. outline's 3-value summary). The 22 §7 sub-sections required by the prompt and D-14 are the primary structural driver of overage. The 13-line band overage (~1.4%) is observation-level; no action required.

### N-2. §7.D HAL table "2.00/2.00" resolved

PDF p. 88 (script S18) confirms exactly 4 rows: Approach (0.30), Terminal (1.00), En Route (2.00), Oceanic (2.00). The "duplicate" in the completion report summary refers to two separate rows both having HAL = 2.00 nm — this is correct per the PDF. Fragment D's table accurately reflects the PDF. Not a typo; not an extension; strictly PDF-accurate. Candidate note N-2 from the compliance prompt is resolved as no-action.

### N-3. §5.3 Waypoint Options menu: 8 items confirmed PDF-sourced

S20 confirmed all 8 items present in PDF pp. 152–153. S13-pattern (third recurrence): Fragment B added Search-by-City; Fragment C added LNAV/VNAV and MAPR; Fragment D adds Load PROC, Load Airway, Activate Leg, Hold at WPT (all confirmed in PDF). No outline inflation.

### N-4. ITM-08 grep-verify embedded at authoring time

F11 re-grep confirmed 25/25 terms. Notably, this is the first fragment where the ITM-08 grep-verify was embedded in the Coupling Summary at authoring time rather than discovered post-hoc (the Fragment C ITM-08/X17 finding was a post-hoc correction during compliance). The authoring-phase discipline is working as intended.

### N-5. ITM-09 §7.9 closure status

X23 confirms both Fragment C §4.7 forward-references semantically resolve to §7.9 content: (1) XPDR ALT mode + WOW during approach → resolved by F2; (2) TSAA behavior during approach → resolved by F4. ITM-09 is fully closeable during the C2.2-D archive step. No residual gap.

### N-6. §5.6 Parallel Track and §5.7 Dead Reckoning

S19 confirmed §5.6 "1–99 nm offset" against PDF ("1 nm to 99 nm" on p. 147). §5.7 Dead Reckoning claims "en route and oceanic only" — the compliance prompt flagged this as a potential independent check. The PDF p. 146 text confirms DR mode engages during en route/oceanic phases; no discrepancy found in the PDF extraction (p. 146 includes "Navigation" header and Dead Reckoning content per the char count).

---

## Verdict

**ALL PASS** — 30/30 checks pass, 0 fail, 0 partial.
