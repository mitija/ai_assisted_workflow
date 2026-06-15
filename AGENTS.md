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
  skills/
    coding-standards/SKILL.md  Logging and code quality standards
    init-project/SKILL.md      Initialize project_context.yaml
    specification-methodology/ 5-step spec writing methodology
    test-scenarios/SKILL.md    Contractual customer-facing test scenarios
    todo-list/SKILL.md         TDD-based TODO list generator
  .gitignore                   Ignores project_context.yaml and *.ini credentials
docs/
  AI_assisted_development_workflow.md  The methodology these files encode
tools/
  install.sh                   Symlinks agents/ to ~/.agents
local/                         Unversioned scratch material (not in git)
```

## Skills

| Skill | When to load |
|---|---|
| `coding-standards` | Writing or modifying any application code, script, or service |
| `init-project` | `project_context.yaml` is missing or incomplete |
| `specification-methodology` | Creating or writing software specifications |
| `test-scenarios` | Authoring or reviewing `<epic>_TESTS.md` contractual scenarios |
| `todo-list` | Generating a TDD-based TODO list for entry-level programmers |

## Working on this repo

### What counts as a change

This repo has no application code. A "task" here is editing one or more of:
- `agents/AGENTS.md` or `agents/AGENTS.odoo.md`
- `agents/project_context.template.yaml`
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

### Minimal diff

Make the smallest change that satisfies the intent. Do not reformat surrounding
content, reorganise unrelated sections, or change wording outside the scope of
the task.

### No commits without asking

Never run `git commit` or any git write operation unless explicitly asked.

### Keep PROJECT_SUMMARY.md current

After any substantive change, update `PROJECT_SUMMARY.md` to reflect current
state (not a changelog — current state only).

## Definition of Done (for this repo)

Before reporting a task complete:

- [ ] The changed file is internally consistent and valid (YAML, Markdown).
- [ ] The consistency triangle is checked (template ↔ AGENTS.md ↔ init-project skill).
- [ ] `README.md` skills table is up to date.
- [ ] `PROJECT_SUMMARY.md` reflects the new state.
- [ ] Nothing committed unless asked.
