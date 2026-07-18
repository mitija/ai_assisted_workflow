# AI Agent Configs — Project AGENTS.md

This repository maintains my personal AI agent configuration: a base `AGENTS.md`
to drop into projects, an Odoo-specific companion, a project config template, and
a library of reusable skills.

The goal is a consistent, spec-driven workflow across all projects, refined
continuously as I work.

## Repository Layout

```
agents/                        Deployable agent bundle (symlinked to ~/.agents)
  AGENTS.md                    Generic agent guidance — drop into any project
  AGENTS.odoo.md               Odoo-specific companion (testing, DB, acceptance)
  project_context.template.yaml  Template for machine/project-specific config
  agent/
    conductor.md               Conductor orchestration agent (opencode agent definition)
    committer.md               Committer agent — groups changes into focused commits (opencode agent definition)
    reviewer.md                Reviewer agent — read-only code review (opencode agent definition)
    escalate1.md               First-tier escalation agent — read-only diagnosis + task plan
    escalate2.md               Second-tier escalation agent — deep-dive diagnosis + task plan
    verifier.md                Verification agent — runs exact delegated commands, reports PASS/FAIL/BLOCKED
  skills/
    coding-standards/SKILL.md  Logging and code quality standards
    handover/SKILL.md          Create session-end handover documents
    init-project/SKILL.md      Initialize project_context.yaml
    spec-refinement/SKILL.md   Refine a rough requirement before specification-methodology
    specification-methodology/ 5-step spec writing methodology
    test-scenarios/SKILL.md    Contractual customer-facing test scenarios
    todo-list/SKILL.md         TDD-based TODO list generator
    conductor-*/SKILL.md       [Conductor-internal] six phase skills loaded on demand by the conductor
  .gitignore                   Ignores project_context.yaml and *.ini credentials
opencode.json                  Per-agent model assignments (merged with global ~/.config/opencode/opencode.json)
docs/
  AI_assisted_development_workflow.md  The methodology these files encode
  workflow/                  Detailed wiki-style collection (specification, workflow, acceptance, etc.)
tools/
  install.sh                   Symlinks agents/ to ~/.agents, agents/agent/ to ~/.config/opencode/agent, and agents/skills/ to ~/.config/opencode/skills
```

## Skills

| Skill | When to load |
|---|---|
| `handover` | Creating a self-contained `HANDOVER-xx.md` at session end for the next session to continue |
| `coding-standards` | Writing or modifying any application code, script, or service |
| `init-project` | `project_context.yaml` is missing or incomplete |
| `spec-refinement` | A rough/ambiguous requirement needs refining before specification-methodology |
| `specification-methodology` | Creating or writing software specifications |
| `test-scenarios` | Authoring or reviewing `<epic>_TESTS.md` contractual scenarios |
| `todo-list` | Generating a TDD-based TODO list for entry-level programmers |
| `conductor-analyze` | [Conductor-internal] Phase 1 — goal/scope/constraints analysis |
| `conductor-code-decomposition` | [Conductor-internal] Phase 2 — code-work task graph generation |
| `conductor-noncode-decomposition` | [Conductor-internal] Phase 2 — non-code task graph generation |
| `conductor-execute` | [Conductor-internal] Phase 3 — topological-round execution and verification |
| `conductor-escalate` | [Conductor-internal] Phase 4 — failure escalation (escalate1 → escalate2) |
| `conductor-report` | [Conductor-internal] Phase 5 — final report generation |

> **Note:** Skills prefixed with `conductor-` are loaded automatically by the
> conductor agent during its workflow. They are not meant to be loaded directly
> by users or general agents.

## Working on this repo

### What counts as a change

This repo has no application code. A "task" here is editing one or more of:
- `opencode.json` (project-level config — per-agent model assignments)
- `agents/AGENTS.md` or `agents/AGENTS.odoo.md`
- `agents/project_context.template.yaml`
- An agent definition under `agents/agent/`
- A skill file under `agents/skills/`
- `docs/AI_assisted_development_workflow.md`
- Project tooling (`tools/`, `README.md`, this file)

### Consistency rule

`agents/AGENTS.md`, `agents/project_context.template.yaml`, and the
`init-project` skill are a triangle: they must stay in sync. When any one
changes, check the other two.

- If `project_context.template.yaml` adds or removes a field, update the
  embedded template in `init-project/SKILL.md` and any field descriptions in
  `agents/AGENTS.md`.
- If `agents/AGENTS.md` references a skill, that skill must exist under
  `agents/skills/`.
- If a skill is added or removed, update both `agents/AGENTS.md` (skills table)
  and `README.md` (skills table).

### Agent definitions

opencode agents live as markdown files (YAML frontmatter + prompt body) under
`agents/agent/`. `tools/install.sh` symlinks `agents/agent/` to
`~/.config/opencode/agent`, where opencode auto-discovers them — so no
`opencode.json` entry is needed for file-based agent *discovery*. However, per-agent
model assignments should live in the project-level `opencode.json` (not in the agent
frontmatter) to keep execution config separate from agent behaviour. When adding or
changing an agent, keep the repo-layout block above, `README.md`, and
`PROJECT_SUMMARY.md` in sync. The `conductor` agent uses the `todo-list` skill for
code decomposition and the `committer` agent for commits; changes to either must
stay compatible with `agents/agent/conductor.md`.

### Minimal diff

Make the smallest change that satisfies the intent. Do not reformat surrounding
content, reorganise unrelated sections, or change wording outside the scope of
the task.

### Keep PROJECT_SUMMARY.md current

After any substantive change, update `PROJECT_SUMMARY.md` to reflect current
state (not a changelog — current state only).

## Definition of Done (for this repo)

Before reporting a task complete:

- [ ] The changed file is internally consistent and valid (YAML, Markdown).
- [ ] The consistency triangle is checked (template ↔ AGENTS.md ↔ init-project skill).
- [ ] `README.md` skills table is up to date.
- [ ] `PROJECT_SUMMARY.md` reflects the new state.
- [ ] No git tags were created (tagging is a user action only).
