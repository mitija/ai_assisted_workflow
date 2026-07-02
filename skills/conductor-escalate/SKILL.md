---
name: conductor-escalate
description: Phase 4 of the conductor workflow. Handles task failures — stops new work, records outcomes, delegates diagnosis to escalate1 then escalate2, creates remedial tasks from their plans or aborts. Routes to conductor-report on abort or recovery.
---

# Conductor: Escalate

This skill guides the conductor's **Phase 4 — Escalate on failure**. The conductor should load this skill when a task fails to execute or fails verification during the execution phase.

## Instructions

### 0. Precondition

You (the conductor) reached this skill because:

- A task failed during execution or verification.
- You have already stopped spawning new rounds (from [`conductor-execute`](../conductor-execute/SKILL.md)).
- You have let any already-running sub-agents in the current round finish and recorded their outcomes.
- You have **not** committed the failed task's work.

### 1. First-tier escalation

Spawn the `escalate1` sub-agent. Provide it with:

- The failed task's prompt.
- The error, test output, or verification failure.
- What was already tried (execution attempts, verification commands run).
- Any relevant context (logs, diff, file paths).

Escalate1 is read-only — it inspects and plans but does not edit. It returns its
diagnostic task plan **in its final message** (it does not write a file).

### 2. Evaluate escalate1's plan

Read escalate1's plan directly from the sub-agent's return message — you do not
need a separate file read.

- **If escalate1 produced a plan**: create new tasks from it. Add these new tasks to the task graph as dependencies of the original failed task (so the original can be retried after them). Continue execution by loading the [`conductor-execute`](../conductor-execute/SKILL.md) skill via the `skill` tool with the updated graph.
- **If escalate1 returned no plan or its tasks also fail**: proceed to second-tier escalation (step 3).

### 3. Second-tier escalation

Spawn `escalate2` with the full failure chain (including what escalate1 found and what happened when you tried its plan). Escalate2 performs a deeper diagnosis.

Repeat step 2 with escalate2's plan.

### 4. Abort

- **If escalate2 also returns no plan or its tasks fail**: proceed to the report phase.
- Load the [`conductor-report`](../conductor-report/SKILL.md) skill via the `skill` tool to write the final report with the abort status.

### Interactive mode

In interactive mode (default), report each escalation attempt to the user and ask for guidance before proceeding to the next tier:

1. Before spawning escalate1, tell the user a task failed and ask if they want to proceed with escalation.
2. Before spawning escalate2, report what escalate1 found and ask for confirmation.
3. Before aborting, inform the user and ask if they want to try a different approach.
