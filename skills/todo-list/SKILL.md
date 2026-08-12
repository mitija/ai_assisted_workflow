---
name: todo-list
description: Creates self-contained, bounded-autonomy TODO lists for entry-level programmers using TDD Red, Green, and Commit phases. Outputs to TODOxx.md files.
allowed-tools: Read, Grep, Glob, Bash, Write
---

# TODO List Generator for Entry-Level Programmers

Create atomic, self-contained TODOs for entry-level programmers. Each
implementation TODO uses TDD discipline: Red establishes the missing or
insufficient behavior, Green supplies the smallest compliant implementation,
and Commit records the completed TODO through the `committer` agent.

## Instructions

### 1. Understand and inspect the task

Clarify or inspect the goal, expected outcome, relevant scope and touchpoints,
fixed constraints, test framework, test locations, and authoritative commands.
Read the repository guidance and relevant existing code/tests. Do not invent a
final file list or internal mechanism when the repository has not fixed it.

### 2. Define atomic tasks

Each TODO must be small enough for an entry-level programmer and contain:

- **Intent/outcome**: what behavior or artifact will exist when complete and why.
- **Scope/touchpoints**: known files, symbols, interfaces, tests, or
  documentation; these are starting points, not an invented exhaustive list.
- **Context**: applicable conventions, existing patterns, dependencies, and
  business rules.
- **Fixed constraints**: requirements, public interfaces, safety rules,
  repository conventions, or user decisions. State why each exact detail is fixed.
- **Semantic success criteria**: observable behavior or artifact quality, not a
  prescribed implementation shape.
- **Required evidence**: authoritative commands, tests, inspection results, or
  manual checks and the expected evidence.

Leave wording, internal design, final file set, and implementation mechanism
open unless fixed by a traced requirement, interface, repository convention,
safety constraint, or user decision. Do not defer genuine product or design
ambiguity to the executor; resolve it or mark it as a blocker first.

Every implementation TODO has these phases:

1. **TDxx.1 Red** — write or extend tests that demonstrate the expected
   behavior is missing or insufficient for the expected reason. A test that
   already passes may be retained when it covers existing behavior, but identify
   the unproven behavior and add a failing assertion only where meaningful. If
   no meaningful pre-implementation test is possible, mark Red **(Skipped)** and
   explain why.
2. **TDxx.2 Green** — implement the outcome with the minimum compliant change.
   Do not prescribe functions, state variables, regexes, line placement, CSS,
   prose, or other mechanics unless a fixed constraint requires them.
3. **TDxx.3 Commit** — after evidence passes, delegate a scoped commit to the
   `committer` agent. The commit message may be chosen by that agent unless a
   repository or user contract fixes it.

### 3. Determine the output file

Use Glob to find existing `TODO*.md` files, identify the highest number, and
choose the next number (or `TODO00.md` if none exist). An authoritative
repository command may remain exact when it is the command being documented.

### 4. Required TODO format

```markdown
# TODO List: [Brief Description of Goal]

**Created**: [Date]
**Target Audience**: Entry-Level Programmer
**Estimated Tasks**: [Number]

## Overview
[Goal, context, and completion outcome]

## Prerequisites
- [Required access, context, or commands]

## TD01: [Outcome-oriented title]
[Intent, why it matters, and bounded scope/touchpoints]

### Fixed constraints
- [Constraint and why it is fixed, or "None beyond repository guidance"]

### TD01.1: Red Phase — Establish the behavior gap
**Outcome**: [Tests or evidence define the missing/insufficient behavior.]

**Context and touchpoints**: [Relevant existing tests/code and conventions.]

**Steps**:
1. [Add or extend tests for the behavior and expected result.]
2. [Use the existing test pattern; choose the test location unless fixed above.]

**Success criteria**:
- [ ] [Semantic assertion is present for each required behavior.]
- [ ] [The new behavior fails before implementation, or existing passing
      regression coverage is explicitly identified.]

**Evidence**: Run `[exact authoritative command]`. Record the result and explain
why it demonstrates the behavior gap without relying on accidental wording.

### TD01.2: Green Phase — Implement the outcome
**Outcome**: [The required behavior is implemented without unnecessary scope.]

**Steps**:
1. [Use the context and Red evidence to implement the outcome.]
2. [Preserve fixed interfaces, conventions, and unrelated behavior.]

**Success criteria**:
- [ ] [Observable behavior and relevant regressions are correct.]
- [ ] [No extra mechanism, file, or requirement was introduced without a reason.]

**Evidence**: Run `[exact authoritative command]` and required checks. Map the
output to each success criterion; literal presence/absence is not semantic proof
unless exact text is the contract.

### TD01.3: Commit Phase
**Outcome**: The verified TD changes are committed as one focused unit.

**Steps**:
1. Confirm the Green evidence and inspect the scoped diff.
2. Delegate the commit to `committer`, providing actual changed files and an
   outcome-oriented message unless a message is contractually fixed.

**Success criteria**:
- [ ] Required evidence passes and no unintended changes remain.
- [ ] `committer` creates the focused commit.
```

### 5. Writing guidance

**Do**:

- Use clear language and name known paths/symbols as touchpoints.
- Explain why a constraint is fixed and trace it to a requirement, interface,
  convention, safety rule, or user decision.
- Describe inputs, outputs, edge cases, and evidence for complex behavior.
- Keep tasks atomic, self-contained, TDD-oriented, and executable by a less
  capable model.
- Use exact test/build/lint commands when they are authoritative commands.

**Do not**:

- Prescribe an implementation recipe when only an outcome is fixed.
- Invent exact final file lists, regexes, state variables, line placement,
  styling, prose, or commit text.
- Require every Red test to fail when some behavior already exists.
- Use vague tasks or defer a genuine decision to the executor.
- Add code or pseudocode instead of describing required behavior.

### 6. Final checklist and output

Before writing the file, confirm every TODO has an outcome, scope/touchpoints,
context, fixed constraints with reasons, semantic acceptance criteria, and
required evidence. Confirm Red/Green/Commit phases are present or Red is marked
Skipped with a reason. Confirm no control depends on accidental literal wording.

After saving, report the path, task count, test framework/commands, and the
Red -> Green -> Commit sequence. Do not commit the TODO file unless explicitly
requested by the user or surrounding workflow.
