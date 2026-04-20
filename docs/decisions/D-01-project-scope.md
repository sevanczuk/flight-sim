# D-01: Project scope defined — flight sim environment optimization

**Created:** 2026-04-19T17:45:10-04:00
**Source:** Purple Turn 5 — first session, user-provided scope statement
**Decision type:** scope / architecture

## Decision

flight-sim project scope: **optimize a flight sim environment and operation primarily based on X-Plane 12, with potential secondary support for the latest version of Microsoft Flight Simulator.**

Near-term focus (first active workstream): build an Air Manager instrument for the Garmin GNC 355 touchscreen GPS/COM using the Air Manager API.

## Context

This is the first session for the flight-sim project. Prior to this turn the project was scaffolded with Basecamp v1.2.0 but had no defined scope — `claude-project-description.txt` said "Domain and scope to be defined as development progresses" and `CLAUDE.md` line 1 still held the `{project_description}` template placeholder.

## Consequences

- `CLAUDE.md` line 1 updated from the placeholder to the scope statement.
- `claude-project-description.txt` updated with the scope statement plus the near-term GNC 355 focus note.
- `CLAUDE.md.needs_refresh` and `claude-project-description.txt.needs_refresh` regenerated per the Flag File Protocol.
- Secondary MSFS support is explicitly optional — it should not dominate design decisions. Where X-Plane-specific patterns conflict with MSFS-portable patterns, prefer the X-Plane pattern and document the MSFS gap.
- Many other `CLAUDE.md` placeholders remain (System Environment, Pipeline Overview, Project Data Structure, `{pipeline_spec}.md`, `{main_spec}.md`, test/build/start-server commands). These will be filled in as the work defines them — not preemptively.

## Related

- `CLAUDE.md` (line 1)
- `claude-project-description.txt`
- Flag File Protocol in `claude-project-instructions.md`
