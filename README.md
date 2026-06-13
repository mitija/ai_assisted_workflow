# AI Agent Configs

A reusable set of agent instructions, skills, and project templates for
AI-assisted, spec-driven software development. Drop into any project to give
AI coding agents a consistent, structured workflow.

## What's inside

```
agents/          Agent instructions and skills (copy/symlink to ~/.agents)
  AGENTS.md        Generic agent guidance for all projects
  AGENTS.odoo.md   Odoo-specific companion (testing, source layout, DB/instances)
  project_context.template.yaml  Template for machine/project-specific config
  skills/          Reusable agent skills (coding-standards, test-scenarios, etc.)
docs/            Methodology documentation
tools/           Shell scripts and utilities
```

## Quick start

```bash
git clone <repo-url>
./tools/install.sh
```

This symlinks `agents/` to `~/.agents`. Alternatively, copy the directory manually.

## How it works

1. Copy `agents/project_context.template.yaml` to your project root as
   `project_context.yaml` and fill in your local paths, commands, and credentials.
2. The agent reads `AGENTS.md` and `project_context.yaml` at the start of each
   session to understand the project context and workflow.
3. Follow the spec-driven workflow described in `docs/AI_assisted_development_workflow.md`.

## Skills

| Skill | Description |
|-------|-------------|
| `coding-standards` | Logging and code quality standards |
| `test-scenarios` | Writing contractual, customer-facing test scenarios |
| `specification-methodology` | 5-step spec writing (Models, Roles, Use Cases, Documentation, Review) |
| `todo-list` | TDD-based TODO list generator for entry-level programmers |

## License

MIT
