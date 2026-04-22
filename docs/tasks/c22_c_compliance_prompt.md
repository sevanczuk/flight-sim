# CC Task: C2.2-C Compliance Verification

**Created:** 2026-04-22T17:25:41-04:00
**Source:** CD Purple session — Turn 12 (post-resumption 2026-04-22) — Phase 1 check-completions generating Phase 2 compliance verification
**Task ID:** GNX375-SPEC-C22-C-COMPLIANCE
**Purpose:** Independently verify the hard-constraint framing commitments, source fidelity, cross-reference fidelity, fragment file conventions, and negative checks declared in `docs/tasks/c22_c_completion.md`. Modeled on the C2.2-B compliance structure (archived at `docs/tasks/completed/c22_b_compliance_prompt.md` and `docs/tasks/completed/c22_b_compliance.md`).

**Scope of verification:** all content in `docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` (725 lines). Do NOT verify anything outside this fragment except where explicitly instructed (PDF spot checks, Fragment A/B cross-references, outline forward-ref targets).

**Output:** `docs/tasks/c22_c_compliance.md` — a compliance report with a PASS/FAIL/PARTIAL verdict for each numbered check, each accompanied by specific evidence (line numbers, grep counts, PDF page citations, and short verbatim quotes where supportive).

**Verdict conventions:**
- **PASS** — constraint verifiably met
- **FAIL** — constraint verifiably violated (would require fix)
- **PARTIAL** — constraint met with a noted caveat (e.g., minor over-enumeration acceptable)
- Use Notes section for observations that don't affect verdict but preserve context for future work

---

## Pre-flight

1. Verify the fragment file exists and has expected line count:
   ```bash
   wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md
   ```
   Expect: 725 lines (per completion report). If substantially different (>±5), note as pre-flight anomaly.

2. Verify Fragment A and Fragment B are available for backward-ref verification:
   ```bash
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md
   ```

3. Verify outline and PDF JSON are available for source-fidelity checks:
   ```bash
   ls docs/specs/GNX375_Functional_Spec_V1_outline.md
   ls assets/gnc355_pdf_extracted/text_by_page.json
   ```

4. Read the full fragment into working memory.

5. Read the completion report `docs/tasks/c22_c_completion.md`.

---

## Checks

### F. Framing Commitments (11 checks)

**F1. Fragment C opens with `### 4.7 Procedures Pages` directly — NO `## 4. Display Pages` header.** This is the most critical structural commitment for Fragment C. Verify two things:

- `grep -c '^## 4\. Display Pages' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` must return exactly **0**
- The first `###` heading in the spec-body portion (after the fragment header) must be `### 4.7`

Quote the first `###` heading line and its line number.

**F2. §4.7 Visual Approach — external CDI/VDI only for vertical deviation (per D-15).** Locate the Visual Approach sub-section (around §4.7's Visual Approach heading). Verify:

- Prose explicitly states vertical deviation is output to external CDI/VDI only, NOT rendered on the GNX 375 screen
- D-15 is cited OR the no-internal-VDI framing is explicit
- Pilot's Guide p. 205 is cited (this is the PDF source)
- NO prose anywhere in the fragment implies the GNX 375 renders a VDI internally

Quote the key sentence(s). Confirm by searching for `VDI` across the fragment and spot-checking each match — every match must either state "external" or "no internal" or appear in a cross-ref/open-question context.

**F3. §4.7 XPDR-interaction context preserved as forward-refs only.** §4.7 documents page structure; operational XPDR-during-approach behavior lives in §7.9 + §11.4. Verify:

- Three open questions appear at end of §4.7 (per outline): (a) XPDR altitude reporting during approach, (b) ADS-B traffic / TSAA during approach, (c) Autopilot roll steering datarefs
- Each XPDR-approach or ADS-B-approach open question includes explicit forward-refs to §7.9 and/or §11.4
- NO operational XPDR behavior authored in §4.7 (no "pilot enters squawk code by...", no "IDENT button behavior", no Mode S protocol details)

Quote the three open-question headings and their forward-refs.

**F4. §4.9 ADS-B built-in receiver framing flip.** The most distinctive 375-specific framing in this fragment. Verify both FIS-B Weather and Traffic Awareness sub-sections explicitly state:

- "Built-in dual-link ADS-B In receiver" OR "built-in 978 MHz UAT receiver" (FIS-B side)
- "Built-in dual-link ADS-B In receiver (1090 ES + UAT)" or similar (Traffic side)
- Explicit contrast with GPS 175 (no built-in ADS-B In) AND GNC 355/355A (no built-in ADS-B In) — i.e., prose states both siblings require external hardware

`grep -ni 'built-in\|built in' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — enumerate matches; confirm the distribution is predominantly in §4.9 (and §4.10 ADS-B Status).

**F5. §4.9 TSAA = GNX 375 only (with aural alerts).** Verify:

- TSAA is framed throughout as GNX 375-only
- Siblings (GPS 175, GNC 355/355A) explicitly noted as lacking TSAA
- Aural alerts noted as GNX 375-only feature
- NO prose anywhere suggests TSAA is available on GPS 175 or GNC 355

`grep -ni 'TSAA' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — enumerate matches; confirm all refs are GNX 375-consistent.

**F6. §4.9 OPEN QUESTION 6 (TSAA aural alert delivery mechanism) preserved verbatim with `sound_play` language.** The prompt required the exact phrase to be preserved. Verify:

- `grep -ni 'sound_play\|OPEN QUESTION 6\|TSAA aural' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — enumerate matches
- Expect the verbatim preservation in at least the §4.9 Open questions block (may also appear in the Traffic body per self-review claim)
- Quote the full OPEN QUESTION 6 paragraph from the fragment and confirm the design-phase-deferred framing (no resolution)

**F7. §4.9 B4 Gap 1 (terrain/obstacle canvas overlays) preserved as design-phase decision.** Verify:

- `grep -ni 'B4 Gap 1' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — match in §4.9 (AMAPI notes or Open questions)
- Prose frames this as "same design-decision gap as §4.2 Map Page" (Fragment B)
- NO attempt to resolve in the spec body

**F8. §4.9 FIS-B data source + ADS-B sim availability open questions preserved.** Verify both are present:

- FIS-B data source in Air Manager: design-phase decision
- ADS-B In data availability in simulators (XPL/MSFS): research during design

Quote each open-question heading and confirm the research-needed / design-phase-deferred framing.

**F9. §4.10 CDI On Screen = GNX 375 / GPS 175 only; lateral only (per D-15).** Verify:

- `grep -ni 'CDI On Screen' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — enumerate matches
- §4.10 CDI On Screen sub-section states "GNX 375 / GPS 175 only" or equivalent
- Explicitly states "NOT GNC 355/355A" (or equivalent negative framing)
- Explicitly states "lateral only" or "no VDI" with D-15 cite
- Pilot Settings inventory table row for CDI On Screen shows ✓ for GNX 375 and GPS 175, — (or similar) for GNC 355/355A

**F10. §4.10 ADS-B Status page = built-in receiver framing (no external LRU).** Verify:

- §4.10 ADS-B Status sub-section states "built-in" receiver framing
- Explicitly states "no external LRU required" or equivalent
- AIRB / SURF / ATAS sub-pages mentioned (per completion report claim)

**F11. §4.10 Logs page = GNX 375 ADS-B traffic logging (not on siblings).** Verify:

- Logs sub-section explicitly states ADS-B traffic data logging is GNX 375-only
- Explicitly states "not available on GPS 175 or GNC 355/355A" (or equivalent)
- WAAS diagnostic logging framed as available on all units (no GNX 375-only claim)

---

### S. Source Fidelity (5 checks)

**S12. GPS Flight Phase Annunciations table — PDF p. 184–185 verification.** The fragment's table enumerates 11 annunciations (OCEANS, ENRT, TERM, DPRT, LNAV, LNAV/VNAV, LNAV+V, LP, LP+V, LPV, MAPR). The outline listed 9 (OCEANS, ENRT, TERM, DPRT, LNAV+V, LNAV, LP+V, LP, LPV). Fragment adds LNAV/VNAV and MAPR.

Verification procedure: write a Python script (saved `.py` file per D-08) that reads `assets/gnc355_pdf_extracted/text_by_page.json`, extracts text from pages 184 and 185, and searches for each of the 11 annunciation codes. Report FOUND/NOT FOUND per code with specific pages. If LNAV/VNAV and MAPR both appear in the PDF, this is S13-pattern (fragment correctly extends outline from PDF). If either is absent from pp. 184–185 but present elsewhere, note the actual page. If either is absent from the PDF entirely, flag as FAIL (potential hallucination).

**S13. FIS-B weather products table — PDF pp. 230–243 verification.** The fragment's table enumerates 13 products (NEXRAD, METARs, TAFs, Graphical AIRMETs, SIGMETs, PIREPs, Cloud Tops, Lightning, CWA, Winds/Temps Aloft, Icing, Turbulence, TFRs).

Write a Python script that extracts text from PDF pp. 230–243 and searches for each product name. Report FOUND/NOT FOUND per product with specific pages. All 13 should appear. If any are absent, flag.

Also confirm the Product Status table's 3 states (Unavailable, Awaiting Data, Data Available) appear on p. 231.

**S14. Approach types table — PDF pp. 199–206 verification.** The fragment's table enumerates 7 approach types (LNAV, LNAV/VNAV, LNAV+V, LPV, LP, LP+V, ILS). Write a Python script that extracts text from PDF pp. 199–206 and searches for each type. Report FOUND/NOT FOUND per type. All 7 should be confirmable.

**S15. ADS-B Status AIRB / SURF / ATAS sub-pages — PDF pp. 107–108 verification.** The fragment claims AIRB (Airborne), SURF (Surface), ATAS (Airborne Traffic Alerting, includes TSAA) as the three traffic applications. The outline mentions Traffic Application Status but does not explicitly enumerate AIRB/SURF/ATAS.

Write a Python script that extracts text from PDF pp. 107–108 and searches for AIRB, SURF, ATAS. Report FOUND/NOT FOUND.

**S16. Page citations preserved — spot check of 8 specific citations.** Verify each citation appears in the fragment at the corresponding sub-section:

| Citation | Expected sub-section |
|---|---|
| `[pp. 181–207]` | §4.7 heading |
| `[pp. 184–185]` | §4.7 GPS Flight Phase Annunciations |
| `[p. 205]` | §4.7 Visual Approach (D-15 framing) |
| `[p. 207]` | §4.7 Autopilot Outputs |
| `[pp. 209–221]` | §4.8 heading |
| `[pp. 225–244]` | §4.9 FIS-B Weather sub-section |
| `[pp. 245–256]` | §4.9 Traffic Awareness sub-section |
| `[pp. 257–269]` | §4.9 Terrain Awareness sub-section |
| `[p. 89]` | §4.10 CDI On Screen |
| `[pp. 107–108]` | §4.10 ADS-B Status |
| `[p. 109]` | §4.10 Logs |

Report PASS/FAIL per citation.

---

### X. Cross-Reference Fidelity (3 checks)

**X17. Fragment A backward-refs resolve to real sub-sections.** The Coupling Summary declares 4 Fragment A backward-ref categories (§1, §2, §3, Appendix B). Verify each cited Fragment A sub-section exists:

- §1 in Fragment A: does it discuss GNX 375 baseline framing and no-internal-VDI?
- §2 in Fragment A: does it discuss knob/touchscreen behaviors?
- §3 in Fragment A: does it include SD card specs (FAT32, 8–32 GB)?
- Appendix B in Fragment A: does it contain glossary entries for FIS-B, TSAA, UAT, 1090 ES, TSO-C112e, TSO-C166b, TSO-C151c, EPU, HFOM/VFOM, HDOP, SBAS, WOW, IDENT, Flight ID?

Use `grep -n` to locate these targets in Fragment A. Report PASS/FAIL per category.

**X18. Fragment B backward-refs resolve to real sub-sections.** The Coupling Summary declares 3 Fragment B backward-ref categories (§4.1, §4.2, §4.3). Verify each:

- §4.1 in Fragment B: Home Page app icon inventory exists (Weather, Traffic, Terrain, Utilities, System Setup)
- §4.2 in Fragment B: Map Page overlay inventory exists (NEXRAD, Traffic, TFRs, Airspaces, SafeTaxi, Terrain)
- §4.3 in Fragment B: FPL Page with GPS NAV Status indicator key layout

Use `grep -n` to locate these targets. Report PASS/FAIL per category.

**X19. Forward-ref targets exist in outline.** The Coupling Summary enumerates forward-refs to Fragments D, E, F, G. Verify each target section exists in the outline `docs/specs/GNX375_Functional_Spec_V1_outline.md`:

| Forward-ref target | Expected outline location |
|---|---|
| §7 | `## 7. Procedures` |
| §7.9 (or §7.D, equivalents) | §7 sub-section for XPDR-during-approach |
| §10 | `## 10. Settings / System Pages` |
| §11 | `## 11. Transponder + ADS-B Operation` |
| §11.4 | §11 sub-section for XPDR modes |
| §11.11 | §11 sub-section for ADS-B In (Built-in Dual-link Receiver) |
| §12.4 | §12 sub-section for Aural alert hierarchy |
| §14 | `## 14. Persistent State` |
| §15 | `## 15. External I/O` |
| §15.6 | §15 sub-section for External CDI/VDI output contract |

Use `grep -n` to locate each target in the outline. Report PASS/FAIL per target. PARTIAL acceptable if target section exists but sub-section numbering differs slightly (e.g., §7.D vs. §7.9 — same concept, different numeric).

---

### C. Fragment File Conventions (2 checks)

**C20. YAML front-matter, fragment header, and heading levels correct per D-18.** Verify:

- Lines 1–6: YAML front-matter present with `Created`, `Source: docs/tasks/c22_c_prompt.md`, `Fragment: C`, `Covers: §§4.7–4.10 ...`
- Fragment header: `# GNX 375 Functional Spec V1 — Fragment C`
- No `## 4. Display Pages` header (confirmed in F1)
- Sub-sections use `###` (levels: `### 4.7`, `### 4.8`, `### 4.9`, `### 4.10`)
- Harvest-category markers check: `grep -nE '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — expect **0 matches** in `###` lines

**C21. Coupling Summary correctly delineated as coordination metadata.** Verify:

- `## Coupling Summary` heading exists at end of fragment
- Coupling Summary is preceded by a `---` horizontal rule
- First lines of Coupling Summary state "authored per D-18 for CD/CC coordination" and "stripped on assembly" (or equivalent)
- Coupling Summary content includes: backward-refs (A + B), forward-refs (D–G), §4 parent-scope inheritance note, outline coupling footprint (4 sub-blocks expected)

Line-number the Coupling Summary start and end.

---

### N. Negative Checks (4 checks)

**N22. `grep -c '^## 4\. Display Pages'` returns exactly 0.** This is the single most important negative check for Fragment C — redundant with F1 but deliberately restated as an independent negative check so the compliance report unambiguously documents the structural commitment.

**N23. No §§4.1–4.6 content leaked into Fragment C.**

`grep -nE '^### 4\.(1|2|3|4|5|6)' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — expect **0 matches**. (Those sub-sections belong to Fragment B and must not appear in C.)

**N24. No later-fragment (§§5–15) scope content in Fragment C.**

`grep -nE '^(## |### )(5|6|7|8|9|10|11|12|13|14|15)\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — expect **0 matches**. Any mention of §§5–15 content must be as forward-refs in prose (e.g., "see §7 for operational detail"), NOT as authored section headers.

**N25. No §11 XPDR panel internals authored anywhere in Fragment C.**

`grep -nEi 'squawk code|IDENT button|Mode S|Extended Squitter' docs/specs/fragments/GNX375_Functional_Spec_V1_part_C.md` — enumerate matches. Each match must either be:
- A peripheral reference (e.g., "transponder software version in System Status")
- A receiver-type description (e.g., "1090 ES (Extended Squitter)" framed as ADS-B In reception, not XPDR output)
- An explicit forward-ref to §11

NOT:
- Step-by-step procedures for entering a squawk code
- IDENT button press workflow
- Mode S protocol mechanics
- XPDR mode transitions

Quote each match and classify. Flag any that describe XPDR internals as operational procedures.

---

## Notes section

Include a Notes section at the end of the compliance report for observations that don't fit a PASS/FAIL check. Candidates:

1. **Line-count overage classification:** the completion report classifies the +26% overage as structural (required tables + Coupling Summary template + open-question blocks). If the independent check confirms all tables are PDF-sourced (via S12–S15) and the Coupling Summary is template-driven (via C21), then the overage classification is confirmed — observation-level Note, not a FAIL.

2. **Fragment B trailing newline (798 vs. expected 799):** Pre-flight noted this. Observation-level; no action.

3. **Any outline-vs-PDF discrepancies surfaced during S12–S15** — e.g., if LNAV/VNAV or MAPR is in the PDF but was missed by the outline, note as S13-pattern (fragment more PDF-accurate than outline). This is valuable to preserve even though no fragment action is needed.

4. **Approach downgrade advisory text, "Enable APR Output" advisory, "ILS and LOC approaches are not approved for GPS." popup text:** these are short quoted-looking strings in the fragment. Verify they are <15 words each and appear in quotation marks (or verify the phrasing does not claim to be a direct quote).

5. **MAPR / RNP 0.3 regulatory citation (AC 90-101A):** the fragment cites AC 90-101A in §4.7 RF Leg section. Note whether this citation is in the Pilot's Guide or added by CC as context. If added by CC, note — not a defect, just context preservation.

---

## Completion

1. Write `docs/tasks/c22_c_compliance.md` with:
   - YAML front-matter: `Created`, `Source: docs/tasks/c22_c_compliance_prompt.md`
   - Summary table: total checks, PASS/FAIL/PARTIAL counts
   - Results sections in order (F, S, X, C, N) with evidence per check
   - Notes section
   - Verdict line: "ALL PASS", "PASS WITH NOTES", "PARTIAL PASS", or "FAIL"

2. `git add -A`

3. `git commit` with D-04 trailers (via `[System.IO.File]::WriteAllText` BOM-free + `git commit -F`):

   ```
   GNX375-SPEC-C22-C-COMPLIANCE: verify Fragment C compliance

   Phase 2 compliance for C2.2-C per check-compliance protocol.
   Verdict: {ALL PASS | PASS WITH NOTES | ...}
   Checks: {N} total ({P} PASS, {F} FAIL, {PR} PARTIAL)

   {1-2 sentence summary of notable findings}

   Task-Id: GNX375-SPEC-C22-C-COMPLIANCE
   Authored-By-Instance: cc
   Refs: D-18, D-19, D-20, D-21, GNX375-SPEC-C22-C
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

4. Send ntfy notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-C-COMPLIANCE completed [flight-sim]"
   ```

5. Do NOT git push.

---

## Estimated duration

~5–10 min CC wall-clock (LLM-calibrated per D-20: compliance is mostly grep + PDF-text search; 3 Python scripts for PDF spot checks S12–S15 add a few minutes of script authoring and execution).
