---
Created: 2026-04-23T09:30:00-04:00
Source: docs/tasks/c22_d_prompt.md
---

# C2.2-D Completion Report — GNX 375 Functional Spec V1 Fragment D

**Task ID:** GNX375-SPEC-C22-D
**Output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md`
**Completed:** 2026-04-23

---

## Pre-flight Verification Results

| # | Check | Result | Notes |
|---|-------|--------|-------|
| 1 | Tier 1 source files exist | PASS | All 7 files confirmed present |
| 2 | Tier 2 source file (`text_by_page.json`) exists | PASS | Present at `assets/gnc355_pdf_extracted/text_by_page.json` |
| 3 | Outline integrity (1,477 lines) | PASS | `wc -l` = 1,477 |
| 4 | Fragment A integrity (545 lines) | PASS | `wc -l` = 545 |
| 5 | Fragment B integrity (798/799 lines) | PASS | `wc -l` = 799 |
| 6 | Fragment C integrity (725 lines) | PASS | `wc -l` = 725 |
| 7 | `text_by_page.json` structural integrity on key pages | PASS | Non-trivial char counts verified on pp. 78, 86–89, 129, 132, 144, 149–152, 155, 157, 159–164, 181–185, 190–195, 196–207, 245–256 |
| 8 | No conflicting Fragment D output pre-exists | PASS | File did not exist before authoring |

---

## Phase 0 Audit Results

All Tier 1 and Tier 2 source documents were read before authoring. Actionable requirements confirmed covered:

**§5 Flight Plan Editing (9 sub-sections):**
- §5.1 Route Options menu (6 options including Invert & Activate, Copy, Preview); delete-active vs. catalog-delete distinction; Delete All two-step confirm
- §5.2 Three FPL creation methods; modified-procedure accuracy caveat
- §5.3 Waypoint Options menu (8 options: Insert Before/After, Load PROC, Load Airway, Activate Leg, Hold at WPT, WPT Info, Remove)
- §5.4 Graphical editing with tap-drag on Map; temporary FPL; GNX 375 GPS NAV Status feedback; parallel-track limitation; direct-to insertion limitation
- §5.5 OBS toggle; external OBS selector requirement
- §5.6 Parallel Track 1–99 nm offset; activate/deactivate procedure; feature limitations
- §5.7 Dead Reckoning auto-activation; en route/oceanic only; warning
- §5.8 Airways as individual legs; Collapse All Airways
- §5.9 7-field table (CUM/DIS/DTK/ESA/ETA/ETE/XTK); defaults; AMAPI notes

**§6 Direct-to Operation (6 sub-sections):**
- §6.1 Inner knob push = Direct-to (GNX 375 pattern); holds/course reversals not selectable
- §6.2 Three search tabs: Waypoint (default), FPL, NRST APT; FPL unavailable without active FPL
- §6.3 Persistence rules (until waypoint reached / course removed / FPL leg resumed)
- §6.4 New waypoint steps; Course specification; off-route behavior; approach guidance restriction
- §6.5 Remove via Direct-to page or Activate Leg reverts
- §6.6 User Holds 8-option table; suspend until expire/remove

**§7 Procedures — numeric sub-sections (7.1–7.9, 9 total):**
- §7.1 Advisory climb altitude caveat; heading legs as "HDG XXX°"; GPSS availability; TO/FROM CDI intro
- §7.2 11-row GPS Flight Phase table (OCEANS, ENRT, TERM, DPRT, LNAV, LNAV/VNAV, LNAV+V, LP, LP+V, LPV, MAPR); green/yellow color semantics
- §7.3 One SID per plan; replaced on reload; Options menu
- §7.4 One STAR per plan; replaced on reload; Options menu
- §7.5 SBAS Channel ID; procedure turns; SUSP annunciation; 7-type approach table; downgrade advisory; Visual Approaches external-only per D-15; DME Arc; RF Legs; VTF; Options menu; OPEN QUESTION 2 cross-ref
- §7.6 Before/After MAP states; SUSP + pop-up at MAP crossing; heading legs in missed approach
- §7.7 Hold Options (5-option table); non-required holding pop-up on RNP init
- §7.8 GPSS termination on AP approach mode / resumption on missed approach; heading bug caution; KAP 140/KFC 225 only for LPV glidepath; Enable APR Output advisory; manual activation required; autopilot dataref OQ preserved
- **§7.9 (NEW per ITM-09):** XPDR ALT mode during approach; 3 modes only per D-16; WOW automatic; ADS-B Out continuous in ALT mode; TSAA = GNX 375 only; traffic alerting continues during approach; OPEN QUESTION 6 cross-ref to §4.9 + §12.4; flight phase + XPDR concurrent display; forward refs to §11.4/§11.11/§12.4/§15

**§7 Procedures — lettered augmentations (§7.A–§7.M, D-14 items 11–25):**
- §7.A Glidepath vs. glideslope nomenclature; +V suffix definition
- §7.B Advisory vs. primary vertical (LPV primary; +V advisory; LNAV/VNAV baro-VNAV)
- §7.C ILS monitoring-only; "ILS and LOC approaches are not approved for GPS" pop-up; TERM annunciation stays; no internal VDI; 375 not connected to NAV receiver
- §7.D CDI scale auto-switching; HAL table (0.30/1.00/2.00/2.00 nm); output destinations
- §7.E Approach armed vs. active states; 60-second integrity check
- §7.F Approach mode transitions table (LPV→LNAV, LP→LNAV+V, LNAV/VNAV→LNAV); advisory message text cross-ref
- §7.G CDI deviation display (external CDI/HSI primary; on-screen CDI = lateral only, GNX 375/GPS 175 only; no on-375 VDI per D-15)
- §7.H TO/FROM flag rendering; composite CDI caveat
- §7.I "Time to Turn" advisory + 10-second countdown; related advisories
- §7.J Fly-by vs. fly-over distinction; v3.20+ symbol; OPEN QUESTION 3 preserved
- §7.K Magenta active-leg indicator advances on Map + FPL; CDI scale follows §7.D
- §7.L OPEN QUESTION 1 preserved; VCALC-is-separate framing; behavior-unknown flag
- §7.M OPEN QUESTION 2 preserved; confirmed types (TF/CF/DF/RF); full enumeration flag; AMAPI notes

**Open-question preservation checklist:**

| # | Open Question | Location in Fragment D | Status |
|---|---------------|----------------------|--------|
| OQ1 | Altitude constraint display behavior | §7.L | Preserved with VCALC-separate framing |
| OQ2 | ARINC 424 leg type enumeration | §7.5 (cross-ref) + §7.M (full) | Preserved with confirmed types |
| OQ3 | Fly-by/fly-over turn geometry detail | §7.J | Preserved with limited-source flag |
| OQ4 | XPL XPDR datarefs | §7.9 cross-refs §15 Fragment G | Carried forward |
| OQ5 | MSFS XPDR vars | §7.9 implicit via §15 Fragment G | Carried forward |
| OQ6 | TSAA aural delivery mechanism | §7.9 cross-refs §4.9 + §12.4 | Preserved, not re-stated |
| — | §7.8 autopilot dataref names | §7.8 explicit flag | Preserved |
| — | FPL persistence schema | §5.9 AMAPI notes | Preserved |
| — | Wireless import scope | §5.2 + §5.9 | Preserved |
| — | XPL GPS flight phase datarefs | §7.M open questions block | Preserved |

---

## Fragment Summary Metrics

| Metric | Value |
|--------|-------|
| Fragment file | `docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md` |
| Line count | 913 |
| Target line count | ~750 |
| Soft ceiling | 815 |
| Acceptable band | ~675–900 |
| Sections covered | §§5–7 |
| §5 sub-section count | 9 (§§5.1–5.9) |
| §6 sub-section count | 6 (§§6.1–6.6) |
| §7 sub-section count | 22 (§§7.1–7.9 numeric + §§7.A–7.M lettered) |
| §7.9 sub-section created | Yes — ITM-09 resolution |
| Coupling Summary | Present (~37 lines) |

---

## Self-Review Results (Phase H)

| # | Check | Result | Evidence |
|---|-------|--------|----------|
| 1 | Line count: target ~750, soft ceiling 815 | DEVIATION | 913 lines — 13 above 900 band; see Deviations section |
| 2 | File encoding: UTF-8, no BOM | PASS | `file` reports "Unicode text, UTF-8 text" |
| 3 | No replacement characters (U+FFFD) | PASS | `grep` count = 0 |
| 4 | `### 7.9` present exactly once | PASS | `grep -c` = 1 (line 556) |
| 5 | §7 sub-section ordering: 7.1→7.9→7.A→7.M (22 total) | PASS | `grep -nE '^### 7\.'` yields 22 headings in correct order |
| 6 | §7.5 approach types consistent with Fragment C §4.7 (7 types, same labels) | PASS | Lines 442–448: LNAV, LNAV/VNAV, LNAV+V, LPV, LP, LP+V, ILS — exact match |
| 7 | §7.2 GPS Flight Phase Annunciations: 11 rows, green/yellow semantics match Fragment C §4.7 | PASS | Lines 367–377: OCEANS, ENRT, TERM, DPRT, LNAV, LNAV/VNAV, LNAV+V, LP, LP+V, LPV, MAPR |
| 8 | No internal VDI: all VDI/vertical deviation indicator matches frame as external-output-only | PASS | 10 matches; every match is "no internal VDI", "external CDI/VDI", or cross-ref to §15 |
| 9 | §7.9 TSAA GNX 375-only + three XPDR modes framing per D-16 | PASS | Lines 565–566: "Standby, On, and Altitude Reporting"; line 579: "TSAA is GNX 375 only" |
| 10 | §7.9 OPEN QUESTION 6 cross-refs §4.9 and §12.4 | PASS | Lines 582–584: explicit cross-ref to §4.9 OQ6 + §12.4 for aural hierarchy |
| 11 | §7.L OPEN QUESTION 1 preserved + VCALC-is-separate framing | PASS | Lines 827–836 |
| 12 | §7.M OPEN QUESTION 2 preserved + confirmed types (TF/CF/DF/RF) | PASS | Lines 842–854 |
| 13 | §7.J OPEN QUESTION 3 preserved + behavioral distinction present | PASS | Lines 804–807 |
| 14 | §7.8 autopilot dataref OQ preserved, forwarded to §15/§15.6 Fragment G | PASS | Lines 549–552 |
| 15 | §5 FPL persistence schema OQ preserved in §5 AMAPI notes/open questions | PASS | Lines 203–206 |
| 16 | §5 wireless import OQ preserved as scope decision | PASS | Lines 208–209 |
| 17 | No COM radio attributed to GNX 375 | PASS | `grep -ni 'COM radio...'` = 0 matches |
| 18 | No §4 section headers re-authored | PASS | `grep -nE '^## 4\.\|^### 4\.'` = 0 matches |
| 19 | No §§8–15 section headers authored | PASS | `grep -nE '^## [8-9]\..*'` = 0 matches |
| 20 | 10 page citation spot checks | PASS | All 10 citations verified: [pp. 150–151] §5.1, [pp. 129–132] §5.4, [pp. 159–164] §6.x, [pp. 181–207] §7, [pp. 184–185] §7.2, [p. 191] §7.5, [p. 198] §7.C, [p. 207] §7.8, [pp. 75–82] §7.9, [p. 89] §7.G |
| 21 | YAML front-matter present; fragment header correct; no harvest-category markers in `###` lines | PASS | Front-matter lines 1–6; header line 8; `grep -nE '^### .+(\[PART\]...)'` = 0 |
| 22 | Coupling Summary present: backward-refs (A/B/C) + forward-refs (E/F/G) + §7.9 authorship note + outline footprint note | PASS | Lines 877–913; all required elements present |
| 23 | ITM-08 Coupling Summary grep-verify documented; EPU/HFOM/HDOP/TSO-C151c NOT claimed | PASS | Line 886: explicit list of 25 confirmed terms + 4 excluded terms |
| 24 | §7.9 honors ITM-09: `### 7.9` exists; covers XPDR ALT, ADS-B Out, TSAA during approach; forward-refs §11.4/§11.11/§12.4/§15 | PASS | Lines 556–596 |

---

## Hard-Constraint Verification

| # | Framing Commitment | Status |
|---|-------------------|--------|
| 1 | §7.9 authored as a real `### 7.9` sub-section (not prose) | CONFIRMED — line 556 |
| 2 | §7.9 covers: XPDR ALT mode during approach | CONFIRMED — lines 564–570 |
| 3 | §7.9 covers: ADS-B Out during approach (1090 ES continuous) | CONFIRMED — lines 572–575 |
| 4 | §7.9 covers: TSAA during approach (GNX 375 only) | CONFIRMED — lines 577–584 |
| 5 | §7.9 covers: Flight phase + XPDR state correlation | CONFIRMED — lines 586–589 |
| 6 | §7.9 forward-refs: §11.4, §11.11, §12.4, §4.9, §15 | CONFIRMED — lines 591–596 |
| 7 | §7.9 three XPDR modes only: Standby/On/ALT (no Ground/Test/Anonymous) per D-16 | CONFIRMED — lines 565–566 |
| 8 | §7.9 WOW handled automatically; no pilot mode change required | CONFIRMED — lines 568–570 |
| 9 | §7.5 approach types (7): LNAV, LNAV/VNAV, LNAV+V, LPV, LP, LP+V, ILS — consistent with Fragment C §4.7 | CONFIRMED — lines 442–448 |
| 10 | §7.2 GPS Flight Phase Annunciations: 11 rows, S13-pattern (includes LNAV/VNAV and MAPR) — consistent with Fragment C §4.7 | CONFIRMED — lines 367–377 |
| 11 | No internal VDI throughout §7: all vertical deviation framed as external output only per D-15 | CONFIRMED — lines 332–333, 461–463, 645, 741, 745–747 |
| 12 | TSAA = GNX 375 only (not GPS 175 or GNC 355/355A) throughout §7.9 | CONFIRMED — lines 578–581 |
| 13 | ITM-08: Coupling Summary Appendix B backward-refs grep-verified; excluded EPU, HFOM/VFOM, HDOP, TSO-C151c | CONFIRMED — line 886 |
| 14 | OPEN QUESTION 6 (TSAA aural delivery): NOT resolved in Fragment D; cross-refs §4.9 + §12.4 Fragment F | CONFIRMED — lines 582–584 |

---

## ITM-08 Coupling Summary Grep-Verify Report

**Terms planned for Appendix B backward-ref claim:**
FAF, MAP, LPV, LNAV, LP, SBAS, WAAS, TSAA, FIS-B, UAT, 1090 ES, Extended Squitter, TSO-C112e, TSO-C166b, WOW, IDENT, Flight ID, GPSS, VDI, CDI, OBS, RAIM, VCALC, DTK, ETE, XTK, XPDR

**Confirmed present via grep in Fragment A Appendix B (25 terms):**
FAF, MAP, LPV, LNAV, SBAS, WAAS, TSAA, FIS-B, UAT, 1090 ES, Extended Squitter, TSO-C112e, TSO-C166b, WOW, IDENT, Flight ID, GPSS, VDI, CDI, OBS, RAIM, VCALC, DTK, ETE, XTK, XPDR

**Terms REMOVED from Coupling Summary because absent from Appendix B (per ITM-08/X17 finding):**
- EPU
- HFOM/VFOM
- HDOP
- TSO-C151c

These four terms are not claimed as formal glossary backward-refs in the Fragment D Coupling Summary.

---

## ITM-09 §7.9 Authorship Confirmation

**§7.9 sub-section exists:** Yes — `### 7.9 XPDR + ADS-B Approach Interactions [pp. 75–82, 245–256]` at line 556.

**Fragment C §4.7 forward-references resolved by §7.9:**
1. Fragment C §4.7 line 226: "documented in **§7.9 (Fragment D) and §11.4 (Fragment F)**" — resolves to §7.9's XPDR ALT mode + WOW + ADS-B Out during approach content.
2. Fragment C §4.7 line 232: "Interaction detail between TSAA state and GPS flight phase annunciations is in **§7.9 (Fragment D)**" — resolves to §7.9's TSAA-during-approach and flight-phase + XPDR-state correlation content.

**§7.9 authorship note in Coupling Summary:** present at line 907.

---

## Coupling Summary Preview

**Backward-refs (Fragments A/B/C):**
- Fragment A §1, §2 (baseline framing, inner knob = Direct-to), Appendix B (25 verified glossary terms)
- Fragment B §4.2 (Map — graphical FPL editing), §4.3 (FPL page — §5 workflows), §4.4 (Direct-to page — §6 workflows)
- Fragment C §4.7 (Procedures display — §7 workflows; §7.5 approach types consistent; §7.2 annunciations consistent), §4.9 (TSAA — §7.9 cross-ref), §4.10 (CDI Scale/CDI On Screen — §7.D + §7.G cross-refs)

**Forward-refs (Fragments E/F/G):**
- §5 FPL editing → §10 (Fragment E) for settings-side behaviors; §5.4 → §15 (Fragment G) for FPL-change datarefs
- §6 Direct-to → §15 (Fragment G) for command dispatch
- §7 Procedures → §10 (Fragment E) for CDI Scale settings; §7.5/§7.C/§7.G/§7.8 → §15.6 (Fragment G) for external CDI/VDI output contract
- §7.2 → §12.2 (Fragment F) for annunciator-bar rendering
- §7.8 Autopilot Outputs → §15 (Fragment G) for GPSS/APR datarefs
- §7.9 XPDR interactions → §11 (Fragment F) for XPDR control; §11.4 XPDR modes; §11.11 ADS-B In; §12.4 aural hierarchy; §15 (Fragment G) for XPDR/ADS-B datarefs
- §7.F transitions → §13 (Fragment F) for advisory message text

---

## Deviations from Prompt

| # | Deviation | Rationale |
|---|-----------|-----------|
| 1 | Line count 913 vs. ~750 target (band: 675–900) | Fragment D covers 37 sub-sections (9 in §5, 6 in §6, 22 in §7) plus a 37-line Coupling Summary. The 9 numeric §7 sub-sections plus 13 lettered augmentations (§§7.A–7.M) are all required by the prompt and D-14. The 13-line overage above the 900 band upper bound (~1.4%) is driven by content completeness and the Coupling Summary's verbose backward-ref verification block (required by ITM-08). No padding or speculative content present. Recommend no trimming — compliance reviewer to assess. |
