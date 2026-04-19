# Domain Agent Design Guide

**Purpose:** How to create project-specific spec review agents for the Basecamp `/spec-review` pipeline.

## Quick Start

1. Copy `core/agents/_domain_agent_template.md` to `.claude/agents/spec-{domain}-reviewer.md`
2. Fill in the domain-specific sections
3. The agent is auto-detected by `/spec-review` (filesystem scan of `spec-*-reviewer.md`)

## Agent File Structure

Every domain agent follows this structure:

### Role (required)
One sentence: what this agent checks. Example: "Verify FAR/AIM regulatory compliance of all aviation training content."

### Scope (required)
What sections or aspects of specs this agent examines. Be specific — agents that try to check everything check nothing well.

### Grading Criteria (required)
A–F scale with concrete criteria per grade. The grades must be calibrated to the domain — an "A" in FAA compliance means something different from an "A" in code quality.

### Finding Categories (required)
Define what constitutes CRITICAL, HIGH, MEDIUM, and LOW findings in your domain. These should be actionable — a reviewer reading the finding should know what to fix.

### Domain Knowledge (required)
Reference material, standards, regulations, or expertise that this agent applies. This is the agent's "brain" — the more specific and authoritative the references, the better the findings.

### Output Persistence
All domain agents use this standard block:
> Findings are written by the spec-review pipeline, not by the agent directly. Finding IDs use the pipeline's auto-numbering scheme (G-n, O-n).

## Registration

Domain agents are auto-detected by the `/spec-review` command via filesystem scan of `.claude/agents/spec-*-reviewer.md`. No configuration file update required.

## Batch Assignment

Domain agents default to Batch 4 (run last, after core quality checks). To override, edit the batch constants in your project's `.claude/commands/spec-review.md`.

Override examples:
- FAA compliance → Batch 1 (foundational — regulatory violations block everything)
- Flight instruction accuracy → Batch 2 (content correctness before integration checks)
- Radio communications → Batch 4 (lower priority, default is fine)

## Example: aviation-rag Domain Agents

| Agent | Domain | Batch |
|-------|--------|-------|
| spec-cfii-reviewer | Flight instruction accuracy | 2 |
| spec-dpe-reviewer | Practical test standards | 3 |
| spec-faa-reviewer | FAR/AIM regulatory compliance | 1 |
| spec-weather-reviewer | Meteorological accuracy | 3 |
| spec-radio-reviewer | Radio communications standards | 4 |
