# LlamaParse Agentic Re-extraction Report

**Task ID:** PDF-REEXTRACT-LLAMAPARSE-V1
**Authorizing decision:** D-22 §(1)
**Completed:** 2026-04-24T10:31:37-0400

## Run Summary

- Source PDF: `assets/Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf`
- Output directory: `assets/gnc355_pdf_extracted/llamaparse_agentic_v1`
- Credential source: `C:/PhotoData/config/api_keys.json[llamaparse] (value not logged)`
- Parse mode: `parse_page_with_agent` (v2 `agentic` tier equivalent)
- Result type: `markdown`
- Pages extracted: 330
- Elapsed: 148.7s (2.5 min)
- llama-parse SDK version: 0.6.94

## Outputs

- Per-page markdown: `pages/page_001.md` through `pages/page_330.md`
- Aggregated markdown: `full_markdown.md`
- Extraction metadata: `extraction_log.json`

## Next Steps

C3 spec review agents (when drafted per D-22 §(2)) should reference this
extraction as the source-of-truth PDF content, in preference to the
original `assets/gnc355_pdf_extracted/text_by_page.json`.

The original extraction is preserved for archival compliance reference
(Fragment A–G compliance reports were bound to the original; do not
re-compliance-check archived fragments against this new extraction).

Known ITMs this extraction may help resolve or confirm:
- ITM-10: Fragment C §4.10 Unit Selections vs. PDF p. 94 — re-verify p. 94 here.
