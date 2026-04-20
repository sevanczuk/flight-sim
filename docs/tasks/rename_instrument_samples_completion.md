---
Created: 2026-04-20T12:14:00+00:00
Source: docs/tasks/rename_instrument_samples_prompt.md
---

# SAMPLES-RENAME-01: Completion Report

## Summary

Built a Python copy-and-rename pipeline for the 45 UUID-named Air Manager instrument sample directories under `assets/instrument-samples/`. Originals are never modified.

### Modules created

| File | Purpose |
|------|---------|
| `scripts/rename_instrument_samples.py` | Main script: slugify, safe-name derivation, collision resolution, info.xml parser, copy logic, manifest + JSON index generation |
| `tests/test_rename_instrument_samples.py` | 26 unit tests covering all required behaviors |
| `assets/instrument-samples-named/` | 45 human-readable directories (copy destinations) |
| `assets/instrument-samples-named/_index.json` | JSON index of all samples |
| `docs/knowledge/instrument_samples_index.md` | Markdown manifest |

## Test results

**Command:** `python -m pytest tests/test_rename_instrument_samples.py -v`

**Result: 26 passed, 0 failed**

Coverage:
- slugify: 7 cases (Cessna 172, ADF, G1000, empty, whitespace, accents, idempotency)
- safe_name: known example verified
- Collision resolution: different 8-char prefixes, forced 12-char promotion, forced `_2` suffix
- info.xml parsing: valid minimal, missing aircraft/type/uuid raise ValueError, UUID mismatch warns, booleans, integers, lists
- Copy logic: first copy, idempotent skip, different-UUID error, byte-identical destination
- Source immutability: checksums before/after copy are identical

## Smoke-test results

### Dry run
- Source dirs processed: 45
- Would copy: 45
- Errors: 0
- Collisions: 0

### Real run
- Source dirs processed: 45
- Copied: 45
- Skipped (idempotent): 0
- Errored: 0
- Collisions resolved: 0

### Idempotency re-run
- Source dirs processed: 45
- Copied: 0
- Skipped (idempotent): 45
- Errored: 0

Idempotency confirmed: re-running produces zero file modifications.

Originals spot-check: `assets/instrument-samples/04a6aa5d-7aad-42e4-9ed7-ca313b0e2edb/` file sizes (info.xml: 1146 B, logic.lua: 10523 B, preview.png: 95483 B) identical before and after run.

## Sample manifest (first 5 rows)

| Safe name | UUID | Aircraft | Type | Author | Sim compat | Dimensions | Version |
|-----------|------|----------|------|--------|------------|------------|---------|
| cessna-172_adf_04a6aa5d | 04a6aa5d-7aad-42e4-9ed7-ca313b0e2edb | Cessna 172 | ADF | Jason Tatum | FSX, P3D, XPL, FS2020, FS2024 | 512x512 | 126 |
| cessna-172_airspeed_05542d69 | 05542d69-a055-45a6-915a-f0aa81c195f7 | Cessna 172 | Airspeed | Jason Tatum | FSX, P3D, XPL, FS2020, FS2024 | 512x512 | 110 |
| cessna-172_alternate-static-air_2a5c2a45 | 2a5c2a45-2324-4939-0120-72cfec15461e | Cessna 172 | Alternate Static Air | Joe "Crunchmeister" Gilker | FS2020, FS2024 | 181x283 | 2 |
| cessna-172_altimeter_cf5829f6 | cf5829f6-92e1-42c0-bbed-8935f586e696 | Cessna 172 | Altimeter | Jason Tatum | FSX, P3D, XPL, FS2020, FS2024 | 512x512 | 112 |
| cessna-172_annunciators_13b58426 | 13b58426-9305-4f2c-8672-394f1e40c9d1 | Cessna 172 | Annunciators | Jason Tatum | FSX, P3D, XPL, FS2020, FS2024 | 400x100 | 13 |

## Deviations from prompt

None. All phases implemented exactly as specified.
