# Retired Assets — Moved Out

**Created:** 2026-04-30T12:00:01-04:00
**Last updated:** 2026-05-04T08:52:27-04:00 — converted to forwarding pointer after move-out (AUDIT-RETIRED-MOVE-01)
**Source:** Originally CD Purple Turn 32, 2026-04-30 — recorded retirement of two `gnc355_*` directories per the D-12 GNX 375 pivot and the discovery that the older PDF extraction is defective.

## What this directory used to contain

`gnc355_pdf_extracted/` and `gnc355_reference/` — the pre-pivot PDF extraction outputs, related image catalogs, and Steve's manually curated p. 125 land-data-symbols PNG. All material related to the superseded GNC 355 (pre-pivot) workflow.

## Where the contents are now

Both subdirectories were moved to `C:\Users\artroom\projects\flight-sim-project\archive\` (a non-tracked sibling of this project) on 2026-05-04 as the final step of the dependency-audit cleanup chapter (DEPENDENCY-AUDIT-01 → AUDIT-CLEANUP-01 → AUDIT-PATCH-01 → AUDIT-RETIRED-MOVE-01).

- `archive/gnc355_pdf_extracted/` — the defective LlamaParse extraction, PyMuPDF-era image and JSON outputs, and historical extraction report
- `archive/gnc355_reference/` — the original curated reference directory (note: `land-data-symbols.png` was deleted entirely during AUDIT-CLEANUP-01 per Steve's directive — not preserved in archive)

## Active replacements

- Pre-pivot PDF extraction → `assets/gnx375_llama_extract/` (LlamaParse markdown body) + `assets/gnx375_pymupdf_v1_0_1/` (PyMuPDF metadata + page_number_map v2.0)
- `land-data-symbols.png` → no replacement; references removed from active V1 spec content per AUDIT-CLEANUP-01

## Why this README is preserved

This file remains as a forwarding pointer. References in `docs/tasks/completed/`, `docs/decisions/`, and `project-status/` describe historical work that touched paths under `assets/retired/`; readers following those references should land here and learn where the contents went.

Steve may delete this README and the `assets/retired/` directory at any time once it stops adding navigational value. No active work depends on it.

## Related

- `docs/decisions/D-12-*` — GNX 375 pivot rationale
- `docs/decisions/D-26-cd-verify-against-ground-truth-source-documents.md` — verify-against-ground-truth discipline; the defective-extraction discovery surfaced this principle
- `docs/decisions/D-30-v1-fragment-citations-use-physical-pdf-page-numbers.md` — V1 fragment citations use absolute physical PDF page numbers; closed ITM-11
- `docs/todos/issue_index_resolved.md` §ITM-11 — page-number offset misdiagnosis, closed 2026-05-02
- `docs/tasks/completed/dependency_audit_01_*` — audit that produced the patch + flag lists
- `docs/tasks/completed/audit_cleanup_01_*` — bookkeeping cleanup that archived completed task records, retired compliance scripts, fixed Side Finding #4, and deleted `land-data-symbols.png`
