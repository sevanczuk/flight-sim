# D-26 — CD must verify against ground-truth source documents, not derived artifacts

**Created:** 2026-04-30T17:46:00-04:00
**Source:** CD Purple session — Turn 38; consolidating a recurring violation pattern observed across Turns 22–37 of the page-map / extraction-comparison conversation
**Status:** Adopted
**Supersedes:** None (extends D-25)
**Decision class:** Convention / process refinement

---

## Decision

When two derived artifacts disagree about a fact, CD's job is to consult the **ground-truth source** — the PDF itself, the schema specification, the API documentation, the actual source file — rather than picking which derived artifact "feels canonical." This applies whenever the derived artifacts are LlamaParse extractions (consult the source PDF), schema instances (consult the schema spec), API client outputs (consult the API documentation), or any analogous setup.

**Tripwire:** when CD finds itself reasoning "artifact X is correct because it ran first" or "artifact Y is correct because it's currently treated as canonical" or "the API surely supports / surely doesn't support feature Z," that's the cue to consult the ground-truth source instead.

This extends D-25 ("CD must verify external API claims before asserting them"). D-25 covered claims; D-26 covers conflicts between derived artifacts where the resolution is the source document.

---

## Context — three failures across the GNX 375 page-map debugging arc

### Failure 1 — Turn 27: which extraction was correct

The old `gnc355_pdf_extracted/llamaparse_agentic_v1/` had 330 pages. The new `gnx375_llama_extract/` had 310 pages. CD's reasoning: "old must be correct because ITM-11 references it; the v2 SDK must be compressing blank/sparse pages." Wrong. Steve later examined the source PDF in Adobe Acrobat and found 310 pages — making the new extraction correct and the old one defective by 20 phantom pages. CD hadn't checked the source PDF.

### Failure 2 — Turn 28: API capability claim

CD asserted "no documented v2 parameter to preserve blank pages exists; the page-merging is emergent SDK behavior." Wrong. Steve found `bbox_top` / `bbox_bottom` (v1) on a blog post; subsequent doc review revealed the v2 equivalent `crop_box` plus the *separately-relevant* `output_options.extract_printed_page_number` — which directly addresses the actual problem (preserving printed page numbers, not page count). CD hadn't read the v2 API docs thoroughly.

### Failure 3 — Turn 35: claim that JSON had no page numbers

CD asserted the new extraction's `raw_json_result.json` "has no page numbers anywhere." Wrong. Steve pointed out that each `markdown_pages[]` entry has a `"page": n` field. CD had read a sample, identified that footer text (Garmin logical page identifier) was missing, and conflated that with "no page numbers" — without distinguishing physical PDF page from Garmin logical page.

In each case, the answer was already in a ground-truth document (source PDF, official API docs, the JSON sample) and CD had jumped to a conclusion from incomplete inspection.

---

## Convention

**Ground-truth verification rule:**

When CD is about to assert any of:

- "Artifact X is correct"
- "Artifact Y is wrong"
- "API Z does/doesn't support feature F"
- "Field K is present/absent in data D"
- "The right approach is [option] because [other option] doesn't work"

CD must first identify the **authoritative source** for the claim and consult it directly:

| Claim type | Authoritative source |
|------------|----------------------|
| Two extractions disagree about page count | The source PDF (page count via Acrobat or pypdf, not via either extraction) |
| Two parses produce different markdown | The source document |
| Two API clients produce different responses | The API's official documentation, ideally a specific docs URL |
| Two consumers of a schema disagree | The schema specification |
| Field is/isn't present in JSON | The full JSON file (or representative sample), not a memory of having read part of it |
| API option does/doesn't exist | The current docs (preferring v2/latest pages over blog posts that may be v1-era) |

If the authoritative source is unavailable to CD directly, CD requests it from Steve or dispatches a CC task to read it — never substitutes an inference from prior context.

---

## Tripwire phrases that should trigger this convention

CD should be alert to phrases in its own reasoning that indicate it's about to violate D-26:

- "X must be correct because…" (without naming the source check that confirmed it)
- "I checked some boundary cases and the rest are probably…"
- "The docs probably say…"
- "I don't recall seeing that field…"
- "That's likely a v1 feature that v2 dropped…"
- "It's been my impression that…"

Any of these in CD's draft response is a cue to stop, consult the source, and re-author.

---

## What changes operationally

1. **PDF / extraction work:** CD reads source PDF page count via direct check (Acrobat or pypdf) before claiming which extraction is correct.
2. **API integration work:** CD reads the current authoritative API docs (`https://developers.llamaindex.ai/llamaparse/parse/guides/configuring-parse/` for LlamaParse v2; analogous canonical docs URLs for other APIs) before claiming options exist or don't.
3. **Inspection of structured data (JSON, YAML, etc.):** CD reads enough of the file to support its claim — not "I read the first sample and concluded X." Specifically, when claiming a field is absent, CD verifies via a structural check (grep, schema validation, full read) before asserting.
4. **Conflicting derived artifacts:** CD never picks a winner based on which artifact is currently treated as canonical. It traces both back to the source.

---

## Cross-references

- D-25 — CD must verify external API claims before asserting them. Antecedent of D-26; D-26 is the broader convention applying to any conflict-between-derived-artifacts situation, not just API claims.
- ITM-11 — page-number offset issue; the conversation arc that surfaced D-26.
- ITM-13 — BOM-in-commit-subject defect; unrelated technical issue tracked separately.

---

## Verification

Future CD turns where source-of-truth verification is a possible tripwire should end with the same decision-log footer noting "verified against source-of-truth at [URL/path]" or "no ground-truth check required this turn."
