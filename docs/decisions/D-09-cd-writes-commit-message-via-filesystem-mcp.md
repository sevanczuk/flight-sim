# D-09: Amend D-04 — CD writes commit message file directly via Filesystem MCP

**Created:** 2026-04-20T18:52:56-04:00
**Source:** Purple Turn 4 — Steve flagged copy-paste friction with the D-04 PowerShell here-string commit pattern; this decision moves the file-writing burden from Steve to CD
**Decision type:** convention / mechanics refinement (amends D-04)
**Amends:** D-04

## Decision

CD writes the commit message file directly to `.git\COMMIT_EDITMSG_cd` via the Filesystem MCP `write_file` tool, in the same turn it makes the doc/file edits being committed. Steve then runs a single short PowerShell command to stage, commit, and clean up.

This supersedes D-04's "CD-authored commit mechanics" section's PowerShell here-string pattern as the **preferred** path. The PowerShell here-string remains documented as a **fallback** for cases where Filesystem MCP write is unavailable (rare).

## New canonical CD commit pattern

**CD's responsibilities (silent, in same turn as doc edits):**

1. After making file edits, draft the commit message text (subject + body + D-04 trailer block).
2. Write the message to `.git\COMMIT_EDITMSG_cd` via Filesystem MCP `write_file`.
3. Provide Steve a single command block.

**What Steve sees in the response:**

````powershell
git add -A docs/; git commit -F .git\COMMIT_EDITMSG_cd; Remove-Item .git\COMMIT_EDITMSG_cd
````

(The exact `git add` argument may vary — `-A docs/`, `-A`, or specific paths depending on what was modified. CD chooses based on the scope of the turn's work.)

That's it. One paste, one Enter, done.

## Why Filesystem MCP write is BOM-safe

Filesystem MCP `write_file` is implemented over Node's `fs.writeFile` which defaults to UTF-8 without BOM. The BOM-detection problem from D-04 §Turn 32 (caused by PowerShell 5.x `Out-File -Encoding utf8` adding BOM) does not apply to the Filesystem MCP write path.

**Verification protocol:** for the first commit using this new mechanic (Purple Turn 4 — this decision's own commit), inspect the resulting `git log --format=fuller -1` output for the U+FEFF leading character on the subject line. If detected, fall back to the PowerShell here-string pattern and document the issue here. If absent, the new mechanic is confirmed and becomes default.

## Trade-offs vs alternatives (considered and rejected)

| Alternative | Rejected because |
|---|---|
| CC task per CD commit | Massive overhead — CC session setup/teardown for a 1-second action; kills velocity gain that D-04 trailer policy provides |
| Revert to one-line commit messages (no trailers) | Loses `Authored-By-Instance`, `Task-Id`, `Decision`, `Refs` greppability; undoes the audit trail D-04 was created to establish |
| Batch commits at end-of-session only | Reduces frequency but doesn't fix per-commit friction; also loses turn-grain attribution; can layer on Option 3 if needed but not a substitute |
| Git commit template (`commit.template` config) | Still requires hand-editing the template every commit; more friction not less |

## Edge cases

- **Concurrent CD commits in queue:** If CD writes `.git\COMMIT_EDITMSG_cd` while a previous CD commit message hasn't been consumed yet, the second write overwrites the first. Mitigation: commit between every CD turn that produces a commit-worthy delta. If queueing becomes a real problem (multiple uncommitted CD turns), switch to timestamped filenames like `.git\COMMIT_EDITMSG_cd_T{N}` — but don't optimize prematurely.
- **CD turns with no file changes:** No commit needed; CD doesn't write the message file. Same as before.
- **CC commits:** Unchanged. CC already writes its own message file via PowerShell `[System.IO.File]::WriteAllText` from inside the CC bash environment. CC never reads CD's `.git\COMMIT_EDITMSG_cd` and there's no path conflict.
- **CC tasks where CD also writes files in the same session:** CD's `.git\COMMIT_EDITMSG_cd` is for CD's commits only. CC writes its own message to the same path is acceptable — they don't run concurrently. If a turn produces both CD-edits and a CC task, CD's commit happens before the CC task launches; no conflict.

## Consequences

- D-04's §CD commit execution mechanics section gets a header pointing to D-09 as the new preferred path (small surgical edit on D-04, documented here)
- `claude-conventions.md` §Git Commit Trailers / §CD commit execution mechanics needs the same update
- Refresh flag for `claude-conventions.md` (already pending — no new flag needed)
- Steve's per-commit copy-paste burden drops from ~25 lines to 1 line
- D-04's trailer audit benefits are fully preserved
- BOM verification on this commit determines whether the new mechanic ships as default or remains opt-in

## Related

- D-04 (commit trailer policy — amends mechanics section)
- D-07 (compliance triage — recently logged decision exercising the commit pattern)
- D-08 (completion-report verification — same)
- `claude-conventions.md` §Git Commit Trailers (needs update)
