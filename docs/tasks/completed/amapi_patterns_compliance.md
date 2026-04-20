---
Created: 2026-04-20T22:38:06Z
Source: docs/tasks/amapi_patterns_compliance_prompt.md
---

# AMAPI-PATTERNS-01 Compliance Report

**Verified:** 2026-04-20T22:38:06Z
**Verdict:** PASS WITH NOTES

## Summary
- Total checks: 30
- Passed: 23
- Partial: 5
- Failed: 2

---

## Results

### I. Inventory & Structure

**I1. Pattern count claim (24) — PASS**

```
$ grep -cE '^### Pattern [0-9]+(\.[0-9]+)?:' docs/knowledge/amapi_patterns.md
24
```

Exactly 24 pattern headings. Matches completion-report claim.

**I2. Pattern count within target band (15–30) — PASS**

24 is within the 15–30 target range.

**I3. Categories present — PARTIAL**

```
$ grep -nE '^## Category:' docs/knowledge/amapi_patterns.md
98:## Category: Writing to the simulator
276:## Category: Reading simulator state
468:## Category: Touchscreen / button input
525:## Category: Knob / hardware dial input
679:## Category: Visual state management
871:## Category: Sound
914:## Category: User properties / instrument configuration
995:## Category: Instrument metadata / platform detection
```

8 of 9 expected categories present at `## Category:` level. **Persistence** is absent from the main catalog body as a `## Category:` section — it appears only in the Pattern Index (`## Pattern index`) as a `### Category: Persistence` sub-entry at line 83 with Pattern 11 cross-referenced there. Pattern 11 itself lives in the `## Category: Knob / hardware dial input` section. This is a deliberate design choice (Pattern 11 is the only persistence pattern; it's physically in the Knob section and cross-indexed under Persistence), but the structural result is that `grep -nE '^## Category:'` returns 8 not 9 headers.

Category name alignment: "User properties / instrument configuration" (catalog) vs. "User properties / configuration" (completion report) — minor naming difference, same category. "Instrument metadata / platform detection" vs. "Instrument metadata / platform" — same.

**I4. Required structural sections — PASS**

All 5 required sections present:
- Provenance header: lines 2–3 (`Created: 2026-04-20T00:00:00Z`, `Source: docs/tasks/amapi_patterns_prompt.md`)
- "How to use this document": line 16
- "Pattern index": line 24
- "Pattern cross-reference": line 1078
- "What this catalog does NOT cover": line 1124

**I5. Sample appendix structure — PASS**

```
$ grep -nE '^### ' docs/knowledge/amapi_patterns_sample_appendix.md
16:### generic_garmin-gtn-650_1ae7feb5
38:### generic_garmin-gns-530_72b0d55c
72:### generic_garmin-gns-430_24038c68
90:### generic_bendixking-kap-140-autopilot-system_da394c59
119:### generic_bendixking-kx-165a-ts0-com1nav1_a6f6d3b9
143:### generic_garmin-gfc-500-autopilot_c154321a
174:### cessna-172_heading_079a54d1
183:### cessna-172_altimeter_cf5829f6
192:### cessna-172_vor-nav1ils_94a0e896
201:### cessna-172_adf_04a6aa5d
210:### cessna-172_switch-panel_0fb7ea63
219:### generic_garmin-340-audio-panel_d30c0bb4
230:### generic_garmin-gma-1347d-audio-panel_965144b1
241:### cessna-172_turn-coordinator_487838a2
```

6 Tier 1 sections (lines 16–143), 8 Tier 2 sections (lines 174–241). "Sample-specific techniques catalog" section at line 252 contains a table with 13 rows (techniques at lines 258–270), matching the completion-report claim of 13 entries. The techniques are structured as a table, not as `#### ` headers, which is why `grep -cE '^#### '` returns 0 — not a structural error.

---

### II. Per-pattern Quality (Spot-Check)

**II1. Pattern 1 — PASS (with minor note)**

All required subsections present: Problem (line 102), Solution (line 104), Code sketch (lines 106–115), Functions used (lines 117–121), Exemplars (lines 123–128), Variants (lines 130–133), Caveats (line 135), GNC 355 relevance (line 137).

Code sketch lines: 7 content lines + 1 blank = effectively 8 when blank is counted; bash `grep -v '```' | wc -l` reports 7 (blank line excluded). This is at or 1 below the stated 8-line minimum. "Allow some slack" language applies. The sketch is complete and functional; no information is missing due to brevity. Minor note, not a FAIL.

Exemplars: 5 sample directories listed — exceeds the 2-minimum.

**II1. Pattern 11 — PASS**

All required subsections present: Problem, Solution, Code sketch (lines 533–548, 13 lines), Functions used (6 functions linked), Exemplars (2 samples: GNS 530, GNS 430), Caveats, GNC 355 relevance. 13-line sketch is within 8–30. Exemplar count meets 2-minimum.

**II1. Pattern 21 — PASS**

All required subsections present: Problem, Solution, Code sketch (lines 643–659, 15 lines), Functions used, Exemplars (4 samples: altimeter, VOR, ADF, heading), Caveats, GNC 355 relevance. 15-line sketch is within 8–30. Exemplar count exceeds 2-minimum.

Note: `hw_dial_add` in the "Functions used" section is plain text (backtick literal), not a markdown link. See VIII2 for analysis.

**II2. Pattern 1 exemplar verification — PASS**

Grepped `assets/instrument-samples-named/generic_garmin-gtn-650_1ae7feb5/logic.lua`:

```
14:    xpl_command("RXP/GTN/HOME_" .. device_id)
15:    fsx_event("GPS_MENU_BUTTON", device_id_rxp_fsx + 2)
17:        msfs_event("H:GTN650" .. device_id_pms .. "_HomePushLong")
28:    xpl_command("RXP/GTN/DTO_" .. device_id)
29:    fsx_event("GPS_DIRECTTO_BUTTON", device_id_rxp_fsx)
30:    msfs_event("H:GTN650" .. device_id_pms .. "_DirectToPush")
```

All three pattern signature functions (`xpl_command`, `fsx_event`, `msfs_event`) confirmed present. Triple-dispatch is the primary dispatch mechanism throughout the file.

---

### III. Anticipated Patterns Presence

**III1. Triple-dispatch pattern — PASS**

Pattern 1: "Triple-dispatch button/dial" (line 100)

Defining sentence: "Every button and dial callback unconditionally fires the XPL command, the FSX event, and the MSFS event in sequence — without checking which sim is connected."

Exact match to anticipated form. Pattern is most-frequent: 5/6 Tier 1 samples.

**III2. Parallel subscription pattern — PARTIAL**

Pattern 14: "Parallel XPL + MSFS subscriptions for same state" (line 382)

Defining sentence: "Subscribe to the state via both `xpl_dataref_subscribe` and `msfs_variable_subscribe`, each wired to a separate update callback."

This covers 2 of the 3 anticipated subscription APIs (`xpl_dataref_subscribe` + `msfs_variable_subscribe`). The anticipated form included `fsx_variable_subscribe` as the third leg. Pattern 14 omits `fsx_variable_subscribe` because the Tier 1 samples in scope (GNS 530, GNS 430) subscribe only to XPL and MSFS — FSX subscriptions for the same state were not observed in the corpus. The pattern is represented but covers 2-sim parallel subscription, not 3-sim. The FSX leg is covered in the "Parallel subscription bus" context via Pattern 2 (multi-variable bus), not as a standalone parallel-subscription pattern.

**III3. Long-press detection — PASS**

Pattern 4: "Long-press button via timer" (line 470)

Defining sentence: "In the press callback, start a timer with the long-press threshold duration. In the release callback, check if the timer is still running — if yes, it was a short press (cancel timer, fire short action); if no, the timer already fired the long-press action."

Code sketch at line 487: `tmr_home = timer_start(1500, nil, home_long_press)` — exactly 1500 ms, matching anticipated form. `timer_running(tmr_home)` check in release callback confirms short-vs-long differentiation.

**III4. Multi-instance device-ID — PASS**

Pattern 5: "Multi-instance device ID suffix" (line 916)

Defining sentence: "Add an integer user property (Device ID 1 or 2). At startup, derive three suffix variants from it: an XPL command suffix, an FSX event offset, and an MSFS event name suffix. Append these to every command/event dispatch in callbacks."

Code sketch at line 922: `user_prop_add_integer("Device ID", 1, 1, 2, ...)` with string concatenation into XPL/FSX/MSFS command names. Exact match to anticipated form.

**III5. Detent-type user prop — PASS**

Pattern 20: "Detent-type user prop for hw_dial_add" (line 596)

Defining sentence: "Expose an enum user property with the detent options. At startup, read the property, look up the corresponding `TYPE_N_DETENT_PER_PULSE` constant in a table, and pass it to `hw_dial_add`."

Code sketch at lines 600–617: `user_prop_add_enum("Detent setting", "1 detent/pulse,2 detents/pulse,4 detents/pulse", ...)` mapped to `TYPE_1_DETENT_PER_PULSE`, `TYPE_2_DETENTS_PER_PULSE`, `TYPE_4_DETENTS_PER_PULSE` constants. Exact match to anticipated form.

---

### IV. Cross-Reference Integrity

**IV1. Total cross-link count — PARTIAL**

```
$ grep -oE '\.\./reference/amapi/by_function/[^)]+\.md' docs/knowledge/amapi_patterns.md | wc -l
72
```

Actual count: **72**. Completion report claims "~85". Discrepancy of 13 links (~15%). The "~" prefix provides some flexibility but 72 vs 85 exceeds reasonable approximation range. This may reflect patterns added late in the authoring phase (Patterns 22–24) that have sparser cross-link coverage, or an overcounting error in the in-progress estimate. Not a structural failure — all 72 links are valid — but the count estimate is materially inaccurate.

**IV2. Distinct functions referenced — PARTIAL**

```
$ grep -oE '\.\./reference/amapi/by_function/[^)]+\.md' docs/knowledge/amapi_patterns.md | sort -u | wc -l
36
```

Actual distinct count: **36**. Completion report claims 34. Actual is 2 higher than claimed — a small overcount in the wrong direction (actual exceeds claim). The two additional functions referenced beyond the 34 claimed are likely from the late-stage Tier 2 patterns (23, 24) added in Phase C.

**IV3. Broken-link scan (full) — PASS**

All 36 distinct link targets verified:

```
OK: Button_add, Canvas_add, Canvas_draw, Dial_add, Fs2020_variable_subscribe,
    Fs2024_event, Fs2024_variable_subscribe, Fsx_event, Fsx_variable_subscribe,
    Group_add, Img_add, Mouse_setting, Msfs_event, Msfs_variable_subscribe,
    Msfs_variable_write, Opacity, Persist_add, Persist_get, Persist_put,
    Rotate, Si_variable_subscribe, Sound_add, Sound_play, Timer_running,
    Timer_start, Timer_stop, Touch_setting, User_prop_add_boolean,
    User_prop_add_enum, User_prop_add_integer, User_prop_get, Var_cap,
    Video_stream_add, Visible, Xpl_command, Xpl_dataref_subscribe
```

**0 broken links.** Contrary to the completion report's claim, `Hw_dial_add.md` IS NOT a broken link — it was never written as a markdown link in the catalog (see VIII2). And `docs/reference/amapi/by_function/Hw_dial_add.md` EXISTS (2007 bytes, created 2026-04-20 13:44). The completion report's gap claim was false.

**IV4. Spot-check report's 5 named targets exist — PASS**

```
Xpl_dataref_subscribe: EXISTS
Timer_start:           EXISTS
Si_variable_subscribe: EXISTS
Persist_add:           EXISTS
Group_add:             EXISTS
```

All 5 spot-check targets confirmed.

---

### V. Source-of-Truth Coverage

**V1. Phase 0 audit was performed — PASS**

`_crp_work/amapi_patterns_01/_phase_A_complete.md` exists and records all 6 Tier 1 samples read. No deviation files exist:
- `docs/tasks/amapi_patterns_prompt_phase0_deviation.md` — not found
- `docs/tasks/amapi_patterns_prompt_deviation.md` — not found

`_status.json` confirms phases A–E all completed. No signals of skipped source-of-truth reads.

**V2. B2 Tier 1 / Tier 2 boundaries respected — PASS**

Exactly 6 raw_notes files for exactly the 6 specified Tier 1 samples:

```
raw_notes_generic_garmin-gtn-650_1ae7feb5.md         ← matches Phase A item 1
raw_notes_generic_garmin-gns-530_72b0d55c.md         ← matches Phase A item 2
raw_notes_generic_garmin-gns-430_24038c68.md         ← matches Phase A item 3
raw_notes_generic_bendixking-kap-140-autopilot-system_da394c59.md  ← item 4
raw_notes_generic_bendixking-kx-165a-ts0-com1nav1_a6f6d3b9.md     ← item 5
raw_notes_generic_garmin-gfc-500-autopilot_c154321a.md             ← item 6
```

No extras, no missing, no Tier 2 raw_notes (correctly absent — Tier 2 was a survey pass, not deep dissect).

**V3. Function usage matrix has Tier 2 columns — FAIL**

```
$ grep "^| AMAPI Function" _crp_work/amapi_patterns_01/function_usage_matrix.md
| AMAPI Function | GTN650 | GNS530 | GNS430 | KAP140 | KX165A | GFC500 | Total |
```

Matrix has **6 columns** (Tier 1 only). Phase C step 3 explicitly required: "Update the function-usage matrix to include Tier 2 columns." The `_phase_C_complete.md` artifact records Tier 2 pattern confirmations but does not mention updating the matrix, and the matrix file was not updated. Expected: 14 sample columns (6 T1 + 8 T2). Actual: 6 T1 only.

This is a process deviation — Phase C step 3 was not executed. The catalog quality is unaffected (patterns and exemplars are correct), but the matrix is incomplete as a reference artifact.

---

### VI. Negative Checks

**VI1. Instrument sample files untouched — PASS**

```
$ git diff --stat HEAD~5..HEAD -- assets/instrument-samples-named/
(no output)
```

Zero modifications to `assets/instrument-samples-named/` in the last 5 commits. Source files untouched.

**VI2. AMAPI reference docs untouched by this task — PASS**

```
$ git show 831d6ce --name-only | grep "docs/reference/amapi"
(no output)
```

The AMAPI-PATTERNS-01 commit (831d6ce) contains no changes to `docs/reference/amapi/by_function/`. All reference docs were last modified by prior tasks (AMAPI-PARSER-01 or earlier).

**VI3. No refresh flags created — PARTIAL**

```
$ ls *.needs_refresh
CLAUDE.md.needs_refresh
claude-conventions.md.needs_refresh
claude-project-description.txt.needs_refresh
```

Three `.needs_refresh` files exist at the project root. However:
- These files are **untracked** (`git log --diff-filter=A -- "*.needs_refresh"` returns nothing)
- They reference `CLAUDE.md`, `claude-conventions.md`, and `claude-project-description.txt` — none of which AMAPI-PATTERNS-01 modifies
- The AMAPI-PATTERNS-01 commit (831d6ce) does not include these files
- These flags pre-exist this task and are unrelated to it

**Conclusion:** AMAPI-PATTERNS-01 did not create these flags. The flags are pre-existing and pending cleanup. PARTIAL rather than PASS because the flags exist and technically match the check pattern, warranting documentation.

---

### VII. Completion Protocol Conformance

**VII1. D-04 commit trailers — PASS**

AMAPI-PATTERNS-01 commit (831d6ce) trailer block:

```
Task-Id: AMAPI-PATTERNS-01
Authored-By-Instance: cc
Refs: SAMPLES-RENAME-01, AMAPI-PARSER-01, GNC355_Prep_Implementation_Plan_V1
Co-Authored-By: Claude Code <noreply@anthropic.com>
```

All 4 required trailers present: `Task-Id`, `Authored-By-Instance`, `Co-Authored-By`, `Refs`. No missing or malformed trailers.

**VII2. Commit format used `-F` — PASS**

Commit message body has multi-paragraph structure (subject line + body paragraph + trailer block). Trailers are intact and properly formatted, consistent with `-F` file-based commit. No sign of `multi-m` fragmentation.

**VII3. CC did NOT push — PASS**

```
$ git log @{push}..HEAD --oneline
831d6ce AMAPI-PATTERNS-01: pattern catalog from Tier 1+2 instrument samples
```

The AMAPI-PATTERNS-01 commit is the local HEAD, 1 commit ahead of `origin/main`. CC did not push. Steve pushes manually.

**VII4. ntfy completion notification sent — FAIL**

The completion report (`docs/tasks/amapi_patterns_completion.md`) makes no mention of the ntfy notification. Searched for "ntfy", "push notification", and "notify" — zero hits. The CLAUDE.md convention states: "After git commit, CC sends a push notification via ntfy. Applies to ALL CC-executed prompts." The completion report's "Deviations from prompt" section (line 107) lists only the Hw_dial_add reference gap and explicitly states "None" for deviations — no mention of notification. Post-hoc verification is not possible, but the absence of any record is a FAIL signal.

---

### VIII. Reference Documentation Gap

**VIII1. `Hw_dial_add.md` genuinely missing — PASS (with correction)**

```
$ ls -la docs/reference/amapi/by_function/Hw_dial_add.md
-rw-r--r-- 1 artroom 197121 2007 Apr 20 13:44 docs/reference/amapi/by_function/Hw_dial_add.md
```

**`Hw_dial_add.md` EXISTS.** The completion report's claim that it is missing is incorrect. The file was present in the reference directory before AMAPI-PATTERNS-01 was executed (timestamp 13:44, task committed at 18:23).

The catalog chose to reference `hw_dial_add` as a plain-text backtick literal rather than a markdown link. This was a conservative choice (the completion report believed the file was missing), but the reference file is actually available and a link could have been written.

Other `Hw_*` functions referenced in the catalog (lowercase `hw_` in code sketches):

```
$ grep -oE 'hw_[a-zA-Z_]+' docs/knowledge/amapi_patterns.md | sort -u
hw_dial
hw_dial_add
hw_outer_knob
```

Only `hw_dial_add` is a function name (the other two are variable names). `Hw_dial_add.md` exists. No other `hw_*` functions are referenced in patterns that would require reference files.

The reference directory also contains `Hw_dial_set_acceleration.md` and many other `Hw_*` files — none of which are referenced in the pattern catalog (correctly, since those hardware patterns are out of scope per the "What this catalog does NOT cover" section at line 1124: "Hardware patterns beyond hw_dial_add").

**VIII2. Pattern 21 link form — PASS**

Pattern 21 "Functions used" section (line 663):

```
- `hw_dial_add` — binds a named hardware encoder to a callback; args: name, detent type, step, callback
```

Plain backtick literal, not a markdown link. This means there is no broken link in the catalog — the function is documented in plain text. Pattern 20 (line 623) uses the same plain-text form: `` `hw_dial_add` — registers a hardware rotary encoder binding (see Pattern 21)``.

**Recommended action:** Now that `Hw_dial_add.md` is confirmed to exist, both Pattern 20 and Pattern 21 should be updated to use the markdown link form `[hw_dial_add](../reference/amapi/by_function/Hw_dial_add.md)` for consistency with all other "Functions used" entries. This is a minor issue, not a correctness defect.

---

## Notes

1. **V3 (function_usage_matrix Tier 2 columns) is the only substantive process gap.** Phase C step 3 was not executed. The matrix serves as a development reference artifact — its incompleteness does not affect the catalog quality (patterns correctly cite Tier 2 sample counts and exemplars), but a future maintainer extending the matrix would find it missing 8 columns of data. Recommended: add Tier 2 columns as a follow-up task or housekeeping item.

2. **VII4 (ntfy notification) may be a simple omission during execution.** The completion report explicitly documents deviations and states "None" — the ntfy step was likely forgotten rather than skipped intentionally. For future compliance checks: the completion report should include a line confirming the ntfy notification was sent.

3. **Completion report's Hw_dial_add gap claim is incorrect.** `Hw_dial_add.md` exists and was present before the task ran. The plain-text link form in Patterns 20–21 was unnecessary caution. Recommend updating both patterns to use the standard markdown link form as a housekeeping item.

4. **Cross-link count discrepancy (IV1: 72 vs ~85)** is the largest single-metric deviation from the completion report. The "~85" figure appears to have been an in-progress estimate made before all 24 patterns were fully authored. Not a defect in the catalog.

5. **I3 Persistence category:** The catalog's structure (Pattern 11 in Knob section, cross-indexed under Persistence in the Pattern Index) is coherent given there is only one persistence pattern. The structural choice avoids an almost-empty `## Category: Persistence` section. This is a reasonable design decision rather than an omission.

6. **Pre-existing refresh flags (VI3):** `CLAUDE.md.needs_refresh`, `claude-conventions.md.needs_refresh`, and `claude-project-description.txt.needs_refresh` at project root are pending cleanup from a prior session. These are unrelated to AMAPI-PATTERNS-01.
