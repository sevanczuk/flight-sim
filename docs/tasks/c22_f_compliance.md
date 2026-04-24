---
Created: 2026-04-24T14:30:00-04:00
Source: docs/tasks/c22_f_compliance_prompt.md
---

# C2.2-F Compliance Report — GNX 375 Functional Spec V1 Fragment F

**Task ID:** GNX375-SPEC-C22-F-COMPLIANCE
**Parent task:** GNX375-SPEC-C22-F
**Fragment under review:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md`
**Completed:** 2026-04-24

---

## Summary

| Category | Total | PASS | PASS WITH NOTES | PARTIAL | FAIL |
|----------|-------|------|-----------------|---------|------|
| F (File/Format) | 6 | 6 | 0 | 0 | 0 |
| S (Structural/Source-Fidelity) | 10 | 10 | 0 | 0 | 0 |
| X (Cross-Reference) | 7 | 7 | 0 | 0 | 0 |
| C (Constraints) | 12 | 11 | 0 | 1 | 0 |
| N (Notes/Classification) | 3 | 2 | 1 | 0 | 0 |
| **Total** | **38** | **36** | **1** | **1** | **0** |

**Overall verdict: PASS WITH NOTES**
- 36 PASS, 1 PASS WITH NOTES (N1), 1 PARTIAL (C2 Coupling Summary line count)
- Zero FAILs; zero C-category hard-constraint failures
- PARTIAL is format/presentation only: all required content present

---

## Per-Item Results

### F Category

**F1. PASS.** Evidence: PowerShell `(Get-Content ...).Count` = **606 lines**. Matches completion report claim of 606. Within D-19 acceptable band (485–720); below soft ceiling (650); +12% over target of 540.

**F2. PASS.** Evidence: `Select-String -Pattern '\\u[0-9a-fA-F]{4}'` → **0 matches**.

**F3. PASS.** Evidence: Byte-level check via `scripts/compliance/c22_f/check_encoding.py`:
- U+FFFD (EF BF BD) count: **0**
- Valid § (C2 A7) count: **169**
- Broken C2 sequences (C2 not followed by A7): **0**

CD's Phase 1 observation of `��` in the Coupling Summary forward-refs block was mojibake from a tool reading the UTF-8 file with the wrong encoding (Windows-1252). The file is correctly UTF-8 encoded throughout. The specific bullet "§11.4 Altitude Reporting + §11.8 Extended Squitter → §15.7 Altitude Source Dependency" at line 594 was read via the Read tool and confirmed correct — the § before "11.4" is present and correctly encoded as C2 A7. PowerShell `Get-Content` without explicit UTF-8 encoding renders § as `Â§` (mojibake artifact) but the file bytes are correct. Self-check claim of 0 U+FFFD: confirmed accurate.

**F4. PASS.** Evidence: Lines 1–8 of fragment (via Read tool):
```
1: ---
2: Created: 2026-04-24T11:30:00-04:00
3: Source: docs/tasks/c22_f_prompt.md
4: Fragment: F
5: Covers: §§11–13 (Transponder + ADS-B Operation, Audio/Alerts/Annunciators, Messages)
6: ---
7: (blank)
8: # GNX 375 Functional Spec V1 — Fragment F
```
`Fragment: F` ✓. `Covers: §§11–13` ✓. Fragment header `# GNX 375 Functional Spec V1 — Fragment F` appears on line 8 (one blank line after the closing `---` on line 6 — standard YAML front-matter practice; compliant).

**F5. PASS.** Evidence: `Select-String -Pattern '^## Coupling Summary'` → **1 match** at line 568. Four sub-blocks present:
- L572: `### Backward cross-references (sections this fragment references authored in prior fragments)`
- L589: `### Forward cross-references (sections this fragment writes that later fragments will reference)`
- L597: `### Intra-fragment cross-references (within Fragment F)`
- L604: `### Outline coupling footprint`

All 4 sub-blocks substantive. Coupling Summary actual line count: **39 lines** (see C2 below for PARTIAL on this point).

**F6. PASS.** Evidence: `Select-String -Pattern '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])'` → **0 matches**.

---

### S Category

**S1. PASS.** Evidence: `Select-String -Pattern '^### 11\.'` → **14 matches**. Sub-sections in order: 11.1 XPDR Overview and Capabilities; 11.2 XPDR Control Panel; 11.3 XPDR Setup Menu; 11.4 XPDR Modes; 11.5 Squawk Code Entry; 11.6 VFR Key and IDENT; 11.7 Transponder Status Indications; 11.8 Extended Squitter (ADS-B Out); 11.9 Flight ID; 11.10 Remote Control via G3X Touch; 11.11 ADS-B In (Built-in Dual-link Receiver); 11.12 XPDR Failure / Alert; 11.13 XPDR Advisory Messages; 11.14 XPDR Persistent State. Contiguous 11.1–11.14. ✓

**S2. PASS.** Evidence: `Select-String -Pattern '^### 12\.'` → **9 matches**. Sub-sections: 12.1–12.9 in order. ✓

**S3. PASS.** Evidence: `Select-String -Pattern '^### 13\.'` → **13 matches**. Sub-sections: 13.1–13.13 in order. ✓

**S4. PASS.** Evidence: §11.4 content (line 66–84 via Read tool):
- Heading: `### 11.4 XPDR Modes [p. 78]` ✓
- 3-row mode table: Standby / On / Altitude Reporting ✓
- Denial framing (L68): "There is no Ground mode, no Test mode in the pilot UI, and no Anonymous mode on the GNX 375." ✓
- WOW automatic framing (L80): "all aircraft air/ground state transmissions are handled **automatically** via the transponder — no pilot mode change is required on landing or takeoff [p. 78]." ✓
- PDF p. 78 confirms: exactly 3 modes (Standby/On/Altitude Reporting); "During Altitude Reporting mode, all aircraft air/ground state transmissions are handled via the transponder and require no pilot action." ✓

**S5. PASS.** Evidence: §11.5 content (lines 88–110):
1. 0–7 keys (L90): "Eight digit keys (0–7) provide access to all ATCRBS codes in the range 0000–7777 (octal)" ✓
2. Backspace/outer knob (L92): "Use the Backspace key or the outer control knob to move the cursor." ✓
3. Underscores (L93): "Digits not yet entered display as underscores." ✓
4. Enter/Cancel (L94–95): "Tap **Enter** to activate the new code; tap **Cancel** to exit without changing the active code." ✓
5. Special codes informational only (L98): "**Special squawk codes — informational only; no preset buttons [p. 79]:**" followed by table; (L107): "The GNX 375 provides no dedicated preset buttons for 7500, 7600, or 7700." ✓
PDF p. 79 confirms: informational special code table (1200/7500/7600/7700); "There are no preset buttons" is consistent with p. 79 text structure. ✓

**S6. PASS.** Evidence: Nine advisory texts verified character-by-character against PDF pp. 283–284 and 290:

*From pp. 283–284 (items 1–4):*
| # | Fragment F text | PDF text | Match |
|---|----------------|----------|-------|
| 1 | "ADS-B Out fault. Pressure altitude source inoperative or connection lost." | "ADS-B Out fault. Pressure altitude source inoperative or connection lost." | ✓ Verbatim |
| 2 | "Transponder has failed." | "Transponder has failed." | ✓ Verbatim |
| 3 | "Transponder is operating in ground test mode." | "Transponder is operating in ground test mode." | ✓ Verbatim |
| 4 | "ADS-B is not transmitting position." | "ADS-B is not transmitting position." | ✓ Verbatim |

*From p. 290 (items 5–9):*
| # | Fragment F text | PDF text | Match |
|---|----------------|----------|-------|
| 5 | "1090ES traffic receiver fault." | "1090ES traffic receiver fault." | ✓ Verbatim |
| 6 | "ADS-B traffic alerting function inoperative." | "ADS-B traffic alerting function inoperative." | ✓ Verbatim |
| 7 | "ADS-B traffic function inoperative." | "ADS-B traffic function inoperative." | ✓ Verbatim |
| 8 | "Traffic/FIS-B functions inoperative." | "Traffic/FIS-B functions inoperative." | ✓ Verbatim |
| 9 | "UAT traffic/FIS-B receiver fault." | "UAT traffic/FIS-B receiver fault." | ✓ Verbatim |

All 9 match verbatim. PP. 288–289 advisory set (GDL 88 LRU failures) explicitly excluded (L246, L542). ✓

**S7. PASS.** Evidence: §11.2 five UI regions (lines 38–45) vs. PDF p. 75:
| # | Fragment F Region | PDF p. 75 Region | Match |
|---|------------------|-----------------|-------|
| 1 | Squawk Code Entry Field | Squawk Code Entry Field | ✓ |
| 2 | VFR Key | VFR Key | ✓ |
| 3 | XPDR Mode Key | XPDR Mode Key | ✓ |
| 4 | Squawk Code Entry Keys (0–7) | Squawk Code Entry Keys | ✓ |
| 5 | Data Field | Data Field | ✓ |
PDF p. 75 (confidence: clean) confirms all 5 regions identically labeled. ✓

**S8. PASS.** Evidence: §11.7 four states (lines 127–134) vs. PDF p. 81:
| # | Fragment F State | PDF p. 81 State | Match |
|---|-----------------|----------------|-------|
| 1 | IDENT active — unmodified code | "IDENT" (Reply active, IDENT function active, No change to transponder code) | ✓ |
| 2 | IDENT with new squawk code | "IDENT with New Squawk Code" (Reply active, Transponder code modified) | ✓ |
| 3 | Standby | "Standby Mode" (Standby mode, Current squawk code inactive) | ✓ |
| 4 | Altitude Reporting | "Altitude Reporting Mode" (Reply active, Identify function active) | ✓ |
PDF p. 81 (confidence: clean) confirms all 4 states. Tap behaviors documented in Fragment F table column "Tap XPDR Key Behavior." ✓

**S9. PASS.** Evidence: §12.1 (lines 284–294) — 3-row table:
| Level | Display | Priority | Required Response |
| Warning | White text on red background | 1 (highest) | Immediate pilot action required |
| Caution | Black text on amber background | 2 | Timely pilot action; abnormal condition present |
| Advisory | Black/white text on white background | 3 (lowest) | Awareness; no immediate action required |
PDF p. 98 (confidence: clean) confirms 3-level priority hierarchy: Warnings (1), Cautions (2), Mode & function advisories (3). Color assignments (red/amber/white) are consistent with p. 98 figure; the PDF extracted text does not enumerate colors explicitly (those are in the visual diagram). Table structure equivalent to prompt specification. ✓

**S10. PASS.** Evidence: All 10 citation spot-checks confirmed:
| Citation | Required Location | Actual Location | Result |
|----------|------------------|----------------|--------|
| [p. 75] | §11.2 | L32 (heading), L36 (body) | ✓ |
| [p. 76] | §11.3 | L50 (heading) | ✓ |
| [p. 77] | §11.8 | L142 (heading), L144 (body) | ✓ |
| [p. 78] | §11.4 | L66 (heading), L68, L70, L80 (body) | ✓ |
| [p. 79] | §11.5 | L88 (heading), L90, L98 (body) | ✓ |
| [p. 80] | §11.6 | L113 (heading), L117 (body) | ✓ |
| [p. 81] | §11.7 | L125 (heading), L127 (body) | ✓ |
| [p. 82] | §11.10 or §11.12 | L169 (§11.10 heading), L209 (§11.12 heading) | ✓ |
| [pp. 283–284] | §11.13 and §13.9 | L223 (§11.13 heading), L507 (§13.9 heading) | ✓ |
| [p. 290] | §11.13 and §13.11 | L223 (combined `[pp. 283–284, 290]`), L530 (§13.11 heading) | ✓ |

---

### X Category

**X1. PASS.** Evidence: §13.9 (lines 507–518) — four items listed with "(§11.13 item N)" cross-refs:
1. "ADS-B Out fault — pressure altitude source inoperative or connection lost (§11.13 item 1)"
2. "Transponder has failed (§11.13 item 2)"
3. "Transponder is operating in ground test mode (§11.13 item 3)"
4. "ADS-B is not transmitting position (§11.13 item 4)"
Items are titled/summarized (not verbatim re-authored): items 1 and 2 use em-dash and omit period; cross-refs are explicit. Verbatim advisory text is NOT duplicated; §11.13 is authoritative. ✓

**X2. PASS.** Evidence: §13.11 (lines 530–543) — five items in a table with §11.13 Ref column cross-referencing items 5–9. Explicit pp. 288–289 exclusion statement (L542): "The GPS 175/GNC 355 traffic advisory set (pp. 288–289) references GDL 88 LRU-specific failures... Those messages are **NOT applicable to the GNX 375** — the GNX 375 uses no external ADS-B LRU and has no GDL 88 failure modes." ✓

**X3. PASS.** Evidence: §11.11 (lines 184–205):
- Cross-ref to §4.9 Fragment C (L193): "cross-ref §4.9 Fragment C for display behavior — authoritative for display-side detail; §11.11 authors receiver-side framing only" ✓
- Cross-ref to §10.12 Fragment E (L201): "For ADS-B Status settings-page workflow... cross-ref §10.12 (Fragment E) — authoritative for that page's operational workflow." ✓
- §11.11 content: built-in receiver framing, dual-link description, operational modes, TIS-B participant status — no display-page layout or settings-page workflow re-tabulation. ✓

**X4. PASS.** Evidence: §12.4 (lines 324–334) — OPEN QUESTION 6 cross-reference block (L332): "The design-phase decision on the TSAA aural alert delivery mechanism... is preserved as OPEN QUESTION 6 in §4.9 (Fragment C). See §4.9 for the full open-question text and design options. Fragment F does not re-preserve the verbatim text." ✓ No verbatim OQ6 text in Fragment F. ✓

**X5. PASS.** Evidence: §12.5 (lines 338–354) — cross-ref (L352): "Cross-ref §10.11 (Fragment E) for the full GPS Status operational page workflow (satellite sky view, position accuracy fields, SBAS Providers selection)." ✓

**X6. PASS.** Evidence:
- §12.7 (lines 369–373): "For the full traffic annunciation table (threat levels, alert types, aural alert triggers), cross-ref §4.9 Traffic Awareness (Fragment C)." — body is 3 lines total; cross-ref only ✓
- §12.8 (lines 376–380): "For the full terrain annunciation table (alert conditions, visual and aural triggers, inhibit function), cross-ref §4.9 Terrain Awareness (Fragment C)." — body is 2 lines total; cross-ref only ✓

**X7. PASS.** Evidence: Coupling Summary "Intra-fragment cross-references" block (lines 597–602):
- §11.7 Status Indications ↔ §12.9 XPDR Annunciations ✓
- §11.13 ↔ §13.9 (items 1–4, pp. 283–284) ✓
- §11.13 ↔ §13.11 (items 5–9, p. 290) ✓
- §12.4 ↔ §13.9/§13.11 (aural delivery OPEN QUESTION 6) ✓
All 4 required intra-fragment cross-refs present. ✓

---

### C Category

**C1. PASS.** Evidence: Independent grep of Fragment A (`docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`) via Read tool at offset 355–455:

All 20 claimed terms confirmed present at claimed line numbers (all ± 0; exact matches):

| # | Term | Claimed Line | Actual Line | Match |
|---|------|-------------|------------|-------|
| 1 | CDI | 364 | 364 | ✓ Exact |
| 2 | GPSS | 371 | 371 | ✓ Exact |
| 3 | RAIM | 380 | 380 | ✓ Exact |
| 4 | SBAS | 381 | 381 | ✓ Exact |
| 5 | TSAA | 385 | 385 | ✓ Exact (B.1 main; see-also B.1 additions at 407) |
| 6 | VDI | 387 | 387 | ✓ Exact |
| 7 | WAAS | 390 | 390 | ✓ Exact |
| 8 | Mode S | 402 | 402 | ✓ Exact |
| 9 | 1090 ES | 404 | 404 | ✓ Exact |
| 10 | UAT | 405 | 405 | ✓ Exact |
| 11 | Extended Squitter | 406 | 406 | ✓ Exact |
| 12 | FIS-B | 408 | 408 | ✓ Exact |
| 13 | TIS-B | 409 | 409 | ✓ Exact |
| 14 | Flight ID | 410 | 410 | ✓ Exact |
| 15 | IDENT | 412 | 412 | ✓ Exact |
| 16 | WOW | 413 | 413 | ✓ Exact |
| 17 | Target State and Status | 414 | 414 | ✓ Exact |
| 18 | TSO-C112e | 415 | 415 | ✓ Exact |
| 19 | TSO-C166b | 416 | 416 | ✓ Exact |
| 20 | Connext | 440 | 440 | ✓ Exact |

Exclusion list verification (Fragment A Appendix B, lines 355–450 fully read):
| Term | Expected Status | Verified Status |
|------|----------------|----------------|
| EPU | Absent from Appendix B | Absent ✓ |
| HFOM | Absent from Appendix B | Absent ✓ |
| VFOM | Absent from Appendix B | Absent ✓ |
| HDOP | Absent from Appendix B | Absent ✓ |
| TSO-C151c | Absent from Appendix B | Absent ✓ |

Coupling Summary exclusion-list statement (Fragment F L577): "**NOT claimed (absent from Appendix B per C2.2-C X17, C2.2-D F11, C2.2-E C1):** EPU, HFOM, VFOM, HDOP, TSO-C151c." ✓ Explicitly present.

Decision rule: All 20 terms at exact lines; 5 exclusions absent from Appendix B and explicitly stated in Coupling Summary → **PASS.**

**C2. PARTIAL.** Evidence: Coupling Summary starts at line 568; file ends at line 606. Actual Coupling Summary line count: **39 lines**.

Completion report claimed ~80 lines. Actual 39 lines is significantly below the ~80 target and below the 60-line PARTIAL floor.

Per-section line counts (from `## section` heading to next `## section` heading):
- §11 (lines 10–277): **268 lines** (target ~280 — within 4.3%) ✓
- §12 (lines 278–406): **129 lines** (target ~120 — slight overage +7.5%) ✓
- §13 (lines 407–567): **161 lines** (target ~180 — slight underage -10.6%) ✓
- Coupling Summary (lines 568–606): **39 lines** (target ~80 — at 49% of target) ✗

Content completeness: all required refs ARE present (14 backward-refs, 5 forward-refs, 4 intra-fragment refs, 1 outline footprint block — all substantive). The 39 lines are information-dense with long multi-clause bullet points. However, per the decision rule, <60 lines = PARTIAL.

The completion report's claim of "~80 lines" was inaccurate. This is a format/presentation issue only — all required content is present and correct.

Decision rule outcome: **PARTIAL** (under-budget; verify all required refs present → all present; report as density-justified under-budget).

**C3. PASS.** Evidence: `Select-String -Pattern '^## 4\.|^### 4\.'` → **0 matches**. ✓

**C4. PASS.** Evidence: §11.11 (lines 184–205) — all 4 framing elements:
- (a) Built-in, no external LRU (L186): "built-in dual-link ADS-B In receiver — no external hardware required" ✓
- (b) Dual-link 1090 ES + 978 UAT (L187–189): "1090 ES link (1090 MHz): receives ADS-B Out transmissions... UAT link (978 MHz): receives FIS-B weather and NOTAM broadcasts; receives UAT-equipped traffic" ✓
- (c) All three XPDR modes (L199): "Operates in all three XPDR modes (Standby, On, Altitude Reporting)" ✓
- (d) TIS-B in On + ALT only (L200): "TIS-B participant status: active only when in On or Altitude Reporting mode — NOT in Standby." ✓

GDL 88 / GTX 345 references verified: L191 ("GPS 175 and GNC 355/355A... require an external GDL 88, GTX 345, or equivalent LRU") and L26 ("GPS 175 and GNC 355/355A have no transponder... they require an external GDL 88 or GTX 345") — both in explicit sibling-unit comparison context; NEVER "GNX 375 requires GDL 88/GTX 345." ✓

**C5. PASS.** Evidence: §11.10 (line 180): "Remote XPDR control via G3X Touch is **not implemented in the v1 Air Manager instrument.**" ✓ Capabilities list preserved (lines 171–177): squawk code, transponder mode, IDENT activation, ADS-B Out transmission enable, Flight ID assignment — all 5 documented. ✓

**C6. PASS.** Evidence: `Select-String -Pattern 'Ground mode|Test mode|Anonymous mode'` → 4 matches, all in denial/quotation context:
- L68: "There is no Ground mode, no Test mode in the pilot UI, and no Anonymous mode on the GNX 375." — explicit denial ✓
- L233: Advisory message text "Transponder is operating in ground test mode." — quoted advisory text (condition description), not a mode assertion ✓
- L303: "Alert/Inhibit/Test Mode slot" — annunciator bar slot name, not a XPDR mode ✓
- L515: Same advisory text in §13.9 cross-ref context ✓
Zero assertions of any 4th mode existing on GNX 375. **PASS.**

**C7. PASS.** S6 passed (all 9 advisory texts verified verbatim; total = 9). **PASS.**

**C8. PASS.** Evidence: §12.4 (lines 324–334):
- "Aural traffic alerts are present on the GNX 375 via the TSAA (Traffic Situational Awareness with Alerting) application" (L326) ✓ (present-on-GNX-375 framing)
- "The **Mute Alert** function silences only the **current active aural alert** — it does not mute future alerts [p. 101]." (L329) ✓ (mute-current-only)

**C9. PASS.** Evidence: §12.9 (lines 383–398) — all 5 XPDR elements present:
- Squawk Code Display (L391): "Active 4-digit squawk code (0000–7777 octal); unentered digits shown as underscores" ✓
- Mode Indicator (L392): "SBY (Standby) / ON (On) / ALT (Altitude Reporting) — **three modes only, per D-16**" ✓
- Reply (R) Indicator (L393): "Transponder responding to ATC interrogations (On and Altitude Reporting modes)" ✓
- IDENT Active Indicator (L394): "18-second IDENT state active; visible in annunciator bar and Data Field" ✓
- Failure Indicator (L395): "Red 'X' over IDENT key when transponder fails (cross-ref §11.12)" ✓
COM content check (L385): "The GNX 375 has no VHF COM radio; all annunciation elements here are transponder-related." ✓ No COM-on-GNX-375 content.

**C10. PASS.** Evidence: §13.9 header (L507): "### 13.9 XPDR Advisories (GNX 375 — replaces COM Radio Advisories)"; body (L509): "This sub-section replaces the COM Radio Advisories sub-section from the GNC 355 spec. The GNX 375 has no VHF COM radio; all advisories here are transponder and ADS-B Out related." ✓ Four XPDR/ADS-B Out conditions cross-referencing §11.13 items 1–4 ✓. No COM radio content. ✓

**C11. PASS.** Evidence: `Select-String -Pattern 'COM radio|COM standby|COM volume|COM frequency|COM monitoring|VHF COM'` → 5 matches:
- L12: "§11 COM Radio Operation from the GNC 355 spec: the GNX 375 has no VHF COM radio" — type (b) explicit negation ✓
- L385: "replaces the COM Annunciations sub-section... GNX 375 has no VHF COM radio" — type (b)/(c) ✓
- L409: "§13.9 XPDR Advisories replaces COM Radio Advisories from the GNC 355 spec" — type (c) ✓
- L507: "replaces COM Radio Advisories" — type (c) heading label ✓
- L509: "replaces the COM Radio Advisories sub-section... GNX 375 has no VHF COM radio" — type (b)/(c) ✓
Category (d) count (present-tense COM assertion on GNX 375): **0**. ✓

**C12. PASS.** Evidence: `Select-String -Pattern 'ADC|ADAHRS|altitude encoder|altitude source'` → 12 matches spanning multiple §11 locations:
- L23 (§11.1): "from ADC/ADAHRS via altitude encoder input; GNX 375 does not compute pressure altitude internally" ✓
- L60 (§11.3): "altitude from the external ADC/ADAHRS source" ✓
- L150 (§11.8): "Pressure altitude (from external ADC/ADAHRS — included only when in Altitude Reporting mode)" ✓
- L231 (§11.13 item 1): "Transponder loses communication with the external pressure altitude source" ✓
- L494 (§13.8): "altitude encoder calibration" (service context) ✓
- L498 (§13.8): "Pressure altitude source inoperative or connection lost: no pressure altitude from any source" ✓
- L576 (Coupling Summary): "external altitude source framing (ADC/ADAHRS via altitude encoder, p. 34)" ✓
- L594 (Coupling Summary forward-ref): "external pressure altitude dataref contract" ✓
5+ consistent external-source references verified; no prose implying internal computation. ✓

---

### N Category

**N1. PASS WITH NOTES.** Evidence: Per-section line distribution:
- §11 (XPDR + ADS-B): 268 lines — 14 sub-sections × avg 19 lines/sub-section; 4.3% below target of 280; justified by D-16 framing requirements, 9-advisory table, 5-UI-region table, 4-state table, WOW/dual-link/mode constraints, AMAPI cross-refs per sub-section. ✓
- §12 (Audio/Alerts/Annunciators): 129 lines — 9 sub-sections × avg 14 lines; +7.5% over target of 120; justified by XPDR-specific §12.9 expansion. ✓
- §13 (Messages): 161 lines — 13 sub-sections × avg 12 lines; -10.6% under target of 180; efficient given cross-ref-only approach for §13.9/§13.11. ✓
- Coupling Summary: 39 lines (see C2 PARTIAL for line-count concern).

Total fragment: 606 lines; +12% over 540 target; within 485–720 band; below 650 soft ceiling. Lowest relative overshoot in the C/D/E/F series (D: +22%, E: +82%). Density is justified. Overall file-level classification: density-appropriate.

**N2. PASS.** Evidence: Open-question preservation verified:
| Item | Expected Location | Verified |
|------|------------------|---------|
| OPEN QUESTION 4 (XPL XPDR datarefs) | §11.14 + §11.5/§11.6/§11.8 AMAPI notes | ✓ L269 (OQ block), L109 (§11.5), L121 (§11.6), L155 (§11.8) |
| OPEN QUESTION 5 (MSFS XPDR vars) | §11.14 + same AMAPI notes | ✓ L270 (OQ block), L109/121/155 |
| OPEN QUESTION 6 (TSAA aural delivery) | Cross-ref only to §4.9 Fragment C | ✓ L332 (§12.4 cross-ref only; verbatim OQ6 NOT reproduced) |
| §11.10 v1 scope flag | §11.10 explicit | ✓ L180 "not implemented in the v1 Air Manager instrument" |
| §11.11 simulator ADS-B In | Flagged as design-phase decision | ✓ L203–204 "Simulator availability flag: ... design-phase decision" |

**N3. PASS.** Evidence: All 4 Coupling Summary sub-blocks present and substantive (verified at F5 and C1):
1. Backward cross-references: 14 entries spanning Fragments A–E ✓
2. Forward cross-references: 5 entries to Fragment G (§§14–15) ✓
3. Intra-fragment cross-references: 4 entries (§11.7↔§12.9; §11.13↔§13.9; §11.13↔§13.11; §12.4↔§13.9/§13.11) ✓
4. Outline coupling footprint: present with substantive scope-delimiting statement ✓

---

## Items Warranting New ITMs

**ITM-NEW-F-01: C2.2-F Coupling Summary line count under-budget (39 lines vs. ~80 target)**
- **Location:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_F.md`, lines 568–606
- **Severity:** Low — all required content present and correct; purely format/presentation
- **Finding:** Completion report claimed ~80 lines for Coupling Summary; independent verification finds 39 lines, below the 60-line PARTIAL floor specified in the compliance check. The 39 lines contain all required backward-refs (14), forward-refs (5), intra-fragment refs (4), and outline coupling footprint — but written as dense single-line bullets rather than expanded prose entries. The CC self-review metric appears to have been calculated incorrectly (possibly including AMAPI notes block or confusing total fragment trailing lines with Coupling Summary).
- **Disposition options:** (a) Accept as-is — content complete, line count is a style metric; (b) Expand Coupling Summary bullets to multi-sentence format in a future revision to reach target; (c) Relax the line-count target for Fragment F given content completeness.
- **Resolution recommendation:** Accept as-is with note. Fragment G Coupling Summary should target ≥60 lines with explicit per-ref prose expansion.

---

## Recommendation to CD

- [x] **Archive with new ITMs logged (PASS WITH NOTES)**
  - Archive Fragment F
  - Log ITM-NEW-F-01 (C2.2-F Coupling Summary line count)
  - Proceed to C2.2-G
- [ ] Bug-fix task required (no C-category FAILs; no bug-fix warranted)

**Rationale:** All 38 items verified independently. 36 PASS, 1 PASS WITH NOTES (N1 — density classification), 1 PARTIAL (C2 — Coupling Summary 39 lines vs. 60 floor). The PARTIAL is cosmetic/format: content is complete and correct. Zero C-category FAILs. F3 encoding concern raised by CD in Phase 1 is resolved — the file is correctly UTF-8 encoded with 169 valid § characters and 0 replacement characters; CD's `��` observation was a viewer encoding artifact, not file corruption.

---

## Deviations from Compliance Prompt

None. All 38 checks executed as specified. Scripts saved to `scripts/compliance/c22_f/` per D-08:
- `check_encoding.py` — byte-level U+FFFD and § integrity check (F3)
- `read_pdf_pages_utf8.py` — PDF page text extraction for S6/S7/S8/S9/S10 verification
- `check_json_structure.py` — JSON structure discovery (intermediate; not a compliance artifact)
- `check_json_pages.py` — JSON page lookup exploration (intermediate; not a compliance artifact)
- `read_pdf_pages_fixed.py` — initial page reader (intermediate; superseded by utf8 version)
