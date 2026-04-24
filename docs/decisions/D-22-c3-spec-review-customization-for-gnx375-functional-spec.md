# D-22: C3 Spec Review Customization for GNX 375 Functional Spec

**Created:** 2026-04-24T07:09:07-04:00
**Revised:** 2026-04-24T07:18:49-04:00 (Turn 9 rewrite — scope corrected to this spec's C3 review only; Tier 3 items promoted to in-scope; LlamaParse upstream step added; triage criteria sharpened)
**Revised:** 2026-04-24T10:41:03-04:00 (Turn 19 amendment — §(1) source-of-truth policy expanded: new extraction preferred for post-archive authoring work in addition to C3 review; archived compliance records remain bound to original extraction; image-extraction follow-up work noted; page-offset ITM-11 referenced)
**Source:** Purple Turn 6–9 (2026-04-24) — Steve asked "what can we do to facilitate spec review on this large spec? same question regarding findings triage?" and then refined the answer with aggressive-triage directives in Turn 7 continuation.
**Status:** Accepted — to be applied at C3 kick-off for **the GNX 375 Functional Spec V1 review cycle only**
**Scope:** This decision customizes `docs/specs/Spec_Review_Workflow.md` application **for the C3 review of the GNX 375 Functional Spec V1 aggregate** (the spec assembled from Fragments A–G per D-18). It does **not** establish new standing conventions for spec review in general. Later specs — the GNX 375 Design Spec (D1), any future revisions, the GNC 355 Functional Spec when that workstream resumes — will have their own success criteria and should not inherit these customizations by default.
**Related:** D-18 (piecewise + manifest partition — prerequisite for hybrid-mode C3), D-19 (fragment size targets), ITM-08 (Coupling Summary glossary-ref discipline — one of the failure modes the new agents are designed to catch), ITM-10 (Fragment C vs. PDF p. 94 — an example of a finding the upstream PDF re-extraction and new PDF-fidelity agent would surface earlier).

---

## Context

The standard `docs/specs/Spec_Review_Workflow.md` roster and procedure were built around code specs (SQL, API contracts, SSE events, schema migrations, test coverage mapping against existing test files). The GNX 375 Functional Spec is a **behavioral / operational spec** — it describes how an avionics instrument behaves, not how a backend is built. Applying the default roster as-is would run 6–8 agents whose trigger patterns don't match our spec content, producing weak signal and wasted tokens.

More importantly, **this spec's success criterion is narrow and specific:** the spec must accurately describe the real-world GNX 375 as documented in the Garmin Pilot's Guide 190-02488-01 Rev. C and confirmed by research (D-15 display architecture research, D-16 XPDR + ADS-B scope research, and any subsequent research). **We are not designing a novel avionics product.** We are building an Air Manager instrument that simulates an existing device. "Improvements" to the functional behavior are failure modes for this review cycle — they would produce an instrument that doesn't match the real device, defeating the purpose.

This framing shapes every downstream choice: agent roster, triage stance, finding documentation policy.

---

## Six customizations for the C3 review cycle

### (1) Upstream: Re-extract the Pilot's Guide PDF via LlamaParse Agentic tier

Before C3 kicks off, resubmit `assets/gnc355_pdf_extracted/`'s source PDF (Garmin Pilot's Guide 190-02488-01 Rev. C) to **LlamaParse (LlamaIndex) using the `llamaparse_agentic` ("Agentic tier") preset**, not the older `llamaparse_premium` tier. Replace or add-alongside the existing `text_by_page.json` extraction.

**Status (Turn 18, 2026-04-24T10:31 ET):** Completed. 330 pages extracted via `parse_mode="parse_page_with_agent"` in 2.5 min wall-clock. Output at `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/`. Major quality uplift confirmed on spot-checked pages (§11.4 XPDR Modes, §4.10 Unit Selections).

**Status (Turn 19, 2026-04-24T10:41 ET):** Follow-up work identified — the initial script didn't request image extraction. Images are needed for instrument GUI (I1–I3) implementation. Path forward: leverage the existing 521 `.bin` files PyMuPDF already extracted (see the original `scripts/gnc355_pdf_extract.py` run), writing a catalog+rename script first (free). If the resulting catalog is insufficient for specific UI artifacts, commission a supplementary LlamaParse run with `images_to_save` enabled at that point. See `docs/tasks/image_catalog_prompt.md` (to be drafted) for the image-catalog task.

**Rationale:** the original extraction had known gaps — p. 94 Unit Selections shows a partial category list (triggering ITM-10); p. 125 Land data symbols is image-only (worked around with a manual PNG supplement); sparse pages (pp. 1, 36, 110, 208, 222, 270, 292, 298, 308, 309, 310) were flagged in Fragment A Appendix C. The original extraction was done via `scripts/gnc355_pdf_extract.py` without OCR (Tesseract not available at extraction time). LlamaParse's Agentic tier applies LLM-assisted reasoning to table extraction, image-heavy pages, and cross-reference resolution in ways the original pipeline did not.

**The new extraction is both the C3 review source-of-truth AND the preferred PDF citation reference for post-archive work going forward.** (Amended Turn 19 — see below.) The new `spec-pdf-source-fidelity-reviewer` agent (see (2) below) checks spec claims against the PDF extraction. Improving the extraction directly improves every downstream finding the agent surfaces. If the new extraction contradicts claims in archived fragments (e.g., proves or disproves ITM-10), that's high-value signal for C3, not a problem.

**Source-of-truth policy (amended Turn 19):**

- **Archived fragments (A through F, and G once archived):** compliance records remain bound to the **original** `text_by_page.json` extraction. Do NOT re-compliance-check archived fragments against the new extraction; compliance reports are archival and cite the extraction in force at the time of review. This preserves audit integrity.
- **Post-archive authoring work (C2.2-G if still pending; any future spec authoring, revision, or Design Spec work):** the **new** `llamaparse_agentic_v1` extraction is the preferred PDF citation reference. Authors should consult it in preference to `text_by_page.json` when authoring new spec prose, drafting new task prompts, or investigating PDF-source questions.
- **C3 spec review:** uses the new extraction as source-of-truth (original intent of this §(1)).
- **Page-number offset:** the new extraction uses physical PDF page numbering (cover = page 1), while the original extraction and all archived fragments cite Garmin logical page numbering (1-based from the body). Offset varies by section (~+2 early, up to ~+4 later). ITM-11 (logged Turn 19) tracks this; a page-number mapping will be needed for C3 review agents comparing fragment citations against the new extraction.
- **Original extraction retention:** `text_by_page.json` and the 521 `.bin` images from the original `gnc355_pdf_extract.py` run remain on disk for (a) archival compliance reference, (b) the image-catalog task (see Turn 19 status above). Do NOT delete the original extraction.

**Acceptance criterion:** new extraction committed to `assets/gnc355_pdf_extracted/` (new filename or versioned path; keep original for provenance) before C3 launches. Pre-flight script (item 4 below) reads whichever extraction the review targets.

**Out of scope here:** whether LlamaParse replaces the existing extraction permanently — deferred pending I1–I3 implementation experience. The Turn 19 amendment above narrows this — for authoring and review purposes the new extraction is preferred; for compliance audit trail the original remains bound to archived fragments.

### (2) Customized agent roster with `--without` for low-fit agents

The default roster (9 default + 3 conditional = 12 agents) was tuned for code specs. For this spec:

| Agent | Fit for this spec | C3 decision |
|-------|-------------------|-------------|
| Implementation | Low — no algorithms to trace | `--without implementation` |
| API Contract | Low — no endpoints | `--without api` |
| Assistant Parity | Low — no UI/backend duality | `--without assistant-parity` |
| Integration | Low — no migrations, no serve_db.py | `--without integration` |
| Security/Data Integrity | Low — no user data, no sidecar rules | `--without security` |
| Performance/Query | Low — no SQL | `--without perf` |
| Test Coverage | Low — no test files yet (pre-implementation) | `--without test` |
| Complexity | **High** — accidental complexity in operational description is a real failure mode | Keep |
| Editorial/Convention | **High** — cross-fragment consistency is critical | Keep |
| Enhancement | **Medium** — runs automatically; findings must be triaged aggressively per (3) below (goal is fidelity, not "improvements") | Keep (but see triage bias in (3)) |
| UX Engineer | Medium — device UX (touchscreen behaviors, knob actions), not app UX | Keep |
| Error Recovery | Medium — instrument failure modes (XPDR fail, GPS LOI, ADS-B receiver fault) are real | Keep |

**Plus three new domain-specific agents** to be drafted in `.claude/agents/` before C3:

1. **spec-pdf-source-fidelity-reviewer** — every PDF citation in the spec verifiable against the new LlamaParse-agentic extraction (or current extraction as fallback); every claim about PDF content re-grep'd. Automates the C1/S5/S7-pattern compliance checks we've been running by hand.
2. **spec-cross-fragment-coupling-reviewer** — every `see §N.x` cross-ref resolves to an actual section in another fragment; Coupling Summary backward/forward refs match body content; no ITM-08/ITM-09-pattern over-claims.
3. **spec-sibling-unit-consistency-reviewer** — statements about GNX 375 vs. GPS 175 vs. GNC 355/355A consistent across fragments; Appendix A deltas match inline mentions; D-15 (no internal VDI) and D-16 (three-modes, built-in ADS-B, TSAA GNX-375-only, Remote G3X Touch v1 out-of-scope) framing honored throughout; no COM-on-GNX-375 leakage.

**Net active roster for C3:** 8 agents (Complexity, Editorial/Convention, Enhancement, UX Engineer, Error Recovery, PDF Source Fidelity, Cross-Fragment Coupling, Sibling-Unit Consistency). 4 Opus + 4 Sonnet per the model-assignment pattern in workflow §4.11 — the three new agents should be Sonnet (pattern-matching against PDF / cross-ref / sibling-unit assertions; not judgment-heavy).

Agent files are small (~60 lines each). Estimated drafting cost: ~1 CD turn each, or one batched CC task. Draft during idle windows between C2.2-F/G CC executions; target completion before C2.2-G archive.

### (3) Aggressive triage stance for this review cycle

**Triage criterion — C3 only:** every finding must pass a functional-fidelity test to be accepted.

| Finding class | Triage rule |
|---------------|-------------|
| **CRITICAL gap** | **Keep** all. Accept into V2. |
| **HIGH gap, could lead to functional error** | **Keep.** "Functional error" means the Air Manager instrument would behave differently from the real GNX 375 as documented. Accept into V2. |
| **HIGH gap, could NOT lead to functional error** (e.g., editorial precision, internal consistency, stylistic) | **Reject**, but document thoroughly per (4) below. |
| **MEDIUM gap, could lead to functional error** | **Keep.** Accept into V2. |
| **MEDIUM gap, could NOT lead to functional error** | **Reject**, document thoroughly. |
| **LOW gap** | **Reject** by default, document thoroughly. Exception: if a LOW finding is a direct symptom of a deeper functional issue, re-classify at CD discretion. |
| **Opportunity (any value level)** | **Default Reject**, document thoroughly. Be especially wary — opportunities propose capabilities beyond what the real device has. Exception: if an opportunity is actually a gap misclassified as an opportunity (e.g., "add X" where X is in the real device but missing from the spec), re-classify as a gap. |

**Why this is asymmetric:** the review is measuring spec ↔ real-device fidelity, not spec ↔ ideal-avionics-design fidelity. A finding that says "the spec doesn't document a graceful recovery path from GPS signal loss during an active approach" is functional (real device has specific behavior here; if spec is silent, implementation will drift). A finding that says "the spec could be more consistent in how it cross-references §7.D and §7.G" is editorial (functional behavior unchanged either way). Even HIGH-severity findings fall into both buckets — severity alone does not imply functional impact.

**Anticipated distribution (rough):** first-round V1 review might produce 80–150 findings. Under this rule, we'd expect to accept 20–40 (CRITICALs + functional HIGHs + functional MEDIUMs) and reject 40–110 with thorough documentation.

### (4) Thorough documentation of rejected/deferred findings

**Every Reject or Defer disposition is paired with same-turn documentation, not a column-fill.** The documentation serves two purposes:

1. **Audit trail:** future CD or Steve reviewing the spec can reconstruct why finding G-n or O-n was rejected, without re-deriving the rationale.
2. **Deviation-investigation asset:** once the instrument is implemented (I1–I3 phase per Task flow plan), any deviation between instrument behavior and expected behavior will trigger investigation. The rejected-findings documentation is the first place to look — a finding rejected during C3 that later turns out to have been real is a high-signal clue.

**Documentation shape per rejected finding:**

- **Inline disposition** in `{Name}_V1_review.md` — the Disposition column gets "Reject" or "Defer" plus a one-sentence rationale linking to the functional-fidelity test above.
- **`issue_index.md` entry** for any finding where the rationale is >1 sentence or the finding might resurface — give it an ID (G-n / O-n / FE- / ITM-n as appropriate), full description, functional-fidelity test result, and PDF-source citation if applicable.
- **If finding becomes resolved later** (e.g., by design phase or implementation): move to `issue_index_resolved.md` with resolution summary.

**Concrete example** (hypothetical): review finding "G-47 HIGH: §7 procedures spec doesn't describe LPV glidepath capture behavior during course reversal." Triage: does the real device have specific behavior here? Consult PDF pp. 200–204 + D-15/D-16 research. If PDF documents specific behavior that's missing from spec → Accept (functional). If PDF is silent and there's no research basis → Reject as "speculative elaboration beyond source documentation" and log in `issue_index.md` as a watchpoint (FE- if worth future research; ITM- if we need to note we looked and found nothing).

### (5) Hybrid-mode review + Review Priority Guide + tier escalation

Operational mechanics for running the review:

**Hybrid mode:** C3 runs against the manifest (`docs/specs/GNX375_Functional_Spec_V1_manifest.json`), not the assembled aggregate alone. `/spec-review --mode hybrid` gives section-level granularity per fragment in Phase 1 + integration review on the aggregate in Phase 2. D-18's piecewise partition is the prerequisite — we already have it. Assembly script (`scripts/assemble_gnx375_spec.py`) and manifest pre-flight (`scripts/verify_gnx375_manifest.py`) are C2.2-G-archive-step deliverables.

**Review Priority Guide** prepended to the aggregate spec at C2.2-G archive:

- **P1 (correctness-critical):** §11 XPDR + ADS-B (signature feature; D-16 framing), §15 External I/O (output contracts to X-Plane/MSFS; OPEN QUESTIONS 4 and 5), §4.9 Hazard Awareness (alert behaviors; OPEN QUESTION 6), §7 Procedures (approach state machine; D-15 no-internal-VDI framing).
- **P2 (functionality-critical):** §§5–6 FPL editing + Direct-to, §§8–10 Nearest/Waypoint/Settings, §14 Persistent State, §12 Alerts, §13 Messages.
- **P3 (quality/polish):** §§1–4 Overview/Controls/Startup/Display pages (largely PDF transcription; stable), Appendices A/B/C.

Enables `--p1p2-only` for iterative re-review passes.

**Tier escalation with aggressive `-s` on later rounds:**

- **V1 review:** `--tier quick --mode hybrid` + `--without` flags listed in (2) + `--with pdf-fidelity,cross-fragment,sibling-unit`. Batches 1–2 of customized roster. Rationale: first-round overlap catches more than first-round breadth.
- **V2 review:** `--tier standard --mode hybrid -s C` + same `--without` / `--with` flags. `-s C` re-runs only agents that scored C-or-worse on V1. Significant token savings.
- **V3 review (only if V2 has residual CRITICAL/HIGH functional findings):** `--tier full --mode hybrid -s C` + flags. Reserve Full tier for residual polish; most specs converge in 2 rounds and the aggressive-rejection policy in (3) accelerates this.

### (6) Manifest pre-flight and disposition cheat-sheet as C3 tooling

**Manifest pre-flight script** (`scripts/verify_gnx375_manifest.py`) verifies:
- Every fragment listed in manifest exists on disk
- Line counts match archive records in the manifest status journal
- Section headers are continuous across fragments (no gaps, no duplicates)
- `see §N.x` cross-refs resolve to actual targets (or note unresolved for reviewer attention)
- Coupling Summary forward-refs resolve to sections in later fragments
- PDF citation format is parseable (all `[p. N]` or `[pp. N–M]` patterns valid)

Runs before `/spec-review --mode hybrid` launches. Surfaces assembly-breakage problems before they hit the reviewer pipeline.

**Disposition cheat-sheet** (`docs/templates/spec_review_disposition_guide.md`) — written after the first 20 V1 findings are triaged, using the triage criterion in (3) as the baseline rule. The cheat-sheet codifies the functional-fidelity test in concrete examples observed from this specific review. Updated after each review round.

---

## Implementation checklist

- [ ] **PDF re-extraction:** resubmit GNC355 Pilot's Guide to LlamaParse Agentic tier; commit to `assets/gnc355_pdf_extracted/` (versioned filename; preserve original extraction)
- [ ] **Draft `.claude/agents/spec-pdf-source-fidelity-reviewer.md`** (~60 lines; Sonnet)
- [ ] **Draft `.claude/agents/spec-cross-fragment-coupling-reviewer.md`** (~60 lines; Sonnet)
- [ ] **Draft `.claude/agents/spec-sibling-unit-consistency-reviewer.md`** (~60 lines; Sonnet)
- [ ] **CD authors `scripts/assemble_gnx375_spec.py`** (already planned per D-18)
- [ ] **CD authors `scripts/verify_gnx375_manifest.py`** (per (6) above)
- [ ] **CD prepends Review Priority Guide** to aggregate spec at C2.2-G archive (per (5) above)
- [ ] **CD writes `docs/templates/spec_review_disposition_guide.md`** after first 20 V1 findings (per (6) above)
- [ ] **CD adds scratch directory to `.gitignore`** if parallel-CD triage is invoked: `docs/todos/_triage_work/` (parallel-CD triage is not mandatory under this decision; deploy only if V1 produces >100 findings despite the aggressive rejection stance)

**Sequence:**
- Items 2–4 (three new agent files): draft during idle windows between C2.2-F/G CC executions.
- Item 1 (PDF re-extraction): can happen any time before C3 launches; independent of C2.2-F/G.
- Items 5–7 (assembly, pre-flight, priority guide): at C2.2-G archive step.
- Item 8 (disposition cheat-sheet): after first 20 V1 findings.

---

## Scope caveat (critical)

**This decision applies only to the C3 review of the GNX 375 Functional Spec V1.** It does not establish standing conventions for spec review in general. The aggressive-rejection triage criterion in (3) is specifically calibrated to the goal of real-device-fidelity implementation — it is **not** appropriate for:

- **GNX 375 Design Spec review** (D1/D2 phase per Task flow plan) — the Design Spec describes the Air Manager implementation approach, which is novel per-project design work; opportunities and quality-of-life findings matter more there. Test Coverage agent becomes relevant. Security/Data Integrity may matter if design involves user data. Standard workflow should apply with modest customization.
- **GNC 355 Functional Spec review** (when the deferred 355 workstream resumes) — success criterion is also real-device fidelity, so the triage criterion in (3) probably applies; but the specific agent roster and Priority Guide will need to be re-derived for the 355's content. The meta-pattern "customize workflow per spec's success criterion" applies; the specific customization does not port directly.
- **Any future revision of the GNX 375 Functional Spec V1 itself** — if a V2+ revision is driven by real-world device updates (new Garmin firmware, new Pilot's Guide revision), the aggressive-rejection stance still applies. If it's driven by Air Manager instrument bugs surfaced during I1–I3 implementation, the stance may loosen (implementation findings could legitimately motivate small improvements beyond strict PDF fidelity).

When the next spec review cycle approaches, CD should re-derive the applicable customizations from the spec's success criterion — not copy this decision record forward as a standing convention.

---

## Non-obvious tradeoffs

- **Dropping Test Coverage agent for C3:** it runs by default in every tier per workflow §4.7. We drop it for this review because there's no implementation code yet. Re-enable at Design Spec review.
- **`--tier quick` as V1 default (deliberate departure from workflow §4.7's `--tier standard` default):** first-round review catches lots of overlapping CRITICALs across agents, so breadth of roster matters less than running cheaply. Tier up on V2 once V1 fixes are incorporated.
- **LlamaParse re-extraction may surface new discrepancies with archived fragments (A–G):** this is expected and valuable — such discrepancies become review findings for C3 dispositions. Do NOT re-compliance-check archived fragments against the new extraction; compliance was against the original extraction and is archival. Only the C3 review uses the new extraction as source-of-truth. **(Amended Turn 19:** the new extraction is ALSO the preferred reference for post-archive authoring work — C2.2-G if still pending, Design Spec D1/D2, future spec revisions — but archived compliance records remain bound to the original extraction. See §(1) source-of-truth policy for the full rule.**)**
- **Aggressive rejection policy might hide real gaps that masquerade as opportunities:** the example in (4) illustrates why re-classification discretion matters. Reject-with-thorough-documentation is the safety net: if a rejection turns out to be wrong post-implementation, the `issue_index.md` record is discoverable.
- **LlamaParse Agentic tier has API costs.** One full extraction of the ~310-page Pilot's Guide is modest (tens of dollars range, not hundreds), and is one-time for C3 purposes. Acceptable.
- **Three new agent files add maintenance surface.** They're project-specific (flight-sim / GNX 375); not portable to other Basecamp projects without modification. Accepted — the value they deliver for this review outweighs the maintenance overhead, and they can be deleted post-implementation if the instrument is single-deliverable.

---

## Related

- `docs/specs/Spec_Review_Workflow.md` — the workflow being customized (retains as the standing reference for future spec reviews)
- `docs/decisions/D-18-c22-format-decision-piecewise-manifest.md` — manifest partition prerequisite
- `docs/decisions/D-19-fragment-prompt-line-count-expansion-ratio.md` — fragment sizing (hybrid-mode relevance)
- `docs/decisions/D-15-gnx375-display-architecture-internal-vs-external-turn-20-research.md` — sibling-unit agent checks D-15 framing
- `docs/decisions/D-16-gnx375-xpdr-adsb-scope-corrections-turn-21-research.md` — sibling-unit agent checks D-16 framing
- `docs/todos/issue_index.md` §ITM-08 — Coupling Summary over-claim pattern (cross-fragment-coupling agent targets this)
- `docs/todos/issue_index.md` §ITM-10 — Fragment C Unit Selections vs. PDF (PDF-fidelity agent would have caught this; re-extraction may definitively resolve it)
- Compliance reports for C2.2-B through C2.2-E — concrete examples of failure modes the new agents target
- `assets/gnc355_pdf_extracted/` — target directory for LlamaParse re-extraction output
