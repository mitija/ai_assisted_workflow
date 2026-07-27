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

### Contract and implementation safeguards

The analyst owns the functional contract. Analyst-specific lifecycle,
decision-classification, provenance, and documentation-tag procedures live in the
analyst agent and `analyst-*` skills.

For spec-driven implementation:

- Work against the immutable documentation tag: read the tagged specification
  and contractual scenarios before implementing, and record the tag used.
- The specification and contractual scenarios define required behaviour. Tests
  win over contradictory prose; do not invent requirements or silently fill
  contractual gaps.
- A genuine contractual ambiguity blocks work and routes to the analyst for
  interpretation. Do not work ahead of an unresolved ambiguity.
- Do not silently edit `docs/customer-facing/`. Contract-changing discoveries
  route through the analyst baseline-change process; implementation resumes only
  against the resulting approved documentation tag.
- Derive automated tests from contractual scenarios. Extra developer tests are
  non-contractual; generic work uses its explicit acceptance criteria and
  evidence instead of spec-driven obligations.

### Delivery evidence

For **spec-driven code**, produce the source changes, automated tests for the
contractual scenarios and in-scope invariants, and a development report tied to
the requirements, evidence, coverage, deviations, and design decisions.

For **generic code and non-code work**, use the explicit acceptance criteria and
evidence for that work. Produce applicable artefacts, verification results,
traceability, and outcome reporting without imposing spec-driven or code-only
deliverables.

Before decomposition, the baseline must identify applicable contractual scenarios,
code unit-test expectations, verification/evidence methods, and explicit non-code
acceptance criteria/evidence. These are planned expectations, not passing results;
the applicable tests, checks, and acceptance evidence are produced and assessed
during Execute and required at completion.

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
one level above the `docs` and `src` repos. Read it at the start of a session.
The conductor routes missing or unusable context to `init-project`. Init-project
scans available evidence, infers visible active profiles, and asks only for
unavailable values required by those active profiles. Missing or unsupported
`schema_version` requires explicit approved reinitialization or conversion; no
v1 preservation guarantee exists. Routine setup is conductor-owned. Never
hard-code these paths or credentials in code or docs.

The project context uses a minimal v2 envelope with optional visible typed profiles
for code, non-code, Odoo, and other controlled extensions. `schema_version: 2` is
required; missing or unsupported versions are unusable and route to `init-project`
for explicit reinitialization or conversion. Inactive profiles impose no
requirements, and unknown extension keys in valid v2 are preserved without
reinterpretation.
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

Agents must not read, list, search, stat, resolve, traverse, or scan broad external
directories such as the user's home directory, a general Projects/workspace directory,
or a parent workspace. A configuration reference may reveal that a path exists, but it
does not authorize accessing that path. Before accessing an eligible concrete
project-specific external path, state its exact lexically expanded/normalized candidate, the
operation that requires it, why it is necessary, why the project root or a narrower
path cannot satisfy the need, and the associated risk and scope. Require explicit user
approval before access and again before persisting the permission. If a genuinely
necessary operation would require a broad directory, stop and present a reasoned,
risk-aware justification to the user; approval must identify the narrowest concrete
subpath possible, and broad permission patterns remain prohibited.

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
- Environment variables — values such as `$HOME`, `$PROJECTS`, or other variables used in config, expanded when their values are available.
- Git-linked directories — `git submodule`, `git worktree` locations.
- Dependency-link targets — `npm link` or equivalent symlinked dependency directories.
- User declaration — the user explicitly naming a required external path.

Before comparing or authorizing a discovered path, first perform only lexical
handling: expand known environment-variable and tilde syntax when the values
are available, normalize textual `.`/`..`, and reject obvious broad home,
Projects/workspace, or parent paths. This stage must not read, list, stat,
traverse, resolve symlinks, or otherwise access the external path. Only for a
 concrete project-specific candidate, and only after explicit approval to access
 it, resolve its absolute path and canonicalize symlinks. If the canonical target
 is broader than or outside the exact scope of the approved candidate, stop even
 if an existing allow entry happens to cover it. Present the exact canonical
 target and renewed justification, obtain renewed explicit approval to access it,
 and obtain separate explicit approval before adding or relying on permission for
 that changed target. Harmless canonical spelling differences within the exact
 approved scope do not require re-approval; never continue silently after a
 broader or out-of-scope target is found.

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
| [`init-project`](../skills/init-project/SKILL.md) | `project_context.yaml` is missing, incomplete, unusable, or has an unsupported schema |
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
