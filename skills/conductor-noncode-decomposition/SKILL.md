---
name: conductor-noncode-decomposition
description: Phase 2 for non-code work. Produces a task graph for non-code tasks — documentation, configuration, research, project setup. No spec-refinement or todo-list skill needed. Uses the standard per-task schema.
---

# Conductor: Non-Code Decomposition

This skill guides the conductor's **Phase 2 — Decompose into a task graph** for **non-code work**. The conductor should load this skill only after analysis has determined the work is not code-related.

## Instructions

### 1. Identify the task sequence

Non-code work includes things like:
- Writing or editing documentation
- Creating or updating configuration files
- Project setup and tooling
- Research and analysis
- File organisation or cleanup
- Spec writing (when the spec is the deliverable, not code implementing it)

Think through the steps required and their dependency order. Be explicit about what needs to happen first and what can happen in parallel.

### 2. Define each task

Every task in the graph must have these fields — this schema mirrors the one in
`agents/agent/conductor.md` (§ Task schema). Keep the two copies in sync; the
execute and report phases depend on these exact field names:

| Field | Description |
|-------|-------------|
| `id` | Short unique label (`T01`, `T02`, …) |
| `dependencies` | List of task ids that must complete before this task (empty if none) |
| `description` | One-line summary of what the task accomplishes |
| `prompt` | A **fully self-contained, bounded-autonomy** prompt stating intent/outcome, relevant scope/touchpoints, context, fixed constraints with reasons, semantic success criteria, required evidence, and commands where applicable. Leave wording, internal design, and final file set open unless a traced requirement or convention fixes them. |
| `verification` | Evidence mapped to the intended outcome, such as an authoritative command, dry run, inspection, or manual criterion. Exact wording is required only when it is itself the contract; accidental literal markers are not semantic proof. |

### 3. Validate the graph

Confirm:

- No cycles exist.
- Every dependency `id` refers to a task that exists in the graph.
- Every task is reachable (no orphan tasks with unmetable dependencies).

### 4. Save the graph (if extensive)

If the graph is extensive (many tasks, complex dependencies), delegate a `general` sub-agent to save the task graph as a Markdown file in `docs/working/`. For simple, small task lists, keep the graph in memory.

### 5. Route to execution

Once the graph is validated, load the [`conductor-execute`](../conductor-execute/SKILL.md) skill via the `skill` tool to begin executing tasks in dependency order.
