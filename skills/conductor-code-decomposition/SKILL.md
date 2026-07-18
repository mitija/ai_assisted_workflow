---
name: conductor-code-decomposition
description: Phase 2 for code work. Produces a dependency-aware task graph from code-related tasks. If the requirement is rough, loads spec-refinement then specification-methodology first. Checks for an existing TODOxx.md or generates one via the todo-list skill. Maps TDs to graph tasks with the standard schema.
---

# Conductor: Code Decomposition

This skill guides the conductor's **Phase 2 — Decompose into a task graph** for **code work**. The conductor should load this skill only after analysis has determined the work is code-related.

## Prerequisites

If the initial requirement is **rough or ambiguous**, first load the
[`spec-refinement`](../spec-refinement/SKILL.md) skill to refine it, then load
the [`specification-methodology`](../specification-methodology/SKILL.md) skill
to produce the full specification — **both before** decomposing into tasks.

In **autonomous mode**, `spec-refinement` is an interactive, one-question-at-a-time
dialogue with the user and cannot run. If the requirement is rough in autonomous
mode, treat it as a hard blocker — stop, surface it, and refuse to proceed —
unless the user is available to answer questions. For a well-specified
requirement, skip `spec-refinement` and proceed.

## Instructions

### 1. Check for an existing TODOxx.md

Use the `explore` sub-agent to check whether a TODOxx.md file already exists in the workspace (typically under `docs/working/`).

- **If one exists**: use it directly — do not regenerate. Map its TDs onto the task graph in step 3.
- **If none exists**: spawn a `general` sub-agent to generate the `TODOxx.md`. Give the sub-agent the **absolute path** to the todo-list skill instructions (`~/.config/opencode/skills/todo-list/SKILL.md`) and instruct it to follow that discipline and write the file to `docs/working/TODOxx.md`. Do not load the skill into your own context — the sub-agent owns the generation; you only review the result.

### 2. Produce the task graph

Every task in the graph must have these fields — this schema mirrors the one in
`agents/agent/conductor.md` (§ Task schema). Keep the two copies in sync; the
execute and report phases depend on these exact field names:

| Field | Description |
|-------|-------------|
| `id` | Short unique label (`T01`, `T02`, …) |
| `dependencies` | List of task ids that must complete before this task (empty if none) |
| `description` | One-line summary of what the task accomplishes |
| `prompt` | A **fully self-contained** prompt that a `general` sub-agent can execute with no access to this conversation. Include: goal, exact files/paths, relevant context and constraints, success criteria, and any commands to run. Assume the executor knows nothing beyond the project's `AGENTS.md` and `project_context.yaml`. |
| `verification` | How to confirm the task succeeded. Command(s) to run (tests, lint, typecheck, build) and the expected result, plus any success criteria to check. |

### 3. Map TDs onto tasks

For each TD from the TODOxx.md:

- Create one or more tasks that implement the TD's intent.
- Carry the TD's dependency order into the task's `dependencies` field.
- The `prompt` should fully describe the work the sub-agent must do (Red/Green phases per the todo-list skill's convention).
- The `verification` field should reference tests the TD covers.

### 4. Validate the graph

Confirm:

- No cycles exist.
- Every dependency `id` refers to a task that exists in the graph.
- Every task is reachable (no orphan tasks with unmetable dependencies).

### 5. Save the graph (if extensive)

If the graph is extensive (many tasks, complex dependencies), delegate a `general` sub-agent to save the task graph as a Markdown file in `docs/working/`. Name it descriptively (e.g. `task-graph-<topic>.md`). For simple, small task lists, keep the graph in memory.

### 6. Route to execution

Once the graph is validated, load the [`conductor-execute`](../conductor-execute/SKILL.md) skill via the `skill` tool to begin executing tasks in dependency order.
