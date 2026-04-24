"""
Re-extract Garmin GNC 375/GPS 175/GNC 355/GNX 375 Pilot's Guide PDF
via LlamaParse Agentic tier.

Authorizing decision: D-22 §(1)
Task ID: PDF-REEXTRACT-LLAMAPARSE-V1
Source PDF: assets/Garmin GNC 375 - ... .pdf
Output: assets/gnc355_pdf_extracted/llamaparse_agentic_v1/

CREDENTIAL HANDLING:
The LlamaParse API key is loaded from C:/PhotoData/config/api_keys.json
under the key name 'llamaparse'. The value is read into a local variable,
passed directly to the LlamaParse SDK, and NEVER printed, logged, or
stringified to any output stream. Per cc_safety_discipline.md.
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
OUTPUT_DIR = PROJECT_ROOT / "assets" / "gnc355_pdf_extracted" / "llamaparse_agentic_v1"
PAGES_DIR = OUTPUT_DIR / "pages"


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
        # Never include the file contents in the error message
        raise RuntimeError(
            f"credential file is not valid JSON (line {exc.lineno})"
        ) from None
    except OSError as exc:
        # Permission denied, etc. — never include file contents
        raise RuntimeError(f"credential file could not be opened: {exc.strerror}") from None

    if not isinstance(creds, dict):
        raise RuntimeError("credential file root is not a JSON object")

    if CREDENTIAL_KEY_NAME not in creds:
        raise RuntimeError(f"'{CREDENTIAL_KEY_NAME}' key missing from credential file")

    key = creds[CREDENTIAL_KEY_NAME]

    # Drop the parsed dict reference immediately so no other keys linger.
    creds = None

    # Format-shape checks (label-only; never expose value).
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

    # Import here so the script can print friendly errors on pre-flight before requiring the dep.
    from llama_parse import LlamaParse

    print(f"Starting LlamaParse Agentic-tier extraction of {SOURCE_PDF.name}")
    print(f"Output: {OUTPUT_DIR}")
    start_time = time.time()

    # Configure parser.
    # parse_mode="parse_page_with_agent" is the current v2 SDK name for what the
    # legacy SDK called premium_mode=True. Maps to the v2 "agentic" tier.
    # result_type="markdown" produces structured markdown output per page.
    # api_key is passed as a local kwarg; never via env var export or print.
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
    )

    # Drop our local reference to the key. The parser instance has captured it
    # internally; we don't need it on the stack anymore.
    api_key = None

    # Run extraction (blocking; SDK handles polling).
    try:
        documents = parser.load_data(str(SOURCE_PDF))
    except Exception as exc:
        # Defensive: if the SDK ever includes the key in an exception message,
        # strip it before printing. The regex redacts any llx-... fragments.
        sanitized = _sanitize_error(str(exc))
        print(f"ERROR: LlamaParse extraction failed: {sanitized}", file=sys.stderr)
        return 3

    elapsed = time.time() - start_time
    print(f"Extraction complete: {len(documents)} documents in {elapsed:.1f}s")

    # Save per-page markdown. LlamaParse returns one "document" per page for
    # parse_page_with_agent mode, so len(documents) ≈ page count.
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

    # Write extraction log (metadata only; never include API key or credential file contents)
    log = {
        "task_id": "PDF-REEXTRACT-LLAMAPARSE-V1",
        "source_pdf": str(SOURCE_PDF.relative_to(PROJECT_ROOT)).replace("\\", "/"),
        "output_dir": str(OUTPUT_DIR.relative_to(PROJECT_ROOT)).replace("\\", "/"),
        "credential_source": "C:/PhotoData/config/api_keys.json[llamaparse] (value not logged)",
        "parse_mode": "parse_page_with_agent",
        "result_type": "markdown",
        "page_count": page_count,
        "elapsed_seconds": round(elapsed, 1),
        "completed_at": time.strftime("%Y-%m-%dT%H:%M:%S%z"),
        "llama_parse_version": _get_pkg_version("llama-parse"),
    }
    (OUTPUT_DIR / "extraction_log.json").write_text(
        json.dumps(log, indent=2), encoding="utf-8"
    )

    # Write human-readable report
    report = f"""# LlamaParse Agentic Re-extraction Report

**Task ID:** PDF-REEXTRACT-LLAMAPARSE-V1
**Authorizing decision:** D-22 §(1)
**Completed:** {log['completed_at']}

## Run Summary

- Source PDF: `{log['source_pdf']}`
- Output directory: `{log['output_dir']}`
- Credential source: `{log['credential_source']}`
- Parse mode: `parse_page_with_agent` (v2 `agentic` tier equivalent)
- Result type: `markdown`
- Pages extracted: {page_count}
- Elapsed: {elapsed:.1f}s ({elapsed/60:.1f} min)
- llama-parse SDK version: {log['llama_parse_version']}

## Outputs

- Per-page markdown: `pages/page_001.md` through `pages/page_{page_count:03d}.md`
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
"""
    (OUTPUT_DIR / "extraction_report.md").write_text(report, encoding="utf-8")

    print(f"Extraction report: {OUTPUT_DIR / 'extraction_report.md'}")
    return 0


def _get_pkg_version(name: str) -> str:
    try:
        import importlib.metadata as im
        return im.version(name)
    except Exception:
        return "unknown"


if __name__ == "__main__":
    sys.exit(main())
