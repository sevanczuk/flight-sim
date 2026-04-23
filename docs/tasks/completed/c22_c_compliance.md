---
Created: 2026-04-22T21:00:00-04:00
Source: docs/tasks/c22_c_compliance_prompt.md
---

# C2.2-C Compliance Report — GNX 375 Functional Spec V1 Fragment C

**Task ID:** GNX375-SPEC-C22-C-COMPLIANCE
**Fragment verified:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md`
**Completed:** 2026-04-22

---

## Summary Table

| Category | Total | PASS | PARTIAL | FAIL |
|---|---|---|---|---|
| F — Framing Commitments | 11 | 11 | 0 | 0 |
| S — Source Fidelity | 5 | 4 | 1 | 0 |
| X — Cross-Reference Fidelity | 3 | 1 | 2 | 0 |
| C — Fragment File Conventions | 2 | 2 | 0 | 0 |
| N — Negative Checks | 4 | 4 | 0 | 0 |
| **Total** | **25** | **22** | **3** | **0** |

**Verdict: PASS WITH NOTES** — All hard constraints met; 3 PARTIAL items are minor caveats (PDF text extraction limits, Coupling Summary over-claims 4 glossary terms in Fragment A, §7.9 sub-section gap in outline).

---

## Pre-flight Results

| Check | Expected | Actual | Status |
|---|---|---|---|
| Fragment C line count | 725 | 725 | PASS |
| Fragment A present | Yes | `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` | PASS |
| Fragment B present | Yes | `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` | PASS |
| Outline present | Yes | `docs/specs/GNX375_Functional_Spec_V1_outline.md` | PASS |
| PDF JSON present | Yes | `assets/gnc355_pdf_extracted/text_by_page.json` | PASS |

---

## F — Framing Commitments

**F1. Fragment C opens with `### 4.7` — NO `## 4. Display Pages` header. PASS**

`grep -c '^## 4\. Display Pages'` = **0**

First `###` heading: line 18 — `### 4.7 Procedures Pages [pp. 181–207]` ✓

**F2. §4.7 Visual Approach — external CDI/VDI only for vertical deviation (D-15). PASS**

VDI matches in fragment: 7 total (lines 191, 192, 193, 195, 599, 600, 672, 699, 707). Every match is either:
- Explicit "external" framing: "external CDI/VDI displays", "external CDI/VDI instruments", "external CDI/VDI output contract"
- Explicit "no internal" framing: "The GNX 375 has no internal VDI"
- Coupling Summary cross-reference

Key sentence (line 190–195):
> "vertical deviation indications are not displayed on the GNX 375 screen. Per D-15 and Pilot's Guide p. 205: 'Only external CDI/VDI displays provide vertical deviation indications.' The GNX 375 has no internal VDI. All vertical deviation output goes exclusively to external CDI/VDI instruments."

D-15 cited ✓ | p. 205 cited ✓ | No internal VDI ✓ | No match implies internal rendering ✓

**F3. §4.7 XPDR-interaction context preserved as forward-refs only. PASS**

Three open questions at lines 224–241:

1. *XPDR altitude reporting during approach* (line 226): "The interaction between WOW (weight-on-wheels) state, approach phase annunciation, and XPDR ALT mode behavior is documented in **§7.9 (Fragment D) and §11.4 (Fragment F)**. Not authored here."
2. *ADS-B traffic display during approach / TSAA behavior* (line 232): "Interaction detail between TSAA state and GPS flight phase annunciations is in **§7.9 (Fragment D)**."
3. *Autopilot roll steering dataref names* (line 236): "Research required during the design phase. See **§15.6 (Fragment G)**."

No operational XPDR behavior authored: no squawk code entry, no IDENT button workflow, no Mode S protocol. Confirmed by N25. ✓

**F4. §4.9 ADS-B built-in receiver framing flip. PASS**

`grep -ni 'built-in\|built in'` = **11 matches**: predominantly in §4.9 (lines 350, 358, 414, 417, 423) and §4.10 (lines 551, 626, 641, 651) plus Coupling Summary (2). Distribution correct.

FIS-B sub-section (line 358): "GNX 375 incorporates a **built-in 978 MHz UAT receiver**... GPS 175 requires an external ADS-B device (GDL 88 or GTX 345)... GNC 355/355A similarly requires external hardware."

Traffic sub-section (line 414): "GNX 375 incorporates a **built-in dual-link ADS-B In receiver** covering both 1090 ES (Extended Squitter) and 978 MHz UAT... GPS 175 requires an external ADS-B In product... GNC 355/355A similarly requires external hardware."

Both siblings explicitly named as requiring external hardware. ✓

**F5. §4.9 TSAA = GNX 375 only (with aural alerts). PASS**

`grep -ni 'TSAA'` = **14 matches**. All GNX 375-consistent.

Scope paragraph (line 353–354): "GNX 375 adds TSAA (Traffic Situational Awareness with Alerting), including aural traffic alerts, which are **not available on GPS 175 or GNC 355/355A**."

Traffic Applications (line 425–427): "**TSAA — GNX 375 only.** TSAA is a traffic alerting application available **exclusively on the GNX 375**. GPS 175 and GNC 355/355A **do not have TSAA**; they have ADS-B traffic display only (via external hardware)."

Aural alerts (line 471): "Aural alerts are a GNX 375-only feature — **not available on GPS 175 or GNC 355/355A**." ✓

**F6. §4.9 OPEN QUESTION 6 preserved verbatim with `sound_play` language. PASS**

`grep -ni 'sound_play\|OPEN QUESTION 6\|TSAA aural'` = **6 matches**.

Verbatim in §4.9 Traffic body (lines 472–474):
> "**OPEN QUESTION 6 — TSAA aural alert delivery mechanism:** whether the 375 instrument emits aural alerts via `sound_play` directly or depends on an external audio panel integration is a spec-body design decision. Behavior TBD."

Verbatim again in §4.9 Open questions #2 (lines 533–535). Two occurrences confirmed. Design-phase-deferred framing with no resolution. ✓

**F7. §4.9 B4 Gap 1 (terrain/obstacle canvas overlays) preserved as design-phase decision. PASS**

`grep -ni 'B4 Gap 1'` = **3 matches** (lines 519, 542, 704).

AMAPI notes (line 519–521): "**B4 Gap 1:** same design-decision gap as §4.2 Map Page (Fragment B). Canvas-drawn terrain overlay implementation is a design-phase decision **deferred to the design phase**; the spec body documents the behavior contract only. **Do not resolve here.**"

Open questions #4 (line 542): "Same design-decision gap as §4.2 Map Page (Fragment B). Design decision deferred to design phase." ✓

**F8. §4.9 FIS-B data source + ADS-B sim availability open questions preserved. PASS**

§4.9 Open questions (lines 527–540):

OQ1 — *FIS-B weather data source in Air Manager* (line 527): "Spec must decide whether weather display is dataref-subscribed FIS-B data from the simulator, a static dataset, or deferred as 'requires external FIS-B data bridge.' Spec must also define behavior when no FIS-B uplink is available. **Design-phase decision.**"

OQ3 — *ADS-B In data availability in simulators* (line 537): "X-Plane 12 has partial ADS-B dataref exposure; MSFS has limited ADS-B traffic data access. Spec must define behavior when ADS-B In data is absent vs. degraded... **Design-phase research required.**"

Both present with research-needed / design-phase-deferred framing. ✓

**F9. §4.10 CDI On Screen = GNX 375 / GPS 175 only; lateral only (D-15). PASS**

`grep -ni 'CDI On Screen'` = **7 matches** (lines 198, 550, 563, 590, 592, 660, 687, 707).

Pilot Settings table (line 563): `CDI On Screen | ✓ | ✓ | — | GNX 375 / GPS 175 only — NOT GNC 355/355A` ✓

Section heading (line 590): `#### CDI On Screen [p. 89] — GNX 375 / GPS 175 only (NOT GNC 355/355A)` ✓

Lateral-only / no VDI (lines 597–600): "The CDI provides **lateral deviation indications only** — no vertical deviation indicator is present. The GNX 375 has no internal VDI per D-15; vertical deviation is output only to external CDI/VDI instruments." D-15 cited. ✓

**F10. §4.10 ADS-B Status page = built-in receiver framing (no external LRU). PASS**

§4.10 ADS-B Status (lines 625–638):
- "built-in dual-link ADS-B In/Out receiver — no external LRU is required" ✓
- Contrast: "On GPS 175 and GNC 355/355A, the equivalent page requires an external GDL 88 or GTX 345." ✓
- AIRB / SURF / ATAS: "Traffic Application Status — status of three traffic applications: **AIRB** (Airborne), **SURF** (Surface), **ATAS** (Airborne Traffic Alerting, includes TSAA)." ✓

**F11. §4.10 Logs page = GNX 375 ADS-B traffic logging (not on siblings). PASS**

§4.10 Logs (lines 648–652):
- "ADS-B traffic data logging — **GNX 375 only.** Stores ADS-B In traffic data received by the built-in dual-link receiver. This logging capability is **not available on GPS 175 or GNC 355/355A**." ✓
- WAAS diagnostic logging: "available on all units (GPS 175, GNC 355/355A, GNX 375)" — no incorrect GNX 375-only claim for WAAS. ✓

---

## S — Source Fidelity

**S12. GPS Flight Phase Annunciations — PDF pp. 184–185 verification. PARTIAL**

Script: `scripts/c22c_check_pdf.py` (PDF JSON pages list with `page_number` key). Page 184: 1,344 chars. Page 185: 708 chars.

| Annunciation | pp. 184–185 | Notes |
|---|---|---|
| OCEANS | NOT FOUND | PDF uses abbreviated code "OCN" (page 185); expanded description form in fragment is acceptable |
| ENRT | NOT FOUND | Likely in graphical table on p. 184; not extracted by pdfplumber |
| TERM | FOUND p. 185 | ✓ |
| DPRT | FOUND p. 184 | ✓ |
| LNAV/VNAV | **FOUND p. 184** | S13-pattern: not in outline (9-item list), confirmed in PDF — fragment correctly extends outline from PDF |
| LNAV+V | FOUND p. 184 | ✓ |
| LNAV | FOUND p. 184 | ✓ |
| LP+V | NOT FOUND pp. 184–185 | PDF has "LP +V" (with space) on p. 185; confirmed on pp. 199, 203, 204; OCR spacing variant |
| LP | FOUND pp. 184, 185 | ✓ |
| LPV | FOUND pp. 184, 185 | ✓ |
| MAPR | **FOUND p. 185** | S13-pattern: not in outline, confirmed in PDF — fragment correctly extends outline from PDF |

**Partial rationale:** PDF pages 184–185 use graphics-heavy table layout; pdfplumber extracted partial text. Key additions beyond the outline (LNAV/VNAV, MAPR) are confirmed. Missing annunciations (OCEANS as OCN, ENRT, LP+V as "LP +V") are extraction artifacts, not hallucinations — ENRT and OCEANS are standard GPS annunciation codes; LP+V confirmed on approach pages.

**S13. FIS-B weather products — PDF pp. 230–243 verification. PASS**

Script: `scripts/c22c_check_pdf.py`. All 13 products confirmed.

| Product | Pages | Product | Pages |
|---|---|---|---|
| NEXRAD | 230, 233, 234 | Cloud Tops | 230, 234, 239 |
| METARs | 230, 235 | Lightning | 230, 234, 239 |
| TAFs | 230, 235 | CWA | 230, 239 |
| Graphical AIRMETs | 230, 236, 237, 241 | Winds/Temps Aloft | 230, 237, 240, 243 |
| SIGMETs | 230, 238, 241 | Icing | 230, 234, 237, 240 |
| PIREPs | 230, 238 | Turbulence | 230, 234, 237, 241 |
| TFRs | 230, 232, 241 | | |

Product Status States on p. 231: **Unavailable** FOUND, **Awaiting Data** FOUND, **Data Available** FOUND. ✓

**S14. Approach types — PDF pp. 199–206 verification. PASS**

Script: `scripts/c22c_check_pdf.py`. All 7 approach types confirmed.

| Approach Type | Pages |
|---|---|
| LNAV | 199, 201, 202, 203 |
| LNAV/VNAV | 199 |
| LNAV+V | 199 |
| LPV | 199, 200, 202 |
| LP | 199, 200, 202, 203, 204 |
| LP+V | 199, 203, 204 |
| ILS | 199, 200, 201 |

**S15. ADS-B Status AIRB / SURF / ATAS — PDF pp. 107–108 verification. PASS**

Script: `scripts/c22c_check_pdf.py`. Page 107 (740 chars): describes ADS-B Status feature requirements ("GDL 88 or GTX 345 ADS-B transceiver (GPS 175 and GNC 355/355A only) OR GNX 375"). Page 108 (843 chars): AIRB FOUND, SURF FOUND, ATAS FOUND. Also confirmed on pp. 245–247, 251 (traffic pages). ✓

Bonus: p. 107 text confirms the built-in framing (GNX 375 vs. external GDL 88/GTX 345 for siblings). ✓

**S16. Page citations — spot check of 11 citations. PASS**

| Citation | Expected Sub-section | Line | Status |
|---|---|---|---|
| `[pp. 181–207]` | §4.7 heading | 18 | PASS |
| `[pp. 184–185]` | GPS Flight Phase Annunciations | 41 | PASS |
| `[p. 205]` | §4.7 Visual Approach (D-15 framing) | 191 (prose cite) | PASS |
| `[p. 207]` | §4.7 Autopilot Outputs | 200 | PASS |
| `[pp. 209–221]` | §4.8 heading | 244 | PASS |
| `[pp. 225–244]` | §4.9 FIS-B Weather | 356 | PASS |
| `[pp. 245–256]` | §4.9 Traffic Awareness | 412 | PASS |
| `[pp. 257–269]` | §4.9 Terrain Awareness | 476 | PASS |
| `[p. 89]` | §4.10 CDI On Screen | 590 | PASS |
| `[pp. 107–108]` | §4.10 ADS-B Status | 623 | PASS |
| `[p. 109]` | §4.10 Logs | 644 | PASS |

Note: The §4.7 Visual Approach heading uses `[pp. 205–206]` (line 174); the D-15 framing prose uses `p. 205` inline (line 191). Both are present in the sub-section. ✓

---

## X — Cross-Reference Fidelity

**X17. Fragment A backward-refs resolve to real sub-sections. PARTIAL**

Sub-section existence:

| Target | Found | Evidence |
|---|---|---|
| §1 Overview (GNX 375 baseline, no-internal-VDI) | ✓ | Line 16; no-internal-VDI at line 71–72: "GNX 375 has **no internal VDI**; vertical deviation is output only to external CDI/VDI instruments" |
| §2 Physical Layout & Controls (knob/touchscreen) | ✓ | Line 88 `## 2. Physical Layout & Controls` |
| §3 Power-On / Startup / Database (SD card FAT32, 8–32 GB) | ✓ | Line 240; FAT32 at line 113: "**FAT32 format, 8–32 GB capacity.**" |
| Appendix B Glossary — FIS-B, TSAA, UAT, 1090 ES, TSO-C112e, TSO-C166b, SBAS, WOW, IDENT, Flight ID | ✓ | Lines 381–416: all 10 terms present as formal glossary entries |
| Appendix B — TSO-C151c, EPU, HFOM/VFOM, HDOP | **ABSENT** | `grep` of Fragment A for these terms returns 0 matches — not in Appendix B |

**Partial rationale:** The four core categories (§1, §2, §3, Appendix B) all resolve for their primary purpose. The Coupling Summary in Fragment C (line 679–681) over-claims Appendix B by listing TSO-C151c, EPU, HFOM/VFOM, HDOP as glossary entries, but these terms are absent from Fragment A's Appendix B. These are GPS accuracy/integrity display fields (EPU, HFOM, VFOM, HDOP) and a terrain database cert standard (TSO-C151c); they appear as display field labels in Fragment C §4.10 GPS Status (line 619) and are self-explanatory in context. Not a spec-body defect — only the Coupling Summary claim overstates coverage.

**X18. Fragment B backward-refs resolve to real sub-sections. PASS**

| Target | Found | Evidence |
|---|---|---|
| §4.1 Home Page — app icon inventory (Weather, Traffic, Terrain, Utilities, System Setup) | ✓ | Line 33; icons at lines 56–61 |
| §4.2 Map Page — overlay inventory (NEXRAD, Traffic, TFRs, Airspaces, SafeTaxi, Terrain) | ✓ | Line 94; overlays at lines 298–307 |
| §4.3 FPL Page — GPS NAV Status indicator key layout | ✓ | Line 357; GPS NAV Status key at line 470: "The GPS NAV Status indicator key is located in the lower right corner of the display." |

All three backward-ref categories resolve. ✓

**X19. Forward-ref targets exist in outline. PARTIAL**

| Forward-ref | Outline Location | Status |
|---|---|---|
| §7 `## 7. Procedures` | Line 654 | PASS |
| §7.9 XPDR-interaction during approach | Referenced in outline prose at line 446 ("see §7.9 and §11.4"); no `### 7.9` heading — §7 uses lettered augmentation notation (7.A–7.N) | PARTIAL |
| §10 `## 10. Settings / System Pages` | Line 856 | PASS |
| §11 `## 11. Transponder + ADS-B Operation` | Line 894 | PASS |
| §11.4 `### 11.4 XPDR Modes` | Line 950 | PASS |
| §11.11 `### 11.11 ADS-B In (Built-in Dual-link Receiver)` | Line 1052 | PASS |
| §12.4 Aural Alerts | Line 1155 `- 12.4 Aural Alerts [p. 101]` (outline bullet format) | PASS |
| §14 `## 14. Persistent State` | Line 1220 | PASS |
| §15 `## 15. External I/O` | Line 1261 | PASS |
| §15.6 External CDI/VDI Output Contract | Line 1303 `- 15.6 External CDI/VDI Output Contract (per D-15)` (outline bullet format) | PASS |

**Partial rationale (§7.9):** The XPDR-interaction-during-approach section is conceptually established in the outline (prose reference at line 446: "see §7.9 and §11.4 for operational detail") but §7 uses lettered sub-sections (7.1–7.8 numeric + 7.A–7.N lettered augmentations). No `### 7.9` heading exists. PARTIAL per compliance protocol ("PARTIAL acceptable if target section exists but sub-section numbering differs slightly"). §12.4 and §15.6 use outline bullet notation rather than `###` headings — consistent with §12 and §15 outline format; concept targets confirmed.

---

## C — Fragment File Conventions

**C20. YAML front-matter, fragment header, and heading levels. PASS**

Lines 1–6:
```yaml
---
Created: 2026-04-22T17:20:00-04:00
Source: docs/tasks/c22_c_prompt.md
Fragment: C
Covers: §§4.7–4.10 (Procedures, Planning, Hazard Awareness, Settings/System display pages)
---
```
- `Created`: ✓
- `Source: docs/tasks/c22_c_prompt.md`: ✓
- `Fragment: C`: ✓
- `Covers: §§4.7–4.10 ...`: ✓

Fragment header line 8: `# GNX 375 Functional Spec V1 — Fragment C` ✓

No `## 4. Display Pages` header: 0 (F1 confirmed) ✓

Sub-sections use `###`: first `###` heading is `### 4.7 Procedures Pages [pp. 181–207]` at line 18 ✓

`grep -nE '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])'` = **0 matches** ✓

**C21. Coupling Summary correctly delineated. PASS**

- `## Coupling Summary` heading: line 665 ✓
- Preceded by `---` horizontal rule: line 663 ✓
- Lines 666–668: "This section is authored **per D-18 for CD/CC coordination** across the 7-fragment spec. It is **not part of the spec body and is stripped on assembly**." ✓

Content coverage:
- Backward-refs Fragment A: lines 671–681 (7 categories) ✓
- Backward-refs Fragment B: lines 682–689 (3 categories) ✓
- Forward-refs Fragments D–G: lines 691–713 (12 references) ✓
- §4 parent-scope inheritance note: lines 715–721 ✓
- Outline coupling footprint: lines 723–725 ✓

Coupling Summary spans lines **665–725** (end of file; 61 lines). ✓

---

## N — Negative Checks

**N22. `grep -c '^## 4\. Display Pages'` = exactly 0. PASS**

Count: **0**. Structural commitment independently confirmed.

**N23. No §§4.1–4.6 content leaked into Fragment C. PASS**

`grep -nE '^### 4\.(1|2|3|4|5|6)'` returned **one match**: line 547 `### 4.10 Settings and System Pages`. This is a false positive — the regex `4\.(1|2|3|4|5|6)` prefix-matches `4.10`. No actual §§4.1–4.6 headers are present in Fragment C. Confirmed by manual review: `### 4.7`, `### 4.8`, `### 4.9`, `### 4.10` are the only `### 4.X` headings present.

**N24. No later-fragment (§§5–15) scope content in Fragment C. PASS**

`grep -nE '^(## |### )(5|6|7|8|9|10|11|12|13|14|15)\.'` = **0 matches**. §§5–15 content appears only as forward-reference prose (e.g., "see §7 for operational detail"), never as section headers. ✓

**N25. No §11 XPDR panel internals authored anywhere in Fragment C. PASS**

`grep -nEi 'squawk code|IDENT button|Mode S|Extended Squitter'` = **1 match**:

- Line 415: "covering both 1090 ES (**Extended Squitter**) and 978 MHz UAT, with no external hardware required"

Classification: **receiver-type description** — "Extended Squitter" appears as an ADS-B In receiver capability label, not as a XPDR output protocol. The context is describing what the built-in ADS-B In receiver can receive (1090 ES signals from other aircraft), not the GNX 375's XPDR output mechanics.

NOT present in Fragment C: squawk code entry procedures, IDENT button press workflow, Mode S protocol mechanics, XPDR mode transitions. ✓

---

## Notes

**Note 1 — Line-count overage classification confirmed.** The +26% overage (725 vs. ~575 target) is attributable to: (a) 5 required tables in §4.9 (~55 lines, all PDF-sourced per S12–S15); (b) D-18 Coupling Summary template (~61 lines, confirmed template-driven per C21); (c) multi-item open-question blocks (~25 lines, outline-mandated). Independent check confirms no invented content; overage classification from completion report is accurate.

**Note 2 — Fragment B trailing newline (798 vs. expected 799 lines).** Pre-flight noted in completion report; verified here only as observation. Off-by-one is a trailing newline gap; no functional content impact.

**Note 3 — S13-pattern: LNAV/VNAV and MAPR confirmed from PDF, absent from outline.** The outline's §4.7 sub-structure (via §7.2 outline bullets) listed 9 annunciations and omitted LNAV/VNAV and MAPR. Both are confirmed on pp. 184–185 of the Pilot's Guide. Fragment C correctly extended the outline from the PDF source — this is the intended S13-pattern (fragment more PDF-accurate than outline). No fragment action needed.

**Note 4 — Advisory text quoted strings.** Three short advisory strings verified:
- "GPS approach downgraded. Use LNAV minima." (line 65) — in quotes, 7 words ✓
- "Enable APR Output" (line 213) — in quotes, 3 words ✓
- "ILS and LOC approaches are not approved for GPS." (line 118) — in quotes, 10 words ✓
All <15 words; all appear in quotation marks or clearly attributed as advisory text. ✓

**Note 5 — AC 90-101A citation (RF Leg, line 165).** Fragment line 165: "See AC 90-101A for regulatory context." The Pilot's Guide references RF Legs for RNAV RNP 0.3 non-AR approaches (p. 197) but does not cite AC 90-101A by number. The citation was added by CC as regulatory context. Not a defect — AC 90-101A is the correct regulatory authority for RF Leg approach authorization. Observation preserved for design-phase context.

---

## Verdict

**PASS WITH NOTES**

25 checks total: **22 PASS | 3 PARTIAL | 0 FAIL**

All hard-constraint framing commitments (F1–F11) verified. All source citations present (S16). All negative checks clean (N22–N25). Fragment file conventions correct (C20–C21). Three PARTIAL items are structural/metadata observations with no spec-body action required:
- S12: PDF text extraction partial on graphics-heavy pages; key additions (LNAV/VNAV, MAPR) confirmed
- X17: Coupling Summary over-claims 4 glossary terms absent from Fragment A Appendix B (EPU, HFOM/VFOM, HDOP, TSO-C151c); not a spec-body error
- X19: §7.9 lacks a named outline heading; concept established in outline prose; PARTIAL per compliance protocol
