# Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│  Human (Objective Owner)                                        │
│  1. Provides problem, functional outcome, high-level criteria   │
│     and constraints to the analyst                              │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Analyst (Functional Contract Owner)                            │
│  2. Phase 1 — Intake: high-level Q&A, objective brief           │
│  3. Phase 2 — Discovery: evidence-first 20-step process         │
│     → functional, non-functional, operational, documentation    │
│     → requirements, business rules, success criteria, wireframes│
│     → intended user/operational documentation                   │
│  4. Phase 3 — Review: quality gate                              │
│  5. [Guided mode] Functional validation package → human approves│
│  6. Phase 4 — Baseline: traceability, identifiers, consistency  │
│  7. Binary completion gate (complete/partial/aborted)           │
│  8. Produces requirements baseline with stable IDs and trace    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Conductor (Delivery Owner)                                     │
│  9. Checks analyst output aligns with original objective        │
│ 10. Decomposes implementation work (task graph)                 │
│ 11. Coordinates implementation, technical review, verification  │
│ 12. Validates delivered result against:                         │
│     - detailed specification (functional contract)              │
│     - original functional objective                             │
│     - human's high-level success criteria                       │
│ 13. Ensures traceability, verification evidence, documentation  │
│     are complete before declaring success                       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Developer (with AI, method of their choice)                    │
│ 14. Check out docs tag                                          │
│ 15. Raise questions to analyst; if genuine gap → cycle updates  │
│     requirements baseline and produces new tag                  │
│ 16. Implement against spec + tests                              │
│ 17. Record the docs tag implemented in source-side traceability │
│ 18. Deliver per [Developer Deliverables](#developer-deliverables)│
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Conductor + Analyst + Reviewer                                 │
│ 19. Code review (AI-assisted) against spec                      │
│ 20. Run automated tests                                         │
│ 21. Behavioural demo                                            │
│ 22. Analyst updates traceability with evidence                  │
│ 23. Conductor performs functional outcome review                │
│ 24. Final human outcome review                                  │
│ 25. Approve, or feed findings into next analysis iteration      │
└─────────────────────────────────────────────────────────────────┘
```

**Cycle target: a few hours of implementation per iteration.**

## Analysis Modes

The analyst operates in two modes, chosen at project start and switchable during the project.
The analysis mode is an independent value distinct from the conductor's own interactive/
autonomous interaction mode — analysis governance and implementation autonomy are
separate dimensions:

- **Autonomous mode** (default for well-understood work): the analyst performs intake, discovery, review, and baseline without mandatory human approval between phases. Interrupts the human only for Class C (material business/UX/security/cost decisions) or Class D (blocking/high-risk) decisions. Non-blocking uncertainty is resolved and recorded, not escalated.
- **Guided mode** (default for new products, material scope changes, or when explicitly requested): the same analysis process, but the analyst pauses after Phase 3 (Review) to produce a concise functional validation package for human review. The human reviews the functional interpretation — not every individual requirement — and responds with approved, approved-with-changes, or reanalyse. The analyst then propagates feedback across all affected artefacts.

Mode transitions are permitted: start guided, switch to autonomous after the validation gate; temporarily return to guided if a material scope change emerges.

## Questions During Analysis and Implementation

- During analysis, the analyst resolves non-blocking decisions autonomously and escalates only consequential or blocking decisions to the human.
- During implementation, genuine ambiguity about the functional contract is a blocker: stop and route to the analyst for functional interpretation, not the human. A genuine gap stops the cycle, updates the requirements baseline, and produces a new tag.
- Trivial clarifications that don't change the requirements are captured in `docs/working/` or `local/` without a new tag.
- No parallel work. Building against an unresolved question produces rework by design.

## Roles

| Role          | Owns                                              | Tools                       |
|---------------|---------------------------------------------------|-----------------------------|
| Human         | Problem, functional objective, high-level criteria, consequential decisions | Read access to docs repo    |
| Analyst       | Functional contract: requirements, business rules, success criteria, traceability, wireframes, intended documentation | AI (analyst skills), git    |
| Conductor     | Delivery, decomposition, verification orchestration, outcome validation against objective | AI (conductor skills), git  |
| Developer     | Code, automated tests, dev server, dev report     | AI (method of their choice) |
| Reviewer      | Code review against spec, structural completeness | Read-only AI-assisted       |
| Verifier      | Independent test/inspection execution, evidence recording | AI (verifier agent)         |

## Developer Deliverables

Required at the end of each cycle:

1. **Source code** — committed against the docs tag, with the tag referenced in source-side traceability.
2. **Automated test suite** — covers every state-table row and every cross-cutting invariant in scope.
3. **Development report** — short, covering:
   - Summary of work, tied to use cases and test scenarios.
   - Test coverage statement: what's covered, what isn't, why.
   - Any deviations from spec (should be zero in the routine case).
   - Notable design decisions not dictated by the spec.
4. **Running dev server** — accessible to conductor and analyst, with a fixture database suitable for the test scenarios.

## Navigation

- [Workflow index](README.md)
- [Acceptance](acceptance.md)
- [Landing page](../AI_assisted_development_workflow.md)