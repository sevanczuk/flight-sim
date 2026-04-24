# D-23: Credential File Access Pattern for CC Scripts

**Created:** 2026-04-24T10:19:02-04:00
**Source:** Purple Turn 16 (2026-04-24) — Steve requested PDF re-extraction task pull its API key from `C:\PhotoData\config\api_keys.json` under key name `llamaparse`, without exposing the value
**Status:** Accepted — applies to all future CC scripts that need API keys from the PhotoData credential file
**Related:** `cc_safety_discipline.md` §Credential File Protection (absolute rule); D-06 (gitignore regenerable output pattern, for context); D-22 §(1) (the PDF re-extraction task that motivated codifying this pattern)

---

## Decision

When a CC script needs an API key that lives in `C:\PhotoData\config\api_keys.json`, the script follows a **fixed credential-access pattern** that balances functional need (pass the key to an SDK) against the absolute rule in `cc_safety_discipline.md` §Credential File Protection (never directly read/cat/view credential files; never expose values).

---

## The pattern

Scripts access credentials via a dedicated helper function `_load_api_key()` with these properties:

### 1. File access happens inside Python, not in shell

- `cat`, `Get-Content`, `type`, `read_text_file`, text editors, `view` — **FORBIDDEN**, even for "diagnostic" purposes.
- `python script.py` executing `json.load(open(path))` — **ALLOWED**. This is functional use; the interpreter reads the file to parse it, not to display it.
- The script must be invoked by Steve or by CC's bash/PowerShell tool running Python directly; never by CC reading the credential file via any Filesystem MCP tool.

### 2. Extract only the required key; drop the rest immediately

```python
with open(CREDENTIAL_FILE, "r", encoding="utf-8") as fh:
    creds = json.load(fh)

key = creds[CREDENTIAL_KEY_NAME]  # e.g., "llamaparse"
creds = None  # drop reference to the parsed dict; other keys must not linger
```

The parsed dict may contain other credentials (e.g., `openai`, `anthropic`, service-specific keys). Binding the reference to `None` lets the garbage collector reclaim it and prevents later code from accidentally operating on other keys.

### 3. Format-validate without exposing values

Validate shape, length, and prefix. Report failures with **labels only** — never the value, never any portion of the file contents, never any other keys that happen to be present:

```python
if not isinstance(key, str):
    raise RuntimeError(f"'{CREDENTIAL_KEY_NAME}' value is not a string")
if len(key) < 20:
    raise RuntimeError(f"'{CREDENTIAL_KEY_NAME}' value too short (expected >= 20 chars)")
if not key.startswith(EXPECTED_PREFIX):
    raise RuntimeError(f"'{CREDENTIAL_KEY_NAME}' value has wrong prefix (expected '{EXPECTED_PREFIX}')")
```

Expected prefix is per-service: LlamaParse uses `llx-`, Anthropic uses `sk-ant-`, OpenAI uses `sk-`. The prefix check is a cheap format-sanity filter; the label-only error message preserves privacy.

### 4. Pass directly to SDK; drop local reference

```python
client = SomeSDK(api_key=key)
key = None  # SDK instance has captured it; drop our reference
```

The SDK instance retains the key internally (unavoidable — it needs to authenticate requests). The script's job is to not hold duplicate references on the stack that could leak into logs, exception messages, or repr strings.

### 5. Sanitize error messages

Exceptions from the SDK may (rarely, but defensively) include the key in their messages. Any `except` block that re-raises or prints must first strip key-shaped substrings:

```python
def _sanitize_error(msg: str) -> str:
    """Strip any llx-... fragments from an error message before logging."""
    return re.sub(r'llx-[A-Za-z0-9_-]+', 'llx-<REDACTED>', msg)
```

Service-specific prefixes get their own regex. General principle: any substring that could plausibly be the key gets redacted before any `print`, `sys.stderr.write`, log call, or exception re-raise.

### 6. Log metadata, not contents

Extraction logs, commit messages, completion reports, ntfy bodies, and any other persistent record refer to the credential source by path + key name only:

> "Credential source: `C:/PhotoData/config/api_keys.json[llamaparse]` (value not logged)"

Never include the value or any other JSON from the file.

### 7. Pre-flight checks without opening the file

Scripts may want to confirm the credential file exists before starting a long-running operation. Acceptable pre-flight:

```powershell
Test-Path "C:\PhotoData\config\api_keys.json"
(Get-Item "C:\PhotoData\config\api_keys.json").Length
```

Both are metadata probes — they return existence and file size without reading contents. `Test-Path` and `Get-Item .Length` are allowed. `Get-Content`, `cat`, `type`, or any variant that surfaces the contents to stdout or a variable that could be displayed — forbidden.

---

## Rationale

The `cc_safety_discipline.md` §Credential File Protection rule is absolute for a reason: accidental exposure is a common and high-impact failure mode. An exposed API key in a commit message, a log file, or an ntfy push is a real cost (rotation effort, potential abuse) that compounds with the project's outward-facing artifacts being under version control.

But "never touch the file" read literally would make scripts that legitimately need keys impossible to write. The functional requirement is: the key must reach the SDK. The safety requirement is: the value must not reach any persistent record or any output stream visible to humans or to tools other than the SDK itself.

This pattern threads that needle. The Python interpreter reads the file (unavoidable; someone has to). The helper function extracts only the required key (minimizes surface area). The format check uses label-only errors (informs operator without disclosing value). The SDK captures the key internally (intended). Everything else — logs, reports, commits, error messages — refers to the key by source path + name, never by value.

---

## Applicability

- **Applies to:** any CC script in this project that needs an API key from `C:\PhotoData\config\api_keys.json`. Specific keys known at time of writing: `llamaparse` (for D-22 §(1) PDF re-extraction). Future keys will be added to the file as needed.
- **Applies to:** any future script accessing service credentials in a similar key-value JSON file, regardless of service.
- **Does NOT apply to:** environment-variable-based credentials (those are handled by `os.getenv()`; no file read is needed). Environment variables are the preferred credential source when the calling context can reliably set them. The credential-file pattern is for cases where env-var export is inconvenient (e.g., Steve wants to keep keys in a single managed file across multiple projects, or where keys are shared across PhotoData and flight-sim workflows).
- **Does NOT apply to:** secrets that should be ephemeral (session tokens, OAuth refresh tokens) — those need different handling.

---

## Worked example

`scripts/pdf_reextraction/reextract_gnc355_pdf_llamaparse.py` (authored per D-22 §(1)) is the reference implementation of this pattern. Future scripts needing similar access should follow its structure:
- `_load_api_key()` helper at module top
- `_sanitize_error()` helper for error-message redaction
- `main()` loads key, passes to SDK, drops local reference
- No `print`, `log`, or write call outside of `_sanitize_error()` ever receives the key value

---

## Non-obvious tradeoffs

- **The pattern is slightly more verbose than "pass env var to SDK."** ~30 lines added per script for helper functions. Worth it for the explicit audit-readability.
- **Environment variables remain the preferred fallback.** If a script can use an env var cleanly, it should. The credential-file pattern exists because Steve uses the PhotoData file as a shared-across-projects key store; env var export would require setting the var in every shell that launches CC, which is fragile.
- **Error sanitization is defensive, not paranoid.** LlamaParse and most mature SDKs don't include API keys in exception messages. But the `_sanitize_error` regex costs nothing and catches the one-in-a-thousand case where a misbehaving SDK does leak.
- **Script commits expose the pattern but not the value.** The script source is in git; it references `C:\PhotoData\config\api_keys.json` and the key name `llamaparse` as literals. That's fine — the path and key name are not secrets (the machine path is Steve's workstation-specific; anyone with access to the repo but not the workstation cannot resolve the key). Commits must never include actual key values, and the sanitization pattern ensures exception-path leakage is caught.

---

## Implementation checklist (one-time)

- [x] Revised `docs/tasks/pdf_reextraction_llamaparse_prompt.md` (Turn 16) to use credential-file access pattern
- [x] Task flow plan entry for PDF re-extraction updated to reflect Turn 16 revision
- [ ] Future scripts needing PhotoData credentials: follow the `_load_api_key()` / `_sanitize_error()` template from the PDF re-extraction script

---

## Related

- `cc_safety_discipline.md` §Credential File Protection — the absolute rule this pattern operationalizes
- `docs/tasks/pdf_reextraction_llamaparse_prompt.md` — reference implementation of the pattern
- `docs/decisions/D-22-c3-spec-review-customization-for-gnx375-functional-spec.md` §(1) — task that motivated codifying this
