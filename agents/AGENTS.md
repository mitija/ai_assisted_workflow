# Agent Guidance for Long-Horizon Work

This file provides generic guidance for AI agents conducting long-horizon work in a
target-project workspace. It covers coding and non-coding work — including
documentation, research, analysis, planning, configuration, and project setup.
Spec-driven coding is the mature supported path within the [broader Agentic
Framework for Long-Horizon AI Work](../docs/AI_assisted_development_workflow.md);
the rules below apply proportionately to either path.

The project workspace is intentionally one level above the git repositories. The
workspace root is not itself a git repository; `docs/` and `src/` are separate
repositories with separate lifecycles:

```text
project-folder/
├── docs/       # documentation/specification git repo
│   ├── customer-facing/  # contractual specs/tests, tagged when ready
│   └── working/          # versioned project documentation work
├── src/        # source-code git repo
└── local/      # unversioned project-local tool config (e.g. Lima), prompts, session notes, logs, scratch material
```

Temporary files for project work should live under `local/tmp/` rather than system
`/tmp` to keep scratch material within the project boundary.

The `docs` and `src` repositories have different lifecycles. Documentation is
drafted, reviewed, committed, and tagged when ready for implementation. Source
work is then implemented against that immutable docs tag and should reference it
in commits, PRs, development reports, or other implementation traceability docs.
Within `docs`, `customer-facing/` contains the contractual spec/test artifacts
that are tagged when ready, while `working/` contains versioned project
documentation work. Do not treat unversioned workspace-level `local/` material as
contractual.
### Role and lifecycle ownership

- The **human** owns intent, priorities, consequential decisions, and final
  judgement of whether the functional outcome is acceptable.
- The **analyst** owns the functional contract and evidence model across its full
  lifecycle: intake, discovery, review, and baseline. This includes requirements,
  business rules, success criteria, verification definitions, traceability,
  documentation, wireframes, and evidence mapping.
- The **conductor** owns delivery orchestration across six phases: Analyze,
  Decomposition, Execute, Review, Escalate, and Report. The conductor does not
  replace the analyst's functional ownership or the human's approval gates.
- The conductor is the normal delivery entry point and transparently drives the
  analyst when a baseline is absent or needs maintenance. It owns initialization,
  tooling/environment readiness, command/layout discovery, permissions, setup
  tasks, and setup blockers, delegating mechanics to the appropriate agents.

`analysis_mode` and `interaction_mode` are independent values. `analysis_mode`
(`autonomous` or `guided`) governs the analyst's functional-contract lifecycle and
human validation policy. `interaction_mode` (`autonomous` or `interactive`)
governs whether the conductor pauses for ambiguity during delivery. Record both;
never infer one from the other. Autonomous operation does not bypass mandatory
human gates: objective confirmation, required functional validation, Class C/D
decisions, external-permission approval, final review, or final human judgement
remain blocking where applicable. A genuine blocker always stops the affected
work; do not guess, weaken tests, or work ahead of unresolved interpretation.

### Phase-specific rules

These rules distinguish the two phases of work — analysis (drafting the
functional contract) and implementation (building against a frozen baseline).

#### During analysis

The analyst owns the functional contract: authoring requirements, business
rules, success criteria, documentation, and wireframes. The analyst performs
evidence-first task, domain, and background research, including motivation,
problem, beneficiaries, outcomes, and reasonable user or operational
expectations. Record sources, findings, confidence, assumptions, and provenance,
distinguishing observed or domain expectations from explicit human requirements.
The analyst may:

- Resolve **Class A** (minor, low-impact, reversible) decisions
  autonomously with provenance and rationale.
- Resolve **Class B** (low-impact functional) decisions autonomously with
  provenance and guided-package visibility.
- Handle **Class C** (material/consequential) decisions: in autonomous mode
  ask immediately; in guided mode defer non-blocking to the validation
  package and ask blocking ones immediately.
- Handle **Class D** (blocking/high-risk) decisions: always stop and ask
  immediately, never decide autonomously.
- Author and maintain all functional documentation under `docs/working/` and
  prepare artefacts for `docs/customer-facing/` before a tag freeze.

The analyst must never implement code or perform delivery work. The analyst may
create an immutable documentation tag in the configured documentation repository
only under the documentation-tag policy in the analyst baseline skill, using
`~/.agents/create-spec-tag`.

Requirement provenance is a separate seven-value concept, not Class A-D.
Every requirement and important business rule carries exactly one provenance label:
explicitly-requested, inferred-context, inherited, domain-practice,
design-decision, risk-control, or unresolved. Never present an inferred
requirement as though it was explicitly requested.

#### During implementation (coding against a frozen baseline)

Implementation agents work against an immutable tagged baseline:

- **The spec is the contract.** If behaviour is not in the spec or the tests,
  it is not required. Do not invent requirements. Do not fill functional gaps
  or silently alter the contract.
- **Stop on real ambiguity.** A genuine ambiguity that affects implementation
  is a blocker: stop and route to the analyst for functional interpretation rather than
  guessing. When the analyst escalates a question to the human, ask **one
  question at a time** and wait for the answer before asking the next. For a
  complex question, **unpack it first** — state the ambiguity, why it matters,
  the options and their trade-offs, and your recommendation — then ask. Do not
  batch unrelated questions into a single dump. Do not work ahead of an
  unresolved blocker; building against an open question only produces rework.
- **No silent doc edits.** Implementation agents cannot silently edit
  `docs/customer-facing/` spec/test documents. The analyst owns authoring and
  maintaining functional documentation. If implementation reveals a gap that
  changes contractual behaviour, follow the analyst-baseline discovery sequence
  and require human review plus a new analyst-created docs tag.
- **Tests are executable spec for spec-driven work, and tests win.** Every business rule is a
  specification-level, contractual test scenario in `<epic>_TESTS.md` (see the
  `test-scenarios` skill for the format). Derive automated tests from these
  scenarios. If the spec and the tests disagree, the tests are authoritative —
  flag the discrepancy to the user. Any extra tests you add during
  implementation to strengthen the build are non-contractual and separate from
  these.
  For generic work, use the analyst's explicit acceptance criteria and evidence
  instead of imposing contractual test scenarios.
- **Work against the docs tag.** Specs and tests live in a separate
  documentation repo, tagged at each freeze (e.g. `spec-260513`). Read the
  current spec and TESTS docs at that tag before implementing. Their location
  is in `project_context.yaml`. Record the docs tag used for implementation so
  the source repo can always be traced back to the exact specification state.

### Delivery evidence

For **spec-driven coding**, implement against the immutable docs tag and produce
the source changes, automated tests for the contractual scenarios and invariants
in scope, and a development report tied to the requirements, use cases, evidence,
coverage, deviations, and design decisions. Commit/tag actions follow the project
workflow; only the analyst may create documentation tags under the analyst-baseline
policy, and no other agent is authorized to create tags.

For **non-code work**, use the explicit acceptance criteria and evidence defined
for that work. Produce the applicable artefacts, verification results, traceability,
and outcome report. Do not impose source-code, automated-test, docs-tag, or commit
deliverables where they do not apply.
The analyst must provide an explicit acceptance-criteria list for non-code work.

Before decomposition, the analyst baseline must identify the applicable contractual
scenarios, code unit-test expectations, verification/evidence methods, and explicit
non-code acceptance criteria/evidence. These are planned delivery expectations, not
passing results. Applicable tests, checks, and acceptance evidence are produced and
assessed during Execute and are required at completion.

## Build, Lint & Verify
Use the applicable build, lint, typecheck, format, and test commands configured in
`project_context.yaml`. Do not guess commands. Record checks that are not
applicable. Odoo-specific test handling belongs in `AGENTS.odoo.md`; this policy
also applies to non-Odoo code projects and non-code work.

## Definition of Done
Before reporting a task complete, confirm, as applicable:
- The analyst completion gate is satisfied: the functional baseline, quality gate,
  traceability, and required documentation are complete.
- For spec-driven code, every in-scope automated test and contractual scenario
  passes, including state-table rows and cross-cutting invariants. For generic
  code, applicable tests pass. For non-code work, acceptance evidence is complete.
- Applicable configured build, lint, typecheck, format, and test checks are clean,
  with any non-applicable checks explicitly recorded.
- Evidence maps the outcome to the requirements and success criteria, and any
  deviations, assumptions, risks, or coverage gaps are reported.
- The mandatory reviewer audit is complete and its findings are resolved or
  explicitly accepted through the appropriate gate.
- A functional-outcome assessment is recorded, and the human has made final
  judgement where the work requires it.
- Required reports and test-doc/config-sample artefacts are in sync.

## Stack-Specific Guidance
For Odoo projects, also follow the rules in @AGENTS.odoo.md (testing, source
layout, database/instance access). Skip it for non-Odoo projects.

## Project-Specific Paths & Config
All machine/project-specific values (source/docs paths, build/test commands, DB
and instance credentials) live in `project_context.yaml` in the project folder,
one level above the `docs` and `src` repos. Read it at the start of a session. If
it is missing, copy `project_context.template.yaml` to `project_context.yaml` and
ask the user to fill it in. Never hard-code these paths or credentials in code or docs.

The project context uses a minimal v2 envelope with optional visible typed profiles
for code, non-code, Odoo, and other controlled extensions. `schema_version: 2` is
required; missing or unsupported versions are unusable and route to `init-project`
for explicit reinitialization or conversion. Inactive profiles impose no
requirements, and unknown extension keys in valid v2 are preserved without
reinterpretation. The conductor routes missing or unusable context to
`init-project`, which infers profiles and asks only for active-profile values.
Secrets remain protected and external-path authorization remains in
`opencode.json`.

## Maintain Context
Maintain a `PROJECT_SUMMARY.md` (path may be set in `project_context.yaml`) recording
a summary of the project and the work done. Its purpose is to let any LLM resuming
work get up to speed quickly. No historical log — current state only (status,
what's done, what's planned next).

## Working Conventions
- Do not start coding unless explicitly asked to do so. When the user describes a
  problem or asks a question, answer it directly without jumping into implementation
  unless they specifically request code changes.
- Use subagents extensively to keep the main context window small and save tokens.
- **Minimal diff.** Make the smallest change that satisfies the spec and tests. Do
  not refactor, rename, or reformat code that is outside the scope of the task.
- **Blocker protocol.** If a contractual test fails or the environment is broken,
  never weaken, skip, or mock away the test to make it pass — report the blocker.
  Tests win (see Spec-Driven Workflow); the build conforms to them, not the reverse.
- Only the analyst may create an immutable documentation tag, and only under the
  documentation-tag policy in `analyst-baseline`. All conductor, committer,
  reviewer, verifier, and implementation roles remain prohibited from tagging.
  No role may create source, release, deployment, or production tags.
- When a feature is added, behaviour changes, or a bug is fixed, keep any test-doc
  and config-sample files (including `project_context.template.yaml`) in sync.

## Security & Secrets
Treat every value in `project_context.yaml` — especially database and QA-instance
credentials — as secret. Never print, echo, or copy these values into chat output,
logs, source code, commits, or the development report. Reference them by their
config key, not their literal value.

## Filesystem Boundary & External Access

### Default boundary

The **project root** (the workspace directory containing `project_context.yaml`, e.g.
`~/Projects/project_name`) is the default filesystem boundary. All read/write operations
are expected to stay within this root. Access to directories outside the root requires
explicit permission via OpenCode's `permission.external_directory` rules.

### Where permissions live

OpenCode's external-directory permissions are stored in the project-level
`opencode.json` under `permission.external_directory` as a record of
`"<path-glob>": "allow"` entries. Broad patterns such as `~/Projects/**` or `~/**`
must never be added — only concrete, project-specific external paths are permitted.

The `permission.external_directory` block is **generated and maintained by the agent
workflow**, not by hand. Agents add entries only through the documented conductor
or `init-project` preflight process.

### Legitimate external paths

Paths outside the project root that a project legitimately needs may include:

- **Sibling repositories** — shared libraries, monorepo workspaces, or config repos
  adjacent to this project.
- **Generated assets** — build outputs, compiled artifacts, or cached data stored
  outside the project tree.
- **Services / runtimes** — language runtimes, databases, Odoo source trees, or
  other service directories required for development or testing.
- **Environment-specific files** — shared `/etc/` config, system-wide credential
  stores referenced by config files.
- **Explicit user requirement** — any path the user directly states is needed.

Paths are discovered via:
- `project_context.yaml` — external `source.*`, `scripts.*`, or other path values.
- Project configuration files — `.ini`, `.cfg`, `.env`, and equivalent config files that reference absolute paths.
- Environment variables — values such as `$HOME`, `$PROJECTS`, or other variables used in config, resolved after expansion.
- Git-linked directories — `git submodule`, `git worktree` locations.
- Dependency-link targets — `npm link` or equivalent symlinked dependency directories.
- User declaration — the user explicitly naming a required external path.

Before comparing or authorizing a discovered path, require environment-variable
and tilde expansion, normalization of `.`/`..`, resolution to an absolute
path, and symlink canonicalization. Only then classify it as inside the project
root, a broad parent/workspace path, or an eligible concrete external path.

Broad values such as `$HOME`, `~/`, `~/**`, `$PROJECTS`, `~/Projects/**`, or a parent workspace directory are **rejected** and must never be presented as authorization candidates; only concrete project-specific paths are eligible.
The `local/` directory is unversioned project-local storage for safe configuration,
data, prompts, logs, and scratch material that would otherwise be placed under a
user-level config or share directory. Use it when the project can safely own the
data; keep credentials protected and never move machine-wide or unrelated data
there. The conductor and `init-project` skill own the procedural permission
preflight; this file defines only the policy.

The conductor and `init-project` skill own the procedural permission preflight:
they normalize discovered paths, request approval one path at a time, and persist
only approved concrete project-specific permissions. Do not update `opencode.json`
before approval and never authorize broad paths.

## Communication & Output
- Keep responses concise and skimmable; lead with the answer, not the process.
- When referring to code, use `file_path:line` references so the user can navigate
  directly to the location.
  Use clear, direct sentences.

## Reading Files & Logs (stay autonomous)
Use the `Read` tool with `offset`/`limit` and the `Grep` tool instead of running
shell commands like `sed`, `grep`, `tail`, or `cat` via Bash. This avoids
permission prompts and keeps the workflow autonomous.
- Never use Bash with pipes (`|`) or redirections (`2>&1`, `>`) to read/search files.

## Skills

General skills are reusable by agents, but the `analyst-*` skills are loaded only
by the analyst agent. Users and general agents should invoke the analyst rather
than loading those lifecycle skills directly. Conductor-specific skills are
internal orchestration steps loaded automatically by the conductor.

### General skills

| Skill | When to load |
|---|---|
| [`analyst-baseline`](../skills/analyst-baseline/SKILL.md) | Phase 4 — requirements baseline and traceability |
| [`analyst-discovery`](../skills/analyst-discovery/SKILL.md) | Phase 2 — structured discovery process |
| [`analyst-intake`](../skills/analyst-intake/SKILL.md) | Phase 1 — objective brief and intake Q&A |
| [`analyst-review`](../skills/analyst-review/SKILL.md) | Phase 3 — requirements quality gate and validation |
| [`coding-standards`](../skills/coding-standards/SKILL.md) | Writing or modifying any application code, script, or service |
| [`handover`](../skills/handover/SKILL.md) | Creating a self-contained `HANDOVER-xx.md` at session end for the next session to continue |
| [`init-project`](../skills/init-project/SKILL.md) | `project_context.yaml` is missing or incomplete |
| [`specification-methodology`](../skills/specification-methodology/SKILL.md) | Optional post-baseline structuring of an existing functional contract into specification artefacts |
| [`test-scenarios`](../skills/test-scenarios/SKILL.md) | Authoring or reviewing `<epic>_TESTS.md` contractual scenarios |
| [`todo-list`](../skills/todo-list/SKILL.md) | Optional TDD-oriented decomposition for coding work when a task list is useful |

### Conductor-specific skills

These are loaded automatically by the conductor agent during its workflow. They are not meant to be loaded directly by users or general agents. The workflow has six phases: Phase 1 Analyze, Phase 2 Decomposition, Phase 3 Execute, Phase 4 Review, Phase 5 Escalate, Phase 6 Report. Phase 4 Review is performed by the `reviewer` agent; the other five phases are represented by the conductor-specific skills below.

| Skill | When to load |
|---|---|
| [`conductor-analyze`](../skills/conductor-analyze/SKILL.md) | [Conductor-internal] Phase 1 — establish modes, goal, scope, constraints, permissions, and analyst readiness |
| [`conductor-code-decomposition`](../skills/conductor-code-decomposition/SKILL.md) | [Conductor-internal] Phase 2 — dependency-aware task graph for coding against a frozen baseline |
| [`conductor-noncode-decomposition`](../skills/conductor-noncode-decomposition/SKILL.md) | [Conductor-internal] Phase 2 — dependency-aware task graph for non-code acceptance/evidence work |
| [`conductor-execute`](../skills/conductor-execute/SKILL.md) | [Conductor-internal] Phase 3 — execute graph tasks and delegate applicable verification |
| [`conductor-escalate`](../skills/conductor-escalate/SKILL.md) | [Conductor-internal] Phase 5 — diagnose blockers, create remedial tasks, and resume or abort safely |
| [`conductor-report`](../skills/conductor-report/SKILL.md) | [Conductor-internal] Phase 6 — report task results, evidence, ambiguities, and functional outcome |

## Agents

| Agent | Role / Description | Invocable as |
|---|---|---|
| [`analyst`](agent/analyst.md) | Transforms high-level human intent into a complete, defensible functional contract. Owns requirements, business rules, success criteria, traceability, documentation, and wireframes. Operates in autonomous or guided mode. Orchestrates four lifecycle phases via analyst-* skills. Never implements code. | Both |
| [`conductor`](agent/conductor.md) | Orchestrates multi-step work end to end. Runs on a better AI model than sub-agents — owns the thinking, planning, and decision-making. Interactive by default for ambiguity resolution; autonomous when requested. | Primary |
| [`committer`](agent/committer.md) | Groups changes by topic and makes focused commits with clear messages. Never tags. Does not push or create branches unless explicitly asked. | Subagent |
| [`reviewer`](agent/reviewer.md) | Reviews work for correctness, style, and completeness. Read-only agent — produces a structured review plan with findings and remediation tasks. Never edits files; runs only read-only inspection commands. | Both |
| [`escalate1`](agent/escalate1.md) | First-tier escalation. Read-only diagnosis + task plan. | Subagent |
| [`escalate2`](agent/escalate2.md) | Second-tier escalation. Deep-dive diagnosis + task plan. Read-only. | Subagent |
| [`verifier`](agent/verifier.md) | Runs exact delegated commands, reports PASS/FAIL/BLOCKED. Never edits files. | Subagent |
