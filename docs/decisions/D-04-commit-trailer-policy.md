# D-04: Git commit trailer policy

**Created:** 2026-04-20T08:19:17-04:00  
**Amended:** 2026-04-20T09:10:00-04:00 (Purple Turn 37 — executing-mechanics clarifications: `-F` + file pattern, BOM-free writes, CD-drafts / Steve-executes)  
**Amended:** 2026-04-20T18:52:56-04:00 (Purple Turn 4 — see D-09: CD writes message file directly via Filesystem MCP; PowerShell here-string demoted to fallback)  
**Source:** Purple Turns 25–27 (original), 29, 31–32 (mechanics lessons), 37 (amendment), 4-of-new-session (D-09 amendment)  
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

**New convention:** CD is responsible for its own direct file writes being committed at natural turn seams. A "natural seam" is:
- End of a substantive turn where files were written
- On explicit Steve request ("commit that")
- Before authoring a task prompt that will cite the files just written (so CC sees a consistent tree)

### CD-authored commit mechanics (amended Turn 37; further amended Turn 4 — see D-09)

**As of D-09 (2026-04-20T18:52:56-04:00), the preferred CD commit mechanic is:**

1. CD writes the commit message text directly to `.git\COMMIT_EDITMSG_cd` via Filesystem MCP `write_file` tool, in the same turn as the file edits being committed.
2. Steve runs ONE command: `git add -A docs/; git commit -F .git\COMMIT_EDITMSG_cd; Remove-Item .git\COMMIT_EDITMSG_cd` (or equivalent for the actual stage scope).

This eliminates the multi-line PowerShell here-string copy-paste. See D-09 for full rationale, BOM-safety analysis, and edge cases.

The PowerShell here-string pattern documented below remains as a **fallback** for when Filesystem MCP write is unavailable.

---

**Fallback pattern (PowerShell here-string — use only if Filesystem MCP write is unavailable):**

CD has no git tool — it writes files via the Filesystem MCP but cannot execute `git` on Steve's machine. Therefore CD-authored commits are produced via this two-actor pattern:

1. **CD drafts the commit command** with trailers populated correctly, including `Authored-By-Instance: cd-{color}`
2. **Steve executes the command** in PowerShell

The `Authored-By-Instance` trailer is honest: CD authored the file contents; Steve's role is mechanical command execution. No content decisions are delegated.

Steve remains the only actor who performs `git push`.

### Recommended commit-message delivery: `-F <file>`, NOT multi-`-m`

Early experience (Turn 29) showed that PowerShell's handling of multiple `-m` flags with empty-string arguments is unreliable. PowerShell swallows empty `-m ""` arguments, which corrupts the message body structure and can make git interpret trailer lines as pathspecs.

**Canonical CD commit pattern (works reliably on PowerShell):**

1. CD emits two blocks to Steve: the `git add` command, then a commit-via-file block.
2. The commit-via-file block uses a PowerShell here-string to write the message to a temp file, then `git commit -F <file>`, then deletes the temp file.
3. The temp file lives under `.git/` (never committed, never pushed) with a distinctive name like `.git/COMMIT_EDITMSG_cd`.
4. File encoding MUST be BOM-free to avoid U+FEFF leaking into the commit subject. PowerShell 5.x's `Out-File -Encoding utf8` writes WITH BOM; use `-Encoding utf8NoBOM` (PowerShell 6+) OR `-Encoding ascii` OR write via `[System.IO.File]::WriteAllText($path, $content)` which defaults to BOM-free UTF-8.
5. Message file structure: subject on line 1, **blank line** on line 2, then trailer block. The blank line is aesthetic but recommended — git parses the trailers either way (confirmed Turn 32 via `git log --pretty="%(trailers)"`), but visual readability improves with the separator.

**Reference pattern CD emits to Steve (fill in the specifics per commit):**

````powershell
# Step 1: stage files
git add <file1> <file2> ...

# Step 2: write commit message (BOM-free) and commit
$msg = @"
{SUBJECT LINE}

Task-Id: {TASK-ID}
Authored-By-Instance: cd-{color}
Decision: D-{n}                       # if applicable
Refs: {spec, decision, plan}          # if applicable
Co-Authored-By: Claude Desktop <noreply@anthropic.com>
"@
[System.IO.File]::WriteAllText(".git/COMMIT_EDITMSG_cd", $msg)
git commit -F .git/COMMIT_EDITMSG_cd
Remove-Item .git/COMMIT_EDITMSG_cd
````

The blank line between subject and the first trailer line is required for visual readability and improves some git tools' trailer parsing. The `@"` ... `"@` here-string accepts multi-line content without escape gymnastics.

**CC-authored commits** follow the same `-F <file>` pattern — CC has shell access so it writes the file directly and runs `git commit -F`. Multi-`-m` is discouraged for CC commits too; uniformity reduces failure modes.

**What NOT to do (anti-patterns discovered):**
- `git commit -m "{subject}" -m "" -m "{trailer1}" -m "{trailer2}" ...` — PowerShell drops empty-string `-m`, breaking the message
- `Out-File -Encoding utf8 ...` in PowerShell 5.x — writes UTF-8 with BOM, which leaks U+FEFF into the commit subject
- Inline `git commit -m $("...")` with embedded newlines — PowerShell quoting rules eat the newlines

### Related Turn-specific lessons

- **Turn 29:** Multi-`-m` failure on PowerShell; empty `-m ""` swallowed.
- **Turn 32:** BOM detected in `git log --format=fuller` output as `﻿` before the subject line. Verified that `git log --pretty="%(trailers)"` still returned the four trailer lines cleanly, so tooling was unaffected but visual display was marred.

Full decision record: this document.

---

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
