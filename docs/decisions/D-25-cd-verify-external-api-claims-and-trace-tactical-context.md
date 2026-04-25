# D-25: CD must verify external-API claims and connect tactical answers to active task design

**Created:** 2026-04-25T08:33:49-04:00 ET
**Source:** CD Purple session — proposed across Turns 35, 40, 46, 53; approved by Steve Turn 54
**Status:** Active
**Scope:** CD planning discussions and conversational responses (companion to D-24 which covers CC task prompts)

---

## Context

Across the Purple session of 2026-04-24/25, four instances were observed where CD provided
confident answers that were either factually unverified or technically correct but
contextually useless. The pattern is captured below to prevent recurrence.

### Observed instances this session

| Turn | Topic | Failure mode |
|------|-------|--------------|
| 15 | Image-extraction scope framing for GNX 375 spec | Assumed PyMuPDF .bin files extracted in prior work would suffice for spec illustration; did not anticipate that LlamaParse-quality images (screenshots with callouts) would be the actually-needed asset. Surfaced when the briefing was being drafted. |
| 22 | "Approach B (LlamaParse re-parse with images_to_save) is free within the 48-hour cache window" | Asserted as fact without checking docs. Steve pushed back in Turn 23. Research showed the v1 cache documentation says cache considers "parameters that can have an impact on output (such as parsing_instructions, language, page_separators)" — a non-exhaustive list. Empirical test in Turns 24-25 confirmed the cache invalidates. Original assertion was wrong. |
| 24/26 | Test script success-detection logic | Wrote a cache-test script whose try/except design assumed the v1 SDK would raise an exception on quota-exceeded API responses. The SDK actually prints to stderr and returns an empty list — no exception. Script reported "PASSED" when the API had rejected the request. Found and corrected after the fact. |
| 43 | "Project_id is safe to /btw to CC" | Answered the literal security question correctly (project_id is not secret; URL-path identifier; safe to share). But did not check the answer against what the active V2 task prompt actually directs CC to do with the project_id — which is "create only a template with placeholder values." So /btw'ing the real value had no effect. Steve had to course-correct CC mid-session. |

### Common root

CD provided a complete, confident response to a literal question without:
- (a) verifying claims about external-system behavior against a documented or empirical source, or
- (b) checking whether the answer's practical implications actually serve the user's underlying goal.

The pattern is distinct from honest uncertainty (which CD already flags). It is the failure
mode of being correct-sounding while not having done the work to be reliably correct.

---

## Decision

### Rule 1 — Empirical verification for external-API claims

Any claim about an external API's behavior — pricing, caching, error handling, output
semantics, parameter semantics, rate limits — where being wrong could cause:
- billing surprises,
- broken test interpretations,
- downstream planning errors,
- or wasted CC work,

must be either:

- **(a)** backed by an explicit documentation citation (URL or named source), or
- **(b)** explicitly flagged as "unverified assumption — verify before committing" with a
  concrete proposed verification step (run a one-page test, install the SDK and introspect,
  query a free endpoint, etc.).

This applies to CD's planning discussions, briefings, and responses to user questions
about external systems. It complements D-24, which governs CC task prompts — D-24 is
about prompts CD writes for CC; D-25 Rule 1 is about CD's own conversational claims.

### Rule 2 — Trace tactical answers back to active task design

When the user asks a tactical question ("is X safe to do?", "should I include Y?",
"will Z work?"), CD must answer:

- **(a)** the literal question (with Rule 1 applied), and
- **(b)** the practical context: does the answer's implication actually serve the user's
  underlying goal given the active task/design?

If (b) reveals a disconnect — e.g., the answer is "yes, X is safe" but the active task
doesn't actually do anything with X — CD must surface the disconnect explicitly rather
than letting the user act on a literal-but-useless answer.

### Tripwires

Sentinel phrases that should trigger a self-check before sending a response:

- "It's safe to..." / "It's free to..." / "You can just..."
- "X works like Y" (claiming behavior of an external system)
- "Yes, [tactical action]" — without explicit reference to what the active task does with that action
- "[approach name] is [free | cheap | safe | non-billable]" — claims about cost/risk profile of an approach

When CD generates a response containing one of these phrases, the rule requires either a
citation or an explicit unverified-assumption flag, AND a brief check of practical context.

### What this rule does NOT require

- It does NOT require verification for every claim. Claims about CD's own design, project
  conventions, file paths, or internal state remain trust-the-context.
- It does NOT require empirical testing for low-stakes claims (e.g., "Python sets are
  unordered" — well-established CS fact, no verification needed).
- It does NOT require CD to refuse to answer when verification would take too long. CD can
  still answer with the unverified-assumption flag plus a recommendation to verify.

---

## Application

This rule is binding on CD going forward. Specifically:

1. CD self-monitors for the tripwire phrases and applies the verification gate.
2. The user can invoke this rule shorthand: "verify before answering" forces Rule 1
   citation; "trace context" forces Rule 2 trace.
3. Future failure instances of the same pattern should be appended to the "Observed
   instances" table in this document with a brief note. If three new instances accumulate
   despite this rule, the rule itself is failing and needs revision.

## Companion decisions

- **D-23** — Credential file access pattern (operational, narrower scope)
- **D-24** — Billable-API task prompts must enumerate outputs (CC-side companion of Rule 1)

## Revision history

- 2026-04-25: Initial creation. Captures failure pattern observed across Purple session
  Turns 15, 22, 24/26, and 43.
