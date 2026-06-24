# HANDOVER-01

**Created**: 2026-06-24
**Session summary**: Added the `handover` skill and created the first-handover document.
**Previous handover**: None

---

## Project goal

This repository (`all_agents`) maintains a reusable AI agent configuration bundle: a base `AGENTS.md` to drop into projects, an Odoo-specific companion (`AGENTS.odoo.md`), a project config template (`project_context.template.yaml`), opencode agent definitions (`agent/conductor.md`, `agent/committer.md`, `agent/reviewer.md`, `agent/escalate1.md`, `agent/escalate2.md`), and a library of reusable skills (`skills/`). The goal is a consistent spec-driven workflow across all projects, refined continuously.

## Current implementation status

All existing components are internally consistent and functional. The repo is a guidance/skill bundle — no application code. The project has been stable; this session added a new skill (`handover`) and this handover document.

## Important files

| File | Purpose |
|------|---------|
| `AGENTS.md` (workspace root) | Meta-guidance for working on this repo itself. Consistency triangle, skills table, DoD checklist. |
| `agents/AGENTS.md` | Deployable agent guidance for all projects. Spec-driven workflow, build/lint/verify, DoD, skills. |
| `agents/AGENTS.odoo.md` | Odoo-specific companion (testing, source layout, DB/instances, acceptance demo). |
| `agents/project_context.template.yaml` | Template for machine/project-specific config. |
| `agents/agent/conductor.md` | opencode agent definition — orchestration agent that decomposes work into a task graph, spawns `general` sub-agents, verifies, commits, escalates on failure. |
| `agents/agent/committer.md` | opencode agent definition — groups changes by topic into focused commits. |
| `agents/agent/reviewer.md` | opencode agent definition — read-only code review with structured findings. |
| `agents/agent/escalate1.md` | opencode agent definition — first-tier escalation (read-only diagnosis + task plan). |
| `agents/agent/escalate2.md` | opencode agent definition — second-tier escalation (deep-dive diagnosis). |
| `agents/skills/handover/SKILL.md` | **New** — creates self-contained `HANDOVER-xx.md` at session end. |
| `agents/skills/coding-standards/SKILL.md` | Coding standards (currently logging). |
| `agents/skills/init-project/SKILL.md` | Scan-first `project_context.yaml` initializer. |
| `agents/skills/spec-refinement/SKILL.md` | One-question-at-a-time requirement refinement. |
| `agents/skills/specification-methodology/SKILL.md` | 5-step spec writing (Models, Roles, Use Cases, Documentation, Review). |
| `agents/skills/test-scenarios/SKILL.md` | Contractual `<epic>_TESTS.md` scenario authoring. |
| `agents/skills/todo-list/SKILL.md` | TDD-based TODO list generator (Red → Green → Commit). |
| `PROJECT_SUMMARY.md` | Current state summary of the project. |
| `skills/handover/SKILL.md` | Mirrored copy of the handover skill (workspace root level, same content as `agents/skills/handover/SKILL.md`). |
| `README.md` | Project overview, quick-start, end-to-end flow, skills/agents tables. |
| `docs/AI_assisted_development_workflow.md` | The methodology all guidance files encode. |
| `tools/install.sh` | Symlinks `agents/` to `~/.agents` and `agents/agent/` to `~/.config/opencode/agent`. |

## Recent changes

- Created `agents/skills/handover/SKILL.md` — the new skill definition with YAML frontmatter, usage guidance, step-by-step instructions, document template, and quality checklist.
- Created `skills/handover/SKILL.md` — mirrored copy at the workspace root level.
- Updated `agents/AGENTS.md` — added `handover` to the skills list.
- Updated workspace root `AGENTS.md` — added `handover` to the repo layout block and skills table.
- Updated `README.md` — added `handover` to the skills table.
- Updated `PROJECT_SUMMARY.md` — added `handover` skill to the layout description and skills bullet.
- Created `HANDOVER-01.md` — this file.

## Key decisions and rationale

| Decision | Rationale |
|----------|-----------|
| Handover skill stored in both `agents/skills/handover/` and `skills/handover/` | The `agents/skills/` directory is the deployable bundle (symlinked to `~/.agents`); `skills/` at workspace root mirrors it for local reference. Both must be kept in sync. |
| Handover files named `HANDOVER-xx.md` with incremental counter | Provides clear ordering and prevents overwrites. Counter is determined by scanning existing files. |
| Handover document is self-contained — no assumed prior conversation context | The next agent opening a new chat has zero access to the previous conversation. Every detail needed to continue must be in the document. |

## Constraints, conventions, and architectural preferences

- **Skill format**: YAML frontmatter (`name`, `description`, `allowed-tools`) followed by markdown body with `When to use`, step-by-step `Instructions`, and a `Quality checklist`.
- **Consistency triangle**: `agents/AGENTS.md` ↔ `project_context.template.yaml` ↔ `init-project/SKILL.md` must stay in sync. This does not apply to the `handover` skill directly.
- **Mirroring**: Skills live in `agents/skills/<name>/SKILL.md` (deployable) and `skills/<name>/SKILL.md` (workspace root). Both must be updated when a skill is added/changed.
- **Table updates**: When adding or removing a skill, update: `agents/AGENTS.md` skills list, root `AGENTS.md` skills table, `README.md` skills table, `PROJECT_SUMMARY.md`.
- **No git tags**: Tagging is a user action. The AI must not create git tags.
- **Minimal diff**: Smallest change that satisfies the intent. No scope-creep refactoring.
- **No secrets**: Credentials live in gitignored `project_context.yaml` / `odoo_config.ini`. Never emit them.

## Commands / tests already run and results

No application code or tests exist for this repo. No build/lint/test commands were run in this session — the changes are documentation/configuration only.

## Known issues, bugs, and risks

| Issue | Status | Notes |
|-------|--------|-------|
| `local/` directory does not exist yet | Open | Not a blocker; the repo layout references it but it is empty. `tools/install.sh` does not create it. |
| `docs/working/` directory does not exist | Open | Referenced by the conductor agent as an output directory but not yet created. Not blocking — the conductor creates it when needed. |

## Pending tasks and recommended next steps

1. **Add the `handover` skill to the opencode system prompt** — The available skills list in the opencode configuration should include `handover` so the agent knows to load it at session end. Update `opencode.json` or related config.
2. **Verify the `handover` skill is discoverable** — After `tools/install.sh` is run, check that `~/.agents/skills/handover/SKILL.md` exists.
3. **Add `handover` to the `agents/AGENTS.md` Maintain Context section** — The Maintain Context section (line 93) describes `PROJECT_SUMMARY.md` but does not mention `HANDOVER-xx.md`. Add a note that the handover skill should be used at session end.
4. **Consider adding `handover` to the conductor agent prompt** — The conductor (`agents/agent/conductor.md`) may benefit from a session-end handover step.
