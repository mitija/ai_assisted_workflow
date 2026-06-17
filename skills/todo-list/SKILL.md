---
name: todo-list
description: Creates a structured TODO list for entry-level programmers using a test-driven development (TDD) approach. Each implementation task is split into TDxx.1 (Red phase — write failing tests) and TDxx.2 (Green phase — implement to pass tests). A dedicated Review & Commit TD is added after each completed feature/use case. Outputs to TODOxx.md files.
allowed-tools: Read, Grep, Glob, Bash, Write
---

# TODO List Generator for Entry-Level Programmers

This skill creates clear, actionable TODO lists designed for entry-level programmers using a test-driven development (TDD) approach. Each implementation task is split into two phases: a **Red phase** where the programmer writes tests that fail, and a **Green phase** where the programmer writes the implementation to make the tests pass. After each completed feature or use case, a dedicated **Review & Commit** TD is added as a human checkpoint to review changes and commit to git.

## When to use this skill

- Breaking down a feature or bug fix into actionable steps
- Creating onboarding tasks for junior developers
- Documenting implementation steps for complex features
- Creating step-by-step guides for code changes
- Planning work that will be executed by entry-level programmers

## Instructions

### 1. Understand the task

Ask the user what they want to accomplish. Clarify:
- What is the overall goal or feature?
- What files or areas of the codebase are involved?
- Are there any constraints or requirements?
- What is the expected outcome?
- What test framework and runner is used? (e.g., Jest, Vitest, pytest, etc.)
- Where do tests live in the project? (e.g., `__tests__/`, `tests/`, co-located with source)

### 2. Analyze the codebase (if applicable)

- Use Glob to find relevant files
- Use Read to understand existing code patterns
- Use Grep to find related implementations
- Identify dependencies and integration points
- Locate existing test files to understand test conventions, patterns, and file structure
- Identify the test runner command (e.g., from `package.json` scripts, `Makefile`, etc.)

### 3. Break down into atomic tasks

**CRITICAL**: Each task must be simple enough for an entry-level programmer and must follow the TDD Red/Green cycle. Apply these rules:

1. **Single Responsibility**: Each TODO does ONE thing
2. **No Ambiguity**: Instructions must be explicit and complete
3. **Reasonable Scope**: If a task takes more than 30-60 minutes, split it
4. **Clear Context**: Explain WHY, not just WHAT
5. **Red Before Green**: Every implementation TODO is split into TDxx.1 (Red phase — write failing tests) and TDxx.2 (Green phase — implement to pass). TDxx.1 must be completed before starting TDxx.2.
6. **Review & Commit After Each Feature**: When all TDs for a feature or use case are complete, add a dedicated Review & Commit TD (a full TDxx with its own number). This is a human checkpoint — the programmer must review all changes for the feature, then commit to git with a meaningful commit message. This TD has no Red/Green phases; it only has review and commit steps. If a use case spans multiple TDs (e.g., TD01–TD03), the Review & Commit TD comes after them (e.g., TD04). If a use case is a single TD, the Review & Commit TD follows immediately after it.
7. **Never Commit Without Explicit Permission**: Never run `git commit` or any git write operation unless the user explicitly asks or approves. Review & Commit TDs describe what the programmer should do — the agent must not execute commits autonomously. Always ask the user before committing.
8. **One TD at a Time**: When executing the TODO list, process only one TD at a time. After completing a TD (or its sub-phases), stop and ask the user for confirmation before moving on to the next TD. Do not batch or skip ahead.
9. **Red Phase Skipped When Not Applicable**: Some TDs cannot have a meaningful failing test in the Red phase. For example, creating a new module/file from scratch — there is nothing to test against yet because the module does not exist. In these cases, still create the TDxx.1 section but mark it as **(Skipped)** and provide a clear reason why. The TDxx.2 (Green phase) proceeds as normal.

**Complexity Guidelines**:
- If a task requires understanding multiple systems, split it
- If a task has multiple steps, each step becomes a separate TODO
- If a task requires decision-making, provide the decision criteria
- **If a task requires complex logic, explain the logic in technical terms**

### 4. Determine the output file number

Before writing the TODO file:

1. Use Glob to find existing TODO files: `TODO*.md`
2. Identify the highest number used (e.g., if TODO03.md exists, next is TODO04.md)
3. If no TODO files exist, start with TODO00.md

```bash
# Check for existing TODO files
ls TODO*.md 2>/dev/null | sort -V | tail -1
```

### 5. Create the TODO list

**MANDATORY FORMAT**:

```markdown
# TODO List: [Brief Description of Goal]

**Created**: [Date]
**Target Audience**: Entry-Level Programmer
**Estimated Tasks**: [Number of TODOs]

---

## Overview

[2-3 sentences explaining the overall goal and context. What will be accomplished when all TODOs are complete?]

## Prerequisites

- [List any setup, access, or knowledge required before starting]
- [Include relevant documentation links if applicable]

---

## TD01: [Clear, Action-Oriented Title]

[One sentence describing what this task accomplishes]

### TD01.1: Red Phase — Write Failing Tests

**Goal**: Write tests that define the expected behavior. All tests MUST fail at this stage.

#### Steps

1. [Where to create/modify the test file - be explicit about file paths]
2. [What test cases to write - describe each test's purpose and expected behavior]
3. [Continue with numbered steps...]

#### Success Criteria

- [ ] [Test file exists at the correct location]
- [ ] [Test case for expected behavior #1 is written]
- [ ] [Test case for expected behavior #2 is written]
- [ ] [Continue as needed...]

#### Verification

**Run the tests and confirm they FAIL:**

1. [Exact command to run the tests, e.g., `npm test -- --grep "email validation"`]
2. **Expected**: All new tests fail (red) — this confirms the tests are correctly asserting behavior that does not exist yet
3. If any test passes at this stage, it means the test is not testing new behavior — review and fix it

---

### TD01.2: Green Phase — Implement to Pass Tests

**Goal**: Write the minimum implementation to make all TD01.1 tests pass.

#### Steps

1. [First specific action - be explicit about file paths, function names, etc.]
2. [Second specific action]
3. [Continue with numbered steps...]

#### Success Criteria

- [ ] [Specific, verifiable outcome #1]
- [ ] [Specific, verifiable outcome #2]
- [ ] [Continue as needed...]

#### Verification

**Run the tests and confirm they PASS:**

1. [Exact command to run the tests]
2. **Expected**: All tests from TD01.1 now pass (green)
3. [Any additional manual checks if applicable]

---

## TD02: [Next Task Title]

[Continue with same TDxx.1 / TDxx.2 structure...]

---

## TDxx: [Task Where Red Phase Is Not Applicable]

[One sentence describing what this task accomplishes]

### TDxx.1: Red Phase — (Skipped)

**Skipped**: [Reason why a failing test is not possible at this stage. E.g., "This TD creates a new module from scratch. There is no existing code to test against, so a failing test cannot be written before the module exists."]

---

### TDxx.2: Green Phase — Implement [Task]

[Proceed with normal Green phase structure...]

---

## TDxx: Review & Commit — [Feature/Use Case Name]

*(Insert this TD after the final TD of each completed feature or use case. It gets its own TD number in sequence.)*

**Goal**: Human review of all changes for this feature, then commit to git. **This is a human checkpoint — no Red/Green phases. Never commit without the user's explicit permission.**

### Steps

1. **Review all changes** made during this feature (covering TD[first]–TD[last]):
   - Run `git diff` to see all uncommitted changes
   - Verify the changes match what was intended
   - Check that no unrelated files were modified
   - Ensure no debug code, console logs, or temporary changes remain

2. **Run the full test suite** to confirm nothing is broken:
   - [Exact command to run all tests, e.g., `npm test`]
   - **Expected**: All tests pass, including pre-existing tests

3. **Ask the user for permission to commit.** Only proceed if they approve.

4. **Stage and commit** the changes (only after user approval):
   - Stage the relevant files: `git add [list files changed in TD[first]–TD[last]]`
   - Commit with a descriptive message: `git commit -m "[Feature]: [brief description of what was implemented]"`

### Success Criteria

- [ ] All changes have been reviewed by the programmer
- [ ] No unintended changes, debug code, or temporary modifications remain
- [ ] Full test suite passes
- [ ] Changes are committed to git with a meaningful commit message

---

## Completion Checklist

After completing all TODOs:

- [ ] All tasks marked complete (both .1 and .2 for each implementation TD)
- [ ] All .1 phases confirmed tests fail before implementation
- [ ] All .2 phases confirmed tests pass after implementation
- [ ] All Review & Commit TDs completed — changes reviewed and committed to git
- [ ] Full test suite passes: [command to run all tests]
- [ ] Code compiles/runs without errors
- [ ] [Any additional final checks]
```

### 6. Writing Guidelines for Entry-Level Programmers

**DO**:
- Use simple, clear language
- Provide exact file paths: `src/components/Button.tsx` not "the button component"
- Explain technical terms on first use
- Include example inputs and outputs
- Reference existing similar code in the codebase as examples
- Describe WHAT to do, not HOW to code it (let the programmer write the code)
- Provide exact test runner commands for each phase verification
- In the Red phase, describe test cases in terms of inputs and expected outputs
- In the Green phase, reference the failing tests as the specification to implement against
- Reference existing test files in the codebase as examples of test patterns and conventions

**DON'T**:
- Assume knowledge of the codebase
- Use jargon without explanation
- Give vague instructions like "update the logic"
- Skip steps that seem "obvious"
- Combine multiple distinct changes into one TODO
- **Write actual code in the TODO** - describe the task, let the programmer implement it
- Include code snippets unless showing existing code to locate/modify
- Skip the Red phase without marking it as (Skipped) with a reason — if a Red phase is not applicable, it must still appear as TDxx.1 with a (Skipped) label and explanation
- Write Green phase steps that go beyond what is needed to pass the tests

### 7. Logic Detail Guidelines

**IMPORTANT: Never write code (including pseudo code) in the TODO list.**

When a task involves complex logic, explain the logic in technical terms so the programmer understands WHAT needs to happen and WHY, without being given the code to copy.

**When to include logic details**:
- Complex algorithms with multiple branching conditions
- Recursive logic or state machines
- Business rules with edge cases
- Data transformations with specific ordering or dependencies
- Flow control that involves multiple systems or components

**When logic details are NOT needed**:
- Standard CRUD operations
- Simple API calls and data fetching
- Basic form validation
- Straightforward UI updates
- Simple database queries

**How to write logic details**:
1. Describe the inputs, expected outputs, and constraints
2. Explain the conditions and branching decisions in technical terms
3. Identify edge cases and how they should be handled
4. Reference relevant data structures, types, or interfaces
5. Point to similar patterns in the codebase when available

**Example**:

```markdown
### Logic Detail

This function must authenticate the user and authorize their access. It should first verify the user's credentials against the stored hash, then check their role against the resource's required permission level. If both checks pass, fetch the requested resource and return it. If authentication fails, return a 401 error. If authorization fails, return a 403 error. Consider the edge case where the user's session has expired mid-request — in that case, treat it as an authentication failure.
```

### 8. Example TODO Entry

```markdown
## TD03: Add validation for email field in signup form

Add client-side email validation to the signup form to prevent invalid email submissions.

### TD03.1: Red Phase — Write Failing Tests

**Goal**: Write tests that define the expected email validation behavior. All tests MUST fail at this stage.

#### Steps

1. Create a new test file at `src/components/__tests__/SignupForm.email.test.tsx`

2. Reference the existing test pattern in `src/components/__tests__/LoginForm.test.tsx` for test structure and conventions

3. Write the following test cases:
   - **Invalid email format**: When the user types "notanemail" into the email field, an error message "Please enter a valid email address" should appear
   - **Missing @ symbol**: When the user types "userexample.com", the same error message should appear
   - **Valid email clears error**: When the user corrects the email to "test@example.com", the error message should disappear
   - **Valid email allows submission**: When a valid email is entered, the form should submit without errors
   - **Empty email on blur**: When the user leaves the email field empty and moves focus away, an error should appear

#### Success Criteria

- [ ] Test file exists at `src/components/__tests__/SignupForm.email.test.tsx`
- [ ] All five test cases described above are written
- [ ] Tests follow the same conventions as `LoginForm.test.tsx`

#### Verification

**Run the tests and confirm they FAIL:**

1. Run: `npm test -- --grep "email validation"`
2. **Expected**: All 5 new tests fail (red) — this confirms they are testing behavior that does not exist yet
3. If any test passes, review it — it is not testing new behavior

---

### TD03.2: Green Phase — Implement to Pass Tests

**Goal**: Add email validation to the signup form so all TD03.1 tests pass.

#### Steps

1. Open the file `src/components/SignupForm.tsx`

2. Locate the email input field (approximately line 34) — look for the input with `type="email"`

3. Create a new validation function above the component (around line 10) that:
   - Takes an email string as input
   - Uses a regular expression to validate email format
   - Returns true if valid, false if invalid

4. Add a new state variable for storing the email error message, placed after the existing state declarations (around line 18)

5. Modify the email input's onChange handler to:
   - Call the validation function when the value changes
   - Set the error message if validation fails
   - Clear the error message if validation passes

6. Add an error message display element below the email input that:
   - Only renders when there is an error
   - Uses the `error-text` CSS class for styling

**Reference**: See the password validation in `src/components/LoginForm.tsx:25-40` for a similar implementation pattern

#### Success Criteria

- [ ] Validation function exists and correctly validates email format
- [ ] Error state is properly managed with useState
- [ ] Error message displays when email is invalid
- [ ] Error message clears when email becomes valid
- [ ] Form still submits when email is valid

#### Verification

**Run the tests and confirm they PASS:**

1. Run: `npm test -- --grep "email validation"`
2. **Expected**: All 5 tests from TD03.1 now pass (green)
3. Run the full test suite: `npm test`
4. **Expected**: No existing tests have been broken

---

## TD04: Review & Commit — Signup Email Validation

**Goal**: Review all email validation changes (TD03) and commit to git. **This is a human checkpoint — no Red/Green phases.**

### Steps

1. **Review all changes** made for email validation (TD03):
   - Run `git diff` to see all uncommitted changes
   - Verify that only the signup form and its test file were modified/created
   - Ensure no debug code or temporary changes remain

2. **Run the full test suite**:
   - Run: `npm test`
   - **Expected**: All tests pass

3. **Stage and commit**:
   - `git add src/components/SignupForm.tsx src/components/__tests__/SignupForm.email.test.tsx`
   - `git commit -m "feat(signup): add client-side email validation to signup form"`

### Success Criteria

- [ ] All changes reviewed — no unintended modifications
- [ ] Full test suite passes
- [ ] Changes committed to git with a descriptive commit message
```

### 9. Save the TODO file

After creating the content:

1. Determine the correct filename (TODO00.md, TODO01.md, etc.)
2. Write the file to the current working directory
3. Confirm the file was created successfully

```bash
# Verify the file exists and show its location
ls -la TODOxx.md
```

### 10. Summary Output

After saving, provide the user with:

```
TODO list created: TODOxx.md

Summary:
- Total tasks: [N]
- Complexity: [Simple/Moderate/Complex]
- Estimated scope: [Brief description]
- Test framework: [e.g., Jest, Vitest, pytest]
- Test command: [e.g., npm test, pytest]

Tasks created:
- TD01: [Title] (TD01.1 Red → TD01.2 Green)
- TD02: [Title] (TD02.1 Red → TD02.2 Green)
- TD03: Review & Commit — [Feature/Use Case Name]
- [Continue...]

Next steps: Start with TD01.1 — write the failing tests first, then move to TD01.2 to implement.
Note: TDs will be executed one at a time. I will ask for your confirmation before moving to the next TD.
```

## Handling Complex Tasks

When encountering tasks too complex for entry-level programmers:

### Option 1: Split into smaller tasks (PREFERRED)
```
Original: "Implement user authentication"

Split into (each TD has its own Red/Green phases, with Review & Commit TDs after each use case):
- TD01: Create User model with email and password fields
- TD02: Add password hashing utility function
- TD03: Review & Commit — User model and password hashing
- TD04: Create login API endpoint skeleton
- TD05: Implement login validation logic
- TD06: Review & Commit — Login feature
- TD07: Create session/token generation
- TD08: Create logout API endpoint
- TD09: Review & Commit — Session management and logout
```

### Option 2: Reference similar existing code (PREFERRED)
```
"This follows the same pattern as the existing ProductService.
See `src/services/ProductService.ts:45-67` for reference."
```

### Option 3: Provide logic details (when logic is complex)

When the task involves complex logic that cannot be simplified by splitting or referencing existing code, explain the logic in technical terms.

```
Original: "Implement retry with exponential backoff"

Logic detail:
"The function should attempt the operation up to a configurable maximum number
of retries. After each failed attempt, it should wait before retrying, with the
delay increasing exponentially (base delay multiplied by 2 raised to the attempt
number). If the operation succeeds at any point, return the result immediately.
If all retries are exhausted, return a failure."
```

## Quality Checklist

Before finalizing the TODO list, verify:

- [ ] Each task has a clear, action-oriented title
- [ ] Every implementation task is split into TDxx.1 (Red) and TDxx.2 (Green)
- [ ] TDxx.1 describes specific test cases with expected inputs and outputs
- [ ] TDxx.1 includes the exact command to run tests and confirm failure
- [ ] TDxx.2 steps target only what is needed to pass the TDxx.1 tests
- [ ] TDxx.2 includes the exact command to run tests and confirm they pass
- [ ] All file paths are explicit and accurate (including test file paths)
- [ ] Steps are numbered and sequential within each phase
- [ ] Steps describe WHAT to do, not the actual code to write
- [ ] Success criteria are specific and verifiable for each phase
- [ ] No task requires advanced knowledge without explanation
- [ ] Complex tasks are split into smaller tasks, with logic details provided where needed
- [ ] Tasks can be completed independently (where possible)
- [ ] A Review & Commit TD follows the final TD of each feature or use case
- [ ] Review & Commit TDs list which preceding TDs they cover and which files to stage
- [ ] Review & Commit TDs explicitly state that user permission is required before committing
- [ ] TDs where the Red phase is not applicable have TDxx.1 marked as (Skipped) with a reason
- [ ] File is saved with correct TODOxx.md naming
