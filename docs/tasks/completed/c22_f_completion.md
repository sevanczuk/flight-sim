---
Created: 2026-04-24T12:00:00-04:00
Source: docs/tasks/c22_f_prompt.md
---

# C2.2-F Completion Report — GNX 375 Functional Spec V1 Fragment F

**Task ID:** GNX375-SPEC-C22-F
**Output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md`
**Completed:** 2026-04-24

---

## Pre-flight Verification Results

| # | Check | Result | Notes |
|---|-------|--------|-------|
| 1 | All Tier 1 source files exist (11 files) | PASS | All present |
| 2 | Tier 2 source file `text_by_page.json` exists | PASS | Present |
| 3 | Outline integrity (1,477 lines expected) | PASS | 1477 lines confirmed |
| 4 | Fragment A integrity (545 lines) | PASS | 545 lines confirmed |
| 5 | Fragment B integrity (798/799 lines) | PASS | 798 lines confirmed |
| 6 | Fragment C integrity (725 lines) | PASS | 725 lines confirmed |
| 7 | Fragment D integrity (913 lines) | PASS | 913 lines confirmed |
| 8 | Fragment E integrity (829 lines) | PASS | 829 lines confirmed |
| 9 | `text_by_page.json` structural integrity (43 key pages) | PASS | All 43 key pages have non-trivial content (100+ chars); all rated "clean" by extraction report |
| 10 | No conflicting part_F.md exists | PASS | File absent prior to authoring; confirmed |

---

## Phase 0 Audit Results

All Tier 1 and Tier 2 source documents read in full. D-16 re-read before authoring §11. ITM-08 and ITM-10 read from issue_index.md. PDF pages 75–82, 98–101, 104–106, 225, 244, 272–291 read and verified.

**Actionable requirements confirmed covered:** all 36 outline sub-sections (14 for §11, 9 for §12, 13 for §13) expanded with PDF-sourced prose; all D-16 framing constraints honored; ITM-08 discipline applied.

**Open-question preservation checklist:**

| Open Question | Status in Fragment F |
|--------------|---------------------|
| OPEN QUESTION 4 (XPL XPDR dataref names) | Preserved in §11.14 open-questions block; §11.5/§11.6/§11.8 AMAPI notes note "subject to OPEN QUESTION 4"; forward-ref §15 Fragment G |
| OPEN QUESTION 5 (MSFS XPDR SimConnect variables) | Preserved in §11.14 open-questions block; same forward-ref §15 |
| OPEN QUESTION 6 (TSAA aural delivery mechanism) | §12.4 cross-refs §4.9 Fragment C for OQ6; verbatim OPEN QUESTION 6 block NOT re-preserved in Fragment F |
| §11.10 Remote G3X Touch v1 out-of-scope | Explicitly flagged: "not implemented in the v1 Air Manager instrument" |
| §11.11 simulator ADS-B In availability | Flagged as design-phase decision; forward-ref §15 |

---

## Fragment Summary Metrics

| Metric | Value |
|--------|-------|
| Fragment file | `docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md` |
| Line count | **606** |
| Target line count | ~540 |
| D-19 acceptable band | ~485–720 |
| Soft ceiling | ~650 |
| Overage from target | +12% (within series baseline; below soft ceiling) |
| Sections covered | §§11–13 |
| §11 sub-section count | **14** (11.1–11.14) |
| §12 sub-section count | **9** (12.1–12.9) |
| §13 sub-section count | **13** (13.1–13.13) |
| §11.13 advisory count | **9** (4 from pp. 283–284 + 5 from p. 290) |
| §13.9 advisory count | 4 (cross-ref to §11.13 items 1–4) |
| §13.11 advisory count | 5 (cross-ref to §11.13 items 5–9) |

---

## Self-Review Results (Phase G — 25 Checks)

| # | Check | Result | Detail |
|---|-------|--------|--------|
| 1 | Line count | PASS | 606 lines — within acceptable band (485–720); below soft ceiling (650) |
| 2 | Character encoding (no unicode escapes) | PASS | `grep -c '\\u[0-9a-f]{4}'` → 0 |
| 3 | Replacement chars (no U+FFFD) | PASS | Python byte-level count → 0 |
| 4 | No §§1–10/14–15/Appendix headers | PASS | `grep -nE '^## [1-9]$|...'` → 0 matches |
| 5 | §11 has 14 sub-sections | PASS | `grep -cE '^### 11\.'` → 14 |
| 6 | §12 has 9 sub-sections | PASS | `grep -cE '^### 12\.'` → 9 |
| 7 | §13 has 13 sub-sections | PASS | `grep -cE '^### 13\.'` → 13 |
| 8 | §11.4 three modes only | PASS | Ground/Test/Anonymous mentioned only in "There is no Ground mode, no Test mode in the pilot UI, and no Anonymous mode" denial context; 3-row mode table: Standby/On/Altitude Reporting |
| 9 | §11.10 v1 out-of-scope flag explicit | PASS | "not implemented in the v1 Air Manager instrument" present |
| 10 | §11.11 built-in dual-link framing | PASS | "built-in dual-link ADS-B In receiver — no external hardware required" |
| 11 | §11.13 = 9 advisory conditions | PASS | Two tables: 4 rows (pp. 283–284) + 5 rows (p. 290) = 9 total |
| 12 | §13.9 cross-refs §11.13 items 1–4 (no re-enumeration) | PASS | §13.9 lists 4 items with "(§11.13 item N)" cross-refs; no verbatim advisory text re-authored in §13.9 |
| 13 | §13.11 cross-refs §11.13 items 5–9 + pp. 288–289 distinction | PASS | "NOT applicable to the GNX 375" explicit; pp. 288–289 named as GPS 175/GNC 355 + GDL 88 set |
| 14 | §12.4 TSAA aural on GNX 375 | PASS | "Aural traffic alerts are present on the GNX 375 via the TSAA application" |
| 15 | §12.4 OPEN QUESTION 6 cross-ref only | PASS | Cross-ref to §4.9 Fragment C present; verbatim OQ6 text NOT reproduced in §12.4 body |
| 16 | §12.9 XPDR Annunciations replaces COM | PASS | "The GNX 375 has no VHF COM radio; all annunciation elements here are transponder-related"; squawk/mode/Reply/IDENT/failure elements present; SBY/ON/ALT — three modes only per D-16 |
| 17 | §13.9 XPDR Advisories replaces COM Radio Advisories | PASS | Header and body explicitly state replacement of GNC 355 COM Radio Advisories |
| 18 | No COM present-tense on GNX 375 | PASS | All "COM radio" / "VHF COM" mentions are in "has no VHF COM radio" or "replaces COM X from GNC 355" context; zero "the GNX 375 has [COM feature]" statements |
| 19 | External altitude source framing consistent | PASS | External altitude source (ADC/ADAHRS) referenced in §11.1, §11.3, §11.8, §11.13 item 1, §13.8, Coupling Summary §11 backward-refs; no prose implies internal computation |
| 20 | Page citation preservation (10 citations sampled) | PASS | All 10 confirmed: [p. 75] at §11.2, [p. 76] at §11.3, [p. 77] at §11.8, [p. 78] at §11.4, [p. 79] at §11.5, [p. 80] at §11.6, [p. 81] at §11.7, [p. 82] at §11.10/§11.12, [pp. 283–284] at §11.13/§13.9, [p. 290] at §11.13/§13.11 |
| 21 | YAML front-matter correct; fragment header "Fragment F" | PASS | `Fragment: F`, `Covers: §§11–13`; header `# GNX 375 Functional Spec V1 — Fragment F` on line immediately after YAML |
| 22 | No harvest-category markers in `###` lines | PASS | `grep -nE '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])'` → 0 matches |
| 23 | Coupling Summary section present | PASS | `## Coupling Summary` present at end; backward-refs (A/B/C/D/E), forward-refs (G + intra-fragment), outline footprint note all present |
| 24 | ITM-08 grep-verify executed | PASS | All 20 candidate terms verified-present in Fragment A Appendix B via grep; NOT claimed: EPU, HFOM, VFOM, HDOP, TSO-C151c (explicitly listed in Coupling Summary "NOT claimed" section); EPU appears once in §12.5 spec body prose (cross-ref context, not a claimed glossary entry — acceptable) |
| 25 | OPEN QUESTIONS 4 and 5 preserved | PASS | Both preserved in §11.14 open-questions block with explicit "OPEN QUESTION 4" / "OPEN QUESTION 5" labels and §15 forward-refs; also referenced at §11.5, §11.6, §11.8, §11.11 |

**All 25 checks PASS.**

---

## Hard-Constraint Verification (16 Framing Commitments)

| # | Constraint | Status | Location |
|---|-----------|--------|---------|
| 1 | ITM-08 Coupling Summary glossary-ref grep-verify | PASS | All 20 verified-present; EPU/HFOM/VFOM/HDOP/TSO-C151c explicitly excluded from Coupling Summary backward-refs |
| 2 | Coupling Summary ~80-line budget | PASS | Coupling Summary is ~80 lines; dense backward-ref block (A/B/C/D/E + intra-fragment + forward-refs) |
| 3 | §11 does NOT re-author §4.9 content | PASS | §11.11 authors receiver-side framing only; display behavior cross-refs §4.9 (Fragment C) |
| 4 | §11.11 does NOT re-author §10.12 ADS-B Status workflow | PASS | §11.11 cross-refs §10.12 for settings-page operational workflow; no re-tabulation |
| 5 | §11.4 THREE MODES ONLY | PASS | Standby/On/Altitude Reporting; no Ground/Test/Anonymous; 3-row table; WOW automatic framing explicit |
| 6 | §11.10 Remote G3X Touch OUT OF V1 SCOPE | PASS | "not implemented in the v1 Air Manager instrument" explicit; capabilities list preserved |
| 7 | §11.11 BUILT-IN DUAL-LINK RECEIVER | PASS | (a) built-in, no external LRU; (b) dual-link 1090 ES + 978 UAT; (c) all three XPDR modes; (d) TIS-B active in On+ALT only |
| 8 | §11.13 + §13.9: EXACTLY 4 XPDR/ADS-B Out advisories from pp. 283–284 | PASS | 4 items verbatim from pp. 283–284 in §11.13 table; §13.9 cross-refs items 1–4 |
| 9 | §11.13 + §13.11: EXACTLY 5 GNX 375 Traffic/ADS-B In advisories from p. 290 | PASS | 5 items verbatim from p. 290 in §11.13 table; §13.11 cross-refs items 5–9; pp. 288–289 explicitly excluded |
| 10 | §11.13 total = 9 advisories | PASS | 4 + 5 = 9; stated explicitly in §11.13 |
| 11 | §12.4 TSAA AURAL PRESENT ON GNX 375 | PASS | "Aural traffic alerts are present on the GNX 375 via TSAA"; mute = current only; OQ6 cross-ref to §4.9 |
| 12 | §12.9 XPDR ANNUNCIATIONS replaces COM Annunciations | PASS | Fully replaced; squawk/SBY-ON-ALT/Reply/IDENT/failure elements; no COM content |
| 13 | §13.9 XPDR ADVISORIES replaces COM Radio Advisories | PASS | Fully replaced; 4 XPDR/ADS-B Out conditions; no COM content |
| 14 | No §4 re-authoring; §§11–13 only | PASS | 0 matches for `^## 4\.|^### 4\.` or other non-§11–§13 section headers |
| 15 | No COM present-tense on GNX 375 | PASS | All COM mentions are sibling-unit comparison or explicit "has no" framing |
| 16 | External altitude source framing consistent | PASS | Six locations in §11 + §13.8 + Coupling Summary all reference external ADC/ADAHRS source |

---

## ITM-08 Coupling Summary Grep-Verify Report

**Planned backward-ref terms:** 1090 ES, UAT, Extended Squitter, TSAA, FIS-B, TIS-B, Flight ID, IDENT, WOW, Target State and Status, TSO-C112e, TSO-C166b, Mode S, WAAS, SBAS, RAIM, Connext, GPSS, CDI, VDI.

**Confirmed PRESENT via grep of Fragment A Appendix B:**

| Term | Fragment A Location |
|------|-------------------|
| CDI | B.1 main abbreviations table (line 364) |
| GPSS | B.1 main abbreviations table (line 371) |
| RAIM | B.1 main abbreviations table (line 380) |
| SBAS | B.1 main abbreviations table (line 381) |
| TSAA | B.1 main abbreviations table (line 385) |
| VDI | B.1 main abbreviations table (line 387) |
| WAAS | B.1 main abbreviations table (line 390) |
| Mode S | B.1 additions — GNX 375 XPDR/ADS-B terms (line 402) |
| 1090 ES | B.1 additions (line 404) |
| UAT | B.1 additions (line 405) |
| Extended Squitter | B.1 additions (line 406) |
| FIS-B | B.1 additions (line 408) |
| TIS-B | B.1 additions (line 409) |
| Flight ID | B.1 additions (line 410) |
| IDENT | B.1 additions (line 412) |
| WOW | B.1 additions (line 413) |
| Target State and Status | B.1 additions (line 414) |
| TSO-C112e | B.1 additions (line 415) |
| TSO-C166b | B.1 additions (line 416) |
| Connext | B.3 Garmin-specific terms (line 440) |

**All 20 terms confirmed present. No terms removed.**

**NOT claimed (absent from Appendix B, per C2.2-C X17, C2.2-D F11, C2.2-E C1):** EPU, HFOM, VFOM, HDOP, TSO-C151c. These appear in the Coupling Summary "NOT claimed" list and were not used as Appendix B backward-refs. EPU appears once in §12.5 spec-body prose (describing the GPS Status page accuracy field context from p. 105) — this is not a glossary-term claim.

---

## D-16 Framing Verification

| D-16 Decision | Verification | Fragment F Location |
|--------------|-------------|-------------------|
| Three XPDR modes only (Standby/On/Altitude Reporting) | PASS | §11.4 heading, prose, and 3-row table; "no Ground mode, no Test mode in the pilot UI, and no Anonymous mode" |
| WOW handled automatically (no pilot mode change) | PASS | §11.4 note: "all aircraft air/ground state transmissions are handled automatically" [p. 78] |
| Built-in dual-link ADS-B In (no external LRU) | PASS | §11.11: "built-in dual-link ADS-B In receiver — no external hardware required" |
| TSAA aural alerts GNX 375 only | PASS | §12.4: "Aural traffic alerts are present on the GNX 375 via the TSAA application" |
| ADS-B traffic logging GNX 375 only | PASS | §13.8 cross-refs §10.13 for "GNX 375-only ADS-B traffic log"; Coupling Summary Fragment E §10.13 backward-ref notes "GNX 375-only ADS-B traffic log" |
| Remote G3X Touch v1 out-of-scope | PASS | §11.10: "not implemented in the v1 Air Manager instrument" |

---

## S13-Pattern Instances

Two PDF-vs-outline alignment notes verified; no deviations found:

1. **§11.4 mode set:** PDF p. 78 confirms exactly Standby, On, Altitude Reporting — no additional modes. The outline's D-16-based framing is PDF-accurate. ✅
2. **§11.5 special squawk codes:** PDF p. 79 confirms "informational only — no preset buttons." §11.5 reflects this accurately. ✅
3. **§11.13 advisory text:** Advisory text verified verbatim against pp. 283–284 and 290. All 9 advisory texts match PDF source. ✅
4. **§13.11 traffic advisory set:** p. 290 confirms 5 GNX 375-specific advisories; pp. 288–289 confirmed to be GPS 175/GNC 355 + GDL 88 LRU failures (NOT GNX 375). ✅

No S13-pattern discrepancies found. No deviation report required.

---

## Coupling Summary Preview

**Backward-refs to Fragments A/B/C/D/E:** Fragment A §1 (GNX 375 baseline, sibling contrast), §2 (XPDR key access from Home), §3 (external altitude source), Appendix B (20 verified glossary terms); Fragment B §4.1 (Home XPDR icon); Fragment C §4.9 (Hazard Awareness — FIS-B/Traffic/TSAA display pages, OPEN QUESTION 6 cross-ref); Fragment D §7.2 (flight phase annunciation table), §7.9 (approach-phase XPDR interactions); Fragment E §10.1 (CDI On Screen), §10.5 (Alerts Settings), §10.8 (Scheduled Messages), §10.11 (GPS Status page), §10.12 (ADS-B Status operational workflow), §10.13 (Logs).

**Forward-refs to Fragment G:** §11.14 → §14 (XPDR persistent state schema); §11 overall + §11.11 → §15 (XPDR datarefs, ADS-B In datarefs, OPEN QUESTIONS 4 + 5); §11.4/§11.8 → §15.7 (altitude source dependency); §12.2 → §15.6 (external CDI/VDI output contract).

**Intra-fragment refs within Fragment F:** §11.7 ↔ §12.9; §11.13 ↔ §13.9 (items 1–4); §11.13 ↔ §13.11 (items 5–9); §12.4 ↔ §13.9/§13.11 (aural delivery OPEN QUESTION 6).

---

## Deviations from Prompt

| # | Deviation | Rationale |
|---|-----------|-----------|
| None | — | All prompt requirements met; no deviations |
