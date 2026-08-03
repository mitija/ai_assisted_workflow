# AI Assisted Workflow

A reusable framework of agent instructions, skills, and project templates for
structured long-horizon work: software, documentation, configuration, research,
and project setup. Spec-driven development is the most mature supported workflow;
broader non-code workflows use the same decomposition and evidence principles but
are still evolving.

## Framework steps

1. **Human intent:** the human provides the problem, desired outcome, high-level
   criteria, constraints, and consequential decisions.
2. **Conductor-led delivery:** the conductor analyzes the goal, scope, constraints,
   and work type, then decomposes the work into a dependency-aware task graph. It
   delegates implementation and mechanical work to sub-agents across six phases:
   **Analyze, Decompose, Execute, Review, Escalate, and Report**. Ready tasks may
   run in parallel; the verifier checks delegated commands, the committer handles
   focused commits, and the reviewer audits the completed work. Interactive mode is
   the default, so genuine ambiguity is resolved with the user rather than filled
   with assumptions.
3. **Evidence and judgement:** task verification, contractual tests, review findings,
   and the final report provide evidence of what was delivered. The human remains
   responsible for consequential decisions and the final outcome judgement.

For spec-driven coding, the workflow can refine a rough requirement, structure the
specification, write contractual test scenarios, and generate TDD-based implementation
tasks. Implementation is performed against the frozen documentation state recorded in
the project context. For non-code work, explicit acceptance criteria and evidence
replace the software test suite where appropriate.

## Strengths and benefits

- Separates intent, task decomposition, implementation, verification, and review.
- Makes unresolved ambiguity a visible blocker instead of an implementation
  assumption.
- Applies one orchestration model to code, documentation, configuration, research,
  and project setup.
- Connects spec-driven implementation to a frozen documentation tag, contractual
  scenarios, and Red / Green / Commit task phases.
- Provides verification, final review, failure diagnosis, and a report rather than
  stopping after code generation.

## Quick start

```bash
git clone <repo-url>
./tools/install.sh
```

The installer symlinks `agents/` to `~/.agents`, `agents/agent/` to
`~/.config/opencode/agent`, and `skills/` to `~/.config/opencode/skills`.
Alternatively, copy the directories manually. The conductor is the normal entry
point for multi-step work; it delegates file changes and command execution to the
appropriate sub-agents.

For a project using the framework:

1. Run the `init-project` skill when `project_context.yaml` is absent. It copies
   [`agents/project_context.template.yaml`](agents/project_context.template.yaml)
   and guides you through the project-specific paths, commands, and configuration.
2. Keep `AGENTS.md` and `project_context.yaml` at the project root so agents can
   read the project guidance and context at the start of a session.
3. Invoke the **conductor** for a multi-step task. For the spec-driven coding path,
   follow the workflow described in
   [`docs/AI_assisted_development_workflow.md`](docs/AI_assisted_development_workflow.md).

## Known limitations

- The quality of the specification and contractual tests remains the main
  determinant of the result. A bad specification can produce bad software on
  schedule.
- AI-assisted drafting controls drift between the specification and implementation,
  but customer or stakeholder validation is still needed to catch drift between
  intent and the specification.
- The current workflow assumes a technically fluent consultant who can make or
  validate architectural decisions. A purely functional consulting workflow would
  need an additional technical-design and architecture-review step.
- Plain-English contractual scenarios must still be translated into executable
  tests, and API or scheduled-job triggers can be awkward to validate behaviourally.
- Non-functional requirements and non-code outcomes have less standardized
  verification than functional software behaviour.
- Linear documentation tags and an intentionally unspecified developer-side AI
  workflow are adequate for the current model but do not cover every multi-team or
  long-running delivery shape.

See the [known gaps and open questions](docs/workflow/known-gaps-and-open-questions.md)
for the fuller assessment.

## What the repository contains

```
agents/          Agent instructions and OpenCode agent definitions
  AGENTS.md        Generic guidance for all projects
  AGENTS.odoo.md   Odoo-specific companion
  project_context.template.yaml  Project configuration template
  agent/           conductor, committer, verifier, reviewer, and escalation agents
skills/          Reusable and conductor-specific skills
docs/            Methodology and workflow documentation
tools/           Installation scripts and utilities
```

## Documentation

- [`docs/AI_assisted_development_workflow.md`](docs/AI_assisted_development_workflow.md)
  - authoritative methodology overview and topic navigation.
- [`docs/workflow/README.md`](docs/workflow/README.md) - detailed wiki index.
- [`docs/workflow/philosophy.md`](docs/workflow/philosophy.md) - rationale and
  guiding principles.
- [`docs/workflow/known-gaps-and-open-questions.md`](docs/workflow/known-gaps-and-open-questions.md)
  - current limitations and areas for feedback.

## Skills

General skills are reusable by any agent or user. Conductor-specific skills are
internal orchestration steps loaded automatically by the conductor during its
workflow.

### General skills

| Skill | Description |
|---|---|
| [`coding-standards`](skills/coding-standards/SKILL.md) | Coding standards when writing or modifying application code. Currently covers logging requirements. |
| [`handover`](skills/handover/SKILL.md) | Create session-end handover documents for the next chat session to continue. |
| [`init-project`](skills/init-project/SKILL.md) | Initialize or inspect a project's `project_context.yaml` configuration file. |
| [`spec-refinement`](skills/spec-refinement/SKILL.md) | Guided session that refines a rough requirement before specification-methodology. |
| [`specification-methodology`](skills/specification-methodology/SKILL.md) | Five-step specification methodology covering models, roles, use cases, documentation, and review. |
| [`test-scenarios`](skills/test-scenarios/SKILL.md) | Write contractual, customer-facing test scenarios. |
| [`todo-list`](skills/todo-list/SKILL.md) | Generate TDD-based implementation TODOs with Red, Green, and Commit phases. |

### Conductor-specific skills

| Skill | Description |
|---|---|
| [`conductor-analyze`](skills/conductor-analyze/SKILL.md) | Phase 1: goal, scope, and constraints analysis. |
| [`conductor-code-decomposition`](skills/conductor-code-decomposition/SKILL.md) | Phase 2: code-work task graph generation. |
| [`conductor-noncode-decomposition`](skills/conductor-noncode-decomposition/SKILL.md) | Phase 2: non-code task graph generation. |
| [`conductor-execute`](skills/conductor-execute/SKILL.md) | Phase 3: topological-round execution and verification. |
| [`conductor-escalate`](skills/conductor-escalate/SKILL.md) | Phase 5: failure diagnosis and recovery. |
| [`conductor-report`](skills/conductor-report/SKILL.md) | Phase 6: final report generation. |

## Agents

| Agent | Role | Invocable as |
|---|---|---|
| [`conductor`](agents/agent/conductor.md) | Primary orchestrator for multi-step code and non-code work. | Primary |
| [`committer`](agents/agent/committer.md) | Groups changes by topic and makes focused commits. | Subagent |
| [`reviewer`](agents/agent/reviewer.md) | Read-only correctness and completeness audit. | Both |
| [`escalate1`](agents/agent/escalate1.md) | First-tier read-only failure diagnosis. | Subagent |
| [`escalate2`](agents/agent/escalate2.md) | Deep-dive read-only failure diagnosis. | Subagent |
| [`verifier`](agents/agent/verifier.md) | Runs delegated verification commands and records evidence. | Subagent |

## License

MIT
