---
name: specification-methodology
description: An optional specification-structuring tool that consumes an existing `analyst baseline` and produces a consistent, testable wiki-style specification. Uses 5 techniques (Models, Roles, Use Cases identification, Use Cases documentation, Review). Use when structuring an analyst's output into implementation-ready spec artefacts. Not a requirements elicitation process — the analyst owns the functional contract. Not a mandatory conductor prerequisite.
argument-hint: [requirements-file-or-description]
---

# Specification Writing Methodology

You are a specification writer. Transform an existing **`analyst baseline`** — the validated requirements baseline — into structured, testable implementation artefacts. This is an optional structuring tool — not a second requirements elicitation, not a mandatory conductor prerequisite. The analyst owns the functional contract (analyst-baseline skill); this methodology shapes it for implementation.

## When to Use

- Structuring an existing analyst requirements baseline into wiki-style spec files
- Defining data models, roles, or use cases from an established baseline
- Documenting a system's behavior with consistent naming and output formats
- Organising requirements that are already validated into implementation-ready artefacts

## Input

This skill consumes an existing **`analyst baseline`** (the output of the analyst's four-phase workflow: intake, discovery, review, baseline). The baseline provides:
- Confirmed requirements with stable identifiers (FR-xxx, BR-xxx, NFR-xxx, etc.)
- Business rules and success criteria
- Verified traceability and provenance

If no `analyst baseline` exists, stop. Route the requirements through the full analyst lifecycle (intake → discovery → review → baseline) before loading this skill. This methodology is not a requirements elicitation or validation tool; it is a structuring post-process for an already-validated baseline.

If `$ARGUMENTS` is provided, read that file first.

## Process Overview

Follow these five steps uninterrupted in both analysis modes. Do not stop for approval between steps. Resolve purely structural observations (naming, formatting, cross-references) within the methodology as you go. If structuring reveals a material functional-contract issue — a requirement that is ambiguous, contradictory, or incomplete in a way that affects implementation — stop and route it back through the analyst change/decision/validation policy; do not create a methodology-owned approval gate. Genuine ambiguities still stop appropriately (one question at a time with unpacking).

```
Analyst Requirements Baseline
         |
    Step 1: Models and Attributes
         |
    Step 2: Roles
         |
    Step 3: Identify Use Cases
         |
    Step 4: Document Use Cases
         |
    Step 5: Review (consistency check — not a second quality gate)
         |
  Final Specification Artefacts
```

## Routing Table

| If the user says… | Load this file |
|---|---|
| "Identify models / entities / data" | [Step 1: Models](steps/01-models.md) |
| "Define roles / permissions / actors" | [Step 2: Roles](steps/02-roles.md) |
| "Find / list / identify use cases" | [Step 3: Use Case Identification](steps/03-use-case-identification.md) |
| "Write / document use cases / scenarios" | [Step 4: Use Case Documentation](steps/04-use-case-documentation.md) |
| "Review / finalize / validate spec" | [Step 5: Review](steps/05-review.md) |
| "What templates do I use?" | [Specification Templates](assets/specification-template.md) |
| "What field types / constraints / naming?" | [Field Reference](references/field-reference.md) |
| "What does a good spec look like?" | [Quality Checklist](references/quality-checklist.md) |

## Output Document Structure

The specification is organized as a **wiki-style directory tree**. The main file (`spec-index.md`) acts as an index.

### Default Layout (single project, no epics)

```
spec/
├── spec-index.md                    # Main index + inline sections
├── data-initialization.md           # (>40 lines, else inline)
├── non-functional-requirements.md   # (>40 lines, else inline)
├── integration-points.md            # (>40 lines, else inline)
├── appendices.md                    # (>40 lines, else inline)
├── <project>_TESTS.md               # Contractual tests (test-scenarios skill)
├── models/
│   └── <ModelName>.md               # One per model — GLOBAL, shared across epics
└── use-cases/
    └── UC-001-<kebab-case-title>.md
```

### Epic-Split Layout (large-scope projects)

```
spec/
├── spec-index.md
├── models/                          # GLOBAL — never duplicated per epic
│   └── <ModelName>.md
└── epics/
    ├── <epic-a>/
    │   ├── use-cases/
    │   └── <epic-a>_TESTS.md
    └── <epic-b>/
        ├── use-cases/
        └── <epic-b>_TESTS.md
```

**Migration rule:** Start flat, introduce epics later. Move use-case files + TESTS into `epics/<epic>/`, update relative links. Models stay global. Each epic owns exactly one `<epic>_TESTS.md`.

### Main Index File (`spec-index.md`) Sections

1. General Business Context
2. User Roles (inline)
3. Data Initialization (inline if ≤40 lines)
4. Use Cases Index (links to `use-cases/`)
5. Data Models Index (links to `models/`)
6. Non-Functional Requirements (inline if ≤40 lines)
7. Integration Points (inline if ≤40 lines)
8. Appendices (inline if ≤40 lines)

### Extraction Rule

Sections 3, 6, 7, 8: if >40 lines, extract to standalone file and replace with summary + relative link.

### File Naming Conventions

- **Models:** `models/<ModelName>.md` — PascalCase matching model name
- **Use cases:** `use-cases/UC-XXX-<kebab-case-title>.md`
- **Section files:** kebab-case (`data-initialization.md`)
- **Test files:** `<project>_TESTS.md` (flat) or `<epic>_TESTS.md` (epic-split)

### Cross-Referencing

- The main index must link to every sub-file via relative Markdown links.
- Sub-files may link back to the index and to related models/use cases.
- Use case files should link to the models they reference.
- Model files may link to use cases when helpful (optional, maintenance trade-off).

## Best Practices

1. **Start Simple, Add Detail Progressively** — Begin with high-level model list, add attributes iteratively.
2. **Use Consistent Naming** — Follow naming conventions strictly. Maintain glossary. No synonyms.
3. **Think About the User** — Write use cases from user perspective. Include realistic examples.
4. **Leverage Examples** — Reference similar systems. Provide sample data.
5. **Collaborate Early** — Involve developers in Step 1, users in Steps 3-4.

## Adaptation Notes

- **Smaller projects:** Simplify use case detail, combine related use cases, skip Step 2 if single user type.
- **Larger projects:** Add sub-steps, create multiple spec documents per module, include formal review gates.
- **Different domains:** Adjust generic use cases, add domain-specific sections, modify template.

## Important Rules

- Never use synonyms — one term equals one concept throughout.
- Maintain a glossary and reference it.
- Every use case must have Gherkin-style acceptance criteria.
- Document exception flows — happy path is not enough.
- Do not over-engineer for hypothetical future needs.
- Always include audit fields via BaseModel inheritance.
- Be explicit about on-delete behaviors for every relationship.
- Specification writing is iterative — refine as you go.

## Loading Policy

Do not load all supporting files up front. Load only the current step file needed, plus any template or reference file that step links to. This keeps the context small.