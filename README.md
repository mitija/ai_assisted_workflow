# AI Assisted Workflow

A reusable set of agent instructions, skills, and project templates for
AI-assisted, multi-step task orchestration — code, documentation, configuration,
research, and more. Drop into any project to give AI coding agents a consistent,
structured workflow. Spec-driven development with red/green phases is a key
supported workflow.

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
3. Use the **conductor** agent as a general orchestrator for multi-step tasks.
   For spec-driven feature implementation, follow the workflow described in
   [docs/AI_assisted_development_workflow.md](docs/AI_assisted_development_workflow.md).

## End-to-end flow

The **conductor** agent orchestrates any multi-step task — code implementation,
documentation, configuration, research, project setup, and more. Its workflow is
split across five phases, each loaded from a `conductor-*` skill on demand:

### Phase 1 — Analyze

The conductor determines the goal, scope, and constraints; identifies the type
of work needed (code vs non-code); and gathers relevant context. If the
requirement is rough or ambiguous, it resolves questions interactively with the
user.

### Phase 2 — Decompose

Depending on the work type, the conductor loads the appropriate decomposition
skill:

- **`conductor-code-decomposition`** — for code-related tasks. If the
  requirement is rough, it first loads `spec-refinement` then
  `specification-methodology` to produce a spec, then uses the `todo-list` skill
  to generate a TDD-based TODO list and a dependency-aware task graph.
- **`conductor-noncode-decomposition`** — for non-code tasks (documentation,
  configuration, research, project setup). Produces a task graph directly.

### Phase 3 — Execute

The `conductor-execute` skill guides topological-round execution: ready tasks
are spawned in parallel via `general` sub-agents, each task is verified with
appropriate checks (e.g. lint, typecheck, tests, build) on completion, and
passing tasks are committed via the
`committer` sub-agent. After the graph is exhausted, the `reviewer` performs a
final audit; critical or blocking findings trigger a remediation loop that
repeats review until no critical or blocking findings remain, while warnings and suggestions are assessed by the
conductor and do not trigger another reviewer invocation on their own.

### Phase 4 — Escalate on failure

If a task fails verification, the `conductor-escalate` skill spawns `escalate1`
(first-tier, read-only diagnosis + task plan) and, if needed, `escalate2`
(second-tier, deep-dive) before continuing or aborting.

### Phase 5 — Report

The `conductor-report` skill writes a full report to `docs/working/` covering
every task, its verification result, reviewer findings and resolution, and the
overall status.

The conductor runs in **interactive mode** by default (it consults the user when
it encounters ambiguity) and switches to **autonomous mode** when requested.

### Spec-driven development (supported workflow)

A key use case of the conductor is spec-driven feature implementation. In this
workflow, the specification is written interactively before the conductor runs:

1. **Refine** a rough requirement with `spec-refinement` (one question at a time
   until entities, relationships, and business rules are clear).
2. **Write the spec** with `specification-methodology` (models, roles, use
   cases).
3. **Write contractual tests** with `test-scenarios` (every business rule mapped
   to a `T-NN` scenario in `<epic>_TESTS.md`).
4. **Freeze** the spec doc repo with a tag (e.g. `spec-260613`).

The conductor then runs its general flow against the frozen spec. It loads the
spec docs at the current tag, determines what to implement — for example, by
comparing against the previous implementation tag — and drives development
through the five phases above. Verification runs the contractual tests as part
of every task round.

The user typically touches the process at two points: writing/refining the spec
and freezing it, then reviewing the final report. Everything between runs
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
| `reviewer` | Reviews work for correctness, style, and completeness. Read-only agent — produces a structured review plan with findings, verdict, and an implementation-ready task list where every task specifies exact file path + line, concrete change, rationale, dependencies, and a verify command with expected result. Prohibits vague/deferred wording; unresolved ambiguities are reported as blockers rather than left for the implementer. Never edits files or runs anything beyond a curated set of read-only inspection commands (git status/show/log/diff/blame, grep, ls, echo). |
| `escalate1` | First-tier escalation. Diagnoses failures the normal build agent cannot resolve and produces an ordered task plan for a cheaper model to execute. Read-only — never edits files; may run a curated set of read-only inspection commands (git status/show/log/diff/blame, grep, ls, echo) to gather diagnostic context. |
| `escalate2` | Second-tier escalation. Deep-dive diagnosis on hard problems — spec ambiguities, complex logic errors, cross-cutting refactors. Produces a task plan for a cheaper model to execute. Read-only. Called when Escalate1 cannot resolve. |

## License

MIT
