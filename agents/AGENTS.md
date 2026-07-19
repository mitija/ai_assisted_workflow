# AGENTS.md

This file provides guidance to AI agents when working with code in this repository.

## Supported Spec-Driven Coding Workflow

This workflow is one mature, supported capability within the [broader Agentic Framework for Long-Horizon AI Work](../docs/AI_assisted_development_workflow.md). The framework also supports non-coding long-horizon work — documentation, research, analysis, planning, configuration, and project setup — and current improvement effort prioritises those areas. The rules below govern the spec-driven coding path.

The project workspace is intentionally one level above the git repositories. Treat
the workspace root as the operational project folder, not as a single git repo:

```text
project-folder/
├── docs/       # documentation/specification git repo
│   ├── customer-facing/  # contractual specs/tests, tagged when ready
│   └── working/          # versioned project documentation work
├── src/        # source-code git repo
└── local/      # unversioned prompts, session notes, logs, scratch material
```

The `docs` and `src` repositories have different lifecycles. Documentation is
drafted, reviewed, committed, and tagged when ready for implementation. Source
work is then implemented against that immutable docs tag and should reference it
in commits, PRs, development reports, or other implementation traceability docs.
Within `docs`, `customer-facing/` contains the contractual spec/test artifacts
that are tagged when ready, while `working/` contains versioned project
documentation work. Do not treat unversioned workspace-level `local/` material as
contractual.

- **The spec is the contract.** If behaviour is not in the spec or the tests, it
  is not required. Do not invent requirements.
- **Never fill gaps with assumptions.** A genuine ambiguity is a blocker: stop and
  ask the user rather than guessing. Ask **one question at a time** and wait for the
  answer before asking the next, so the user can think each through. For a complex
  question, **unpack it first** — state the ambiguity, why it matters, the options and
  their trade-offs, and your recommendation — then ask. Do not batch unrelated
  questions into a single dump. Do not work ahead of an unresolved blocker; building
  against an open question only produces rework.
- **No mid-flight spec changes.** If a question reveals a real gap, the spec/tests
  are updated and re-tagged first; then implement against the new tag. Do not edit
  customer-facing spec/test docs yourself unless explicitly asked.
- **Tests are executable spec, and tests win.** Every business rule is a
  specification-level, contractual test scenario in `<epic>_TESTS.md` (see the
  `test-scenarios` skill for the format). Derive automated tests from these
  scenarios. If the spec and the tests disagree, the tests are authoritative —
  flag the discrepancy to the user. Any extra tests you add during implementation
  to strengthen the build are non-contractual and separate from these.
- **Work against the docs tag.** Specs and tests live in a separate documentation
  repo, tagged at each freeze (e.g. `spec-260513`). Read the current spec and
  TESTS docs at that tag before implementing. Their location is in
  `project_context.yaml`. Record the docs tag used for implementation so the
  source repo can always be traced back to the exact specification state.

### Implementation deliverables
At the end of a cycle, produce:
1. Source code, committed against the docs tag.
2. An automated test suite covering every state-table row and every cross-cutting
   invariant in scope.
3. A short development report: summary of work tied to use cases/test scenarios,
   a test-coverage statement (what's covered, what isn't, why), any spec deviations
   (normally zero), and notable design decisions not dictated by the spec.

## Build, Lint & Verify
Build, lint, typecheck, format, and generic test commands live in the `commands:`
section of `project_context.yaml` (the Odoo test wrapper is separate — see
@AGENTS.odoo.md). Use those commands rather than guessing them.
- Run lint, typecheck, and build before considering a task done. Do not introduce
  new lint or type errors.
- Only auto-format or auto-fix files you are already changing. Do not reformat or
  re-fix files that are otherwise outside the scope of your change.

## Definition of Done
Before reporting a task complete, confirm all of the following:
- Every in-scope automated test passes (each state-table row and every cross-cutting
  invariant in scope).
- Lint, typecheck, and build are clean.
- The development report is written (see Implementation deliverables).
- Test-doc and config-sample files are in sync (see Working Conventions).

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
| [`coding-standards`](../skills/coding-standards/SKILL.md) | Writing or modifying any application code, script, or service |
| [`handover`](../skills/handover/SKILL.md) | Creating a self-contained `HANDOVER-xx.md` at session end for the next session to continue |
| [`init-project`](../skills/init-project/SKILL.md) | `project_context.yaml` is missing or incomplete |
| [`spec-refinement`](../skills/spec-refinement/SKILL.md) | A rough/ambiguous requirement needs refining before specification-methodology |
| [`specification-methodology`](../skills/specification-methodology/SKILL.md) | Creating or writing software specifications |
| [`test-scenarios`](../skills/test-scenarios/SKILL.md) | Authoring or reviewing `<epic>_TESTS.md` contractual scenarios |
| [`todo-list`](../skills/todo-list/SKILL.md) | Generating a TDD-based TODO list for entry-level programmers |

### Conductor-specific skills

These are loaded automatically by the conductor agent during its workflow. They are not meant to be loaded directly by users or general agents. The workflow has six phases: Phase 1 Analyze, Phase 2 Decomposition, Phase 3 Execute, Phase 4 Review, Phase 5 Escalate, Phase 6 Report. Phase 4 Review is performed by the `reviewer` agent; the other five phases are represented by the conductor-specific skills below.

| Skill | When to load |
|---|---|
| [`conductor-analyze`](../skills/conductor-analyze/SKILL.md) | [Conductor-internal] Phase 1 — goal/scope/constraints analysis |
| [`conductor-code-decomposition`](../skills/conductor-code-decomposition/SKILL.md) | [Conductor-internal] Phase 2 — code-work task graph generation |
| [`conductor-noncode-decomposition`](../skills/conductor-noncode-decomposition/SKILL.md) | [Conductor-internal] Phase 2 — non-code task graph generation |
| [`conductor-execute`](../skills/conductor-execute/SKILL.md) | [Conductor-internal] Phase 3 — topological-round execution and verification |
| [`conductor-escalate`](../skills/conductor-escalate/SKILL.md) | [Conductor-internal] Phase 5 — failure escalation (escalate1 → escalate2) |
| [`conductor-report`](../skills/conductor-report/SKILL.md) | [Conductor-internal] Phase 6 — final report generation |

## Agents

| Agent | Role / Description | Invocable as |
|---|---|---|
| [`conductor`](agent/conductor.md) | Orchestrates multi-step work end to end. Runs on a better AI model than sub-agents — owns the thinking, planning, and decision-making. Interactive by default for ambiguity resolution; autonomous when requested. | Primary |
| [`committer`](agent/committer.md) | Groups changes by topic and makes focused commits with clear messages. Never tags. Does not push or create branches unless explicitly asked. | Subagent |
| [`reviewer`](agent/reviewer.md) | Reviews work for correctness, style, and completeness. Read-only agent — produces a structured review plan with findings and remediation tasks. Never edits files; runs only read-only inspection commands. | Both |
| [`escalate1`](agent/escalate1.md) | First-tier escalation. Read-only diagnosis + task plan. | Subagent |
| [`escalate2`](agent/escalate2.md) | Second-tier escalation. Deep-dive diagnosis + task plan. Read-only. | Subagent |
| [`verifier`](agent/verifier.md) | Runs exact delegated commands, reports PASS/FAIL/BLOCKED. Never edits files. | Subagent |
