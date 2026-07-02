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
| `prompt` | A **fully self-contained** prompt that a `general` sub-agent can execute with no access to this conversation. Include: goal, exact files/paths, relevant context and constraints, success criteria, and any commands to run (if applicable). Assume the executor knows nothing beyond the project's `AGENTS.md` and `project_context.yaml`. |
| `verification` | How to confirm the task succeeded. For non-code work this might be: verifying the file was written correctly, checking output with a tool, running a dry-run command, or manual inspection criteria. |

### 3. Validate the graph

Confirm:

- No cycles exist.
- Every dependency `id` refers to a task that exists in the graph.
- Every task is reachable (no orphan tasks with unmetable dependencies).

### 4. Save the graph (if extensive)

If the graph is extensive (many tasks, complex dependencies), delegate a `general` sub-agent to save the task graph as a Markdown file in `docs/working/`. For simple, small task lists, keep the graph in memory.

### 5. Route to execution

Once the graph is validated, load the [`conductor-execute`](../conductor-execute/SKILL.md) skill via the `skill` tool to begin executing tasks in dependency order.
