# CC Task Prompt: PDF Re-extraction via LlamaParse Agentic Tier

**Created:** 2026-04-24T07:46:47-04:00
**Revised:** 2026-04-24T10:19:02-04:00 (Turn 16 — API key source changed from env var to credential file at `C:\PhotoData\config\api_keys.json` with key name `llamaparse`)
**Source:** CD Purple session — Turn 15–16 (2026-04-24)
**Task ID:** PDF-REEXTRACT-LLAMAPARSE-V1
**Authorizing decision:** D-22 §(1) — upstream PDF re-extraction for C3 spec review
**Predecessor:** None (this is pre-C3 work; independent of C2.2-F/G)
**Depends on:** `assets/Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf` (25.5 MB source PDF); `llamaparse` key in the credential file at `C:\PhotoData\config\api_keys.json`.
**Priority:** High — pre-C3 critical path per D-22
**Estimated scope:** Small-medium — installs llama-parse; writes a Python script (~130 lines); runs extraction (~310 pages, ~5–15 min API wall-clock at agentic tier); saves output; commits.
**Task type:** script + run; produces versioned extraction output in `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/`
**CRP applicability:** Not required

---

## Purpose

The existing PDF extraction at `assets/gnc355_pdf_extracted/text_by_page.json` was produced by `scripts/gnc355_pdf_extract.py` using a non-OCR text extraction pipeline. Known limitations include:

- Table extraction quality is inconsistent (triggering ITM-10: §4.10 Unit Selections shows partial categories vs. PDF p. 94)
- Image-heavy pages (e.g., p. 125 Land Data Symbols) produce no text; required manual PNG supplement
- Several pages flagged sparse in Fragment A Appendix C (pp. 1, 36, 110, 208, 222, 270, 292, 298, 308, 309, 310)
- Cross-reference resolution is lexical (no understanding of context)

Per D-22 §(1), resubmit the source PDF to **LlamaParse Agentic tier** for C3 review. Agentic tier uses an LLM-assisted parsing pipeline (via the LlamaParse v2 API or the deprecated-but-still-functional `llama-parse` Python SDK) to produce higher-accuracy output on table-dense and image-heavy pages.

The new extraction becomes the **source of truth for C3 spec review** (not for archived fragment compliance — those remain bound to the original extraction). Un-gitignored for this pass; re-run to regenerate if lost.

---

## Source of Truth

### Inputs

1. **Source PDF:** `assets/Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf`
   - Size: 25.5 MB
   - Pages: ~310
   - Document ID: 190-02488-01 Rev. C (Garmin Pilot's Guide — GPS 175, GNC 355, GNC 355A, GNX 375)

2. **API key:** loaded from the credential file at `C:\PhotoData\config\api_keys.json` under the key name `llamaparse`.
   - Expected file format: `{ "llamaparse": "llx-...", ... }` — other keys may be present; only `llamaparse` is read.
   - Expected key value begins with `llx-`.
   - **CRITICAL — credential file handling (per `cc_safety_discipline.md` §Credential File Protection):**
     - **NEVER** directly `cat`, `view`, `read_text_file`, `Get-Content`, `type`, open in an editor, or otherwise display the file's contents. Not even to diagnose a problem. Not even to verify the format.
     - **NEVER** print, log, echo, or include the key value in any script `print` / `Write-Host` / `Console.WriteLine` / stderr output / commit message / report / ntfy body.
     - **ONLY** acceptable access pattern: the Python script in Phase A opens the file with `json.load`, extracts the `llamaparse` field into a local variable, passes it directly to the `LlamaParse(api_key=...)` constructor, and immediately nulls its local reference. No intermediate stringification, no logging of the variable, no exception message that could leak the value.
     - The script validates structure WITHOUT exposing values: confirm the `llamaparse` key exists; confirm its value is a string; confirm length >= 20 chars; confirm it starts with `llx-`. Report format-failures with labels only — `"llamaparse key missing"` / `"llamaparse key malformed"` / `"llamaparse key too short"` / `"llamaparse key wrong prefix"` — never the value itself, and never any part of the file contents.
   - If the file is missing, unreadable, or `llamaparse` key is absent/malformed: STOP and write a deviation report at `docs/tasks/pdf_reextraction_llamaparse_prompt_deviation.md` describing the format-check failure (NOT the key contents or file contents). Do NOT attempt to work around it.
   - If Steve needs to create/rotate the `llamaparse` key: https://cloud.llamaindex.ai/api-key

3. **LlamaParse docs:**
   - v2 tier overview: https://developers.llamaindex.ai/llamaparse/parse/guides/tiers/
   - Getting started: https://docs.cloud.llamaindex.ai/llamaparse/getting_started
   - Python SDK: https://pypi.org/project/llama-parse/ (deprecated May 1, 2026; still functional)
   - Advanced parsing modes: https://docs.cloud.llamaindex.ai/llamaparse/parsing/advance_parsing_modes
   - The `premium_mode=True` in the legacy SDK is equivalent to `parse_mode="parse_page_with_agent"`, which maps to the v2 `agentic` tier.

### Outputs (new paths; preserve existing extraction)

Create a sub-directory under the existing gitignored extraction path:

- **Primary output directory:** `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/`
- **Per-page markdown:** `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages/page_001.md`, `page_002.md`, …, `page_310.md` (zero-padded to 3 digits; actual last page number determined by the PDF)
- **Aggregated markdown:** `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/full_markdown.md` (concatenation with per-page separator comments)
- **Extraction metadata:** `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/extraction_log.json` — structured log of API call, duration, page count, credit usage (if reported), any errors per page
- **Human-readable report:** `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/extraction_report.md` — short summary CD/Steve can read

Do NOT delete or modify the existing `assets/gnc355_pdf_extracted/text_by_page.json` or `assets/gnc355_pdf_extracted/extraction_report.md`. The original extraction remains the archival compliance record.

---

## Pre-flight Verification

Execute these checks before running any extraction. If any fails, STOP and write `docs/tasks/pdf_reextraction_llamaparse_prompt_deviation.md`.

1. Verify source PDF exists:
   ```bash
   ls -l "assets/Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf"
   ```
   Expect ~25.5 MB file.

2. Verify credential file exists and has non-trivial size, WITHOUT opening its contents:
   ```powershell
   Test-Path "C:\PhotoData\config\api_keys.json"
   (Get-Item "C:\PhotoData\config\api_keys.json").Length
   ```
   Expect: `True`; file length > 20 bytes (non-empty).

   **Do NOT `Get-Content`, `cat`, `type`, or `read_text_file` this file.** This is a hard safety rule per `cc_safety_discipline.md` §Credential File Protection.

   The actual `llamaparse` key format validation happens inside the extraction script (Phase A below), which opens the file via `json.load`, extracts only the `llamaparse` field, and validates format without printing the value or any other file contents.

3. Verify `llama-parse` package is installed OR install it:
   ```powershell
   pip show llama-parse 2>&1 | Select-String "Name"
   ```
   If not installed:
   ```powershell
   pip install --upgrade llama-parse
   ```
   Note the deprecation notice (package maintained through May 1, 2026). Proceed; this one-time extraction will complete well before deprecation.

4. Verify output directory does not yet exist (or is empty):
   ```powershell
   Test-Path "assets/gnc355_pdf_extracted/llamaparse_agentic_v1"
   ```
   If present and non-empty: STOP; if Steve wants to re-run, he must delete the directory first. Do not overwrite silently.

---

## Phase 0: Source-of-Truth Audit

1. Read this prompt.
2. Read `docs/decisions/D-22-c3-spec-review-customization-for-gnx375-functional-spec.md` §(1) to confirm the re-extraction rationale.
3. Read `docs/decisions/D-06-gitignore-pdf-extraction-output.md` — confirm the regenerable-extraction-output pattern applies to the new directory.
4. Read `cc_safety_discipline.md` §Credential File Protection — confirm you understand the "never read, never print, script-only" handling rule for `C:\PhotoData\config\api_keys.json`.
5. Print "Phase 0: source-of-truth audit complete" and proceed, OR write deviation report and STOP.

---

## Implementation Order

Execute phases sequentially.

### Phase A: Write the extraction script

Create `scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse.py`.

**Structure:**

```python
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
```

Save the script. **Do not execute inline via `python -c`** (per CLAUDE.md conventions; PowerShell quoting makes inline commands fragile).

### Phase B: Run the extraction

```powershell
cd C:\Users\artroom\projects\flight-sim-project\flight-sim
python scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse.py
```

Expected wall-clock: ~5–15 min for a ~310-page document at agentic tier. API is server-side; your script polls until complete.

If the script errors out partway:
- `extraction_log.json` will not be written (script only writes it on successful completion).
- LlamaParse caches results for 48h by default; re-running within that window re-uses cached pages at zero credit cost.
- Any key-redaction in error messages is automatic via the `_sanitize_error` helper.

### Phase C: Verify the output

```powershell
# Page count sanity check
(Get-ChildItem assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages -Filter page_*.md).Count

# Aggregate file size (should be ~500 KB – 2 MB range for ~310 pages of markdown)
(Get-Item assets/gnc355_pdf_extracted/llamaparse_agentic_v1/full_markdown.md).Length

# Sanity-check one key page (p. 94 Unit Selections — related to ITM-10)
Get-Content assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages/page_094.md
# Look for Unit Selections table — should show all 7 categories per D-22 rationale
```

Note the p. 94 check is an informal spot-check for ITM-10 relevance; a full ITM-10 resolution is not this task's responsibility (it's a C3 review concern).

### Phase D: Update .gitignore (if warranted)

The parent directory `assets/gnc355_pdf_extracted/` is gitignored per D-06. The new sub-directory inherits the ignore. This is correct per D-06 pattern (regenerable; re-run script to reproduce).

**No .gitignore changes required.** The new extraction is treated as regenerable output like the original.

---

## Completion Protocol

1. **Save the script** to `scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse.py`.
2. **Run the extraction** (Phase B). Confirm success (exit code 0; `extraction_log.json` and `extraction_report.md` written).
3. **Verify output** (Phase C).
4. **Commit the script only** (extraction output is gitignored):
   ```powershell
   git add scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse.py docs/tasks/pdf_reextraction_llamaparse_prompt.md
   ```
   (Also add a completion report file — see step 5.)
5. **Write completion report** to `docs/tasks/pdf_reextraction_llamaparse_completion.md`:

   ```markdown
   ---
   Created: {ISO 8601}
   Source: docs/tasks/pdf_reextraction_llamaparse_prompt.md
   ---

   # PDF Re-extraction via LlamaParse — Completion Report

   **Task ID:** PDF-REEXTRACT-LLAMAPARSE-V1
   **Completed:** {ISO 8601 date}

   ## Pre-flight Results

   {table of 4 pre-flight checks with PASS/FAIL. For check 2 (credential
   file presence), report ONLY the Test-Path result and file size — do
   NOT include file contents, and do NOT include the llamaparse key
   value or any JSON snippet.}

   ## Extraction Run

   | Metric | Value |
   |--------|-------|
   | llama-parse SDK version | {version} |
   | Parse mode | parse_page_with_agent |
   | Result type | markdown |
   | Credential source | C:/PhotoData/config/api_keys.json[llamaparse] (value not logged) |
   | Pages extracted | {N} |
   | Elapsed wall-clock | {seconds} s ({minutes} min) |
   | Output directory | `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/` |

   ## Output Verification

   - Per-page files: {count} / expected {N}
   - Aggregate full_markdown.md size: {bytes}
   - extraction_log.json present: {yes/no}
   - extraction_report.md present: {yes/no}

   ## Spot Check — p. 94 Unit Selections (ITM-10 context)

   Quote the Unit Selections content from `pages/page_094.md`. Compare
   informally against what Fragment C §4.10 and Fragment E §10.6
   documented. This is informational only; full ITM-10 resolution is
   a C3 review concern, not this task's responsibility.

   ## Deviations from Prompt

   {None, or table of any deviations}
   ```

6. **Commit** with D-04 trailer format (write commit message to temp file via `[System.IO.File]::WriteAllText()`, BOM-free):

   ```
   PDF-REEXTRACT-LLAMAPARSE-V1: re-extract pilot's guide via LlamaParse Agentic tier

   Per D-22 §(1): upstream PDF re-extraction for C3 spec review, using
   LlamaParse's agentic-tier parsing (parse_mode="parse_page_with_agent",
   equivalent to legacy premium_mode=True). Source: Garmin Pilot's Guide
   190-02488-01 Rev. C (~310 pages). Output: per-page markdown +
   aggregate + extraction log/report in
   assets/gnc355_pdf_extracted/llamaparse_agentic_v1/ (gitignored per
   D-06 regenerable-extraction pattern).

   This extraction is C3-review-only source-of-truth. Archived fragment
   compliance (Fragments A-G) remains bound to the original
   text_by_page.json extraction and is not re-verified against this run.

   API key loaded from C:/PhotoData/config/api_keys.json under key name
   'llamaparse' (per cc_safety_discipline.md credential file protection:
   value read once via json.load into local variable, passed directly to
   SDK, never printed/logged/stringified; error messages sanitized to
   redact any llx-... fragments defensively).

   Task-Id: PDF-REEXTRACT-LLAMAPARSE-V1
   Authored-By-Instance: cc
   Refs: D-06, D-22, ITM-10
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```

   PowerShell pattern (mandatory per CLAUDE.md — do not use inline `python -c` or `-m` multi-flag commit):
   ```powershell
   $msg = @'
   ...commit message above with actual values substituted...
   '@
   [System.IO.File]::WriteAllText((Join-Path $PWD ".git\COMMIT_EDITMSG_cc"), $msg)
   git commit -F .git\COMMIT_EDITMSG_cc
   Remove-Item .git\COMMIT_EDITMSG_cc
   ```

7. **Flag refresh check:** This task does NOT modify CLAUDE.md / claude-project-instructions.md / claude-conventions.md / cc_safety_discipline.md / claude-memory-edits.md. Do NOT create refresh flags.

8. **Send completion notification:**
   ```powershell
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "PDF-REEXTRACT-LLAMAPARSE-V1 completed [flight-sim]"
   ```

9. **Do NOT git push.** Steve pushes manually.

---

## Parallel-CC-Session Note

This task runs in a **separate CC session** from the C2.2-F compliance task. File-level conflict check (CD-verified before authoring this prompt):

- This task writes: `scripts/pdf_reextraction/*.py`, `docs/tasks/pdf_reextraction_llamaparse_*.md`, `assets/gnc355_pdf_extracted/llamaparse_agentic_v1/*`
- C2.2-F compliance task writes: `docs/tasks/c22_f_compliance.md`, `scripts/compliance/c22_f/*`

**Disjoint. Safe to parallelize.**

Both tasks commit independently. If their commits interleave, that's fine — no shared files modified. If git pull/push conflicts arise (Steve's end), they'll be mechanical to resolve.

---

## Estimated duration

- CC wall-clock: ~10–20 min total (2–3 min script authoring; 5–15 min LlamaParse API extraction; 2 min verification + commit + ntfy).
- CD coordination cost after: ~0.5 turn to review completion report and decide on any follow-up (e.g., spot-checking p. 94 vs. p. 125).

Proceed when ready.
