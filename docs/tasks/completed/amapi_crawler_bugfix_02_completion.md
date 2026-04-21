---
Created: 2026-04-20T13:10:00Z
Source: docs/tasks/amapi_crawler_bugfix_02_prompt.md
---

# AMAPI-CRAWLER-BUGFIX-02 Completion Report

## Summary Table

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | PEM moved into project | DONE | `assets/air_manager_api/wiki-cert-chain.pem`; sha256 verified |
| 2 | Sidecar README created | DONE | `assets/air_manager_api/wiki-cert-chain.README.md` |
| 3 | `--ca-bundle` flag added | DONE | Overrides CA bundle; validated path at startup |
| 4 | `--insecure` flag added | DONE | Disables verification; emits warning to log + stderr |
| 5 | `fetch.py` `verify` param | DONE | Passed through to `requests.Session.get` |
| 6 | `resolve_verify()` resolver | DONE | Priority: insecure > ca-bundle > project PEM > certifi |
| 7 | Tests (97 baseline + 9 new) | PASSED | 106 passed, 0 failed |
| 8 | Smoke tests (3 modes) | PASSED | All 3 returned HTTP 200 with correct log messages |

---

## Phase A: PEM File

**Source:** `C:\Users\artroom\wiki-cert-chain.pem` (6739 bytes)
**Destination:** `assets/air_manager_api/wiki-cert-chain.pem`
**sha256:** `1484c9413b3e8c347916c02e7b781a30c704b15ce2b6e56b3ab809f911edaac8` — matches source exactly.
**Cert count:** 3 (leaf `*.siminnovations.com`, Sectigo RSA DV intermediate, USERTrust RSA root).
**Sidecar:** `assets/air_manager_api/wiki-cert-chain.README.md` — documents origin, purpose, and regeneration instructions.
**Source PEM:** Left in place at `C:\Users\artroom\wiki-cert-chain.pem` per prompt instructions (CD decision pending).

---

## Phase B: fetch.py Changes

`scripts/amapi_crawler_lib/fetch.py`:
- Added `verify: bool | str = True` parameter to `fetch_page`.
- Passes `verify=verify` to `session.get(...)`.
- Default `True` preserves existing behavior (certifi bundle).
- InsecureRequestWarning suppression is done at crawler startup in `resolve_verify` (Phase C), not at call site.

---

## Phase C: crawler.py Changes

**New CLI flags in `main()`:**
- `--ca-bundle PATH` (`str`, default `None`) — explicit CA bundle path.
- `--insecure` (`store_true`, default `False`) — disable TLS verification.

**New function `resolve_verify(args, log_path) -> bool | str`:**
Priority chain:
1. `--insecure` + `--ca-bundle` both set → logs warning, `--insecure` wins, returns `False`.
2. `--insecure` alone → suppresses urllib3 InsecureRequestWarning module-wide, writes warning to stderr, returns `False`.
3. `--ca-bundle PATH` → validates file exists (SystemExit if not), returns path as `str`.
4. Project PEM (`assets/air_manager_api/wiki-cert-chain.pem`) present → returns its path as `str`.
5. Fallback → returns `True` (certifi default).

**Threading `verify` through the crawler:**
- Called once at startup: `verify = resolve_verify(args, log_path)`
- `_load_robots_parser` updated to accept `verify` kwarg; passes to its `requests.get` call.
- `fetch_page` call in the main loop passes `verify=verify`.
- No other stray `requests.get(...)` calls found in the codebase.

---

## Phase D: New Tests

**Test count:** 97 (baseline) → 106 passed (+9 new tests)

**`TestResolveVerify` (6 tests):**
- `test_insecure_flag_returns_false` — `--insecure` → returns `False`
- `test_insecure_wins_over_ca_bundle` — both flags → returns `False`, warning logged
- `test_ca_bundle_flag_returns_path` — `--ca-bundle /path.pem` (file exists) → returns path string
- `test_ca_bundle_missing_file_exits` — nonexistent path → `SystemExit`
- `test_project_pem_fallback` — no flags, project PEM present in tmp tree → returns project PEM path
- `test_certifi_default_fallback` — no flags, no project PEM → returns `True`

**`TestFetchVerifyParameter` (3 tests):**
- `test_verify_true_passed_through` — `verify=True` → `requests.Session.get` receives `verify=True`
- `test_verify_path_passed_through` — `verify='/path/to/bundle.pem'` → received by `requests.Session.get`
- `test_verify_false_passed_through` — `verify=False` → received by `requests.Session.get`

---

## Phase E: Smoke Tests

### Smoke Test 1 — Default (project PEM auto-detected)

**Command:** `python scripts/amapi_crawler.py --max-wall-clock-hours 0.01`

**Log (first 10 lines):**
```
[2026-04-20T13:05:25Z] TLS: using project CA bundle at assets\air_manager_api\wiki-cert-chain.pem
[2026-04-20T13:05:25Z] Crawler started
[2026-04-20T13:05:25Z] New crawl run: run_id=7
[2026-04-20T13:05:25Z] Seeds imported: 384 URLs processed
[2026-04-20T13:05:26Z] robots.txt: not found — no restrictions apply
[2026-04-20T13:05:26Z] FETCH https://wiki.siminnovations.com/index.php?title=Xpl_dataref_subscribe
[2026-04-20T13:05:27Z] FETCHED https://wiki.siminnovations.com/index.php?title=Xpl_dataref_subscribe (18281 bytes, 2 new links)
...
```

**Progress line:**
```
[0:00:36 elapsed] fetched: 29 new / 83 total  |  HTTP: 200=29  |  queue: 144 pending  |  discovered: 44 new  |  rate: 48.3/min  |  STOPPED: wall-clock limit (0.01h)
```

Result: 29 HTTP 200 fetches, 0 errors. ✓

---

### Smoke Test 2 — Explicit `--ca-bundle`

**Command:** `python scripts/amapi_crawler.py --max-wall-clock-hours 0.01 --ca-bundle assets/air_manager_api/wiki-cert-chain.pem`

**Log (first 2 lines):**
```
[2026-04-20T13:06:08Z] TLS: using CA bundle from assets\air_manager_api\wiki-cert-chain.pem
[2026-04-20T13:06:08Z] Crawler started
```

**Progress line:**
```
[0:00:37 elapsed] fetched: 30 new / 113 total  |  HTTP: 200=30  |  queue: 114 pending  |  discovered: 35 new  |  rate: 48.5/min  |  STOPPED: wall-clock limit (0.01h)
```

Result: 30 HTTP 200 fetches, 0 errors. ✓

---

### Smoke Test 3 — `--insecure`

**Command:** `python scripts/amapi_crawler.py --max-wall-clock-hours 0.01 --insecure`

**stderr (first line):**
```
WARNING: running with --insecure; TLS verification is OFF
```

**Log (first 2 lines):**
```
[2026-04-20T13:06:50Z] WARNING: TLS certificate verification DISABLED via --insecure flag
[2026-04-20T13:06:50Z] Crawler started
```

**Progress line:**
```
[0:00:36 elapsed] fetched: 29 new / 142 total  |  HTTP: 200=29  |  queue: 85 pending  |  discovered: 39 new  |  rate: 47.4/min  |  STOPPED: wall-clock limit (0.01h)
```

Result: 29 HTTP 200 fetches, 0 errors, no `InsecureRequestWarning` noise in stderr. ✓

---

## Phase F: Recommendations (CD decision required)

1. **Delete `C:\Users\artroom\wiki-cert-chain.pem`** — yes, recommended. The project now has its own copy at `assets/air_manager_api/wiki-cert-chain.pem`, verified byte-identical. The source PEM is redundant. Safe to delete.

2. **Uninstall `python-certifi-win32`** (installed during Turn 31 diagnosis) — yes, recommended but harmless if left. This task uses a project-bundled PEM directly rather than patching certifi, so the package provides no value. However, leaving it installed is also harmless.

These are CD decisions; this task documents them but does not act on them.

---

## Deviations from This Prompt

None. All phases executed as specified.
