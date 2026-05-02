# D-30 — V1 fragment citations use absolute physical PDF page numbering

**Created:** 2026-05-02T10:41:21-04:00
**Source:** CD Purple session — Turn 14; verification of ITM-11 anchor citations against the LlamaParse body extraction surfaced this finding generically
**Status:** Adopted
**Supersedes:** None (clarifies an unwritten convention)
**Decision class:** Convention / data-format clarification

---

## Decision

GNX 375 V1 functional spec fragments (`docs/specs/fragments/GNX375_Functional_Spec_V1_part_*.md`) cite **absolute physical page numbers of the combined Pilot's Guide PDF** (`assets/Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf`). Citations of the form `[p. N]`, `[pp. N–M]`, or `[pp. N, M, K]` resolve directly to physical pages 1–310 of that PDF — the same numbering used by `assets/gnx375_llama_extract/pages/page_NNN.md` body files and by `assets/gnx375_pymupdf_v1_0_1/page_metadata.json` physical-page keys.

**Zero offset.** No translation step is needed between a V1 citation and the corresponding extraction page.

This convention is now the documented standard for V1 spec citations. Any future spec authoring (V2, design specs, supplements) that wishes to cite a different page identifier (e.g., Garmin's section-prefixed printed page identifier "2-42") must do so with an explicit prefix (`[printed p. 2-42]` or similar) to avoid ambiguity with the V1 convention.

---

## Verification supporting this decision

13 citations sampled across all 7 fragments resolve cleanly by direct content match. Full table in `docs/todos/issue_index_resolved.md` §ITM-11.

| Coverage | Count |
|---|---|
| Original ITM-11 anchor citations | 4/4 PASS |
| Spot-check citations | 9/9 PASS |
| Total | 13/13 PASS |
| Fragment coverage | A:3, B:1, C:1, D:3, E:1, F:2, G:2 |

Citation count by fragment (for reference scope of the convention): A:17, B:52, C:55, D:72, E:64, F:64, G:15. Total 339 citations across V1.

---

## Implications for downstream consumers

### `spec-pdf-source-fidelity-reviewer` agent (D-22 §(2) item 1)

Reading a V1 citation `[p. N]` and verifying its content: read `assets/gnx375_llama_extract/pages/page_NNN.md` directly and check that the page's content matches the V1 section header it's cited in. **No `page_number_map.json` lookup required** for this path.

If the agent encounters a citation in Garmin's section-prefixed format (e.g., `[printed p. 2-42]`), only then should it consult `page_number_map.json`'s `logical_to_physical` to resolve to a physical page. This case does not occur in the current V1; reserved for future use.

### `page_number_map.json` (v2.0) usage scope

The map remains a useful artifact, but its role is narrower than ITM-11 originally projected:

| Use case | Map needed? |
|---|---|
| Resolving V1 `[p. N]` citations | No |
| Resolving future `[printed p. X-Y]` citations | Yes |
| Cross-referencing the extraction back to a printed Garmin manual the user holds in hand | Yes |
| Determining which Garmin section a given physical page belongs to | Yes (lookup by physical-page key in extras / physical_to_logical) |

### Future spec-authoring guidance

For any spec written going forward (V2 of the functional spec, design specs, supplements):

1. **Continue citing physical pages by default.** The `[p. N]` convention is established; preserve it for consistency with V1.
2. **Prefix Garmin printed pages explicitly** if used. `[printed p. 2-42]` is unambiguous; `[p. 2-42]` is *also* unambiguous (the dash distinguishes it from a bare integer), but the explicit prefix removes any ambiguity for tools that grep `[p. \d+]`.
3. **Document any deviation** in the spec's preface or the Coupling Summary if a particular fragment chooses a different convention.

---

## Why this clarification matters

This was an unwritten convention. Multiple project artifacts (ITM-11, the briefing inheriting it, my Turn 12 framing of the verification task) all assumed there was a Garmin-logical-vs-physical schism in V1 citations that needed reconciliation. There wasn't. The cost of the misdiagnosis was Turn 13 of inspection work plus a now-resolved ambiguity. Documenting the convention here prevents the same speculation from recurring.

Generalizes the discipline from D-26 (CD must verify external claims against ground-truth source documents) — a related but distinct prescription. D-26 is about *how* to check a claim; D-30 is about *what the claim is* for V1 citations specifically.

---

## Scope

Applies to:

- All 7 archived V1 fragments at `docs/specs/fragments/GNX375_Functional_Spec_V1_part_*.md`
- The eventual assembled `docs/specs/GNX375_Functional_Spec_V1.md` (when assembled)
- Any future authoring referencing the V1 fragments by citation
- The `spec-pdf-source-fidelity-reviewer` agent and any other tool that resolves citations against the PDF extraction

Does not apply to:

- Pre-V1 archived fragments authored under the old GNC 355 PDF + `text_by_page.json` extraction (those are pre-pivot and may use a different convention; verify before reusing their citations)
- Any future spec that explicitly adopts a different citation convention and documents it

---

## Related

- ITM-11 (resolved 2026-05-02 — the verification work that surfaced this convention)
- D-22 (source-of-truth policy)
- D-26 (CD verification discipline)
- D-28 (page 2 PAP 22 recycling code — extraction integrity context)
- `assets/gnx375_llama_extract/pages/page_NNN.md` (body content extraction)
- `assets/gnx375_pymupdf_v1_0_1/page_number_map.json` (printed-page-id ↔ physical bridge)
- GNX375-PAGEMAP-PYMUPDF-01 task family
