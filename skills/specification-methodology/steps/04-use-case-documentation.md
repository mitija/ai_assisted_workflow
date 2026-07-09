# Step 4: Document Use Cases

[Back to Step 3: Use Case Identification](03-use-case-identification.md) | [Up to Index](../SKILL.md) | [Next: Step 5 — Review](05-review.md)

## Objective

Write detailed, testable specifications for each use case identified in [Step 3](03-use-case-identification.md).

## Process

1. **Document Each Use Case** following the template below. Be thorough in main sequence and exception flows. Include all acceptance criteria.
2. **Review for Completeness** — Every use case from the Step 3 table must have a detailed specification. Cross-check that main sequences reference correct model fields and relationships.

## Use Case Template

Each use case must include all of the following sections:

- **Use Case ID** — UC-XXX (sequential numbering)
- **Title** — Action + Model (e.g., "Create Deck")
- **Summary** — One-sentence description
- **Pre-conditions** — What must be true before execution
- **Actors & Trigger** — Authorized roles and what initiates the use case
- **Main Sequence** — Numbered back-and-forth between User and System. Prefix each step with **User** or **System**.
- **Alternative Flows** — Variations, optional paths, different user choices
- **Exception Flows** — Validation failures, business rule violations, system errors, with user feedback for each
- **Related Models** — List of models involved, with links to their files. Keep model references here rather than scattering links throughout the main text.
- **Technical Considerations** — Algorithms, performance requirements, security concerns, integration points
- **Post-conditions** — What is true after successful completion, data state changes, side effects
- **Acceptance Criteria** — Gherkin-style scenarios (Given/When/Then). These are inputs to the contractual `<epic>_TESTS.md` scenarios authored via the `test-scenarios` skill, which are authoritative.

## Output Format

Each use case written to `use-cases/UC-XXX-<kebab-case-title>.md`. See [Specification Template: Use Case File](../assets/specification-template.md#use-case-file-template) for the exact format.

## Example

File: `use-cases/UC-006-create-deck.md` — see the [Use Case File Template](../assets/specification-template.md#use-case-file-template) for a filled example.

> **Checkpoint:** Present the documented use cases to the user for validation before moving to [Step 5](05-review.md). The Gherkin acceptance criteria written here feed the contractual `<epic>_TESTS.md` (see the `test-scenarios` skill), which is the authoritative test contract.