---
name: analyst-review
description: Phase 3 of the analyst workflow. Performs the requirements quality gate — checking every requirement for necessity, clarity, singularity, consistency, feasibility, testability, traceability, implementation independence, priority, visible assumptions, and scope. In guided mode, produces the functional validation package for human review and propagates all feedback across affected artefacts.
allowed-tools: Read, Grep, Glob, Edit, Write, Question
---

# Analyst Review Skill

This is Phase 3 of the analyst workflow. Load it after the discovery phase
completes.

## Purpose

Perform a structured quality gate on the complete requirements set. In guided
mode, produce a concise functional validation package for human review and
propagate feedback across all affected artefacts. There is no separate
requirements-reviewer agent — this skill implements the quality gate.

## Quality gate

### Per-requirement checklist

Check every requirement, business rule, and detailed success criterion against
these criteria:

| Criterion | What to check |
|-----------|---------------|
| **Necessity** | Does it support an objective, constraint, or risk control? If not, remove or flag as optional. |
| **Clarity** | Is the statement unambiguous? Could two readers interpret it differently? |
| **Singularity** | Does it address exactly one behaviour? Split compound statements. |
| **Consistency** | Does it contradict any other requirement, business rule, or artefact? |
| **Feasibility** | Is it achievable within known constraints (technology, budget, time)? |
| **Testability** | Can a pass/fail verdict be determined unambiguously? |
| **Traceability** | Is it linked to its source objective and to a detailed success criterion? |
| **Implementation independence** | Does it specify *what*, not *how*? If it prescribes internal design, rephrase. |
| **Priority** | Is relative importance clear (essential / important / nice-to-have)? |
| **Visible assumptions** | Are all assumptions on which the requirement depends explicit? |
| **Scope** | Is it within the agreed boundaries? If not, flag as scope creep. |

### Whole-set checklist

Check the requirements set as a whole:

| Criterion | What to check |
|-----------|---------------|
| **Sufficiently complete** | Are there any obvious gaps in coverage? Completeness does not mean every technical detail — it means remaining implementation freedom can safely be exercised by implementation agents. |
| **Internally consistent** | No contradictions between any pair of artefacts. |
| **Bounded** | Scope is clearly defined and no unapproved expansion has occurred. |
| **Risk-aware** | Important risks are identified and controls are reflected in requirements. |
| **Proportionate** | The level of detail matches project complexity and risk. |
| **Traceable to objective** | Every requirement traces back to the functional objective. |
| **Explicit about unresolved matters** | Open decisions, assumptions, and risks are recorded, not hidden. |

### Cross-artefact consistency check

Detect and flag contradictions between artefacts:

- A business rule differing from the user guide
- A wireframe exposing an action forbidden by the requirements
- A success criterion testing behaviour absent from the specification
- A configuration option documented but unsupported
- A requirement changed without updating traceability
- Any other material inconsistency

## Review findings

Record each finding as exactly one of:

| Severity | Meaning | Action |
|----------|---------|--------|
| **Critical** | Requirement violates an objective, contradicts a confirmed business rule, or is infeasible | Must be resolved before proceeding |
| **Warning** | Ambiguity, missing traceability, unclear priority, or minor inconsistency | Should be addressed |
| **Suggestion** | Optional improvement in clarity or structure | May be addressed |

Fix all critical findings immediately. Record warnings and suggestions for the
baseline.

## Guided mode validation package

If the operating mode is **guided**, produce a functional validation package
for the human. The package must be concise and focused on matters requiring
human judgement — not a document dump. Include where applicable:

- **Refined functional outcome** — restatement of what the system will do
- **Scope boundaries** — what is in and out of scope
- **Main user journeys** — high-level workflow descriptions
- **Key business rules** — the most consequential rules
- **Important exceptions** — notable error and recovery behaviour
- **Significant assumptions** — assumptions that could materially affect
  outcome if wrong
- **Decisions made autonomously** — Class A/B decisions with rationale
- **Decisions requiring confirmation** — Class C decisions that were escalated
- **Low-fidelity wireframes** — where UI behaviour is meaningful
- **Detailed success-criteria coverage** — summary of how high-level criteria
  are addressed
- **High-level traceability summary** — objective → requirement → verification
- **Explicit exclusions and limitations** — what is deliberately not covered

Present the package and ask the human to respond with one of:

- **Approved** — proceed to baseline and implementation
- **Approved with changes** — specific changes requested; update all artefacts
- **Reanalyse** — fundamental disagreement; return to discovery

### Propagate feedback

When the human provides feedback (changes or reanalysis direction):

1. Identify every affected artefact: requirements, business rules, user
   journeys, wireframes, success criteria, verification methods, user
   documentation, configuration documentation, traceability, and any other
   related items.
2. Update each one consistently.
3. Verify no contradictions were introduced by the changes.
4. Present the updated baseline for confirmation if the changes were material.

Do not ask the human to identify affected artefacts manually. Propagation is
your responsibility.

## Output

- Quality gate findings (critical/warning/suggestion per requirement)
- Resolution of all critical findings
- (Guided mode only) Functional validation package and human decision
- Updated artefacts reflecting any human feedback

## Quality checklist

- [ ] Every requirement checked against all 11 per-requirement criteria
- [ ] Whole-set checked against all 7 criteria
- [ ] Cross-artefact consistency checked
- [ ] All critical findings resolved
- [ ] (Guided) Validation package is concise and focused on human-judgement
      items
- [ ] (Guided) Human feedback propagated to all affected artefacts
- [ ] No new contradictions introduced by changes