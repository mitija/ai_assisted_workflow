# AI Assisted Workflow

A reusable framework of agent instructions, skills, and project templates for
structured long-horizon work: software, documentation, configuration, research,
and project setup. Spec-driven development is the most mature supported workflow;
broader non-code workflows use the same decomposition and evidence principles but
are still evolving.

## Framework steps

1. **Human intent:** the human provides the problem, desired outcome, high-level
   criteria, constraints, and consequential decisions.
2. **Analyst contract:** the analyst runs intake, discovery, review, and baseline
   to produce stable requirements, provenance, traceability, verification
   definitions, wireframes, and intended documentation.
3. **Conductor delivery:** the conductor analyzes, decomposes, executes, reviews,
   escalates failures, and reports for code and non-code work.
4. **Evidence and judgement:** implementers and the verifier produce evidence;
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
Alternatively, copy the directories manually. Then run the `init-project` skill
to create and populate `project_context.yaml`; agents read it and `AGENTS.md` at
the start of each session.

## Known limitations

- Analysis quality is the main bottleneck. A flawed baseline can produce a
  conforming but unwanted result, especially in autonomous analysis.
- Human gates and final outcome judgement remain necessary for consequential
  decisions, guided validation, and intent-versus-delivery assessment.
- Verification is strongest for functional software behaviour. Non-functional
  requirements, external triggers, UI/UX nuance, and non-code outcomes have
  weaker or less standardized verification paths.
- The framework is production-ready for its core use case but remains evolving;
  tooling, git fluency, environment setup, and the analyst/conductor split impose
   adoption costs.
  Reduce adoption cost incrementally: use `project_context.yaml` and a ready,
  accepted analyst baseline first; for bounded, low-risk tasks, that baseline can
  be proportionate and lightweight. Conductor work always uses the ready, accepted
  baseline; add deeper analyst discovery and traceability, then frozen
  specifications and contractual tests, as complexity and consequence grow.
  Trivial tasks do not require the full process.

## What the repository contains

```
agents/          Agent instructions and opencode agent definitions
  AGENTS.md        Generic guidance for all projects
  AGENTS.odoo.md   Odoo-specific companion
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

General skills are reusable by any agent or user. Conductor-specific skills are
loaded automatically by the conductor during its workflow.

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
