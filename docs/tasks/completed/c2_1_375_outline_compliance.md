---
Created: 2026-04-21T00:00:00-04:00
Source: docs/tasks/c2_1_375_outline_compliance_prompt.md
---

# Compliance Report: GNX375-SPEC-OUTLINE-01

**Task ID:** GNX375-SPEC-OUTLINE-01
**Output verified:** `docs/specs/GNX375_Functional_Spec_V1_outline.md`
**Completion report:** `docs/tasks/c2_1_375_outline_completion.md`
**Verification date:** 2026-04-21

---

## Overall Verdict: PASS WITH NOTES

16 of 17 items PASS. 1 item has a numeric discrepancy (item 12: §4 sub-section estimates sum to ~1,090, not ~740 as the §4 top-level estimate states). The discrepancy is in spec-body length estimates only — it does not affect outline content correctness, spec completeness, or prompt compliance. Flagged for CD triage per D-07.

---

## Category 1: File Structural Integrity

### Item 1 — Line count verification
**Result: PASS**

```
1477 docs/specs/GNX375_Functional_Spec_V1_outline.md
```

Actual count: 1,477 lines. Completion report claimed 1,477. Exact match (0-line delta).

---

### Item 2 — Character encoding cleanliness (Turn 22 bug precedent)
**Result: PASS**

```
grep -c '\\u[0-9a-f]{4}': 0
grep for \\u00a7, \\u2014, \\u2192, \\u2248: no matches
```

Zero literal `\u` escape sequences anywhere in the file. Turn 22 bug did not recur.

---

### Item 3 — Corrupted character artifact in §4.9
**Result: PASS**

Byte-level scan (PowerShell): U+FFFD replacement char count = 0.

The `§��10` mojibake that appeared in CD Phase 1's read was a viewer artifact; the file itself is clean. AMAPI cross-refs block confirms at line 209 with proper text. No repair needed.

---

### Item 4 — Provenance header present
**Result: PASS**

```
---
Created: 2026-04-21T00:00:00-04:00
Source: docs/tasks/c2_1_375_outline_prompt.md
---
```

Both `Created:` and `Source:` fields present in YAML front matter per convention.

---

## Category 2: Completion Report Spot-Check Re-Verification

### Item 5 — Page-reference spot checks (all 5)
**Result: PASS — all 5 CONFIRMED**

| # | Page | Claim | Verified |
|---|------|-------|---------|
| 1 | p. 40 | FAT32 format + Basemap/Navigation/Obstacles/SafeTaxi/Terrain database types | PDF text: "supports SD cards in the FAT32 format only, with capacities ranging between 8 GB and 32 GB"; database table lists exactly those 5 types — **CONFIRMED** |
| 2 | p. 114 | GPS 175/GNX 375 default user fields: distance, ground speed, DTK+TRK, distance/bearing to destination | PDF text: "GPS 175/GNX 375: • distance • ground speed • desired track and track • distance/bearing from destination airport" — **CONFIRMED** |
| 3 | p. 200 | "Time to Turn advisory" with 10-second countdown | PDF text: "Time to Turn advisory annunciates and 10 second timer counts down as the distance approaches zero" — **CONFIRMED** |
| 4 | p. 78 | XPDR modes: Standby / On / Altitude Reporting only; air/ground auto-handling | PDF text: mode table shows exactly three modes; "During Altitude Reporting mode, all aircraft air/ground state transmissions are handled via the transponder and require no pilot action" — **CONFIRMED** |
| 5 | p. 290 | "Traffic Advisories, GNX 375" header with 5 conditions | PDF text: header present; lists 1090ES receiver fault, ADS-B traffic alerting function inoperative, ADS-B traffic function inoperative, Traffic/FIS-B functions inoperative, UAT traffic/FIS-B receiver fault — all 5 — **CONFIRMED** |

---

## Category 3: Harvest-Map Fidelity Extension

### Item 6 — [FULL] section fidelity check (§5 and §8)
**Result: PASS — both FAITHFUL**

**§5 Flight Plan Editing [FULL]:**
- Title: identical in both outlines ✓
- Source pages: [pp. 144–157] — identical ✓
- Estimated length: ~200 lines — identical ✓
- Sub-section count: 9 (§5.1–5.9) — identical ✓
- All page references within sub-sections identical to 355 outline ✓
- No COM-related deletions (expected — §5 has no COM content) ✓
- Minor scope wording difference: 375 says "Identical across GPS 175, GNC 355, and GNX 375"; not a content drift ✓
- Verdict: **FAITHFUL**

**§8 Nearest Functions [FULL]:**
- Title: identical in both outlines ✓
- Source pages: [pp. 179–180] — identical ✓
- Estimated length: ~60 lines — identical ✓
- Sub-section count: 5 (§8.1–8.5) — identical ✓
- All page references within sub-sections identical to 355 outline ✓
- AMAPI cross-refs: identical ✓
- No COM-related deletions (expected — Nearest has no COM content) ✓
- Minor prose condensation in 8.2 (single-line format vs. bullet list); semantically equivalent ✓
- Verdict: **FAITHFUL**

---

### Item 7 — [355] omission check (extended)
**Result: PASS**

**COM Standby / COM Radio refs grep:**
```
grep -ni 'COM Standby|COM Radio Operation|COM active frequency|COM1_RADIO_SWAP|XFER key'
```
Matches at lines 28, 69, 103, 185, 896, 1367, 1368 — all in one of these contexts:
- Summary statement: "§4.11 COM Standby Control Panel (~60 lines) is dropped entirely" (historical)
- Negative statement: "NOT COM standby tuning" (line 103)
- Omission statement: "§4.11 (COM Standby Control Panel) is omitted — the 375 has no COM radio." (line 185)
- Historical reference: "Replaces §11 COM Radio Operation from GNC 355." (line 896)
- Comparison table (Appendix A.3): §4.11 listed as GNC 355-only feature (lines 1367–1368)

No COM ACTIVE FREQUENCY, COM1_RADIO_SWAP, or XFER key matches anywhere.

**§11 sub-sections:** All 14 sub-sections (§11.1–11.14) are XPDR/ADS-B-titled. No `§11.x COM` sub-sections present. ✓

**§12.9:** Line 1168 — "**12.9 XPDR Annunciations (GNX 375 — replaces COM Annunciations)**" ✓

**§13.9:** Line 1201 — "**13.9 XPDR Advisories (GNX 375 — replaces §13.9 COM Radio Advisories)**" ✓

**§14.1:** Line 1229 — "**14.1 XPDR State (GNX 375 — replaces §14.1 COM State)**" ✓

**§15 COM frequency datarefs:** Zero matches for `COM ACTIVE FREQUENCY`, `COM1_RADIO_SWAP`, or `com_frequency`. ✓

All omissions correct. No COM features specified as present on GNX 375 anywhere.

---

## Category 4: Open-Question Flag Verification

### Item 8 — 6 open questions properly flagged (not resolved)
**Result: PASS**

All 6 open questions confirmed flagged. No speculative language found (no "the 375 likely…" patterns).

| # | Key phrase | Instances found | Language quality |
|---|-----------|----------------|-----------------|
| 1 | Altitude constraints on FPL legs | Lines 316, 773–776, 1467 | "behavior unknown; research needed during design phase" — non-speculative ✓ |
| 2 | ARINC 424 leg type handling | Lines 705, 777–779, 1468 | "full supported set not enumerated; research-needed or limited-source feature" — non-speculative ✓ |
| 3 | Fly-by vs. fly-over turn geometry | Lines 769, 797, 1469 | "behavioral turn-geometry details not prominently documented; research needed" — non-speculative ✓ |
| 4 | Exact XPL dataref names (XPDR) | Lines 1123, 1323, 1462 | "require verification against XPL datareftool during design phase" — non-speculative ✓ |
| 5 | MSFS SimConnect variable behavior | Lines 1124, 1324, 1462 | "differ between FS2020 and FS2024; design-phase research required" — non-speculative ✓ |
| 6 | TSAA aural alert delivery mechanism | Lines 539, 1128, 1158, 1470 | "spec-body design decision; behavior TBD" — non-speculative ✓ |

**Note:** An additional OPEN QUESTION instance at line 720 covers autopilot coupling XPL dataref names. This is not one of the 6 numbered open questions in the completion report but is appropriately flagged as a design-phase open question. Not a violation.

---

## Category 5: Cross-Reference Validity

### Item 9 — Internal cross-reference validity (5 sampled)
**Result: PASS**

Cross-reference sample and verification:

| Ref cited | Found at | Format | Valid |
|-----------|----------|--------|-------|
| `see §5` (line 297) | Line 577: `## 5. Flight Plan Editing` | `##` section header | ✓ |
| `see §7.9` (lines 446–447) | Line 781: `**7.9 Approach-phase XPDR + ADS-B interactions**` | Bold sub-section within §7 | ✓ |
| `cross-ref §12.4` (line 523) | Line 1155: `- 12.4 Aural Alerts [p. 101]` | Sub-structure bullet in §12 | ✓ |
| `see §11.10` (line 1033) | Line 1041: `### 11.10 Remote Control via G3X Touch` | `###` sub-section header | ✓ |
| `cross-ref §11.13` (line 1075) | Line 1085: `### 11.13 XPDR Advisory Messages` | `###` sub-section header | ✓ |

**Note:** §7.9 and §12.4 are formatted as bold text (`**7.9...**`) and sub-structure bullets (`- 12.4...`) rather than `###` headers. They are unambiguously identifiable as cross-reference targets; no dangling references.

All 5 sampled cross-references VALID.

---

### Item 10 — Decision-doc cross-reference validity
**Result: PASS**

```
ls docs/decisions/D-01*.md ... D-16*.md
docs/decisions/D-01-project-scope.md
docs/decisions/D-11-c2-delivery-format-deferred-outline-first.md
docs/decisions/D-12-pivot-gnc355-to-gnx375-primary-instrument.md
docs/decisions/D-13-c2-2-format-decision-still-deferred-for-375.md
docs/decisions/D-14-procedural-fidelity-coverage-additions-turn-19-audit.md
docs/decisions/D-15-gnx375-display-architecture-internal-vs-external-turn-20-research.md
docs/decisions/D-16-gnx375-xpdr-adsb-scope-corrections-turn-21-research.md
```

All 7 decision files cited in the outline exist on disk. ✓

---

## Category 6: Numeric Consistency

### Item 11 — Section length estimates vs. top-level summary
**Result: PASS WITH NOTES**

Top-level section estimates (§§1–15 + appendices):

| Section | Estimate |
|---------|---------|
| §1 Overview | ~50 |
| §2 Hardware Interface | ~150 |
| §3 Setup and Configuration | ~80 |
| §4 Display Pages | ~740 |
| §5 Flight Plan Editing | ~200 |
| §6 Direct-to Operation | ~80 |
| §7 Procedures | ~350 |
| §8 Nearest Functions | ~60 |
| §9 Waypoint Information | ~120 |
| §10 Settings | ~200 |
| §11 XPDR + ADS-B | ~200 |
| §12 Audio, Alerts, Annunciators | ~100 |
| §13 Advisory Messages | ~150 |
| §14 Persistent State | ~50 |
| §15 External I/O | ~50 |
| Appendix A | ~150 |
| Appendix B | ~65 |
| Appendix C | ~35 |
| **Total** | **~2,830** |

Header claims ~2,860. Difference: 30 lines. Within ±100. **CONSISTENT.**

**Note — §4 discrepancy:** The outline navigation-aids block (line 26) says "Section 4 (Display pages, ~800 lines)" but §4's own `**Estimated length.**` field says ~740. This 60-line discrepancy between the nav-aids summary and the section's own estimate is pre-existing and acknowledged in the compliance prompt. Not a new finding; flagged for item 12 detail.

---

### Item 12 — §4 sub-section length sum
**Result: DISCREPANCY**

Sub-section estimated lengths:

| Sub-section | Estimate |
|-------------|---------|
| §4.1 Home/App Switcher | ~50 |
| §4.2 Map Page | ~200 |
| §4.3 Active FPL Page | ~150 |
| §4.4 Direct-to Page | ~60 |
| §4.5 Waypoint Information Pages | ~100 |
| §4.6 Nearest Pages | ~50 |
| §4.7 Procedures Pages | ~200 |
| §4.8 GPS Status Page | ~80 |
| §4.9 Hazard Awareness Pages | ~120 |
| §4.10 CDI On Screen | ~80 |
| **Sum** | **~1,090** |

§4 top-level estimate: ~740. Sub-section sum: ~1,090. **Discrepancy: ~350 lines.**

The sum exceeds the top-level estimate by approximately 350 lines. The largest contributor is §4.7 Procedures Pages (~200 lines), which covers pp. 181–207 (26 source pages) and is appropriately large, but the cumulative effect of all sub-section estimates significantly exceeds the §4 header.

**Assessment:** This is a numeric inconsistency in spec-body length estimates — the sub-section estimates were likely set independently and not reconciled against the §4 header estimate. It does not affect outline content correctness or spec completeness. No content errors; estimates-only issue. Flagging for CD triage.

---

## Category 7: Prompt Directive Negative Checks

### Item 13 — No on-screen VDI specified
**Result: PASS**

All VDI occurrences (lines 28, 436, 656, 701, 735, 755, 1263, 1303, 1309, 1311, 1325, 1326, 1463, 1474) are in exactly one of the four permitted categories:
- **(a) Explicit negative:** "no internal VDI is specified anywhere" (line 28); "No VDI on the 375" (line 735); "No on-375 VDI of any kind (per D-15)" (line 755); "No on-screen VDI specified for GNX 375" (line 1311)
- **(b) D-15 cross-reference:** "per D-15" appears in lines 436, 656, 701, 1263, 1309
- **(c) Output-contract language:** "External CDI/VDI Output Contract" (line 1303); "Vertical deviation output to external VDI" (line 1309); output dataref names for external VDI (lines 1325–1326)
- **(d) Open-question:** dataref names for external VDI output require design-phase research (line 1463)

Zero instances treat VDI as an on-375 display element. ✓

---

### Item 14 — No Ground / Test / Anonymous modes
**Result: PASS**

Relevant matches:
- Line 28: "Ground/Test/Anonymous modes **do not exist** on the GNX 375" — negative statement ✓
- Line 952: "Three modes only (no Ground mode, no Test mode in pilot UI — per D-16 and p. 78)" — explicit negative ✓
- Line 1092: "Transponder is operating in ground test mode." — this is a **quoted advisory message string** (one of 9 XPDR advisory conditions from pp. 283–284), documenting a transponder-generated status message, NOT a pilot-selectable mode. Context: §11.13 XPDR Advisory Messages. ✓
- Line 1127: "Anonymous mode: **does NOT apply** to GNX 375 (GPS 175 / GNC 355 + GDL 88 only; confirmed p. 84)" — negative statement ✓
- Line 1203: "ground test mode" — in §13.9 XPDR Advisories listing advisory conditions, summarizing the same advisory message as line 1092. Advisory message context only. ✓

No instance specifies Ground, Test, or Anonymous as a pilot-selectable XPDR mode on the GNX 375. ✓

---

## Category 8: Appendix Fidelity

### Item 15 — Appendix A baseline flip
**Result: PASS**

- Title: "Appendix A: Family Delta — GNX 375 as Baseline" (line 1330) — references "GNX 375 as Baseline" ✓
- Scope (line 1332): "GNX 375 is the baseline; GPS 175 and GNC 355/355A are the comparison units." ✓
- A.2 (line 1344): "GPS 175 vs. GNX 375 differences" — GPS 175 compared against GNX 375 ✓
- A.3 (line 1357): "GNC 355/355A vs. GNX 375 differences" — GNC 355 compared against GNX 375 ✓
- GNC 375/GNX 375 disambiguation: line 63 "None; resolved per D-12" — not present as a flag ✓

---

### Item 16 — Appendix B glossary additions
**Result: PASS**

All 11 required 375-specific terms confirmed present:

| Term | Line | Entry |
|------|------|-------|
| Mode S | 1407 | "Mode S: selective addressing transponder protocol (ICAO Annex 10)" |
| 1090 ES | 1409 | "1090 ES: 1090 MHz Extended Squitter — ADS-B Out transmission format" |
| UAT | 1410 | "UAT: Universal Access Transceiver — 978 MHz ADS-B/FIS-B reception band" |
| Extended Squitter | 1411 | "Extended Squitter: continuous 1090 MHz ADS-B Out broadcast from Mode S transponder" |
| TSAA | 1412 | "TSAA: Traffic Situational Awareness with Alerts — ADS-B-based traffic alerting application" |
| FIS-B | 1413 | "FIS-B: Flight Information Services – Broadcast — UAT weather/NOTAM datalink" |
| TIS-B | 1414 | "TIS-B: Traffic Information Service – Broadcast — ADS-B re-broadcast of radar targets" |
| Flight ID | 1415 | "Flight ID: transponder-broadcast aircraft identification (callsign or registration)" |
| squawk code | 1416 | "Squawk code: 4-octal-digit ATCRBS identity code (0000–7777)" |
| IDENT | 1417 | "IDENT: transponder special position identification pulse (SPI); 18-second duration on GNX 375" |
| TSO-C112e | 1420 | "TSO-C112e: FAA Technical Standard Order for Mode S transponder compliance; Level 2els, Class 1" |

All 11 terms present. ✓

---

### Item 17 — Appendix C disambiguation gap dropped
**Result: PASS**

Three matches for disambiguation grep — all in negative/resolved context:
- Line 63 (outline nav-aids): "None; GNC 375/GNX 375 disambiguation resolved per D-12 (GNX 375 is the correct product name)." ✓
- Line 1436 (Appendix C scope): "GNC 375/GNX 375 disambiguation gap resolved per D-12 — dropped." ✓
- Line 1471 (Appendix C C.2): "~~GNC 375/GNX 375 disambiguation~~ — resolved per D-12; dropped" (struck through) ✓

Not present as an active flag anywhere. ✓

---

## Summary of Discrepancies for CD Triage

| Item | Category | Severity | Description |
|------|----------|----------|-------------|
| 12 | Numeric consistency | Minor | §4 sub-section estimates sum to ~1,090; §4 top-level estimate says ~740. Discrepancy of ~350 lines. Both the nav-aids header (~800) and the section estimate (~740) are inconsistent with the sub-section sum. Estimates-only issue; no outline content incorrect. |

---

## Per-Item Result Summary

| # | Category | Item | Result |
|---|----------|------|--------|
| 1 | File integrity | Line count | PASS |
| 2 | File integrity | Unicode escape sequences | PASS |
| 3 | File integrity | U+FFFD replacement chars | PASS |
| 4 | File integrity | Provenance header | PASS |
| 5 | Spot checks | 5 page references | PASS |
| 6 | Harvest fidelity | [FULL] §5 and §8 | PASS |
| 7 | Harvest fidelity | [355] omissions | PASS |
| 8 | Open questions | 6 flags non-speculative | PASS |
| 9 | Cross-refs | Internal refs (5 sampled) | PASS |
| 10 | Cross-refs | Decision doc files | PASS |
| 11 | Numeric | Total spec estimate sum | PASS WITH NOTES |
| 12 | Numeric | §4 sub-section sum | DISCREPANCY |
| 13 | Directive | No on-screen VDI | PASS |
| 14 | Directive | No Ground/Test/Anon modes | PASS |
| 15 | Appendices | Appendix A baseline flip | PASS |
| 16 | Appendices | Appendix B glossary terms | PASS |
| 17 | Appendices | Appendix C disambiguation dropped | PASS |
