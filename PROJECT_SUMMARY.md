# PROJECT_SUMMARY.md

## Purpose
Build a reusable, working `AGENTS.md` to drop into all projects, plus an Odoo-specific
companion and a set of agents/skills, so AI coding agents follow a consistent
spec-driven workflow. Deliverables live in `agents/`.

## Current status
Working draft complete and internally consistent. No code/app component — this is a
guidance/skill bundle for agents.

## Repo layout (`agents/`)
- `AGENTS.md` — generic, all-projects guidance.
- `AGENTS.odoo.md` — Odoo-specific companion (testing, source layout, DB/instances,
  acceptance demo). Referenced from `AGENTS.md` via `@AGENTS.odoo.md`.
- `project_context.template.yaml` — template for machine/project-specific values
  (paths, spec docs repo + tag, generic `commands:` block for build/lint/typecheck/
  format/test, Odoo source/scripts, modules). Odoo DB credentials removed — they
  live in `odoo_config.ini` exclusively. Copy to `project_context.yaml` (gitignored)
  per project.
- `.gitignore` — ignores `project_context.yaml` and credential `.ini` files.
- `opencode.json` — project-level per-agent model assignments (merged with global config).
- `agent/conductor.md` — opencode agent definition for the `conductor`
  (orchestration agent). Symlinked to `~/.config/opencode/agent` by
  `tools/install.sh` for auto-discovery. Conductor runs on a better AI model
  than sub-agents and **owns all thinking, planning, and decision-making**
  (determining goals, constraints, scope, task decomposition). It **never**
  reads/writes files, edits code, or runs commands itself — those mechanical
  actions are delegated to sub-agents. The detailed workflow is split across
  six `conductor-*` skills in `skills/` (analyze, code-decomposition,
  noncode-decomposition, execute, escalate, report) loaded on demand so the
  base prompt stays small. Interactive mode (default) is a dialogue with the
  user for ambiguity resolution; autonomous mode only when requested.
  Decomposes work into a dependency-aware task graph, uses `explore` sub-agents
  for file reading, `general` sub-agents for execution and verification,
  `committer` for commits, `escalate1`/`escalate2` for failure diagnosis, and
  delegates report writing to a sub-agent.
- `agent/committer.md` — opencode agent definition for the `committer` (sub-agent).
  Inspects the working tree, groups changes by topic into focused commits with
  descriptive messages, and executes them. Never tags, pushes, or branches unless
  explicitly asked.
- `agent/reviewer.md` — opencode agent definition for the `reviewer`. Read-only
  inspection of work for correctness, style, and completeness. Produces a structured
  review plan with findings (issues, warnings, passes), verdict, and an ordered task
  list mapping each recommendation to an actionable item (with file:line references)
  for the implementer to work through. Never edits files.
- `agent/escalate1.md` — opencode agent definition for `Escalate1`, the first-tier
  escalation subagent. Called when the primary build agent hits an issue it cannot
  resolve. Read-only (edit denied; webfetch allowed; bash limited to a curated read-only inspection allow-list) — diagnoses and produces a
  task plan for a cheaper model to execute.
- `agent/escalate2.md` — opencode agent definition for `Escalate2`, the second-tier
  escalation subagent. Called when Escalate1 cannot resolve an issue. Read-only
  (edit denied; webfetch allowed; bash limited to a curated read-only inspection allow-list) — deep-dive diagnosis producing a task plan for a
  cheaper model to execute. Deep reasoning on hard problems.
- `skills/coding-standards/SKILL.md` — coding standards (currently logging).
- `skills/handover/SKILL.md` — creates self-contained HANDOVER-xx.md at session end.
- `skills/init-project/SKILL.md` — scan-first workflow to create `project_context.yaml`
  with inferred defaults; asks the user only for what cannot be discovered.
- `skills/spec-refinement/SKILL.md` — guided, one-question-at-a-time session that runs
  *before* `specification-methodology`. Refines a rough/high-level requirement into a
  precise, unambiguous freeform narrative at `docs/working/refined-requirements.md`,
  clarifying entities, relationships, core manipulation intent, and key business rules
  (and terminology) — deliberately non-exhaustive: defers full CRUD, roles, field types,
  and exception flows to the full spec. Dynamic questioning (no fixed phases), always
  offers a recommended answer, updates the narrative inline.
- `skills/specification-methodology/SKILL.md` — 5-step spec writing (Models, Roles,
  Use Cases identification, Use Cases documentation, Review). Produces wiki-style
  `spec/` directory with individual files per model (`models/`, global/shared) and
  use case (`use-cases/`, flat by default or grouped under `epics/<epic>/` for
  large-scope projects), cross-referenced via relative links. Main `spec-index.md`
  serves as index; sections over 40 lines extract to standalone files. Gherkin
  acceptance criteria feed the contractual `<epic>_TESTS.md` (see test-scenarios).
- `skills/test-scenarios/SKILL.md` — how to write contractual, customer-facing
  `<epic>_TESTS.md` scenarios.
- `skills/todo-list/SKILL.md` — TDD-based TODO list generator. Each implementation TD
  has Red (TDxx.1) / Green (TDxx.2) / Commit (TDxx.3) phases; the TD's changes are
  committed after the Green phase passes, delegated to the `committer` agent. (The old
  per-feature "Review & Commit" human-checkpoint TD and the one-TD-at-a-time / no-commit
  rules were removed.)

## What `agents/AGENTS.md` covers
- Spec-driven workflow rules: spec is the contract; never fill gaps with assumptions
  (ambiguity is a blocker — ask interactively, one question at a time, unpacking
  complex ones); no mid-flight spec changes; tests are executable spec and tests win;
  work against the docs tag.
- Implementation deliverables: code vs tag, automated tests, development report.
- Build/Lint/Verify: commands sourced from `project_context.yaml` `commands:`; run
  before done; minimal-diff/no scope-creep formatting.
- Definition of Done checklist (tests pass, lint/typecheck/build clean, report written,
  sample files synced).
- Project config via `project_context.yaml` (lives in the project folder, one level
  above the `docs` and `src` repos); maintain `PROJECT_SUMMARY.md`.
- Working conventions (don't code unless asked, use subagents, minimal diff, blocker
  protocol — never weaken/skip/mock contractual tests, never create git tags, keep
  samples in sync).
- Security & Secrets: treat config values (esp. credentials) as secret; never emit them.
- Communication & Output: concise responses, `file_path:line` references.
- Autonomous file/log reading (Read/Grep, no Bash pipes/redirects).
- Skills: `coding-standards`, `handover`, `spec-refinement`, `test-scenarios`.

## What `AGENTS.md` (workspace root) covers
- Meta-guidance for working on this repo itself.
- Consistency triangle: `agents/AGENTS.md` ↔ `project_context.template.yaml` ↔
  `init-project/SKILL.md` must stay in sync.
- Skills table and Definition of Done for this repo (including "No git tags created").

## Key source documents
- `AI_assisted_development_workflow.md` (docs/) — the methodology `agents/AGENTS.md`
  encodes. Workspace root with separate docs and source repos; docs repo split into
  `customer-facing/` and versioned `working/`; unversioned workspace-level `local/`
  scratch material; docs freeze tags; 5-step spec methodology; state-table tests;
  multi-layer acceptance; known gaps.

## Design notes / decisions
- `conductor` agent created to orchestrate multi-step work. Conductor owns the
  thinking (goal/scope/constraint analysis, task decomposition, result interpretation)
  and delegates all mechanical actions (file I/O, command execution, report writing)
  to sub-agents. Interactive mode is the default — the Analyze phase is designed as a
  dialogue with the user. Agent definition lives in
  `agent/conductor.md` (file-based opencode agent, symlinked to
  `~/.config/opencode/agent`).
- The conductor's detailed workflow was **split out of the agent file into six
  conductor-* skills** (`conductor-analyze`, `conductor-code-decomposition`,
  `conductor-noncode-decomposition`, `conductor-execute`, `conductor-escalate`,
  `conductor-report`) to reduce the base prompt size, segregate code-work from
  non-code-work flows, and load phase instructions on demand rather than loading
  everything at every turn.
- `committer` agent created to own the commit workflow: inspects the working tree,
  groups changes by topic into focused commits with descriptive messages, and executes
  them. Never pushes/tags/branches unless asked. Agent definition lives in
  `agent/committer.md`.
- `todo-list` skill revised: removed the one-TD-at-a-time rule, the
  no-commit-without-permission rule, and the per-feature "Review & Commit" checkpoint
  TD. Each TD now has a mandatory TDxx.3 Commit phase that delegates to the `committer`
  agent. The skill retains its TDD Red/Green discipline for entry-level-programmer-level
  task decomposition.
- `test-scenarios` skill format uses Pre-conditions / Steps with Before/After /
  Expected-result tables, grouped into Categories, `T-NN` IDs. State-table format
  kept as a documented alternative for multi-step scenarios.
- Contractual, customer-facing scenarios are explicitly distinguished from
  non-contractual developer implementation tests.
- `init-project` skill redesigned to scan filesystem first and infer defaults
  before asking questions — typically 0–3 questions instead of 12.
- `project_context.template.yaml` streamlined: Odoo DB credentials (`user`, `host`,
  `port`, `password`) and `qa_instance.url` removed — they come from `odoo_config.ini`.
- `specification-methodology` output format changed from single monolithic file to
  wiki-style directory tree (`spec/` with `models/`, `use-cases/` subdirs,
  `spec-index.md` as index). Use cases reference models via a `## Related Models`
  section; model files do not back-reference use cases (maintenance trade-off).
  Sections exceeding 40 lines extract to standalone files. Review process is
  agent-run with human validation at each step and a "Wiki Integrity" check.
  Large-scope projects may split use cases under `epics/<epic>/` (one
  `<epic>_TESTS.md` each) while the data model stays global.

## Planned / open
- Consider an `agents/AGENTS.md` note on non-functional requirements (workflow §8.8 gap).
