---
Created: 2026-04-25T09:15:00-04:00
Source: docs/tasks/c22_g_prompt.md
---

# C2.2-G Completion Report — GNX 375 Functional Spec V1 Fragment G

**Task ID:** GNX375-SPEC-C22-G
**Output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md`
**Completed:** 2026-04-25

---

## Pre-flight Verification Results

| Check | Description | Result |
|-------|-------------|--------|
| PF-1 | Tier 1 source files exist (outline, D-12, D-15, D-16, D-18, D-19, fragments A–F, manifest, issue index) | PASS |
| PF-2 | Tier 2 source file exists (`assets/gnc355_pdf_extracted/text_by_page.json`) | PASS |
| PF-3 | Outline line count 1,477; fragments A=545, B=798, C=725, D=913, E=829, F=606 | PASS (all match expected) |
| PF-4 | PDF structural integrity verified on key §14/Appendix A pages (18–20, 58, 75–82, 89, 97, 155–156, 158, 175–176) | PASS |
| PF-5 | No conflicting Fragment G output exists | PASS |

Note on PF-1: The D-12 filename is `D-12-pivot-gnc355-to-gnx375-primary-instrument.md` (not `D-12-gnc355-to-gnx375-pivot.md` as cited in the prompt). File exists at the corrected path; content matches expected decision.

---

## Phase 0 Audit Results

All Tier 1 documents read in full: outline §§14–15 + Appendix A, D-12, D-15, D-16, D-18, D-19.
All six archived fragments A–F read in full.
ITM-08, ITM-10, ITM-11, ITM-12 read in full from `docs/todos/issue_index.md`.
Key PDF pages read: pp. 18–20, 58, 60, 63, 72, 75–82, 89, 97, 155–156, 158, 175–176.

**Assembly-readiness audit:** All forward-refs from Fragments A–F to Fragment G content verified:
- §11.14 (Fragment F) → §14 Persistent State ✓ resolved in §14.1
- §12.2 (Fragment F) → §15.6 External CDI/VDI Output Contract ✓ resolved
- §11 + §13.8 (Fragment F) → §15.7 Altitude Source Dependency ✓ resolved
- Multiple fragments → §15 datarefs/variables ✓ resolved in §15.1–§15.5
- Multiple fragments → Appendix A ✓ resolved in A.1–A.5

**Open-question preservation checklist:**
| OQ | Description | Status |
|----|-------------|--------|
| OQ4 | XPL XPDR dataref names (transponder_code, mode, ADS-B Out, pressure altitude) | PRESERVED in §15.3 block, verbatim per requirement |
| OQ5 | MSFS XPDR SimConnect variables (TRANSPONDER CODE:1, STATE, IDENT; FS2020 vs. FS2024; Pattern 23) | PRESERVED in §15.5 block, verbatim |
| §15.6 CDI/VDI output dataref flag | XPL dataref names for lateral/vertical deviation output require design-phase research | PRESERVED as design-phase flag in §15.6 |
| §14.1 FPL catalog serialization | Air Manager persist API is scalar; encoding scheme required | PRESERVED as open question in §14.1 and §14.3 |
| §14.3 active direct-to persistence | Device behavior unverified; may or may not persist across power cycle | PRESERVED as open question in §14.3 |
| §15.7 altitude source | External ADC/ADAHRS required; advisory trigger on loss | FULLY SPECIFIED per D-16; no open question needed |
| Appendix A.4 GNX 375A variant | No variant documented in current Pilot's Guide | PRESERVED as placeholder |

---

## Fragment Summary Metrics

| Metric | Value |
|--------|-------|
| Fragment file | `docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md` |
| Line count | **443** |
| Target line count | ~300 (D-19) |
| Prompt-adjusted target | ~410 (per prompt §"Per-section page budget") |
| Soft ceiling | ~450 |
| Acceptable band | 270–450 |
| Sections covered | §§14–15 + Appendix A |
| §14 sub-section count | **6** (14.1–14.6) ✓ |
| §15 sub-section count | **7** (15.1–15.7) ✓ |
| Appendix A sub-section count | **5** (A.1–A.5) ✓ |
| Coupling Summary line count | **105** (target 95–105 per ITM-12) ✓ |

Line count of 443 vs. prompt-adjusted target of 410 = +8% overage. Classification: within acceptable band; overage is prose expansion in §15 dataref tables (more rows than outline estimated) and Appendix A.3 adds table. No padding.

---

## Self-Review Results (Phase G)

| # | Check | Result | Detail |
|---|-------|--------|--------|
| 1 | Line count 270–450 | PASS | 443 lines; within acceptable band |
| 2 | No unicode escape sequences | PASS | grep found 0 matches |
| 3 | No U+FFFD replacement chars | PASS | verified |
| 4 | No §§1–13 / Appendix B/C headers | PASS | grep returned 0 matches |
| 5 | §14 = 6 sub-sections | PASS | `grep -cE '^### 14\.'` = 6 |
| 6 | §15 = 7 sub-sections | PASS | `grep -cE '^### 15\.'` = 7 |
| 7 | Appendix A = 5 sub-sections | PASS | `grep -cE '^### A\.'` = 5 |
| 8 | Top-level headings = 3 | PASS | `grep -cE '^## 14\.|^## 15\.|^## Appendix A'` = 3 |
| 9 | §14.1 has squawk/mode/Flight ID/ADS-B Out/data field; replaces COM State | PASS | All 5 items in §14.1 table; "replaces COM State" in heading and prose |
| 10 | §15.6 has no on-screen VDI, external, LPV, LP+V, LNAV+V, vertical deviation output | PASS | All 6 terms present; D-15 no-internal-VDI framing explicit |
| 11 | §15.7 has external, ADC, ADAHRS, altitude encoder | PASS | All present; no internal altitude computation framing |
| 12 | Three XPDR modes only (Standby, On, Altitude Reporting) | PASS | No Ground/Test/Anonymous mode references in §15 datarefs |
| 13 | OQ4 preserved verbatim | PASS | Full OQ4 block in §15.3 with candidate names and design-phase flag |
| 14 | OQ5 preserved verbatim | PASS | Full OQ5 block in §15.5 with MSFS variable names and FS2020/2024 note |
| 15 | Appendix A.1 has D-12, GNX 375 primary, GNC 355 deferred | PASS | D-12 cited explicitly; "deferred" appears; §A.1 heading references D-12 |
| 16 | Appendix A.5 feature matrix ~18 rows | PASS | 19 feature rows covering all required categories |
| 17 | No COM present-tense on GNX 375 | PASS | All COM references are in A.3 sibling-comparison context or §14.1 "replaces COM State" framing |
| 18 | Page citations spot-check (5 citations) | PASS | [pp. 58, 89] in §14.2; [pp. 18–20] in A.2/A.3/A.5; [p. 89] in A.2; [p. 158] in A.2; [p. 155] in A.3 |
| 19 | YAML front-matter correct; Fragment G | PASS | `Fragment: G`, `Covers: §§14–15 + Appendix A` present |
| 20 | No harvest-category markers in `###` lines | PASS | 0 matches |
| 21 | Coupling Summary present; 90–110 lines; prose-per-ref format | PASS | 105 lines; 14 backward-ref blocks with 2–4 sentences each |
| 22 | Forward-refs block states "closing fragment" | PASS | "closing fragment" appears at line 421 in forward-refs block |
| 23 | ITM-08 grep-verify executed; exclusions honored | PASS | 27 confirmed-present terms; EPU/HFOM/VFOM/HDOP/TSO-C151c NOT claimed |
| 24 | Intra-fragment cross-refs present (3 blocks) | PASS | §14.1↔§15; §15.6↔§15.1; §15.7↔§14/§15.1 all present in Coupling Summary |
| 25 | Assembly readiness note in outline footprint | PASS | "7-fragment decomposition per D-18 §'Task partition'" and "assembly-ready" explicit |

---

## Hard-Constraint Verification

| # | Constraint | Status |
|---|-----------|--------|
| 1 | ITM-08 Coupling Summary glossary-ref grep-verify | PASS — 27 confirmed; 5 excluded |
| 2 | ITM-12 Coupling Summary prose-per-ref, 90–110 lines | PASS — 105 lines; 2–4 sentences per ref |
| 3 | No forward-refs in Fragment G | PASS — forward-refs block explicitly states "closing fragment; no forward-refs" |
| 4 | §14.1 = XPDR State with 5 items; three modes per D-16; no COM | PASS |
| 5 | §15 does not re-author §11 XPDR behavior | PASS — §15 scopes to interface names/types/contracts only; cross-refs §11 for behavior |
| 6 | §15.6 External CDI/VDI Output Contract per D-15 (no on-screen VDI; vertical deviation output-only; LPV/LP+V/LNAV+V) | PASS |
| 7 | §15.7 Altitude Source Dependency per D-16 (external ADC/ADAHRS; no internal; advisory trigger) | PASS |
| 8 | OQ4 preserved verbatim in §15 | PASS |
| 9 | OQ5 preserved verbatim in §15 | PASS |
| 10 | Appendix A.1 D-12 context (pilot guide covers GPS 175/GNC 355/GNX 375; GNX 375 primary; GNC 375 corrected; 355 deferred) | PASS |
| 11 | Appendix A.2 GPS 175 lack list (5 items) + identical list | PASS |
| 12 | Appendix A.3 GNC 355 lacks (7 items) + adds (9 items) + identical list | PASS |
| 13 | Appendix A.5 feature matrix table (~18 features) | PASS — 19 rows |
| 14 | No sibling-unit consistency drift (all A.2/A.3 claims consistent with Fragments A–F) | PASS |
| 15 | No §4/§7/§10/§11 re-authoring (grep returns 0 matches) | PASS |
| 16 | No COM present-tense on GNX 375 | PASS |
| 17 | Assembly readiness — section numbering continuous; 3 top-level headings | PASS |

---

## ITM-08 Coupling Summary Grep-Verify Report

**Planned for claiming:** All terms used in Fragment G spec body that appear in Appendix B.

**Confirmed present (27 terms) — grep location:**

| Term | Appendix B location |
|------|---------------------|
| Mode S | B.1 additions, line ~402 |
| 1090 ES | B.1 additions |
| UAT | B.1 additions |
| Extended Squitter | B.1 additions |
| TSAA | B.1 + B.1 additions |
| FIS-B | B.1 additions |
| TIS-B | B.1 additions |
| Flight ID | B.1 additions |
| Squawk code | B.1 additions |
| IDENT | B.1 additions |
| WOW | B.1 additions |
| Target State and Status | B.1 additions |
| TSO-C112e | B.1 additions |
| TSO-C166b | B.1 additions |
| CDI | B.1 |
| VDI | B.1 |
| GPSS | B.1 |
| WAAS | B.1 |
| SBAS | B.1 |
| LNAV | B.1 |
| LPV | B.1 |
| RAIM | B.1 |
| ADC | B.1 |
| ADAHRS | B.1 |
| Connext | B.3 |
| dataref | B.2 |
| persist store | B.2 |

**NOT claimed (absent from Appendix B per prior fragment compliance findings):**
EPU, HFOM, VFOM, HDOP, TSO-C151c — absent in Appendix B, confirmed by grep. Exclusion consistent with C2.2-C X17, C2.2-D F11, C2.2-E C1, C2.2-F C1.

---

## ITM-12 Coupling Summary Format Verification

**Format:** Prose-per-ref (2–4 sentences per backward-ref). NOT compact single-line bullets. ✓

**Total Coupling Summary line count:** 105 lines. Within 95–105 target. ✓

**Example refs with sentence counts:**

| Ref | Sentence count | Example (abbreviated) |
|-----|---------------|----------------------|
| Fragment F §11.14 | 3 sentences | "§11.14 was the forward-ref target... Fragment G §14.1 delivers... §14.1 is fully consistent..." |
| Fragment A Appendix B | 3 sentence-groups | Title line + confirmed-present list + NOT-claimed line |
| Fragment E §§8–10 | 3 sentences | "Six Fragment E sub-sections... Each resolves in Fragment G §14.2–§14.6... Fragment E §10.1 and §10.11..." |

All 14 backward-ref blocks verified to contain 2–4 substantive sentences (or equivalent prose lines). No compact single-line bullets in the Coupling Summary.

---

## D-15 / D-16 Framing Verification

**D-15 (no-internal-VDI):**
- §15.6 explicitly states: "The GNX 375 has no on-screen VDI of any kind."
- §15.6 cites Pilot's Guide p. 205: "Only external CDI/VDI displays provide vertical deviation indications."
- Vertical deviation output row in §15.6 table is bolded and explicitly labeled "D-15: no on-screen VDI — external VDI only."
- Approaches covered: LPV, LP+V, LNAV+V ✓

**D-16 (three XPDR modes; external altitude source):**
- §14.1 table: "Three modes only per D-16: Standby / On / Altitude Reporting; no Ground, Test, or Anonymous modes."
- §15.7: "The GNX 375 does not compute pressure altitude internally." External ADC/ADAHRS sourcing and advisory trigger fully specified.

---

## D-12 Appendix A Context Verification

- A.1 states GNX 375 is primary per **D-12** (explicit citation).
- A.1 states "D-02 reference to 'GNC 375' was a nomenclature error resolved by D-12."
- A.1 states "GNC 355 implementation is **deferred** per D-12."
- A.1 references the shelved GNC 355 outline for eventual resumption.
- All four D-12 context requirements confirmed present. ✓

---

## Assembly-Readiness Report

**Forward-refs from Fragments A–F to Fragment G content — resolution status:**

| Forward-ref source | Points to | Resolved in Fragment G |
|-------------------|-----------|----------------------|
| Fragment A §1.3 | §15.6 External CDI/VDI | ✓ §15.6 authored |
| Fragment B §4.3 | §14 persistence | ✓ §14.3 FPL catalog |
| Fragment C §4.7 | §15.6 GPSS/VDI contract | ✓ §15.6 authored |
| Fragment C §4.10 | §14.2 + §15.6 | ✓ both authored |
| Fragment D §5/§6 | §15 datarefs | ✓ §15.1–§15.5 |
| Fragment D §7.8/§7.G | §15.6 GPSS/APR | ✓ §15.6 |
| Fragment D §7.9 | §15 XPDR datarefs | ✓ §15.1–§15.5 |
| Fragment E §9.4 | §14 1,000-waypoint persist | ✓ §14.3 |
| Fragment E §10.1/§10.3/§10.6/§10.7/§10.8/§10.9/§10.10 | §14 persist | ✓ §14.2–§14.6 |
| Fragment E §10.11/§10.12 | §15.1 datarefs | ✓ §15.1 |
| Fragment F §11.14 | §14.1 XPDR State | ✓ §14.1 |
| Fragment F §11.13/§13.9 | §15.7 altitude dependency | ✓ §15.7 |
| Fragment F §12.2 | §15.6 CDI/VDI output | ✓ §15.6 |

**Duplicate heading check:** No §§14–15 or Appendix A headings appear in Fragments A–F. No duplicate headings on concatenation.

**7-fragment decomposition completeness:** Fragments A–G cover §§1–15, Appendix A, Appendix B, Appendix C — all 18 divisions per D-18 §"Task partition". Zero overlap, zero gaps.

---

## Deviations from Prompt

| # | Deviation | Rationale |
|---|-----------|-----------|
| 1 | D-12 filename used was `D-12-pivot-gnc355-to-gnx375-primary-instrument.md`, not `D-12-gnc355-to-gnx375-pivot.md` as cited in the prompt | The actual file has a different name than the prompt specifies; contents are the same D-12 decision. No functional impact. |
| 2 | Fragment G total line count is 443 vs. prompt-adjusted ~410 target (+8%) | Overage is in §15 dataref tables (18 rows vs. ~15 estimated) and Appendix A.3 adds table (10 rows). All content is outline-mandated or decision-required. No padding. Classification: within acceptable band 270–450. |
| 3 | Coupling Summary is exactly 105 lines (at the ceiling of 95–105 target) | All 14 backward-ref blocks required substantive prose. Three-sentence-per-block format produces the line density needed. No content cut. |
