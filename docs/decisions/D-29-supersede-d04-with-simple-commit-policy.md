# D-29 — Simple commit policy supersedes D-04 trailer policy

**Created:** 2026-05-02T08:14:04-04:00
**Source:** CD Purple session — Turn 10; Steve's reassessment of D-04's value in a single-developer context
**Status:** Adopted
**Supersedes:** D-04
**Decision class:** Convention / process simplification

---

## Decision

Replace the structured trailer block from D-04 with a simple commit format. The flight-sim repository is a single-developer project; the parallel-CD-instance attribution model that justified D-04's ceremony is theoretical, not operational. This decision reduces commit-message overhead and eliminates the BOM-free heredoc-and-file mechanics that D-04 required.

### Commit message format

**Subject:**

```
{TASK-ID}: {brief description} [AI commit]
```

- `{TASK-ID}:` prefix when the commit relates to a tracked task; omit otherwise.
- `[AI commit]` tag when CC or CD authored the commit; omit when Steve authored.
- Verb-led description for non-task commits (e.g., `Remove stale refresh flag`).

**Body (optional, free-form prose):**

Include when context is useful — what changed and why, briefly. Multi-paragraph allowed.

**Optional reference lines (use only when applicable):**

- `Refs: D-XX, OTHER-TASK-ID, spec-name` — when the commit references decisions, prior tasks, or specs
- `Fixes: ITM-XX` — when the commit closes a tracked issue
- `Supersedes: <commit-sha>` — when the commit replaces a prior commit's intent

These lines appear at the bottom of the message, separated from the body by a blank line.

### What's removed from D-04

- `Task-Id:` trailer (the subject line carries this)
- `Authored-By-Instance:` trailer (the `[AI commit]` tag is sufficient at AI-vs-human granularity)
- `Co-Authored-By:` trailer (redundant with `[AI commit]`)
- `Decision:` trailer (subsumed by `Refs:`)
- All BOM-free heredoc / `git commit -F <file>` mechanics

### What's preserved from D-04

- CC, CD, and Steve all commit; only Steve pushes.
- CC and CD commits should include the `[AI commit]` subject tag.
- CD commits its own direct file writes at natural turn seams.

---

## Mechanics

### CD commit execution

CD emits two simple PowerShell blocks (a `git add` line and a `git commit -m` line). Steve copy-pastes and runs. No file-based commit messages, no BOM concerns.

```powershell
git add <file1> <file2> ...

git commit -m "{subject line}" -m "{optional body paragraph}" -m "Refs: D-XX"
```

PowerShell renders each `-m` argument as a paragraph separated by a blank line. The `-m "" -m "..."` empty-string failure mode that drove D-04's heredoc requirement is avoided by simply not having empty `-m` arguments — every `-m` carries real content.

### CC commit execution

CC has direct shell access and writes its own commits via `git commit -m "..." -m "..."`. Same simple format.

---

## Examples

**CC task commit:**

```
GNX375-PAGEMAP-PYMUPDF-01: build page_number_map.json from PyMuPDF metadata [AI commit]

Mechanical transform from page_metadata.json to page_number_map.json (schema v2.0). Applies D-28 PAP-22 override on page 2. 8/8 built-in sanity checks pass; 310 total / 306 parsed / 4 unparseable.

Refs: D-28
```

**CD decision commit:**

```
D-29: supersede D-04 with simple commit policy [AI commit]

Drops the structured trailer block, the BOM-free heredoc mechanics, and the parallel-CD-instance attribution. Subject + optional body + optional Refs/Fixes/Supersedes lines is sufficient for a single-developer project.

Refs: D-04, ITM-13
```

**Steve manual commit:**

```
Remove stale refresh flag
```

**Bug-fix commit closing an ITM:**

```
GNX375-PAGEMAP-PYMUPDF-02: fix override-rationale field name mismatch [AI commit]

Renames extras[*].override_rationale_ref to override_decision_ref to match the schema spec at GNX375-PAGEMAP-PYMUPDF-01-COMPLIANCE finding L4.

Fixes: ITM-XX
Refs: D-28
```

---

## Consequences

- **CLAUDE.md** §Conventions and §Git: trailer-related guidance replaced with the simple format above. Refresh flag required.
- **claude-conventions.md** §Git Commit Trailers: section replaced. The "CD commit execution mechanics" subsection (heredoc + BOM-free + `git commit -F`) is removed entirely. Refresh flag required.
- **docs/templates/CC_Task_Prompt_Template.md** Completion Protocol: trailer-format examples replaced with simple format.
- **D-04** is marked Superseded with a header pointer to D-29; not deleted (audit trail preserved).
- **ITM-13** (CC commit subject contains UTF-8 BOM) closes — D-29 makes the failure mode unreachable. The BOM came from PowerShell `Out-File -Encoding utf8` writing message files; with no message files, no BOM.
- **Existing commits** with D-04 trailers stay as-is. No history rewrite. Mixed-format history is acceptable; the rollover boundary is documented here.
- **`git log --grep`** for task IDs still works (subject contains them). `git log --grep="\[AI commit\]"` surfaces AI-authored commits.
- **Memory note:** `userMemories` carries a detailed D-04 entry. That entry is now stale. Steve to update via `memory_user_edits` at his discretion.

---

## Why D-04 made sense at the time, and why it doesn't now

D-04 was authored on 2026-04-20 (Purple Turns 25–27) when the parallel-CD-instance model (green/yellow/purple) was newly adopted and there was a real question of how to attribute commits across concurrent sessions. The mechanics amendments (BOM-free writes, `-F <file>` pattern) were responses to actual PowerShell failures in real flight-sim work.

What changed:

1. The parallel-CD model in flight-sim is, in practice, sequential — only one CD session is active on the repo at a time. Color identifiers help distinguish session contexts conceptually but the commit-attribution problem they were designed to solve doesn't materialize.
2. The mechanics overhead (heredoc + BOM-free write + `git commit -F` + cleanup) costs ~10 lines of PowerShell per commit. For a one-line decision-record commit, that's a 10:1 ceremony-to-content ratio.
3. ITM-13 (CC committing with BOM in subject) is the canonical example of mechanics fragility. With plain `git commit -m`, the failure mode is gone.

D-04 was correct work for its moment. The simplification here is honest reassessment, not retraction of the original reasoning.

---

## Related

- D-04 (commit trailer policy — superseded by this decision)
- ITM-13 (BOM-in-commit-subject — closes with D-29)
- D-09 (CD writes commit message via Filesystem MCP — obsolete; the file-based commit pattern is dropped)
