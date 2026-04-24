# D-24: Billable API Task Prompts Must Enumerate All Supported Outputs

**Created:** 2026-04-24T10:51:26-04:00
**Source:** Purple Turn 19–20 — post-mortem on Turn 18 LlamaParse extraction that requested text-only output, missing image extraction that was available at the same credit cost
**Status:** Accepted — applies to all future CD-authored task prompts that invoke billable APIs
**Related:** D-22 §(1) (the task that surfaced this gap); D-23 (credential-handling pattern for billable-API scripts); `docs/tasks/image_extraction_briefing.md` (the follow-up work that should have been part of the original task)

---

## Decision

When CD drafts a CC task prompt that invokes a **billable external API** (LlamaParse, OpenAI, Anthropic, or any third-party service priced per-request/per-page/per-token), the prompt must include an explicit **"Outputs considered"** section enumerating every output the API supports at the chosen configuration, with a rationale for each output that is either requested or excluded.

---

## The failure mode this prevents

Turn 18's LlamaParse Agentic-tier extraction requested `result_type="markdown"` and got 330 pages of clean markdown. The same billable API call could have additionally requested `output_options.images_to_save=["embedded"]` (embedded figures) and/or `output_options.images_to_save=["screenshots"]` (full-page rasters) at **no additional credit cost** — credits are per-page-per-tier, not per-output-type. The images were identified as needed for I1–I3 instrument GUI implementation in Turn 19, *after* the extraction completed. Getting them now requires either (a) a full re-extraction costing ~3,300 credits if the 48-hour cache window has elapsed, or (b) a more complicated catalog-then-supplement workflow leveraging the existing PyMuPDF `.bin` files.

The failure was at CD's task-design step. The task prompt framed scope around a single downstream consumer (C3 spec review PDF-fidelity agent, which only needs markdown) when multiple downstream consumers (I1–I3 implementation, design-phase UI reference) had legitimate needs from the same billable call. When CD's research in Turn 15 surfaced the LlamaParse API landscape, it captured tiers, pricing, and parse modes — but not `output_options.images_to_save`, which is a separate knob on the same API at the same tier.

This is a scope-framing error, not a technical one. The fix is procedural.

---

## The rule

For any CC task prompt invoking a billable API, CD must:

### 1. Enumerate all plausible downstream consumers before writing the prompt

- What will the output be used for, immediately?
- What might the output be used for, 1–6 months from now?
- Are there parallel workstreams (spec review, implementation, design, testing, documentation) that could legitimately consume the same output?

If the answer to any of these implicates an output the API supports, request that output — even if the immediate downstream consumer doesn't need it.

### 2. Read the API's full output-option surface, not just the primary output format

Tiers, modes, and pricing are not the whole story. Most modern parsing/extraction APIs support multiple concurrent outputs at one request:

- LlamaParse v2: `markdown`, `text`, `json`, `images_to_save=["embedded"]`, `images_to_save=["screenshots"]`, `structured_items`, `chart_data`, `layout_extraction` — often enabled together
- OpenAI: response_format (text, json_object, json_schema), logprobs, tools-calling metadata
- Anthropic: stop reasons, usage tokens, structured outputs, tool use blocks

These "also available" fields are usually cheap-to-free add-ons at the same billable tier. Request them unless there is a concrete reason not to.

### 3. Include an "Outputs considered" section in the task prompt

Every billable-API task prompt must contain a section naming every output the API supports and stating the disposition:

```markdown
## Outputs considered

| Output | Requested? | Rationale |
|--------|-----------|-----------|
| Markdown per page | YES | Primary deliverable — source-of-truth for spec review agents |
| Embedded images | YES | Required for I1–I3 instrument GUI implementation; same credit cost |
| Full-page screenshots | NO | Not needed; embedded images should cover UI references |
| Structured JSON items | NO | Markdown is sufficient for downstream agents; JSON would duplicate |
| Layout extraction | YES | Free in v2; useful for spec review cross-reference verification |
```

The rationale column is the critical part. "NO" without a reason is a red flag — it suggests the option wasn't considered. "NOT NEEDED" is not a rationale; state *why* the output would not be used by any plausible consumer.

### 4. CD self-review the Outputs table before launching CC

Before emitting the CC launch command, CD re-reads the Outputs table and explicitly asks: "Is any output here excluded for a reason other than 'we don't need it right now'?" If the only reason is immediate-need framing, that's a signal to include the output.

---

## Rationale

This is a prescriptive rule because the asymmetry of costs and benefits strongly favors requesting more outputs:

- **Cost of requesting an extra output that turns out unused:** near-zero (bandwidth, disk space, slight prompt-authoring overhead)
- **Cost of not requesting an output that turns out needed:** a second full billable API call (~$10 at LlamaParse Agentic tier for a 310-page PDF; potentially higher for other services)

When the cost is truly per-output-type (e.g., an API that charges separately for image download), the rationale column should state it and the exclusion decision becomes real. In practice, most modern billable APIs do not charge per output type at the parse/extract step; they charge per input-page or per-token.

---

## Applicability

**Applies to:**
- CC task prompts invoking LlamaParse (any tier), OpenAI Chat Completions, Anthropic Messages, any document-parsing API, any embedding API, any transcription API, any image-generation API
- CC task prompts that consume paid API credits from a shared project budget
- CC task prompts that produce outputs intended for multiple downstream consumers

**Does NOT apply to:**
- Local scripts with no external API dependency (PyMuPDF, pypdf, local Tesseract, etc.) — the "output not requested" cost is the local CPU time, which is already cheap
- CC task prompts invoking free-tier APIs where the per-request cost is already zero — though the habit of enumerating outputs is still useful
- Pure code-authoring tasks where the "API" is an LLM completion and the output format is fixed (the task-prompt surface is different)

---

## Non-obvious tradeoffs

- **This rule adds ~15–30 lines to every billable-API task prompt.** Worth it when the alternative is an extra full API call.
- **Enumeration requires CD to read the API docs more carefully at task-design time.** That's the point. In exchange, the CC task does not need to re-research the API.
- **Over-requesting outputs may clutter the output directory.** Acceptable; cleanup is cheap. Disk space is free relative to API cost.
- **Some outputs require post-processing to be useful.** For instance, LlamaParse's `images_content_metadata` returns presigned URLs that must be downloaded before they expire. If an output requires significant additional logic to consume, the task prompt must include that logic even if CD initially only expected to use the primary output later.

---

## Implementation checklist

- [ ] Review `docs/templates/CC_Task_Prompt_Template.md` and add an "Outputs considered" section to the template for billable-API tasks (or a separate `docs/templates/CC_Task_Prompt_Template_Billable_API.md` variant)
- [ ] Apply the rule retroactively to any in-flight billable-API CC task prompts (none currently; the Turn 18 LlamaParse task is the precedent-setter and is already complete)
- [ ] Include this rule in CD's task-design self-review checklist

---

## Related

- `docs/tasks/completed/pdf_reextraction_llamaparse_prompt.md` (once archived) — the precedent-setting task that motivated this rule
- `docs/tasks/image_extraction_briefing.md` — the follow-up work this rule is meant to prevent in future cases
- `docs/decisions/D-22-c3-spec-review-customization-for-gnx375-functional-spec.md` §(1) — the scope-framing context
- `docs/decisions/D-23-credential-file-access-pattern-for-cc-scripts.md` — companion rule for credential handling in billable-API scripts
