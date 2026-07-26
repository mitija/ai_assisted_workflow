---
name: conductor-report
description: Phase 6 of the conductor workflow. Produces the final conductor report — a Markdown file in docs/working/ with the goal, mode, status, task results, and ambiguities. Delegated to a general sub-agent.
---

# Conductor: Report

This skill guides the conductor's **Phase 6 — Report**. The conductor should load this skill when the task graph is exhausted (either all tasks completed successfully or the run was aborted after escalation).

## Instructions

You (the conductor) have all the data in memory from the completed run. Do **not** write the report yourself. Delegate it to a `general` sub-agent.

### 1. Prepare the data

Collect the following into a structured form you can pass to the `general` sub-agent:

- **Goal** — the original request / what was supposed to be done.
- **interaction_mode** — interactive or autonomous.
- **analysis_mode** — guided or autonomous (from the analyze phase).
- **Overall status** — `complete` (graph fully executed), `partial` (executed with deferred items or rejected human outcome), or `aborted` (escalation exhausted).
- **Task count** — how many tasks completed successfully vs. total tasks in the graph.
- **Per-task detail**, for each task in graph order: id, description, dependencies, the full prompt given to the executor, the verification performed and its result (pass/fail), the commit made (if any), and final status (passed / failed / not-started).
- **Review rounds**: for each reviewer invocation, record the round number, the reviewer's findings (counts per severity and key observations), and the conductor's resolution (remedial tasks created, suggestions implemented or advisory, any re-review outcome).
- **Analyst traceability gate** — gate status (`passed`, `passed with gaps`, or `not passed`), evidence mapping summary, limitations list, documentation discrepancies.
- **Functional-outcome check** — overall result (`pass`, `partial`, `gap`), per-criterion detail with evidence references.
- **Final human outcome** — decision (approved, rejected, accepted with caveats), caveats text.

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
**Interaction mode:** interactive | autonomous
**Analysis mode:** guided | autonomous
**Status:** complete | partial | aborted
**Tasks completed:** X / Y
**Ambiguities** (autonomous interaction mode only):
- <ambiguity> → assumed <assumption>

## Task Details

| ID | Description | Dependencies | Verification | Result | Commit | Status |
|----|-------------|--------------|--------------|--------|--------|--------|
| T01 | ... | — | ... | pass | abc1234 | passed |
| T02 | ... | T01 | ... | fail | — | failed |
```

For each task, also include the full prompt that was given to the executor (below the table or in an appendix).

### 4. Analyst traceability gate section

After the task details, include an analyst traceability gate section:

```markdown
## Analyst Traceability Gate

**Gate status:** passed | passed with gaps | not passed

<if not passed or passed with gaps: description of limitations, deferred criteria, documentation discrepancies>

**Evidence mapping:** <summary of test → requirement → criteria traceability>
```

### 5. Review section

After the task details, include a review section:

```markdown
## Review

| Round | Critical | Blocking | Warning | Suggestion | Resolution |
|-------|----------|----------|---------|------------|------------|
| 1 | 0 | 2 | 1 | 3 | 2 remedial tasks created, 1 warning accepted, 3 suggestions (1 implemented, 2 advisory) |
| 2 | 0 | 0 | 0 | 0 | No critical/blocking findings — clean |
```

For each round, describe the key findings and the conductor's decision. If the
review had non-blocking warnings or suggestions, note them explicitly — do not
claim "No tasks" means no findings of any kind. Distinguish between "no
critical/blocking findings" and a completely clean review.

### 6. Outcome sections

After the review section, include functional outcome and final human outcome:

```markdown
## Functional Outcome Check

**Overall result:** pass | partial | gap

| Criterion | Result | Evidence |
|-----------|--------|----------|
| <criterion 1> | pass | <test/verification ref> |
| <criterion 2> | partial | <test/verification ref, known gap> |

## Final Human Outcome

**Decision:** approved | rejected | accepted with caveats

<if caveats: description>
```

### 7. Final summary

After the report is written, give the user a concise summary and the report's path.
