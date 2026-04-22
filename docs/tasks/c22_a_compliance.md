---
Created: 2026-04-22T00:00:00-04:00
Source: docs/tasks/c22_a_compliance_prompt.md
---

# C2.2-A Compliance Report — GNX 375 Functional Spec V1 Fragment A

**Task ID:** GNX375-SPEC-C22-A
**Fragment under review:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`
**Compliance prompt:** `docs/tasks/c22_a_compliance_prompt.md`
**Overall verdict:** **PASS WITH NOTES**

---

## Category 1: File Structural Integrity

### Item 1 — Line count re-confirmation

```
wc -l: 545 lines
```

Expected: 545 ± 2. **PASS** (exact match; CC self-review value confirmed).

---

### Item 2 — Character encoding cleanliness

```
grep -c '\\u[0-9a-f]{4}': 0
grep for \\u00a7, \\u2014, etc.: 0 matches
```

**PASS** — no literal `\u` escape sequences. Em-dashes and section-sign characters are correctly rendered as UTF-8 Unicode code points throughout.

---

### Item 3 — U+FFFD replacement character scan

```python
# scripts/check_fragment_a_encoding.py
U+FFFD count: 0
```

**PASS** — no replacement characters. File is clean UTF-8.

---

### Item 4 — Fragment file conventions per D-18

**YAML front-matter (head -7):**

```
---
Created: 2026-04-21T15:30:00-04:00
Source: docs/tasks/c22_a_prompt.md
Fragment: A
Covers: §§1–3 + Appendix B + Appendix C
---
```

All four required fields present: `Created`, `Source`, `Fragment: A`, `Covers`. **PASS**.

**Heading counts:**

| Level | Count | Expected | Result |
|-------|-------|----------|--------|
| H1 (`# `) | 1 | Exactly 1 | PASS |
| H2 (`## `) | 6 | 6 | PASS |
| H3 (`### `) | 28 | ~25–30 | PASS |

H2 sections: `## 1. Overview`, `## 2. Physical Layout & Controls`, `## 3. Power-On, Self-Test, and Startup State`, `## Appendix B: Glossary and Abbreviations`, `## Appendix C: Extraction Gaps and Manual-Review-Required Pages`, `## Coupling Summary`. Exactly the 6 expected.

**PASS** overall.

---

## Category 2: PDF Page Reference Fidelity

### Item 5 — Page-reference spot checks

Script: `scripts/verify_fragment_a_page_refs.py`

| # | Claim | Fragment cite | PDF page(s) | Result | Notes |
|---|-------|--------------|------------|--------|-------|
| 1 | SD card: FAT32, 8–32 GB | §2.2 | p. 22 | **CONFIRMED** | PDF: "SD card in the FAT32 format, with memory capacity between 8 GB and 32 GB" |
| 2 | Inner knob push = Direct-to | §2.5, §2.7 | pp. 27–30 | **CONFIRMED** | PDF: "Inner Knob Functions GPS 175 & GNX 375 … push … Direct-to" confirmed |
| 3 | Power-off: hold Power/Home key ≥0.5 s | §3.4 | p. 39 | **CONFIRMED (minor note)** | PDF p. 39 says "Power key" (not "Power/Home key"); the composite name "Home/Power key" appears on p. 31. The ≥0.5 s threshold is exact. Fragment's "Power/Home key" is consistent with the overall PDF nomenclature. See notes. |
| 4 | Database types: Navigation, Obstacles, SafeTaxi, Basemap, Terrain | §3.5 | p. 40 | **CONFIRMED** | All five types present on p. 40 |
| 5 | Color conventions include Gray and Blue | §2.9 | p. 32 | **CONFIRMED** | PDF: "Gray … Blue" entries present |

**Overall: PASS WITH NOTE on item 3.** The 0.5 s threshold is exact; the key name discrepancy is a composite name drawn from two pages within the same PDF section and is not a content error.

---

### Item 6 — Unexpected content additions

| # | Claim | Pages checked | Result | Notes |
|---|-------|--------------|--------|-------|
| 6a | §1.1: GNC 355 has TSO-C169a VHF COM | pp. 18–20 | **CONFIRMED** | PDF p. 18: "GNC 355/355A are TSO-C169a compliant … VHF COM" |
| 6b | §2.2: SD card label facing display's left edge; spring latch | p. 22 | **CONFIRMED** | Both phrases found verbatim in PDF p. 22 |
| 6c | §2.8: Push-hold inner knob + Home/Power; camera icon in annunciator bar | p. 31 | **CONFIRMED (minor note)** | PDF says "control knob" (not "inner control knob"); camera icon + annunciator bar confirmed. "Inner" qualifier added by CC is contextually correct for a dual-concentric-knob unit. See notes. |
| 6d | §2.9: Gray and Blue beyond outline's 6 colors | p. 32 | **CONFIRMED** | Both entries present on p. 32 |
| 6e | §3.5: DB SYNC product list (GI 275, GDU TXi v3.10+, GTN v6.72, GTN Xi v20.20+) | pp. 40–52 | **CONFIRMED** | All product names found within pp. 40–52 |

**Overall: PASS WITH NOTES on 6c.** All additions are PDF-sourced.

---

## Category 3: Outline Fidelity

### Item 7 — Outline sub-section coverage

```
grep -cE '^### (1\.[1-4]|2\.[1-9]|3\.[1-5]|B\.[1-3]|C\.[1-3])': 25
```

Expected: ~25. The regex correctly identifies:
- §1: 1.1, 1.2, 1.3, 1.4 (4)
- §2: 2.1–2.9 (9)
- §3: 3.1–3.5 (5)
- B.1 (main) + B.1 additions (2 matches on B.1 pattern)
- B.2, B.3 (2)
- C.1, C.2, C.3 (3)

Total: 25. **PASS** — all 25 expected sub-sections present. No missing entries.

---

### Item 8 — Scope parity [PART] vs. [FULL]

**§3 [FULL] unit-agnostic check:**

```
grep -ni 'GNX 375 only\|375 only\|only on GNX' — matches at lines 79, 407, 443, 444
```

- Line 79: §1.4 explanatory text ("features marked 'GNX 375 only'") — definitional, not a claim
- Line 407: Appendix B.1 additions, TSAA glossary entry — glossary, not §3
- Lines 443, 444: Appendix B.3, CDI On Screen and GPS NAV Status indicator key — glossary

**No matches in §3 body (lines 240–341).** §3 scope paragraph explicitly states "identical across GPS 175, GNC 355, and GNX 375." **PASS**.

---

## Category 4: Hard-Constraint Re-Verification

### Item 9 — TSO-C112e exclusive presence

```
grep -n 'TSO-C112': lines 27, 39, 51, 415
```

All 4 occurrences: `TSO-C112e`. Line 415 (B.1 additions glossary): "TSO-C112e compliant (not TSO-C112d)." Explicit contrast present. **PASS**.

---

### Item 10 — COM absence on GNX 375

```
grep -ni 'COM radio|COM standby|COM volume|COM active frequency|VHF COM': lines 37, 50, 73, 93, 176, 236
```

All 6 matches context:

| Line | Context | Assessment |
|------|---------|-----------|
| 37 | GNC 355/355A description (sibling unit) | ✓ comparison context |
| 50 | Feature comparison table, GNC 355/355A column | ✓ comparison context |
| 73 | §1.3 Excludes: "GNX 375 has no VHF COM" | ✓ negative statement |
| 93 | §2 scope: "not COM standby tuning (GNC 355/355A behavior)" | ✓ comparison context |
| 176 | §2.5: "COM volume control. No COM-radio knob mode sequence exists on the GNX 375" | ✓ negative statement |
| 236 | §2.9: "GNX 375 has no COM radio" | ✓ negative statement |

No match specifies COM as a GNX 375 feature. **PASS**.

---

### Item 11 — No internal VDI language

```
grep -ni 'VDI': lines 71, 72, 387, 490, 534
```

| Line | Context | Assessment |
|------|---------|-----------|
| 71 | §1.3: "GNX 375 has **no internal VDI**" | ✓ negative statement |
| 72 | "output only to external CDI/VDI instruments (§7 and §15.6 per D-15)" | ✓ cross-ref to external output |
| 387 | B.1 glossary: "external instrument driven by GNX 375 output" | ✓ definition as external |
| 490 | C.2: "External CDI/VDI output datarefs (§15.6): names require design-phase research" | ✓ external output context |
| 534 | Coupling Summary: "§1.3 no-internal-VDI constraint → §7 (Procedures, C2.2-D) and §15.6" | ✓ forward-ref |

All matches are negative ("no internal VDI") or external-output context. **PASS**.

---

### Item 12 — Disambiguation gap not active

```
grep -ni 'disambiguation': lines 451, 505
```

- Line 451: Appendix C scope paragraph: "GNC 375 / GNX 375 disambiguation is resolved per D-12 and is not an active flag"
- Line 505: C.2 resolved-gap section: "Resolved gap (not active): GNC 375 / GNX 375 disambiguation — resolved per D-12"

2 matches, both in "resolved per D-12" and "not an active flag" context. **PASS**.

---

## Category 5: Glossary Completeness

### Item 13 — Appendix B XPDR/ADS-B term count

```
grep for all 15 required terms in B.1 additions section
```

All 15 terms found in B.1 additions (lines 402–416):

Mode S, Mode C, 1090 ES, UAT, Extended Squitter, TSAA, FIS-B, TIS-B, Flight ID, Squawk code, IDENT, WOW, Target State and Status, TSO-C112e, TSO-C166b.

Grep returned 16 matches total; the 16th is TSAA's cross-reference entry in B.1 main list ("see B.1 additions"), not a second definition. Exactly 15 terms in B.1 additions. **PASS**.

---

### Item 14 — Appendix B.1 aviation abbreviation count

B.1 table (lines 357–392) rows:

ACT, ADC, ADAHRS, ADS-B, AP, ARTCC, CDI, DTK, ETE, FAF, FLTA, FPL, GPS, GPSS, GSL, IAF, LNAV, LPV, MAP, MFD, NDB, OBS, RAIM, SBAS, SVID, TAF, TFR, TSAA, VCALC, VDI, VLOC, VOR, WAAS, XPDR, XTK = **35 terms**.

Expected: ≥20. Completion report claimed 35. **CONFIRMED — PASS**.

---

## Category 6: Cross-Reference Validity

### Item 15 — Forward cross-references point at valid outline sections

Sources checked: `docs/specs/GNX375_Functional_Spec_V1_outline.md` and `docs/decisions/D-18-c22-format-decision-piecewise-manifest.md`.

| Cross-reference claim | Outline section | D-18 fragment assignment | Result |
|----------------------|----------------|--------------------------|--------|
| §6 Direct-to Operation → C2.2-D | outline line 632: `## 6. Direct-to Operation` ✓ | D-18: C2.2-D = §§5–7 ✓ | **VALID** |
| §7 Procedures → C2.2-D | outline line 654: `## 7. Procedures` ✓ | D-18: C2.2-D = §§5–7 ✓ | **VALID** |
| §10.9 Crossfill → C2.2-E | outline line 876: `10.9 Crossfill [p. 97]` ✓ | D-18: C2.2-E = §§8–10 ✓ | **VALID** |
| §15.6 external CDI/VDI output → C2.2-G | outline line 1303: `15.6 External CDI/VDI Output Contract (per D-15)` ✓ | D-18: C2.2-G = §§14–15 + App. A ✓ | **VALID** |
| Appendix A → C2.2-G | D-18 explicitly: "Appendix A…natural placement: last" in C2.2-G ✓ | D-18: C2.2-G = §§14–15 + App. A ✓ | **VALID** |

All 5 forward cross-references are **VALID — PASS**.

---

### Item 16 — AMAPI cross-reference validity

```
grep -n '^## 3|^## 4|^## 11' docs/knowledge/amapi_by_use_case.md
grep -n '^### Pattern 4|6|11|15|20|21' docs/knowledge/amapi_patterns.md
```

Results:

| Ref | File | Found at | Result |
|-----|------|----------|--------|
| `amapi_by_use_case.md` §3 (§2.3) | amapi_by_use_case.md | line 64: `## 3. Pilot input — touchscreen` | **VALID** |
| `amapi_patterns.md` Pattern 4 (§2.3) | amapi_patterns.md | line 470: `### Pattern 4: Long-press button via timer` | **VALID** |
| `amapi_by_use_case.md` §4 (§2.5) | amapi_by_use_case.md | line 76: `## 4. Pilot input — knobs and rotary encoders` | **VALID** |
| `amapi_patterns.md` Pattern 11 (§2.5) | amapi_patterns.md | line 527: `### Pattern 11: Persist dial angle across sessions` | **VALID** |
| `amapi_patterns.md` Pattern 15 (§2.5) | amapi_patterns.md | line 568: `### Pattern 15: mouse_setting + touch_setting pair on dials` | **VALID** |
| `amapi_patterns.md` Pattern 20 (§2.5) | amapi_patterns.md | line 596: `### Pattern 20: Detent-type user prop for hw_dial_add` | **VALID** |
| `amapi_patterns.md` Pattern 21 (§2.5) | amapi_patterns.md | line 637: `### Pattern 21: hw_dial_add for hardware rotary encoder` | **VALID** |
| `amapi_by_use_case.md` §11 (§3.5) | amapi_by_use_case.md | line 221: `## 11. Persistence (flight plans, preferences, last-session state)` | **VALID** |
| `amapi_patterns.md` Pattern 6 (§3.5) | amapi_patterns.md | line 681: `### Pattern 6: Power-state group visibility` | **VALID** |

All 9 AMAPI references are **VALID — PASS**.

---

## Category 7: Completion Report Claim Re-Verification

### Item 17 — Re-verify completion report metric claims

| Claim | Method | Expected | Actual | Result |
|-------|--------|----------|--------|--------|
| Self-check #2: character encoding = 0 | grep literal `\u` escapes | 0 | 0 | **CONFIRMED** |
| Self-check #7: glossary term count = 15 | count B.1 additions rows | 15 | 15 | **CONFIRMED** |
| Self-check #9: YAML ✓, H1 ✓, ## ✓, ### ✓ | structural grep counts | YAML/1/6/28 | YAML/1/6/28 | **CONFIRMED** |
| "28 sub-sections" | `grep -c '^### '` globally | 28 | 28 | **CONFIRMED** |
| "35 aviation abbreviations" | B.1 table row count | 35 | 35 | **CONFIRMED** |
| "8 AMAPI terms" in B.2 | B.2 table row count | 8 | 8 (Air Manager, AMAPI, dataref, persist store, canvas, dial, button_add, triple-dispatch) | **CONFIRMED** |
| "6 Garmin terms" in B.3 | B.3 table row count | 6 | 6 (FastFind, Connext, SafeTaxi, Smart Airspace, CDI On Screen, GPS NAV Status indicator key) | **CONFIRMED** |

All completion report metric claims accurate. **PASS**.

---

## Summary of Discrepancies

Two minor notes raised; neither rises to FAIL status:

**Note 1 — Item 5, Check 3 (power-off key name):**
Fragment uses "Power/Home key" throughout (consistent with p. 31's "Home/Power key" name). PDF p. 39 says only "Power key" at that location. The 0.5 s threshold is correct. No content error; composite name is PDF-consistent across the document. **Accept as-is.**

**Note 2 — Item 6c (screenshot "inner" qualifier):**
Fragment says "push and hold the **inner** control knob"; PDF p. 31 says "Push and hold the control knob." The unit has two concentric knobs; "the control knob" on p. 31 contextually refers to the inner one (the same knob that accesses Direct-to, per §2.5/§2.7). Camera icon and key mechanics confirmed exact. **Accept as-is** — minor clarifying qualifier, not invented content.

No content invention identified across all 17 items.

---

## Line-Count Overage Assessment

| Category | Lines attributed | Source | Assessment |
|----------|-----------------|--------|-----------|
| B.1 aviation abbreviations (35 entries) | ~80 | PDF Pilot's Guide §8 (pp. 299–304) | PDF-sourced — accept |
| B.1 additions — XPDR/ADS-B terms (15 entries) | ~40 | Outline mandate | Prompt-mandated — accept |
| B.2 AMAPI terms (8 entries) | ~16 | Outline mandate | Prompt-mandated — accept |
| B.3 Garmin terms (6 entries) | ~14 | Outline mandate | Prompt-mandated — accept |
| §3.5 database management (5-type table + SYNC detail) | ~45 | PDF pp. 40–52 | PDF-sourced — accept |
| C.1 sparse pages table (13 rows) | ~20 | Outline/extraction_report.md mandate | Prompt-mandated — accept |
| Coupling Summary | ~20 | D-18 mandate | Prompt-mandated — accept |

**Compliance-side recommendation: ACCEPT overage.** All excess content is PDF-sourced or prompt-mandated. No padding, filler, or invented content detected. The 545-line count is within the 550 reassessment threshold CC flagged. CD decision: accept-as-is vs. trim is judgment call; compliance finds no grounds to recommend trimming.

---

## Overall Verdict

**PASS WITH NOTES**

17 items across 7 categories verified. All items PASS or CONFIRMED. Two minor terminology notes (power-off key name, screenshot "inner" qualifier) are PDF-consistent and do not represent content invention. All hard constraints honored, all glossary terms present, all AMAPI cross-references valid, all forward references point at correct outline sections.

This fragment is fit for archival per the CD workflow.
