# Phase D Complete — AMAPI-PATTERNS-01

**Completed:** 2026-04-20

## Final pattern count: 24

All 24 confirmed patterns are documented in `docs/knowledge/amapi_patterns.md`.

## Patterns by category

| Category | Patterns | Pattern #s |
|---|:---:|---|
| Writing to the simulator | 5 | 1, 18, 19, 23, 24 |
| Reading simulator state | 4 | 2, 3, 14, 22 |
| Touchscreen / button input | 1 | 4 |
| Knob / hardware dial input | 4 | 11, 15, 20, 21 |
| Visual state management | 5 | 6, 7, 8, 10, 17 |
| Sound | 1 | 16 |
| User properties / configuration | 2 | 5, 9 |
| Persistence | 1 | 11 (cross-ref) |
| Instrument metadata / platform | 2 | 12, 13 |

## Cross-reference count

Pattern catalog entries reference these AMAPI function docs (each link is one cross-ref):
- 34 distinct functions referenced across patterns
- Estimated total cross-reference links: ~85

## A3 use-case section coverage

| A3 Section | Coverage |
|---|---|
| §1 Reading simulator state | ✓ Patterns 2, 3, 14, 22 |
| §2 Writing to sim | ✓ Patterns 1, 18, 19, 23, 24 |
| §3 Pilot input — touchscreen | ✓ Pattern 4 |
| §4 Pilot input — knobs | ✓ Patterns 11, 15, 20, 21 |
| §5 Switches/sliders | — No confirmed patterns (single-sample only) |
| §6 Drawing — static | ✓ Pattern 8 (img_add style string) |
| §7 Dynamic canvas drawing | — No confirmed patterns |
| §8 Running displays | — No confirmed patterns |
| §9 Visual state management | ✓ Patterns 6, 7, 8, 10, 17 |
| §10 Maps / navigation data | — No confirmed patterns |
| §11 Persistence | ✓ Pattern 11 |
| §12 User properties | ✓ Patterns 5, 9, 20 |
| §13 Sound | ✓ Pattern 16 |
| §14 Timing | — No standalone pattern (timer is supporting mechanism) |
| §15 Data loading | — No confirmed patterns |
| §16 Value helpers | — No standalone pattern |
| §17 Instrument metadata | ✓ Patterns 12, 13 |
| §18 SI bus | ✓ Pattern 10 |
