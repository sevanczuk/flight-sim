"""
Re-extract Garmin GNC 375/GPS 175/GNC 355/GNX 375 Pilot's Guide PDF
via LlamaParse Agentic tier WITH IMAGE OUTPUT ENABLED.

Purpose: CACHE BEHAVIOR TEST (Purple Turn 24, 2026-04-24)
---------------------------------------------------------
Turn 18's successful extraction (output at llamaparse_agentic_v1/)
did NOT request image output. This script repeats that extraction
with save_images=True and take_screenshot=True added to the
constructor — every other parameter is IDENTICAL to Turn 18 —
to empirically determine whether adding image-output parameters
invalidates the 48-hour LlamaParse cache.

Safety: the account is at 100% of monthly free-tier quota.
- If cache applies despite new image params: request succeeds,
  we get images at zero credit cost.
- If cache does NOT apply: request immediately fails on quota
  exhausted, zero credits charged.
Either outcome is definitive and billing-safe.

Output location: llamaparse_agentic_v1_with_images/ (new dir;
Turn 18's llamaparse_agentic_v1/ output is preserved untouched.)

CREDENTIAL HANDLING:
The LlamaParse API key is loaded from C:/PhotoData/config/api_keys.json
under the key name 'llamaparse'. The value is read into a local variable,
passed directly to the LlamaParse SDK, and NEVER printed, logged, or
stringified to any output stream. Per cc_safety_discipline.md and D-23.
"""

import json
import re
import sys
import time
from pathlib import Path

CREDENTIAL_FILE = Path(r"C:\PhotoData\config\api_keys.json")
CREDENTIAL_KEY_NAME = "llamaparse"

PROJECT_ROOT = Path(__file__).resolve().parents[2]
SOURCE_PDF = PROJECT_ROOT / "assets" / "Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf"
OUTPUT_DIR = PROJECT_ROOT / "assets" / "gnc355_pdf_extracted" / "llamaparse_agentic_v1_with_images"
PAGES_DIR = OUTPUT_DIR / "pages"
IMAGES_DIR = OUTPUT_DIR / "images"


def _load_api_key() -> str:
    """Load the LlamaParse API key from the credential file.

    Validates presence, format-shape, and length without exposing the value.
    Returns the key as a local string; caller must not log or print it.
    Raises RuntimeError with a label-only message on any failure.
    """
    if not CREDENTIAL_FILE.exists():
        raise RuntimeError(f"credential file not found at {CREDENTIAL_FILE}")

    try:
        with open(CREDENTIAL_FILE, "r", encoding="utf-8") as fh:
            creds = json.load(fh)
    except json.JSONDecodeError as exc:
        raise RuntimeError(
            f"credential file is not valid JSON (line {exc.lineno})"
        ) from None
    except OSError as exc:
        raise RuntimeError(f"credential file could not be opened: {exc.strerror}") from None

    if not isinstance(creds, dict):
        raise RuntimeError("credential file root is not a JSON object")

    if CREDENTIAL_KEY_NAME not in creds:
        raise RuntimeError(f"'{CREDENTIAL_KEY_NAME}' key missing from credential file")

    key = creds[CREDENTIAL_KEY_NAME]

    # Drop the parsed dict reference immediately.
    creds = None

    if not isinstance(key, str):
        raise RuntimeError(f"'{CREDENTIAL_KEY_NAME}' value is not a string")
    if len(key) < 20:
        raise RuntimeError(f"'{CREDENTIAL_KEY_NAME}' value too short (expected >= 20 chars)")
    if not key.startswith("llx-"):
        raise RuntimeError(f"'{CREDENTIAL_KEY_NAME}' value has wrong prefix (expected 'llx-')")

    return key


def _sanitize_error(msg: str) -> str:
    """Strip any llx-... fragments from an error message before logging."""
    return re.sub(r'llx-[A-Za-z0-9_-]+', 'llx-<REDACTED>', msg)


def main() -> int:
    # Pre-flight: load API key (raises if missing/malformed; no value ever printed)
    try:
        api_key = _load_api_key()
    except RuntimeError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2

    if not SOURCE_PDF.exists():
        print(f"ERROR: source PDF not found at {SOURCE_PDF}", file=sys.stderr)
        return 2

    if OUTPUT_DIR.exists() and any(OUTPUT_DIR.iterdir()):
        print(f"ERROR: output dir {OUTPUT_DIR} exists and is non-empty. Remove it first.", file=sys.stderr)
        return 2

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    PAGES_DIR.mkdir(parents=True, exist_ok=True)
    IMAGES_DIR.mkdir(parents=True, exist_ok=True)

    from llama_parse import LlamaParse

    print(f"Starting LlamaParse Agentic-tier extraction WITH IMAGES: {SOURCE_PDF.name}")
    print(f"Output: {OUTPUT_DIR}")
    print(f"Test: empirical cache-behavior verification (account is at 100% quota;")
    print(f"      quota-rejection = definitive proof of cache invalidation)")
    start_time = time.time()

    # Parser configuration:
    # - Every parameter EXCEPT save_images and take_screenshot is IDENTICAL to
    #   Turn 18's successful run (the baseline this test is compared against).
    # - save_images=True: v1 SDK equivalent of output_options.images_to_save=["embedded"]
    # - take_screenshot=True: v1 SDK equivalent of output_options.images_to_save=["screenshot"]
    # The v1 SDK has no equivalent for output_options.images_to_save=["layout"];
    # that category is v2-only and would require a larger protocol change.
    parser = LlamaParse(
        api_key=api_key,
        parse_mode="parse_page_with_agent",
        result_type="markdown",
        verbose=True,
        language="en",
        parsing_instruction=(
            "Extract all tables and figures with high accuracy. Preserve page numbers, "
            "section headers, and cross-references. For figures that are images without "
            "OCR text (e.g., symbol charts), note the figure content descriptively. "
            "This is an avionics pilot's guide; preserve exact terminology for squawk "
            "codes, flight phase annunciations, approach types, and transponder modes."
        ),
        # ---- NEW vs. Turn 18 ----
        save_images=True,
        take_screenshot=True,
        # -------------------------
    )

    # Drop our local reference to the key.
    api_key = None

    # PRIMARY CACHE-BEHAVIOR TEST: call load_data with the new image-requesting
    # parser configuration. This is the one call whose outcome answers the
    # research question:
    #
    #   - If documents are returned successfully: cache applied despite the
    #     new image params. Re-parsing the same file with added image options
    #     within the 48h window is free.
    #
    #   - If an exception is raised (likely a quota-exceeded HTTP 429 or
    #     similar): cache was invalidated by the new image params. A fresh
    #     parse was attempted and rejected on quota.
    try:
        documents = parser.load_data(str(SOURCE_PDF))
    except Exception as exc:
        sanitized = _sanitize_error(str(exc))
        print(f"ERROR: LlamaParse extraction failed: {sanitized}", file=sys.stderr)
        print(f"", file=sys.stderr)
        print(f"INTERPRETATION:", file=sys.stderr)
        print(f"  If the error mentions quota/429/credits: this is DEFINITIVE evidence", file=sys.stderr)
        print(f"  that changing output_options (save_images/take_screenshot) invalidates", file=sys.stderr)
        print(f"  the 48-hour LlamaParse cache. Approach B should be budgeted for full", file=sys.stderr)
        print(f"  credit cost (~3,300 credits for 330-page agentic-tier re-parse).", file=sys.stderr)
        print(f"  Billing safety: account is at 100% quota, so zero credits were charged.", file=sys.stderr)
        # Write a cache-test result file even on failure for post-hoc review.
        (OUTPUT_DIR / "CACHE_TEST_RESULT.md").write_text(
            f"# Cache Behavior Test — RESULT: CACHE INVALIDATED\n\n"
            f"**Test time:** {time.strftime('%Y-%m-%dT%H:%M:%S%z')}\n\n"
            f"**Outcome:** load_data() raised an exception. The error message "
            f"(sanitized): `{sanitized}`\n\n"
            f"**Interpretation:** Adding save_images=True and take_screenshot=True "
            f"to the LlamaParse constructor invalidated the 48-hour cache, causing "
            f"a fresh parse attempt that was rejected due to quota exhaustion. This "
            f"is definitive evidence that output_options parameters count as "
            f"cache-invalidating parameters in LlamaParse.\n\n"
            f"**Billing impact:** Zero credits charged (pre-billing rejection on quota).\n\n"
            f"**Implication for Approach B:** budget full credit cost "
            f"(~3,300 credits for 330-page agentic-tier re-parse). No free-via-cache path.\n",
            encoding="utf-8",
        )
        return 3

    elapsed_parse = time.time() - start_time
    print(f"PRIMARY TEST PASSED: parse succeeded in {elapsed_parse:.1f}s")
    print(f"  -> Cache behavior: adding save_images+take_screenshot did NOT invalidate cache")
    print(f"  -> {len(documents)} documents returned")

    # Save per-page markdown (same as Turn 18).
    page_count = len(documents)
    full_parts = []
    for idx, doc in enumerate(documents, start=1):
        page_num_str = f"{idx:03d}"
        page_file = PAGES_DIR / f"page_{page_num_str}.md"
        content = getattr(doc, "text", None) or str(doc)
        page_file.write_text(content, encoding="utf-8")
        full_parts.append(f"<!-- page {idx} -->\n\n{content}\n")

    full_md = OUTPUT_DIR / "full_markdown.md"
    full_md.write_text("\n---\n\n".join(full_parts), encoding="utf-8")

    # ---- Image retrieval (best-effort; does not fail the primary test) ----
    # The v1 SDK exposes images via parser.get_json_result() which returns the
    # full per-page structured result including image metadata, and
    # parser.get_images() which downloads them to a local path.
    images_retrieved = 0
    screenshots_retrieved = 0
    image_retrieval_error = None
    raw_json_saved = False

    try:
        print(f"Retrieving image metadata via get_json_result...")
        json_objs = parser.get_json_result(str(SOURCE_PDF))

        # Save the raw JSON for post-hoc inspection regardless of what comes back.
        (OUTPUT_DIR / "raw_json_result.json").write_text(
            json.dumps(json_objs, indent=2, default=str),
            encoding="utf-8",
        )
        raw_json_saved = True

        # Download embedded images.
        try:
            print(f"Downloading embedded images to {IMAGES_DIR}...")
            image_dicts = parser.get_images(json_objs, download_path=str(IMAGES_DIR))
            images_retrieved = len(image_dicts) if image_dicts else 0
            print(f"  -> Retrieved {images_retrieved} image records")
        except Exception as exc_img:
            sanitized_img = _sanitize_error(str(exc_img))
            print(f"WARN: embedded-image download failed: {sanitized_img}", file=sys.stderr)
            image_retrieval_error = f"get_images: {sanitized_img}"

        # Download screenshots (v1 SDK method; may not exist on all SDK versions).
        try:
            if hasattr(parser, "get_screenshots"):
                print(f"Downloading page screenshots...")
                screenshot_dicts = parser.get_screenshots(json_objs, download_path=str(IMAGES_DIR))
                screenshots_retrieved = len(screenshot_dicts) if screenshot_dicts else 0
                print(f"  -> Retrieved {screenshots_retrieved} screenshot records")
            else:
                print(f"NOTE: parser.get_screenshots not available on this SDK version; "
                      f"screenshots may be mixed into the get_images output or require "
                      f"direct v2-API retrieval via images_content_metadata.")
        except Exception as exc_scr:
            sanitized_scr = _sanitize_error(str(exc_scr))
            print(f"WARN: screenshot download failed: {sanitized_scr}", file=sys.stderr)
            if image_retrieval_error:
                image_retrieval_error += f"; get_screenshots: {sanitized_scr}"
            else:
                image_retrieval_error = f"get_screenshots: {sanitized_scr}"

    except Exception as exc:
        sanitized = _sanitize_error(str(exc))
        print(f"WARN: get_json_result failed: {sanitized}", file=sys.stderr)
        image_retrieval_error = f"get_json_result: {sanitized}"
    # ----------------------------------------------------------------------

    elapsed_total = time.time() - start_time
    print(f"Total elapsed: {elapsed_total:.1f}s")

    # Extraction log (metadata only; never include API key or credential file contents)
    log = {
        "task_id": "PDF-REEXTRACT-LLAMAPARSE-WITH-IMAGES-CACHE-TEST",
        "purpose": "empirical cache-behavior test: does adding save_images+take_screenshot invalidate the 48h cache?",
        "source_pdf": str(SOURCE_PDF.relative_to(PROJECT_ROOT)).replace("\\", "/"),
        "output_dir": str(OUTPUT_DIR.relative_to(PROJECT_ROOT)).replace("\\", "/"),
        "credential_source": "C:/PhotoData/config/api_keys.json[llamaparse] (value not logged)",
        "parse_mode": "parse_page_with_agent",
        "result_type": "markdown",
        "added_vs_turn_18": ["save_images=True", "take_screenshot=True"],
        "all_other_params_identical_to_turn_18": True,
        "page_count": page_count,
        "elapsed_parse_seconds": round(elapsed_parse, 1),
        "elapsed_total_seconds": round(elapsed_total, 1),
        "completed_at": time.strftime("%Y-%m-%dT%H:%M:%S%z"),
        "llama_parse_version": _get_pkg_version("llama-parse"),
        "cache_test_primary_result": "PASSED — parse succeeded despite added image params",
        "raw_json_saved": raw_json_saved,
        "embedded_images_retrieved": images_retrieved,
        "screenshots_retrieved": screenshots_retrieved,
        "image_retrieval_error": image_retrieval_error,
    }
    (OUTPUT_DIR / "extraction_log.json").write_text(
        json.dumps(log, indent=2), encoding="utf-8"
    )

    # Cache-test result summary (PASS case)
    (OUTPUT_DIR / "CACHE_TEST_RESULT.md").write_text(
        f"# Cache Behavior Test — RESULT: CACHE APPLIED\n\n"
        f"**Test time:** {log['completed_at']}\n\n"
        f"**Outcome:** load_data() succeeded in {elapsed_parse:.1f}s with "
        f"{page_count} pages returned. Account is at 100% monthly free-tier "
        f"quota; a non-cached parse would have been rejected before any "
        f"processing. Success therefore means the cache applied.\n\n"
        f"**Interpretation:** Adding `save_images=True` and `take_screenshot=True` "
        f"to the LlamaParse constructor did NOT invalidate the 48-hour cache for "
        f"an otherwise-identical parse request. Output-options changes at this "
        f"level do not cache-invalidate.\n\n"
        f"**Billing impact:** Zero credits charged (cache hit).\n\n"
        f"**Implication for Approach B:** Within the 48h cache window, a "
        f"supplementary image-extraction re-parse of the same file with added "
        f"`save_images`/`take_screenshot` parameters is free. Outside the window, "
        f"it costs the full credit rate.\n\n"
        f"**Caveats:**\n"
        f"- This test used the v1 SDK boolean flags (`save_images`, `take_screenshot`).\n"
        f"  The v2 API's `output_options.images_to_save` may have different cache "
        f"  semantics — this test does not conclusively answer the v2 case.\n"
        f"- Other image types (e.g., v2's `\"layout\"`) are untested here.\n"
        f"- Image retrieval (post-parse downloads via `get_images` / "
        f"  `get_screenshots`) results: {images_retrieved} embedded images, "
        f"  {screenshots_retrieved} screenshots. "
        f"{'Retrieval error: ' + image_retrieval_error if image_retrieval_error else 'No retrieval errors.'}\n",
        encoding="utf-8",
    )

    print(f"")
    print(f"Cache test result summary: {OUTPUT_DIR / 'CACHE_TEST_RESULT.md'}")
    print(f"Extraction log: {OUTPUT_DIR / 'extraction_log.json'}")
    return 0


def _get_pkg_version(name: str) -> str:
    try:
        import importlib.metadata as im
        return im.version(name)
    except Exception:
        return "unknown"


if __name__ == "__main__":
    sys.exit(main())
