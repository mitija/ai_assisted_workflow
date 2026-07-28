# Universal Agent Invariants

This file contains universal invariants for agents working in a project
workspace. Detailed lifecycle, orchestration, filesystem-approval, Odoo, and
skill procedures live in the relevant [agent](agent/) and
[skill](../skills/) files.

## Workspace

The project root is above separate `docs/` and `src/` repositories:

```text
project-root/
├── docs/
│   ├── customer-facing/  # contractual specifications and scenarios
│   └── working/          # versioned working documentation
├── src/                  # source repository
└── local/                # unversioned project-local material
```

- Put temporary project files under `local/tmp/`, not system `/tmp`.
- `docs/customer-facing/` is the contractual documentation area. Spec-driven
  source work uses its immutable approved documentation baseline/tag.
- `docs/working/` and `local/` are not contractual. Do not treat working or
  local material as an approved specification.

## Project context and secrets

- `project_context.yaml` is the source of machine/project paths, repository
  locations, configured commands, profiles, and environment references.
- Use the commands configured there; do not guess or invent build, lint,
  typecheck, format, test, or acceptance commands. Record non-applicable checks.
- `schema_version: 2` is required. Missing, unsupported, or unusable context
  routes to [`init-project`](../skills/init-project/SKILL.md).
- Never expose, hard-code, copy, or commit literal credentials or other secret
  context values. Project external-path authorization lives in `opencode.json`.

## Universal safeguards

- Do not write code unless the user explicitly asks for code changes.
- Make the smallest in-scope diff; do not reformat, refactor, or alter unrelated
  work.
- The contract is the approved specification and scenarios, or the explicit
  acceptance criteria for generic work. Do not invent requirements or silently
  fill contractual gaps.
- Genuine functional ambiguity blocks the affected work and routes to the
  analyst. Do not guess or work ahead of unresolved interpretation.
- Never weaken, skip, or mock away a failing check, test, or acceptance result.
- Do not silently edit frozen `docs/customer-facing/` material or change
  behaviour outside the approved contract. Contract changes use
  [`analyst-baseline`](../skills/analyst-baseline/SKILL.md) and a new approved
  documentation tag before spec-driven implementation resumes.
- Only the analyst may create immutable documentation tags under the applicable
  baseline procedure. No role may create source, release, deployment, or
  production tags.

## Filesystem boundary

- The project root is the default filesystem boundary. Do not broadly read,
  list, search, stat, traverse, resolve, or scan home, Projects/workspace,
  parent, or other broad external directories.
- A path mentioned by configuration is not authorization. External access is
  limited to the narrow concrete project-specific path required for the work;
  broad globs and broad parent/home paths are forbidden.
- The detailed discovery, lexical normalization, canonicalization, approval,
  and permission-persistence procedure is owned by [`conductor.md`](agent/conductor.md)
  and [`init-project`](../skills/init-project/SKILL.md). Do not bypass it or
  update external permissions before the required approval.

## Completion

- Report completion only when stated success criteria are met.
- Applicable configured checks and acceptance evidence must pass; record what
  is not applicable.
- Evidence must trace to the criteria. Keep documentation, reports, tests, and
  configuration samples synchronized.
- Resolve critical or blocking reviewer findings, or record their explicit
  acceptance through the appropriate gate.
- Report deviations, assumptions, risks, and coverage gaps.

## Maintain context

- Maintain [`PROJECT_SUMMARY.md`](../PROJECT_SUMMARY.md) as current state, not a
  history log.

For Odoo projects, also follow [`AGENTS.odoo.md`](AGENTS.odoo.md).
