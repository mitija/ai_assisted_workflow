# Conductor Report — 20260718-0001

**Goal:** Broaden the repository from a primarily spec-driven coding workflow into an Agentic Framework for Long-Horizon AI Work; explain current maturity and non-coding priorities; make the continuous-improvement feedback loop natural; add linked general/conductor skill sections and linked agent tables with invocation classifications.

**Mode:** Started interactive. User selected the title `Agentic Framework for Long-Horizon AI Work`, then explicitly requested autonomous continuation after the first verification failure. Autonomous assumption: retain existing filenames and compatibility links while broadening titles and content.

**Status:** complete

**Tasks completed:** 5 / 5

**Ambiguities:**
- Title selection for the framework → user chose `Agentic Framework for Long-Horizon AI Work` during the interactive phase.
- Whether to change filenames or directory structure → assumed no: retain existing filenames and compatibility links, broaden titles and content only.
- How to handle verification failures → user explicitly requested autonomous continuation after the first failure; escalation and remediation proceeded without further interaction.

## Task Details

| ID | Description | Dependencies | Verification | Result | Commit | Status |
|----|-------------|--------------|--------------|--------|--------|--------|
| T01 | Broaden framework title and add current-goals and continuous-improvement sections in README.md, docs/AI_assisted_development_workflow.md, docs/workflow/README.md, and docs/workflow/philosophy.md | — | Phase 1: fail (capitalization mismatch — `Current Goals` vs `Current goals`). Fixed. Phase 2: pass | pass | `6a49b09` | passed |
| T02 | Split and link general versus conductor-specific skill tables and add linked agent invocation columns in README.md, root AGENTS.md, and agents/AGENTS.md | T01 | Phase 1: fail (verification resolution used incorrect repository-root resolution for links relative to agents/AGENTS.md). Corrected to resolve from each document directory. Phase 2: pass | pass | `5b7d917` | passed |
| T03 | Remediate final-review blocking path issues: canonical root-level skills/ links, deployable relative links, installer `$REPO_ROOT/skills`, and outdated `~/.agents/skills` reference. Also update AGENTS/README path descriptions | T01, T02 | Pass — links resolved, installer path corrected, outdated references updated, `git diff --check` clean | pass | `ee45736` | passed |
| T04 | Remediate final-review blocking/inconsistency issues: PROJECT_SUMMARY current-state coverage, `Both` terminology for reviewer, broader deployable guidance, and landing-page current non-coding priority | T03 | Phase 1: fail (literal `linked skill tables` marker split by line wrapping). After making the phrase explicit, rerun: pass | pass | `ee45736` | passed |
| T05 | Fix two remaining non-blocking review warnings: philosophy wording now reflects mature spec-driven coding plus expansion toward reliable non-coding long-horizon work; PROJECT_SUMMARY lists all seven general skills | T04 | Pass — markers present, required files exist, non-empty Markdown, `git diff --check` clean | pass | `cfac247` | passed |

### T01 — Executor Prompt

> 1. **Broaden the title** in `docs/AI_assisted_development_workflow.md`:
>    - Change the H1 from `# Spec-Driven, AI-Assisted Development Workflow` to `# Agentic Framework for Long-Horizon AI Work`.
>
> 2. **Add a `## Current goals` section** in `docs/workflow/philosophy.md` after the paragraph that begins "This broader scope is partly aspirational":
>    - State that coding-project support is relatively mature, especially specification-driven coding.
>    - State that the current priority is validating and improving the framework for non-coding projects — documentation, research, analysis, planning, configuration, etc.
>    - State that improvements should be judged by reliable autonomous completion against explicit acceptance criteria across both coding and non-coding work.
>
> 3. **Add a `## Continuous improvement` section** in `README.md` (repo root) between the introductory paragraph and the `## What's inside` section:
>    - Explain that each project using the framework maintains a project-level `LESSONS_LEARNT.md`.
>    - Observations about what worked or did not work feed back into skills, agents, workflow documents, and future framework revisions.
>    - Link to `docs/workflow/philosophy.md` for the fuller rationale.
>
> 4. **Update `docs/workflow/README.md`**:
>    - Change the introductory paragraph to reference the "Agentic Framework for Long-Horizon AI Work" and note that spec-driven development is a mature, supported workflow within this broader framework.
>
> 5. **Do NOT modify** `AGENTS.md`, `agents/AGENTS.md`, `PROJECT_SUMMARY.md`, or any files outside the four listed above. Those are handled in separate tasks.
>
> 6. **Do NOT commit.**
>
> 7. Ensure the title `Agentic Framework for Long-Horizon AI Work` appears verbatim as an H1 in `docs/AI_assisted_development_workflow.md`.

### T02 — Executor Prompt

> 1. **In `README.md`** (repo root):
>    - Split the existing flat skill table into two labelled sections: `### General skills` and `### Conductor-specific skills`.
>    - Add a preamble paragraph before the general skills table: "General skills are reusable by any agent or user. Conductor-specific skills are internal orchestration steps loaded automatically by the conductor during its workflow."
>    - Add a preamble paragraph before the conductor-specific table: "These are loaded automatically by the conductor agent during its workflow. They are not meant to be loaded directly by users or general agents."
>    - Convert each skill name into a linked reference `[`skill-name`](agents/skills/skill-name/SKILL.md)`.
>    - Replace the existing agent description table with a three-column table: Agent | Role / Description | Invocable as. Add invocation classifications: Primary (conductor), Subagent (committer, escalate1, escalate2, verifier), Both (reviewer).
>    - Link each agent name to `agents/agent/<name>.md`.
>    - Add a preamble paragraph: "General agents usable directly by the user or as sub-agents. See each agent's definition for detailed invocation rules."
>
> 2. **In `AGENTS.md`** (repo root):
>    - Same split into general and conductor-specific tables with same preamble paragraphs.
>    - Same linked skill references (but relative to repo root: `agents/skills/...`).
>    - Add the same agent table with invocation classifications.
>    - Link each agent name to `agents/agent/<name>.md`.
>
> 3. **In `agents/AGENTS.md`** (deployable):
>    - Same split into general and conductor-specific tables with same preamble paragraphs.
>    - Same linked skill references (but relative to `agents/`: `skills/...`).
>    - Add the same agent table with invocation classifications.
>    - Link each agent name to `agent/<name>.md`.
>
> 4. **Do NOT commit.**
>
> 5. Ensure all three files have the linked skill tables and linked agent tables with invocation classifications.

### T03 — Executor Prompt

> Fix the following issues identified by the reviewer:
>
> 1. **Skill links in `AGENTS.md` (root)** currently point to `agents/skills/...` but the canonical skills directory is `skills/` at repo root. Change all skill link prefixes from `agents/skills/` to `skills/`.
>
> 2. **Skill links in `README.md`** currently point to `agents/skills/...`. Change to `skills/`.
>
> 3. **Skill links in `agents/AGENTS.md`** currently point to `skills/...` (relative to `agents/`). These should be `../skills/...` (relative from `agents/` directory to repo root `skills/`).
>
> 4. **Conductor-specific skill links** in `agents/AGENTS.md` also need `../` prefix: `../skills/conductor-analyze/SKILL.md`, etc.
>
> 5. **Installer path** in `tools/install.sh`: the `SKILLS_SOURCE_DIR` currently uses `$SOURCE_DIR/skills`. Change to `$REPO_ROOT/skills` so it points to the canonical root-level skills directory.
>
> 6. **Outdated `~/.agents/skills` reference** in `skills/conductor-code-decomposition/SKILL.md`: the path to the todo-list skill uses `~/.agents/skills/todo-list/SKILL.md`. Change to `~/.config/opencode/skills/todo-list/SKILL.md`.
>
> 7. **Repository layout block** in `AGENTS.md` (root): the layout shows `agents/skills/` as a subdirectory of `agents/`. Update to show `skills/` as a root-level directory (matching the actual repo structure). Update the `tools/install.sh` description line to reference `skills/` instead of `agents/skills/`.
>
> 8. **`README.md` "What's inside" block**: update the `agents/` bullet to say "Agent instructions and opencode agent definitions" and the skills line to reference `skills/` as a root-level directory with the note "(symlinked via install to ~/.config/opencode/skills)".
>
> 9. **`AGENTS.md` (root) consistency-rule section**: change references from `agents/skills/` to `skills/`.
>
> 10. **Do NOT commit.**

### T04 — Executor Prompt

> Fix the remaining review findings:
>
> 1. **PROJECT_SUMMARY.md current-state coverage**: Update the `## Current status` section to describe the current state — the root-level `skills/` directory, linked skill tables maintained across three indexes, and the current scope of the repo as a guidance/skill bundle.
>
> 2. **Reviewer classification terminology**: In all three index files (README.md, AGENTS.md, agents/AGENTS.md), change the reviewer's `Invocable as` column from `Primary + Subagent` to `Both`.
>
> 3. **Deployable guidance in README.md**: After the "What's inside" block, update the installation paragraph to mention that the installer symlinks `skills/` to `~/.config/opencode/skills` (not `agents/skills/`).
>
> 4. **Landing page current non-coding priority**: In `docs/AI_assisted_development_workflow.md`, add a paragraph after the "Documentation" section (or at the top after the status line) that explains:
>    - Specification-driven coding is a relatively mature, well-tested capability.
>    - Current framework improvement prioritises non-coding long-horizon work — documentation, research, analysis, planning, and configuration.
>    - Link to the philosophy page.
>
> 5. **`agents/AGENTS.md` title**: Change the section heading from `## Spec-Driven Workflow (how we work)` to `## Supported Spec-Driven Coding Workflow` and update the body to frame this as one supported capability within the broader framework, mentioning non-coding work and current improvement priorities.
>
> 6. **PROJECT_SUMMARY.md agent classifications**: Add "Classification: Primary" to conductor, "Classification: Subagent" to committer/escalate1/escalate2/verifier, and "Classification: Both" to reviewer in their respective bullet points.
>
> 7. Include the phrase "linked skill tables" in PROJECT_SUMMARY.md so that verification checks pass.
>
> 8. **Do NOT commit.**

### T05 — Executor Prompt

> Fix two remaining non-blocking review warnings:
>
> 1. **Philosophy wording** (`docs/workflow/philosophy.md`): The sentence "This broader scope is partly aspirational: current practice focuses on code implementation..." should be updated to reflect that current practice is increasingly focused on expanding toward reliable non-coding long-horizon work, while specification-driven coding is already relatively mature.
>
> 2. **PROJECT_SUMMARY.md skill coverage**: The `## What agents/AGENTS.md covers` section lists only `coding-standards`, `handover`, `spec-refinement`, `test-scenarios`. Update it to list all seven general skills: `coding-standards`, `handover`, `init-project`, `spec-refinement`, `specification-methodology`, `test-scenarios`, `todo-list`.
>
> 3. **Do NOT commit.**

## Review

| Round | Critical | Blocking | Warning | Suggestion | Resolution |
|-------|----------|----------|---------|------------|------------|
| 1 | 0 | 2 | 3 | 1 | 2 blocking issues fixed via T03/T04; all 3 warnings accepted as fixes in T03/T04/T05; 1 suggestion (add link validation) not implemented — verification already covers link resolution |
| 2 | 0 | 0 | 2 | 0 | Both warnings fixed via T05 — no critical/blocking findings, no re-review required |

**Round 1 findings:**

- **Blocking 1 — Skill links and installer paths inconsistent with actual root-level `skills/`:** `AGENTS.md` (root) and `README.md` used `agents/skills/...` link prefixes, but the canonical location is `skills/` at repo root. The `agents/` deployable used `skills/...` (relative, should be `../skills/...`). The installer (`tools/install.sh`) used `$SOURCE_DIR/skills` instead of `$REPO_ROOT/skills`. The conductor-code-decomposition skill referenced `~/.agents/skills/` (outdated). **Resolution:** T03 fixed all of these — link prefixes corrected, installer path updated, outdated reference replaced.

- **Blocking 2 — PROJECT_SUMMARY stale:** The `## Current status` section did not describe the root-level skills directory, linked skill tables, or current state. Agent classifications were missing. **Resolution:** T04 updated PROJECT_SUMMARY with current-state coverage, added classification labels, and included the `linked skill tables` marker.

- **Warning 1 — Reviewer category wording:** `Primary + Subagent` terminology should be `Both` for consistency. **Resolution:** T04 changed all three index files to use `Both`.

- **Warning 2 — Deployable guidance still coding-centric:** The README installation paragraph still referenced `agents/skills/`. **Resolution:** T03/T04 updated the installation paragraph and the "What's inside" block to reference root-level `skills/`.

- **Warning 3 — Landing page still coding-centric:** `agents/AGENTS.md` heading was `## Spec-Driven Workflow (how we work)` and the body did not acknowledge non-coding work. **Resolution:** T04 broadened the heading and body to frame spec-driven coding as one supported capability within the broader framework.

- **Suggestion 1 — Add link validation:** The reviewer suggested adding a link-validation mechanism. **Resolution:** Not implemented — verification already covers link resolution relative to each containing file, which is sufficient.

**Round 2 findings (after `ee45736`):**

- **Warning 1 — Stale current-practice sentence in `docs/workflow/philosophy.md`:** The sentence "current practice focuses on code implementation" did not reflect the expanded scope. **Resolution:** T05 updated it to "current practice is increasingly focused on expanding toward reliable non-coding long-horizon work, while specification-driven coding is already relatively mature."

- **Warning 2 — Incomplete PROJECT_SUMMARY skill coverage:** Only 4 of 7 general skills were listed in the `## What agents/AGENTS.md covers` section. **Resolution:** T05 added the three missing skills (`init-project`, `specification-methodology`, `todo-list`).

No third review was required because no critical or blocking findings remained after Round 2. The final verifier passed and the committer reported a clean tree.

## Escalation Summary

Three verification failures occurred during the run, all resolved without escalation beyond the first-tier diagnosis:

1. **T01 Phase 1 failure:** The verifier expected the literal `Current goals` (lowercase `g`) but the executor had written `Current Goals` (capitalized). The failure was diagnosed directly by the conductor; a simple capitalization fix was applied. Verification passed on re-run.

2. **T02 Phase 1 failure:** The verifier resolved links relative to the repository root, but `agents/AGENTS.md` links (e.g., `skills/coding-standards/SKILL.md`) are relative to `agents/`. The conductor corrected the verification to resolve from each document's directory. Verification passed on re-run.

3. **T04 Phase 1 failure:** The verifier expected the literal string `linked skill tables` as a contiguous phrase, but the executor's text had it split across lines due to wrapping. The conductor made the phrase explicit on a single line. Verification passed on re-run.

No escalate1 or escalate2 sub-agents were invoked — the conductor diagnosed and remediated all failures directly.

## Final Summary

All 5 tasks completed successfully across 4 commits (`6a49b09`, `5b7d917`, `ee45736`, `cfac247`). The repository has been broadened from a spec-driven coding workflow into an Agentic Framework for Long-Horizon AI Work. All three index files (README.md, AGENTS.md, agents/AGENTS.md) now have split general/conductor-specific linked skill tables and linked agent tables with invocation classifications (Primary, Subagent, Both). The landing page, philosophy page, and PROJECT_SUMMARY reflect the current maturity of spec-driven coding and the priority on non-coding work. The continuous-improvement feedback loop is documented with `LESSONS_LEARNT.md` references. The installer and all skill/agent paths are consistent with the canonical root-level `skills/` directory. No tags, pushes, or branches were created; the final working tree is clean.