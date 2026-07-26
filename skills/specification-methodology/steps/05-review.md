# Step 5: Structural Consistency and Wiki Integrity Check

[Back to Step 4: Use Case Documentation](04-use-case-documentation.md) | [Up to Index](../SKILL.md)

## Objective

Verify the specification artefacts are structurally consistent and the wiki layout is intact. This is a **structural consistency and wiki integrity check**, not a second quality or approval gate — the analyst-review skill owns the functional validation and quality gate. Do not duplicate that work.

## Consistency Checklist

See the [Quality Checklist](../references/quality-checklist.md) for the detailed reference by category. Focus on structure/formatting and internal consistency items:

- **Structure** — All files exist, relative links resolve, main index links to every sub-file.
- **Naming consistency** — No synonyms; one term equals one concept; glossary usage is uniform.
- **Cross-referencing** — Use case files link to referenced models; model files reference use cases where helpful.
- **Extraction rule** — Sections over 40 lines extracted to standalone files with summary + link.
- **Output format** — All files follow the wiki-style directory layout.

## Structuring Observations During the Checklist

During the checklist pass, resolve purely structural observations (naming, formatting, cross-references, missing links, extraction rule violations) directly — these are within the methodology's scope. If the checklist reveals a material functional-contract issue (e.g., a missing requirement that affects correctness), stop and route it back through the analyst change/decision/validation policy; do not create a methodology-owned approval gate.

## Finalization

1. Resolve any blocking issues found during the checklist.
2. Update the revision history in `spec-index.md`.
3. Mark the specification as "Final".
4. Verify all files exist and all relative links resolve.