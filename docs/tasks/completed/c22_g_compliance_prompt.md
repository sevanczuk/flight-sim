# CC Task Prompt: GNX375-SPEC-C22-G Compliance Verification

**Task ID:** GNX375-SPEC-C22-G-COMPLIANCE
**Verifying:** GNX375-SPEC-C22-G (completed 2026-04-25)
**Prompt:** `docs/tasks/c22_g_prompt.md`
**Completion:** `docs/tasks/c22_g_completion.md`
**Output under verification:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md`
**Spec:** `docs/specs/GNX375_Functional_Spec_V1.md` (manifest)
**Created:** 2026-04-25T09:56:56-04:00
**Source:** Purple Turn 4 — Phase 1 check-completions cross-reference of c22_g_prompt.md vs. c22_g_completion.md

---

## Instructions

This is a **read-only verification task**. Do NOT modify any source files. Verify that the C2.2-G implementation matches the original prompt and the C2.2 series conventions by gathering concrete evidence from the fragment file, the surrounding archived fragments, and the issue index.

Read `CLAUDE.md` for project conventions.

For each checklist item below, report:
- **PASS** — with the evidence (file, line number, relevant snippet)
- **FAIL** — with what was expected vs. what was found
- **PARTIAL** — with explanation of what's present and what's missing

Use `grep -n` liberally. Quote the specific lines that prove compliance. Where the completion report claims a count or grep result, **independently re-run the grep and report your own count** rather than trusting the completion report.

---

## Categories used in this checklist

- **F. Format / structure** — YAML, headings, sub-section counts, line counts
- **S. Self-review re-verification** — independent re-run of the 25 self-checks the completion report claims
- **X. ITM-08 + ITM-12 discipline** — Coupling Summary glossary grep + format
- **C. Constraint adherence** — the 17 hard constraints in the prompt
- **N. Negative checks** — content that must NOT appear
- **A. Assembly readiness** — forward-ref resolution, no duplicate headings across fragments

---

## Checklist

### F. Format / Structure

**F1.** YAML front-matter exists with `Created`, `Source`, `Fragment: G`, `Covers: §§14–15 + Appendix A`. Quote lines.

**F2.** H1 fragment header is `# GNX 375 Functional Spec V1 — Fragment G`. Quote line.

**F3.** Top-level H2 count exactly matches: `^## 14\.`, `^## 15\.`, `^## Appendix A` — total 3 (excluding `## Coupling Summary`). Run `grep -cE '^## 14\.|^## 15\.|^## Appendix A' docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md` and report the integer.

**F4.** §14 sub-section count: `grep -cE '^### 14\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md` → expect 6. Report the integer.

**F5.** §15 sub-section count: `grep -cE '^### 15\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md` → expect 7. Report the integer.

**F6.** Appendix A sub-section count: `grep -cE '^### A\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md` → expect 5. Report the integer.

**F7.** Total line count: `wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md`. Report integer. Acceptable band: 270–450. Soft ceiling: 450. Completion report claims 443.

**F8.** No harvest-category markers in `###` lines: `grep -nE '^### .+(\[PART\]|\[FULL\]|\[355\]|\[NEW\])' docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md` → expect 0 matches.

**F9.** No unicode escape sequences: `grep -nE '\\u[0-9a-fA-F]{4}' docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md` → expect 0 matches.

**F10.** No U+FFFD replacement chars (write a short `.py` script to count `\uFFFD` byte sequences; report count; expect 0). Do NOT use inline `python -c`.

### S. Self-Review Re-Verification (re-run the 25 prompt self-checks independently)

For each, run the grep / wc command yourself and report the integer or list of matches. Do NOT trust the completion report's claim — independently verify.

**S1.** Self-check 4 (no foreign top-level headers): `grep -nE '^## 4\.|^### 4\.|^## 7\.|^### 7\.|^## 10\.|^### 10\.|^## 11\.|^### 11\.|^## [5689]|^### [5689]\.|^## 12\.|^### 12\.|^## 13\.|^### 13\.|^## Appendix B|^## Appendix C' docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md` → expect 0 matches.

**S2.** Self-check 9 (§14.1 framing): in §14.1 body, confirm presence of all five state items: "squawk code" or "squawk", "mode" (in modes context), "Flight ID", "ADS-B Out", "data field" / "data field preference". Quote each match.

**S3.** Self-check 9 cont. (§14.1 replaces COM State): grep §14.1 heading and body for "replaces COM State" or "replaces the COM State" — must appear at least once. Quote.

**S4.** Self-check 10 (§15.6 D-15 framing): grep §15.6 body for "no on-screen VDI", "external" (VDI/CDI context), "LPV", "LP+V", "LNAV+V", "vertical deviation output" — confirm all 6 markers. Quote each.

**S5.** Self-check 11 (§15.7 D-16 framing): grep §15.7 body for "external", "ADC", "ADAHRS", "altitude encoder" — confirm all 4 markers. Quote each.

**S6.** Self-check 12 (three XPDR modes consistency in §15): grep §15.1/§15.2/§15.3 for "Standby", "On" (mode context), "Altitude Reporting" — confirm all three present. Confirm no "Ground", "Test", or "Anonymous" mode appearing as a GNX 375 mode (sibling-unit comparison context excepted). Quote.

**S7.** Self-check 13 (OQ4 verbatim preservation): grep `^OPEN QUESTION 4` or `OPEN QUESTION 4:` in §15. Quote the entire OQ4 block. Confirm the block contains: "transponder_code" OR "XPL datareftool" / "datareftool" verification language; "transponder_mode" or mode-dataref placeholder; "ADS-B Out" state placeholder; "pressure altitude" dataref placeholder; design-phase verification flag.

**S8.** Self-check 14 (OQ5 verbatim preservation): grep `OPEN QUESTION 5` in §15. Quote the entire OQ5 block. Confirm the block contains: "TRANSPONDER CODE:1" or "TRANSPONDER CODE", "TRANSPONDER STATE", "TRANSPONDER IDENT", FS2020 vs. FS2024 distinction, Pattern 23 reference for FS2024 B.

**S9.** Self-check 15 (Appendix A.1 D-12 context): grep A.1 body for "D-12", "GNX 375" (primary context), "GNC 355" + "deferred". Quote.

**S10.** Self-check 16 (Appendix A.5 feature matrix size): count rows in A.5 table. Completion report claims 19. Report your independent count.

**S11.** Self-check 17 (no COM present-tense on GNX 375): `grep -nE 'COM radio|COM standby|COM volume|COM frequency|COM monitoring|VHF COM' docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md`. For each match, verify it is in (a) Appendix A.3 sibling-unit comparison context with explicit "GNC 355 has" framing, OR (b) §14.1 explicit "replaces COM State" framing. Report any matches that imply the GNX 375 itself has the COM feature.

**S12.** Self-check 18 (page citations spot-check): grep for `[pp. 58`, `[pp. 18`, `[p. 89]`, `[p. 158]`, `[p. 155]`. Report which sub-sections contain each citation.

**S13.** Self-check 21 (Coupling Summary present + line count): grep for `^## Coupling Summary` (expect exactly 1 match). From that match through end of file, count lines. Completion report claims 105 (target 95–105 per ITM-12). Report your count.

**S14.** Self-check 22 (Forward-refs block "closing fragment"): in the Coupling Summary forward-refs block, grep for "closing fragment". Quote.

**S15.** Self-check 24 (Intra-fragment cross-refs): in Coupling Summary intra-fragment block, confirm presence of three cross-ref blocks: §14.1↔§15.x; §15.6↔§15.1; §15.7↔§14/§15.x. Quote heading or first sentence of each.

### X. ITM-08 + ITM-12 Discipline

**X1.** ITM-08 grep-verify — re-run independently against `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` for every Appendix B term claimed in Fragment G's Coupling Summary backward-refs block targeting Appendix B. Completion report claims 27 confirmed-present terms. Independently:

a. Extract the list of Appendix B terms claimed in Fragment G's Coupling Summary backward-refs (the block referencing "Fragment A Appendix B").

b. For each claimed term, run `grep -ni "{term}" docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` restricted to the Appendix B section. Report PASS (term found in Appendix B) or FAIL (term claimed but not found).

c. Confirm the explicitly excluded terms (EPU, HFOM, VFOM, HDOP, TSO-C151c) are NOT claimed in Fragment G's backward-refs. Report PASS/FAIL.

**X2.** ITM-12 format — confirm prose-per-ref format. Pick three backward-ref blocks at random (not the same three the completion report cites). For each, count sentences / line count. Report whether they are 2–4 sentence prose (PASS) or compact single-line bullets (FAIL).

**X3.** ITM-12 line count — re-confirm S13 result. Completion report claims 105 lines, target 95–105. Independently report line count and whether within band.

### C. Constraint Adherence (17 hard constraints from the prompt)

Re-verify each of the 17 hard constraints. The completion report's Hard-Constraint Verification table lists these — independently re-run the underlying greps where possible.

**C1.** Constraint 1 (ITM-08 grep-verify): see X1 above.

**C2.** Constraint 2 (ITM-12 prose-per-ref + 90–110 lines): see X2/X3 above.

**C3.** Constraint 3 (no forward-refs): grep Coupling Summary "Forward cross-references" block. Confirm it states "closing fragment; no forward-refs" or equivalent. Confirm no `[Fragment H]` or `→ §16` or any forward-ref to non-existent content. Quote.

**C4.** Constraint 4 (§14.1 = XPDR State, three modes per D-16): see S2/S3/S6 above.

**C5.** Constraint 5 (§15 doesn't re-author §11 XPDR behavior): grep §15.1/§15.2/§15.3 for behavioral verbs ("when the pilot", "the pilot then", "displays the", "automatically" applied to XPDR pilot-facing behavior — heuristic check). §15 should describe interface surfaces (dataref names, types, contracts), not pilot behavior. Report any sentences that read as §11-style behavioral spec rather than interface contract. Cross-ref §11 should appear at least once in §15 to delegate behavior.

**C6.** Constraint 6 (§15.6 External CDI/VDI per D-15): re-confirm S4. Additionally verify §15.6 contains:
- "GPSS" (roll steering output)
- "glidepath capture" or equivalent autopilot output language
- TO/FROM flag output language
- design-phase flag for exact dataref names (lateral + vertical deviation output)

**C7.** Constraint 7 (§15.7 Altitude Source per D-16): re-confirm S5. Additionally verify §15.7 contains the advisory message reference: "ADS-B Out fault. Pressure altitude source inoperative or connection lost." or cross-ref to §11.13/§13.9 for the advisory.

**C8.** Constraint 8 (OQ4 verbatim): see S7.

**C9.** Constraint 9 (OQ5 verbatim): see S8.

**C10.** Constraint 10 (Appendix A.1 D-12 context): see S9. Additionally verify A.1 mentions "D-02" being resolved per D-12, OR explicit GNC 375 → GNX 375 nomenclature correction.

**C11.** Constraint 11 (Appendix A.2 GPS 175 lacks/identical lists):
- Lacks list: count items. Expect 5: Mode S XPDR, ADS-B Out, built-in ADS-B In, TSAA, ADS-B traffic logging.
- Identical list: confirm presence of CDI On Screen, GPS NAV Status indicator key, Direct-to via knob-push.

**C12.** Constraint 12 (Appendix A.3 GNC 355 lacks + adds + identical):
- Lacks list: count items. Expect 7: Mode S XPDR, ADS-B Out, built-in ADS-B In, TSAA, ADS-B traffic logging, CDI On Screen, GPS NAV Status indicator key.
- Adds list: count items. Expect ~6 (prompt specifies 6; completion report claims 9). Independently count and report. Confirm presence of: VHF COM radio, COM Standby Control Panel, 25/8.33 kHz, COM volume/sidetone/etc., Flight Plan User Field [p. 155], Direct-to via standby-frequency-tune.
- Identical list present.

**C13.** Constraint 13 (Appendix A.5 feature matrix table — ~18 rows): see S10. Independently count rows and report.

**C14.** Constraint 14 (no sibling-unit consistency drift): for each "GNC 355" mention in Fragment G, verify the claim is consistent with what's stated about GNC 355 in Fragments A–F. Particular focus: "GNC 355 has VHF COM" (consistent with all archived); "GNC 355 lacks CDI On Screen" (verify Fragment B/C statements); "GNC 355 lacks ADS-B Out" (verify Fragment F §11 framing). Report any inconsistencies.

**C15.** Constraint 15 (no §4/§7/§10/§11 re-authoring): same as S1.

**C16.** Constraint 16 (no COM present-tense on GNX 375): same as S11.

**C17.** Constraint 17 (assembly readiness — 3 top-level headings): same as F3.

### N. Negative Checks

**N1.** No CSS / HTML stray content: `grep -nE '<[a-z]+ ' docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md` (except markdown comment `<!--`). Report.

**N2.** No "TBD" placeholders left in finalized prose (excluding intentional design-phase OQ flags): `grep -ni 'TBD' docs/specs/fragments/GNX375_Functional_Spec_V1_part_G.md`. Report each match and classify: legitimate design-phase flag vs. unfinished prose.

**N3.** No fragment-internal authoring scaffolding: grep for "[Phase", "Phase A:", "TODO:", "FIXME". Expect 0.

### A. Assembly Readiness

**A1.** Forward-ref resolution from each archived fragment to Fragment G — independently spot-check three:
- Fragment F §11.14 → Fragment G §14.1 XPDR State: open Fragment F at the §11.14 forward-ref and confirm Fragment G §14.1 contains the corresponding content.
- Fragment F §12.2 → Fragment G §15.6 External CDI/VDI Output Contract: same check.
- Fragment E §10.11 → Fragment G §15.1 datarefs: same check.

For each, report PASS (target sub-section authored, scope consistent) or FAIL (forward-ref unresolved or scope mismatch).

**A2.** No duplicate H2 headings across all 7 fragments combined: run `grep -hE '^## ' docs/specs/fragments/GNX375_Functional_Spec_V1_part_*.md | sort | uniq -d`. Expect empty (no duplicates) — except the standard `## Coupling Summary` which is stripped on assembly. Report any non-Coupling-Summary duplicates.

**A3.** 7-fragment decomposition outline footprint: confirm Coupling Summary outline-footprint block in Fragment G explicitly states "7-fragment decomposition complete" or equivalent language. Quote.

---

## Output

Write the compliance report to `docs/tasks/c22_g_compliance.md` with this structure:

```markdown
---
Created: {ISO 8601 timestamp}
Source: docs/tasks/c22_g_compliance_prompt.md
---

# GNX375-SPEC-C22-G Compliance Report

**Verified:** {ISO 8601 timestamp}
**Verdict:** [ALL PASS / PASS WITH NOTES / PARTIAL / FAILURES FOUND]

## Summary
- Total checks: {N}
- Passed: {N}
- Passed with notes: {N}
- Partial: {N}
- Failed: {N}

## Results

### F. Format / Structure
F1. [PASS/FAIL/PARTIAL] — evidence
F2. ...
...

### S. Self-Review Re-Verification
S1. ...
...

### X. ITM-08 + ITM-12 Discipline
X1. ...
X2. ...
X3. ...

### C. Constraint Adherence
C1. ...
...

### N. Negative Checks
N1. ...
...

### A. Assembly Readiness
A1. ...
A2. ...
A3. ...

## Notes

{Any observations, minor deviations, or recommendations that don't rise to FAIL level but are worth documenting.}
```

---

## Completion Protocol

1. Write compliance report to `docs/tasks/c22_g_compliance.md`
2. `git add -A`
3. `git commit` with D-04 trailer format. Use the BOM-free `WriteAllText` + `git -F` PowerShell pattern. Subject:
   ```
   GNX375-SPEC-C22-G-COMPLIANCE: verification report for Fragment G
   ```
   Trailers:
   ```
   Task-Id: GNX375-SPEC-C22-G-COMPLIANCE
   Authored-By-Instance: cc
   Refs: GNX375-SPEC-C22-G, ITM-08, ITM-12, D-15, D-16, D-12, D-18
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```
4. Send completion notification:
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-G-COMPLIANCE completed [flight-sim]"
   ```

**Do NOT git push.**
