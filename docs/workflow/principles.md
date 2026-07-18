# Core Principles

1. **The spec is the contract.** If behaviour is not specified or tested, it is not required.
2. **Tests are executable spec.** Every business rule appears as a test scenario with concrete state transitions. Prose alone is not acceptance criteria.
3. **Cycles are short by design.** Typical implementation cycle: a few hours of AI-assisted work. Design effort is pushed upstream so downstream is mechanical. *(TOL Improvements stats to be added.)*
4. **No mid-flight spec changes.** Genuine questions stop work, update the spec, produce a new tag. Implementation never runs in parallel with spec clarification.
5. **The developer is autonomous on method.** We specify the *what* (spec + tests + acceptance), not the *how* (which AI, which IDE, which prompts).
6. **Documentation is a first-class artifact** — own repository, versioned, customer-accessible, kept up to date. A stale spec is worse than no spec.
7. **Local scratch material is not the contract.** Prompts, session notes, copied logs, and experiments may live in the project workspace outside both git repositories. Versioned documentation work may also live under `docs/working/`, but it is still not the frozen implementation contract unless promoted into the tagged customer-facing spec/test docs.

> **A note on strictness.** These principles are not guidelines — they are load-bearing. Loosening any one of them collapses the economics of the lean cycle. The methodology is designed to be adopted as a package, not partially.

## Navigation

- [Workflow index](README.md)
- [Landing page](../AI_assisted_development_workflow.md)