# D-04: Git commit trailer policy

**Created:** 2026-04-20T08:19:17-04:00
**Source:** Purple Turns 25–27 — discovered inconsistency in CC commit trailers across AMAPI-CRAWLER-01, SAMPLES-RENAME-01, GNC355-EXTRACT-01; policy defined
**Decision type:** convention / workflow

## Decision

Standardize Git commit message format with structured trailers for attribution, task tracking, and authoring-instance identification. Applies to all commits in this repository going forward.

CD (Claude Desktop) commits its own direct file writes (decision records, plan updates, refresh flags) at natural turn seams, using the `cd-{color}` instance identifier. Prior convention (only CC and Steve commit) is superseded.

Steve remains the only actor who performs `git push`.

## Commit Message Structure

### First line (subject)

```
{TASK-ID}: {brief description}
```

or for non-task commits:

```
{Verb-led brief description}
```

Examples:
- `AMAPI-CRAWLER-01: implement AMAPI wiki crawler with tracking DB`
- `D-04: add commit trailer policy`
- `Remove stale refresh flag`

### Body (optional)

Free-form narrative. Separated from subject by blank line. Separated from trailer block by blank line.

### Trailer block

Structured key-value lines at the bottom of the message. Git recognizes these and makes them searchable via `git log --grep` and machine-parseable by tools.

**Mandatory on every commit:**

| Trailer | Format | Purpose |
|---|---|---|
| `Task-Id:` | `AMAPI-CRAWLER-01` (matches task prompt's Task ID field) | Machine-greppable. Use `MANUAL` for commits not tied to a task, or `D-{n}` for decision-only commits. |
| `Authored-By-Instance:` | `cc` \| `cd-green` \| `cd-yellow` \| `cd-purple` \| `steve` | Identifies which instance of which tool produced the commit. |

**Mandatory when CC or CD authored:**

| Trailer | Value |
|---|---|
| `Co-Authored-By:` | `Claude Code <noreply@anthropic.com>` for CC-authored commits; `Claude Desktop <noreply@anthropic.com>` for CD-authored commits |

**Conditional (add when they apply):**

| Trailer | When to add | Example |
|---|---|---|
| `Refs:` | Commit implements or references a decision record, spec, or plan | `Refs: D-03, GNC355_Prep_Implementation_Plan_V1` |
| `Fixes:` | Commit closes a specific issue ID | `Fixes: ITM-12` |
| `Supersedes:` | Commit replaces a prior commit's intent | `Supersedes: 97456c9` |
| `Decision:` | Commit instantiates a decision record | `Decision: D-04` |

**Explicitly rejected (do not add):**

- `Signed-off-by:` — DCO sign-off. Not operating under a DCO. Skip.
- `Reviewed-by:` — Gerrit-style code review. Not our workflow. Skip.
- `Tested-by:` — CC always tests before commit per completion protocol. Redundant. Skip.

### Order

Trailers appear in this order when present:
1. `Task-Id:`
2. `Authored-By-Instance:`
3. `Decision:` (if applicable)
4. `Refs:` (if applicable)
5. `Fixes:` (if applicable)
6. `Supersedes:` (if applicable)
7. `Co-Authored-By:` (if applicable)

## Examples

### CC-authored task commit

```
SAMPLES-RENAME-01: copy instrument samples with safe names and generate manifest

Task-Id: SAMPLES-RENAME-01
Authored-By-Instance: cc
Refs: D-02, GNC355_Prep_Implementation_Plan_V1
Co-Authored-By: Claude Code <noreply@anthropic.com>
```

### CC-authored bugfix commit

```
AMAPI-CRAWLER-BUGFIX-01: fix source labeling, add robots.txt check, verify Phase E.5

Task-Id: AMAPI-CRAWLER-BUGFIX-01
Authored-By-Instance: cc
Refs: D-03, AMAPI-CRAWLER-01
Supersedes: 97456c9
Co-Authored-By: Claude Code <noreply@anthropic.com>
```

### CD-authored decision commit

```
D-04: add commit trailer policy

Task-Id: D-04-AUTHORING
Authored-By-Instance: cd-purple
Decision: D-04
Co-Authored-By: Claude Desktop <noreply@anthropic.com>
```

### Steve-authored manual commit

```
Remove stale refresh flag

Task-Id: MANUAL
Authored-By-Instance: steve
```

## CD Commit Scope (new — supersedes prior convention)

Previously, CD wrote files via Filesystem MCP but did not commit them — commits were left to CC or to Steve. This created dangling uncommitted changes when CD wrote decision records or plan updates outside the context of a CC task.

**New convention:** CD commits its own direct file writes at natural turn seams. A "natural seam" is:
- End of a substantive turn where files were written
- On explicit Steve request ("commit that")
- Before authoring a task prompt that will cite the files just written (so CC sees a consistent tree)

CD commits use `Authored-By-Instance: cd-{color}` where color matches the active CD instance. Standard CD sessions (no color) use `cd` (no suffix).

**CD still does NOT push.** Only Steve pushes.

## Migration — Existing Commits

The four existing non-migration commits (`d2297bc`, `97456c9`, `4ea1685`, `5f88e9c`) do not follow this policy. They are **not retroactively rewritten** — the history reflects the pre-policy state. New commits from this point forward follow D-04.

## Consequences

- `CLAUDE.md` §Development Workflow §Conventions and §Git sections updated with the trailer policy
- `claude-conventions.md` gets a new §Git Commit Trailers section
- `docs/templates/CC_Task_Prompt_Template.md` §Completion Protocol updated to show the new commit message format
- CC task prompts authored going forward include the new commit format in their completion protocol
- CD-authored commits become a regular occurrence; each is attributable via the `cd-{color}` trailer
- `git log --grep='Authored-By-Instance: cd'` will surface CD-authored commits; same for CC or Steve
- Refresh flags required for CLAUDE.md, claude-conventions.md, and the CC task prompt template since they're modified

## Related

- D-01 (project scope)
- D-02 (GNC 355 prep scoping)
- D-03 (AMAPI crawler DB schema)
- `CLAUDE.md` §Development Workflow
- `claude-conventions.md`
- `docs/templates/CC_Task_Prompt_Template.md`
