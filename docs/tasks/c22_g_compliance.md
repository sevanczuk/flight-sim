---
Created: 2026-04-25T11:15:00-04:00
Source: docs/tasks/c22_g_compliance_prompt.md
---

# GNX375-SPEC-C22-G Compliance Report

**Verified:** 2026-04-25T11:15:00-04:00
**Verdict:** PASS WITH NOTES

## Summary
- Total checks: 51
- Passed: 49
- Passed with notes: 2
- Partial: 0
- Failed: 0

---

## Results

### F. Format / Structure

**F1. PASS** — YAML front-matter present with all required fields.
Lines 1–6:
```
Created: 2026-04-25T09:00:00-04:00
Source: docs/tasks/c22_g_prompt.md
Fragment: G
Covers: §§14–15 + Appendix A (Persistent State, External I/O, Family Delta)
```

**F2. PASS** — H1 header matches exactly.
Line 8: `# GNX 375 Functional Spec V1 — Fragment G`

**F3. PASS** — Top-level H2 count = 3.
`grep -cE '^## 14\.|^## 15\.|^## Appendix A'` → **3**
Matches: line 14 `## 14. Persistent State`, line 86 `## 15. External I/O (Datarefs and Commands)`, line 216 `## Appendix A: Family Delta — GNX 375 as Baseline`.

**F4. PASS** — §14 sub-section count = 6.
`grep -cE '^### 14\.'` → **6** (14.1–14.6). Matches completion report.

**F5. PASS** — §15 sub-section count = 7.
`grep -cE '^### 15\.'` → **7** (15.1–15.7). Matches completion report.

**F6. PASS** — Appendix A sub-section count = 5.
`grep -cE '^### A\.'` → **5** (A.1–A.5). Matches completion report.

**F7. PASS** — Total line count = 443, within 270–450 band.
`wc -l` → **443**. Completion report claims 443. ✓

**F8. PASS** — No harvest-category markers in `###` lines.
`grep -nE '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])'` → exit code 1, 0 matches.

**F9. PASS** — No unicode escape sequences.
`grep -nE '\\u[0-9a-fA-F]{4}'` → exit code 1, 0 matches.

**F10. PASS** — No U+FFFD replacement chars.
`python scripts/check_fffd.py` → `U+FFFD replacement char count: 0`.

---

### S. Self-Review Re-Verification

**S1. PASS** — No foreign top-level headers.
`grep -nE '^## 4\.|^### 4\.|^## 7\.|...|^## Appendix B|^## Appendix C'` → exit code 1, 0 matches.

**S2. PASS** — §14.1 contains all five state items.
- "Squawk code" line 26: `| **Squawk code** | Restored to last-set 4-digit octal code | Retains last ATC-assigned or pilot-entered code [p. 75] |`
- "XPDR mode" line 27: `| **XPDR mode** | Restored to last-set mode | Three modes only per D-16: Standby / On / Altitude Reporting [p. 78]...`
- "Flight ID" line 28: `| **Flight ID** | Restored to installer-configured or pilot-set value |...`
- "ADS-B Out enable state" line 29: `| **ADS-B Out enable state** | Restored to ON or OFF | Toggled via XPDR Setup Menu |`
- "Data field preference" line 30: `| **Data field preference** | Restored to Pressure Altitude or Flight ID | Controls what appears in the XPDR data field [p. 75] |`

**S3. PASS** — "replaces COM State" present in §14.1.
- Line 20 (heading): `### 14.1 XPDR State (GNX 375 — replaces COM State) [pp. 75–82]`
- Line 22 (prose): `This list replaces the COM State enumeration that §14.1 contains in the GNC 355 equivalent, consistent with D-16's framing...`

**S4. PASS** — All six §15.6 D-15 markers confirmed.
- "no on-screen VDI": line 181: `**The GNX 375 has no on-screen VDI of any kind.**`
- "external" (VDI/CDI context): line 181: `external-only, routed to a connected VDI or CDI instrument`
- "LPV": line 190: `Glidepath deviation for LPV, LP+V, LNAV+V approaches`
- "LP+V": line 190 (same)
- "LNAV+V": line 190 (same)
- "vertical deviation output": line 190: `| **Vertical deviation** | **External VDI** | **Glidepath deviation for LPV, LP+V, LNAV+V approaches** | **D-15: no on-screen VDI — external VDI only** |`

**S5. PASS** — All four §15.7 D-16 markers confirmed.
- "external": line 199: `The GNX 375 transponder requires an **external altitude source**`
- "ADC": line 199: `Air Data Computer (ADC — e.g., Garmin GDC 74)`
- "ADAHRS": line 199: `Air Data / Attitude & Heading Reference System (ADAHRS)`
- "altitude encoder": line 199: `or a standalone altitude encoder (p. 34, D-16)`

**S6. PASS** — Three XPDR modes present in §15.1/15.2/15.3; no Ground/Test/Anonymous.
- Line 102: `[OQ4 — verify; mode mapping: 0=Standby, 1=On, 2=Alt Rpt]`
- Line 126: `Pilot mode selection (Standby / On / Altitude Reporting) | [OQ4 — verify name; only three valid values]`
- §14.1 line 27: `Three modes only per D-16: Standby / On / Altitude Reporting [p. 78]; no Ground, Test, or Anonymous modes`
- `grep 'Ground\|Anonymous\|Test.*mode' §15` sections → only one match at line 27 explicitly *excluding* those modes.

**S7. PASS** — OQ4 verbatim preserved (line 144).
Full block:
> `OPEN QUESTION 4 (XPL XPDR dataref names): XPL dataref names for XPDR code (sim/cockpit2/radios/actuators/transponder_code), mode (sim/cockpit2/radios/actuators/transponder_mode), reply state, ADS-B Out enable state, and external pressure altitude source require verification against current XPL datareftool output during design phase. These candidate names are provisional. All entries marked [OQ4] in §§15.1–15.3 must be resolved against the XPL datareftool before implementation. Forward-flag for D1 Design Spec resolution.`

Confirmed: `transponder_code` ✓, `datareftool` ✓, `transponder_mode` ✓, ADS-B Out enable state ✓, external pressure altitude source ✓, design-phase flag ✓.

**S8. PASS** — OQ5 verbatim preserved (line 175).
Full block:
> `OPEN QUESTION 5 (MSFS XPDR SimConnect variables): TRANSPONDER CODE:1, TRANSPONDER STATE, and TRANSPONDER IDENT variable names and behavioral differences between FS2020 and FS2024 require design-phase research. FS2024 introduced breaking changes in several SimConnect variable names and event formats; amapi_patterns.md Pattern 23 (FS2024 B: event dispatch) may apply to XPDR mode and code set operations. All entries marked [OQ5] in §§15.4–15.5 must be verified against both FS2020 and FS2024 SDK references during design phase. Forward-flag for D1 Design Spec resolution.`

Confirmed: `TRANSPONDER CODE:1` ✓, `TRANSPONDER STATE` ✓, `TRANSPONDER IDENT` ✓, FS2020 vs. FS2024 ✓, Pattern 23 reference ✓.

**S9. PASS** — A.1 D-12 context present.
- Line 230: `**GNX 375 is the primary instrument for this project per D-12**`
- Line 230: `The D-02 reference to "GNC 375" was a nomenclature error resolved by D-12: the correct product designation is **GNX 375**`
- Line 232: `GNC 355 implementation is **deferred** per D-12.`

**S10. PASS** — A.5 feature matrix: 19 data rows.
`grep -c '^|'` within A.5 section → **21** total pipe rows (2 header rows + 19 data rows). Completion report claims 19 feature rows. Independently confirmed: 19.

**S11. PASS** — No COM present-tense on GNX 375.
COM-related matches on lines 16, 22, 32, 226–228, 277, 280, 328. All examined:
- Lines 16, 22, 32: framing that GNX 375 has *no* COM radio or COM state ✓
- Lines 226–228: A.1 comparative description — GPS 175 "no COM radio", GNC 355 "VHF COM radio", GNX 375 "no COM radio" ✓
- Lines 277, 280: GNC 355 Adds table (sibling-comparison context) — attributed to GNC 355/355A, not GNX 375 ✓
- Line 328: A.5 matrix row `| VHF COM Radio | — | ✓ | — |` — "—" in GNX 375 column ✓

No match implies GNX 375 has COM radio. PASS.

**S12. PASS WITH NOTE** — Page citations present; `p. 155` formatted without brackets in table cell.
- `[pp. 58, 89]`: line 38 (§14.2 heading) ✓
- `[pp. 18–20]` (as `pp. 18–20` in table cells): lines 243–245, 266–268; heading line 305 `[pp. 18–20]` ✓
- `[p. 89]`: line 46 in §14.2 CDI On Screen bullet; line 250 in A.2 ✓
- `[p. 158]`: line 251 in A.2 ✓
- `p. 155`: line 285 in A.3 adds table source column — present but without square brackets, consistent with table cell formatting throughout the document ✓

Note: The completion report cites `[p. 155]` with brackets, but the actual text has `p. 155` without brackets (table cell). Content is correct; formatting is consistent with document conventions. Minor.

**S13. PASS** — Coupling Summary present; 105 lines.
`grep '^## Coupling Summary'` → 1 match at line 339. `wc -l` from that point to EOF → **105** lines. Within 95–105 target. Matches completion report claim.

**S14. PASS** — Forward-refs block states "closing fragment."
- Line 341: `Fragment G is the closing fragment — every forward-ref authored in Fragments A through F lands here...`
- Line 421 (Forward cross-references block): `Fragment G is the closing fragment of the GNX 375 Functional Spec V1 body. There are no forward-refs to later fragments because no later fragments exist.`

**S15. PASS** — Three intra-fragment cross-ref blocks present.
- Block 1 (line 427): `**§14.1 XPDR State ↔ §15.1/§15.2/§15.3 XPL Datarefs and Commands.**` ✓
- Block 2 (line 431): `**§15.6 External CDI/VDI Output Contract ↔ §15.1 XPL Datarefs Reads.**` ✓
- Block 3 (line 435): `**§15.7 Altitude Source Dependency ↔ §14.1 and §15.1 pressure altitude dataref.**` ✓

---

### X. ITM-08 + ITM-12 Discipline

**X1. PASS** — ITM-08 grep-verify: all 27 claimed terms confirmed present in Fragment A Appendix B.

a. Terms extracted from Fragment G Coupling Summary backward-refs block:
> Mode S, 1090 ES, UAT, Extended Squitter, TSAA, FIS-B, TIS-B, Flight ID, Squawk code, IDENT, WOW, Target State and Status, TSO-C112e, TSO-C166b (B.1 additions); CDI, VDI, GPSS, WAAS, SBAS, LNAV, LPV, RAIM, ADC, ADAHRS (B.1); Connext (B.3); dataref, persist store (B.2).

b. Independent grep verification against `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`:

*B.1 additions (14 terms — all confirmed at lines 402–416):*
| Term | Result |
|------|--------|
| Mode S | PASS — line 402 |
| 1090 ES | PASS — line 404 |
| UAT | PASS — line 405 |
| Extended Squitter | PASS — line 406 |
| TSAA | PASS — lines 385, 407 |
| FIS-B | PASS — line 408 |
| TIS-B | PASS — line 409 |
| Flight ID | PASS — line 410 |
| Squawk code | PASS — line 411 |
| IDENT | PASS — line 412 |
| WOW | PASS — line 413 |
| Target State and Status | PASS — line 414 |
| TSO-C112e | PASS — line 415 |
| TSO-C166b | PASS — line 416 |

*B.1 core (10 terms — all confirmed at lines 359–392):*
| Term | Result |
|------|--------|
| CDI | PASS — line 364 |
| VDI | PASS — line 387 |
| GPSS | PASS — line 371 |
| WAAS | PASS — line 390 |
| SBAS | PASS — line 382 |
| LNAV | PASS — line 374 |
| LPV | PASS — line 375 |
| RAIM | PASS — line 380 |
| ADC | PASS — line 359 |
| ADAHRS | PASS — line 360 |

*B.2 and B.3:*
| Term | Result |
|------|--------|
| dataref | PASS — line 426 (B.2) |
| persist store | PASS — line 427 (B.2) |
| Connext | PASS — line 440 (B.3) |

c. Excluded terms: `awk '/^## Appendix B/,/^## Appendix C/'` then `grep -i 'EPU\|HFOM\|VFOM\|HDOP\|TSO-C151c'` → **exit code 1, 0 matches**. PASS — excluded terms not present in Appendix B. ✓

**X2. PASS** — ITM-12 format: three randomly selected backward-ref blocks (not the same as completion report).

Block 1 — "Fragment A §3 Power-On and external altitude source framing" (lines 357–360):
3 sentences; prose format, not compact bullet. PASS ✓

Block 2 — "Fragment D §5 FPL Editing and §6 Direct-to Operation" (lines 381–384):
3 sentences; prose format, not compact bullet. PASS ✓

Block 3 — "Fragment E §10.12 ADS-B Status and §10.13 ADS-B Traffic Logging" (lines 395–399):
3 sentences; prose format, not compact bullet. PASS ✓

All three blocks are 2–4 sentence prose per ITM-12. NOT compact single-line bullets.

**X3. PASS** — ITM-12 line count re-confirmed at 105, within 95–105 target. (See S13.)

---

### C. Constraint Adherence

**C1. PASS** — ITM-08 grep-verify: see X1. 27 confirmed present, 5 excluded.

**C2. PASS** — ITM-12 prose-per-ref + 90–110 lines: see X2/X3. 105 lines; prose-per-ref format confirmed.

**C3. PASS** — No forward-refs in Fragment G Coupling Summary.
Forward cross-references block (line 419–421):
> `Fragment G is the closing fragment of the GNX 375 Functional Spec V1 body. There are no forward-refs to later fragments because no later fragments exist. Every behavior, dataref, state, or feature delta that Fragments A through F deferred to §14, §15, or Appendix A resolves within this fragment. The assembled spec will contain no unresolved forward-references from the C2.2 fragment series.`

No `[Fragment H]`, no `→ §16`, no forward-ref to non-existent content. ✓

**C4. PASS** — §14.1 = XPDR State, five items, three modes per D-16: see S2/S3/S6.

**C5. PASS** — §15 does not re-author §11 XPDR behavior.
Line 88 (§15 intro): `§15 specifies interface names, types, and contracts; it does not re-author the pilot-facing XPDR behaviors specified in §11 (Fragment F) — cross-ref §11 for behavioral semantics.`
§15.1–15.3 content consists of dataref names, types, triggers, and notes — interface contract language, not pilot-facing behavioral narrative. Cross-ref to §11 present at line 88. ✓

**C6. PASS** — §15.6 External CDI/VDI Output Contract per D-15.
In addition to S4 verification:
- "GPSS" (roll steering): line 189: `| GPSS roll steering | Compatible autopilots (KAP 140, KFC 225) | Roll-steering command for autopilot coupling | Enabled when GPSS or APR Output configured [pp. 183, 207] |` ✓
- "glidepath capture": line 191: `| Glidepath capture | Autopilot (APR coupling) | LPV glidepath arm/capture signal | Feeds KAP 140 / KFC 225 GS input [p. 207] |` ✓
- TO/FROM flag: line 188: `| TO/FROM flag | External CDI flag indicator | Determines needle sense |...` ✓
- Design-phase flag: line 193: `Design-phase flag — CDI/VDI output dataref names: XPL dataref names for lateral deviation output to external CDI...require design-phase research.` ✓

**C7. PASS** — §15.7 Altitude Source Dependency per D-16.
In addition to S5 verification:
- Advisory message reference: line 205: `The advisory **"ADS-B Out fault. Pressure altitude source inoperative or connection lost."** triggers when the external altitude source is lost — cross-ref §11.13 item 1 (Fragment F) and §13.9 (Fragment F)` ✓
Cross-refs both §11.13 and §13.9 per the constraint requirement.

**C8. PASS** — OQ4 verbatim: see S7.

**C9. PASS** — OQ5 verbatim: see S8.

**C10. PASS** — A.1 D-12 context, including D-02 correction.
- D-12 cited: line 230 ✓
- D-02 nomenclature error resolved: line 230: `The D-02 reference to "GNC 375" was a nomenclature error resolved by D-12: the correct product designation is **GNX 375**` ✓
- GNC 355 deferred: line 232 ✓

**C11. PASS** — A.2 GPS 175 lacks/identical lists.
- Lacks list: `grep -c '^|'` in A.2 section → 7 pipe rows = 2 header + 5 data rows.
  Items: Mode S XPDR, ADS-B Out, Built-in dual-link ADS-B In, TSAA, ADS-B traffic logging. All 5 present ✓
- Identical list (lines 248–253): CDI On Screen ✓, GPS NAV Status indicator key ✓, Knob push = Direct-to ✓

**C12. PASS WITH NOTE** — A.3 GNC 355 lacks/adds/identical.
- Lacks: 7 data rows confirmed by independent pipe count (9 pipe rows − 2 header = 7 data rows) ✓
  Items: Mode S XPDR, ADS-B Out, Built-in ADS-B In, TSAA, ADS-B traffic logging, CDI On Screen, GPS NAV Status indicator key ✓
- Adds: independent pipe count gives 12 pipe rows − 2 header = **10 data rows**. Completion report claims 9; prompt's original expectation was ~6.
  All 6 prompt-specified required items confirmed present: VHF COM radio ✓, COM Standby Control Panel ✓, 25/8.33 kHz ✓, COM volume/sidetone ✓, Flight Plan User Field [p. 155] ✓, Direct-to via standby-frequency-tune ✓.
  Additional items present (legitimate GNC 355 features): COM monitor mode, Reverse frequency lookup (RFL), User COM frequencies (up to 15), COM alerts.
- Identical list present ✓

Note: Adds count is 10, not 9 as the completion report claimed. All 10 items are correct GNC 355 features; no spurious content. The discrepancy is in the completion report's self-count, not the spec content quality.

**C13. PASS** — A.5 feature matrix: 19 rows. See S10.

**C14. PASS** — No sibling-unit consistency drift. Spot-checked three claims:
- "GNC 355 has VHF COM radio": consistent with Fragment F §11's GNX 375 transponder scope (no COM authored there) and Fragment A §1's unit-family framing ✓
- "GNC 355 lacks CDI On Screen": consistent with Fragment A Appendix B.3 which defines CDI On Screen as `GPS 175 + GNX 375 only (not GNC 355/355A)` (line 443 of part_A.md) ✓
- "GNC 355 lacks ADS-B Out": consistent with Fragment F §11 which authors ADS-B Out exclusively as a GNX 375 feature ✓

**C15. PASS** — No §4/§7/§10/§11 re-authoring: see S1. 0 foreign top-level headers.

**C16. PASS** — No COM present-tense on GNX 375: see S11.

**C17. PASS** — Assembly readiness — 3 top-level headings: see F3.

---

### N. Negative Checks

**N1. PASS** — No CSS/HTML stray content.
`grep -nE '<[a-z]+ '` (excluding `<!--`) → exit code 1, 0 matches.

**N2. PASS** — All TBD entries are legitimate design-phase flags.
18 "TBD" matches, all in §15.1, §15.2, §15.3, §15.5 dataref tables and related prose:
- Lines 103–115, 127, 137–142, 173: TBD dataref candidate names in §15.1–15.3 tables, all tagged [OQ4] or [OQ5] — intentional provisional flags awaiting design-phase verification ✓
- Line 173: `FS2024 B equivalents (TBD) | Per Pattern 23` — [OQ5] pending ✓
- Line 208: prose reference to TBD entry in §15.1 ✓
- Line 433: Coupling Summary reference to TBD entries ✓
No unfinished prose TBDs; all are OQ-flagged design-phase placeholders as intended.

**N3. PASS** — No authoring scaffolding.
`grep -n '\[Phase\|Phase A:\|TODO:\|FIXME'` → exit code 1, 0 matches.

---

### A. Assembly Readiness

**A1. PASS** — Forward-ref resolution from archived fragments to Fragment G.

*Fragment F §11.14 → Fragment G §14.1 XPDR State:*
Fragment F §11.14 heading (line 252 of part_F.md): `### 11.14 XPDR Persistent State [§14 cross-ref]`
Fragment F Coupling Summary (line 591): `§11.14 XPDR Persistent State → §14 Persistent State (Fragment G): squawk code, mode, Flight ID (if configurable), ADS-B Out enable state, data field preference.`
Fragment G §14.1 delivers exactly those 5 items in table form. Scope consistent. **PASS** ✓

*Fragment F §12.2 → Fragment G §15.6 External CDI/VDI Output Contract:*
Fragment F Coupling Summary (line 595): `§12.2 Annunciator Bar FROM/TO slot + CDI scale slot → §15.6 External CDI/VDI Output Contract (Fragment G).`
Fragment G §15.6 authored with TO/FROM flag output, CDI scale mode, lateral deviation output — all consistent with §12.2's Annunciator Bar context. **PASS** ✓

*Fragment E §10.11 → Fragment G §15.1 datarefs:*
Fragment E Coupling Summary (line 821): `§10.11 GPS Status → §15 External I/O (Fragment G): GPS status datarefs.`
Fragment G §15.1 XPL Datarefs — Reads table contains GPS position, altitude, groundspeed, heading, and navigation datarefs that service the GPS Status display. Scope consistent. **PASS** ✓

**A2. PASS** — No duplicate H2 headings across all 7 fragments (excluding expected `## Coupling Summary`).
`grep -hE '^## ' docs/specs/fragments/GNX375_Functional_Spec_V1_part_*.md | sort | uniq -d` → only `## Coupling Summary` (expected; stripped on assembly). No spec-body section heading appears in more than one fragment.

**A3. PASS** — Coupling Summary outline footprint confirms 7-fragment decomposition complete.
Line 443: `Together with Fragments A through F, this fragment completes the **7-fragment decomposition per D-18 §"Task partition"** — Fragments A–G cover all 15 outline sections plus Appendices A, B, and C with zero overlap and no gaps. The GNX 375 Functional Spec V1 body is **assembly-ready**`

---

## Notes

1. **C12 Adds count discrepancy (minor):** The completion report's self-review (check #12) claims 9 items in the GNC 355 Adds list; independent verification counts 10 data rows in the A.3 adds table. The 10 items are: VHF COM radio, COM Standby Control Panel, 25/8.33 kHz, COM volume and sidetone offset, COM monitor mode, Reverse frequency lookup (RFL), User COM frequencies (up to 15), COM alerts, Flight Plan User Field, Direct-to via standby-frequency-tune. All are legitimate GNC 355 features; no spurious content. The completion report's self-count underran by 1. The original prompt's baseline of ~6 was the minimum required set; the fragment correctly includes the fuller enumeration.

2. **S12 / p. 155 bracket format (cosmetic):** The completion report cites `[p. 155]` as a verified citation. The actual text at line 285 has `p. 155` without square brackets, consistent with how source columns are formatted throughout all five A-section tables. The citation is present and correct; only the bracket notation in the self-review description is slightly inaccurate.

3. **TBD entries in §15 (by design):** 18 "TBD" entries exist in the dataref tables. These are all OQ4/OQ5-flagged provisional dataref names requiring design-phase verification. The completion report correctly classified these as intentional. N2 confirms none are unfinished prose. These will be resolved by the D1 Design Spec phase.

4. **Coupling Summary at 105 lines (at target ceiling):** The Coupling Summary is exactly at the 95–105 line ceiling. Given that Fragment G is the most backward-ref-dense fragment (14 backward-ref blocks covering all prior fragments), this is expected and appropriate. No trimming recommended; all 14 blocks contribute substantive content.
