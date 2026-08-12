# Core Principles

1. **The spec is the contract.** If behaviour is not specified or tested, it is not required.
2. **Tests are executable spec.** Every business rule appears as a test scenario with concrete state transitions. Prose alone is not acceptance criteria.
3. **Cycles are short by design.** Typical implementation cycle: a few hours of AI-assisted work. Design effort is pushed upstream so downstream is mechanical. *(TOL Improvements stats to be added.)*
4. **No mid-flight spec changes.** Genuine questions stop work, update the spec, produce a new tag. Implementation never runs in parallel with spec clarification.
5. **The developer is autonomous on method.** We specify the *what* (spec + tests + acceptance), not the *how* (which AI, which IDE, which prompts).
6. **Documentation is a first-class artifact** — own repository, versioned, customer-accessible, kept up to date. A stale spec is worse than no spec.
7. **Local scratch material is not the contract.** Prompts, session notes, copied logs, and experiments may live in the project workspace outside both git repositories. Versioned documentation work may also live under `docs/working/`, but it is still not the frozen implementation contract unless promoted into the tagged customer-facing spec/test docs.
8. **Verification follows semantic intent.** Evidence must demonstrate the
   intended behavior or outcome, not accidental literal wording. Exact text is
   binding only when it is itself a traced contract, such as a machine protocol,
   API/config key, legal wording, or explicit user requirement. A failed check is
   first classified as work nonconformity or a defective/insufficient control;
   defective controls are corrected and rerun without rewriting compliant work.
9. **Tasks preserve bounded autonomy.** TODOs, task graphs, reviews, and
   escalation plans state intent, scope/touchpoints, context, fixed constraints
   with reasons, semantic success criteria, and evidence. They leave internal
   design and mechanism open unless a traced constraint fixes them, while
   resolving genuine product/design ambiguity before delegation.

> **A note on strictness.** These principles are not guidelines — they are load-bearing. Loosening any one of them collapses the economics of the lean cycle. The methodology is designed to be adopted as a package, not partially.

## Navigation

- [Workflow index](README.md)
- [Landing page](../AI_assisted_development_workflow.md)
