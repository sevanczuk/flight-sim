# CC Task Prompt: C2.2-B — GNX 375 Functional Spec V1 Fragment B (§§4.1–4.6)

**Created:** 2026-04-22T10:53:27-04:00
**Source:** CD Purple session — Turn 1 (post-resumption from 2026-04-22-1100-purple checkpoint) — second of 7 piecewise fragments per D-18
**Task ID:** GNX375-SPEC-C22-B (Stream C2, sub-task 2B for the 375 primary deliverable)
**Parent reference:** `docs/decisions/D-18-c22-format-decision-piecewise-manifest.md` §"Task partition"
**Authorizing decisions:** D-11 (outline-first), D-12 (pivot to 375), D-14 (procedural fidelity), D-15 (display architecture — no internal VDI), D-16 (XPDR + ADS-B scope), D-18 (piecewise format + 7-task partition), D-19 (fragment line-count expansion ratio)
**Predecessor task:** GNX375-SPEC-C22-A (`docs/tasks/completed/c22_a_*.md`) — produced Fragment A (§§1–3, Appendix B glossary, Appendix C extraction gaps); Fragment A content at `docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md` is an authoritative backward-reference source for this task
**Depends on:** C2.2-A archived (✅ Turn 35), manifest at `docs/specs/GNX375_Functional_Spec_V1.md` exists (✅ Turn 35)
**Priority:** Critical-path — second of 7 fragments; largest display-pages fragment; contains B4 Gap 1 (Map rendering architecture) as a major open design question that must NOT be resolved in spec body
**Estimated scope:** Medium-Large — ~90–120 min; authors ~720 lines across 6 distinct display-page sub-sections (§4.1 ~50, §4.2 ~200, §4.3 ~150, §4.4 ~60, §4.5 ~100, §4.6 ~50, plus §4 parent scope intro, fragment header, and Coupling Summary)
**Task type:** docs-only (no code, no tests)
**CRP applicability:** NO — single phase, single output file

---

## Source of Truth (READ ALL OF THESE BEFORE AUTHORING ANY SPEC BODY CONTENT)

### Tier 1 — Authoritative content source

1. **`docs/specs/GNX375_Functional_Spec_V1_outline.md`** — **THE PRIMARY BLUEPRINT.** For C2.2-B, authoritative content comes from:
   - The outline header (pp. 1–26): format decision + navigation aids + the §4 parent scope paragraph
   - **§4 parent scope** (~10 lines): enumerates display pages; notes GNX 375 additions (XPDR app icon, GPS NAV Status indicator key, CDI On Screen toggle, built-in ADS-B framing for Hazard Awareness); notes omission of §4.11 COM Standby Control Panel
   - **§4.1 Home Page and Page Navigation Model** (~50 lines)
   - **§4.2 Map Page** (~200 lines) — largest single sub-section of this fragment
   - **§4.3 Active Flight Plan (FPL) Page** (~150 lines)
   - **§4.4 Direct-to Page** (~60 lines)
   - **§4.5 Waypoint Information Pages** (~100 lines)
   - **§4.6 Nearest Pages** (~50 lines)

   **Do not deviate from the outline's section numbering, sub-structure, or page references.** The outline is the contract; this task expands it into prose.

2. **`docs/decisions/D-18-c22-format-decision-piecewise-manifest.md`** — format contract. Defines fragment file conventions (path, YAML front-matter, heading levels), the Coupling Summary convention, and the sequential delivery order rationale. Read §"Fragment file conventions" and §"Coupling summary convention" before authoring.

3. **`docs/decisions/D-19-fragment-prompt-line-count-expansion-ratio.md`** — line-count authority for this task. Target: **~720 lines** for Fragment B. D-19's rationale breaks down the expansion ratio; no recomputation needed.

4. **`docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md`** — **Fragment A (previous archived fragment). Authoritative backward-reference source.** Appendix B glossary terms, §2 physical control terminology (knob behavior, touchscreen gestures, outer knob page navigation, Power/Home key), and §1 framing (GNX 375 baseline, TSO-C112e, no internal VDI) are defined here and must be used consistently — do not redefine. Load this file into your reading during Phase 0.

5. **`docs/specs/GNX375_Functional_Spec_V1.md`** — the fragment manifest. Covers assembly instructions and tracks per-fragment status. Read the manifest entry for Fragment B (order 2, covers §§4.1–4.6) and confirm your output path matches.

### Tier 2 — PDF source material (authoritative for content details)

6. **`assets/gnc355_pdf_extracted/text_by_page.json`** — the primary PDF content source (310 pages). For C2.2-B, the relevant pages are:
   - §4 parent scope context: pp. 17–20 (overview intro), 86 (Home/apps context)
   - §4.1 Home Page: pp. 17, 24, 28–30, 86
   - §4.2 Map Page: pp. 113–139 (heaviest page range; includes map symbols, overlays, interactions, Smart Airspace, SafeTaxi)
   - §4.3 FPL Page: pp. 140–158 (data columns, GPS NAV Status indicator key on p. 158, Flight Plan Catalog, OBS mode, Dead Reckoning, Parallel Track)
   - §4.4 Direct-to Page: pp. 159–164
   - §4.5 Waypoint Information Pages: pp. 165–178
   - §4.6 Nearest Pages: pp. 179–180

   Read these pages (JSON `pages[N-1]` indexed from 0) when authoring to confirm specific facts. **The outline already cites specific page numbers — honor those citations in the spec body.**

7. **`assets/gnc355_pdf_extracted/extraction_report.md`** — extraction quality notes. Relevant: **p. 125 is sparse** (land data symbols — supplement image exists, see below). This affects §4.2 Map Page aviation/land symbols content. Fragment A's Appendix C already enumerates sparse pages; do not re-enumerate here, but do note that land-data-symbols content in §4.2 references the supplement.

8. **`assets/gnc355_reference/land-data-symbols.png`** — supplement for p. 125. The §4.2 Map Page treatment of Land Data Symbols must reference this supplement by path (`assets/gnc355_reference/land-data-symbols.png`) to document the source of the enumerated land symbols list.

### Tier 3 — Cross-reference context

9. **`docs/knowledge/355_to_375_outline_harvest_map.md`** — harvest categorization. For C2.2-B, the relevant categorizations:
   - §4.1: [PART] — XPDR app icon addition
   - §4.2: [FULL with note on default user fields] — default Map user fields differ on GNX 375 vs. GNC 355
   - §4.3: [PART] — GPS NAV Status indicator key added; Flight Plan User Field removed
   - §4.4: [FULL]
   - §4.5: [FULL] — with noted GNX 375 benefit (built-in ADS-B In / FIS-B for Airport Weather tab)
   - §4.6: [FULL]

10. **`docs/knowledge/amapi_by_use_case.md`** — A3 use-case index. The outline's "AMAPI cross-refs" bullets cite specific sections (§3 touchscreen, §6 static content, §7 dynamic 2D content, §8 running displays, §10 maps and navigation data). When transcribing these cross-refs to the spec body, verify the referenced sections exist.

11. **`docs/knowledge/amapi_patterns.md`** — B3 pattern catalog. The outline cites pattern numbers for specific UI primitives. Verify existence when authoring.

12. **`docs/knowledge/stream_b_readiness_review.md`** — B4 readiness review. Documents three non-blocking coverage gaps. **For this task, B4 Gap 1 (Map rendering architecture: canvas vs. Map_add API vs. video streaming) is the critical reference.** Read the B4 Gap 1 section specifically. B4 Gap 2 (scrollable list implementation) is also relevant to §4.3 FPL Page. **Neither gap is to be resolved in the spec body** — see framing commitments below.

13. **`docs/decisions/D-01-project-scope.md`** — XPL primary + MSFS secondary
14. **`docs/decisions/D-12-pivot-gnc355-to-gnx375-primary-instrument.md`** — pivot rationale; affects §4.3 Flight Plan User Field omission framing
15. **`docs/decisions/D-15-gnx375-display-architecture-internal-vs-external-turn-20-research.md`** — no-internal-VDI constraint; relevant to §4.1 (no CDI On Screen implementation detail here — that's §4.10 in Fragment C — but Fragment B's Home page enumerate Settings icon which leads to the setting)
16. **`docs/decisions/D-16-gnx375-xpdr-adsb-scope-corrections-turn-21-research.md`** — XPDR scope; relevant to §4.1 XPDR app icon presence and §4.5 Airport Weather FIS-B framing
17. **`docs/tasks/completed/c22_a_prompt.md`** — **structural template.** Use the same section structure, YAML front-matter format, heading-level conventions, Coupling Summary block format, and self-review checklist pattern. Do **not** copy the content — scope and hard constraints are different. This is a style/structure reference only.

18. **`CLAUDE.md`** (project conventions, commit format, ntfy requirement)
19. **`claude-conventions.md`** §Git Commit Trailers (D-04)

**Audit level:** standard — CD will check completions and run a compliance verification modeled on the C2.2-A compliance approach (~17-item check). This is the second C2.2 fragment; the compliance bar is consistent with C2.2-A and benefits from template reuse.

---

## Pre-flight Verification

**Execute these checks before authoring any fragment content. If any fails, STOP and write `docs/tasks/c22_b_prompt_deviation.md`.**

1. Verify Tier 1 source files exist:
   ```bash
   ls docs/specs/GNX375_Functional_Spec_V1_outline.md
   ls docs/decisions/D-18-c22-format-decision-piecewise-manifest.md
   ls docs/decisions/D-19-fragment-prompt-line-count-expansion-ratio.md
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
   ls docs/specs/GNX375_Functional_Spec_V1.md
   ```

2. Verify Tier 2 source files exist:
   ```bash
   ls assets/gnc355_pdf_extracted/text_by_page.json
   ls assets/gnc355_pdf_extracted/extraction_report.md
   ls assets/gnc355_reference/land-data-symbols.png
   ```

3. Verify outline integrity (1,477 lines expected):
   ```bash
   wc -l docs/specs/GNX375_Functional_Spec_V1_outline.md
   ```
   Expect exactly 1,477 lines.

4. Verify Fragment A integrity (545 lines expected per archived completion report):
   ```bash
   wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md
   ```
   Expect 545 lines (±5). Fragment A will be read in full during Phase 0.

5. Verify `text_by_page.json` structural integrity on relevant pages:
   ```bash
   python3 -c "import json; d = json.load(open('assets/gnc355_pdf_extracted/text_by_page.json')); p = d['pages']; print(f'pages={len(p)}'); print(f'p113={p[112][\"text_char_count\"]}'); print(f'p140={p[139][\"text_char_count\"]}'); print(f'p158={p[157][\"text_char_count\"]}'); print(f'p165={p[164][\"text_char_count\"]}'); print(f'p179={p[178][\"text_char_count\"]}')"
   ```
   Expect 310 pages; p. 113 (Map), p. 140 (FPL), p. 158 (GPS NAV Status indicator key), p. 165 (Waypoint Info), p. 179 (Nearest) should all have non-trivial character counts.

6. Verify no conflicting fragment output exists:
   ```bash
   ls docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md 2>/dev/null
   ```
   Expect failure (file should not exist yet). If it exists, STOP and note in deviation report.

---

## Phase 0: Source-of-Truth Audit

Before authoring any spec body content:

1. Read all Tier 1 documents in full (outline §4 parent + §§4.1–4.6, D-18, D-19, Fragment A).
2. Read Fragment A in its entirety — not just the Appendix B glossary. Fragment A's §2 (Physical Layout & Controls) and §1 (Overview) establish terminology and framing that Fragment B must use consistently.
3. Read the PDF pages listed in outline sub-section `[pp. N]` citations (pp. 113–139 for §4.2, pp. 140–158 for §4.3, etc.).
4. Read `docs/knowledge/355_to_375_outline_harvest_map.md` §§ covering §§4.1–4.6.
5. Read `docs/knowledge/stream_b_readiness_review.md` B4 Gap 1 and B4 Gap 2 sections specifically.

**Definition — Actionable requirement:** A statement in the outline or an authorizing decision that, if not reflected in the fragment, would make the fragment incomplete relative to what C2.2-C through C2.2-G depend on. Includes: page-structure contracts that later fragments reference (e.g., §4.1 Home page app icon grid enumerates the XPDR icon which Fragment F §11 depends on; §4.3 GPS NAV Status indicator key behavior which Fragments D and F reference), framing decisions (GNX 375 default Map user fields, FPL page omissions, FIS-B built-in receiver for Airport Weather), and open-question preservation (B4 Gap 1, B4 Gap 2, OPEN QUESTION 1 on altitude constraints).

6. Extract actionable requirements. Particular attention to:
   - **§4.1 Home Page**: XPDR app icon (GNX 375 only — NOT on GPS 175 or GNC 355); complete app icon inventory (Map, FPL, Direct-to, Waypoints, Nearest, Procedures, Weather, Traffic, Terrain, XPDR, Utilities, System Setup); locater bar with Slot 1 = Map (fixed) and Slots 2–3 = user-configurable; Back key + Power/Home key behavior (reference Fragment A §2 for the physical key details, do not redefine)
   - **§4.2 Map Page**: default user fields differ per unit (GNX 375 / GPS 175: distance, ground speed, desired track and track, distance/bearing from destination airport; GNC 355/355A: distance, ground speed, DTK/TRK, from/to/next waypoints); field options list (~25 options: BRG, DIS, DIS/BRG, GS, GSL, DTK, TRK, ALT, VERT SPD, ETE, ETA, XTK, CDI, OAT, TAS, WIND, plus OFF and Restore User Fields); map orientation modes (North Up, Track Up, Heading Up; North Up Above); Visual Approach orientation behavior; TOPO scale, Range ring, Track vector, Ahead View; Map detail levels (full/high/medium/low); aviation data symbols (airport variants, heliport, intersection, NDB, VOR, VRP); land data symbols (reference supplement for p. 125 sparse content); map interactions (zoom via pinch/stretch + inner knob, pan via swipe/drag, tap selection, map pointer + info banner, Next key for stacked objects, graphical flight plan editing); overlays (TOPO, Terrain, Traffic via built-in ADS-B In, NEXRAD, TFRs, Airspaces, SafeTaxi); Smart Airspace; SafeTaxi (runways, taxiways, hot spots)
   - **§4.3 FPL Page**: waypoint list layout with coloring (magenta active / white past-future / gray transition); Airport Info shortcut; active leg status indications (FAF/MAP/fix type symbols match chart labels); 3 data columns configurable via Edit Data Fields (restore to defaults); Collapse All Airways; OBS mode toggle (forward-ref §5); Dead Reckoning display; Parallel Track; Flight Plan Catalog access (open/activate/invert); **GPS NAV Status indicator key [p. 158] — GNX 375 / GPS 175 only, NOT GNC 355** with three states (no-plan icon, active-route display, CDI-scale-active display); User Airport Symbol; Fly-over Waypoint Symbol (v3.20+); **Flight Plan User Field OMITTED on GNX 375** (GNC 355/355A only, p. 155)
   - **§4.4 Direct-to Page**: search tabs (Waypoint, Flight Plan, Nearest); waypoint identifier + course option + hold option; distance/bearing display; activation methods (direct-to new waypoint, direct-to flight plan waypoint, direct-to off-route course); remove direct-to; user holds (suspend/expire/remove)
   - **§4.5 Waypoint Info Pages**: waypoint types (Airport, Intersection, VOR, VRP, NDB, User Waypoint); common page layout (identifier key, location, nearest NAVAID, waypoint type, action keys); Airport tabs (Info, Procedures, Weather, Chart); **Weather tab FIS-B framing — GNX 375 has built-in dual-link receiver, no external hardware required** (contrast with GPS 175 which has no ADS-B In); VOR frequency/class/elevation/ATIS; NDB frequency/class; User Waypoint (Edit/View List/Delete); FastFind Predictive Waypoint Entry; Search Tabs (Airport/Intersection/VOR/NDB/User/by Name/by Facility Name); USER tab up to 1,000 user waypoints
   - **§4.6 Nearest Pages**: access via Home > Nearest; Nearest Airports (up to 25 within 200 nm — identifier, distance, bearing, runway info); Nearest NDB/VOR/Intersection/VRP; Nearest ARTCC (facility, distance, bearing, frequency); Nearest FSS (facility, distance, bearing, frequency, "RX" = receive-only); Runway criteria filter

7. **Open-question preservation checklist:**
   - §4.1: "Home page exact icon layout and icon assets: image-based page; pixel-accurate layout requires screen captures or physical device reference" — PRESERVE
   - §4.2: B4 Gap 1 (Map rendering architecture) — PRESERVE as "major design decision deferred to design phase"; NEXRAD/traffic overlay behavior when ADS-B In data is unavailable — PRESERVE
   - §4.3: B4 Gap 2 (scrollable list implementation) — PRESERVE as "design decision in design phase"; OPEN QUESTION 1 (altitude constraints on flight plan legs — whether 375 automatically displays published procedure altitude restrictions) — PRESERVE as "behavior unknown; research needed during design phase"
   - §4.4: "None; content is well-extracted" — no open questions; no action
   - §4.5: Airport weather tab behavior when no FIS-B uplink available — PRESERVE
   - §4.6: "None; content is clean" — no open questions; no action

8. If ALL requirements are covered by your planned fragment structure: print "Phase 0: all source requirements covered" and proceed to authoring.
9. If any requirement is uncovered: write `docs/tasks/c22_b_prompt_phase0_deviation.md` and STOP.

---

## Instructions

Produce the second fragment of the GNX 375 Functional Spec V1 body: the first half of §4 Display Pages, covering the six GPS operational display pages (Home, Map, FPL, Direct-to, Waypoint Info, Nearest). This is the largest display-pages fragment and contains one major design open question (B4 Gap 1 Map rendering architecture) plus one procedural open question (OPEN QUESTION 1 altitude constraints) that must be preserved in spec-body form without being resolved.

**Primary output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`

### Authoring strategy

Same as C2.2-A: outline provides structural skeleton; task expands outline bullets into implementable prose while preserving structure, page references, and cross-references.

#### Authoring depth guidance

- **§4 parent scope paragraph:** 3–5 sentences introducing the §4 section as a whole (page-structure focus rather than operational workflows), noting the GNX 375 additions and omissions. Immediately followed by the §4.1 sub-section header.

- **Scope paragraphs (per sub-section):** 2–4 sentences per sub-section. State what the page is for, its key GNX 375-specific framing (if any), and any operational cross-refs (e.g., "§4.3 documents the active flight plan page layout; operational workflows for creating and editing flight plans are in §5.").

- **Sub-section prose:** each outline bullet should become a short block (5–20 lines typical for short bullets; up to 40 lines for dense bullets like §4.2 map orientation or §4.2 overlays) with bullet points expanded into prose or preserved as refined lists where enumeration is natural (field options, overlay types, aviation data symbols, search tabs). Preserve source-page citations inline.

- **Tables:** use tables where content is naturally tabular. Expected tables in Fragment B:
  - §4.1: app icon inventory (icon name, function, sibling unit presence)
  - §4.2: default Map user fields per unit (unit, 4 default fields)
  - §4.2: field options (option code, meaning)
  - §4.2: map orientation modes (mode, description, altitude-trigger behavior if applicable)
  - §4.2: aviation data symbols (symbol category, representation note)
  - §4.3: FPL data column options (column, definition)
  - §4.3: GPS NAV Status indicator key states (state, trigger condition, display contents)
  - §4.5: waypoint type tabs (type, key fields displayed)

- **AMAPI cross-refs:** at the end of each sub-section where the outline cites AMAPI references, include an "AMAPI notes" block citing the specific `amapi_by_use_case.md` section or `amapi_patterns.md` pattern number. Do not expand the AMAPI content — that's the design-spec's job. Just cite.

- **Open questions / flags:** preserve every outline flag as "Open questions" sub-bullets at the end of the relevant sub-section. Use the same non-speculative language the outline uses. Specifically flagged items (see framing commitments below): B4 Gap 1, B4 Gap 2, OPEN QUESTION 1.

- **Cross-references to other fragments:** use the Coupling Summary convention from D-18.
  - Backward-refs to Fragment A: cite glossary terms and physical control terminology naturally. Since Fragment A's content becomes part of the assembled spec, the cross-ref is just "see §2.7" — no need to mention the fragment. **Use `see §N.x` without fragment qualification** in the body prose; the Coupling Summary block at end tracks which sub-sections this fragment references from prior fragments.
  - Forward-refs to later fragments: use `see §N.x` without further qualification. Later fragments will author the targets.

#### Fragment file conventions (per D-18)

- **Path:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`
- **YAML front-matter (required):**
  ```yaml
  ---
  Created: 2026-04-22T{HH:MM:SS}-04:00
  Source: docs/tasks/c22_b_prompt.md
  Fragment: B
  Covers: §§4.1–4.6 (Home, Map, FPL, Direct-to, Waypoint Info, Nearest pages)
  ---
  ```
- **Heading levels:**
  - `# GNX 375 Functional Spec V1 — Fragment B` — fragment header (stripped on assembly)
  - `## 4. Display Pages` — **shared section header with Fragment C.** Include the §4 parent scope paragraph under this header. Fragment C will open directly with `### 4.7 Procedures Pages` (no duplicate §4 header) so the assembly script's concatenation yields a single continuous §4. Include the §4 parent scope ONLY in Fragment B. Document this in the Coupling Summary.
  - `### 4.1 Home Page and Page Navigation Model [pp. 17, 28–29, 86]` — sub-sections. Note: do NOT include the harvest-category marker (`— [PART]`) in the spec body heading; that's outline-authoring metadata. Keep the Pilot's Guide page refs in square brackets per outline convention.
- **Line count target:** ~720 lines per D-19. Under-delivery (<650) suggests under-coverage of outline content; over-delivery (>800) suggests either content creep or genuine content density that warrants completion-report classification.

#### Specific framing commitments

These are **hard constraints** that must appear in the fragment:

1. **§4.2 Map rendering architecture (B4 Gap 1) — DO NOT RESOLVE.** The spec body documents the Map page's structure, data fields, overlays, and behavior contract. It does NOT commit to a rendering technology (canvas drawing vs. Map_add API vs. video streaming). The relevant §4.2 AMAPI cross-refs note the candidate APIs and explicitly flag "Implementation architecture choice (Map_add API vs. canvas vs. video streaming): major design decision deferred to design phase." Preserve this flag verbatim (or with minor rewording consistent with spec-body voice). Do not write sentences that commit to any particular rendering approach.

2. **§4.3 Scrollable list implementation (B4 Gap 2) — DO NOT RESOLVE.** The FPL page is a scrollable list; the spec must document the list's behavior (row content, scrolling behavior, coloring, active-leg highlighting) without committing to an implementation mechanism (GTN 650 sample-style vs. invented AMAPI pattern). Preserve the flag: "Scrollable list implementation mechanism: B4 Gap 2 design decision; spec must commit in design phase." Do not commit in the spec body.

3. **§4.3 OPEN QUESTION 1 (altitude constraints on FPL legs) — PRESERVE.** Whether the 375 automatically displays published procedure altitude restrictions (cross at/above/below/between) is not documented in the extracted PDF. VCALC is a separate pilot-input planning tool, not automatic from procedure data. Preserve this flag verbatim.

4. **§4.1 XPDR app icon — GNX 375 only.** The Home page app icon inventory must explicitly note that XPDR is a GNX 375-only icon, not present on GPS 175 or GNC 355. Do NOT describe XPDR-panel internals in §4.1 (those live in §11, Fragment F); forward-ref: "see §11 for XPDR control panel detail."

5. **§4.3 GPS NAV Status indicator key — GNX 375 / GPS 175 only.** Explicitly note it is NOT present on GNC 355. Document its three states (no-plan, active route, CDI scale active) per outline.

6. **§4.3 Flight Plan User Field — OMITTED.** The GNC 355/355A Flight Plan User Field (p. 155) is NOT present on the GNX 375. Note this omission explicitly in §4.3 (one sentence). Do not document the field's behavior in prose — that would be out of scope for the 375 spec.

7. **§4.5 Airport Weather tab FIS-B framing.** GNX 375 has the built-in dual-link ADS-B In receiver, so FIS-B weather (METAR/TAF) is available without external hardware. Frame this as a GNX 375 advantage vs. GPS 175 (which has no ADS-B In). Preserve the open question: "behavior when no FIS-B ground station uplink is available."

8. **No COM radio content anywhere.** §§4.1–4.6 must contain zero references to COM frequency tuning, COM standby, COM volume, or COM monitoring as present features on the GNX 375. COM may only be mentioned in sibling-unit comparison prose (e.g., "the GNC 355 adds a VHF COM radio" in §4.1 comparison context). §4.11 COM Standby Control Panel (in the 355 outline) is OMITTED entirely from the 375 spec; do not reference it, do not mention its omission (Fragment A §1 already established the no-COM framing).

9. **Default Map user fields per-unit distinction (§4.2).** Explicitly document the difference: GNX 375 and GPS 175 share the same default set (distance, ground speed, desired track and track, distance/bearing from destination airport); GNC 355/355A have a different default set (distance, ground speed, DTK/TRK, from/to/next waypoints). This is [FULL with note on default user fields] per harvest map; the "note" is this per-unit default distinction.

10. **Reference supplement for §4.2 Land Data Symbols.** The Pilot's Guide p. 125 is sparse for land data symbols. The §4.2 Land Data Symbols content must reference `assets/gnc355_reference/land-data-symbols.png` as the source for the enumerated land symbols list. Do NOT attempt to enumerate land symbols from p. 125 alone — use the supplement's content.

11. **No internal VDI framing.** Any §4 content that touches vertical deviation must be consistent with Fragment A §1's no-internal-VDI framing (D-15). Fragment B does not author any VDI-specific content directly (VDI is addressed in §7 Procedures in Fragment D and §15 External I/O in Fragment G), but must not accidentally imply the GNX 375 renders VDI internally.

#### Per-section page budget (informative)

| Section | Outline estimate | Fragment prose target |
|---------|------------------|------------------------|
| Fragment header + YAML + §4 parent scope intro | — | ~20 |
| §4.1 Home Page | ~50 | ~65 |
| §4.2 Map Page | ~200 | ~265 |
| §4.3 FPL Page | ~150 | ~195 |
| §4.4 Direct-to Page | ~60 | ~75 |
| §4.5 Waypoint Info Pages | ~100 | ~125 |
| §4.6 Nearest Pages | ~50 | ~60 |
| Coupling Summary block | — | ~15 |
| **Total target** | **~610** | **~720** |

The ~110-line buffer over the outline sum accounts for fragment header, YAML front-matter, §4 parent scope intro, per-sub-section scope paragraphs, AMAPI notes blocks, and Coupling Summary block. Expansion ratio ~1.18× per D-19.

#### Coupling Summary block

At the end of the fragment (after §4.6), include a **Coupling Summary** section per D-18:

```markdown
---

## Coupling Summary

This section is authored per D-18 for CD/CC coordination across the 7-fragment spec. It is not part of the spec body and is stripped on assembly.

### Backward cross-references (sections this fragment references that were authored in prior fragments)

- Fragment A §1 (Overview): GNX 375 baseline framing, TSO-C112e, no-internal-VDI, sibling-unit distinctions — all referenced in §4.1 app icon enumeration and §4.5 Airport Weather FIS-B framing.
- Fragment A §2 (Physical Layout & Controls): knob behavior (inner knob push = Direct-to, §2.7), touchscreen gestures (§2.3 pinch/stretch zoom, swipe/drag pan, tap selection — referenced in §4.2 map interactions), outer knob page navigation (§2.5–2.6 — referenced in §4.1), Power/Home key (§2.1 — referenced in §4.1 navigation model), Back key (§2.4 — referenced in §4.1 navigation model).
- Fragment A Appendix B (Glossary): FastFind, FIS-B, TIS-B, METAR, TAF, CDI, OBS, NDB, VOR, VRP, ARTCC, FSS, Smart Airspace, SafeTaxi, TSAA, 1090 ES, UAT — all referenced without redefinition.
- Fragment A §3 (Power-On/Startup): not directly referenced; Fragment B assumes unit is in post-startup operational state.

### Forward cross-references (sections this fragment writes that later fragments will reference)

- §4.1 Home page app icon grid → §11 XPDR Control Panel (Fragment F) for XPDR icon target; §7 Procedures (Fragment D) for Procedures icon target; §8 Nearest Functions (Fragment E) for Nearest icon target; §9 Waypoint Information operations (Fragment E); §10 Settings/System (Fragment E) for System Setup icon target.
- §4.2 Map overlays (Traffic, NEXRAD) → §11.11 ADS-B In (Fragment F) for source data; §4.9 Hazard Awareness (Fragment C) for display consumer framing.
- §4.2 Graphical flight plan editing → §5 Flight Plan Editing (Fragment D) for edit workflow detail.
- §4.2 Map interactions → §2.3 (Fragment A, backward-ref) for touchscreen gesture source; no forward-ref needed.
- §4.3 OBS mode toggle → §5 Flight Plan Editing (Fragment D) for manual waypoint sequencing behavior.
- §4.3 Flight Plan Catalog access → §5 Flight Plan Editing (Fragment D) for stored-plan operations.
- §4.3 GPS NAV Status indicator key → §10 Settings (Fragment E) for any related configuration; §11.7 Transponder Status Indications (Fragment F) for relationship to XPDR status (if any).
- §4.3 Dead Reckoning display → §14 Persistent State (Fragment G) for last-known position preservation.
- §4.4 Direct-to activation, user holds → §6 Direct-to Operation (Fragment D) for full operational detail.
- §4.5 Airport Weather tab → §11.11 ADS-B In / FIS-B (Fragment F) for FIS-B source; §10 Settings (Fragment E) for any weather-related display configuration.
- §4.5 User Waypoint Edit/View List/Delete → §9 Waypoint Information (Fragment E) for full user-waypoint management workflows.
- §4.5 FastFind, Search Tabs → §9 Waypoint Information (Fragment E) for search-pattern detail.
- §4.6 Runway criteria filter → §10 Settings (Fragment E) for filter configuration.

### §4 parent-scope authoring note

This fragment authors the §4 parent scope paragraph (introductory content under `## 4. Display Pages`). Fragment C (C2.2-C, covering §§4.7–4.10) must NOT re-author this parent scope. Fragment C opens with `### 4.7 Procedures Pages` directly. The assembly script treats Fragments B and C as contiguous sub-sections under §4.

### Outline coupling footprint

This fragment draws from outline §4 parent scope + §§4.1–4.6. No content from §§4.7–4.10, §§1–3, §§5–15, or Appendices A/B/C is authored here.
```

---

## Integration Context

- **Primary output file:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` (new)
- **Directory already exists:** `docs/specs/fragments/` was created by C2.2-A.
- **No code modification in this task.** Docs-only.
- **No test suite run required.** Docs-only.
- **Do not modify the outline.** If you spot outline errors during authoring, note them in the completion report's Deviations section.
- **Do not modify Fragment A.** It is archival.
- **Do not modify the manifest yet.** CD will update the manifest status entry for Fragment B after this task archives.

---

## Implementation Order

**Execute phases sequentially. Do not parallelize phases or launch subagents.**

### Phase A: Read and audit (Phase 0 per above)

Read all Tier 1 and Tier 2 sources. Read Fragment A in full. Extract actionable requirements. Confirm coverage of the open-question preservation checklist. Print the Phase 0 completion line OR write the Phase 0 deviation report and STOP.

### Phase B: Create fragment file skeleton

1. Create the fragment file at `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` with YAML front-matter, fragment header, §4 parent scope placeholder, and section headers (`### 4.1`, `### 4.2`, `### 4.3`, `### 4.4`, `### 4.5`, `### 4.6`).
2. Add the Coupling Summary placeholder at the end.

### Phase C: Author §4 parent scope intro (~10 lines)

Write the §4 parent scope paragraph under `## 4. Display Pages`. Cover:
- Purpose of §4 (page-structure focus; operational workflows in later sections)
- Enumerate the sub-section inventory (4.1 Home, 4.2 Map, 4.3 FPL, 4.4 Direct-to, 4.5 Waypoint Info, 4.6 Nearest, 4.7 Procedures, 4.8 Planning, 4.9 Hazard Awareness, 4.10 Settings/System — note that 4.7–4.10 are authored in a separate fragment)
- GNX 375 additions vs. sibling units: XPDR app icon (§4.1), GPS NAV Status indicator key (§4.3), CDI On Screen toggle (§4.10, future fragment), built-in ADS-B framing for Hazard Awareness pages (§4.9, future fragment)
- Omission: §4.11 COM Standby Control Panel (GNC 355/355A feature, not on GNX 375)

### Phase D: Author §4.1 Home Page and Page Navigation Model (~65 lines)

Expand outline §4.1 into prose:
- Scope paragraph
- Home page layout: app icon tile grid
- App icon inventory table (or list) covering: Map, FPL, Direct-to, Waypoints, Nearest, Procedures, Weather, Traffic, Terrain, **XPDR (GNX 375 only — NOT on GPS 175 or GNC 355)**, Utilities, System Setup. For each icon, note its target page or forward-ref.
- Locater bar: 3 slots; Slot 1 = Map (fixed); Slots 2–3 user-configurable
- Page shortcut navigation via outer knob (backward-ref to Fragment A §2.5–2.6)
- Back key behavior (backward-ref to Fragment A §2.4)
- Power/Home key (backward-ref to Fragment A §2.1): returns to Home from any page
- AMAPI notes block: cite `amapi_by_use_case.md` §6 (static content/backgrounds) and §7 (dynamic 2D content)
- Open questions: icon layout and asset rendering (pixel-accurate layout requires screen captures or physical device reference)

### Phase E: Author §4.2 Map Page (~265 lines)

Largest sub-section of the fragment. Expand outline §4.2 into prose:
- Scope paragraph (note: B4 Gap 1 Map rendering architecture flag to be included below; do not commit in this paragraph)
- **Map page user fields (data corners) [pp. 114, 117–119]**
  - 4 configurable corner fields
  - Default user fields per-unit table (GNX 375, GPS 175, GNC 355/355A rows)
  - Field options table (~25 options)
  - OFF and Restore User Fields behaviors
- **Land and water depictions [p. 115]**
  - Reference-only; not primary navigation
  - Data drawing order priority (traffic, ownship, FPL labels → basemap)
- **Map setup options (via Menu) [pp. 116–123]**
  - Map orientation (North Up, Track Up, Heading Up; North Up Above altitude trigger)
  - Visual Approach orientation behavior
  - TOPO scale, Range ring, Track vector, Ahead View (note: not in North Up)
  - Map detail levels (full/high/medium/low)
- **Aviation data symbols [p. 124]**
  - Symbol table covering all types listed in outline
- **Land data symbols [p. 125]** — Reference `assets/gnc355_reference/land-data-symbols.png` supplement. Enumerate from supplement: railroad, national highway, freeway, local highway, local road, river/lake, state/province border, small/medium/large city symbols. Note Pilot's Guide p. 125 is sparse.
- **Map interactions [pp. 126–132]**
  - Basic: zoom (pinch/stretch, inner knob on Map), pan (swipe/drag)
  - Object selection: tap on map → map pointer + info banner (identifier, type, bearing, distance)
  - Stacked objects: Next key cycles through overlapping items
  - Graphical flight plan editing overlay: tap/drag to add or remove waypoints from active flight plan (forward-ref §5)
- **Map overlays [pp. 133–139]**
  - Overlay controls: via Map Menu; changes immediate
  - Available overlays list: TOPO, Terrain, Traffic (built-in ADS-B In), NEXRAD, TFRs, Airspaces, SafeTaxi
  - Overlay status icons: shown at current range; absence = not present at this zoom or data unavailable
  - Smart Airspace [p. 137]: de-emphasizes non-pertinent airspace relative to aircraft altitude
  - SafeTaxi [pp. 138–139]: high-resolution airport diagrams at low zoom levels; features runways, taxiways, landmarks, hot spots
- **AMAPI notes block:**
  - Map_add API → `docs/knowledge/amapi_by_use_case.md` §10 (Maps and navigation data)
  - Canvas-drawn overlays (Smart Airspace shapes, SafeTaxi outlines) → **B4 Gap 1**; consult `docs/reference/amapi/by_function/Canvas_add.md`
  - Running_img_add_cir (compass rose equivalent) → B4 Gap 3
- **Open questions / flags:**
  - **Implementation architecture choice (Map_add API vs. canvas vs. video streaming): major design decision deferred to design phase.** Do not resolve in spec body.
  - NEXRAD and Traffic overlay behavior when ADS-B In data is unavailable or degraded: spec must document degraded-data presentation (forward-ref §11.11 for source detail).

### Phase F: Author §4.3 Active Flight Plan (FPL) Page (~195 lines)

Expand outline §4.3 into prose:
- Scope paragraph (note: adds GPS NAV Status indicator key; omits Flight Plan User Field)
- Feature requirement: active flight plan present
- Waypoint list layout [p. 140]: scrolling list; row format; coloring (magenta active / white past-future / gray transition) [p. 141]
- Airport Info shortcut [p. 142]
- Active leg status indications [p. 143]: magenta FAF/MAP/fix type symbols match chart labels; From/To/Next indications
- Data columns (1–3) [p. 149]: selectable; Edit Data Fields; Restore to Defaults
  - Data column options table (if sufficient options enumerated in source; otherwise reference "various" and cite page 149)
- Collapse All Airways [p. 144]
- OBS mode toggle [p. 145]: activates manual waypoint sequencing (forward-ref §5)
- Dead Reckoning display [p. 146]: limited position/navigation using last known data; warning required
- Parallel Track display [pp. 147–148]: offset distance and direction
- Flight Plan Catalog access [pp. 150–151]: open/activate/invert (forward-ref §5 for stored-plan operations)
- **GPS NAV Status indicator key (GNX 375 / GPS 175 only, NOT GNC 355) [p. 158]**
  - Located lower right corner of display
  - States (table):
    - No flight plan: page access icon
    - Active route display: from-to-next identifiers + leg types
    - CDI scale active: from-to waypoints only (space constrained)
  - Tap: direct access to active flight plan when no plan exists; display-only when plan active
- User Airport Symbol [p. 156]
- Fly-over Waypoint Symbol [p. 157]: requires software v3.20+
- **Flight Plan User Field (GNC 355/355A only, NOT on GNX 375):** One sentence noting the omission; do not document the field's behavior.
- AMAPI notes block: scrollable list → **B4 Gap 2**; Txt_add/Txt_set → `amapi_by_use_case.md` §7; running displays → §8
- **Open questions / flags:**
  - **Scrollable list implementation mechanism: B4 Gap 2 design decision; spec must commit in design phase.** Do not resolve in spec body.
  - **OPEN QUESTION 1:** Altitude constraints on flight plan legs — whether the 375 automatically displays published procedure altitude restrictions (cross at/above/below/between) is not documented in the extracted PDF. VCALC is a separate pilot-input planning tool, not automatic from procedure data. Behavior unknown; research needed during design phase.

### Phase G: Author §4.4 Direct-to Page (~75 lines)

Expand outline §4.4 into prose:
- Scope paragraph
- Direct-to page layout: search tabs (Waypoint, Flight Plan, Nearest) [pp. 159–160]
- Waypoint tab: identifier + course option + hold option; distance/bearing from current position [p. 160]
- Activation: point-to-point from present position to waypoint [p. 161]
- Navigation modes [pp. 162–163]:
  - Direct-to new waypoint
  - Direct-to flight plan waypoint
  - Direct-to off-route course
- Remove direct-to course [p. 163]
- User holds [p. 164]: holding pattern at direct-to waypoint; suspend/expire/remove (forward-ref §6 for full ops)
- AMAPI notes block: `amapi_by_use_case.md` §3 (touchscreen), §10 (nav data queries)
- No open questions (content is well-extracted per outline)

### Phase H: Author §4.5 Waypoint Information Pages (~125 lines)

Expand outline §4.5 into prose:
- Scope paragraph (note: Airport Weather tab benefits from built-in ADS-B In FIS-B on GNX 375)
- Waypoint types table [p. 165]: Airport, Intersection, VOR, VRP, NDB, User Waypoint
- Common page layout (Intersection/VOR/VRP/NDB) [p. 166]
- Airport-specific tabs [p. 167]:
  - Info tab: location, elevation, timezone, fuel availability
  - Procedures tab: available approaches/departures/arrivals (forward-ref §7 for procedure operations)
  - **Weather tab (FIS-B): METAR/TAF data. GNX 375 has built-in dual-link ADS-B In receiver — no external hardware required. Contrast with GPS 175 (no ADS-B In).**
  - Chart tab: SafeTaxi diagram if available
- VOR page: frequency, class, elevation, ATIS
- NDB page: frequency, class
- User Waypoint page [p. 168]: Edit, View List, Delete functions (forward-ref §9)
- FastFind Predictive Waypoint Entry [p. 169]: keyboard entry with predictive matching (FastFind is a Garmin-specific term per Fragment A Appendix B.3)
- Search Tabs [pp. 170–171]: Airport, Intersection, VOR, NDB, User Waypoint, Search by Name, Search by Facility Name
- USER tab: lists up to 1,000 user waypoints [p. 171]
- AMAPI notes block: Nav_get, Nav_get_nearest → §10; Txt_add/Txt_set → §7
- **Open questions / flags:**
  - Airport Weather tab behavior when no FIS-B ground station uplink is available: spec must document degraded-data presentation (e.g., no data, stale data with age indicator, or suppressed display).

### Phase I: Author §4.6 Nearest Pages (~60 lines)

Expand outline §4.6 into prose:
- Scope paragraph (note: identical across all three units per harvest map [FULL])
- Access: Home > Nearest; select waypoint/frequency icon
- Nearest Airports: up to 25 airports within 200 nm; identifier, distance, bearing, runway info
- Nearest NDB, VOR, Intersection, VRP: identifier, distance, bearing, frequency
- Nearest ARTCC [p. 180]: facility name, distance, bearing, frequency
- Nearest FSS [p. 180]: facility name, distance, bearing, frequency; "RX" = receive-only
- Runway criteria filter: applies airport runway criteria settings (surface, minimum length) (forward-ref §10 for filter configuration)
- AMAPI notes block: Nav_get_nearest, Nav_calc_distance, Nav_calc_bearing → §10
- No open questions (content is clean per outline)

### Phase J: Author Coupling Summary

Write the Coupling Summary block per the template above under §"Coupling Summary block". Backward-refs enumerate the Fragment A sub-sections referenced; forward-refs enumerate the later-fragment targets.

### Phase K: Self-review

Before writing the completion report, perform the following self-checks (per D-08 — completion report claim verification):

1. **Line count:** `wc -l docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — report actual count. Target: ~720 ± 10% (~650–800 acceptable).
2. **Character encoding:** `grep -c '\\u[0-9a-f]\{4\}' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — expect 0.
3. **Replacement chars:** Python check (saved `.py` file per D-08) to count U+FFFD bytes — expect 0.
4. **B4 Gap 1 preserved as unresolved:** `grep -n 'B4 Gap 1\|Map rendering architecture\|canvas vs\.' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — expect matches in §4.2 flagging the gap as "design decision deferred" or similar; no sentences committing to a specific rendering approach.
5. **B4 Gap 2 preserved as unresolved:** `grep -n 'B4 Gap 2\|scrollable list' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — expect matches in §4.3 flagging as design-phase decision.
6. **OPEN QUESTION 1 preserved:** `grep -ni 'altitude constraint\|OPEN QUESTION 1\|VCALC' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — expect matches in §4.3 preserving the altitude-constraint unknown.
7. **XPDR icon GNX 375-only framing:** `grep -n 'XPDR' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — matches should appear in §4.1 with "GNX 375 only" or equivalent framing; zero matches that describe XPDR-panel internals (those live in §11).
8. **GPS NAV Status indicator key framing:** `grep -n 'GPS NAV Status' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — matches must be in §4.3 with "GNX 375 / GPS 175 only" or equivalent framing noting GNC 355 exclusion.
9. **Flight Plan User Field omission:** `grep -ni 'Flight Plan User Field' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — matches must be in §4.3 noting the field is NOT on GNX 375 (GNC 355/355A only); no prose documenting the field's behavior.
10. **FIS-B built-in receiver framing (§4.5):** `grep -ni 'FIS-B\|built-in\|built in' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — §4.5 Airport Weather tab must frame FIS-B as "built-in on GNX 375, no external hardware required."
11. **No COM present-tense on GNX 375:** `grep -ni 'COM radio\|COM standby\|COM volume\|COM frequency\|COM monitoring' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — any matches must be in "the GNC 355 has X" sibling-unit comparison context, never "the GNX 375 has X." Zero matches in §4.1 Home-icon enumeration (no COM app icon).
12. **Default Map user fields per-unit table present (§4.2):** `grep -n 'default' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — expect matches in §4.2 distinguishing GNX 375/GPS 175 defaults from GNC 355/355A defaults.
13. **Land-data-symbols supplement reference (§4.2):** `grep -n 'land-data-symbols\|assets/gnc355_reference' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — expect match in §4.2 Land Data Symbols block.
14. **Outline page references preserved:** sample 5 outline page citations (e.g., `[pp. 113–139]` in §4.2, `[p. 158]` in §4.3 GPS NAV Status indicator key, `[p. 125]` in §4.2 Land Data Symbols, `[pp. 159–164]` in §4.4, `[pp. 179–180]` in §4.6) — confirm each appears in the fragment at the appropriate section/sub-section.
15. **Fragment file conventions:** YAML front-matter present with Created/Source/Fragment/Covers; fragment header `# GNX 375 Functional Spec V1 — Fragment B`; top-level `## 4. Display Pages`; sub-sections use `###`; no harvest-category markers in spec-body headings.
16. **Coupling Summary section present with backward-refs and forward-refs enumerated:** visual check.
17. **§4 parent scope authored exactly once:** `grep -c '^## 4\. Display Pages' docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` — expect 1.

Report all 17 check results in the completion report.

---

## Completion Protocol

1. Write completion report to `docs/tasks/c22_b_completion.md` with this structure:

   ```markdown
   ---
   Created: {ISO 8601 timestamp}
   Source: docs/tasks/c22_b_prompt.md
   ---

   # C2.2-B Completion Report — GNX 375 Functional Spec V1 Fragment B

   **Task ID:** GNX375-SPEC-C22-B
   **Output:** `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md`
   **Completed:** 2026-04-22

   ## Pre-flight Verification Results
   {table of the 6 pre-flight checks with PASS/FAIL}

   ## Phase 0 Audit Results
   {summary of actionable requirements confirmed covered; include open-question preservation checklist}

   ## Fragment Summary Metrics
   | Metric | Value |
   |--------|-------|
   | Fragment file | `docs/specs/fragments/GNX375_Functional_Spec_V1_part_B.md` |
   | Line count | {actual} |
   | Target line count | ~720 |
   | Sections covered | §4 parent + §§4.1–4.6 |
   | Sub-section count | 6 (4.1, 4.2, 4.3, 4.4, 4.5, 4.6) |

   ## Self-Review Results (Phase K)
   {table of the 17 self-checks with PASS/FAIL and specifics}

   ## Hard-Constraint Verification
   {confirm each of the 11 framing commitments}

   ## Coupling Summary Preview
   {brief summary of backward-refs to Fragment A and forward-refs to Fragments C–G}

   ## Deviations from Prompt
   {table of any deviations with rationale; if none, state "None"}
   ```

2. `git add -A`

3. `git commit` with the D-04 trailer format. Write the commit message to a temp file via `[System.IO.File]::WriteAllText()` (BOM-free):

   ```
   GNX375-SPEC-C22-B: author fragment B (§§4.1–4.6 display pages)

   Second of 7 piecewise fragments per D-18. Covers GNX 375 Home,
   Map, FPL, Direct-to, Waypoint Info, and Nearest display pages.
   Target: ~720 lines; actual: {N}.

   Framing commitments honored: B4 Gap 1 (Map rendering architecture)
   preserved as unresolved design-phase decision; B4 Gap 2
   (scrollable list) preserved as unresolved; OPEN QUESTION 1
   (altitude constraints) preserved; XPDR app icon framed as GNX
   375-only; GPS NAV Status indicator key framed as GNX 375 / GPS
   175 only; Flight Plan User Field omission noted; FIS-B built-in
   receiver framing for Airport Weather tab. No COM present-tense
   content on GNX 375.

   Task-Id: GNX375-SPEC-C22-B
   Authored-By-Instance: cc
   Refs: D-18, D-19, GNX375-SPEC-C22-A
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

   PowerShell pattern (mandatory — do not use inline `python -c`):
   ```powershell
   $msg = @'
   ...message above with actual {N} values substituted...
   '@
   [System.IO.File]::WriteAllText((Join-Path $PWD ".git\COMMIT_EDITMSG_cc"), $msg)
   git commit -F .git\COMMIT_EDITMSG_cc
   Remove-Item .git\COMMIT_EDITMSG_cc
   ```

4. **Flag refresh check:** This task does NOT modify `CLAUDE.md`, `claude-project-instructions.md`, `claude-conventions.md`, `cc_safety_discipline.md`, or `claude-memory-edits.md`. Do NOT create refresh flags.

5. **Send completion notification:**
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "GNX375-SPEC-C22-B completed [flight-sim]"
   ```

6. **Do NOT git push.** Steve pushes manually.

---

## What CD will do with this report

After CC completes:

1. CD runs check-completions Phase 1: reads the prompt + completion report, cross-references claims against the fragment file, generates a compliance prompt modeled on the C2.2-A approach. The compliance prompt will verify the 17 self-checks plus additional items CD identifies from reading the fragment directly (sampled page-reference validation, Fragment A cross-reference consistency check, B4 Gap 1 / B4 Gap 2 / OPEN QUESTION 1 preservation verification).

2. After CC runs the compliance prompt: CD runs check-compliance Phase 2. PASS → archive all four files (prompt, completion, compliance_prompt, compliance) to `docs/tasks/completed/`; update manifest to flip Fragment B status to ✅ Archived; begin drafting C2.2-C task prompt. PASS WITH NOTES → log ITM if needed, archive, continue. FAIL → bug-fix task.

---

## Estimated duration

- CC wall-clock: ~90–120 min (reading sources including full Fragment A + authoring ~720 lines of structured prose with 8 tables + self-review + commit)
- CD coordination cost after this: ~1 check-completions turn + ~1 check-compliance turn + ~0.5 turn to update manifest and start C2.2-C prompt

Proceed when ready.
