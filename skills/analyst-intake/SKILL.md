---
name: analyst-intake
description: Phase 1 of the analyst workflow. Establishes the objective brief via a high-level Q&A with the human. The analysis mode (autonomous or guided) is an explicit independent value selected and recorded here — distinct from conductor interaction style or implementation autonomy. Produces the confirmed objective brief and determines whether sufficient analysis already exists or full discovery is needed.
allowed-tools: Read, Grep, Glob, Edit, Write, Question
---

# Analyst Intake Skill

This is Phase 1 of the analyst workflow. Load it at the start of every
analysis engagement.

## Purpose

Establish the human's intent at a high level — not the detailed specification.
The human must confirm the objective baseline before detailed analysis proceeds,
in both autonomous and guided analysis modes.

## What to produce

The objective brief, containing where applicable:

- **Objective** — what problem is being solved and what the intended outcome is
- **Problem statement** — why the current situation is unsatisfactory
- **Beneficiaries or intended users** — who the system serves
- **High-level success criteria** — how the human will know the outcome is
  achieved (in their terms, not formal requirements)
- **Constraints** — important limitations: technology, budget, time, regulatory,
  organisational
- **Scope boundaries** — what is in scope and what is not
- **Explicit exclusions** — things deliberately not being addressed
- **Known integrations** — other systems, platforms, or services the solution
  must interact with
- **Assumptions already supplied by the human** — pre-existing beliefs or
  conditions taken as true
- **Selected analysis mode** — autonomous or guided (analysis governance;
  distinct from conductor interaction style or implementation autonomy)

## Intake process

### 1. Determine what already exists

Before asking questions, inspect the project:

- Read `project_context.yaml` for project metadata, source paths, and commands.
- Check for existing docs, specs, requirements, or analysis files in the
  project workspace.
- Check the git log for recent work and context.
- Determine whether sufficient analysis already exists — if yes, skip the
  full Q&A and proceed to confirm the existing baseline.

### 2. Conduct the initial Q&A

Ask only high-level, functional questions. Do not begin by asking the human to
define:

- detailed entities or fields
- state transitions
- exception handling
- database design
- service boundaries
- libraries or frameworks
- infrastructure details
- routine technical choices

Keep questions at the level of:

- What problem are you solving?
- Who is it for?
- What does success look like?
- What are the important constraints?
- What is explicitly out of scope?
- What existing systems must this work with?
- **What analysis mode do you want? (autonomous / guided)

**Ask one question at a time.** Include your recommended answer where
reasonable. Wait for the answer before asking the next question.

### 3. Produce the objective brief

Write the objective brief to `docs/working/objective-brief.md` (create the
directory if it does not exist). Update it incrementally as each decision is
confirmed.

The brief is a concise narrative, not a template. It should be clear enough
that someone who did not participate in the Q&A understands the intended
outcome.

### 4. Confirm baseline with the human

Present the completed objective brief to the human for confirmation.

This confirmation is **not** approval of a detailed specification. It confirms
that you have understood the intended outcome.

If the human disagrees or corrects, update the brief and re-present until
confirmed.

### 5. Record analysis mode and proceed

Record the selected analysis mode in the objective brief. This is an
independent value governing when the human validates the functional
interpretation; it is distinct from implementation autonomy or the
conductor's interaction style.

- If **autonomous analysis**: proceed to Phase 2 (load `analyst-discovery`).
  The human has confirmed the objective brief and will be asked immediately
  for any Class C or D decisions during discovery.
- If **guided analysis**: note that a functional validation package will be
  required after Phase 2. Proceed to Phase 2. Class C decisions that do not
  block continued analysis are deferred to the validation package; Class D
  decisions stop and ask immediately regardless of mode.

## Output

- `docs/working/objective-brief.md` — confirmed by the human
- `analysis_mode` field: `autonomous` or `guided` — explicit independent value
- Assessment of whether existing analysis suffices or full discovery is needed

## Quality checklist

- [ ] Objective brief captures the human's intent in their own terms
- [ ] High-level success criteria are in the human's language, not formal
      requirement statements
- [ ] Explicit exclusions and scope boundaries are documented
- [ ] Selected analysis mode is recorded (autonomous or guided)
- [ ] The human confirmed the baseline
- [ ] No detailed technical questions were asked during intake