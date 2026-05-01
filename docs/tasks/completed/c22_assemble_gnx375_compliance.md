---
Created: 2026-04-30T11:30:00-04:00
Source: docs/tasks/c22_assemble_gnx375_compliance_prompt.md
---

# GNX375-SPEC-C22-ASSEMBLE Compliance Report

**Verified:** 2026-04-30T11:30:00-04:00
**Verdict:** FAILURES FOUND

## Summary
- Total checks: 45
- Passed: 39
- Passed with notes: 3
- Partial: 2
- Failed: 1

---

## Results

### F. Format / Structure

**F1. PASS WITH NOTE** — Script exists at `scripts/assemble_gnx375_spec.py` and is callable. `--help` emits the full flag set (see S5). Independent `wc -l` reports **555 lines**. Completion report claimed 249 — significant discrepancy. Script is fully functional; the completion report line count was incorrect. No impact on behavior.

**F2. PASS** — `docs/specs/GNX375_Functional_Spec_V1_aggregate.md` exists. Independent `wc -l` reports **4433 lines**, matching the completion report claim exactly.

**F3. PASS** — `grep -cE '^# ' aggregate.md` → **1**. Single H1 heading as required.

**F4. PASS** — `grep -cE '^## ' aggregate.md` → **18** (§§1–15 = 15 numbered, Appendix A + B + C = 3). Matches expected.

**F5. PASS** — `grep -cE '^### ' aggregate.md` → **149**. Matches completion report claim.

**F6. PASS** — Lines 3–6 contain the provenance comment with all required markers:
```
<!-- Assembled from seven part files via scripts/assemble_gnx375_spec.py.
     Source manifest: docs/specs/GNX375_Functional_Spec_V1.md
     Fragments: GNX375_Functional_Spec_V1_part_{A..G}.md
     Generated: 2026-04-30T08:30:25-04:00 -->
```
All four markers present: "Assembled from seven part files", "Source manifest:", "Fragments:", "Generated:".

**F7. PASS** — Line 1 is exactly: `# GNX 375 Functional Spec V1`

---

### S. Script Behavior

**S1. PASS** — Script depends only on Python standard library. Imports at lines 11–15:
```
import argparse
import re
import sys
from datetime import datetime, timezone
from pathlib import Path
```
No third-party imports.

**S2. PASS** — `python scripts/assemble_gnx375_spec.py --check` exits 0 and emits:
```
Manifest: docs\specs\GNX375_Functional_Spec_V1.md — 7 fragment(s) in table

=== Verification Results ===
  [PASS] Section numbering continuity (§1–§15 + Appendices A–C at H2)
  [PASS] Sub-section integrity spot-checks
  [PASS] No duplicate H2 headings
  [PASS] No '## Coupling Summary' in aggregate
  [PASS] No fragment header lines in aggregate
  [PASS] No YAML front-matter blocks
  [PASS (0 unresolved)] Cross-reference resolution
  [4433] Total line count

[--check mode] Aggregate not written. In-memory line count: 4433

All gating verification checks PASS.
```

**S3. PASS** — `--check --verbose` prints the strip statistics table before the verification summary:
```
  Frag      Input     YAML   H1+Intro   Coupling     Body
  A           545        6          5         26      506
  B           798        6          1         55      735
  C           725        6          1         64      653
  D           913        6          1         40      865
  E           829        6          1         40      781
  F           606        6          1         42      556
  G           443        6          3        108      324
  TOTAL      4859                                    4420
```
Per-fragment columns (input, YAML, H1+intro, Coupling, body) all present.

**S4. PASS** — File hash before and after two `--check` runs:
- Before: `6B5850D4EFE610123E81167207BAEBDD8A6638456C8D549777DCC8EDAA65747C`
- After: `6B5850D4EFE610123E81167207BAEBDD8A6638456C8D549777DCC8EDAA65747C`

Hashes identical; `--check` does not write to disk.

**S5. PASS** — `--help` documents all five non-standard flags: `--manifest`, `--fragments-dir`, `--output`, `--partial`, `--check`, `--verbose`. Full help:
```
usage: assemble_gnx375_spec.py [-h] [--manifest MANIFEST]
                               [--fragments-dir FRAGMENTS_DIR]
                               [--output OUTPUT] [--partial] [--check]
                               [--verbose]
...
```

**S6. PASS** — `python scripts/assemble_gnx375_spec.py --check` exits with code 0 when all gating checks pass. Confirmed via `echo $?` → 0 on two independent runs.

**S7. PARTIAL** — `--partial` flag is documented in `--help` and implemented at script lines 471–491. Condition (a) is met: inserts a comment placeholder block (`<!-- Fragment {letter} ({covers}) not yet authored. Placeholder. -->`) for each missing fragment. Condition (c) is partially met: the aggregate is written to disk even when partial (write at line 541 precedes the gating-fail exit at line 547). Condition (b) is **not implemented**: the section-numbering continuity check (`verify_section_numbering`) still runs on the assembled output without skipping ranges corresponding to missing fragments. A `--partial` run with genuinely missing fragments would report FAIL for missing §§ even if the placeholder blocks are correctly inserted. The continuity check would need awareness of missing-fragment ranges to satisfy (b).

---

### V. Verification Logic

**V1. PASS** — `verify_section_numbering` (lines 219–249): iterates all lines, tracks H2 `## N.` and H2 `## Appendix [A-C]` occurrences. Detects duplicates, missing §§1–15, §§>15, missing appendices. Reports issues list. Logic is complete and correct.

**V2. PASS** — `verify_subsection_integrity` (lines 252–300): spot-checks §4.1–§4.10 (all 10 must be present), §7 numeric 7.1–7.9 then lettered 7.A–7.M in order, §14 exactly 6 sub-sections, §15 exactly 7 sub-sections, Appendix A exactly 5 sub-sections. All checks present.

**V3. PASS** — `verify_no_duplicate_h2` (lines 303–314): collects H2 headings into a dict; any key seen twice is flagged with both line numbers.

**V4. PASS** — `verify_no_coupling_summary` (lines 317–319): scans all lines against `_COUPLING_RE = re.compile(r"^##\s+Coupling Summary\s*$")`. Returns line numbers of any matches.

**V5. PASS** — `verify_no_fragment_headers` (lines 322–324): scans all lines against `_H1_RE` (accepts em-dash, en-dash, or hyphen variants). Returns line numbers of any matches.

**V6. PASS** — `verify_no_yaml_blocks` (lines 327–347): tracks fenced code blocks to avoid false positives; flags `---` lines followed by a YAML key-value pattern `^[A-Za-z][\w-]*:\s+\S`. Regular `---` section separators (not followed by `key: value`) are not flagged.

**V7. PASS** — `verify_cross_refs` (lines 350–378): collects all heading targets (section numbers, appendix labels) into a set; scans body lines for `§N` and `Appendix X` references; returns unresolved list. Run reports `[PASS (0 unresolved)]`. Implemented as warning-only (does not set gating_pass = False).

**V8. PASS** — Line 416: `results.append(("Total line count", str(len(assembled)), []))`. Prints as `[4433] Total line count` in verification output.

---

### A. Aggregate Output Content

**A1. PASS** — `grep -nE '^---$' aggregate.md` returns 20+ matches. All are section separators, not YAML front-matter. Confirmed first three matches:
- Line 8: `---` (between provenance comment and `## 1. Overview`) — section separator
- Line 16: `---` (between §1.1 subsection content) — section separator  
- Line 36: `---` (between §1.3 subsection content) — section separator

No front-matter blocks found (none have `Created:` or `Source:` keys on the following line). `verify_no_yaml_blocks` confirms: 0 suspicious `---` lines.

**A2. PASS** — `grep -nE '^# GNX 375 Functional Spec V1 — Fragment [A-G]' aggregate.md` → **0 matches**. No fragment H1 headers in aggregate.

**A3. PASS** — `grep -cE '^## Coupling Summary' aggregate.md` → **0**. No Coupling Summary headings.

**A4. PASS** — `grep -nE '^### 4\.' aggregate.md` → §4.1–§4.10 in order:
```
539:  ### 4.1 Home Page and Page Navigation Model
600:  ### 4.2 Map Page
863:  ### 4.3 Active Flight Plan (FPL) Page
1033: ### 4.4 Direct-to Page
1106: ### 4.5 Waypoint Information Pages
1220: ### 4.6 Nearest Pages
1260: ### 4.7 Procedures Pages
1486: ### 4.8 Planning Pages
1588: ### 4.9 Hazard Awareness Pages
1789: ### 4.10 Settings and System Pages
```
All 10 present, strict ascending order.

**A5. PASS** — `grep -nE '^### 7\.' aggregate.md` → 7.1–7.9 numeric then 7.A–7.M lettered in order:
```
2236: ### 7.1   2255: ### 7.2   2282: ### 7.3   2302: ### 7.4   2317: ### 7.5
2382: ### 7.6   2402: ### 7.7   2424: ### 7.8   2452: ### 7.9
2496: ### 7.A   2513: ### 7.B   2531: ### 7.C   2551: ### 7.D   2584: ### 7.E
2607: ### 7.F   2626: ### 7.G   2649: ### 7.H   2668: ### 7.I   2688: ### 7.J
2707: ### 7.K   2721: ### 7.L   2736: ### 7.M
```
Last numeric (7.9 at 2452) precedes first lettered (7.A at 2496). Correct ordering.

**A6. PASS** — `grep -cE '^### 14\.' aggregate.md` → **6**. Matches expected.

**A7. PASS** — `grep -cE '^### 15\.' aggregate.md` → **7**. Matches expected.

**A8. PASS** — `grep -cE '^### A\.' aggregate.md` → **5**. Matches expected.

**A9. PASS** — Lines 1–10 of aggregate:
```
1:  # GNX 375 Functional Spec V1
2:  (blank)
3:  <!-- Assembled from seven part files via scripts/assemble_gnx375_spec.py.
4:       Source manifest: docs/specs/GNX375_Functional_Spec_V1.md
5:       Fragments: GNX375_Functional_Spec_V1_part_{A..G}.md
6:       Generated: 2026-04-30T08:30:25-04:00 -->
7:  (blank)
8:  ---
9:  (blank)
10: ## 1. Overview
```
Structure matches prompt spec exactly: H1 line 1, blank line 2, provenance comment lines 3–6, blank line 7, `---` line 8, blank line 9, `## 1. Overview` line 10.

**A10. PASS** — §3/§4 transition: `## 3.` at line 234; content ends with `---` at line 335; `## Appendix B` at line 337; `## Appendix C` at line 442; Fragment B retained preamble (informational) at line 516; `## 4. Display Pages` at line 521. No `# GNX 375 Functional Spec V1 — Fragment B` header anywhere in the aggregate. No `## Coupling Summary` leakage. Appendix B/C placement documented under C1.

**A11. PASS** — §4.6/§4.7 transition: `### 4.6 Nearest Pages` at line 1220, content ends around line 1251; Fragment C retained preamble at line 1252; `### 4.7 Procedures Pages` at line 1260. No fragment H1 header, no Coupling Summary, no duplicate `## 4.` heading between the two sub-sections.

**A12. PASS** — §13/§14 transition: `## 13. Messages` at line 3951; content ends with `---` at line 4110; `## 14. Persistent State` at line 4112. No fragment header or Coupling Summary leakage in this region.

---

### D. Determinism

**D1. PASS** — Two independent `--check` runs produced identical stdout. stdout md5sum for both runs: `15c086737aae3e6428639de431170af8`. All structural counts (line totals, H2/H3 counts, strip statistics) identical.

**D2. PASS** — The only per-run variation is the `Generated:` timestamp in the provenance comment written to the output file. This timestamp is generated at runtime:

```python
# Line 178
ts = datetime.now(timezone.utc).astimezone().isoformat(timespec="seconds")
```

The `--check` mode stdout does not include the timestamp (it only appears in the written file header), so stdout determinism is unaffected.

---

### N. Negative Checks

**N1. PASS** — `grep -nE '^(import|from) (requests|yaml|frontmatter)'` → 0 matches. No disallowed third-party imports. Only stdlib: `argparse`, `re`, `sys`, `datetime`, `pathlib`.

**N2. PASS** — Fragment order is read from the manifest table via `parse_manifest()` (lines 33–62). The function parses the markdown table for `| Order | ... | Fragment file ... |` rows, extracts the numeric order and backtick-quoted path, and sorts by order. No hardcoded `['A', 'B', ..., 'G']` sequence drives concatenation.

**N3. PASS** — Only write operation in the script is at line 541: `out_path.write_text("\n".join(assembled) + "\n", encoding="utf-8")`, where `out_path = Path(args.output)` (default: `docs/specs/GNX375_Functional_Spec_V1_aggregate.md`). No writes to `docs/specs/fragments/` or to `docs/specs/GNX375_Functional_Spec_V1.md`. Fragment files are read-only (`.read_text()` only at line 155).

**N4. PASS WITH NOTE** — No stray debug `print()` calls. All print paths are intentional:
- Line 457: manifest/fragment count (always printed — informational status, not debug)
- Lines 472, 509: partial-mode warnings (gated on missing fragments)
- Lines 501–524: verbose strip statistics (gated by `args.verbose`)
- Lines 424–428: verification results summary (always printed — by design)
- Lines 542–544: output-written or check-mode message (gated by `args.check`)
- Lines 547, 550: gating-fail error and all-pass message (gated by `gating_pass`)

The manifest line (457) is not verbose-gated but is an expected status announcement, not a debug trace.

---

### C. CD-Review-Flagged Items

**C1. CONFIRMED** — Appendix B at line **337**, Appendix C at line **442**. Both match the completion report's claims exactly. Placement is after the last content of §3 (line ~335) and before §4 (`## 4. Display Pages` at line 521), consistent with Fragment A's authoring order. This is a CD review item — no recommendation made.

**C2. PARTIAL** — Completion report claims Fragments B, C, D, E, F retain "Fragment X of 7..." intro paragraphs. Independent verification finds **only Fragments B and C** retain such preambles:
- Line 516: `Fragment B of 7 per D-18. Covers §§4.1–4.6 (Home, Map, FPL, Direct-to, Waypoint Info,`
- Line 1252: `Fragment C of 7 per D-18. Covers §§4.7–4.10 (Procedures, Planning, Hazard Awareness,`

Fragments D, E, F have clean section-start boundaries with no "Fragment X of 7..." paragraph in the aggregate. The verbose strip output confirms: all fragments B–F show `H1+intro -1` (only the H1 line stripped, no recognized intro paragraph). The heuristic at lines 103–113 only strips intro paragraphs starting with `"This is "` or `"This fragment "`. Fragment B and C preambles start with `"Fragment B of 7..."` and `"Fragment C of 7..."` — neither matches the heuristic — so they are retained. Fragments D, E, F apparently have no "Fragment X of 7..." paragraph, so there is nothing to retain. The completion report's claim about D, E, F is inaccurate.

**C3. CONFIRMED** — Appendix A at line **4314**. Matches completion report claim. §15 ends around line 4313; Appendix A opens at 4314. Correct placement at end of spec.

---

### P. Provenance and Git

**P1. FAIL** — Commit `7ae84a9` is the most recent commit; subject begins with `GNX375-SPEC-C22-ASSEMBLE`. Required trailers verified:
- `Task-Id: GNX375-SPEC-C22-ASSEMBLE` — **PRESENT** ✓
- `Authored-By-Instance: cc` — **PRESENT** ✓
- `Refs: D-18, D-22, GNX375_Functional_Spec_V1.md` — D-18 **PRESENT** ✓; D-22 also present; file ref is non-standard but not a violation
- `Co-Authored-By: Claude Code <noreply@anthropic.com>` — **PRESENT** ✓
- **BOM character (U+FEFF): FAIL** — `git log -1 --format="%s" | xxd` shows `ef bb bf` (UTF-8 BOM) at byte offset 0, before the subject text. The BOM-free `WriteAllText` + `git -F` pattern was not used for this commit. The subject reads `﻿GNX375-SPEC-C22-ASSEMBLE: author...` with a leading BOM.

All trailers present and correct; BOM in subject is the sole failure.

**P2. PASS WITH NOTE** — No evidence of `git push` execution. Convention enforced by project discipline (`CLAUDE.md`: "CC does NOT push — operator pushes manually"). Push restriction is not verifiable from shell history in this session; reporting as convention compliance.

---

## Notes

1. **Script line count discrepancy (F1):** Completion report claimed 249 lines; actual `wc -l` = 555. The final script is substantially larger than the figure in the completion report, likely because the completion report was drafted early and the script grew during implementation. No functional impact.

2. **BOM in commit subject (P1):** The `﻿` (U+FEFF) BOM at the start of the commit subject is a known issue mentioned in CLAUDE.md conventions. The BOM-free commit pattern (`[System.IO.File]::WriteAllText` + `git commit -F`) should be used for all future task commits.

3. **`--partial` continuity skip (S7):** The prompt specified that `--partial` mode should skip section-numbering continuity for missing-fragment ranges. This logic is not implemented. If a future fragment is genuinely missing at assembly time, the user would see gating check failures. Adding a `missing_sections` set derived from missing fragment coverage metadata and excluding those from the continuity check would close this gap.

4. **Fragment D/E/F preamble absence (C2):** The completion report over-claimed: only B and C have retained preamble sentences. D, E, F have no "Fragment X of 7..." text at their source-fragment level (or their preamble text does not use that form). The aggregate is correct; the completion report description was inaccurate.

5. **Aggregate total-body vs. line count:** Verbose output shows total body lines = 4420. The aggregate is 4433 lines: the 13-line difference is the provenance header block (7 lines) plus single blank-line separators between 7 fragments (6 lines). This arithmetic is consistent.
