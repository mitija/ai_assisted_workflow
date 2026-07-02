# HANDOVER-02

**Created**: 2026-07-03
**Session summary**: Reworked the conductor agent from a single monolithic file into a slim agent file + 6 conductor-* skills loaded on demand.
**Previous handover**: HANDOVER-01.md

---

## Project goal

This repository (`all_agents`) maintains a reusable AI agent configuration bundle: a base `AGENTS.md` to drop into projects, an Odoo-specific companion (`AGENTS.odoo.md`), a project config template (`project_context.template.yaml`), opencode agent definitions (`agent/conductor.md`, `agent/committer.md`, `agent/reviewer.md`, `agent/escalate1.md`, `agent/escalate2.md`), and a library of reusable skills (`skills/`). The goal is a consistent spec-driven workflow across all projects, refined continuously.

## Current implementation status

The conductor agent has been rearchitected. This session:

- **Created** 6 new skills under `agents/skills/conductor-*/` covering each phase of the conductor's workflow.
- **Slimmed** `agents/agent/conductor.md` from 203 lines (~10.5KB) to 98 lines (~4.5KB) — a 57% reduction in base prompt size.
- **Updated** `PROJECT_SUMMARY.md`, `README.md`, and the skills table to reflect the new structure.

All existing components remain internally consistent. The repo is a guidance/skill bundle — no application code.

## Important files

| File | Purpose |
|------|---------|
| `AGENTS.md` (workspace root) | Meta-guidance for working on this repo itself. Consistency triangle, skills table, DoD checklist. |
| `agents/AGENTS.md` | Deployable agent guidance for all projects. |
| `agents/agent/conductor.md` | **Slimmed** — opencode conductor agent definition. Identity, modes, routing table (phase → skill links), shared task schema, sub-agents table, core rules. |
| `agents/skills/conductor-analyze/SKILL.md` | **New** — Phase 1: goal/scope/constraints analysis, context gathering, interactive vs autonomous, routing to decomposition. |
| `agents/skills/conductor-code-decomposition/SKILL.md` | **New** — Phase 2 (code): spec-refinement → specification-methodology pipeline, TODOxx.md check/generation via todo-list, TD→graph mapping. |
| `agents/skills/conductor-noncode-decomposition/SKILL.md` | **New** — Phase 2 (non-code): plainer task list, same per-task schema, no spec/todo dependencies. |
| `agents/skills/conductor-execute/SKILL.md` | **New** — Phase 3: topological rounds, parallel `general` spawns, per-task verification, serialize commits via `committer`. |
| `agents/skills/conductor-escalate/SKILL.md` | **New** — Phase 4: stop/record/not-commit, escalate1 → explore → retry, escalate2 → abort. |
| `agents/skills/conductor-report/SKILL.md` | **New** — Phase 5: delegate report to `general` sub-agent, report format. |
| `agents/agent/committer.md` | opencode agent definition — groups changes by topic into focused commits. |
| `agents/agent/reviewer.md` | opencode agent definition — read-only code review. |
| `agents/agent/escalate1.md` | opencode agent definition — first-tier escalation (read-only). |
| `agents/agent/escalate2.md` | opencode agent definition — second-tier escalation (deep-dive). |
| `agents/skills/coding-standards/SKILL.md` | Coding standards (logging). |
| `agents/skills/handover/SKILL.md` | Creates self-contained HANDOVER-xx.md at session end. |
| `agents/skills/init-project/SKILL.md` | Scan-first project_context.yaml initializer. |
| `agents/skills/spec-refinement/SKILL.md` | One-question-at-a-time requirement refinement. |
| `agents/skills/specification-methodology/SKILL.md` | 5-step spec writing. |
| `agents/skills/test-scenarios/SKILL.md` | Contractual test scenario authoring. |
| `agents/skills/todo-list/SKILL.md` | TDD-based TODO list generator. |
| `PROJECT_SUMMARY.md` | Current state summary of the project (updated this session). |
| `README.md` | Project overview, end-to-end flow, skills/agents tables (updated this session). |
| `docs/AI_assisted_development_workflow.md` | The methodology all guidance files encode. |
| `tools/install.sh` | Symlinks `agents/` to `~/.agents` and `agents/agent/` to `~/.config/opencode/agent`. |

## Recent changes

- **Created** `agents/skills/conductor-analyze/SKILL.md` — Phase 1: determine goal, scope, work type (code vs non-code), gather context via `explore`, resolve ambiguities, route to correct decomposition skill.
- **Created** `agents/skills/conductor-code-decomposition/SKILL.md` — Phase 2 (code): loads spec-refinement → specification-methodology if rough, checks for existing TODOxx.md, generates via todo-list if needed, maps TDs to task graph with standard schema, validates.
- **Created** `agents/skills/conductor-noncode-decomposition/SKILL.md` — Phase 2 (non-code): same per-task schema, no spec/todo dependencies, for docs/config/research/setup work.
- **Created** `agents/skills/conductor-execute/SKILL.md` — Phase 3: topological rounds, parallel ready-set spawn, per-task verification after each round, serialize commits via `committer`, route to escalate on failure.
- **Created** `agents/skills/conductor-escalate/SKILL.md` — Phase 4: stop spawning, let current round finish, escalate1 → explore → retry, escalate2 → abort, interactive checkpoints per tier.
- **Created** `agents/skills/conductor-report/SKILL.md` — Phase 5: delegate report to `general` sub-agent, format with summary + per-task detail + ambiguities.
- **Slimmed** `agents/agent/conductor.md` — from 203 lines to 98 lines. Kept identity, modes, routing table with skill links, shared task schema, sub-agents table, core rules. Removed all detailed phase guidance (moved to skills).
- **Updated** `PROJECT_SUMMARY.md` — replaced conductor repo-layout description and added design note about the skill-based split.
- **Updated** `README.md` — updated Phase 2 flow description, conductor agent description, and added 6 conductor-* skills to the skills table with [Conductor-internal] tag.

## Key decisions and rationale

| Decision | Rationale |
|----------|-----------|
| Split conductor workflow into 6 separate skills (analyze, code-decomposition, noncode-decomposition, execute, escalate, report) | Reduces base prompt from ~10.5KB to ~4.5KB (57% savings per turn). Segregates code-work from non-code-work flows — non-code runs never load the code-decomposition skill. Phase instructions load on demand, not every turn. |
| Code and non-code decomposition are separate skills | Max segregation: non-code work never loads the spec-refinement/specification-methodology/todo-list pipeline. The routing decision (code vs non-code) is made in the analyze phase and is lightweight. |
| Analyze phase as a separate skill rather than inline | Keeps the slim conductor truly minimal. Analyze logic can evolve independently. |
| `conductor-*` naming prefix | Groups them visually in the `skills/` directory and signals they are conductor-internal, not general-purpose skills. |
| Conductor-* skills have no `allowed-tools` frontmatter | The conductor delegates all mechanical work to sub-agents; it never reads/writes files or runs commands directly. These skills are instructional, not executable by a general agent. |
| Skills listed in README with [Conductor-internal] tag | Users can see the full set of skills in the repo, but the tag and note clarify they are not meant to be loaded directly. |

## Constraints, conventions, and architectural preferences

- **Skill format**: YAML frontmatter (`name`, `description`) followed by markdown body. Conductor-* skills omit `allowed-tools` since they are loaded by the conductor (which delegates all mechanical work).
- **Conductor routing**: The slim conductor.md contains a routing table (phase → skill). The conductor loads the relevant skill via the `skill` tool at each phase boundary. Skills are not loaded at startup — only when the conductor reaches that phase.
- **Task schema**: The per-task fields (id, dependencies, description, prompt, verification) are defined in the slim conductor.md and reused by both decomposition skills and the execute/report phases. This schema is the contract between phases.
- **Consistency triangle**: `agents/AGENTS.md` ↔ `project_context.template.yaml` ↔ `init-project/SKILL.md` must stay in sync. Not affected by this session.
- **Table updates**: When adding or removing a skill, update: `agents/AGENTS.md` skills list, root `AGENTS.md` skills table, `README.md` skills table, `PROJECT_SUMMARY.md`.
- **No git tags**: Tagging is a user action. The AI must not create git tags.
- **Minimal diff**: Smallest change that satisfies the intent. No scope-creep refactoring.
- **No secrets**: Credentials live in gitignored `project_context.yaml` / `odoo_config.ini`. Never emit them.

## Commands / tests already run and results

No application code or tests exist for this repo. No build/lint/test commands were run in this session — the changes are documentation/configuration only. The new skills were verified by checking that `~/.agents/skills/conductor-*/SKILL.md` exists (the symlink is live).

## Known issues, bugs, and risks

| Issue | Status | Notes |
|-------|--------|-------|
| `local/` directory does not exist yet | Open | Not a blocker; the repo layout references it but it is empty. `tools/install.sh` does not create it. |
| `docs/working/` directory does not exist | Open | Referenced by the conductor agent as an output directory but not yet created. Not blocking — the conductor creates it when needed. |
| Conductor-* skills are not yet tested in a live conductor session | Open | The skills are structurally complete and follow the same conventions as existing skills, but have not been exercised by a live conductor agent run. The routing links (relative paths) should be verified in a real session. |

## Pending tasks and recommended next steps

1. **Verify conductor-* skills in a live session** — Load the conductor agent and give it a task that exercises all phases (analyze → decompose → execute → report). Check that the skill-loading links work and each phase's guidance is correct when executed.
2. **Consider whether `AGENTS.md` (agents/) should reference conductor-* skills** — Currently `agents/AGENTS.md` does not list the conductor-internal skills. If the conductor is expected to be able to load them via `skill` tool, they should be discoverable. The `skill` tool discovers skills from `~/.agents/skills/`, so they should be auto-discovered, but verify this.
3. **Track remaining HANDOVER-01 pending tasks** — HANDOVER-01 listed: add handover to opencode system prompt, verify handover discoverability, add handover to agents/AGENTS.md Maintain Context section, consider adding handover to conductor prompt. These are still open.