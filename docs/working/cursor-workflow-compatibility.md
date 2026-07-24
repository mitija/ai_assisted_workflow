# Cursor Workflow Compatibility Analysis

**Date:** 2026-07-24
**Scope:** What would need to change for this repo's OpenCode-specific agent/skill/workflow
architecture to work on Cursor. Assessed against Cursor's current documented feature set as of
the date above. Official Cursor documentation is referenced at:
- https://docs.cursor.com/getting-started (general documentation home)
- https://docs.cursor.com/agent (agent features, rules, subagents, skills)
- https://docs.cursor.com/agent/models (model selection and pricing)
- https://www.cursor.com/features (product overview)
- https://cursor.com/docs/rules.md
- https://cursor.com/docs/subagents.md
- https://cursor.com/docs/skills.md
- https://cursor.com/docs/models-and-pricing.md
- https://cursor.com/docs/cloud-agent.md

**Methodology:** Repository inspection (agent definitions, skill files, config, install scripts)
compared against current Cursor documentation. Where features depend on plan tier, version, or
surface availability this is noted. The docs.cursor.com site is client-side rendered and could
not be scraped verbatim at every URL; specific feature details are triangulated from the product
landing page, changelog, and forum.

---

## 1. Architecture Mapping

### OpenCode primitives used by this repo

| OpenCode primitive | How this repo uses it | Cursor equivalent |
|---|---|---|
| File-based agent definitions (`agents/agent/*.md` with YAML frontmatter) | Agent roles, prompts, permissions discovered from `~/.config/opencode/agent/` | `.cursor/agents/*.md` with YAML frontmatter (`name`, `description`, `model`, `readonly`, optional `is_background`). Subagents are invoked by name via `/` commands or `@` references. OpenCode's `mode` field (primary/subagent/all) maps to invocation convention; permission frontmatter does not translate. |
| `opencode.json` (per-agent model assignments + provider config) | Maps each sub-agent to a specific LLM (conductor → GPT-5.6-luna, committer → DeepSeek, etc.) | Per-subagent `model` in `.cursor/agents/*.md` frontmatter using Cursor model IDs or `inherit`. Provider routing (OpenRouter vs direct API) is not directly portable — see §3.5. |
| `skill` tool + `conductor-*` skill files (SKILL.md with YAML frontmatter) | Phase-by-phase instruction injection loaded on demand | `.cursor/skills/<name>/SKILL.md` with `name`/`description` frontmatter. Skills are invoked via `/skill-name` in chat or set as always-on. OpenCode's automatic on-load mechanics differ but the same skill-markup format and file-based discovery are supported. |
| Sub-agent invocation (`task` tool with agent name) | Conductor spawns `general`, `verifier`, `committer`, `explore`, `reviewer`, `escalate1`, `escalate2` as sub-agents | `.cursor/agents/*.md` definitions invoked via `/agent-name` or `@agent-name`. Supports foreground (blocking) and background (non-blocking) execution. Multiple ready tasks can run in independent sub-agents. |
| Permission system (`permission.bash`, `permission.edit`, `permission.task`) | Granular per-agent allowlists (verifier: `edit: deny, task: deny, bash: allow`; escalate1: curated bash allowlist) | `readonly: true` in agent frontmatter prevents edits. OpenCode's exact command-permission allowlists (`bash: {"git status*": allow, ...}`) have no equivalent. Tool-level read-only gating is the closest approximation. |
| Frontmatter `mode: primary \| subagent \| all` | Determines invocation style | No `mode` taxonomy. Invocation is by explicit command (`/agent-name`), automation trigger, or background/foreground flag. |

### How the conductor workflow relies on OpenCode specifics

1. **Skill loading** — Phase transitions (`conductor-analyze` → `conductor-code-decomposition` → ...)
   use the `skill` tool to inject instructions dynamically. Cursor uses `.cursor/skills/` with
   `/skill-name` invocation or automatic loading; the same phase-by-phase pattern is achievable.
2. **Task graph execution** — Phase 3 spawns one `general` sub-agent per ready task **in parallel**
   via `task` tool calls, then delegates verification to `verifier`. Cursor supports parallel
   background sub-agents for independent tasks.
3. **Escalation chain** — Phase 5 invokes `escalate1` and `escalate2` as distinct sub-agent roles.
   Each is a separate `.cursor/agents/*.md` file with its own prompt and `model`.
4. **Committer isolation** — Commits handled by a dedicated `committer` sub-agent with
   `edit: allow, bash: allow`. Maps to a `.cursor/agents/committer.md` agent.
5. **Reviewer isolation** — The `reviewer` agent has `edit: deny` and a curated bash allowlist.
   Maps to a `.cursor/agents/reviewer.md` agent with `readonly: true`. The allowlist itself
   is prompt-enforced rather than technically gated.

---

## 2. What Ports Directly

| Component | Portability | Notes |
|---|---|---|
| **Root `AGENTS.md`** (workflow rules, conventions, DoD) | **Direct** | Drop into project root. Cursor respects root `AGENTS.md` and/or `.cursor/rules/*.mdc` with valid frontmatter. File-based discovery reads `.cursor/rules/*.mdc`; plain `.md` files inside `.cursor/rules/` are ignored. A symlink or copy from `agents/AGENTS.md` to the project root works directly. |
| **General skills** (`coding-standards`, `handover`, `init-project`, `specification-methodology`, `test-scenarios`, `todo-list`) | **Direct** (as Cursor Agent Skills) | Each maps to `.cursor/skills/<name>/SKILL.md`. Retain canonical OpenCode skills under `skills/`; add symlinks or copies to `.cursor/skills/` for Cursor. |
| **`project_context.template.yaml`** | **Direct** | YAML config readable by any Cursor agent. |
| **Methodology documentation** (`docs/`, `docs/workflow/`) | **Direct** | Plain markdown, fully portable. |
| **Workspace conventions** (two-repo model, minimal diff, blocker protocol) | **Direct** | Enforceable via root `AGENTS.md` or `.cursor/rules/*.mdc`. |

---

## 3. What Needs Redesign

### 3.1 Agent definitions (OpenCode YAML frontmatter → `.cursor/agents/*.md`)

**Files affected:** `agents/agent/*.md` (7 files)

OpenCode discovers agents from `~/.config/opencode/agent/` by parsing YAML frontmatter. Cursor
discovers agents from `.cursor/agents/*.md` (custom subagents feature). The prompt body is
preserved; OpenCode-specific frontmatter fields are translated per the table below.

**Translation per file:**

| OpenCode file | Cursor file | Frontmatter map | Notes |
|---|---|---|---|
| `conductor.md` (115 lines) | `.cursor/agents/conductor.md` | `mode: primary` → no mode field. `permission.edit: deny` → no translation (conductor deny is prompt-enforced). | Prompt body substantially preserved. Sub-agent invocation instructions must reference Cursor `/agent-name` convention. References to `skill` tool → `skill` references or inline reading. |
| `committer.md` (87 lines) | `.cursor/agents/committer.md` | `mode: subagent` → no mode field. `permission.bash: allow, permission.edit: allow` → omitted (allowlist does not translate). | Prompt body preserved. |
| `reviewer.md` (170 lines) | `.cursor/agents/reviewer.md` | `mode: all` → no mode field. `permission.edit: deny` → `readonly: true`. Bash allowlist → omitted. | `readonly: true` provides the edit-protection equivalent. |
| `verifier.md` (96 lines) | `.cursor/agents/verifier.md` | `mode: subagent` → no mode field. `permission.edit: deny, permission.task: deny, permission.bash: allow` → `readonly: true` (partial). | Strict PASS/FAIL/BLOCKED protocol preserved in prompt body. |
| `escalate1.md` (96 lines) | `.cursor/agents/escalate1.md` | Same as reviewer: `permission.edit: deny` → `readonly: true`. Bash allowlist → omitted. | Prompt body preserved. |
| `escalate2.md` (105 lines) | `.cursor/agents/escalate2.md` | Same as reviewer: `permission.edit: deny` → `readonly: true`. Bash allowlist → omitted. | Prompt body preserved. |
| `explore.md` / `general.md` (roles, not files) | `.cursor/agents/general.md`, `.cursor/agents/explore.md` | No existing OpenCode files for these roles — create if separate agent definitions are wanted. | Alternatively use the default Cursor Agent for general tasks. |

**Cursor `name`/`description` fields:** Add a `name` (short label) and `description`
(one-liner) to the frontmatter of each `.cursor/agents/*.md` for `@` and `/` autocompletion.

**Cursor `model` field:** Optional per-agent model assignment using Cursor model IDs or
`inherit` (see §3.5).

**Permission allowlists do not translate.** OpenCode's `bash: {"git status*": allow, ...}`
is enforced by the runtime; Cursor has no equivalent. Use `readonly: true` on review/escalation
agents to prevent edits, and rely on prompt instructions for finer-grained command gating.

### 3.2 Skill loading mechanism

**Files affected:** `skills/conductor-*/SKILL.md` (6 files), `skills/<general>/*/SKILL.md` (7 files)

OpenCode's `skill` tool injects skill instructions into the conversation dynamically. Cursor's
Agent Skills feature (`/skill-name` in chat or always-on configuration) provides the equivalent
mechanism using `.cursor/skills/<name>/SKILL.md` with `name`/`description` frontmatter.

**Migration approach:**

| OpenCode skill | Cursor target | Notes |
|---|---|---|
| `conductor-analyze/SKILL.md` | `.cursor/skills/conductor-analyze/SKILL.md` | Add `name`/`description` frontmatter. Invoked by conductor via `/conductor-analyze` at phase boundary. |
| `conductor-code-decomposition/SKILL.md` | `.cursor/skills/conductor-code-decomposition/SKILL.md` | Same. |
| `conductor-noncode-decomposition/SKILL.md` | `.cursor/skills/conductor-noncode-decomposition/SKILL.md` | Same. |
| `conductor-execute/SKILL.md` | `.cursor/skills/conductor-execute/SKILL.md` | Same. Adapt parallel-spawning instructions for Cursor sub-agent model. |
| `conductor-escalate/SKILL.md` | `.cursor/skills/conductor-escalate/SKILL.md` | Same. |
| `conductor-report/SKILL.md` | `.cursor/skills/conductor-report/SKILL.md` | Same. |
| `coding-standards/SKILL.md` | `.cursor/skills/coding-standards/SKILL.md` | General skill — available via `/coding-standards`. |
| `handover/SKILL.md` | `.cursor/skills/handover/SKILL.md` | Same. |
| `init-project/SKILL.md` | `.cursor/skills/init-project/SKILL.md` | Same. |
| `spec-refinement/SKILL.md` | `.cursor/skills/spec-refinement/SKILL.md` | Same. |
| `specification-methodology/SKILL.md` | `.cursor/skills/specification-methodology/SKILL.md` | Same. |
| `test-scenarios/SKILL.md` | `.cursor/skills/test-scenarios/SKILL.md` | Same. |
| `todo-list/SKILL.md` | `.cursor/skills/todo-list/SKILL.md` | Same. |

**Canonical vs Cursor copies:** Retain the canonical OpenCode skills under `skills/` for
OpenCode compatibility. Add symlinks or copies under `.cursor/skills/` for Cursor. The
install script (`tools/install.sh`) should be extended rather than replaced — add a
Cursor-specific install step or document a manual symlink pattern.

**Rule of thumb:** Keep each skill separate. Do not inline skills into a single file; the
per-skill granularity is preserved and matches Cursor's discovery format.

### 3.3 Sub-agent architecture

**Cursor supports custom subagents** via `.cursor/agents/*.md`. The conductor can spawn
independent agents with differentiated prompts, roles, and optional background execution.
Key mapping:

| OpenCode pattern | Cursor equivalent |
|---|---|
| `conductor` spawns `general` sub-agents in parallel | Independent ready tasks run in parallel background sub-agents (`is_background: true`). Foreground sub-agents are also supported for blocking sequential execution. |
| `conductor` delegates verification to `verifier` sub-agent | Conductor invokes `/verifier` with the verification command. The verifier agent runs the command and reports back. |
| `conductor` delegates commits to `committer` sub-agent | Conductor invokes `/committer` with the commit context. |
| Escalation via `escalate1` → `escalate2` chain | Conductor invokes `/escalate1`; if the result indicates a deeper issue, invokes `/escalate2`. Each has its own agent definition, model, and context. |
| `conductor` delegates report writing to `general` sub-agent | Conductor invokes a general sub-agent or a dedicated report-writing agent. |
| `reviewer` delegates to `verifier` for commands outside its allowlist | Reviewer invokes `/verifier` for commands it cannot run (no permission-gating, but prompt-based). |

**Caveats:**
- **Nesting:** Cursor does not support sub-agents recursively invoking sub-agents the way
  OpenCode does (reviewer → verifier). Each agent runs in its own context and cannot spawn
  further agents from within. The conductor owns all delegation; leaf agents are single-depth.
- **Context isolation:** Each sub-agent invocation starts a fresh context; handover information
  (task prompt, expected outcome, verification criteria) must be included explicitly.
- **Parallelism:** Independent ready tasks can run concurrently, but each requires explicit
  handoff context. There is no shared "task graph" state — the conductor must manage the
  graph and dispatch per-task prompts.

**Overall verdict:** The conductor's core architectural pattern — "you own the thinking,
delegate mechanical work" — is preservable. The phase structure, task graph execution,
verification, escalation chain, and review all map to distinct sub-agent definitions.
The main adjustments are explicit context handover and the single-depth sub-agent limit.

### 3.4 Permission system

OpenCode's fine-grained permission model (`edit: deny`, `bash: allow` with glob patterns,
`task: allow` with agent-level filtering) has **no direct Cursor equivalent**. Cursor's
agent frontmatter supports `readonly: true` (disables all edits) and model assignments, but
not per-command allowlists.

**Impact:**
- `readonly: true` provides the safety guarantee for review/escalation agents (no edits).
- Command-level allowlisting (`git status*: allow`, `grep*: allow`, etc.) is not technically
  enforceable. Rely on the agent prompt to constrain behaviour.
- The `verifier` agent's unrestricted bash (by design) and the trust boundary are the same
  on both platforms — prompt-enforced, not sandboxed.

### 3.5 Model assignments and per-agent routing

**Files affected:** `opencode.json` (partial)

OpenCode's `agent: { conductor: { model: "openrouter/openai/gpt-5.6-luna" }, ... }` assigns
different models per role. Cursor supports per-agent `model` in `.cursor/agents/*.md`
frontmatter using Cursor-specific model IDs (e.g. `gpt-5.6-sol`, `opus-4.8`, `deepseek-v4`,
`inherit` for the session default).

**Mapping:**

| OpenCode agent | OpenCode model | Cursor `model` value (example) |
|---|---|---|
| conductor | `openrouter/openai/gpt-5.6-luna` | `gpt-5.6-sol` or `inherit` |
| reviewer | `openrouter/openai/gpt-5.6-luna` | Same as conductor |
| escalate2 | `openrouter/openai/gpt-5.6-terra` | `gpt-5.6-terra` or `opus-4.8` |
| committer | `openrouter/deepseek/deepseek-v4-flash` | `deepseek-v4` or `inherit` |
| general | `openrouter/deepseek/deepseek-v4-flash` | Same |
| verifier | `openrouter/deepseek/deepseek-v4-flash` | Same |
| explore | `openrouter/deepseek/deepseek-v4-flash` | Same |

**Caveats:**
- Cursor model IDs differ from OpenRouter IDs. Exact names depend on the current Cursor model
  catalogue and may change between versions.
- Provider routing (OpenRouter vs direct API) is a Cursor infrastructure concern; you cannot
  specify a custom provider.
- Model availability may depend on plan tier and admin settings.
- Per-agent model assignment is available but subject to plan limitations.

### 3.6 Optional project rules (`.cursor/rules/*.mdc`)

Cursor supports `.cursor/rules/*.mdc` files with YAML frontmatter (title, description, glob
patterns, alwaysApply) as an alternative or supplement to root `AGENTS.md`. Plain `.md` files
inside `.cursor/rules/` are ignored — only `.mdc` files with valid frontmatter are discovered.

**Usage:** If rule-level conditional activation is desired (e.g. apply Odoo rules only for
`.py` files), use `.cursor/rules/` with appropriate `globs` in frontmatter. For catch-all
workflow rules, root `AGENTS.md` suffices.

---

## 4. Capability Assessment

| Feature | Cursor support | Notes |
|---|---|---|
| Custom sub-agents with YAML frontmatter | **Supported** — `.cursor/agents/*.md` with `name`, `description`, `model`, `readonly`, `is_background` | OpenCode's `mode` taxonomy and permission allowlists do not translate. Prompts are directly portable. |
| Per-subagent model assignment | **Supported** — `model` field in agent frontmatter | Uses Cursor model IDs; provider routing not configurable. |
| Sub-agent foreground/background | **Supported** — `is_background: true/false` | Foreground blocks until completion; background runs concurrently. |
| Parallel sub-agent execution | **Supported** — independent background agents run concurrently | Context must be handed off explicitly per agent. |
| Agent Skills (dynamic instruction injection) | **Supported** — `.cursor/skills/<name>/SKILL.md` with `name`/`description` | Invoked via `/skill-name` or always-on. Same file-format as OpenCode. |
| Root `AGENTS.md` | **Supported** — auto-loaded | Directly portable. |
| `.cursor/rules/*.mdc` (optional project rules) | **Supported** — `.mdc` only, plain `.md` ignored | Valid YAML frontmatter required. |
| `readonly: true` (edit prevention) | **Supported** | Partial equivalent of OpenCode `edit: deny`. |
| Command-level permission allowlists | **Not available** | No per-command or per-glob allowlisting. Prompt-enforced. |
| Provider routing (OpenRouter, custom API) | **Not available** | Cursor manages its own model provider infrastructure. |
| Tool-level permission system (bash/edit/task) | **Not available** | Only `readonly: true` at agent level. |
| `mode: primary/subagent/all` taxonomy | **Not available** | Invocation by explicit name or automation trigger. |
| Sub-agent nesting (recursive depth) | **Not supported** | Sub-agents cannot spawn sub-agents. Conductor manages all delegation depth-1. |
| Dynamic skill loading via `skill` tool | **Partial** — same file format, same directory structure, different invocation mechanics (`/skill-name` vs `skill` tool) | Workflow logic must reference the Cursor invocation pattern. |

---

## 5. Recommended Migration Plan (Additive — retain all OpenCode files)

### Phase 1 — Document port (minimal effort, high value)

1. **Root `AGENTS.md`:** Already in project root. Cursor auto-loads it.
2. **`project_context.yaml`:** Already readable by any agent.
3. **Spec-driven methodology docs** (`docs/`, `docs/workflow/`): Already portable.
4. **Optional:** Create `.cursor/rules/` with `.mdc` files for rule-level conditional
   activation if needed.

### Phase 2 — Add `.cursor/agents/*.md` (sub-agents)

1. Create `.cursor/agents/` directory.
2. For each agent in `agents/agent/*.md`, create a `.cursor/agents/<name>.md`:
   - Translate frontmatter per §3.1.
   - Retain prompt body with Cursor-adjusted invocation references.
   - Add `name` and `description` fields.
3. Set `model` per agent using Cursor model IDs.
4. Set `readonly: true` on `reviewer`, `escalate1`, `escalate2`.
5. For the conductor, update phase-transition instructions to use `/skill-name` and
   `/agent-name` invocations.

### Phase 3 — Add `.cursor/skills/` (Agent Skills)

1. Create `.cursor/skills/` directory.
2. For each skill in `skills/*/SKILL.md`, add a copy or symlink under `.cursor/skills/<name>/SKILL.md`.
3. Add `name` and `description` frontmatter to each Cursor copy.
4. Conductor-specific skills reference each other by `/skill-name`; general skills are
   available via `/skill-name` or always-on.

### Phase 4 — Cursor-specific install documentation

1. Extend `tools/install.sh` or add a Cursor counterpart (`tools/install-cursor.sh`) that:
   - Symlinks or copies `.cursor/agents/` and `.cursor/skills/` into a shared config.
   - Does not modify or remove existing OpenCode install logic.
2. Optionally add `.cursor/rules/*.mdc` files for Odoo-specific or stack-specific rules.

### Phase 5 — Conductor architecture adaptation

1. Update the conductor prompt to manage the task graph explicitly (it already does).
2. Replace `task` tool invocations with `/agent-name` references.
3. Replace `skill` tool invocations with `/skill-name` references.
4. Ensure each sub-agent invocation includes full context — no conversational state shared
   between agents.
5. Adapt the execute phase: spawn independent ready tasks via `/general` or `/explore` in
   background mode, collect results, and proceed.

---

## 6. File-by-File Change Map (Additive)

| File | Action | Notes |
|---|---|---|
| `agents/AGENTS.md` | **Port directly** | Already at project root via symlink/copy. |
| `agents/agent/conductor.md` | **Create `.cursor/agents/conductor.md`** | Translate frontmatter. Update phase instructions for Cursor invocation patterns. |
| `agents/agent/committer.md` | **Create `.cursor/agents/committer.md`** | Translate frontmatter. Prompt body directly portable. |
| `agents/agent/reviewer.md` | **Create `.cursor/agents/reviewer.md`** | Translate frontmatter. Add `readonly: true`. |
| `agents/agent/verifier.md` | **Create `.cursor/agents/verifier.md`** | Translate frontmatter. Add `readonly: true`. |
| `agents/agent/escalate1.md` | **Create `.cursor/agents/escalate1.md`** | Translate frontmatter. Add `readonly: true`. |
| `agents/agent/escalate2.md` | **Create `.cursor/agents/escalate2.md`** | Translate frontmatter. Add `readonly: true`. |
| `skills/conductor-*/SKILL.md` (6 files) | **Create `.cursor/skills/<name>/SKILL.md`** | Add `name`/`description` frontmatter. Adapt for `/skill-name` invocation. |
| `skills/<general>/*/SKILL.md` (7 files) | **Create `.cursor/skills/<name>/SKILL.md`** | Add `name`/`description` frontmatter. Content portable. |
| `opencode.json` | **Retain for OpenCode** | Not ported to Cursor. Per-agent model assignments handled via `.cursor/agents/*.md` frontmatter `model` field. |
| `tools/install.sh` | **Retain for OpenCode** | Add Cursor-specific install documentation or an extended script that also sets up `.cursor/` symlinks. |
| `docs/` | **No change** | Methodology documentation already portable. |

---

## 7. Summary Assessment

| Dimension | Verdict |
|---|---|
| **Workflow rules** (spec-driven methodology, conventions, DoD) | **Fully portable** via root `AGENTS.md` |
| **Methodology documentation** | **Fully portable** as plain markdown |
| **Conductor phase structure** (Analyze → Decompose → Execute → Review → Escalate → Report) | **Substantially portable** — phase concept, sub-agent delegation, and escalation chain map to `.cursor/agents/*.md`; parallel execution for independent tasks is available via background agents |
| **Agent definitions** (YAML frontmatter agents) | **Portable** — translate frontmatter format to `.cursor/agents/*.md`; prompts preserved; `mode` and permissions replaced with Cursor equivalents |
| **Agent Skills** (skill files with dynamic loading) | **Portable** — same file format, directory structure; invocation pattern changes from `skill` tool to `/skill-name` |
| **Per-subagent model assignment** | **Supported** — via `model` field in `.cursor/agents/*.md` using Cursor model IDs |
| **Read-only agents** | **Supported** — via `readonly: true` in agent frontmatter |
| **Parallel execution of independent tasks** | **Supported** — via background sub-agents |
| **Command/tool permission allowlists** | **Not available** — no Cursor equivalent; prompt-enforced |
| **Provider routing (OpenRouter, custom API)** | **Not available** — Cursor manages its own provider infrastructure |
| **Sub-agent nesting (recursive delegation)** | **Not supported** — sub-agents cannot spawn sub-agents |
| **`opencode.json` per-role config** | **Not applicable** — model assignments migrate to `.cursor/agents/*.md` frontmatter; provider config is a Cursor infrastructure concern |
| **`tools/install.sh`** | **Retain for OpenCode** — add Cursor install path alongside, do not replace |

### Key irreducible gaps

1. **Permission allowlists** — OpenCode's `bash: {"git status*": allow, ...}` granularity is
   not available. `readonly: true` provides edit-level protection; command-level gating is
   prompt-enforced only.
2. **Provider routing** — Cursor uses its own model infrastructure. You cannot route through
   OpenRouter or specify custom API endpoints.
3. **Sub-agent nesting** — The conductor must delegate at depth 1; sub-agents cannot
   recursively invoke their own sub-agents.
4. **Discovery/installation semantics** — OpenCode's `~/.config/opencode/agent` file-based
   discovery differs from Cursor's project-local `.cursor/agents/`. The repo's symlink-based
   install script is OpenCode-specific; a Cursor counterpart is a straightforward addition.

The conductor architecture — "one premium model directs work, delegates tasks to differentiated
sub-agents" — is substantially preservable on Cursor. The gaps are in permission enforcement,
provider choice, and nesting depth, not in the orchestration model itself.