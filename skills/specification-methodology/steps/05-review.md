# Step 5: Consistency Check

[Back to Step 4: Use Case Documentation](04-use-case-documentation.md) | [Up to Index](../SKILL.md)

## Objective

Verify the specification artefacts are internally consistent, complete, and structurally sound. This is a **consistency check**, not a second quality gate — the analyst-review skill owns the functional validation and quality gate. Do not duplicate that work.

## Consistency Checklist

See the [Quality Checklist](../references/quality-checklist.md) for the detailed reference by category. Focus on structure/formatting and internal consistency items:

- **Structure** — All files exist, relative links resolve, main index links to every sub-file.
- **Naming consistency** — No synonyms; one term equals one concept; glossary usage is uniform.
- **Cross-referencing** — Use case files link to referenced models; model files reference use cases where helpful.
- **Extraction rule** — Sections over 40 lines extracted to standalone files with summary + link.
- **Output format** — All files follow the wiki-style directory layout.

## Analysis Mode Guidance

After the checklist pass, produce the appropriate output based on `analysis_mode`:

- **Guided analysis**: Collect all non-blocking observations recorded during Steps 1–4 and present a single consolidated functional validation package. Include the full specification artefacts, any open questions, and a summary of observations. Wait for human feedback before finalising.
- **Autonomous analysis**: Proceed directly. No intermediate approval needed. Follow analyst decision classes (Class C decisions are immediate in autonomous mode; Class D always immediate).

Blocking issues — genuine ambiguities that affect implementation — must still be surfaced one at a time with unpacking. If none remain, finalise the specification artefacts directly.

## Finalization

1. Address any feedback from the consolidated validation package.
2. Resolve any blocking issues.
3. Update the revision history in `spec-index.md`.
4. Mark the specification as "Final".
5. Verify all files exist and all relative links resolve.