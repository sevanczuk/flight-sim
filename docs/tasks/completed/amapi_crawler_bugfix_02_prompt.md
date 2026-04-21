# CC Task Prompt: AMAPI Crawler TLS Configuration

**Location:** `docs/tasks/amapi_crawler_bugfix_02_prompt.md`
**Task ID:** AMAPI-CRAWLER-BUGFIX-02
**Parent task:** AMAPI-CRAWLER-01 (completed); AMAPI-CRAWLER-BUGFIX-01 (completed)
**Depends on:** AMAPI-CRAWLER-BUGFIX-01 (must be complete; this task extends its code)
**Priority:** Blocks full fetch launch; TLS verification is currently failing on the target machine
**Estimated scope:** Small — 20–30 min; two CLI flags, PEM file placement, fetch.py plumbing, tests
**Task type:** code
**Source of truth:**
- `docs/decisions/D-03-amapi-crawler-db-schema.md`
- `docs/tasks/amapi_crawler_prompt.md` (original crawler task)
- `docs/tasks/amapi_crawler_bugfix_01_prompt.md` (first bugfix — adds context for Phase B robots.txt logic)
- `docs/tasks/amapi_crawler_bugfix_01_completion.md` (reports the SSL issue that drove this task)
**Supporting assets:**
- `C:\Users\artroom\wiki-cert-chain.pem` — the PEM file previously extracted from the wiki's TLS chain (leaf + Sectigo intermediate + USERTrust root). This task moves it into the project.
- `scripts/amapi_crawler.py` + `scripts/amapi_crawler_lib/` — existing code to modify
- `tests/test_amapi_crawler.py` — existing tests
**Audit level:** self-check only — rationale: small, targeted change extending already-reviewed code. Low risk.

---

## Pre-flight Verification

**Execute these checks before writing any code. If any check fails, STOP and write a deviation report.**

1. Verify parent task artifacts exist:
   - `ls docs/tasks/amapi_crawler_prompt.md`
   - `ls docs/tasks/amapi_crawler_bugfix_01_prompt.md`
   - `ls docs/tasks/amapi_crawler_bugfix_01_completion.md`
   - `ls scripts/amapi_crawler.py`
   - `ls -d scripts/amapi_crawler_lib/`
   - `ls scripts/amapi_crawler_lib/fetch.py`
   - `ls tests/test_amapi_crawler.py`
2. Verify PEM file exists at expected location:
   - `ls "C:\Users\artroom\wiki-cert-chain.pem"` — should report a ~6 KB file
3. Verify PEM content is a valid cert chain (3 certs expected: leaf, intermediate, root):
   - Read the file; count occurrences of `-----BEGIN CERTIFICATE-----`. Expect 3. If 0 or !=3, STOP — PEM is malformed.
4. Verify destination doesn't exist yet:
   - `ls assets/air_manager_api/wiki-cert-chain.pem` should FAIL (file not present). If it already exists, note in deviation report but do not overwrite without CD review.
5. Verify test baseline: `python -m pytest tests/test_amapi_crawler.py -v` — expect 97 passed (from BUGFIX-01). Record actual count.
6. Verify no blocking issues: read `docs/todos/issue_index.md` if it exists.

**If any check fails:** Write `docs/tasks/amapi_crawler_bugfix_02_prompt_deviation.md` and STOP.

---

## Phase 0: Source-of-Truth Audit

Read all four source-of-truth documents. Extract actionable requirements for the three scope items (CA bundle flag, insecure flag, PEM placement). Cross-reference against the Implementation Phases below. If any requirement is uncovered, write `docs/tasks/amapi_crawler_bugfix_02_prompt_phase0_deviation.md` and STOP.

---

## Instructions

Add TLS configuration flexibility to the AMAPI crawler. Three deliverables:

1. **Move the existing PEM into the project** at `assets/air_manager_api/wiki-cert-chain.pem` so the crawler is self-contained and works on any checkout.
2. **`--ca-bundle PATH`** flag that overrides the default CA bundle for both the robots.txt fetch and the main fetch loop. Default value: the project PEM if present, otherwise certifi's bundle (normal behavior).
3. **`--insecure`** flag that disables TLS verification entirely. Last-resort escape hatch; emits a prominent warning to `crawl_log.txt` and stderr at startup.

The two flags are mutually exclusive. `--insecure` wins if both are specified, with a warning logged.

**Also read `CLAUDE.md`** for conventions (especially the new D-04 commit trailer policy in §Conventions and §Git). **Also read `cc_safety_discipline.md`** at the project root. **Also read `claude-conventions.md`** §Git Commit Trailers section.

---

## Integration Context

- **Platform:** Windows PowerShell. Python in `.py` files only.
- **Python environment:** `requests` is already installed from the parent task. No new dependencies.
- **The PEM file:** 3-certificate chain (leaf `*.siminnovations.com`, intermediate Sectigo RSA DV, root USERTrust RSA CA). Safe to commit to the repo — public-site cert chain, not a secret. ~6 KB text.
- **The SSL problem:** Python's bundled certifi on this machine does not include the USERTrust RSA root, causing `CERTIFICATE_VERIFY_FAILED` on every `requests` call to the wiki. Pointing `verify=` at the project PEM resolves this. Verified working: `requests.get('https://wiki.siminnovations.com/', verify='C:/Users/artroom/wiki-cert-chain.pem')` returns 200 with 25,858 bytes.
- **Key files this task creates or modifies:**
  - MOVED: `C:\Users\artroom\wiki-cert-chain.pem` → `assets/air_manager_api/wiki-cert-chain.pem`
  - MODIFIED: `scripts/amapi_crawler_lib/fetch.py` — add `verify` parameter plumbing
  - MODIFIED: `scripts/amapi_crawler.py` — add `--ca-bundle` and `--insecure` flags; resolve the effective verify value at startup; pass it through
  - MODIFIED: `tests/test_amapi_crawler.py` — add tests for flag resolution logic
  - NEW: `docs/tasks/amapi_crawler_bugfix_02_completion.md` — completion report

---

## Implementation Order

**Execute phases sequentially.**

### Phase A — Move the PEM into the project

1. Copy `C:\Users\artroom\wiki-cert-chain.pem` to `assets/air_manager_api/wiki-cert-chain.pem`. Use Python (`shutil.copy2`) or PowerShell `Copy-Item`.
2. Verify the destination file is byte-identical to the source via sha256.
3. DO NOT delete the source PEM in `C:\Users\artroom\` — leave it for now. CD will decide whether to remove it after the task completes.
4. Add a one-line comment at the top of the PEM file noting its origin is problematic — PEM files have strict format. SKIP this step. Instead, create a sidecar `assets/air_manager_api/wiki-cert-chain.README.md` with:
   ```
   # wiki.siminnovations.com TLS certificate chain
   
   **Created:** {ISO 8601 timestamp}
   **Source:** docs/tasks/amapi_crawler_bugfix_02_prompt.md
   
   This PEM file contains the three-cert chain for `wiki.siminnovations.com`
   as observed on 2026-04-20: leaf (`*.siminnovations.com`, valid through
   2026-05-26), Sectigo RSA Domain Validation intermediate, USERTrust RSA
   Certification Authority root.
   
   Used by `scripts/amapi_crawler.py` as the CA bundle for TLS verification
   when Python's bundled `certifi` trust store does not include USERTrust
   (common on Windows). See `docs/tasks/amapi_crawler_bugfix_02_*.md` for
   the investigation that led to this file's creation.
   
   **Regeneration:** if the wiki's cert is renewed, extract a fresh chain
   with the PowerShell script in
   `docs/tasks/amapi_crawler_bugfix_02_prompt.md` (Turn 32 diagnostic).
   Alternatively, if Python's certifi bundle is updated to include
   USERTrust or the host's cert chain changes to an already-trusted root,
   this file can be deleted.
   ```

### Phase B — fetch.py plumbing

In `scripts/amapi_crawler_lib/fetch.py`:

1. Add a `verify` parameter to `fetch_page` (or whatever the existing fetch function is called). Valid values:
   - `True` (default) → use certifi bundle (current behavior)
   - `False` → skip verification (suppress `InsecureRequestWarning` at call site)
   - `str` → path to a CA bundle file
2. Pass `verify` through to `requests.get(...)`.
3. When `verify is False`: before the request, suppress `urllib3.exceptions.InsecureRequestWarning` for this call via `urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)` (module-level, done once at crawler startup when `--insecure` is set — see Phase C).

### Phase C — crawler.py flags and resolution

In `scripts/amapi_crawler.py`:

1. Add CLI flags to `argparse`:
   - `--ca-bundle PATH` — explicit path to a CA bundle PEM file. Type: `str`. Default: `None`.
   - `--insecure` — store_true flag. Default: `False`.
2. Add a resolver function `resolve_verify(args) -> bool | str`:
   ```python
   def resolve_verify(args, log_path):
       project_pem = Path('assets/air_manager_api/wiki-cert-chain.pem')
       
       if args.insecure and args.ca_bundle:
           _log(log_path, "WARNING: both --insecure and --ca-bundle specified; --insecure wins")
       
       if args.insecure:
           _log(log_path, "WARNING: TLS certificate verification DISABLED via --insecure flag")
           # Suppress urllib3 warnings at module level
           import urllib3
           urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
           # Also print to stderr so it's visible at run start
           import sys
           sys.stderr.write("WARNING: running with --insecure; TLS verification is OFF\n")
           return False
       
       if args.ca_bundle:
           bundle_path = Path(args.ca_bundle)
           if not bundle_path.exists():
               raise SystemExit(f"ERROR: --ca-bundle path does not exist: {bundle_path}")
           _log(log_path, f"TLS: using CA bundle from {bundle_path}")
           return str(bundle_path)
       
       if project_pem.exists():
           _log(log_path, f"TLS: using project CA bundle at {project_pem}")
           return str(project_pem)
       
       _log(log_path, "TLS: using certifi default CA bundle")
       return True
   ```
3. Call `resolve_verify(args, args.log)` once at startup; store the result in a local `verify` variable; pass through to:
   - The robots.txt fetch (call to `_load_robots_parser`)
   - Every `fetch_page` call in the main loop
4. Thread the `verify` parameter through `_load_robots_parser` to the `requests.get` it makes internally.
5. If the result is `False` (insecure mode), also make sure any incidental `requests` calls anywhere in the crawler honor it — audit the code for stray `requests.get(...)` without a `verify=` argument, and pass the resolved verify value.

### Phase D — Tests

Add to `tests/test_amapi_crawler.py`:

1. **`TestResolveVerify`:**
   - `test_insecure_flag_returns_false` — `--insecure` set, no `--ca-bundle` → returns False
   - `test_insecure_wins_over_ca_bundle` — both set → returns False with warning logged
   - `test_ca_bundle_flag_returns_path` — `--ca-bundle /some/path.pem` with file existing → returns the path as str
   - `test_ca_bundle_missing_file_exits` — `--ca-bundle /does/not/exist.pem` → raises SystemExit
   - `test_project_pem_fallback` — no flags set, project PEM exists in temp tree → returns project PEM path
   - `test_certifi_default_fallback` — no flags, no project PEM → returns True
2. **`TestFetchVerifyParameter`:**
   - Mock `requests.get` to capture the `verify` kwarg
   - Call `fetch_page` with `verify=True` → assert `requests.get` received `verify=True`
   - Call `fetch_page` with `verify='/path/to/bundle.pem'` → assert `requests.get` received `verify='/path/to/bundle.pem'`
   - Call `fetch_page` with `verify=False` → assert `requests.get` received `verify=False`

Use `tmp_path` + monkeypatch for project-PEM tests so they don't touch the real filesystem.

### Phase E — Smoke tests

Three smoke tests, each a short run against the real wiki:

1. **Default (project PEM):**
   ```
   python scripts/amapi_crawler.py --max-wall-clock-hours 0.01
   ```
   Expected: `crawl_log.txt` contains `TLS: using project CA bundle at assets/air_manager_api/wiki-cert-chain.pem`. At least one URL fetched with HTTP 200 in the progress line's HTTP counts. Duration ~36s (at 1 URL/sec).

2. **Explicit `--ca-bundle`:**
   ```
   python scripts/amapi_crawler.py --max-wall-clock-hours 0.01 --ca-bundle assets/air_manager_api/wiki-cert-chain.pem
   ```
   Expected: same as above but log line reads `TLS: using CA bundle from assets/air_manager_api/wiki-cert-chain.pem` (explicit path message).

3. **`--insecure`:**
   ```
   python scripts/amapi_crawler.py --max-wall-clock-hours 0.01 --insecure
   ```
   Expected: `crawl_log.txt` contains the WARNING line; stderr shows the warning; HTTP 200 still returns successfully; no `InsecureRequestWarning` noise in stderr.

For each smoke test, capture the first ~10 lines of `crawl_log.txt` and the progress line into the completion report.

### Phase F — Decision on wider scope (do NOT execute — document only)

After the smoke tests pass, add a **Recommendations** section to the completion report noting:

1. Whether to delete the source PEM at `C:\Users\artroom\wiki-cert-chain.pem` — yes, it's redundant now that the project has its own copy.
2. Whether the `python-certifi-win32` package (installed during Turn 31 diagnosis) can be uninstalled since we're not using it — yes, but harmless if left.

These are CD decisions; this task documents them but does not act on them.

---

## Completion Protocol

1. Run full test suite: `python -m pytest tests/test_amapi_crawler.py -v`. Record count and pass/fail. Expected: baseline 97 + new tests (8 or so) = ~105 passed.
2. Write completion report to `docs/tasks/amapi_crawler_bugfix_02_completion.md` with:
   - Provenance header (Created, Source=this prompt path)
   - Summary table: PEM moved, flags added, tests passing, smoke tests passing
   - Phase A: PEM file moved; sha256 verification; sidecar README created
   - Phase B: fetch.py changes summary
   - Phase C: crawler.py changes summary; resolver logic description
   - Phase D: test count delta and list of new test names
   - Phase E: smoke test output for all three modes
   - Phase F: Recommendations section (per above)
   - Any deviations from this prompt with rationale
3. `git add -A`
4. Commit using the D-04 trailer format via a message file:
   ```
   AMAPI-CRAWLER-BUGFIX-02: add --ca-bundle and --insecure flags; move PEM into project

   Task-Id: AMAPI-CRAWLER-BUGFIX-02
   Authored-By-Instance: cc
   Refs: D-03, AMAPI-CRAWLER-01, AMAPI-CRAWLER-BUGFIX-01
   Co-Authored-By: Claude Code <noreply@anthropic.com>
   ```
   Write to a temp file, commit with `git commit -F <file>`, then delete the temp file. Do NOT use multiple `-m` flags (unreliable on PowerShell with empty-string args per Turn 29 discovery).
5. **Flag refresh check:** This task does not modify CLAUDE.md, claude-project-instructions.md, claude-conventions.md, cc_safety_discipline.md, or claude-memory-edits.md. Do NOT create refresh flags.
6. Send completion notification:
   ```
   Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "AMAPI-CRAWLER-BUGFIX-02 completed [flight-sim]"
   ```

**Do NOT git push.** Steve pushes manually.
