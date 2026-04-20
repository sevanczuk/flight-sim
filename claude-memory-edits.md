# Claude.ai Memory — flight-sim

**Canonical source:** `docs/templates/memory_bootstrap.md` (initial 22 slots); `docs/decisions/D-04-*.md`, `docs/decisions/D-05-*.md` (slots 23–25)
**Generated:** 2026-04-19T00:00:00-04:00 (initial draft)
**Last synced:** 2026-04-20T09:10:00-04:00 (Purple Turn 40 — 25 slots live; file mirrors live memory exactly)
**Purpose:** Exact flat mirror of the 30-slot Claude.ai memory system. Git-tracked backup and bootstrap source. Contains exactly what is in Claude.ai memory — no more.

---

1. User operates a multi-instance Claude workflow: Claude Desktop (CD) for design and planning; Claude Code (CC) for implementation and file operations. CD/CC split is a hard boundary — CD does not implement, CC does not design.

2. Three colored CD instances (Green, Yellow, Purple) run in parallel. Each reads only its own color's checkpoint files on session init. Fallback: latest non-colored file, then no prior context.

3. Every CD response begins with turn number and ISO 8601 timestamp from a system command (never estimated). Colored instances prefix with color: "Green Turn N — ...".

4. CC task lifecycle: prompt written by CD → CC executes → completion report → compliance check (check completions → check compliance) → archive to docs/tasks/completed/ on PASS.

5. CC task prompts must be fully self-contained. CC starts each session fresh. Never reference content in other prompt files by proxy.

6. Status document maintenance: Spec_Tracker.md, CC_Task_Prompts_Status.md, and priority_task_list.md are CD-maintained. CC does not update them. "check updates" refreshes all three.

7. File provenance: all files under docs/ include Created: and Source: header fields. Does not apply to src/, tests/, config/, scripts/.

8. Issue tracking: ITM- (general), G- (spec review gaps), O- (spec review opportunities), FE- (future enhancements). Paired files: issue_index.md (open) + issue_index_resolved.md (closed).

9. Decision logging: write entry on the turn a decision is made, in docs/decisions/. Log broadly. Decision = (a) scope/design/architecture; (b) convention/process refinements; (c) revisions of prior decisions; (d) workflow/tooling changes. Tripwire: prescriptive language (should/must/lesson/pattern) or revising any convention requires a log entry. End substantive turns with "-> Decision log: wrote D-{seq}…" or "-> no decisions this turn". Never defer — compaction risk.

10. Spec review pipeline: /spec-review command runs multi-agent review. Three tiers: quick (5 agents), standard (8 agents, default), full (12 agents). Four execution batches. Grades A–F per agent. Findings auto-assigned G-n/O-n IDs.

11. Spec versioning: _V{n} suffix; initial draft is V1. Version bump = findings incorporated. Implementation-ready = zero CRITICAL/HIGH (or remaining explicitly deferred).

12. CRP (Compaction Resilience Protocol): apply to multi-phase tasks, docs >500 lines, tasks >15 min. Work directory at {project_root}/_crp_work/{task_id}/. Status in _status.json. Phase completion markers in _phase_{X}_complete.md.

13. Check completions protocol: CD reads prompt + completion report → generates compliance prompt → CC runs compliance → CD reviews (PASS: archive; FAIL: bug-fix task).

14. Task validation (DOC-021 v2.x): Phase 0 source-of-truth audit by CC (blocking gate). Three-layer validation post-implementation. CC generates validation prompt from template.

15. Spec lifecycle tracker: per-spec JSON at docs/specs/lifecycle/{DOC-ID}_lifecycle.json. CD creates; CC updates via PUT /api/lifecycle/{spec_id}. Gitignored (runtime state).

16. CC launch: two-step sequence in separate code blocks. Tab title: $env:CLAUDE_CODE_DISABLE_TERMINAL_TITLE = "1"; $host.UI.RawUI.WindowTitle = "{label}"; claude --dangerously-skip-permissions --model opusplan

17. ntfy notification after every git commit: Invoke-RestMethod -Uri "https://ntfy.sh/1668651d-48ae-4104-b09e-f742b559e205" -Method Post -Body "{message}"

18. Python code always in .py files — never inline python -c commands. PowerShell's quoting makes inline commands fragile.

19. Path separators: backslash. Always use the project root and data paths configured in Layer 4.

20. Project: flight-sim. Root: C:/Users/artroom/projects/flight-sim-project/flight-sim

21. Test command (flight-sim): TBD

22. ntfy channel: 1668651d-48ae-4104-b09e-f742b559e205

23. D-04 commit trailer policy: all commits include trailers. Mandatory: Task-Id, Authored-By-Instance (cc, cd-green, cd-yellow, cd-purple, cd, steve). Conditional: Refs, Fixes, Supersedes, Decision. CC+CD commits also include Co-Authored-By: Claude Code or Claude Desktop <noreply@anthropic.com>. CC does not push. CD does not push. Only Steve pushes.

24. CD commit mechanics (D-04): CD drafts command, Steve executes. CD has no git tool. Use git commit -F <file> (NOT multiple -m flags — PowerShell swallows empty -m ""). Write message via [System.IO.File]::WriteAllText (NOT Out-File — writes BOM). Temp file at .git/COMMIT_EDITMSG_cd using Join-Path $PWD for absolute path. Blank line between subject and trailer block.

25. D-05 "assess" shorthand: when Steve says "assess" (or "review") and references a review-artifact file, trigger the protocol matching the filename. *_completion.md → check completions. *_compliance.md → check compliance. *_validation.md → check validation. *_review.md → spec review triage. The literal trigger phrase without a filename means process ALL unprocessed files of that type.
