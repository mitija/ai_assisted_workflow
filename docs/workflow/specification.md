# The Specification

## Requirement Refinement (Precursor)

Before the methodology proper, a **refinement** step hardens the initial plain-English requirement. It is a guided, one-question-at-a-time interview (formalized as the `spec-refinement` skill) that turns a rough, high-level requirement into a precise, unambiguous narrative — clarifying the entities, their relationships, the main ways they are manipulated, the key business rules, and the terminology.

It is deliberately **not exhaustive**: it stops once the requirement is precise enough to begin defining models. Exhaustive CRUD, full permissions, field-level types, and exception flows are left to the methodology. The refined narrative is written to `docs/working/refined-requirements.md` and becomes the input to the 5-step methodology below.

## The 5-Step Methodology

A 5-step methodology, formalized as a reusable AI skill (the `specification-methodology` skill):

1. **Models** — entities, fields with explicit types and constraints, relationships, on-delete behaviour. All models extend a `BaseModel` with audit fields.
2. **Roles** — user types and permissions matrix per use case.
3. **Use case identification** — domain-specific first, then CRUD, then extended operations (export, mass operations, state changes).
4. **Use case documentation** — pre-conditions, actors and triggers, main sequence, alternative flows, exception flows, post-conditions, Gherkin acceptance criteria.
5. **Review** — completeness, consistency, traceability, technical feasibility.

Naming conventions, field types, constraint notation (`*`, `U`, `RO`, `C`, `C/S`, `Rel`, `Rel/S`), and relationship semantics (`ref` vs `m2o`) are formalized so that **two consultants — or two LLMs — produce comparable artifacts.**

Outputs are a **wiki-style directory tree** rather than a single document: a `spec-index.md` index plus one file per model under `models/` (global, shared across epics) and one file per use case under `use-cases/`. Large or multi-item sections extract to their own files; large-scope projects may group use cases and tests under `epics/<epic>/` while the data model stays global.

The spec covers as much as needed: functional logic, data schema, business rules, and UI/UX where it deviates from framework defaults. For Odoo, UI/UX is usually thin.

## Navigation

- [Workflow index](README.md)
- [Landing page](../AI_assisted_development_workflow.md)