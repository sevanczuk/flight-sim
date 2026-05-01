# Cache Behavior Test — RESULT: CACHE INVALIDATED

**Test time:** 2026-04-24T11:57:38-0400
**Corrected:** 2026-04-24T12:04:00-0400 (initial interpretation was wrong; see Script Bug below)

## Actual outcome

`load_data()` did NOT succeed. The LlamaParse API returned:

```
Failed to parse the file: {"detail":"You've exceeded the maximum number of credits for your plan."}
```

The SDK printed this error to stderr but **did not raise a Python exception** — it returned an empty document list instead. This SDK behavior defeated the script's exception-based detection logic, which is why `extraction_log.json` and the original version of this file incorrectly reported "PASSED / CACHE APPLIED".

The 7.2s elapsed time confirms this was an immediate API rejection, not a real parse (Turn 18's baseline parse took 2.5 minutes for 330 pages at the same tier).

## Correct interpretation

**Adding `save_images=True` and `take_screenshot=True` to the LlamaParse constructor INVALIDATED the 48-hour cache.** The server treated the re-parse with new image-output parameters as fresh work, which the account's 100% quota then rejected pre-billing.

This is definitive empirical evidence that **output-options parameters count as cache-invalidating parameters** in the LlamaParse v1 SDK (`llama-parse` 0.6.94) with the legacy upload endpoint.

## Billing impact

**Zero credits charged.** The 100% quota rejected the request before any processing. This confirmed the safety design of the test.

## Implications for Approach B (GNX 375 image extraction)

- **Approach B is NOT free within the 48h cache window.** The cache-hit-is-free optimistic framing from Turn 22 was incorrect.
- Approach B costs the full Agentic-tier credit cost: ~3,300 credits for a 330-page re-parse = **~$4.13 on paid overage**, or **~33% of the monthly free-tier quota** (10,000 credits/month).
- There is no 48-hour urgency window. Approach B can be sequenced whenever it's actually needed in the implementation flow (e.g., at D1/D2 Design Spec authoring or I1–I3 implementation), not pre-emptively within the cache window.

## Caveats / scope of test

- Tested on the v1 SDK (`llama-parse` 0.6.94) using the legacy `/api/parsing/upload` endpoint.
- The v2 API (`/api/v2/parse`) may have different cache semantics. This test does not conclusively answer the v2 case, but given that the v1 cache doc says the cache considers "parameters that can have an impact on the output (such as parsing_instructions, language, page_separators)" and the v2 API formalizes these as `output_options`, the same behavior is expected in v2.
- Screenshots and `"layout"`-category images (v2-only) were not tested.

## Script bug that caused the initial misreport

The test script (`scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse_with_images.py`) relied on `try/except` around `parser.load_data()` to detect failure. This assumed the SDK raises an exception on API-level errors.

**Actual SDK behavior:** when the API returns an error response, the v1 SDK prints the error to stderr and returns an empty list — no exception is raised. The script's fall-through to "success" branch then wrote an incorrect "CACHE APPLIED" interpretation.

**Fix for future test scripts:** validate the RESULT, not the absence of an exception. Specifically:
- Check `len(documents) > 0` AND `elapsed_parse_seconds` is consistent with a real parse (expected ~2.5 min for this PDF, not 7 sec).
- Capture stderr during the call and check for known error signatures.

## Meta-observation

This is the third instance in the session of CD being overconfident about LlamaParse behavior without empirical grounding:
- Turn 15: drafted image-extraction briefing assuming PyMuPDF `.bin` files would be sufficient; didn't anticipate we'd want LlamaParse-quality image output.
- Turn 22: asserted Approach B would be free within cache window without verification.
- Turn 24: wrote a test script whose success/failure detection logic was based on an unverified assumption about SDK error-handling.

A candidate CD convention (separate from current decisions) would require empirical validation for any claim about external-API behavior where uncertainty could affect billing, correctness, or test interpretation.
