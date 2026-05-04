# Briefing: PDF Image Extraction for Instrument GUI

**Created:** 2026-04-24T10:51:26-04:00
**Source:** CD Purple Turn 19–20 — follow-up to D-22 §(1) LlamaParse re-extraction (Turn 18 completed)
**Audience:** CD (Green/Yellow/Purple) + Steve; directly informs any CC task prompts drafted from this plan
**Status:** Active briefing; governs the next two image-extraction CC tasks

---

## Context

The initial LlamaParse Agentic-tier re-extraction (Turn 18, per D-22 §(1)) completed successfully for **text/markdown** content — 330 pages, 2.5 min wall-clock, major quality uplift on tables and cross-references confirmed. That part of the job is done.

The initial extraction **did not request image output**. That was a scope-framing oversight — the credit cost is per-page-per-tier, not per-output-type, so requesting images alongside markdown would have cost the same. The extraction is cached on LlamaParse's side for 48 hours (from 10:31 ET on 2026-04-24), so we still have a free re-parse window for the same file if we decide to re-run.

Meanwhile, the **original** `gnc355_pdf_extract.py` run (via PyMuPDF) extracted 521 embedded images into `assets/gnc355_pdf_extracted/images/`, saved as `page_NNNN_img_NN.bin` files. That data is present, local, and free. The files are opaque (`.bin` extension is a format-punt; names don't describe content) but the pixel data is there.

---

## Why images matter

Instrument GUI implementation (I1–I3 phase per Task flow plan) needs the visual language of the GNX 375:

- **Control elements** — XPDR key appearance, VFR key, squawk-code entry keys, Mode key states (SBY/ON/ALT), Reply (R) indicator, IDENT indicator
- **Annunciator bar rendering** — flight-phase annunciator slot, CDI scale slot, FROM/TO slot, color semantics (warning/caution/advisory)
- **Map and chart symbology** — land data symbols (railroad, highway, city icons per p. 125), airspace rendering, traffic symbols, terrain color bands, TFR patterns
- **Settings and status page layouts** — GPS Status page (EPU/HFOM/VFOM satellite graph), ADS-B Status page, Traffic Application Status sub-pages
- **Approach and procedure page rendering** — LPV glideslope diamond, VDI bar, procedure turn depiction, waypoint symbols on flight plan
- **Advisory pop-ups and alert visuals** — red/yellow/white color-coding, pop-up framing, MSG key flash state

Text descriptions in the spec enumerate *what* these elements are; only images show *what they look like*. Building the instrument without the artwork reference means guessing at proportions, colors, and visual hierarchy.

---

## Plan: Approach A first, Approach B as escalation

### Approach A — Catalog the existing 521 PyMuPDF-extracted images

**What it does:** takes the opaque `.bin` files we already have, detects actual image format per file via magic bytes, renames to proper extensions, produces a structured inventory keyed by PDF page + image-index-within-page, generates a browsable HTML gallery with per-image markdown context pulled from the new LlamaParse extraction, lets a human (Steve) or a downstream task curate the images they need for implementation.

**Cost:** free. Uses only data we already have. ~15–20 min CC wall-clock.

**Output (all gitignored per D-06 regenerable-output pattern):**
- `assets/gnc355_pdf_extracted/images_catalog/images/page_NNN_img_NN.<ext>` — renamed files with proper extensions
- `assets/gnc355_pdf_extracted/images_catalog/inventory.json` — full machine-readable index
- `assets/gnc355_pdf_extracted/images_catalog/gallery.html` — single-page HTML with all images inlined, context captions, and filter controls
- `assets/gnc355_pdf_extracted/images_catalog/effectiveness_report.md` — self-assessment against the failure criteria below

**Approach A is the right first step because:**
- Zero additional API cost
- Leverages extraction work already done
- Informs Approach B scope — if catalog is good enough for 90% of needs, we only pay LlamaParse for the remaining 10% worth of pages (with `target_pages`) rather than a full re-run
- Even if we end up doing Approach B anyway, the cataloged PyMuPDF images remain useful as a second reference source

### Approach B — Supplementary LlamaParse run with image output

**When:** if Approach A's effectiveness is below 100% per the criteria below, and the gaps block progress on UI work.

**What it does:** re-submits the same PDF to LlamaParse (or, if still within the 48-hour cache window, leverages the cached parse) with `output_options.images_to_save=["embedded"]` (embedded figures from the PDF) and/or `output_options.images_to_save=["screenshots"]` (full-page rasterizations). Retrieves image metadata via the v2 API's `expand=images_content_metadata` parameter and downloads via the presigned URLs returned.

**Cost consideration:**
- If run within 48h of the Turn 18 extraction (i.e., before ~10:31 ET on 2026-04-26): cache applies — **zero additional credits** for the parsing itself; only new output-retrieval costs, which are not per-page-tier billed
- If run after 48h: full ~3,300 credits again (Agentic tier at 10 credits/page × 330 pages)

**Output:**
- `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/images_embedded/` — embedded figure files with page linkage in filenames
- `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/images_screenshots/` (optional, if `screenshots` tier added) — per-page full rasterizations
- `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/images_metadata.json` — LlamaParse's structured image metadata

**Approach B considerations:**
- Agentic Plus tier would be required for bounding-box precision on visually complex pages; Agentic suffices for basic embedded image extraction
- If we decide on Approach B, the cache window strongly argues for doing it **soon** (before 48h elapses) to avoid paying a second round

---

## Effectiveness criteria for Approach A (the "when to escalate" rules)

Approach A's catalog is considered **100% effective** if and only if **all** of the following are true. CC's task prompt will produce an `effectiveness_report.md` that evaluates each criterion and reports PASS/FAIL with evidence.

### Hard criteria (any single FAIL triggers Approach B consideration)

**C1. Format detection success rate ≥ 99%.**
Of the 521 `.bin` files, at least 516 must be successfully identified as a known image format (PNG, JPEG, BMP, TIFF, JBIG2, JPEG 2000, or a PyMuPDF-supported stream format that can be transcoded to PNG). Magic-byte detection is the primary mechanism; format-failures (non-detectable streams, unknown types, truncated files) that exceed ~5 files indicate the underlying extraction is lossy in ways the catalog can't fix.

**C2. Presence of GNX 375 core UI artwork.**
Specific key pages must have non-trivial image content. Spot-check:

| Page (Garmin logical) | Required visual | PyMuPDF image file pattern | Why it matters |
|-----------------------|-----------------|----------------------------|----------------|
| p. 17–20 (physical ~19–22) | Unit family/feature overview graphic | `page_0018_img_*` through `page_0021_img_*` | Overview graphic for Fragment A §1 context |
| p. 75 (physical ~79) | XPDR Control Panel UI layout | `page_0079_img_*` or `page_0080_img_*` | §11.2 XPDR UI regions |
| p. 78 (physical ~82) | XPDR Modes menu visual | `page_0082_img_*` | §11.4 three-mode selection |
| p. 94 (physical ~98) | Unit Selections settings panel | `page_0098_img_*` | §4.10 / §10.6 settings page |
| p. 125 (physical ~129) | Land Data Symbols chart (railroad, river, city icons) | `page_0129_img_*` (4 images) | §4.7 map symbol language |
| p. 183 (physical ~187) | Annunciator bar + FROM/TO field | `page_0183_img_*` or `page_0184_img_*` | §12.2 annunciator rendering |

Each row must have at least one successfully cataloged image ≥ 10 KB. A row with only a trivial icon (< 2 KB — likely a sub-glyph fragment, not a full UI element) counts as a FAIL for that row.

**C3. Image-to-page alignment accurate.**
The `inventory.json` must correctly associate each image with its PDF page (the PyMuPDF filename convention `page_NNNN_img_NN` preserves this). Spot-check 10 random images by rendering them alongside the corresponding new-extraction markdown page in the gallery; all 10 must be contextually coherent (not offset, not mis-mapped).

### Soft criteria (FAIL on 2+ of these triggers Approach B consideration)

**S1. Sub-image fragmentation is manageable.**
PyMuPDF's extraction may break visually-unified elements into component parts (this is a known failure mode per the LlamaParse GitHub issue we saw during research — #374). If the XPDR Control Panel visual on p. 75 extracts as 20 separate sub-images rather than 1–2 cohesive ones, the catalog is less useful for UI reference. Gallery review spot-checks 5 UI-critical pages; 3+ pages showing severe fragmentation (>5 sub-images per coherent UI element) = FAIL.

**S2. Image context caption quality.**
For each cataloged image, the gallery must display the markdown context from the surrounding ±10 lines of the new LlamaParse extraction. If context captions are empty, irrelevant, or cut off for more than ~10% of images, the catalog is less navigable.

**S3. Full-page context not required.**
Some UI elements only make sense as part of a full-page screenshot (the CDI scale indicator is meaningless without the rest of the HSI). If ≥ 5 pages among the Required visuals list (C2) are cases where the embedded image doesn't capture the full page layout and a rasterized screenshot would be necessary, this is a FAIL for Approach A at those specific pages.

### Decision matrix

| C1 | C2 | C3 | S1 | S2 | S3 | Recommendation |
|----|----|----|----|----|----|----------------|
| PASS | PASS | PASS | PASS | PASS | PASS | **Approach A sufficient.** No Approach B escalation. |
| PASS | PASS | PASS | 1 FAIL among S1/S2/S3 | | | **Approach A sufficient.** Note the single soft FAIL as known limitation; revisit if UI work later blocks on it. |
| PASS | PASS | PASS | 2+ FAILs among S1/S2/S3 | | | **Consider Approach B.** CD drafts Approach B task; Steve decides based on current UI work needs. |
| Any hard FAIL (C1, C2, or C3) | | | | | | **Approach B required.** CD drafts task immediately; decide cache-window timing. |

---

## Approach B trigger protocol

If Approach A's `effectiveness_report.md` yields "Approach B required" or "Consider Approach B":

1. CD reviews the specific failing criteria and identifies which pages/images Approach A missed
2. CD decides whether the gaps warrant a full re-extraction or targeted `target_pages` retrieval
3. Check cache window: if < 48h since Turn 18's extraction (before ~2026-04-26T10:31 ET), the parse job is cached — image retrieval via `expand=images_content_metadata` costs zero parse credits, only output-handling cost
4. Draft Approach B CC task prompt with:
   - Target pages (if ≤ 100 pages, use `target_pages` parameter to reduce credit exposure on a post-cache re-run)
   - `output_options.images_to_save=["embedded"]` (primary)
   - Conditionally `output_options.images_to_save=["embedded", "screenshots"]` if S3 failed
   - Credential access per D-23 pattern
   - Output to `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/images_embedded/` and optionally `images_screenshots/`

---

## Non-obvious considerations

- **48-hour cache window.** Turn 18 extraction ran at 10:31 ET on 2026-04-24. Cache expires ~10:31 ET on 2026-04-26. If Approach A's report lands after the catalog is done (~15–20 min plus Steve's review time), and Approach B is needed, we have roughly 48 hours minus elapsed time before a potential second extraction would be billable. Acting sooner costs less.
- **Don't conflate "images" with "GUI reference artwork."** Some of the 521 PyMuPDF images are page decorations, section headers, or tiny icons that have no UI-implementation value. The catalog should tag or flag likely-substantive images (by size > 10 KB heuristic, by page-in-body-section heuristic) separately from trivial ones. Approach A's effectiveness criteria C2 enforces this on the critical pages.
- **Image licensing.** Garmin holds copyright on the Pilot's Guide; their artwork is not ours to redistribute in the Air Manager instrument. We use the extracted images **as reference for implementation** (to match visual language, proportions, color); the Air Manager instrument renders its own artwork inspired by but not copied from Garmin's. This applies regardless of which approach produces the reference artwork.
- **Original extraction `.bin` files are archival.** Do not delete them during Approach A cataloging. The catalog creates copies with proper extensions; the originals stay for audit / re-run reproducibility.
- **This briefing governs the next two CC tasks.** First CC task: execute Approach A. Second CC task (conditional on effectiveness report): execute Approach B with scoped parameters. CD drafts each prompt per the success criteria above; Steve launches.

---

## Lessons learned (for the retro log)

- **Scope framing error in D-22 §(1).** The re-extraction task was framed around a single consumer (C3 spec review) when multiple consumers (I1–I3 instrument GUI implementation, design-phase artwork reference) have legitimate needs from the same billable API call. When a task has API cost, CD should enumerate all plausible downstream consumers of the output before drafting.
- **LlamaParse output_options not surfaced.** CD's Turn 15 research surfaced tiers, pricing, parse_mode names, and deprecation — but not `output_options.images_to_save`. A more thorough SDK-option inventory at task-design time would have caught this.
- **CC followed the prompt literally — this is correct.** The fix is upstream at CD. A post-task review by CD (which would normally be compliance) could have caught it, but image absence wasn't in the self-check list for this scripted task — another oversight in prompt design.
- **Future rule:** for any billable API extraction, the task prompt must include an explicit "outputs considered and requested/excluded" section listing every output the API supports, with a rationale for each exclusion.

---

## Related

- `docs/decisions/D-22-c3-spec-review-customization-for-gnx375-functional-spec.md` §(1) — source-of-truth policy; Turn 19 amendment notes image follow-up
- `docs/decisions/D-23-credential-file-access-pattern-for-cc-scripts.md` — credential pattern for any Approach B task
- `docs/tasks/pdf_reextraction_llamaparse_completion.md` — Turn 18 text extraction completion
- `docs/todos/issue_index.md` §ITM-11 — page-number offset (relevant to image-page mapping in inventory)
- `assets/gnc355_pdf_extracted/images/` — source directory for Approach A (521 `.bin` files)
- `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/` — new extraction; surrounding markdown context source for Approach A captions
- LlamaParse v2 image output docs: https://developers.llamaindex.ai/python/cloud/llamaparse/output_options/embedded_images/
