# PROJECT_SUMMARY.md

## Purpose
Build a reusable, working `AGENTS.md` to drop into all projects, plus an Odoo-specific
companion, a set of agents/skills, and a general-purpose conductor agent, so AI agents can orchestrate multi-step tasks and long-horizon autonomous agentic flows
using a consistent workflow — supporting general AI activity,
including software development, documentation, configuration, research, and
project setup (spec-driven development is a key supported use case).
The framework is production-ready but still evolving, and applies beyond Odoo.
Deliverables live in `agents/`.

## Current status
Production-ready for its core, spec-driven coding workflow, while broader
documentation, research, analysis, configuration, and project-setup workflows remain
less mature and evolving. The established paradigm is human objective ownership;
an analyst-owned four-phase functional-contract lifecycle (intake, discovery, review,
and traceable baseline); and conductor-owned six-phase code/non-code delivery
(analyze, decompose, execute, review, escalate, and report). `analysis_mode` and
`interaction_mode` are independent. Implementers and the verifier produce evidence,
the mandatory reviewer audits it, the conductor assesses the functional outcome, and
the human makes the final judgement. Analysis quality, non-functional and non-code
verification, tooling, environment setup, and adoption remain honest limitations.
No code/app component — this is a guidance/skill bundle for agents. The root-level
`skills/` directory holds ten general skills and six conductor-specific skills
(internal orchestration steps).
Linked skill tables are maintained in README.md, root AGENTS.md, and the deployable agents/AGENTS.md, documenting both categories.
Session handover files (`HANDOVER*`) are gitignored at the root.

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
  Current assignments: `analyst`, `conductor`, `reviewer`, `escalate1`, `escalate2` run on
  `openrouter/openai/gpt-5.6-sol`; `committer` on
  `openrouter/deepseek/deepseek-v4-flash`; `plan`, `build`, `explore`,
  `general`, `verifier` on `openrouter/deepseek/deepseek-v4-flash`. OpenRouter model
  entry `openai/gpt-5.6-sol` uses the
  `reasoningEffort: "max"` option under `provider.openrouter.models`.
  Also includes `permission.external_directory` — the authoritative list of
  approved external paths outside the project root, generated and maintained
  by the agent preflight workflow. Currently empty; paths are added per-project.
- `agent/analyst.md` — opencode agent definition for the `analyst`
  (functional contract owner). Classification: Both (`mode: all`). Transforms high-level
  human intent into a complete, defensible functional contract — requirements, business rules,
  success criteria, traceability, documentation, and wireframes. Operates in autonomous or
  guided mode. Orchestrates four lifecycle phases via analyst-* skills loaded on demand:
  Phase 1 Intake (`analyst-intake`), Phase 2 Discovery (`analyst-discovery`),
  Phase 3 Review (`analyst-review`), Phase 4 Baseline (`analyst-baseline`).
Class A-D decisions are impact-based (A=minor/reversible, B=low-impact functional,
   C=material/consequential, D=blocking/high-risk) and distinct from the seven-value
   provenance system. Class C handling is mode-dependent: ask immediately in autonomous
   mode; defer non-blocking to the guided validation package. Class D always stops and
   asks immediately. Class A/B resolved autonomously. Governed by provenance —
every requirement and important business rule carries exactly one label (explicitly-requested, inferred-context,
    inherited, domain-practice, design-decision, risk-control, unresolved) and is never
    silently presented as human-requested. Analysis mode (autonomous/guided) is an
   independent value selected at intake, distinct from the conductor's interaction
   style or implementation autonomy. Never implements
  application code. Permission: `edit: allow`, `task: allow`, `bash` limited to read-only
  inspection commands (`git status`, `git log`, `git diff`, `grep`, `ls`).
- `agent/conductor.md` — ...
  (orchestration agent). Classification: Primary. Symlinked to `~/.config/opencode/agent` by
  `tools/install.sh` for auto-discovery. Conductor runs on a better AI model
  than sub-agents and **owns all thinking, planning, and decision-making**
  (determining goals, constraints, scope, task decomposition). It **never**
  reads/writes files, edits code, or runs commands itself — those mechanical
  actions are delegated to sub-agents. The detailed workflow has six phases:
  Phase 1 Analyze (`conductor-analyze`), Phase 2 Code/Noncode Decomposition
  (`conductor-code-decomposition` / `conductor-noncode-decomposition`),
  Phase 3 Execute (`conductor-execute`), Phase 4 Review (via `reviewer` agent),
  Phase 5 Escalate (`conductor-escalate`), Phase 6 Report (`conductor-report`).
  Phase instructions are loaded on demand so the
  base prompt stays small. Interactive mode (default) is a dialogue with the
  user for ambiguity resolution; autonomous mode only when requested.
  Decomposes work into a dependency-aware task graph, uses `explore` sub-agents
  for file reading, `general` sub-agents for execution, `verifier` sub-agents for verification,
  `committer` for commits, `escalate1`/`escalate2` for failure diagnosis, and
  delegates report writing to a sub-agent. After graph completion, invokes the
  `reviewer` for a final audit; critical/blocking findings trigger a
  remediation/re-review loop, while warnings and suggestions are assessed by the
  conductor and do not trigger another reviewer invocation on their own.
  Final review by `reviewer` is mandatory — cannot substitute another agent.
  The `verifier` sub-agent handles delegated shell-command verification steps.
  Loop prevention rules prohibit recursive or self-delegation.
- `agent/committer.md` — opencode agent definition for the `committer` (sub-agent).
  Classification: Subagent. Inspects the working tree, groups changes by topic into focused commits with
  descriptive messages, and executes them. Never tags, pushes, or branches unless
  explicitly asked.
- `agent/reviewer.md` — opencode agent definition for the `reviewer`.
  Classification: Both. `mode: all` (both primary and subagent invocable). Read-only
  inspection of work for correctness, style, and completeness. Produces a structured
  review plan with findings (issues, warnings, passes), verdict, and an
  implementation-ready task list: every task specifies exact file path + line,
  a concrete change instruction, the rationale/behaviour rule, dependency ordering,
  and a verify command with expected result. Prohibits vague/deferred wording
  ("review this", "investigate", "fix as appropriate"); unresolved ambiguities are
  reported as blockers/questions rather than left for the implementer. Outputs an
  explicit "No tasks" result when no changes are needed. Never edits files.
  Delegates commands outside its curated read-only allowlist to the `verifier`
  sub-agent.
- `agent/escalate1.md` — opencode agent definition for `Escalate1`, the first-tier
  escalation subagent. Classification: Subagent. Called when the primary build agent hits an issue it cannot
  resolve. Read-only (edit denied; webfetch allowed; bash limited to a curated
  read-only inspection allow-list; task limited to invocations of `verifier` only) —
  diagnoses and produces a task plan for a cheaper model to execute. Delegates
  commands outside its curated allowlist to the `verifier` sub-agent.
- `agent/escalate2.md` — opencode agent definition for `Escalate2`, the second-tier
  escalation subagent. Classification: Subagent. Called when Escalate1 cannot resolve an issue. Read-only
  (edit denied; webfetch allowed; bash limited to a curated read-only inspection
  allow-list; task limited to invocations of `verifier` only) — deep-dive diagnosis
  producing a task plan for a cheaper model to execute. Delegates commands outside
  its curated allowlist to the `verifier` sub-agent. Deep reasoning on hard problems.
- `agent/verifier.md` — opencode agent definition for the `verifier` subagent.
  Classification: Subagent. `mode: subagent`; `edit: deny`; `task: deny` (flat deny — recursion impossible);
  `bash: allow` (unrestricted — see trust boundary caveat under Design notes).
  Runs exact delegated verification shell commands and reports structured
  PASS/FAIL/BLOCKED evidence (command, exit status, output). Strict prompt
  forbids installs, deployments, destructive ops, invented commands, shell
  composition, and asking the user. Reports BLOCKED if the command is unsafe,
  absent, ambiguous, or requires approval. May be invoked by `reviewer`,
  `escalate1`, or `escalate2` for commands outside their curated read-only
  allowlists.
- `skills/analyst-intake/SKILL.md` — Phase 1 of the analyst workflow. Conducts initial high-level Q&A with the human to establish the problem, intended users, functional outcome, high-level success criteria, important constraints, explicit exclusions, major preferences, known integrations, and selected operating mode. Produces the objective brief. Determines whether sufficient analysis already exists or full discovery is needed.
- `skills/analyst-discovery/SKILL.md` — Phase 2 of the analyst workflow. Transforms the confirmed objective brief into a complete, defensible functional contract through a structured 20-step discovery process. Evidence-first — inspects existing material before asking. Resolves non-blocking decisions autonomously, escalates consequential ones. Produces functional, non-functional, operational, and documentation requirements with provenance, business rules, success criteria, verification definitions, wireframes, and intended documentation.
- `skills/analyst-review/SKILL.md` — Phase 3 of the analyst workflow. Performs the requirements quality gate — checking every requirement for necessity, clarity, singularity, consistency, feasibility, testability, traceability, implementation independence, priority, visible assumptions, and scope. In guided mode, produces the functional validation package for human review and propagates all feedback across affected artefacts.
- `skills/analyst-baseline/SKILL.md` — Phase 4 of the analyst workflow. Establishes and maintains the requirements baseline with stable identifiers, traceability, and consistency across the project lifecycle. Supports implementation (interpretation, change evaluation, scope protection), verification (evidence mapping), and completion (final documentation baseline). Maintains traceability from objective through high-level criteria, requirements, detailed criteria, verification, and evidence.
- `skills/coding-standards/SKILL.md` — coding standards (currently logging).
- `skills/handover/SKILL.md` — creates self-contained HANDOVER-xx.md at session end.
- `skills/init-project/SKILL.md` — scan-first workflow to create `project_context.yaml`
  with inferred defaults; asks the user only for what cannot be discovered.
- `skills/specification-methodology/SKILL.md` — optional post-baseline specification
   structuring tool (all five steps uninterrupted — no methodology-owned approval gate;
   material contract issues discovered during structuring route back to analyst).
   Consumes the validated analyst baseline and produces wiki-style `spec/` directory
  with individual files per model (`models/`, global/shared) and use case
  (`use-cases/`, flat by default or grouped under `epics/<epic>/` for large-scope
  projects), cross-referenced via relative links. Main `spec-index.md` serves as
  index; sections over 40 lines extract to standalone files. Gherkin acceptance
  criteria feed the contractual `<epic>_TESTS.md` (see test-scenarios). Not a
  requirements elicitation process — the analyst owns the functional contract.
  Not a mandatory conductor prerequisite.
- `skills/test-scenarios/SKILL.md` — how to write contractual, customer-facing
  `<epic>_TESTS.md` scenarios.
- `skills/todo-list/SKILL.md` — TDD-based TODO list generator. Each implementation TD
  has Red (TDxx.1) / Green (TDxx.2) / Commit (TDxx.3) phases; the TD's changes are
  committed after the Green phase passes, delegated to the `committer` agent. (The old
  per-feature "Review & Commit" human-checkpoint TD and the one-TD-at-a-time / no-commit
  rules were removed.)

## What `agents/AGENTS.md` covers
- Spec-driven workflow rules: spec is the contract; never fill gaps with assumptions
   (genuine ambiguity is a blocker — stop and route to the analyst for functional
   interpretation, one question at a time, unpacking complex ones); no mid-flight spec
   changes; tests are executable spec and tests win;
  work against the docs tag.
- Implementation deliverables: code vs tag, automated tests, development report.
- Build/Lint/Verify: commands sourced from `project_context.yaml` `commands:`; run
  before done; minimal-diff/no scope-creep formatting.
- Definition of Done checklist (tests pass, lint/typecheck/build clean, report written,
  sample files synced).
- Project config via `project_context.yaml` (lives in the project folder, one level
  above the `docs` and `src` repos); maintain `PROJECT_SUMMARY.md`.
- **Filesystem Boundary & External Access**: project root is the default boundary;
  external directories require `permission.external_directory` entries in the
  project `opencode.json`. Broad patterns (`~/Projects/**`, `~/**`) prohibited.
  Conductor autonomous mode requires a permission preflight before execution:
  scans `project_context.yaml` and config for absolute external paths, compares
  against authorized entries, asks user for confirmation, persists approved paths
  in `opencode.json`. New legitimate paths discovered during execution follow the
  same update path. Only project-specific paths are added; unrelated paths remain
  at default "ask" policy.
- Working conventions (don't code unless asked, use subagents, minimal diff, blocker
  protocol — never weaken/skip/mock contractual tests, never create git tags, keep
  samples in sync).
- Security & Secrets: treat config values (esp. credentials) as secret; never emit them.
- Communication & Output: concise responses, `file_path:line` references.
- Autonomous file/log reading (Read/Grep, no Bash pipes/redirects).
- Skills: `analyst-intake`, `analyst-discovery`, `analyst-review`, `analyst-baseline`, `coding-standards`, `handover`, `init-project`, `specification-methodology`, `test-scenarios`, `todo-list`.

## What `AGENTS.md` (workspace root) covers
- Meta-guidance for working on this repo itself.
- Consistency triangle: `agents/AGENTS.md` ↔ `project_context.template.yaml` ↔
  `init-project/SKILL.md` must stay in sync.
- Skills table and Definition of Done for this repo (including "No git tags created").

## Key source documents
- `AI_assisted_development_workflow.md` (docs/) — the methodology `agents/AGENTS.md`
  encodes. Workspace root with separate docs and source repos; docs repo split into
  `customer-facing/` and versioned `working/`; unversioned workspace-level `local/`
  for project-local tool config and scratch material, with `local/tmp/` for
  multi-layer acceptance; known gaps.
- `docs/workflow/README.md` — wiki-style collection of detailed pages (philosophy,
  principles, workspace layout, specification, test suite, workflow, acceptance,
  known gaps), linked from the landing page above.

## Design notes / decisions
- `conductor` agent created to orchestrate multi-step work. Conductor owns the
  thinking (goal/scope/constraint analysis, task decomposition, result interpretation)
  and delegates all mechanical actions (file I/O, command execution, report writing)
  to sub-agents. Interactive mode is the default — the Analyze phase is designed as a
  dialogue with the user. Agent definition lives in
  `agent/conductor.md` (file-based opencode agent, symlinked to
  `~/.config/opencode/agent`).
- Prior to autonomous-mode execution, the conductor runs a **permission preflight**
  that scans `project_context.yaml` and config for absolute external paths, compares
  against `permission.external_directory` in `opencode.json`, and requires user
  confirmation before adding new paths. This prevents silent external access and
  ensures broad parent/home patterns are never authorized.
- The project-level `opencode.json` is the single source of truth for
  external-directory permissions. Paths are added as `"<path>/**": "allow"` entries
  and only for concrete, project-specific locations. Broad patterns are prohibited
  by documented policy.
- The conductor's detailed workflow was **split out of the agent file into six
  conductor-* skills** (`conductor-analyze`, `conductor-code-decomposition`,
  `conductor-noncode-decomposition`, `conductor-execute`, `conductor-escalate`,
  `conductor-report`), covering five of the six workflow phases (Phase 4 Review
  is handled by the `reviewer` agent, not a conductor-* skill), to reduce the base prompt size, segregate
  code-work from non-code-work flows, and load phase instructions on demand
  rather than loading everything at every turn.
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
Sections exceeding 40 lines extract to standalone files. All five steps run
   uninterrupted; there is no methodology-owned approval gate — material contract
   issues route back to the analyst change/decision/validation policy.
   Large-scope projects may split use cases under `epics/<epic>/` (one
  `<epic>_TESTS.md` each) while the data model stays global.
- `analyst` agent created as the dedicated functional contract owner. Operates in
   autonomous or guided mode with four lifecycle phases driven by analyst-* skills.
   Class A-D decisions are impact-based (A=minor/reversible, B=low-impact functional,
   C=material/consequential, D=blocking/high-risk) and distinct from the seven-value
   provenance system. Class C handling is mode-dependent (ask immediately in autonomous;
   defer non-blocking to guided validation package); Class D always stops and asks
immediately; Class A/B resolved autonomously. Provenance is a separate concept —
    every requirement and important business rule carries exactly one label (explicitly-requested, inferred-context,
    inherited, domain-practice, design-decision, risk-control, or unresolved) and is
    never silently presented as human-requested. Analysis mode is an independent value
   selected at intake, distinct from the conductor's interaction style or implementation
   autonomy.
- `analyst-intake` skill (Phase 1): high-level Q&A producing a confirmed objective
   brief. `analyst-discovery` skill (Phase 2): 20-step evidence-first discovery
   process producing functional, non-functional, operational, and documentation
   requirements with provenance, business rules, success criteria, verification
   definitions, wireframes, and intended documentation. It preserves the valuable
   historical refinement techniques now integrated: evidence/ambiguity-led probing
   rather than a fixed questionnaire; one-question-at-a-time interactive clarification;
   canonical terminology; defining workflows rather than generic CRUD; relationship
   ownership, cardinality, lifecycle, and delete analysis with boundary scenarios;
   and distinguishing invariant rules from examples. `analyst-review` skill
  (Phase 3): requirements quality gate checking 11 per-requirement and 7 whole-set
  criteria; guided mode produces a functional validation package. `analyst-baseline`
skill (Phase 4): stable identifiers, traceability (OBJ → HC → FR/BR/NFR/OPS/DOC → SC →
VER), consistency maintenance across the full lifecycle, and a documentation/traceability gate
    after verification/evidence mapping. The gate returns only passed or not passed (documentation
    domain); it does not produce a complete/partial/aborted verdict. That overall status is
    determined later by the conductor/report after mandatory reviewer audit, functional-outcome
    assessment, and final human outcome review.
- `spec-refinement` skill was removed and replaced by the analyst methodology.
  The `specification-methodology` skill remains as a general-purpose spec authoring
  tool, but is no longer a conductor-phase prerequisite — spec writing is the
  analyst's responsibility when detailed requirements are needed.
- The conductor's Phase 1 (Analyze) now includes an analyst readiness gate:
  before proceeding to decomposition, the conductor must confirm a sufficient
  functional analysis baseline exists. If not, it delegates to the analyst
  sub-agent. The conductor owns the decision to delegate, the alignment check,
  and acceptance of the baseline — not detailed elicitation.

## Planned / open
- Consider an `agents/AGENTS.md` note on non-functional requirements (workflow §8.8 gap).

## Accepted trust boundary

The `verifier` sub-agent has `bash: allow` — unrestricted shell access. This is
an intentional design choice: project-specific verification commands (tests,
builds, linters, typecheckers) vary arbitrarily across projects, and a
project-specific allowlist would defeat the verifier's generality. Non-mutation
and non-destructive restrictions are prompt-enforced rather than enforced by a
technical sandbox. Delegating parent agents (Reviewer, Escalate1, Escalate2)
must provide only trusted verification commands.
