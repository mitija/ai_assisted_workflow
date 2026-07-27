# AI Assisted Workflow

A reusable framework of agent instructions, skills, and project templates for
structured long-horizon work: software, documentation, configuration, research,
and project setup. Spec-driven development is the most mature supported workflow;
broader non-code workflows use the same decomposition and evidence principles but
are still evolving.

## Framework steps

1. **Human intent:** the human provides the problem, desired outcome, high-level
   criteria, constraints, and consequential decisions.
2. **Conductor-led delivery:** the conductor performs a thin Analyze gate for modes,
   permissions, context readiness, work classification, analyst-baseline
   sufficiency, and objective/scope alignment. When needed, it transparently drives
   the analyst's contract work and setup/readiness, while the analyst retains
   ownership of the functional contract through four phases:
   - **Intake:** establish the objective brief and analysis mode.
   - **Discovery:** perform evidence-first functional-contract discovery.
   - **Review:** perform the requirements quality gate and guided validation.
   - **Baseline:** establish stable IDs, traceability, and evidence mapping.
   The analyst produces stable requirements, provenance, traceability, verification
   definitions, wireframes, and intended documentation, recording sources, findings,
   confidence, assumptions, and provenance, including motivation, beneficiaries,
   outcomes, and reasonable user or operational expectations, without presenting
   inferred expectations as explicit human requirements. The conductor then
   decomposes, executes, reviews, escalates failures, and reports for code and
   non-code work. The baseline identifies applicable contractual scenarios, code
   unit-test expectations, verification/evidence methods, and non-code acceptance
   criteria / evidence before decomposition; passing results are required during
   Execute and at completion, not before decomposition.
3. **Evidence and judgement:** implementers and the verifier produce evidence;
   the reviewer audits it; the conductor assesses the functional outcome; and the
   human makes the final outcome judgement.

The analyst's `analysis_mode` (`guided` or `autonomous`) governs requirements
analysis and is independent of the conductor's `interaction_mode` (`interactive`
or `autonomous`) for handling orchestration ambiguity.

## Strengths and benefits

- Separates human intent, functional-contract ownership, and delivery execution.
- Makes inferred decisions visible through provenance rather than presenting them
  as human requirements.
- Connects objective, requirements, acceptance criteria, verification, and evidence
  through stable traceability.
- Supports both code and non-code work without prescribing the implementer's AI
  workflow.
- Keeps implementation cycles short when the baseline is precise, with review and
  outcome checks beyond passing tests.

## Quick start

```bash
git clone <repo-url>
./tools/install.sh
```

The installer symlinks `agents/` to `~/.agents`, `agents/agent/` to
`~/.config/opencode/agent`, and `skills/` to `~/.config/opencode/skills`.
Alternatively, copy the directories manually. The conductor is the normal delivery
entry: it transparently invokes the analyst when a baseline is missing or stale and
owns initialization, tooling, environment, command/layout discovery, permission,
and setup readiness, delegating mechanics to the appropriate agents. Direct analyst
invocation remains the specialist, analysis-only path. The conductor invokes
`init-project` when `project_context.yaml` is absent or unusable. Init requires
`schema_version: 2`, infers visible typed profiles such as `code`, `non_code`, and
`odoo`, and asks only for missing fields in selected profiles. Missing or unsupported
context requires explicit reinitialization or conversion; v1 readability or
preservation is not promised. Controlled self-describing extensions are preserved
only for valid v2 context. Secrets and external-path authorization remain
protected. Agents read the resulting context and `AGENTS.md` at the start of each
session.

## Known limitations

- Analysis quality is the main bottleneck. A flawed baseline can produce a
  conforming but unwanted result, especially in autonomous analysis.
- Human gates and final outcome judgement remain necessary for consequential
  decisions, guided validation, and intent-versus-delivery assessment.
- Verification is strongest for functional software behaviour. Non-functional
  requirements, external triggers, UI/UX nuance, and non-code outcomes have
  weaker or less standardized verification paths.
- The framework reduces adoption cost through conductor automation: the conductor
  transparently drives analyst readiness and handles initialization, tooling,
  environment, command/layout, permission, and setup readiness. Project-specific
  authorization and genuine hard blockers remain irreducible. The framework is
  production-ready for its core use case but remains evolving; analysis quality and
  weaker verification for some outcomes remain genuine limitations.
- Trivial or bounded, low-risk requests may use a consolidated proportionate
  baseline and only the applicable artefacts. Even this lightweight path requires a
  minimum objective and scope, acceptance and requirements, verification and
  evidence, objective/scope alignment, no unresolved blocker, and analyst readiness.
  Material, ambiguous, or high-risk work follows the full path with deeper analysis,
  traceability, specifications, and contractual tests as applicable.
- Profile-aware context reduces irrelevant setup fields while requiring valid v2
  schema and profile validation; controlled extensions are preserved only for valid
  v2 context.

## What the repository contains

```
agents/          Agent instructions and opencode agent definitions
  AGENTS.md        Generic guidance for all projects
  AGENTS.odoo.md   Odoo-specific companion
  create-spec-tag  Safe annotated documentation-tag wrapper
  project_context.template.yaml  Project configuration template
  agent/           analyst, conductor, reviewer, verifier, committer, and escalation agents
skills/          Reusable and conductor-specific skills
docs/            Methodology and workflow documentation
tools/           Installation scripts and utilities
```

## Documentation

- [`docs/AI_assisted_development_workflow.md`](docs/AI_assisted_development_workflow.md)
  — authoritative overview and topic navigation.
- [`docs/workflow/README.md`](docs/workflow/README.md) — detailed wiki index.
- [`docs/workflow/philosophy.md`](docs/workflow/philosophy.md) — rationale and
  guiding principles.

## Skills

General skills are reusable by any agent or user, except that the four
`analyst-*` lifecycle skills are loaded by the analyst agent rather than directly
by users or general agents. Conductor-specific skills are loaded automatically by
the conductor during its workflow.

### Analyst lifecycle skills

| Skill | Description |
|---|---|
| [`analyst-intake`](skills/analyst-intake/SKILL.md) | Phase 1: objective brief and analysis mode. |
| [`analyst-discovery`](skills/analyst-discovery/SKILL.md) | Phase 2: evidence-first functional-contract discovery. |
| [`analyst-review`](skills/analyst-review/SKILL.md) | Phase 3: requirements quality gate and guided validation package. |
| [`analyst-baseline`](skills/analyst-baseline/SKILL.md) | Phase 4: stable IDs, traceability, and evidence mapping. |

### Other general skills

| Skill | Description |
|---|---|
| [`coding-standards`](skills/coding-standards/SKILL.md) | Standards for application code, currently logging. |
| [`handover`](skills/handover/SKILL.md) | Create session-end handover documents. |
| [`init-project`](skills/init-project/SKILL.md) | Initialize or inspect `project_context.yaml`. |
| [`specification-methodology`](skills/specification-methodology/SKILL.md) | Optional post-baseline specification structuring. |
| [`test-scenarios`](skills/test-scenarios/SKILL.md) | Write contractual customer-facing test scenarios. |
| [`todo-list`](skills/todo-list/SKILL.md) | Generate TDD-based implementation TODOs. |

### Conductor-specific skills

| Skill | Description |
|---|---|
| [`conductor-analyze`](skills/conductor-analyze/SKILL.md) | Phase 1: goal, scope, constraints, and analyst readiness. |
| [`conductor-code-decomposition`](skills/conductor-code-decomposition/SKILL.md) | Phase 2: code task graph generation. |
| [`conductor-noncode-decomposition`](skills/conductor-noncode-decomposition/SKILL.md) | Phase 2: non-code task graph generation. |
| [`conductor-execute`](skills/conductor-execute/SKILL.md) | Phase 3: execution and verification. |
| [`conductor-escalate`](skills/conductor-escalate/SKILL.md) | Phase 5: failure diagnosis and recovery. |
| [`conductor-report`](skills/conductor-report/SKILL.md) | Phase 6: final report generation. |

## Agents

| Agent | Role | Invocable as |
|---|---|---|
| [`analyst`](agents/agent/analyst.md) | Functional contract owner; never implements application code. | Both |
| [`conductor`](agents/agent/conductor.md) | Primary delivery orchestrator. | Primary |
| [`committer`](agents/agent/committer.md) | Focused commit grouping and execution. | Subagent |
| [`reviewer`](agents/agent/reviewer.md) | Read-only correctness and completeness audit. | Both |
| [`escalate1`](agents/agent/escalate1.md) | First-tier read-only failure diagnosis. | Subagent |
| [`escalate2`](agents/agent/escalate2.md) | Deep-dive read-only failure diagnosis. | Subagent |
| [`verifier`](agents/agent/verifier.md) | Runs delegated verification commands and records evidence. | Subagent |

## License

MIT
