---
name: conductor-report
description: Phase 5 of the conductor workflow. Produces the final conductor report — a Markdown file in docs/working/ with the goal, mode, status, task results, and ambiguities. Delegated to a general sub-agent.
---

# Conductor: Report

This skill guides the conductor's **Phase 5 — Report**. The conductor should load this skill when the task graph is exhausted (either all tasks completed successfully or the run was aborted after escalation).

## Instructions

You (the conductor) have all the data in memory from the completed run. Do **not** write the report yourself. Delegate it to a `general` sub-agent.

### 1. Prepare the data

Collect the following into a structured form you can pass to the `general` sub-agent:

- **Goal** — the original request / what was supposed to be done.
- **Mode** — interactive or autonomous. If autonomous, the list of ambiguities encountered and assumptions made.
- **Overall status** — `complete` (graph fully executed) or `aborted` (escalation exhausted).
- **Task count** — how many tasks completed successfully vs. total tasks in the graph.
- **Per-task detail**, for each task in graph order: id, description, dependencies, the full prompt given to the executor, the verification performed and its result (pass/fail), the commit made (if any), and final status (passed / failed / not-started).

### 2. Delegate report writing

Spawn a `general` sub-agent with:

- The structured data from step 1.
- The file path: `docs/working/conductor-report-<YYYYMMDD-HHMM>.md`.
- Clear formatting instructions matching the outline below.

### 3. Report format

The report must contain:

```markdown
# Conductor Report — <YYYYMMDD-HHMM>

**Goal:** <what was supposed to be done>
**Mode:** interactive | autonomous
**Status:** complete | aborted
**Tasks completed:** X / Y
**Ambiguities** (autonomous mode only):
- <ambiguity> → assumed <assumption>

## Task Details

| ID | Description | Dependencies | Verification | Result | Commit | Status |
|----|-------------|--------------|--------------|--------|--------|--------|
| T01 | ... | — | ... | pass | abc1234 | passed |
| T02 | ... | T01 | ... | fail | — | failed |
```

For each task, also include the full prompt that was given to the executor (below the table or in an appendix).

### 4. Final summary

After the report is written, give the user a concise summary and the report's path.
