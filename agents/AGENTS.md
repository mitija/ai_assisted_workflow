# Agent Guidance for Long-Horizon Work

This file provides generic guidance for AI agents conducting long-horizon work in a
target-project workspace. It covers coding and non-coding work — including
documentation, research, analysis, planning, configuration, and project setup.
Spec-driven coding is the mature supported path within the [broader Agentic
Framework for Long-Horizon AI Work](../docs/AI_assisted_development_workflow.md);
the rules below apply proportionately to either path.

The project workspace is intentionally one level above the git repositories. Treat
the workspace root as the operational project folder, not as a single git repo:

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
rules, success criteria, documentation, and wireframes. The analyst may:

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

The analyst must never implement code.

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
  and require a new human-created docs tag.
- **Tests are executable spec, and tests win.** Every business rule is a
  specification-level, contractual test scenario in `<epic>_TESTS.md` (see the
  `test-scenarios` skill for the format). Derive automated tests from these
  scenarios. If the spec and the tests disagree, the tests are authoritative —
  flag the discrepancy to the user. Any extra tests you add during
  implementation to strengthen the build are non-contractual and separate from
  these.
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
workflow; this guidance never authorizes an agent to create a tag.

For **non-code work**, use the explicit acceptance criteria and evidence defined
for that work. Produce the applicable artefacts, verification results, traceability,
and outcome report. Do not impose source-code, automated-test, docs-tag, or commit
deliverables where they do not apply.

## Build, Lint & Verify
Build, lint, typecheck, format, and generic test commands live in the `commands:`
section of `project_context.yaml` (the Odoo test wrapper is separate — see
@AGENTS.odoo.md). Use configured commands rather than guessing or inventing them.
Run each applicable check before completion; if a check is not applicable, record
why. Do not introduce new lint or type errors. Only auto-format or auto-fix files
already being changed; do not reformat or re-fix unrelated files.

## Definition of Done
Before reporting a task complete, confirm, as applicable:
- The analyst completion gate is satisfied: the functional baseline, quality gate,
  traceability, and required documentation are complete.
- Every in-scope automated test and contractual scenario passes, including each
  state-table row and cross-cutting invariant; non-code acceptance evidence is
  complete instead.
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
- **Never create git tags.** Tagging is a user action. The AI must not create tags
  on the user's behalf. Document the docs tag to trace against but never run
  `git tag` or equivalent.
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
workflow**, not by hand. Agents add entries only through the documented preflight
process (see Conductor startup preflight below).

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

### Conductor startup preflight (autonomous mode)

Before beginning autonomous execution, the conductor must run a **permission preflight**
that:

1. **Reads** `opencode.json` at the project root to determine currently authorized
   external directories.
2. **Scans** `project_context.yaml` and other project config files for absolute
   paths that fall outside the project root.
3. **Normalizes** — for each discovered path, perform environment-variable and
   tilde expansion, normalize `.`/`..`, resolve to an absolute path, and
   canonicalize symlinks before classifying it.
4. **Identifies** any legitimate project-specific external paths that are not yet
   in `permission.external_directory`.
5. **Confirms** with the user — presents the proposed additions and asks for approval.
6. **Persists** the approved paths by editing `opencode.json`'s
   `permission.external_directory` block.
7. **Proceeds** only after the boundary is confirmed and the config is updated.

If a new legitimate external path is discovered during execution (e.g. a sub-agent
encounters a needed path), the conductor must apply the **mid-execution discovery
sequence**:

1. **Pause** the affected task immediately.
2. **Classify and explain** — identify the concrete project-specific path and why it is needed.
3. **Ask** the user for approval to add the path to `permission.external_directory`. Present one path at a time.
4. **Wait** for the user's answer before continuing.
5. **If approved**: delegate editing `opencode.json` to a `general` sub-agent with exact instructions to add `"<path>/**": "allow"`.
6. **Validate** that the updated `opencode.json` is valid JSON and the path was persisted correctly.
7. **Resume** execution only after persistence is confirmed.
8. **If denied or the path is unrelated** to the project: do not add it. Leave it at the default "ask" policy. Do not resume with broad access or re-present the same path.

Do **not** update `opencode.json` before receiving user approval. Unrelated or clearly illegitimate paths must **not** be added — they remain at the default "ask" policy.

Interactive mode does not require a formal preflight — the conductor can ask about
external access as part of the normal ambiguity-resolution dialogue.

## Communication & Output
- Keep responses concise and skimmable; lead with the answer, not the process.
- When referring to code, use `file_path:line` references so the user can navigate
  directly to the location.

## Reading Files & Logs (stay autonomous)
Use the `Read` tool with `offset`/`limit` and the `Grep` tool instead of running
shell commands like `sed`, `grep`, `tail`, or `cat` via Bash. This avoids
permission prompts and keeps the workflow autonomous.
- Never use Bash with pipes (`|`) or redirections (`2>&1`, `>`) to read/search files.

## Skills

General skills are reusable by any agent or user. Conductor-specific skills are internal orchestration steps loaded automatically by the conductor during its workflow.

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
