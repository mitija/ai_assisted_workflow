# Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│  Consultant (with AI)                                           │
│  1. Refine the requirement ([specification.md](specification.md)), then draft/update SPEC and   │
│     TESTS in docs repo ([specification.md](specification.md))                                   │
│  2. Customer reviews and validates (via docs repo access)       │
│  3. Commit + tag docs when ready (e.g. spec-260513)             │
│  4. Notify developer                                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Developer (with AI, method of their choice)                    │
│  5. Check out docs tag                                          │
│  6. Raise any questions; if genuine → cycle returns to step 1   │
│  7. Implement against spec + tests                              │
│  8. Record the docs tag implemented in source-side traceability │
│  9. Deliver per [Developer Deliverables](#developer-deliverables)                              │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Consultant + BA                                                │
│  10. Code review (AI-assisted) against spec                     │
│  11. Run automated tests                                        │
│  12. Behavioural demo on dev server                             │
│  13. Approve, or feed findings into next spec iteration         │
└─────────────────────────────────────────────────────────────────┘
```

**Cycle target: a few hours of implementation per iteration.**

## Questions During Implementation

- **All questions are answered before implementation begins.** A genuine question that reveals a gap stops the cycle, updates the spec/tests, and produces a new tag. The developer then starts (or restarts) from that tag.
- **Trivial clarifications** that don't change the spec are captured in `docs/working/` or `local/`, depending on whether they should be versioned, without a new tag.
- **No parallel work.** A developer building against an unresolved question is producing rework by design.

## Roles

| Role          | Owns                                              | Tools                       |
|---------------|---------------------------------------------------|-----------------------------|
| Consultant    | Spec, tests, acceptance, tagging                  | AI (spec skill), git        |
| BA            | Behavioural validation, customer-facing demo      | Dev server                  |
| Developer     | Code, automated tests, dev server, dev report     | AI (method of their choice) |
| Customer      | Sign-off on customer-facing docs                  | Read access to docs repo    |
| AI (any side) | Drafting, translation, review — never decisions   | —                           |

## Developer Deliverables

Required at the end of each cycle:

1. **Source code** — committed against the docs tag, with the tag referenced in source-side traceability.
2. **Automated test suite** — covers every state-table row and every cross-cutting invariant in scope.
3. **Development report** — short, covering:
   - Summary of work, tied to use cases and test scenarios.
   - Test coverage statement: what's covered, what isn't, why.
   - Any deviations from spec (should be zero in the routine case).
   - Notable design decisions not dictated by the spec.
4. **Running dev server** — accessible to consultant and BA, with a fixture database suitable for the test scenarios.

## Navigation

- [Workflow index](README.md)
- [Acceptance](acceptance.md)
- [Landing page](../AI_assisted_development_workflow.md)