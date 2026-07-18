# AI Assisted Workflow

A reusable set of agent instructions, skills, and project templates for
AI-assisted, multi-step task orchestration — code, documentation, configuration,
research, and more. Drop into any project to give AI coding agents a consistent,
structured workflow. Spec-driven development with red/green phases is a key
supported workflow.

## Continuous improvement

Experience from real projects feeds improvements back into the framework's skills,
agents, and workflow documents. See [`docs/workflow/philosophy.md`](docs/workflow/philosophy.md)
for the fuller rationale.

## What's inside

```
agents/          Agent instructions and opencode agent definitions (copy/symlink to ~/.agents)
  AGENTS.md        Generic agent guidance for all projects
  AGENTS.odoo.md   Odoo-specific companion (testing, source layout, DB/instances)
  project_context.template.yaml  Template for machine/project-specific config
  agent/           opencode agent definitions (conductor, committer, verifier, reviewer, escalate1, escalate2)
skills/          Reusable agent skills (symlinked via install to ~/.config/opencode/skills)
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
`skills/` to `~/.config/opencode/skills` (so the `skill` tool discovers
the bundled skills). Alternatively, copy the directories manually.

## Documentation

The full methodology is documented in two places:

- [`docs/AI_assisted_development_workflow.md`](docs/AI_assisted_development_workflow.md) — landing page with a top-level overview and status context.
- [`docs/workflow/README.md`](docs/workflow/README.md) — wiki-style collection with detailed pages on philosophy, principles, workspace layout, specification, test suite, workflow, acceptance, and known gaps.

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
appropriate checks (e.g. lint, typecheck, tests, build) on completion —
delegated to the `verifier` sub-agent for shell-command verification steps,
and passing tasks are committed via the
`committer` sub-agent. After the graph is exhausted, a **higher-level review**
is performed by the `reviewer` sub-agent: it audits all completed work against
the original goal, specification, and acceptance criteria, producing findings
classified as critical, blocking, warning, or suggestion. Critical or blocking
findings trigger a remediation loop that repeats review until no critical or
blocking findings remain, while warnings and suggestions are assessed by the
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

General skills are reusable by any agent or user. Conductor-specific skills are internal orchestration steps loaded automatically by the conductor during its workflow.

### General skills

| Skill | Description |
|-------|-------------|
| [`coding-standards`](skills/coding-standards/SKILL.md) | Coding standards when writing or modifying application code. Currently covers logging requirements. |
| [`handover`](skills/handover/SKILL.md) | Create session-end handover documents for the next chat session to continue. |
| [`init-project`](skills/init-project/SKILL.md) | Initialize or inspect a project's `project_context.yaml` configuration file. |
| [`spec-refinement`](skills/spec-refinement/SKILL.md) | Guided session that refines a rough requirement before specification-methodology. |
| [`specification-methodology`](skills/specification-methodology/SKILL.md) | 5-step spec writing methodology (Models, Roles, Use Cases, Documentation, Review). |
| [`test-scenarios`](skills/test-scenarios/SKILL.md) | Writing contractual, customer-facing test scenarios. |
| [`todo-list`](skills/todo-list/SKILL.md) | TDD-based TODO list generator (Red → Green → Commit phases). |

### Conductor-specific skills

These are loaded automatically by the conductor agent during its workflow. They are not meant to be loaded directly by users or general agents.

| Skill | Description |
|-------|-------------|
| [`conductor-analyze`](skills/conductor-analyze/SKILL.md) | [Conductor-internal] Phase 1 — goal/scope/constraints analysis. |
| [`conductor-code-decomposition`](skills/conductor-code-decomposition/SKILL.md) | [Conductor-internal] Phase 2 — code-work task graph generation (uses spec-refinement, specification-methodology, todo-list). |
| [`conductor-noncode-decomposition`](skills/conductor-noncode-decomposition/SKILL.md) | [Conductor-internal] Phase 2 — non-code task graph generation. |
| [`conductor-execute`](skills/conductor-execute/SKILL.md) | [Conductor-internal] Phase 3 — topological-round execution and verification. |
| [`conductor-escalate`](skills/conductor-escalate/SKILL.md) | [Conductor-internal] Phase 4 — failure escalation (escalate1 → escalate2). |
| [`conductor-report`](skills/conductor-report/SKILL.md) | [Conductor-internal] Phase 5 — final report generation. |

## Agents

General agents usable directly by the user or as sub-agents. See each agent's definition for detailed invocation rules.

| Agent | Role / Description | Invocable as |
|-------|-------------------|--------------|
| [`conductor`](agents/agent/conductor.md) | Orchestrates multi-step work end to end. Runs on a better AI model than sub-agents — owns the thinking, planning, and decision-making. The workflow is split across six conductor-* skills loaded on demand, so the base prompt stays small. Interactive by default for ambiguity resolution; autonomous when requested. | Primary |
| [`committer`](agents/agent/committer.md) | Groups changes by topic and makes focused commits with clear messages. Never tags. Does not push or create branches unless explicitly asked. | Subagent |
| [`reviewer`](agents/agent/reviewer.md) | Reviews work for correctness, style, and completeness. Read-only agent — produces a structured review plan with findings and remediation tasks. Never edits files; runs only read-only inspection commands. | Both |
| [`escalate1`](agents/agent/escalate1.md) | First-tier escalation. Read-only diagnosis of build failures + ordered task plan. | Subagent |
| [`escalate2`](agents/agent/escalate2.md) | Second-tier escalation. Deep-dive diagnosis of hard problems (spec ambiguities, complex logic, cross-cutting refactors). Read-only. | Subagent |
| [`verifier`](agents/agent/verifier.md) | Runs exact delegated verification commands, reports structured PASS/FAIL/BLOCKED evidence. Never edits files. | Subagent |

## License

MIT
