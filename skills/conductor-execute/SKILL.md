---
name: conductor-execute
description: Phase 3 of the conductor workflow. Executes the task graph in topological rounds — spawns the ready set in parallel via general sub-agents, verifies each task on return, commits passing tasks via the committer. Routes to conductor-escalate on failure.
---

# Conductor: Execute

This skill guides the conductor's **Phase 3 — Execute the task graph**. The conductor should load this skill after a task graph has been produced and validated by the decomposition phase.

## Instructions

Execute the graph in topological rounds. Do not delegate the round-management logic itself — you compute the ready set, you issue parallel sub-agent calls, you decide when to verify and commit.

### 1. Compute the ready set

From the current graph state, compute all tasks that are:
- Not yet started
- All dependencies completed successfully

### 2. Spawn the ready set in parallel

Issue one `general` sub-agent per task in the ready set. Each sub-agent receives that task's `prompt` field as its prompt. Use a single parallel batch of `task` tool calls — do not launch them one at a time.

### 3. Verify each task

When all sub-agents in the round return:

- For each task, spawn a `general` sub-agent to execute the task's `verification` criteria. Tell it to run the commands and report pass/fail. Do **not** run verification commands yourself.
- Collect the pass/fail results for every task in the round.

### 4. Commit passing tasks

For each task that passes verification:

- Spawn the `committer` sub-agent with a clear, scoped commit message describing what the task accomplished.
- **Serialize commits** — issue them one at a time to avoid git races. Wait for each commit to complete before starting the next.

### 5. Repeat until exhausted

Recompute the ready set (step 1) and repeat until the graph has no remaining tasks. If a task fails, proceed to step 6.

### 6. Route to escalation on failure

If **any** task in the round fails to execute or fails verification:

- **Stop spawning new rounds.** Do not start tasks that have not begun.
- Let any already-running sub-agents in the **current round** finish, then record their outcomes.
- Do **not** commit the failed task's work.
- Load the [`conductor-escalate`](../conductor-escalate/SKILL.md) skill via the `skill` tool to handle the failure.

### 7. Reviewer audit (after graph exhausted)

When the graph is exhausted with no failures, invoke the `reviewer` sub-agent
once for a final audit of all completed work. Provide the reviewer with:

- The full task graph (all prompts, verification criteria, and outcomes).
- The relevant specification/tests (docs tag, TESTS.md).
- The repository diff and commit history so the reviewer can inspect all
  changes, including already committed ones.

The reviewer returns a review plan with findings (severity-classified) and an
implementation-ready task list for any actionable findings.

### 8. Assess findings and decide

Based on the reviewer's findings:

- **If any critical or blocking findings exist:** the conductor creates remedial
  tasks from the reviewer's task list (or refines them as needed), adds them to
  the graph, and executes them using the same execute/verify/commit workflow
  (steps 1–5, one round). After all remedial tasks are committed, invoke the
  `reviewer` sub-agent **again** to verify the fixes. Repeat this
  remediation/review cycle only while critical or blocking findings remain.
  Critical/blocking findings **cannot** be ignored.
- **If only warnings or suggestions exist:** the conductor assesses each
  non-blocking finding. Suggestions may be accepted for implementation or
  recorded as advisory. Accepted suggestions are implemented as tasks and
  committed. Advisory suggestions are noted but not acted on. **Do not** invoke
  the reviewer again for suggestions alone — this prevents an unbounded loop.
  Warnings should be evaluated similarly: fix if warranted, otherwise record.

### 9. Route to report on completion

When the graph is exhausted and the reviewer audit has passed (no critical or
blocking findings remain, and any accepted suggestions have been implemented),
load the [`conductor-report`](../conductor-report/SKILL.md) skill via the
`skill` tool to produce the final report. Include the reviewer findings and
resolution in the data passed to the report skill.

### Parallelism notes

- Sub-agents in a round run concurrently and their results return together.
- Verification happens per task **after each round returns**, not the instant an individual sub-agent finishes.
- Verify every task; never batch-verify loosely.
