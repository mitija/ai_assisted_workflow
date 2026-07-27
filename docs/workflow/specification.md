# The Specification

## From Intent to Requirements Baseline

Requirements are no longer produced through a human-driven refinement interview. The dedicated **analyst** agent owns the full transformation from high-level human intent to a complete, defensible functional contract. The analyst follows four lifecycle phases:

1. **Intake** — high-level Q&A establishing the problem, intended users, functional outcome, high-level success criteria, constraints, exclusions, and operating mode. Produces a confirmed objective brief.
2. **Discovery** — evidence-first 20-step process: inspects existing material, researches domain conventions, captures motivation, the problem, beneficiaries, outcomes, and reasonable user or operational expectations, identifies actors and entities, generates candidate requirements, defines business rules, analyses exceptions, classifies and resolves decisions, defines detailed success criteria and verification methods, drafts intended documentation, produces wireframes, and performs an internal quality review. Sources, findings, confidence, assumptions, and provenance distinguish observed or domain expectations from explicit human requirements.
3. **Review** — structured quality gate against per-requirement and whole-set criteria. In guided mode, produces a functional validation package for human review. Propagates feedback across all artefacts.
4. **Baseline** — establishes traceability with stable identifiers (OBJ-xxx, HC-xxx, FR-xxx, BR-xxx, NFR-xxx, OPS-xxx, SC-xxx, VER-xxx, DOC-xxx, DEC-xxx, RISK-xxx). Maintains consistency across all functional artefacts throughout implementation, verification, and completion.

Every requirement and important business rule records its provenance — exactly one of: explicitly-requested, inferred-context, inherited, domain-practice, design-decision, risk-control, unresolved. Provenance is distinct from Class A-D decision impact. The governing rule: **never silently present an inferred requirement as though it was explicitly requested by the human.**

For full details of the analyst's process, see the [analyst agent definition](../../agents/agent/analyst.md) and the four `analyst-*` skills (intake, discovery, review, baseline).

The conductor's Analyze phase is only an orchestration gate: it checks modes,
permissions, context readiness, work classification, baseline sufficiency, and
objective/scope alignment. It does not replace the analyst's functional analysis.

## Optional 5-Step Specification Methodology

An **optional post-baseline structuring tool** (the `specification-methodology` skill) consumes the analyst baseline and formats it into implementation-ready wiki-style artefacts. This is not requirements elicitation: the analyst owns the functional contract. It is not a mandatory prerequisite for the conductor.

The methodology runs all five steps uninterrupted in both analysis modes. Purely structural observations (naming, formatting, cross-references) are resolved within the methodology as they arise. If structuring reveals a material functional-contract issue, it is routed back through the analyst change/decision/validation policy — the methodology does not own its own approval gate. Blocking issues still stop appropriately.

The five techniques:

1. **Models** — entities, fields with explicit types and constraints, relationships, on-delete behaviour. All models extend a `BaseModel` with audit fields.
2. **Roles** — user types and permissions matrix per use case.
3. **Use case identification** — domain-specific first, then CRUD, then extended operations (export, mass operations, state changes).
4. **Use case documentation** — pre-conditions, actors and triggers, main sequence, alternative flows, exception flows, post-conditions, Gherkin acceptance criteria.
5. **Consistency check** — structural and naming consistency verification. Not a duplicate of the analyst-review quality gate; the analyst owns functional validation.

Naming conventions, field types, constraint notation (`*`, `U`, `RO`, `C`, `C/S`, `Rel`, `Rel/S`), and relationship semantics (`ref` vs `m2o`) are formalized so that **two practitioners — human or AI — produce comparable artifacts.**

Outputs are a **wiki-style directory tree** rather than a single document: a `spec-index.md` index plus one file per model under `models/` (global, shared across epics) and one file per use case under `use-cases/`. Large or multi-item sections extract to their own files; large-scope projects may group use cases and tests under `epics/<epic>/` while the data model stays global.

The spec covers as much as needed: functional logic, data schema, business rules, and UI/UX where it deviates from framework defaults. For Odoo, UI/UX is usually thin.

## Navigation

- [Workflow index](README.md)
- [Landing page](../AI_assisted_development_workflow.md)
