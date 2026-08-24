# AI Assisted Workflow

A reusable framework of agent instructions, skills, and project templates for
structured long-horizon work: software, documentation, configuration, research,
and project setup. Spec-driven development is the most mature supported workflow;
broader non-code workflows use the same decomposition and evidence principles but
are still evolving.

## Version 3

Version 1 worked, but required substantial manual intervention.

Version 2 aimed to support longer-horizon work through many constraints and checks,
which created overhead and left tasks unfinished.

Version 3 supports long-horizon work by giving the AI greater autonomy, guided by
preserving task intent and success criteria rather than adding constraints.

Version 3 is still evolving, and initial trials of the `fast` agent are promising.

## Framework steps

1. **Human intent:** the human provides the problem, desired outcome, high-level
   criteria, constraints, and consequential decisions.
2. **Fast-led delivery:** the default `fast` agent first understands intent, then
   defines success criteria before planning, prepares a plan, reviews the plan against
   intent and criteria, executes, and reviews the result. After intent and
   criteria are established, it proceeds autonomously, automatically invokes
   ordered escalation for failures when needed, makes and documents non-blocking
   decisions guided by them, and stops only for genuine blockers;
   its report includes those decisions when it made any. The selectable
   `conductor` remains available for its thorough six-phase workflow: **Analyze,
   Code or non-code Decompose, Execute, Review, automatically Escalate when needed,
   and Report**.
3. **Evidence and judgement:** task verification, contractual tests, review findings,
   and the final report provide evidence of what was delivered. Verification is
   interpreted against semantic intent and behavior, not accidental literal
   wording; exact text is binding only when it is itself a traced contract. A
   failed check is first classified as work nonconformity or a defective control,
   which is corrected and rerun without rewriting compliant work. The human
   remains responsible for consequential decisions and the final outcome judgement.

For spec-driven coding, the workflow can refine a rough requirement, structure the
specification, write contractual test scenarios, and generate TDD-based implementation
tasks. Implementation is performed against the frozen documentation state recorded in
the project context. For non-code work, explicit acceptance criteria and evidence
replace the software test suite where appropriate.

## Strengths and benefits

- Separates intent, task decomposition, implementation, verification, and review.
- Keeps delegated work bounded: tasks provide outcome, scope, context, fixed
  constraints with reasons, semantic criteria, and evidence while leaving
  unfixed implementation choices to the executor.
- Treats genuine ambiguity and required approvals as blockers, while routine
  implementation decisions are made autonomously.
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
Alternatively, copy the directories manually. `fast` is the default entry point;
the conductor is available when its thorough six-phase workflow is required.

For a project using the framework:

1. Run the `init-project` skill when `project_context.yaml` is absent. It copies
   [`agents/project_context.template.yaml`](agents/project_context.template.yaml)
   and guides you through the project-specific paths, commands, and configuration.
2. Keep `AGENTS.md` and `project_context.yaml` at the project root so agents can
   read the project guidance and context at the start of a session.
3. Use the default **fast** agent for a request, or invoke the **conductor** for its
   thorough multi-step workflow. For the spec-driven coding path,
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
  agent/           fast, conductor, committer, reviewer, and escalation agents
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
| [`fast`](agents/agent/fast.md) | Default primary agent for the six-step intent-to-result process: defines success criteria before planning, proceeds autonomously after intent and criteria are established, automatically invokes ordered escalation for failures when needed, documents non-blocking decisions guided by them, stops only for genuine blockers, and reports decisions when it made any. | Primary (default) |
| [`conductor`](agents/agent/conductor.md) | Primary orchestrator for the thorough six-phase code and non-code workflow, automatically escalating failures when needed. | Primary |
| [`committer`](agents/agent/committer.md) | Groups changes by topic and makes focused commits. | Subagent |
| [`reviewer`](agents/agent/reviewer.md) | Edit-denied correctness and completeness audit with direct diagnostic and verification Bash. | Both |
| [`escalate1`](agents/agent/escalate1.md) | First-tier edit-denied failure diagnosis with unrestricted Bash for direct diagnostics. | Subagent |
| [`escalate2`](agents/agent/escalate2.md) | Deep-dive edit-denied failure diagnosis with unrestricted Bash for direct diagnostics. | Subagent |

## License

MIT
