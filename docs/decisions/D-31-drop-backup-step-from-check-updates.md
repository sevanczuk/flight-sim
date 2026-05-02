# D-31 \u2014 Drop the per-session backup step from `check updates`

**Created:** 2026-05-02T14:23:46-04:00
**Source:** CD Purple session \u2014 Turn 19; Steve approved skipping the backup step at Purple Turn 15 with a flag for revisiting in a fresh decision; this decision formalizes that simplification
**Status:** Adopted
**Supersedes:** None (revises a step inside `docs/commands/check_updates.md`; the command itself is preserved)
**Decision class:** Convention / process simplification (same spirit as D-29)

---

## Decision

Drop step 1 ("Backup") from the `check updates` procedure at `docs/commands/check_updates.md`. Renumber remaining steps from 4 down to 3, with the cross-consistency check becoming step 4 (was step 5).

The backup step previously instructed CD to copy each of the four CD-maintained status files to `{filename}_backup.md` in the same directory before applying updates. The intent was a quick-restore safety net during the update session.

In a single-developer git-tracked project, this safety net is redundant: every prior version of every tracked file is already preserved in git history. Restore-from-prior-version is `git show HEAD:<path> > /tmp/restore.md` or `git restore <path>`; both are faster, more targeted, and don't add clutter to the repo.

---

## Why D-31 now

The redundancy was visible at the original `check_updates.md` authoring time (Purple Turn 3, 2026-04-25), but the command was reconstituted from the photoprinting template under time pressure and no one questioned the inherited backup step.

At Purple Turn 15 (2026-05-02), running `check updates` for the first time since multiple D-29-style simplifications had landed, the backup step felt out of place against the new lighter convention baseline. Steve confirmed at Turn 16 that he didn't want the backup files. D-31 formalizes the change.

This decision is the smallest scope variant of the same instinct that produced D-29 (drop commit-message ceremony) and the unwritten conventions around skipping ntfy in CD-emit-Steve-runs blocks (Turn 12). The pattern: **inherited ceremony that doesn't earn its cost in a single-developer git-backed project gets pruned when noticed.**

---

## What's removed

The procedure step formerly numbered 1:

> ### Step 1: Backup
>
> Copy the current file to `{filename}_backup.md` in the same directory, overwriting any previous backup. Git/GitHub preserves full version history \u2014 the backup exists only as a quick-restore safety net during the update session.

The acknowledgment "git/GitHub preserves full version history" inside the original step text is itself the strongest argument for removing the step.

---

## What's preserved

Everything else in `check_updates.md` is unchanged:

- The four target files
- The archive-completed-items step (now step 1)
- The update-the-primary-file step (now step 2)
- The Last-updated metadata line update (now step 3)
- The cross-consistency check (now step 4)
- The recommended sequence (CC_Task_Prompts_Status.md \u2192 Spec_Tracker.md \u2192 Task_flow_plan \u2192 priority_task_list)
- The scope rules (CD only, no in-line git ops, no same-turn substitution)

---

## Recovery procedure (if a `check updates` pass needs to be undone)

If a CD `check updates` pass is incorrect and needs reversion before commit:

1. `git diff <file>` shows the proposed changes
2. `git restore <file>` discards the changes
3. The file is back to its pre-update state

If the changes have already been committed:

1. `git revert <commit-sha>` creates a new commit reversing the prior one (preferred; preserves history)
2. Or `git reset --hard HEAD~1` if the commit hasn't been pushed (rewrites history; not preferred but available)

These are the recovery paths the backup file was approximating; the git versions are strictly better.

---

## Consequences

- **`docs/commands/check_updates.md`** is updated in the same turn as this decision. Step renumbering applied. New "What's not in the procedure (and why)" section added explaining the omission for future readers who might wonder.
- **No flag file** for `check_updates.md` because the command file is project-internal, not a Claude.ai-uploaded file. Future CD sessions read the file directly.
- **Memory note:** `userMemories` carries no entry specific to the backup step, so no memory edit needed.
- **Existing `*_backup.md` files** (if any happen to be on disk from prior `check updates` runs) can be deleted at convenience. They're not currently in `.gitignore` so a `git status` will surface them; cleanup is a one-shot `rm` away.

---

## Related

- D-29 (commit policy simplification \u2014 same spirit; supersedes D-04)
- `docs/commands/check_updates.md` (the command this decision modifies)
- Memory slot 17 (CD/CC roles and update cadence \u2014 unaffected)
