# CC Task Prompt: GNX375-SPEC-C22-B Compliance Verification

**Created:** 2026-04-22T16:07:03-04:00
**Source:** CD Purple Turn 5 (post-resumption 2026-04-22) — Phase 1 check-completions for C2.2-B
**Task ID:** GNX375-SPEC-C22-B-COMPLIANCE
**Verifying:** GNX375-SPEC-C22-B (completed 2026-04-22)
**Prompt under review:** `docs/tasks/c22_b_prompt.md`
**Completion report under review:** `docs/tasks/c22_b_completion.md`
**Fragment under verification:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` (reported 798 lines)
**Referenced sources:**
- Outline: `docs/specs/GNX375_Functional_Spec_V1_outline.md`
- Fragment A (prior archived fragment): `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`
- Manifest: `docs/specs/GNX375_Functional_Spec_V1.md`
- PDF source: `assets/gnc355_pdf_extracted/text_by_page.json`
- Land-data-symbols supplement: `assets/gnc355_reference/land-data-symbols.png`
- Decisions: D-18 (format), D-19 (line-count ratio), D-15 (display architecture), D-16 (XPDR/ADS-B scope)
- Harvest map: `docs/knowledge/355_to_375_outline_harvest_map.md`

**Task type:** docs-only (read-only verification; no file modifications)
**CRP applicability:** NO

---

## Instructions

This is a **read-only verification task**. Do NOT modify any source files. Verify that the C2.2-B fragment matches the original prompt's 11 framing commitments, preserves all flagged open questions, cites sources faithfully, resolves cross-references correctly, and follows D-18 fragment file conventions.

Read `CLAUDE.md` for project conventions.

For each checklist item below, report:
- **PASS** — with the evidence (file, line number, relevant snippet)
- **FAIL** — with what was expected vs. what was found
- **PARTIAL** — with explanation of what's present and what's missing

Use `grep -n` liberally. Quote specific lines that prove compliance. This compliance check goes deeper than CC's Phase K self-review (which was predominantly grep-based). It adds PDF-sourcing verification, cross-reference resolution, and behavioral checks.

---

## Checklist

### F. Framing Commitments (11 items from prompt §"Specific framing commitments")

**F1. B4 Gap 1 (Map rendering architecture) preserved as unresolved design-phase decision.**
- `grep -n 'B4 Gap 1\|Map rendering architecture\|canvas vs\.\|Map_add API vs\.\|video streaming' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`
- Confirm at least one match in §4.2 flags the gap as "deferred to design phase" or equivalent.
- **Behavioral check:** read §4.2 Map page prose (map interactions, overlays, AMAPI notes, Open questions subsections) end-to-end. Confirm NO sentence commits to a specific rendering technology (no "the Map page uses the Map_add API", no "implemented via canvas drawing", no "rendered via video streaming"). Quote any sentence that appears to commit and flag as FAIL.

**F2. B4 Gap 2 (scrollable list implementation) preserved as unresolved.**
- `grep -n 'B4 Gap 2\|scrollable list' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`
- Confirm match in §4.3 AMAPI notes or Open questions flags B4 Gap 2 as design-phase decision.
- **Behavioral check:** §4.3 documents the FPL list's behavior (row content, coloring, active-leg highlighting, scrolling) but does NOT commit to an implementation mechanism (e.g., no "implemented using GTN 650 sample pattern X").

**F3. OPEN QUESTION 1 (altitude constraints on FPL legs) preserved.**
- `grep -ni 'altitude constraint\|OPEN QUESTION 1\|VCALC' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`
- Confirm match in §4.3 preserves the VCALC-is-separate-tool framing.
- Confirm prose flags the behavior as unknown and defers to design-phase research.

**F4. §4.1 XPDR app icon framed as GNX 375-only.**
- The §4.1 app icon inventory table shows XPDR with a GNX 375-only marker (e.g., "✓ (GNX 375 only)") and em-dashes / absence markers for GPS 175 and GNC 355/355A.
- Prose in §4.1 states the XPDR icon is present on GNX 375 and absent on siblings.
- Forward-ref to §11 (Fragment F) for XPDR Control Panel internals.
- `grep -n 'XPDR' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — enumerate every match. Each should be in (a) §4.1 icon inventory, (b) §4.2 overlay context as "Traffic / ADS-B In", (c) §4.3 GPS NAV Status context, or (d) Coupling Summary forward-ref. No match should describe XPDR modes, squawk code entry, IDENT, or other §11 internals.

**F5. §4.3 GPS NAV Status indicator key framed as GNX 375 / GPS 175 only.**
- The §4.3 sub-section heading or prose explicitly includes "GNX 375 / GPS 175 only" and "NOT GNC 355" (or equivalent).
- The three states (no flight plan, active route display, CDI scale active) are documented as a table or explicit enumerated list.
- Each state's trigger condition and display contents are specified.

**F6. §4.3 Flight Plan User Field omission.**
- `grep -ni 'Flight Plan User Field' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`
- Each match is in §4.3 and states the field is NOT on GNX 375 (GNC 355/355A only).
- **Negative check:** no prose documents the field's behavior (options, configuration, use-case, page-layout position). A one-to-three sentence omission note is acceptable; documenting the field's behavior is FAIL.

**F7. §4.5 Airport Weather tab FIS-B built-in receiver framing.**
- §4.5 Airport Weather (WX Data) tab description explicitly states the GNX 375 has a **built-in** dual-link ADS-B In receiver.
- Explicit contrast with GPS 175 (no built-in / requires external hardware) and/or GNC 355/355A.
- Open question preserved for degraded-state behavior when no FIS-B ground station uplink is available.

**F8. No COM present-tense on GNX 375.**
- `grep -ni 'COM radio\|COM standby\|COM volume\|COM frequency\|COM monitoring\|VHF COM' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`
- Each match is in sibling-unit comparison context ("the GNC 355 adds...", "on GNC 355/355A...", "[feature] is not present on GNX 375"), never "the GNX 375 has X."
- The §4.1 app icon inventory does NOT list a COM icon as present on GNX 375.
- The §4 parent scope or §4.1 text mentions §4.11 COM Standby Control Panel as omitted on GNX 375 OR Fragment A already established this (acceptable either way — do not double-flag).

**F9. §4.2 Default Map user fields per-unit distinction.**
- §4.2 contains a table with at least 3 rows: GNX 375, GPS 175, GNC 355/355A.
- GNX 375 and GPS 175 rows share the same defaults.
- GNC 355/355A row differs (expected difference: "from/to/next waypoints" as fourth field vs. "distance/bearing from destination airport" for GNX 375 / GPS 175).
- Prose distinguishes the per-unit defaults explicitly.

**F10. §4.2 Land data symbols supplement referenced.**
- `grep -n 'land-data-symbols\|gnc355_reference' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`
- Match in §4.2 Land Data Symbols section cites the supplement path `assets/gnc355_reference/land-data-symbols.png` (or equivalent).
- Fragment acknowledges Pilot's Guide p. 125 is sparse and defers to the supplement for the symbol list.

**F11. No internal VDI framing.**
- `grep -ni 'VDI\|vertical deviation indicator' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`
- Expected result: zero or near-zero matches. If any match exists, verify it does NOT imply the GNX 375 renders VDI internally. (VDI framing lives in §7 Procedures and §15 External I/O in later fragments.)

---

### S. Source Fidelity (outline and PDF alignment)

**S12. §4.2 map overlays enumeration — PDF sourcing verification.**
The fragment's §4.2 overlays table lists 11 overlays (per CC's completion report): TOPO, Terrain, Traffic, NEXRAD, Lightning, METAR, TFRs, Airspaces, Airways, Obstacles and Wires, SafeTaxi. The outline named 7 (TOPO, Terrain, Traffic, NEXRAD, TFRs, Airspaces, SafeTaxi). Verify the 4 extras (Lightning, METAR, Airways, Obstacles and Wires) are PDF-sourced from pp. 133–139 or adjacent map-setup pages (116–132), not invented.

Procedure:
- Write a Python script (saved to `.py` file per D-08, NOT inline `python -c`) that reads `assets/gnc355_pdf_extracted/text_by_page.json` and prints the text of pages 116 through 139 inclusive (i.e., `pages[115]` through `pages[138]`).
- Search the output for each of the 4 extras: "Lightning", "METAR", "Airways", "Obstacles" (or "Wires").
- For each extra, report whether it appears in the PDF text and on which page (or state "not found in pp. 116-139").
- **PASS:** every extra appears in the PDF text.
- **PARTIAL:** 1-2 extras not found; fragment may be over-enumerating but not inventing the overall set.
- **FAIL:** 3+ extras absent from PDF — suggests invention.

**S13. §4.5 Search Tabs structure — PDF sourcing verification.**
The fragment's §4.5 Search Tabs table lists 6 tabs: Recent, Nearest (with class filter), Flight Plan, User, Search by Name, Search by City. The outline listed 7 categories: Airport, Intersection, VOR, NDB, User Waypoint, Search by Name, Search by Facility Name. These structures differ — the fragment may be PDF-accurate and the outline less granular, OR the fragment may have restructured incorrectly.

Procedure:
- Read `assets/gnc355_pdf_extracted/text_by_page.json` pages 169 through 171 (i.e., `pages[168]` through `pages[170]`) via a saved Python script.
- Confirm whether the tabs "Recent", "Nearest", "Flight Plan", "User", "Search by Name", "Search by City" (or "Search by Facility Name") appear in the PDF text.
- Specifically verify: is the correct Pilot's Guide term "Search by City" or "Search by Facility Name"? The outline used the latter.
- **PASS:** fragment's 6-tab structure is PDF-accurate with correct term.
- **PARTIAL:** structure is close but one term differs (e.g., "Search by City" vs. "Search by Facility Name"); report the PDF term.
- **FAIL:** fragment's structure is invented (tabs not in PDF).

**S14. §4.3 FPL Data Columns enumeration — PDF sourcing verification.**
The fragment's §4.3 Data Columns section lists 6 options (CUM, DIS, DTK, ESA, ETA, ETE) with default assignments (Column 1 = DTK, Column 2 = DIS, Column 3 = CUM). The outline said "selectable; Edit Data Fields; restore to defaults option" without enumerating.

Procedure:
- Read `assets/gnc355_pdf_extracted/text_by_page.json` page 149 (`pages[148]`) via a saved Python script.
- Confirm the 6 options appear in the PDF text.
- Confirm the default assignments (DTK / DIS / CUM) match the PDF.
- **PASS:** enumeration and defaults are PDF-sourced.
- **PARTIAL:** some options or defaults present, others missing — report discrepancies.
- **FAIL:** enumeration is CC-invented.

**S15. Sampled outline page citations preserved in fragment.**
Verify the following outline citations appear in the fragment at the expected sub-section. Use `grep -n` with the page-range pattern.

| Expected citation | Expected sub-section |
|-------------------|----------------------|
| `[pp. 17, 28–29, 86]` or equivalent | §4.1 Home Page heading |
| `[pp. 113–139]` | §4.2 Map Page heading |
| `[p. 124]` | §4.2 Aviation data symbols sub-block |
| `[p. 125]` | §4.2 Land data symbols sub-block |
| `[pp. 140–157]` | §4.3 FPL Page heading |
| `[p. 158]` | §4.3 GPS NAV Status indicator key sub-block |
| `[pp. 159–164]` | §4.4 Direct-to Page heading |
| `[pp. 165–178]` | §4.5 Waypoint Information Pages heading |
| `[pp. 179–180]` | §4.6 Nearest Pages heading |

Report any missing or miscited page ranges (e.g., "§4.2 heading shows `[pp. 113–140]` instead of `[pp. 113–139]`").

---

### X. Cross-Reference Fidelity

**X16. Fragment A backward-refs resolve to real sub-sections.**
The fragment's prose references Fragment A sub-sections inline using "see §N.x" language (Fragment A contains §§1–3, Appendix B, Appendix C).

Procedure:
- `grep -nE 'see §[123]\.[0-9]|§1\.[0-9]|§2\.[0-9]|§3\.[0-9]|Appendix B' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — enumerate all Fragment A backward-refs in fragment prose (exclude matches inside the Coupling Summary section).
- For each unique referenced sub-section (e.g., §2.1, §2.3, §2.4, §2.5, §2.6, §2.7, Appendix B, Appendix B.1, Appendix B.3), verify it exists in Fragment A: `grep -nE '^### [123]\.[0-9]|^### Appendix B' docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`.
- Report any dangling refs (fragment cites a sub-section that does not exist in Fragment A).

**X17. Coupling Summary backward-refs match in-prose citations.**
Verify:
- Every Fragment A sub-section mentioned in the in-prose backward-refs (from X16) appears in the Coupling Summary's "Backward cross-references" enumeration.
- Conversely, the Coupling Summary does not claim backward-refs to Fragment A sub-sections that are not actually referenced in prose. (Minor over-enumeration is acceptable; missing enumeration is FAIL.)

**X18. Coupling Summary forward-refs target outline-authorized sections.**
The Coupling Summary's "Forward cross-references" list should target sections that exist in the outline.

Procedure:
- `grep -nE '^## [0-9]+\.' docs/specs/GNX375_Functional_Spec_V1_outline.md` — enumerate outline top-level section numbers (should be §1 through §15 plus Appendices A-C).
- Enumerate the forward-ref targets in the Coupling Summary (e.g., §5, §6, §7, §8, §9, §10, §11, §11.7, §11.11, §14, §15, §4.9).
- For each, confirm the target exists in the outline. Report any target that does not resolve.

---

### C. Fragment File Conventions (D-18)

**C19. YAML front-matter, fragment header, and heading levels.**
Verify:
- YAML front-matter present at top of file with 4 fields: `Created`, `Source`, `Fragment`, `Covers`.
- `Source` field value is `docs/tasks/c22_b_prompt.md`.
- `Fragment` field value is `B`.
- `Covers` field describes §§4.1–4.6.
- Fragment header line: `# GNX 375 Functional Spec V1 — Fragment B` (exactly; single `#`).
- Top-level spec heading: `## 4. Display Pages` (exactly; double `##`).
- Sub-section headings use `### 4.1`, `### 4.2`, etc. (triple `###`).
- **No harvest-category markers in spec-body sub-section headings:** `grep -nE '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` should return zero matches. (Pilot's Guide page citations like `[pp. 113–139]` ARE expected and do NOT count as harvest markers.)

**C20. Coupling Summary clearly delineated as coordination metadata.**
Verify:
- `## Coupling Summary` heading is present.
- An explicit note at the start of the Coupling Summary section states it is "authored per D-18" and "stripped on assembly" (or equivalent language).
- The Coupling Summary appears after the last spec-body sub-section (§4.6) and is separated by a horizontal rule.

---

### N. Negative Checks

**N21. §4 parent scope authored exactly once.**
- `grep -c '^## 4\. Display Pages' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` should equal exactly 1.

**N22. No §§4.7–4.10 content leaked from Fragment C scope.**
- `grep -nE '^### 4\.(7|8|9|10)' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` should return zero matches (these sub-sections are Fragment C scope).
- Read §4.6 and the subsequent section boundary — confirm the next heading is `## Coupling Summary`, not a §4.7+ heading.

**N23. No XPDR-panel internals, no §§5–15 operational workflow detail, no Appendix A family-delta content.**
- Beyond §4.1 app icon forward-ref and §4.2/§4.3 peripheral mentions, fragment prose does NOT document: XPDR modes (Standby/On/Altitude Reporting), squawk code entry, IDENT button, Extended Squitter details, Flight Plan editing workflows (§5 scope), full Direct-to operational sequences (§6 scope), procedure loading/activation workflows (§7 scope), full Nearest operational behavior (§8 scope), full waypoint management (§9 scope), Settings configuration detail (§10 scope), persistence state schema (§14 scope), dataref/event listings (§15 scope), family-delta comparison tables (Appendix A scope).
- Spot-check by reading §§4.1–4.6 prose. Report any content that appears to author detail belonging to later fragments.

---

## Output

Write the compliance report to `docs/tasks/c22_b_compliance.md` with this structure:

```markdown
---
Created: {ISO 8601 timestamp}
Source: docs/tasks/c22_b_compliance_prompt.md
---

# C2.2-B Compliance Report

**Verified:** {ISO 8601 timestamp}
**Verdict:** [ALL PASS / PASS WITH NOTES / FAILURES FOUND]

## Summary
- Total checks: 23
- Passed: [N]
- Failed: [N]
- Partial: [N]

## Results

### F. Framing Commitments
F1. [PASS/FAIL/PARTIAL] — [evidence]
F2. ...
...F11.

### S. Source Fidelity
S12. ...
S13. ...
S14. ...
S15. ...

### X. Cross-Reference Fidelity
X16. ...
X17. ...
X18. ...

### C. Fragment File Conventions
C19. ...
C20. ...

### N. Negative Checks
N21. ...
N22. ...
N23. ...

## Notes

[Observations, minor deviations, or recommendations that don't rise to FAIL level but are worth documenting. Particularly: PDF-sourcing spot-check results (S12, S13, S14) — if any overlay, tab, or option enumeration diverges from the PDF, detail the specific divergence so CD can assess whether it's acceptable.]
```

---

## Completion Protocol

1. Write compliance report to `docs/tasks/c22_b_compliance.md` per structure above.

2. `git add -A`

3. `git commit` with D-04 trailers. Write the commit message via BOM-free `[System.IO.File]::WriteAllText()`:

```powershell
$msg = @'
GNX375-SPEC-C22-B-COMPLIANCE: verification report for fragment B

Read-only compliance verification of fragment B (docs/specs/fragments/
GNX375_Functional_Spec_V1_part_B.md) against the prompt's 11 framing
commitments, 4 source-fidelity PDF spot-checks, 3 cross-reference
fidelity checks, 2 fragment file convention checks, and 3 negative
checks. Verdict: {verdict}.

Task-Id: GNX375-SPEC-C22-B-COMPLIANCE
Authored-By-Instance: cc
Refs: D-18, D-19, GNX375-SPEC-C22-B
Co-Authored-By: Claude Code <noreply@anthropic.com>
'@
[System.IO.File]::WriteAllText((Join-Path $PWD ".git\COMMIT_EDITMSG_cc"), $msg)
git commit -F .git\COMMIT_EDITMSG_cc
Remove-Item .git\COMMIT_EDITMSG_cc
```

4. Send completion notification:
```powershell
Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-B-COMPLIANCE completed [flight-sim]"
```

5. **Do NOT git push.**

---

## Estimated duration

- CC wall-clock: ~5–15 min (LLM-calibrated per D-20; read-only compliance verification with 4 PDF-sourcing sub-tasks requiring a saved Python script to read JSON-encoded PDF pages; ×1 baseline for compliance-class task, no reuse adjustment since this is the first compliance prompt using the updated D-20 heuristic).
- CD coordination cost after CC completes: ~1 "check compliance" turn to triage verdict → PASS → archive 4 files and update manifest; FAIL → bug-fix task.

Proceed when ready.
