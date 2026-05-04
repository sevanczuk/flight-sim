## Review Priority Guide

This guide directs C3 spec review attention. Sections are bucketed by their fidelity-criticality to the real GNX 375 device behavior as documented in Garmin Pilot's Guide 190-02488-01 Rev. C. Reviewers should weight scrutiny accordingly: P1 sections warrant the deepest review; P3 sections warrant verification-only sweeps unless an issue surfaces.

### P1 — Correctness-critical

These sections describe the GNX 375's signature features, output contracts to host simulators, and behaviors where a spec defect would produce a non-fidelity instrument. Findings here are accepted into V2 if they pass the functional-fidelity test (see D-22 §3).

- **§11 — Transponder + ADS-B.** Signature feature differentiating the GNX 375 from sibling units. D-16 framing (three transponder modes; built-in dual-link ADS-B In/Out; TSAA traffic alerting; Remote G3X Touch v1 integration out of scope) must be honored throughout.
- **§15 — External I/O.** Output contracts to X-Plane and MSFS host simulators. OPEN QUESTIONS 4 and 5 sit here.
- **§4.9 — Hazard Awareness.** Alert behaviors (TAWS, traffic, terrain, weather). OPEN QUESTION 6 sits here.
- **§7 — Procedures.** Approach state machine. D-15 framing (no internal VDI; vertical guidance presented to external display only) must be honored.

### P2 — Functionality-critical

These sections describe core navigation and editing behaviors. Findings should be accepted if functional-fidelity-test positive; rejected with documentation otherwise.

- **§§5–6 — Flight plan editing + Direct-to.**
- **§§8–10 — Nearest, Waypoint Information, Settings.**
- **§14 — Persistent State.**
- **§12 — Audio / Alerts.**
- **§13 — Messages.**

### P3 — Quality / polish

These sections are largely PDF transcription and stable. Verify-only sweeps are sufficient unless an issue surfaces.

- **§§1–4 — Overview, Physical / Controls, Power-On, Display Pages.**
- **Appendices A, B, C.**

---

**Triage reminder (per D-22 §3):** every finding must pass a functional-fidelity test to be accepted into V2. A finding that says "the spec doesn't document behavior X that the real device has" is functional. A finding that says "the spec could be more consistent in cross-referencing §A and §B" is editorial. Even HIGH-severity findings fall into both buckets.
