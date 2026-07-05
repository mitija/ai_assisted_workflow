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
  agent/           opencode agent definitions (conductor, committer, reviewer, escalate1, escalate2)
  skills/          Reusable agent skills (coding-standards, test-scenarios, etc.)
docs/            Methodology documentation
tools/           Shell scripts and utilities
```

## Quick start

```bash
git clone <repo-url>
./tools/install.sh
```

This symlinks `agents/` to `~/.agents`, `agents/agent/` to
`~/.config/opencode/agent` (so opencode discovers the bundled agents), and
`agents/skills/` to `~/.config/opencode/skills` (so the `skill` tool discovers
the bundled skills). Alternatively, copy the directories manually.

## How it works

1. Run the `init-project` skill — it copies
   [`agents/project_context.template.yaml`](agents/project_context.template.yaml) to your project root as
   `project_context.yaml` and guides you through filling in local paths, commands, and credentials.
2. The agent reads `AGENTS.md` and `project_context.yaml` at the start of each
   session to understand the project context and workflow.
3. Follow the [spec-driven workflow](docs/AI_assisted_development_workflow.md) described in the methodology docs.

## End-to-end flow

The process splits into two phases: an **interactive** spec-writing phase and an
**autonomous** development phase.

### Phase 1 — Interactive: spec writing

The user drives this phase with guidance from skills:

1. **Refine** a rough requirement with `spec-refinement` (one question at a time
   until entities, relationships, and business rules are clear).
2. **Write the spec** with `specification-methodology` (models, roles, use
   cases).
3. **Write contractual tests** with `test-scenarios` (every business rule mapped
   to a `T-NN` scenario in `<epic>_TESTS.md`).
4. **Freeze** the spec doc repo with a tag (e.g. `spec-260613`).

The output is a tagged specification with executable tests.

### Phase 2 — Autonomous: development

From here, the **conductor** drives everything autonomously. It loads the spec
docs at the current tag and determines what to implement by diffing the specs
and tests against the previous tag — so only new or changed scenarios become
work items:

1. **Diff** — the conductor compares the current spec/tests tag against the
   previous implementation tag to identify new or changed scenarios.
2. **Decompose** — the conductor loads its `conductor-analyze` skill to determine
   goal and scope, then one of two decomposition skills: `conductor-code-decomposition`
   (uses the `todo-list` skill to break diffs into a TODOxx.md and dependency-aware
   task graph) or `conductor-noncode-decomposition` (for non-code work like docs
   and config).
3. **Execute** — the `conductor-execute` skill guides topological-round execution:
   spawns `general` sub-agents in parallel, runs verification (lint, typecheck, tests,
   build), commits passing tasks via the `committer` sub-agent.
4. **Escalate on failure** — if a task fails verification, the `conductor-escalate`
   skill guides spawning `escalate1` (first-tier, read-only diagnosis + task plan),
   then `escalate2` (second-tier, deep-dive), before aborting.
5. **Report** — the `conductor-report` skill writes a full report to `docs/working/`
   covering every task, its verification result, and the overall status.

The user touches the process at two points: writing/refining the spec (Phase 1),
and reviewing the final report (end of Phase 2). Everything between runs
autonomously by default.

## Skills

| Skill | Description |
|-------|-------------|
| `coding-standards` | Logging and code quality standards |
| `handover` | Create session-end handover documents for the next chat |
| `init-project` | Initialize or inspect a project's `project_context.yaml` configuration file |
| `spec-refinement` | Guided session that refines a rough requirement before specification-methodology |
| `specification-methodology` | 5-step spec writing (Models, Roles, Use Cases, Documentation, Review) |
| `test-scenarios` | Writing contractual, customer-facing test scenarios |
| `todo-list` | TDD-based TODO list generator (Red → Green → Commit phases) |
| `conductor-analyze` | [Conductor-internal] Phase 1 — goal/scope/constraints analysis |
| `conductor-code-decomposition` | [Conductor-internal] Phase 2 — code-work task graph generation (uses spec-refinement, specification-methodology, todo-list) |
| `conductor-noncode-decomposition` | [Conductor-internal] Phase 2 — non-code task graph generation |
| `conductor-execute` | [Conductor-internal] Phase 3 — topological-round execution and verification |
| `conductor-escalate` | [Conductor-internal] Phase 4 — failure escalation (escalate1 → escalate2) |
| `conductor-report` | [Conductor-internal] Phase 5 — final report generation |

> **Note:** Skills prefixed with `conductor-` are loaded automatically by the conductor agent during its workflow. They are not meant to be loaded directly by users or general agents.

## Agents

| Agent | Description |
|-------|-------------|
| `conductor` | Plans and orchestrates multi-step work end to end. Runs on a better AI model than sub-agents — owns the thinking, planning, and decision-making. The workflow is split across six conductor-* skills loaded on demand (analyze, code-decomposition, noncode-decomposition, execute, escalate, report) so the base prompt stays small and only relevant phase instructions are loaded. Interactive by default for ambiguity resolution; autonomous when requested. |
| `committer` | Inspects staged/unstaged changes, groups them by topic, and makes one or more focused commits with clear messages. Never tags. Does not push or create branches unless explicitly asked. |
| `reviewer` | Reviews work for correctness, style, and completeness. Read-only agent — produces a structured review plan with findings and verdict, but never edits files or runs anything beyond a curated set of read-only inspection commands (git status/show/log/diff/blame, grep, ls, echo). |
| `escalate1` | First-tier escalation. Diagnoses failures the normal build agent cannot resolve and produces an ordered task plan for a cheaper model to execute. Read-only — never edits files; may run a curated set of read-only inspection commands (git status/show/log/diff/blame, grep, ls, echo) to gather diagnostic context. |
| `escalate2` | Second-tier escalation. Deep-dive diagnosis on hard problems — spec ambiguities, complex logic errors, cross-cutting refactors. Produces a task plan for a cheaper model to execute. Read-only. Called when Escalate1 cannot resolve. |

## License

MIT
