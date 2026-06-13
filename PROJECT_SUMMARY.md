# PROJECT_SUMMARY.md

## Purpose
Build a reusable, working `AGENTS.md` to drop into all projects, plus an Odoo-specific
companion, so AI coding agents follow a consistent spec-driven workflow. Deliverables
live in `agents/`.

## Current status
Working draft complete and internally consistent. No code/app component — this is a
guidance/skill bundle for agents.

## Repo layout (`agents/`)
- `AGENTS.md` — generic, all-projects guidance.
- `AGENTS.odoo.md` — Odoo-specific companion (testing, source layout, DB/instances,
  acceptance demo). Referenced from `AGENTS.md` via `@AGENTS.odoo.md`.
- `project_context.template.yaml` — template for machine/project-specific values
  (paths, spec docs repo + tag, generic `commands:` block for build/lint/typecheck/
  format/test, Odoo source/scripts/DB/QA, modules). Copy to `project_context.yaml`
  (gitignored) per project.
- `.gitignore` — ignores `project_context.yaml` and credential `.ini` files.
- `skills/coding-standards/SKILL.md` — coding standards (currently logging).
- `skills/test-scenarios/SKILL.md` — how to write contractual, customer-facing
  `<epic>_TESTS.md` scenarios.

## What `AGENTS.md` covers
- Spec-driven workflow rules: spec is the contract; never fill gaps with assumptions
  (ambiguity is a blocker — ask interactively, one question at a time, unpacking
  complex ones); no mid-flight spec changes; tests are executable spec and tests win;
  work against the docs tag.
- Implementation deliverables: code vs tag, automated tests, development report.
- Build/Lint/Verify: commands sourced from `project_context.yaml` `commands:`; run
  before done; minimal-diff/no scope-creep formatting.
- Definition of Done checklist (tests pass, lint/typecheck/build clean, report written,
  sample files synced, no unsolicited commits).
- Project config via `project_context.yaml` (lives in the project folder, one level
  above the `docs` and `src` repos); maintain `PROJECT_SUMMARY.md`.
- Working conventions (use subagents, don't commit without asking, minimal diff,
  blocker protocol — never weaken/skip/mock contractual tests, keep samples in sync).
- Security & Secrets: treat config values (esp. credentials) as secret; never emit them.
- Communication & Output: concise responses, `file_path:line` references.
- Autonomous file/log reading (Read/Grep, no Bash pipes/redirects).
- Skills: `coding-standards`, `test-scenarios`.

## Key source documents
- `AI_assisted_development_workflow.md` (repo root) — the methodology `AGENTS.md`
  encodes. Workspace root with separate docs and source repos; docs repo split into
  `customer-facing/` and versioned `working/`; unversioned workspace-level `local/`
  scratch material; docs freeze tags; 5-step spec methodology; state-table tests;
  multi-layer acceptance; known gaps.
- Real test-scenario reference used to design the `test-scenarios` skill:
  a customer-facing Odoo procurement test document (not included in this repo).

## Design notes / decisions
- `test-scenarios` skill format is based on the real scorptec artifact (Pre-conditions /
  Steps with Before/After / Expected-result tables, grouped into Categories, `T-NN` IDs),
  with the workflow doc's Appendix A state-table style kept as a documented alternative.
- Contractual, customer-facing scenarios are explicitly distinguished from non-contractual
  developer implementation tests.

## Planned / open
- No `specification` skill exists yet in the repo; the workflow doc §4 references one.
  Create it (5-step methodology: Models, Roles, Use Case identification, Use Case
  documentation, Review) if/when wanted.
- Consider an `AGENTS.md` note on non-functional requirements (workflow §8.8 gap).
- Nothing committed yet (per convention: ask before committing).
