# D-27 — Cross-project hand-offs go in `docs/handoffs/`

**Created:** 2026-04-30T17:46:30-04:00
**Source:** CD Purple session — Turn 38; arose from the need to brief a new CD session in a sibling project (`commons-project/commons`) about a script upgrade required by flight-sim
**Status:** Adopted
**Decision class:** Convention / file organization

---

## Decision

Briefings authored from one project for execution in another project go in `docs/handoffs/{descriptive_name}_briefing.md` in the originating project's repo. The originating project owns the document for traceability; the receiving project's CD session reads it as input for its own session.

---

## Context

The flight-sim project needed `commons-project/commons/llamaparse-extract/llamaparse_extract.py` upgraded from V3.2 to V3.3 to add LlamaParse v2's `extract_printed_page_number` option. Two paths were considered:

1. CD in flight-sim drafts a CC task prompt that CC executes against the commons project. Risks: CC has to navigate cross-project file paths, the task prompt is bigger than necessary, and the work is more naturally a design + CD-direct edit than an implementation task.
2. CD in flight-sim writes a briefing for a new CD session opened in the commons project. The receiving CD has filesystem access to commons, can read V3.2 directly, and can do the design + implementation in the natural CD-style workflow.

Path 2 was chosen. The briefing was authored as `docs/handoffs/llamaparse_extract_v3.3_upgrade_briefing.md`.

---

## Convention

### When to use a hand-off briefing

Use a briefing when:

- A change is needed in another project (separate repo, separate workspace)
- The change is small enough to be CD-direct work in the receiving project (not a CC task)
- The originating project has context the receiving project lacks
- A round-trip via shared chat would be lossy or slow

Do NOT use a briefing when:

- The change is large enough to warrant a full CC task (use `docs/tasks/{name}_prompt.md` instead and invoke CC in the receiving project)
- The change is in the same project (use the normal turn-based CD workflow)
- The change is purely operational (e.g., "please run command X") — just include the command in the originating session's chat, no need for a doc

### File location

`{originating_project}/docs/handoffs/{descriptive_name}_briefing.md`

For commit purposes the doc is owned by the originating project. The receiving project doesn't commit a copy — it consumes the URL or pasted content.

### Required sections

Briefings should include:

1. **TL;DR** — one paragraph for the receiving CD to orient
2. **Audience** — who is meant to read this (e.g., "new CD session in commons-project")
3. **Background** — what the originating project is doing and why it triggered this
4. **Scope** — concrete deliverables the receiving project should produce
5. **Pre-work** — any research or doc review the receiving CD should do first (this matters; without it the receiving CD can launch into implementation with stale context)
6. **Hand-off pattern** — how the deliverables flow back to the originating project
7. **Decisions baked in** — explicit traceability for what was decided in the originating session, so the receiving session doesn't re-litigate

### Naming

`{topic}_{version_or_action}_briefing.md`. Examples:
- `llamaparse_extract_v3.3_upgrade_briefing.md`
- `commons_pyproject_dependency_alignment_briefing.md`
- `shared_logger_format_change_briefing.md`

---

## File provenance for hand-off documents

Briefings include the standard `Created:` and `Source:` provenance header (per existing project convention). Source field describes the originating CD session and the turn that authored the briefing.

---

## Cross-references

- `claude-conventions.md` § File Provenance — applies to docs/handoffs/ as it does to all docs/ subdirectories
- `docs/handoffs/llamaparse_extract_v3.3_upgrade_briefing.md` — first hand-off authored under this convention; treat as the example template for future hand-offs
