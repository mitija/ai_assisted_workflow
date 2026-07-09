# Conductor Report — 20260708-0754

**Goal:** Rework the `specification-methodology` opencode skill so its root `SKILL.md` becomes a compact router and its step/process/template/reference content is split into supporting Markdown files, with every reference to another supporting file encoded as a Markdown link.

**Mode:** interactive
**Status:** complete
**Tasks completed:** 1 / 1

## Task Details

| ID | Description | Dependencies | Verification | Result | Commit | Status |
|----|-------------|--------------|--------------|--------|--------|--------|
| T01 | Modularize the `specification-methodology` skill into router, step, template, and reference files | — | separate verifier checked directory structure, frontmatter, compact router behavior, loading policy, routing table links, step navigation links, template/reference/checklist contents, no bare intra-skill supporting-file paths, all relative Markdown links resolving, `PROJECT_SUMMARY.md` updated, README/AGENTS consistency, and no commits/tags | PASS | — | passed |

## Executor Prompt Appendix

```
You are executing task T01 for the conductor in /Users/ralla/Projects/all_agents.

Goal: Rework the opencode skill `specification-methodology` from a monolithic file into a small router plus supporting Markdown files, to reduce token usage when the skill is loaded. This is a non-code documentation/configuration change.

Files/paths:
- Existing skill entry point to edit: `/Users/ralla/Projects/all_agents/agents/skills/specification-methodology/SKILL.md`
- Create supporting files under: `/Users/ralla/Projects/all_agents/agents/skills/specification-methodology/`
- Update `/Users/ralla/Projects/all_agents/PROJECT_SUMMARY.md` to reflect the new modular skill structure.
- Check `/Users/ralla/Projects/all_agents/README.md`, `/Users/ralla/Projects/all_agents/AGENTS.md`, and `/Users/ralla/Projects/all_agents/agents/AGENTS.md`; update only if their existing description becomes inaccurate. Do not change `agents/project_context.template.yaml` or `agents/skills/init-project/SKILL.md` unless you discover an actual consistency-triangle issue.

Required new structure (use these exact directories and preferably these exact names unless there is a strong reason not to):
```
agents/skills/specification-methodology/
  SKILL.md
  steps/
    01-models.md
    02-roles.md
    03-use-case-identification.md
    04-use-case-documentation.md
    05-review.md
  templates/
    specification-template.md
  reference/
    field-reference.md
    quality-checklist.md
```

Content requirements:
1. Preserve the methodology and important content from the current monolithic `SKILL.md`:
   - frontmatter name/description/argument-hint;
   - role/when-to-use/input guidance;
   - 5-step process;
   - step-specific instructions and validation checkpoints;
   - output document structure, naming conventions, cross-referencing rules;
   - model/use-case/spec-index templates;
   - field types, constraints, on-delete behavior, naming conventions;
   - best practices, adaptation notes, and important rules.
2. Make root `SKILL.md` a compact router/overview, not a full copy of all details.
3. Put one process step in each `steps/*.md` file.
4. Put reusable skeleton templates in `templates/specification-template.md`.
5. Put detailed field/type/constraint/on-delete/naming/reference material in `reference/field-reference.md`.
6. Put the Step 5 detailed review checklist in `reference/quality-checklist.md`, with Step 5 linking to it.
7. Add a clear loading policy in `SKILL.md`: do not load all supporting files up front; load only the current step/reference/template needed.
8. User-specific constraint: **every reference to another supporting file in Markdown must be encoded as a Markdown link**, not plain text. Example: use `[Step 1: Models](steps/01-models.md)`, not `steps/01-models.md`. Apply this in `SKILL.md` and all supporting files. Include back/next navigation links where useful.
9. Keep supporting files as normal `.md` files only. Do not create nested `SKILL.md` files.
10. Keep minimal diff outside this skill directory and `PROJECT_SUMMARY.md`. Do not reformat unrelated sections.
11. Follow opencode skill conventions from the existing file; the entry point remains `agents/skills/specification-methodology/SKILL.md` so existing links from other skills remain valid.
12. Do not create git commits or tags.

Implementation guidance:
- You may extract content from the existing `SKILL.md`; avoid losing substantive methodology details.
- In the router, include a routing table mapping user intents to linked files.
- In each step file, include required inputs, outputs, process, checkpoint, and links to related template/reference files.
- In `templates/specification-template.md`, include model file, roles/permissions, use-case index, use-case file, and spec-index templates as appropriate.
- In `reference/field-reference.md`, include field types, constraint symbols, on-delete behaviors, naming conventions, and complete model example if useful.
- In `reference/quality-checklist.md`, include the review categories and anti-patterns.

Success criteria:
- `SKILL.md` is much shorter and clearly acts as a router.
- The supporting files collectively preserve the original process and reference content.
- All intra-skill references to supporting files are Markdown links.
- No extra skills are accidentally registered (no nested `SKILL.md`).
- `PROJECT_SUMMARY.md` reflects that `specification-methodology` is modular/router-based.
- README/AGENTS files remain accurate; updated only if necessary.
- Markdown is valid and readable.

After editing, report exactly what files you created/modified and any decisions or caveats. Do not commit.
```