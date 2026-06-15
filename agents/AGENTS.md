# AGENTS.md

This file provides guidance to AI agents when working with code in this repository.

## Spec-Driven Workflow (how we work)
This project follows a spec-driven, AI-assisted methodology. The full description
lives in `AI_assisted_development_workflow.md`; the rules below are what an agent
must honour when implementing.

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
1. Source code, committed against the docs tag (only commit when asked — see below).
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
- Nothing has been committed unless the user explicitly asked.

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
- Use subagents extensively to keep the main context window small and save tokens.
- Do not commit anything before asking first.
- **Minimal diff.** Make the smallest change that satisfies the spec and tests. Do
  not refactor, rename, or reformat code that is outside the scope of the task.
- **Blocker protocol.** If a contractual test fails or the environment is broken,
  never weaken, skip, or mock away the test to make it pass — report the blocker.
  Tests win (see Spec-Driven Workflow); the build conforms to them, not the reverse.
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
- `coding-standards` — follow when writing or modifying application code
  (currently covers logging requirements). Load whenever you add or change code
  that runs as an app, script, or service.
- `spec-refinement` — load before `specification-methodology` when an initial
  requirement is rough or ambiguous. Runs a guided, one-question-at-a-time
  session that refines the high-level requirement until the entities, their
  relationships, the main ways they are manipulated, and the key business rules
  are clear — without expanding into the full spec.
- `test-scenarios` — follow when authoring or reviewing the contractual,
  customer-facing `<epic>_TESTS.md` scenarios. Load when writing or updating
  specification-level test scenarios (not developer-only implementation tests).
