# The Test Suite

Each test scenario uses a **state-table format**:

- **Setup** — initial database state, plain English.
- **State table** — one row per step. Columns name the domain-specific quantities tracked. Final column always `Notes`.
- **Per-step expectations** — Given/When/Then prose for each row.
- **Cross-cutting expectations** — invariants that hold across all steps.

A worked example is in the [sample test scenario](appendices/sample-test-scenario.md).

If the spec and tests disagree, **the tests win** and the spec is corrected before the next tag.

## Navigation

- [Workflow index](README.md)
- [Landing page](../AI_assisted_development_workflow.md)
- [Sample Test Scenario](appendices/sample-test-scenario.md)