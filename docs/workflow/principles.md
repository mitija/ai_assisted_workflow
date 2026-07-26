# Core Principles

1. **The spec is the contract.** If behaviour is not specified or tested, it is not required.
2. **Tests are executable spec.** Every business rule appears as a test scenario with concrete state transitions. Prose alone is not acceptance criteria.
3. **Cycles are short by design.** Typical implementation cycle: a few hours of AI-assisted work. Design effort is pushed upstream so downstream is mechanical. *(TOL Improvements stats to be added.)*
4. **No mid-flight spec changes.** Genuine questions stop work, update the spec, produce a new tag. Implementation never runs in parallel with spec clarification.
5. **The developer is autonomous on method.** We specify the *what* (spec + tests + acceptance), not the *how* (which AI, which IDE, which prompts).
6. **Documentation is a first-class artifact** — own repository, versioned, customer-accessible, kept up to date. The analyst owns documentation across the full lifecycle; it is not a separate administrative task assigned to the human.
7. **Local scratch material is not the contract.** Prompts, session notes, copied logs, and experiments may live in the project workspace outside both git repositories. Versioned documentation work may also live under `docs/working/`, but it is still not the frozen implementation contract unless promoted into the tagged customer-facing spec/test docs.
8. **The analyst owns the functional contract.** Requirements, business rules, success criteria, traceability, wireframes, and documentation are produced and maintained by the analyst agent — not by the human or the conductor. Every requirement and important business rule carries exactly one provenance label: explicitly-requested, inferred-context, inherited, domain-practice, design-decision, risk-control, or unresolved — distinct from Class A-D decision impact. The governing rule: never silently present an inferred requirement as though it was explicitly requested by the human. Stable identifiers (OBJ/HC/FR/BR/NFR/OPS/DOC/SC/VER/DEC/RISK) maintain traceability from human objective through high-level criteria, requirements, success criteria, and verification evidence.

> **A note on strictness.** These principles are not guidelines — they are load-bearing. Loosening any one of them collapses the economics of the lean cycle. The methodology is designed to be adopted as a package, not partially.

## Navigation

- [Workflow index](README.md)
- [Landing page](../AI_assisted_development_workflow.md)