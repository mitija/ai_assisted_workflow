---
name: conductor-execute
description: Phase 3 of the conductor workflow. Executes the task graph in topological rounds — spawns the ready set in parallel via general sub-agents, delegates verification to the verifier sub-agent, commits passing tasks via the committer. Routes to conductor-escalate on failure.
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

- For each task, spawn a `verifier` sub-agent to execute the exact verification commands. Pass the commands verbatim and require structured `VERIFY PASS|FAIL|BLOCKED` evidence. Treat BLOCKED as a failed verification — it routes through normal failure/escalation (step 6). Do **not** run verification commands yourself.
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

### 7. Analyst traceability gate (after graph exhausted)

When the graph is exhausted with no failures and before invoking the reviewer,
invoke the `analyst` sub-agent once to map implementation verification evidence
into the functional baseline. Provide the analyst with:

- The original requirements baseline (objective brief, requirements, success
  criteria, traceability matrix).
- The full task results: every task id, its verification commands and
  pass/fail outcome.
- The repository diff and commit history so the analyst can inspect all
  changes.
- The docs tag used during implementation.

The analyst must perform the following and report results:

1. **Map verification evidence** — link each passing/failing test result to the
   corresponding requirement and success criterion in the traceability baseline.
2. **Reconcile intended documentation** — verify that the implemented behaviour
   matches the intended functional documentation (`docs/customer-facing/` and
   `docs/working/`). Flag any discrepancies.
3. **Record limitations and deferred criteria** — identify any requirements or
   criteria that were not fully met, were deferred, or have known gaps. Record
   these explicitly.
4. **Maintain baseline consistency** — ensure every requirement still has at
   least one verification result (pass or documented gap), every test maps to a
   requirement, and no orphan test exists without a traceable requirement.
5. **Run the documentation completion gate** — assess whether the functional
   documentation (intended user guide, configuration reference, operations
   guide) is complete relative to the implemented behaviour. Report gate status
   as `passed`, `passed with gaps` (non-blocking), or `not passed`.

The analyst returns:

- **Gate status**: `passed`, `passed with gaps`, or `not passed`.
- **Evidence mapping**: traceability table linking tests → requirements → criteria.
- **Limitations list**: deferred items, known gaps, unimplemented criteria.
- **Documentation discrepancies**: list of files and items that need updating.
- **Baseline consistency**: confirmation or flagged inconsistencies.

**If gate status is `not passed`:** record the reason. Proceed to the reviewer
audit (step 8) regardless — a failing gate does not block review, but the report
will record the gate status.

### 8. Reviewer audit (after analyst gate)

After the analyst traceability gate completes, invoke the `reviewer` sub-agent
once for a final audit of all completed work. Provide the reviewer with:

- The full task graph (all prompts, verification criteria, and outcomes).
- The relevant specification/tests (docs tag, TESTS.md).
- The repository diff and commit history so the reviewer can inspect all
  changes, including already committed ones.
- The analyst traceability gate results (gate status, evidence mapping,
  limitations, discrepancies) so the reviewer can factor documentation gaps
  into findings.

The reviewer returns a review plan with findings (severity-classified) and an
implementation-ready task list for any actionable findings.

### 9. Assess findings and decide

Based on the reviewer's findings:

- **If any critical or blocking findings exist:** the conductor creates remedial
  tasks from the reviewer's task list (or refines them as needed), adds them to
  the graph, and executes them using the same execute/verify/commit workflow
  (steps 1–5), repeatedly computing and executing all eligible topological rounds
  until the remedial task graph is exhausted. Each remedial task is mechanically
  verified and every passing remedial task is committed. **If any remedial task
  is behavior-changing** (alters contractual behaviour, adds/removes features,
  changes documentation content), invoke the `analyst` sub-agent again to
  re-run the traceability gate (step 7) after all remedial rounds complete
  successfully. Then invoke the `reviewer` sub-agent again to verify the fixes.
  Repeat this remediation/review cycle only while critical or blocking findings remain.
  Critical/blocking findings **cannot** be ignored.
- **If only warnings or suggestions exist:** the conductor assesses each
  non-blocking finding. Suggestions may be accepted for implementation or
  recorded as advisory. Accepted suggestions are implemented as tasks and
  committed. Advisory suggestions are noted but not acted on. **Do not** invoke
  the reviewer or analyst again for suggestions alone — this prevents an unbounded loop.
  Warnings should be evaluated similarly: fix if warranted, otherwise record.

### 10. Functional outcome check

After the reviewer has no critical or blocking findings (and any accepted
suggestions have been implemented), the conductor checks the achieved functional
outcome against the original objective and high-level criteria.

Perform this check yourself (the conductor — do not delegate):

1. Compare the completed task results, test coverage, verification outcomes,
   and analyst traceability evidence against each high-level criterion
   from the objective brief.
2. For each criterion, determine: `pass` (fully met), `partial` (substantially
   met with known gaps), or `gap` (not met or no evidence).
3. Collect the evidence for each determination (test results, verification
   logs, analyst mapping, reviewer findings).
4. Record the overall functional-outcome result: `pass`, `partial`, or `gap`.

### 11. Final human outcome review

Before routing to the report phase, obtain a human outcome decision. This step
is a mandatory human gate — it is never silently auto-approved, even in
autonomous execution.

In **interactive mode**:

1. Present the results to the user: overall status (graph complete/aborted),
   analyst traceability gate status, reviewer findings resolution, functional-outcome
   result, and key evidence.
2. Ask the user to approve, reject, or accept with caveats.
3. Wait for the user's response.
4. Record the human decision.

In **autonomous mode**:

1. The human outcome review is **not auto-approved**. Compose a summary of the
   completed work, the analyst gate status, the reviewer audit outcome, and the
   functional-outcome result.
2. Present this to the user and request a final outcome decision: approve,
   reject, or accept with caveats.
3. Wait for the user's response.
4. Record the human decision.

**If the human rejects the outcome:** do not proceed to the report phase.
Either create new tasks for the reported issues (returning to step 1) or, if
the user indicates the work should stop, record the outcome as `rejected` and
proceed to the report phase with a `partial` or `aborted` status.

**If the human approves or accepts with caveats:** record the decision and
proceed to step 12.

### 12. Route to report on completion

When the graph is exhausted, the reviewer audit has passed (no critical or
blocking findings remain, and any accepted suggestions have been implemented),
and the final human outcome review is recorded, load the
[`conductor-report`](../conductor-report/SKILL.md) skill via the `skill` tool
to produce the final report. Include in the data passed to the report skill:

- All existing task and reviewer data.
- `analysis_mode` (guided or autonomous).
- Analyst traceability gate: status, evidence mapping, limitations list,
  documentation discrepancies.
- Functional-outcome check: per-criterion results, overall result, evidence.
- Final human outcome: decision, caveats (if any).

### Parallelism notes

- Sub-agents in a round run concurrently and their results return together.
- Verification happens per task **after each round returns**, not the instant an individual sub-agent finishes.
- Verify every task; never batch-verify loosely.
