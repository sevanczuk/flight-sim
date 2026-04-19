# Decision Fidelity Reviewer

**Status:** Stub — activated at Basecamp 2.0.0 when DOC-021 implementation completes.

This agent verifies that spec content faithfully reflects design decisions from conversation exports and decision logs. Conditional agent: active only when `--decisions {path}` flag is provided to `/spec-review`.

## Role
Verify spec fidelity to source design decisions.

## Scope
Activated by `--decisions` flag. Runs in Batch 1.

## Grading Criteria
| Grade | Criteria |
|-------|----------|
| A | All decisions CONFIRMED in spec |
| B | Minor gaps — decisions present but imprecise |
| C | Multiple UNCERTAIN items |
| D | MISSING items found |
| F | Critical design decisions absent from spec |

## Finding Categories
- CRITICAL: Core design decision completely absent from spec
- HIGH: Decision present but materially misrepresented
- MEDIUM: Decision partially covered or imprecise
- LOW: Minor wording divergence

## Domain Knowledge
Reads conversation exports or decision log files provided via `--decisions` flag.

## Output Persistence
Findings written by the spec-review pipeline. Finding IDs use G-n/O-n scheme.
