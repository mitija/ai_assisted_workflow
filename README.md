# AI Assisted Workflow

A reusable set of agent instructions, skills, and project templates for
AI-assisted, spec-driven, red / green phases software development. Drop into any project to give
AI coding agents a consistent, structured workflow.

This is part of my working philosophy - I constantly refine and improve on my workflows. As I work on a project I also work on improving these set of files

## What's inside

```
agents/          Agent instructions and skills (copy/symlink to ~/.agents)
  AGENTS.md        Generic agent guidance for all projects
  AGENTS.odoo.md   Odoo-specific companion (testing, source layout, DB/instances)
  project_context.template.yaml  Template for machine/project-specific config
  agent/           opencode agent definitions (conductor, reviewer)
  skills/          Reusable agent skills (coding-standards, test-scenarios, etc.)
docs/            Methodology documentation
tools/           Shell scripts and utilities
```

## Quick start

```bash
git clone <repo-url>
./tools/install.sh
```

This symlinks `agents/` to `~/.agents` and `agents/agent/` to
`~/.config/opencode/agent` (so opencode discovers the bundled agents).
Alternatively, copy the directories manually.

## How it works

1. Run the `init-project` skill — it copies
   [`agents/project_context.template.yaml`](agents/project_context.template.yaml) to your project root as
   `project_context.yaml` and guides you through filling in local paths, commands, and credentials.
2. The agent reads `AGENTS.md` and `project_context.yaml` at the start of each
   session to understand the project context and workflow.
3. Follow the [spec-driven workflow](docs/AI_assisted_development_workflow.md) described in the methodology docs.

## Skills

| Skill | Description |
|-------|-------------|
| `coding-standards` | Logging and code quality standards |
| `init-project` | Initialize or inspect a project's `project_context.yaml` configuration file |
| `spec-refinement` | Guided session that refines a rough requirement before specification-methodology |
| `specification-methodology` | 5-step spec writing (Models, Roles, Use Cases, Documentation, Review) |
| `test-scenarios` | Writing contractual, customer-facing test scenarios |
| `todo-list` | TDD-based TODO list generator (Red → Green → Commit phases) |

## Agents

| Agent | Description |
|-------|-------------|
| `conductor` | Decomposes work into an ordered, dependency-aware task graph, spawns sub-agents to execute each task (in parallel where the graph allows), verifies each result, commits per task via the `committer` agent, and aborts on failure. Runs interactively (asks on ambiguity) or autonomously (records assumptions and continues). Writes a report to `docs/working/`. |
| `committer` | Inspects staged/unstaged changes, groups them by topic, and makes one or more focused commits with clear messages. Never tags, pushes, or creates branches unless explicitly asked. |
| `reviewer` | Reviews work for correctness, style, and completeness. Read-only agent — produces a structured review plan with findings and verdict, but never edits files or runs side-effect commands. |

## License

MIT
