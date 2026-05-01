# Briefing: LlamaParse-Extract V3.3 Upgrade — Add Page-Number Metadata + Image Outputs as Defaults

**Audience:** New CD session opened in the `commons-project/commons` workspace
**Authored by:** flight-sim CD Purple Turn 38, 2026-04-30T17:44:03-04:00 ET
**Source:** `docs/handoffs/llamaparse_extract_v3.3_upgrade_briefing.md` (in flight-sim repo) — copied into the commons project's CD session as the working briefing
**Type:** CD-direct work — no CC task needed. The commons-project CD instance does the script update directly using its filesystem access.

---

## TL;DR

The `commons-project/commons/llamaparse-extract/llamaparse_extract.py` CLI tool needs a V3.2 → V3.3 upgrade to add LlamaParse v2's `extract_printed_page_number` option (plus a few related output-shape options) as default-on parameters with CLI overrides. The motivating use case is a flight-sim project re-extraction of a Garmin avionics PDF where the v2 SDK's default extraction dropped per-page printed page numbers, blocking the project's page-map rebuild.

The work is small (~50 lines of script changes plus smoke tests), but **it must begin with a deeper read of the LlamaParse v2 API docs** to identify all useful options the current V3.2 may be missing — not just the ones triggered by this specific use case. This briefing explicitly opens that scope.

---

## Background

### What flight-sim is doing

The flight-sim project is producing a Functional Spec V1 for a Garmin GNX 375 GPS instrument. Its source PDF is the Garmin GNC 375 / GPS 175 / GNC 355 / GNX 375 Pilot's Guide (`190-02488-01_c.pdf`, 310 pages).

A LlamaParse extraction of that PDF lives at `flight-sim/assets/gnx375_llama_extract/`. It was produced earlier this month using `llamaparse_extract.py` V3.x with these options (per `extraction_log.json`):

```json
{
  "tier": "agentic",
  "version": "latest",
  "elapsed_seconds": 600.4,
  "credits": 3100
}
```

### Why a re-extraction is needed

The current extraction is content-complete (310 pages = source PDF page count) but lacks the **printed page numbers** — Garmin's logical page identifiers like `2-42`, `3-15`, `i`, `ii` that appear in the page footers. The body content per page is preserved as markdown in `pages/page_NNN.md`, but the footer text (which carries the printed page number) was dropped during extraction.

Why does flight-sim need the printed page numbers? The Functional Spec V1's body cites pages using Garmin's logical identifiers (e.g., `[p. 78]` means Garmin logical page 78, which is some specific physical page in the source PDF). To validate those citations against the extraction, flight-sim needs a **page_number_map.json** that maps physical PDF page → Garmin logical page identifier. The script that builds the map (`flight-sim/scripts/build_page_number_map.py`) currently parses the footer text from per-page markdown — but the new extraction has no footer text to parse.

### What v2 of LlamaParse offers that fixes this

LlamaParse v2 has a dedicated parameter `output_options.extract_printed_page_number` (singular). When enabled, LlamaParse extracts the printed page number from each page and returns it on per-page metadata (retrieved via `expand=["metadata"]`). This is the authoritative LlamaParse-side answer to "give us the Garmin logical page number," and is the mechanism flight-sim wants to use going forward.

The current V3.2 of `llamaparse_extract.py` does not (as far as flight-sim's CD knows) expose this option. The upgrade adds it.

---

## Scope of the V3.3 upgrade

This is the canonical scope. Adjust if your deeper API doc review surfaces additional must-have options.

### New default-on options (with CLI overrides to disable)

| Option (LlamaParse v2 API path) | Default | CLI override flag |
|---|---|---|
| `output_options.extract_printed_page_number` | **on** | `--no-extract-page-number` |
| `output_options.markdown.merge_continued_tables` | **on** | `--no-merge-continued-tables` |

**Rationale for `extract_printed_page_number=on`:** Direct fix for the flight-sim page-map problem. There's no obvious downside to having it enabled — it just adds metadata to each page. If a future user genuinely doesn't want the metadata (rare), they pass `--no-extract-page-number`.

**Rationale for `merge_continued_tables=on`:** The Garmin manual has multi-page tables (e.g., flight-plan messages, advisory references). Merging continuation makes them parse-friendly for downstream consumers. Default is unclear from docs — explicit `true` is safer.

### New CLI-controlled options (default values, overridable)

| Option (LlamaParse v2 API path) | Default | CLI flag |
|---|---|---|
| `output_options.images_to_save` | `["screenshot", "embedded", "layout"]` | `--images-to-save` (comma-separated) |
| `output_options.markdown.annotate_links` | **on** | `--no-annotate-links` |
| `processing_options.specialized_chart_parsing` | unset (off) | `--specialized-chart-parsing` (enum: `efficient` / `agentic` / `agentic_plus`) |
| `agentic_options.custom_prompt` | unset (none) | `--custom-prompt` (string) |
| `disable_cache` | **off (`false`)** | `--disable-cache` (flag, sets to true) |

**Rationale for `disable_cache=off` as default:** Per LlamaParse v2 docs, the cache lasts about 48 hours and any change to parse options auto-busts it. Keeping cache enabled by default lets users re-download recent results without spending credits again. Opt-in to `--disable-cache` when intentionally bypassing (e.g., benchmarking, version-pin verification).

**Rationale for `images_to_save` defaults:** All three image classes are useful for downstream agents — `screenshot` for visual inspection, `embedded` for diagram extraction, `layout` for spatial reasoning. Default to all three; override via `--images-to-save screenshot` etc. for cost-sensitive single-class runs.

**Rationale for `specialized_chart_parsing` default-off:** Adds real cost (especially `agentic_plus`); only worth enabling on chart-heavy documents. Document it as a CLI option for users who need it.

### Existing behavior (unchanged)

- `tier` selection (fast / cost_effective / agentic / agentic_plus)
- `version` (default "latest" or pinnable)
- Output-directory layout (`pages/`, `images_layout/`, `images_screenshot/`, `extraction_log.json`, `full_markdown.md`, `raw_json_result.json`, `structured_items.json`)
- Phase-1 validation
- Batch CLI-arg-per-line syntax
- Compiler-style errors

### Expected output structure changes

Per LlamaParse v2 docs, the printed page number arrives via `expand=["metadata"]` on the GET result endpoint. The script must:

1. Add `"metadata"` to the SDK's `expand` parameter (or whatever the SDK calls it) when `extract_printed_page_number` is enabled.
2. Persist the metadata in `raw_json_result.json` (it should be there automatically when the SDK returns it).
3. Optionally also persist a tighter file `page_metadata.json` mapping `{page_number: {"printed_page_number": "..."}}` for direct downstream consumption.

Whether `page_metadata.json` is added is your call — flight-sim doesn't strictly need it (the `raw_json_result.json` is enough; flight-sim can write a small reader). But if it adds clarity for other downstream users, include it.

---

## What flight-sim wants out of this upgrade

Two deliverables back to flight-sim:

### Deliverable 1 — V3.3 of the script, committed and pushed

Standard upgrade work. Commit message uses the commons project's existing trailer convention (whatever that is — V3.x history will tell you).

### Deliverable 2 — Ready-to-run command line for the GNX 375 re-extraction

The flight-sim CD session will receive the command and execute it on the flight-sim machine. The command should be a single invocation of V3.3's CLI, with all options needed for the GNX 375 re-extraction, ready to paste into a Windows PowerShell session.

**Inputs the command will need:**

- Source PDF path: `C:\Users\artroom\projects\flight-sim-project\flight-sim\assets\Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf`
- Output directory: a NEW directory (do not clobber existing). Suggested: `C:\Users\artroom\projects\flight-sim-project\flight-sim\assets\gnx375_llama_extract_v2\` — flight-sim CD will rename to canonical after verification.
- Tier: `agentic`
- All V3.3 default options engaged (which now include `extract_printed_page_number`)
- The optional CLI options I previously flagged as worth-including-by-default-for-this-run: `merge_continued_tables` (already default-on in V3.3), `annotate_links` (already default-on in V3.3), `images_to_save=screenshot,embedded,layout` (already default in V3.3)

**Probably NOT in the command (for this run):**

- `--specialized-chart-parsing` — the Pilot's Guide has a few diagrams but most are screenshots of UI; agentic_plus chart parsing isn't worth the cost increment for this document
- `--custom-prompt` — the standard agentic tier behavior on a Garmin manual is fine; no special steering needed
- `--disable-cache` — leave default off to allow re-download

Provide the command in two forms:
- A clean single-line PowerShell-compatible version
- A multi-line readable version with backtick continuations for documentation purposes

---

## Pre-work the new CD session should do BEFORE editing the script

This is the most important part of the briefing.

The current V3.2 of the script was authored against an earlier state of LlamaParse v2's documented options. A focused review of the LlamaParse v2 API docs is required before the V3.3 work begins, to ensure no other useful options are missed in the upgrade.

**Documentation pages worth reviewing (in priority order):**

1. **`https://developers.llamaindex.ai/llamaparse/parse/guides/configuring-parse/`** — top-level Configuring Parse guide. Covers all v2 option groups (input_options / output_options / processing_options / agentic_options / page_ranges / crop_box / processing_control). The "Where do I configure X?" table on this page is gold.
2. **`https://developers.llamaindex.ai/typescript/cloud/llamaparse/output_options/spatial_text/`** — spatial text options. We are NOT enabling these for the GNX 375 re-extraction (flight-sim CD evaluated and rejected `preserve_very_small_text` for that use case — not relevant to standard-size footer text), but the V3.3 script should expose them as CLI options for users who need them.
3. **`https://developers.llamaindex.ai/typescript/cloud/llamaparse/output_options/extract_printed_page_numbers/`** — the dedicated docs page for extract_printed_page_number. Read this carefully — confirm option spelling (singular vs plural), required `expand` value, where the result lives in the response.
4. **`https://developers.llamaindex.ai/llamaparse/parse/guides/migration-v1-to-v2/`** — v1-to-v2 migration guide. May surface options the current V3.2 still uses in v1 form that should be moved to v2 form. (Not flight-sim's primary need but worth a sanity check.)
5. **`https://developers.llamaindex.ai/reference/resources/parsing/methods/create`** — full field-by-field API reference. The authoritative source.

**Question to answer during the doc review:**

- Are there any v2 options the V3.2 script doesn't expose that **should** be CLI-overridable for general use?
- Are there v2 options that V3.2 exposes but in their v1 form (i.e., flat parameter rather than structured config object)?
- Is `output_options.extract_printed_page_number` the correct option spelling, or has it been renamed in newer docs?
- Does the option require a corresponding `expand=["metadata"]` parameter on the GET result endpoint, and does the SDK handle this transparently or does the script need to set it explicitly?
- Is there a `printed_page_number` field on the per-page metadata object, or some other field name?

**The result of this review feeds the V3.3 scope.** Add anything that's clearly worth having; defer or document anything ambiguous.

---

## Cache-invalidation note

LlamaParse caches identical requests for ~48 hours. Per the docs: Any change to parse options busts the cache automatically.

The flight-sim re-extraction will use new options (`extract_printed_page_number`, etc.) that the prior run didn't, so cache invalidation will occur naturally. Do NOT pass `--disable-cache` for the re-extraction — let the option-based bust happen, which preserves cache for the next 48 hours of the new options.

---

## Smoke test additions for V3.3

The V3.2 has 90 smoke tests. Add tests for:

- `--no-extract-page-number` flag parses correctly and disables the option
- Default behavior includes `extract_printed_page_number=true` in the API request payload
- `--images-to-save screenshot,embedded` accepts comma-separated values
- `--images-to-save invalid_class` produces a compiler-style error
- `--no-merge-continued-tables` flag parses and disables the option
- `--specialized-chart-parsing agentic_plus` parses correctly
- `--specialized-chart-parsing invalid_value` produces a compiler-style error
- `--custom-prompt "test prompt"` parses correctly
- `--disable-cache` flag parses and sets `disable_cache=true`
- Default behavior leaves `disable_cache=false`

That's ~10 new tests, bringing the suite to ~100. Run the full suite (existing 90 + new 10) and document any pre-existing failures separately from V3.3-introduced failures.

---

## Versioning and release notes

- Bump version string to `3.3` (or `3.3.0` per commons-project convention)
- Update the file's docstring with V3.3 release notes
- Document each new option in the docstring + CLI help text + any commons-project-level changelog

---

## What flight-sim is doing in parallel (FYI; no action needed from commons-side)

Flight-sim is mid-effort on a directory-retirement / dependency-audit cleanup. The previous PDF extraction directory `assets/gnc355_pdf_extracted/` (which had a defective 330-page extraction with 20 phantom pages) is being retired to `assets/retired/gnc355_pdf_extracted/`. The new GNX 375 re-extraction lands in `assets/gnx375_llama_extract_v2/` (a NEW directory — does not clobber the existing `gnx375_llama_extract/`). Once the new extraction is verified, flight-sim CD will rename to whatever canonical path it picks (likely `assets/gnx375_llama_extract/` after retiring the existing one to `assets/retired/`).

This is flight-sim-side housekeeping and doesn't constrain the commons-project work.

---

## Hand-off pattern

When V3.3 is committed and pushed:

1. The commons-project CD session writes a short completion report (or just a chat-side summary, your call): version bumped to 3.3, new options listed, smoke tests passing, ready-to-run command for the re-extraction.
2. Steve runs `git pull` on the flight-sim machine to pick up the V3.3 update in the commons workspace.
3. Steve runs the provided command on the flight-sim machine, producing `assets/gnx375_llama_extract_v2/`.
4. Steve sends the new run's `extraction_log.json` and a sample `pages/page_080.md` (or similar) back to the flight-sim CD session for verification.
5. Flight-sim CD verifies the new extraction has `printed_page_number` metadata and, if so, proceeds to the page-map rebuild and the dependency audit.

---

## Summary of decisions baked in (for traceability)

- New defaults: `extract_printed_page_number=true`, `merge_continued_tables=true`, `annotate_links=true`, `images_to_save=["screenshot","embedded","layout"]`
- `disable_cache` default = `false` (cache enabled)
- `preserve_very_small_text` not enabled for GNX 375 (CAD-specific feature; not relevant to standard footer text)
- `specialized_chart_parsing` and `custom_prompt` are CLI-only with no defaults
- Re-extraction goes to a NEW directory (`gnx375_llama_extract_v2/`), not over the existing one
- Pre-extraction doc review is REQUIRED before script edits begin

If the doc review surfaces a strong reason to deviate from any of the above defaults, do so and document the rationale in the V3.3 release notes.

---

End of briefing.
