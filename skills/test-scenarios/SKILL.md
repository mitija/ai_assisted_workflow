---
name: test-scenarios
description: Write specification-level, customer-facing test scenarios for a spec-driven project. Use when authoring or reviewing <epic>_TESTS.md documents — the contractual end-to-end scenarios that accompany a functional specification. NOT for developer unit/integration tests written during implementation.
allowed-tools: Read, Grep, Glob, Edit, Write
---

# Specification-Level Test Scenarios

These test scenarios are **part of the specification and are contractual**. They
are written in a human-readable format and presented to the customer — either
functional staff or, for highly technical work, the customer's IT team — for
sign-off. They describe *what the system must do*, independently of how it is
implemented.

This skill covers ONLY these specification-level scenarios. Additional tests a
developer writes during implementation to strengthen the build (unit tests,
internal integration tests, regression guards) are **out of scope here** — they
are not contractual and are not presented to the customer.

## Core principles

1. **Contractual.** If a behaviour is not covered by a scenario (or the spec), it
   is not required. Together with the spec, these scenarios are the acceptance
   criteria. Tests win over prose: if the spec and a scenario disagree, the
   scenario is authoritative and the spec is corrected.
2. **Human-readable, not code.** Write for a functional reader. Use real-world
   business language, named example data, and concrete numbers. No Python, no ORM
   calls, no framework internals. The developer translates each scenario into
   automated tests later.
3. **Concrete, not abstract.** Every scenario uses specific, named master data and
   specific quantities/states so there is exactly one correct outcome. "User
   updates the quantity" is not a scenario; "Update Widget-A qty on SO01 from
   10 -> 7" is.
4. **Deterministic and self-contained.** Each scenario states its own
   pre-conditions, the exact steps, and the exact expected result. A reader (or an
   LLM) must reach the same pass/fail verdict every time.
5. **Traceable.** Each scenario references the spec section(s) it covers, so
   coverage can be checked both ways: every contractual rule has a scenario, every
   scenario maps to the spec.

## Document structure

A test-scenarios document (`<epic>_TESTS.md`) has three parts: a header, a
shared Conventions section, then the scenarios grouped into Categories.

### 1. Header

```markdown
# <Epic> — Detailed Test Cases

**Prepared by:** <team/company>
**Date:** <month year>
**Version:** <n.n>
**Related spec:** `<EPIC>_FUNCTIONAL_SPEC.md`
```

### 2. Conventions (shared by all scenarios)

Factor everything common out of the individual scenarios so each scenario stays
short. Typical subsections:

- **Standing master data** — a table of the named entities assumed to exist
  before any test runs (products, partners, users/roles, warehouses, customers).
  Give them memorable names and reuse them everywhere.
- **Notation** — define symbols and shorthand used in tables (e.g. `->` means
  "changes to"; "Before"/"After" = state immediately before/after the step;
  acronyms used in column headers).
- **Global pass criteria** — the conditions that must hold for *any* scenario to
  pass, so they need not be repeated per scenario.
- **Trigger mechanisms** (if applicable) — when the same behaviour can be invoked
  from several entry points (UI action, API call, scheduled job, n8n/webhook),
  list them and state which scenarios must be run for each. Use a per-scenario
  "Trigger variant" note rather than duplicating whole scenarios.

### 3. Scenarios, grouped into Categories

Group scenarios under `## Category X — <theme>` headings (e.g. baseline/no
regression, quantity increase, quantity decrease, cancellation, edge cases,
content validation). Number scenarios sequentially across the whole document
(`T-01`, `T-02`, ...) so they can be referenced stably even across categories.

## Scenario format

The proven, customer-facing format uses tables. Each scenario has:

```markdown
### T-NN — <one-line description of the scenario>

**Covers:** Spec §x.y (and an overview row id if you keep an overview doc)
**Purpose:** <optional — one sentence on what this scenario proves>

#### Pre-conditions

| Element | Value |
|---|---|
| <entity> | <exact starting state, qty, status, relationships> |
| ...     | ... |

#### Steps

| Step | Action | Before | After |
|---|---|---|---|
| 1 | <the action performed, with exact values> | <relevant state before> | <relevant state after> |
| 2 | <observe / next action> | ... | ... |

#### Expected result

| Field | Expected value |
|---|---|
| <what to check> | <the single correct outcome> |
| ...            | ... |

#### Trigger variant — <name>   (optional)

<short note: re-run substituting this trigger; state any differences, or
"all pre-conditions, steps and expected results are identical">
```

Guidance:

- **Pre-conditions** pin down the full starting world for this one scenario: which
  records exist, their quantities/statuses, their relationships, and any relevant
  stock/config. Use the standing master data by name.
- **Steps** are observable actions and observations, not implementation. The
  `Before`/`After` columns let a reader verify the state transition at a glance.
  Include intermediate "compute"/"check" rows when they make the logic auditable
  (e.g. "Total demand recalculated | 11 | 14").
- **Expected result** lists each thing that must be true, each with exactly one
  correct value. Quote exact user-visible strings in backticks when wording is
  contractual (messages, summaries, statuses). Be explicit about what must
  **not** happen ("Activity created: **No**", "no spurious additional activities").
- Always cover the negative/no-op cases (nothing should happen) and the
  boundary/threshold cases, not just the happy path.

## Alternative format: state-table scenarios

When a single scenario walks a record through **many steps while tracking several
evolving quantities**, a state-table format is clearer than repeated Before/After
tables. Use one row per step, one column per tracked quantity, a final `Notes`
column, then add per-step Given/When/Then prose and a list of cross-cutting
invariants that must hold across all steps. Example shape:

```markdown
#### State table

| # | Action | QtyA | QtyB | Status | Notes |
|---|--------|------|------|--------|-------|
| 1 | <action> | ... | ... | ... | <why> |

#### Per-step expectations (Step N)
- **Given** <state>  **When** <trigger>  **Then** <result>

#### Cross-cutting expectations
- <invariant that must hold at every step>
```

Pick whichever format makes the contract clearest for the scenario at hand; do
not mix both within a single scenario.

## Writing checklist

Before presenting scenarios to the customer, verify:

- [ ] Every contractual rule in the spec is covered by at least one scenario.
- [ ] Every scenario maps back to a spec section (`Covers:`).
- [ ] Standing master data and notation are defined once and reused.
- [ ] Each scenario is self-contained: full pre-conditions, exact steps, exact
      expected result.
- [ ] All numbers/states are concrete; outcomes are unambiguous.
- [ ] Negative cases (no activity / no change) and boundary cases are included.
- [ ] Contractual user-visible text is quoted exactly.
- [ ] All entry points (triggers) are covered, via variants rather than duplication.
- [ ] No implementation/code detail leaks into the scenarios.
- [ ] A non-technical reader could follow it; a developer could implement against
      it with no design decisions left to make.
