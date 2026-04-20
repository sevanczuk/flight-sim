# D-02: GNC 355 prep-work scoping decisions

**Created:** 2026-04-19T17:45:10-04:00
**Source:** Purple Turns 8–10 — scoping dialogue for GNC 355 Air Manager plugin prep work
**Decision type:** scope / architecture / process

## Decisions

Ten scoping decisions for the three prep-work streams (AMAPI documentation, instrument sample analysis, GNC 355 functional spec). Documented here so they don't get lost in conversation.

### Stream A — AMAPI documentation

1. **Output format:** Markdown-per-function files + a structured JSON index. Canonical data in JSON, human-readable view in markdown. Location: `docs/reference/amapi/`.

2. **Crawl discovery:** Seed the crawl with the existing `assets/air_manager_api/air_manager_wiki_urls.txt`. Parse each fetched HTML page for additional internal wiki links and queue any that match the API-page title pattern whitelist (`Xpl_*`, `Msfs_*`, `Fs2020_*`, `Fs2024_*`, `Fsx_*`, `P3d_*`, `Hw_*`, `Si_*`, `Ext_*`, `Viewport_*`, `Canvas_*`, `Img_*`, `Txt_*`, `Mouse_*`, `Touch_*`, `Variable_*`, `Request_*`, and other discovered prefixes as they emerge). BFS from the seed list; expectation is one or two discovery waves yields a near-complete set.

3. **Fetch politeness:** 1-second rate limit minimum, single fetch thread, user agent from `assets/air_manager_api/user-agent.txt`. If discovery surfaces so many URLs that wall-clock fetch exceeds ~4 hours, pause and recommend a concurrent-fetch approach rather than proceeding blind.

4. **YouTube URLs:** 18 YouTube links in the seed file. Archive URL + title + description only. No transcription in this phase.

### Stream B — Instrument samples

5. **Renaming strategy:** Copy the 45 UUID-named directories to a working location with human-readable safe names derived from `info.xml` (`<aircraft>` + `<type>` + short UUID prefix for uniqueness). Originals in `assets/instrument-samples/` are never modified. `config.sqlite3` in that directory may reference the UUIDs — not our problem if we don't touch the originals.

6. **Analysis scope:** Select a diverse subset of 8–10 instruments covering different types (gauge, display, GPS-like, engine, navigation, etc.) for initial pattern catalog. Deepen selectively on instruments close to the GNC 355 in shape (touchscreen GPS/COM). Skepticism stance: vendor-generated sample code is illustrative, not authoritative. Patterns are candidates for adoption, not mandates.

### Stream C — GNC 355 functional spec

7. **PDF extraction approach:** pdfplumber for text extraction → CC review → Tesseract OCR as last-resort fallback for any gaps (math formulas, scanned diagrams, low-quality figures). Images extracted separately via pdfplumber/pypdf.

8. **Spec scope:** The implementation spec contains operational behavior only (screens, buttons, modes, pages, workflows). Pilot-technique material (VFR/IFR usage guidance, aeronautical decision making) is archived as a separate reference doc, not folded into the implementation spec.

9. **Family delta appendix:** The PDF (190-02488-01_c) covers four devices — GPS 175, GNC 355, GNC 375, GNX 375. The spec focuses on GNC 355 but includes a compact appendix noting where the 355 differs from the other three. Captures context cheaply while the material is fresh; useful if we later extend to sibling devices.

### Cross-cutting

10. **MSFS compatibility:** X-Plane-only for v1 of the plugin. MSFS support documented as a v2 goal but not designed-for in v1. AMAPI exposes distinct namespaces (`Xpl_*`, `Msfs_*`, `Fs2020_*`, `Fs2024_*`) so retrofitting is feasible without rewrite.

11. **Abstraction-layer decision:** Deferred. Decision gates on both Stream A (AMAPI surface understood) and Stream B (sample patterns catalogued) producing drafts. Both inform the decision.

12. **Repo locations:**
    - AMAPI parsed reference → `docs/reference/amapi/`
    - Instrument pattern catalog → `docs/knowledge/instrument_patterns.md`
    - Instrument samples index (UUID → safe name mapping) → `docs/knowledge/instrument_samples_index.md`
    - GNC 355 operational spec → `docs/specs/GNC355_Functional_Spec_V1.md`
    - GNC 355 pilot-technique archive → `docs/reference/GNC355_Pilot_Guide_Reference.md`
    - Raw crawl output (HTML) → stays in `assets/air_manager_api/wiki.siminnovations.com/`
    - Working copies of samples with safe names → `assets/instrument-samples-named/` (new directory, originals untouched)

13. **Implementation plan:** Captured as a markdown document at `docs/specs/GNC355_Prep_Implementation_Plan_V1.md`. Plan is not run through `/spec-review`; individual specs and task prompts it generates will be reviewed.

## Context

First active workstream under D-01. The prep work (A/B/C streams) is a gate before any actual GNC 355 plugin implementation begins. Rationale: we don't yet know the AMAPI surface well enough to design cleanly, the sample corpus is unexamined, and the Pilot's Guide content hasn't been extracted into a spec. Attempting plugin code without these assets would be guesswork.

## Consequences

- Three parallel CC task prompts to author next: Stream A (crawl), Stream B (rename + patterns), Stream C (PDF extract + draft spec).
- The abstraction-layer question stays open until Streams A and B draft.
- Implementation plan captures sequencing, dependencies, and per-stream tasks.
- `docs/reference/amapi/` and `docs/knowledge/` directories will be created when Streams A and B run.

## Related

- D-01 (project scope)
- `assets/air_manager_api/` — Stream A inputs
- `assets/instrument-samples/` — Stream B inputs
- `assets/Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf` — Stream C input
