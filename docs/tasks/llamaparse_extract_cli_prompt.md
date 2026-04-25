# CC Task Prompt: LlamaParse Extract CLI (Generic, Cross-Project Tool)

**Task ID:** LLAMAPARSE-EXTRACT-CLI-V1
**Authored by:** CD Purple, 2026-04-24
**Authoring turn:** Purple Turn 27
**Deliverable location:** `C:\Users\artroom\projects\shared-tools\llamaparse-extract\` (new directory; create `shared-tools\` if it does not exist)
**Task type:** code
**Expected duration:** 2–3 hours

---

## 1. Purpose & Context

Build a generic, reusable LlamaParse CLI tool that replaces the ad-hoc one-off scripts in `flight-sim/scripts/pdf_reextraction/`. The tool will be used across multiple Steve projects, so it lives in a shared-tools directory outside any single project.

Background from flight-sim that informed this task:
- **Turn 18** script (`reextract_gnc355_pdf_llamaparse.py`) used the deprecated `llama-parse 0.6.94` v1 SDK with `parse_mode`, `parsing_instruction`, etc.
- **Turn 24 cache-behavior test** (`reextract_gnc355_pdf_llamaparse_with_images.py`) added `save_images=True, take_screenshot=True`, which invalidated the 48h cache and triggered a quota-exceeded API response.
- **Critical SDK behavior finding:** the v1 SDK **does not raise** on API errors — it prints to stderr and returns an empty list. The Turn 24 script's exception-based detection missed this and wrote the wrong interpretation. The new tool must validate RESULT (not just absence of exception).
- **Deprecation warnings** from Turn 24 run:
  - `llama-parse` package deprecated → use the new unified SDK (`llama-cloud-services`, per https://github.com/run-llama/llama-cloud-py/blob/main/README.md and https://developers.llamaindex.ai/python/cloud/llamaparse/getting_started/).
  - `parsing_instruction` kwarg deprecated → use `system_prompt`, `system_prompt_append`, or `user_prompt`.

## 2. Pre-flight Verification (REQUIRED — do this first)

Before writing any code, CC must:

1. **Confirm the correct SDK package name** by reading:
   - https://developers.llamaindex.ai/python/cloud/llamaparse/getting_started/
   - https://github.com/run-llama/llama-cloud-py/blob/main/README.md
   Identify: package name on PyPI, primary import, the v2-native parse class/function, and async variants.

2. **Confirm the correct v2 prompt kwargs** — which of `system_prompt`, `system_prompt_append`, `user_prompt` is semantically right for "domain-specific parsing guidance added on top of LlamaParse defaults." Note the distinction.

3. **Confirm the error-handling surface of the new SDK**: does it raise on API errors, return a status-bearing result object, or silently return empty like v1? This determines the detection logic. Read the SDK docs/source until you can state definitively.

4. **Confirm multi-file pattern:** the v2 API is one-file-per-request. The SDK probably exposes an async method (`aparse` or similar) and a concurrency-controlled parallel helper. Identify the exact API surface and document any `num_workers` or similar concurrency cap.

5. **Confirm v2 `output_options.images_to_save` categories:** `["screenshot", "embedded", "layout"]` — verify these names and their semantics haven't changed.

6. **Confirm v2 page-range syntax:** v2 uses `page_ranges` (1-indexed). Confirm exact param name and format.

Write findings to `PREFLIGHT_NOTES.md` in the repo root. This is a required deliverable — downstream maintainers and future Claude sessions will benefit.

## 3. Deliverables

All deliverables live under `C:\Users\artroom\projects\shared-tools\llamaparse-extract\`:

1. `llamaparse_extract.py` — main CLI script (importable as a library too).
2. `README.md` — usage guide: quickstart, CLI reference, credential setup, troubleshooting.
3. `PREFLIGHT_NOTES.md` — findings from section 2.
4. `requirements.txt` — pinned deps (minimum: new unified SDK, `pypdf` or `pymupdf` for page-count pre-check, optionally `tomli` if Python < 3.11 for config support).
5. `.gitignore` — standard Python + exclude output directories the tool creates + exclude any credential files.
6. `completion_report.md` — task completion report.
7. Smoke test: `tests/test_smoke.py` + a 2–5-page `tests/sample.pdf` (use any freely-available small PDF; include attribution in README).

Initialize the directory as a git repo via `git init`, make one commit with the D-04 trailer format (see section 9), and **do NOT push**.

## 4. CLI Contract

```
python llamaparse_extract.py <input> [options]
```

`<input>` is either a single PDF path OR (when `--batch` is used) omitted in favor of the batch file.

Options:

| Flag | Type | Default | Purpose |
|------|------|---------|---------|
| `-o`, `--output-dir` | path | derived from input filename | where extraction outputs go |
| `-t`, `--tier` | enum | `agentic` | fast \| cost_effective \| agentic \| agentic_plus |
| `--version` | str | `latest` | tier version pin |
| `-i`, `--images` | csv | `screenshot,embedded,layout` | comma-sep subset of the three, or `all`, or `none` |
| `--system-prompt-append` | str | built-in avionics-neutral default (see §5) | custom domain guidance appended to SDK default |
| `--system-prompt` | str | (unset) | fully replace SDK default system prompt; mutually exclusive with `--system-prompt-append` |
| `--user-prompt` | str | (unset) | per-request user guidance |
| `-l`, `--language` | str | `en` | OCR language code |
| `-p`, `--pages` | str | (all) | v2 page_ranges syntax, e.g. "1,3,5-10" |
| `--batch` | path | (unset) | text file with one PDF path per line (UTF-8, `#`-comments allowed, blank lines ignored). Overrides positional `<input>` when set. |
| `--concurrency` | int | 4 | max parallel parse jobs when batching (respect rate limits) |
| `--dry-run` | flag | off | print request(s) + cost estimate, make NO API call |
| `--cost-estimate-only` | flag | off | local page count × tier rate, no API call |
| `--credential-file` | path | `C:/PhotoData/config/api_keys.json` | path to credential JSON |
| `--credential-key` | str | `llamaparse` | key name within the JSON object |
| `-v`, `--verbose` | flag | off | per-page progress + SDK verbose |
| `-h`, `--help` | flag | — | usage |

### Default `--system-prompt-append`

Use a neutral, domain-agnostic default:
```
Extract all tables, figures, and embedded text with high accuracy. Preserve page numbers, section headers, and cross-references. For figures that are images without OCR text, note the figure content descriptively.
```

The user can override with a project-specific prompt (e.g., the flight-sim avionics-specific one).

## 5. Output Structure (per parsed file)

```
{output_dir}/
├── pages/
│   ├── page_001.md
│   ├── page_002.md
│   └── ...
├── images_embedded/         # only if "embedded" in --images
├── images_screenshot/       # only if "screenshot" in --images
├── images_layout/           # only if "layout" in --images
├── full_markdown.md         # concatenation of pages/ with page markers
├── raw_json_result.json     # whatever the v2 expand parameters return
└── extraction_log.json      # metadata (see §7)
```

If the same input is parsed twice to the same `output_dir`, the second run goes into a `{output_dir}/reruns/{timestamp}/` subdir to prevent overwrites. The tool never overwrites a successful previous extraction.

For `--batch`, each input file gets its own `{output_dir}/{input_stem}/` subdirectory.

## 6. Error Handling Requirements

1. **Result validation, not exception-based detection.** After any parse call, validate: (a) document count > 0, (b) elapsed time consistent with real parsing (cost_effective ≥ 10s for a 100-page doc; agentic ≥ 60s), (c) no error sentinel in the result object or stderr stream. Log all three checks in `extraction_log.json`.

2. **Classify errors explicitly.** Detect and report distinctly:
   - **Credential error** (missing file, missing key, malformed, wrong prefix) — exit code 2, clear remediation message pointing at `--credential-file` / `--credential-key`.
   - **Quota exceeded** — exit code 3, message shows current quota status if retrievable from API.
   - **Network/timeout** — exit code 4, suggest `--dry-run` to verify config before retry.
   - **Input file error** (not found, not a PDF, password-protected) — exit code 2.
   - **API validation error** (bad tier, bad page range) — exit code 2, surface the server's validation message verbatim.
   - **Unknown error** — exit code 5, full sanitized stderr/exception in the log.

3. **Credential sanitization** (D-23): regex-strip any `llx-[A-Za-z0-9_-]+` fragments from all error messages, log entries, and stdout/stderr before printing. Write a unit test for this.

4. **Batch mode partial-failure handling:** one file's failure must not abort the batch. Accumulate per-file results in a `batch_results.json` listing each input and its individual outcome (success | error_class | error_message_sanitized).

## 7. `extraction_log.json` Schema

```json
{
  "task_id": "...",
  "input_path": "...",
  "output_dir": "...",
  "tier": "...",
  "version": "...",
  "images_requested": ["..."],
  "page_ranges": "...",
  "system_prompt_append_used": "... (first 200 chars)",
  "credential_source": "path[key] (value not logged)",
  "sdk_name": "...",
  "sdk_version": "...",
  "completed_at": "ISO-8601 with tz offset",
  "elapsed_seconds": 0.0,
  "page_count_returned": 0,
  "images_retrieved": {"embedded": 0, "screenshot": 0, "layout": 0},
  "cost_estimate_credits": 0,
  "result_validation": {
    "page_count_gt_zero": true,
    "elapsed_plausible": true,
    "no_error_sentinel": true
  },
  "error": null,
  "error_class": null
}
```

## 8. Documentation (`README.md`) Requirements

Sections required:
- **Install:** single block with `pip install -r requirements.txt` + any platform notes.
- **Credentials:** how to populate the credential JSON; example schema (do NOT show real keys); link to https://cloud.llamaindex.ai/ for obtaining a key.
- **Quickstart:** three concrete example commands (single file, dry-run cost estimate, batch).
- **CLI reference:** table mirroring §4 of this prompt.
- **Output structure:** document §5.
- **Tier/pricing:** brief table of credit rates per tier, pointing at https://developers.llamaindex.ai/python/cloud/general/pricing for authoritative current rates. Do not assert specific prices in the README — they drift.
- **Troubleshooting:** one paragraph per error class from §6 with example messages and remediation.
- **Known caveats:** lift from `PREFLIGHT_NOTES.md`.

## 9. Git Initialization & Commit

```
cd C:\Users\artroom\projects\shared-tools\llamaparse-extract
git init -b main
git add .
```

Then create the initial commit using the BOM-free file pattern:

```powershell
$msg = @"
LLAMAPARSE-EXTRACT-CLI-V1: initial generic LlamaParse CLI tool

Builds a reusable cross-project LlamaParse extraction CLI using
the new unified SDK and v2 API. Replaces the ad-hoc one-off
scripts in flight-sim/scripts/pdf_reextraction/.

Task-Id: LLAMAPARSE-EXTRACT-CLI-V1
Authored-By-Instance: cc
Co-Authored-By: Claude Code <noreply@anthropic.com>
"@
[System.IO.File]::WriteAllText(".git/COMMIT_EDITMSG_cc", $msg)
git commit -F .git/COMMIT_EDITMSG_cc
Remove-Item .git/COMMIT_EDITMSG_cc
```

**Do NOT `git push`.** No remote is configured; Steve will set one up manually if desired.

## 10. ntfy Completion Notification (REQUIRED)

After the git commit succeeds:

```powershell
Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "LLAMAPARSE-EXTRACT-CLI-V1 completed [shared-tools]"
```

## 11. Outputs Considered (D-24 — no billable API calls made during task)

**This task does NOT make any billable LlamaParse API calls.** No actual parsing is performed during implementation. The smoke test in §12 uses `--dry-run` and `--cost-estimate-only` modes exclusively (zero API calls). Real parse validation is deferred to Steve's first real use.

If CC wants to verify the SDK end-to-end with one actual parse, Steve must explicitly authorize it in a follow-up instruction. Do not unilaterally make a billable call.

## 12. Smoke Test Requirements

`tests/test_smoke.py` must verify, using ZERO billable API calls:

1. CLI with `--help` exits 0 and prints usage.
2. CLI with `--cost-estimate-only` on `tests/sample.pdf` exits 0 and prints a non-zero credit estimate.
3. CLI with `--dry-run` on `tests/sample.pdf` exits 0 and prints the API request body it WOULD send.
4. CLI with `--batch tests/sample_batch.txt` (a file listing `tests/sample.pdf` twice) in dry-run mode prints two would-be requests.
5. Missing credential file → exit 2, error class "credential".
6. Missing input file → exit 2, error class "input".
7. Invalid tier → argparse error, exit 2.
8. Credential-sanitization unit test: feed a string containing `llx-abc123_def-XYZ` through the sanitizer; assert the output contains `llx-<REDACTED>` and no part of the original suffix.

Run the smoke test as the final validation step before writing the completion report. All tests must pass.

## 13. Self-Review Checklist (CC must check each item before writing completion report)

- [ ] `PREFLIGHT_NOTES.md` written and documents all six §2 verification items.
- [ ] `llamaparse_extract.py` uses the new unified SDK (not `llama-parse` 0.6.x).
- [ ] No use of deprecated `parsing_instruction` kwarg.
- [ ] Uses `system_prompt_append` (or the correct v2 equivalent confirmed in pre-flight).
- [ ] All 16 CLI flags from §4 implemented.
- [ ] `--batch` supports one-file-per-line text files with comments and blanks.
- [ ] Batch concurrency respects `--concurrency` flag.
- [ ] Result-validation logic (§6.1) implemented and logged.
- [ ] All 6 error classes detected and reported distinctly (§6.2).
- [ ] Credential sanitization applied everywhere (§6.3) and unit-tested.
- [ ] Partial-failure handling in batch mode (§6.4) + `batch_results.json` written.
- [ ] Output structure per §5 (never overwrites previous successful extraction).
- [ ] `extraction_log.json` schema per §7.
- [ ] README has all 8 required sections (§8).
- [ ] `.gitignore` excludes credential files, output directories, `__pycache__`, `.pytest_cache`.
- [ ] `requirements.txt` pins versions.
- [ ] Importable as a library: `from llamaparse_extract import extract` works from a different cwd.
- [ ] All 8 smoke tests pass.
- [ ] Zero billable API calls made during implementation.
- [ ] Git repo initialized, one commit made, D-04 trailer format used.
- [ ] ntfy notification sent after commit.

## 14. Completion Report Requirements

Write `completion_report.md` inside the repo dir (`shared-tools/llamaparse-extract/completion_report.md`).

Required sections:
1. **Summary** — 3–5 sentences on what was built.
2. **Pre-flight findings** — key answers to §2 verification items, with links to sources cited.
3. **Deviations from prompt** — any §4–§13 item where CC diverged, with rationale. If none, say so.
4. **Self-review checklist** — paste the §13 list with each item checked ✓ or flagged ✗ with explanation.
5. **Smoke test results** — which of the 8 tests passed; copy/paste output for any that didn't.
6. **Usage examples verified** — the three README quickstart commands, each with actual output.
7. **Known limitations / TODOs** — things left for a v2 iteration.
8. **Cost** — confirm zero billable API calls were made; if any were made despite §11, list them with justification.

## 15. Invariants (do not violate)

- No real LlamaParse API calls during implementation without explicit Steve authorization (§11).
- Never print, log, or stringify the API key value anywhere. D-23 pattern.
- Use the new unified SDK exclusively — no fallback to `llama-parse` 0.6.x.
- No forward-references to features not yet built; each flag/output documented exists at completion.
- Output structure never overwrites a successful prior extraction (§5 rerun-subdir rule).
- Every error path has a distinct exit code (§6.2).

---

## Launch Command

After reading this prompt end-to-end, begin work. Write `PREFLIGHT_NOTES.md` first — do not write any Python code until pre-flight verification is complete and documented.
