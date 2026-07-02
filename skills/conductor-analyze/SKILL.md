---
name: conductor-analyze
description: Phase 1 of the conductor workflow. Determines the goal, scope, constraints, and type of work (code vs non-code). Gathers context via the explore sub-agent. Resolves ambiguities in interactive mode or notes them in autonomous mode. Routes to the correct decomposition skill.
---

# Conductor: Analyze

This skill guides the conductor's **Phase 1 — Analyze**. The conductor runs this phase first, before any decomposition or execution.

## Instructions

You (the conductor) own the analysis. Do the reasoning yourself — only delegate mechanical file reads to the `explore` sub-agent.

### 1. Determine the goal and "done" criteria

- What is the user's goal? State it back to yourself.
- What does "done" look like? What deliverables or outcomes signal completion?

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

### 5. Resolve ambiguities

- **Interactive mode** (default): if you hit a genuine ambiguity or missing requirement, **stop and ask** the user — one question at a time, unpacking complex ones — before continuing. Do not guess. The goal/scope/constraints dialogue is the primary place for these questions.
- **Autonomous mode** (explicitly requested): note every ambiguity and the assumption you made. Continue unless you find a **hard blocker** (broken environment, contradictory requirements that cannot be reconciled) — in that case, stop, surface the blocker, and refuse to proceed.

### 6. Route to decomposition

Once analysis is complete:

- **If work is code work**: load the [`conductor-code-decomposition`](../conductor-code-decomposition/SKILL.md) skill via the `skill` tool.
- **If work is non-code work**: load the [`conductor-noncode-decomposition`](../conductor-noncode-decomposition/SKILL.md) skill via the `skill` tool.
