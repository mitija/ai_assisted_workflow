---
name: conductor-analyze
description: Phase 1 of the conductor workflow. Determines the goal, scope, constraints, and type of work (code vs non-code). Gathers context via the explore sub-agent. Resolves ambiguities in interactive mode or notes them in autonomous mode. Determines whether sufficient functional analysis exists and delegates to the analyst sub-agent when it does not. Routes to the correct decomposition skill after analyst baseline is ready.
---

# Conductor: Analyze

This skill guides the conductor's **Phase 1 — Analyze**. The conductor runs this phase first, before any decomposition or execution.

## Instructions

You (the conductor) own the analysis. Do the reasoning yourself — only delegate mechanical file reads to the `explore` sub-agent.

### 1. Determine the goal and "done" criteria

- What is the user's goal? State it back to yourself.
- What does "done" look like? What deliverables or outcomes signal completion?

### 1a. Determine and record modes

Determine both `interaction_mode` and `analysis_mode`:

- **interaction_mode**: interactive (default) or autonomous (explicitly requested).
  Controls ambiguity-resolution behaviour throughout the run.
- **analysis_mode**: guided or autonomous. Controls the analyst's human-in-the-loop
  policy during functional analysis. If the analyst will be invoked, the analyst
  confirms or selects the analysis_mode during its intake phase. If existing
  analysis suffices, record the analysis_mode from context.

State both modes and record them. The report phase receives both values.

### 1b. Confirm filesystem boundary (autonomous mode only)

If running in autonomous mode and the preflight was not already executed by the
conductor prompt, run it now:

1. Delegate reading `opencode.json` and `project_context.yaml` to the `explore`
   sub-agent to find all absolute paths outside the project root.
2. Extend scanning to also discover paths from:
    - Project config files — `.ini`, `.cfg`, `.env`, and equivalent config files.
    - Environment-variable references — `$HOME`, `$PROJECTS`, or other variables
      used in config, resolved after expansion.
    - Git-linked directories — `git submodule`, `git worktree` locations.
    - Dependency-link targets — `npm link` or equivalent symlinked dependency
      directories.
    - User declaration — any path explicitly stated.
3. Normalize — for each discovered path, perform environment-variable and
     tilde expansion, normalize `.`/`..`, resolve to an absolute path, and
     canonicalize symlinks before classifying it.
 4. Filter — reject broad values such as `$HOME`, `~/`, `~/**`, `$PROJECTS`,
     `~/Projects/**`, or a parent workspace directory. Only concrete project-specific
     paths are eligible as authorization candidates.
 5. Compare against the authorized `permission.external_directory` entries.
 6. If any unapproved external paths are needed, **stop** and surface them to the
    user. Do not proceed until the user confirms which paths to add and
    `opencode.json` is updated and validated.
 7. For interactive mode, handle external-path questions as part of the normal
   ambiguity-resolution dialogue (step 5).

### 2. Determine work type

Classify the work as one of:

- **Code work** — involves writing, modifying, or testing source code. Includes bug fixes, features, refactoring, test writing, and spec-implementation cycles.
- **Non-code work** — involves documentation, configuration, project setup, file organisation, or research that does not produce application code.

This decision determines which decomposition skill to load next.

### 3. Gather context

Use the `explore` sub-agent to read and summarise relevant files. You do not read files yourself.

Always check:

- `project_context.yaml` — build/lint/test commands, paths, docs tag.
- `PROJECT_SUMMARY.md` — project state and recent work.
- The current docs tag's spec and test files (location from `project_context.yaml`).
- Any other files the user's request or the project structure suggests are relevant.

Interpret the `explore` agent's summaries. Do not delegate reasoning.

### 4. Determine constraints and out-of-scope

From the user's request and the context you gathered:

- What constraints apply? (Time, scope, conventions, compatibility.)
- What is explicitly out of scope? (If not stated, note that in the report later.)

### 5. Check analysis sufficiency

After gathering context and understanding constraints, determine whether
sufficient functional analysis already exists to proceed to decomposition.

**Sufficiency criteria** — the minimum required before decomposition can begin:

1. An **objective brief** exists (or can be confirmed from the user's request
   directly) that captures the functional objective, high-level
   criteria, constraints, scope boundaries, and selected analysis_mode.
2. **Functional requirements** are defined with clear statements and
   traceability to the objective.
3. **Detailed success criteria and verification methods** exist for every
   mandatory requirement.
4. **Business rules** are documented where applicable.
5. **Traceability** links objectives → criteria → requirements → verification.
6. The **quality gate** has been passed (all critical findings resolved).
7. In **guided mode**: the human has approved the functional interpretation.
   In **autonomous mode**: no blocking unresolved decisions remain.

If these criteria are met, the analysis is sufficient. Proceed to step 6.

If these criteria are **not** met, delegate to the **`analyst` sub-agent**:

1. Spawn the analyst with the current objective, context, and analysis_mode.
2. The analyst conducts intake using the provided analysis_mode, selects and
   records it, then proceeds through its single four-phase sequence:
   intake → discovery → review → baseline.
3. **In guided `analysis_mode`:**
   - The analyst pauses for objective-brief confirmation during intake.
   - Only blocking Class C and all Class D decisions interrupt earlier phases
     (intake, discovery). Non-blocking Class C decisions proceed without pausing.
   - One consolidated functional validation gate runs during analyst-review.
4. **In autonomous `analysis_mode`:**
   - The analyst does **not** make Class C or Class D decisions independently.
     Both Class C and D stop and ask immediately, per the current analyst policy.
   - The objective brief confirmation remains mandatory.
5. After the analyst completes, **read its output** (objective brief,
   requirements baseline, traceability) via the `explore` sub-agent.

**Do not** perform detailed elicitation yourself — that is the analyst's
responsibility. You own the decision to delegate, the alignment check, and the
acceptance of the baseline.

### 6. Check objective/scope alignment

Once the analyst baseline is available (or existing analysis is confirmed
sufficient), verify:

- Does the baseline still match the original functional objective?
- Has scope crept without authorisation?
- Are there any unexplained additions or omissions?

If misalignment is found, challenge it before proceeding. In interactive mode,
surface the discrepancy to the user. In autonomous mode, record it and adjust
the scope assumption.

### 7. Resolve ambiguities

- **Interactive mode** (default): if you hit a genuine ambiguity or missing requirement, **stop and ask** the user — one question at a time, unpacking complex ones — before continuing. Do not guess. The goal/scope/constraints dialogue is the primary place for these questions.
- **Autonomous mode** (explicitly requested): note every ambiguity and the assumption you made. Continue unless you find a **hard blocker** (broken environment, contradictory requirements that cannot be reconciled) — in that case, stop, surface the blocker, and refuse to proceed.

### 8. Confirm readiness and route to decomposition

Confirm the analyst readiness gate criteria are satisfied (see sufficiency
criteria in step 5). If the analyst was delegated to, confirm its baseline
is complete and accepted.

Once readiness is confirmed:

- **If work is code work**: load the [`conductor-code-decomposition`](../conductor-code-decomposition/SKILL.md) skill via the `skill` tool.
- **If work is non-code work**: load the [`conductor-noncode-decomposition`](../conductor-noncode-decomposition/SKILL.md) skill via the `skill` tool.
