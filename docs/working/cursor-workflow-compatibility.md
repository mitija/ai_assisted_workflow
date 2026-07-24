# Cursor Workflow Compatibility Analysis

**Date:** 2026-07-24
**Scope:** What would need to change for this repo's OpenCode-specific agent/skill/workflow architecture to work on Cursor.
**Methodology:** Repository inspection (agent definitions, skill files, config, install scripts) compared against authoritative Cursor capabilities observed from cursor.com/features, product changelog, and known Cursor architecture. Where Cursor docs are client-side rendered and could not be extracted verbatim, assumptions are explicitly labelled.

---

## 1. Architecture Mapping

### OpenCode primitives used by this repo

| OpenCode primitive | How this repo uses it | Cursor equivalent |
|---|---|---|
| File-based agent definitions (`agents/agent/*.md` with YAML frontmatter) | Agent roles, permissions, prompts discovered from `~/.config/opencode/agent/` | YAML frontmatter markdown not supported. Cursor uses `.cursorrules` / `.cursor/rules/` for system prompts. |
| `opencode.json` (per-agent model assignments + provider config) | Maps each sub-agent to a specific LLM (e.g. conductor → GPT-5.6-luna, committer → DeepSeek) | **No equivalent.** Cursor allows model selection per session but not per-role assignment within a single agent. |
| `skill` tool + `conductor-*` skill files (SKILL.md with YAML frontmatter) | Phase-by-phase instruction injection loaded on demand from `~/.config/opencode/skills/` | **No equivalent.** Cursor has `.cursor/rules/` for static system prompts but no runtime skill-loading mechanism. |
| Sub-agent invocation (`task` tool with agent name) | Conductor spawns `general`, `verifier`, `committer`, `explore`, `reviewer`, `escalate1`, `escalate2` as sub-agents | **No native sub-agent framework.** Cursor's Agent mode is a single loop; it does not support orchestrated sub-agent spawning with differentiated roles/permissions. |
| Permission system (`permission.bash`, `permission.edit`, `permission.task`) | Granular per-agent permissions (e.g. verifier: `edit: deny, task: deny, bash: allow`; escalate1: bash allowlist) | **No equivalent.** Cursor has no per-agent permission model. The Agent has `bash: allow` by default with no granular control. |
| Frontmatter `mode: primary \| subagent \| all` | Determines invocation style (primary agent, subagent-only, or both) | **No equivalent.** Cursor has no agent mode taxonomy. |

### How the conductor workflow relies on OpenCode specifics

1. **Skill loading** — Phase transitions (`conductor-analyze` → `conductor-code-decomposition` → `conductor-execute` → ...) use the `skill` tool to inject markdown instructions dynamically.
2. **Task graph execution** — Phase 3 spawns one `general` sub-agent per ready task **in parallel** via `task` tool calls, then delegates verification to `verifier` sub-agents.
3. **Escalation chain** — Phase 5 invokes `escalate1` and `escalate2` as distinct sub-agent roles, each with different allowed commands.
4. **Committer isolation** — Commits are handled by a dedicated `committer` sub-agent with `edit: allow, bash: allow`.
5. **Reviewer isolation** — The `reviewer` agent has `edit: deny` and a curated bash allowlist; it delegates to `verifier` for commands outside its allowlist.

---

## 2. What Ports Directly

| Component | Portability | Notes |
|---|---|---|
| **Content of `AGENTS.md`** (workflow rules, conventions, DoD) | **Direct** | Plain markdown. Drop into project root. Cursor respects `.cursorrules` in the project root — AGENTS.md could be referenced or its content merged. |
| **General skills** (`coding-standards`, `handover`, `init-project`, `specification-methodology`, `test-scenarios`, `todo-list`) | **Direct** (as static documents) | The *content* is plain markdown and readable by any LLM. The `skill`-tool-based loading mechanism does not port, but the documents can be read/grepped by the Cursor agent. |
| **`project_context.template.yaml`** | **Direct** | YAML config for project-specific values. Cursor agents can read it the same way. |
| **Methodology documentation** (`docs/`, `docs/workflow/`) | **Direct** | Plain markdown, fully portable. |
| **Workspace conventions** (two-repo model, minimal diff, blocker protocol) | **Direct** | These are workflow rules, not tool-specific. Enforceable via `.cursorrules`. |

---

## 3. What Needs Redesign

### 3.1 Agent definitions (YAML frontmatter → `.cursorrules`)

**Files affected:** `agents/agent/*.md`

OpenCode discovers agents from `~/.config/opencode/agent/` by parsing YAML frontmatter. Cursor has no equivalent discovery mechanism. The conductor's instruction content must be migrated into one or more `.cursorrules` files under `.cursor/rules/`.

**Redesign scope per file:**

| Agent file | Cursor target | Notes |
|---|---|---|
| `conductor.md` (115 lines) | `.cursor/rules/conductor-rules.md` | Split into a system-level rule. The `mode: primary` and permission YAML frontmatter are discarded. The prompt body (workflow, sub-agent instructions, rules) becomes the rule content. |
| `committer.md` (87 lines) | `.cursor/rules/committer-rules.md` | Discard `mode: subagent` and YAML permissions. The commit workflow instructions become a rule the agent follows. |
| `reviewer.md` (170 lines) | `.cursor/rules/reviewer-rules.md` | The detailed findings classification, task list format, and constraints become a rule. |
| `verifier.md` (96 lines) | `.cursor/rules/verifier-rules.md` | The strict PASS/FAIL/BLOCKED protocol becomes a rule. |
| `escalate1.md` (96 lines) | `.cursor/rules/escalate1-rules.md` | Diagnostic workflow becomes a rule. |
| `escalate2.md` (105 lines) | `.cursor/rules/escalate2-rules.md` | Deep-dive diagnostic workflow becomes a rule. |

**Assumption:** Cursor's `.cursor/rules/` directory supports multiple rule files with glob/file-pattern triggers (observed from Cursor changelog referencing "Rules" and "`.cursorrules`"). The exact file-watching and rule-combination semantics could not be verified — the docs site is client-side rendered.

### 3.2 Skill loading mechanism

**Files affected:** `skills/conductor-*/SKILL.md` (6 files)

OpenCode's `skill` tool injects skill instructions into the conversation dynamically. Cursor has **no runtime skill loading API**. The conductor-specific skills must be:

- Converted to static `.cursor/rules/` files (same approach as agent definitions).
- Or embedded directly into the conductor's prompt/rule as inline sections, losing the on-demand granularity.

**Recommendation:** Inline all six conductor skill documents into a single `.cursor/rules/conductor-skills.md` file. The conductor (in prompt instructions) would be told to read relevant sections from this file at each phase. This preserves the content but loses the dynamic-load ergonomic.

### 3.3 Sub-agent architecture

**This is the largest redesign area.** OpenCode's sub-agent model (differentiated roles, `task` tool, permission boundaries, parallel spawning) has no Cursor counterpart. Cursor agent mode runs a single self-contained loop.

**Required redesign:** Replace all sub-agent delegation with sequential prompt-engineering within a single agent loop:

| OpenCode pattern | Cursor replacement |
|---|---|
| `conductor` spawns `general` sub-agents in parallel | Single Cursor Agent processes one task at a time. Parallel execution is not possible. |
| `conductor` delegates verification to `verifier` sub-agent | The agent runs verification commands itself (same loop). |
| `conductor` delegates commits to `committer` sub-agent | The agent runs `git add`/`git commit` itself within its own loop. |
| Escalation via `escalate1` → `escalate2` chain | The agent self-diagnoses failures (same single context). No tiered escalation possible. |
| `conductor` delegates report writing to `general` sub-agent | The agent writes reports itself. |
| `reviewer` delegates to `verifier` for commands outside its allowlist | The reviewer runs those commands itself (no permission boundaries). |

**Impact:** The conductor's core architectural pattern — "you own the thinking, never do mechanical work yourself, delegate everything to sub-agents" — is **not preservable**. On Cursor, the agent necessarily *does* both the thinking and the mechanical work in a single context. The conductor's role collapses into a long system prompt directing a single agent through phases, but without the parallel execution, tiered escalation, or permission boundaries.

### 3.4 Permission system

OpenCode's fine-grained permission model (`edit: deny`, `bash: allow` with glob patterns, `task: allow` with agent-level filtering) has **no Cursor equivalent**. Cursor's Agent has blanket `bash: allow` and `edit: allow` with no per-role or per-operation restrictions.

**Impact:** The safety guarantees that agents like `reviewer` (edit: deny, curated bash allowlist) and `escalate1` (same) rely on are lost. Mitigation is prompt-enforced only — rely on the LLM to respect role boundaries rather than technical enforcement.

### 3.5 Model assignments and per-agent routing

**Files affected:** `opencode.json`

OpenCode's `agent: { conductor: { model: "..." }, ... }` assigns different models per role (expensive model for conductor/reviewer/escalate2, cheap model for committer/general/verifier). Cursor lets the user pick one model per session/chat. There is no mechanism to route different "sub-agents" to different models.

**Impact:** Cost optimization via model-tiering is lost. Everything runs on the user's chosen Cursor model. The recommendation pattern of "conductor on premium, committer on cheap" cannot be preserved.

---

## 4. What Cannot Be Preserved Exactly

| Feature | Preservable? | Reason |
|---|---|---|
| Parallel sub-agent execution | **No** | Cursor Agent is single-threaded. No `task` tool for parallel delegation. |
| Tiered escalation (escalate1 → escalate2) | **No** | Single context — cannot reset between escalation tiers. The agent self-diagnoses everything in one conversation. |
| Per-role model assignment | **No** | Cursor uses one model per session. |
| Granular permission boundaries | **No** | Cursor has no per-agent permission model. |
| Dynamic skill loading via `skill` tool | **No** | No runtime API for injecting external instructions. |
| `mode: subagent` restriction | **No** | Cursor has no subagent/primary distinction. Agent behavior is uniform. |

---

## 5. Recommended Phased Migration

### Phase 1 — Document port (minimal effort, high value)

1. Copy `AGENTS.md` content to `.cursorrules` (project root) — Cursor reads this automatically at session start.
2. Copy or symlink `project_context.yaml` — Cursor can read it.
3. The spec-driven methodology documents (`docs/`, `docs/workflow/`) are already portable markdown.
4. General skills remain accessible as documents the agent can reference.

**Outcome:** The workflow *rules* work. The conductor's orchestration does not.

### Phase 2 — Conductor-as-single-agent (medium effort)

1. Flatten all `agents/agent/*.md` prompt bodies into `.cursor/rules/` files.
2. Flatten all `skills/conductor-*/SKILL.md` into `.cursor/rules/conductor-skills.md`.
3. Rewrite `conductor.md` prompt body to instruct a single Cursor Agent to:
   - Self-navigate through phases (read the conductor-skills rule at each phase boundary instead of loading via `skill` tool).
   - Execute tasks sequentially (no parallel sub-agents).
   - Self-verify (no `verifier` sub-agent).
   - Self-diagnose on failure (no escalation chain).
   - Self-commit (no `committer` sub-agent).

**Outcome:** A single-agent conductor workflow that preserves the phase structure, task graph, and verification discipline.

### Phase 3 — Cursor-specific optimizations (optional)

1. Explore Cursor-specific features to recover lost capabilities:
   - **[Assumption]** Cursor may have MCP (Model Context Protocol) support — if so, an MCP server could provide skill-injection or sub-agent-like endpoints.
   - **Cursor Automations** — periodic/scheduled tasks could replace some escalation patterns.
   - **Cursor Code Review** — the built-in review feature could partially replace the `reviewer` agent, but without the structured findings/task-list format.
2. Create Cursor-specific rules that exploit its strengths (e.g., tighter IDE integration, terminal awareness, file watching).

---

## 6. File-by-File Change Map

| File | Action for Cursor | Notes |
|---|---|---|
| `agents/AGENTS.md` | **Convert to `.cursorrules`** | Drop into project root. Cursor auto-loads. |
| `agents/agent/conductor.md` | **Convert to `.cursor/rules/conductor-rules.md`** | Remove YAML frontmatter. Adapt prompt body for single-agent execution. Remove all sub-agent delegation patterns. |
| `agents/agent/committer.md` | **Convert to `.cursor/rules/committer-rules.md`** | Remove YAML frontmatter. The single agent follows these commit rules directly. |
| `agents/agent/reviewer.md` | **Convert to `.cursor/rules/reviewer-rules.md`** | Remove YAML frontmatter & permission section. The single agent follows review format directly. |
| `agents/agent/verifier.md` | **Convert to `.cursor/rules/verifier-rules.md`** | Remove YAML frontmatter. The single agent uses the PASS/FAIL/BLOCKED format internally. |
| `agents/agent/escalate1.md` | **Convert to `.cursor/rules/escalate1-rules.md`** | Remove YAML frontmatter. Diagnostic workflow becomes inline guidance for the single agent. |
| `agents/agent/escalate2.md` | **Convert to `.cursor/rules/escalate2-rules.md`** | Remove YAML frontmatter. Deep-dive workflow becomes inline guidance. |
| `skills/conductor-analyze/SKILL.md` | **Inline into `.cursor/rules/conductor-skills.md`** | No dynamic loading; the agent reads the relevant section. |
| `skills/conductor-code-decomposition/SKILL.md` | **Inline into `.cursor/rules/conductor-skills.md`** | Same. |
| `skills/conductor-noncode-decomposition/SKILL.md` | **Inline into `.cursor/rules/conductor-skills.md`** | Same. |
| `skills/conductor-execute/SKILL.md` | **Inline into `.cursor/rules/conductor-skills.md`** | Remove parallel-spawning instructions. Adapt for sequential execution. |
| `skills/conductor-escalate/SKILL.md` | **Inline into `.cursor/rules/conductor-skills.md`** | Remove sub-agent escalation chain. Adapt for self-diagnosis. |
| `skills/conductor-report/SKILL.md` | **Inline into `.cursor/rules/conductor-skills.md`** | Add instruction to delegate report-writing via single-agent read/write. |
| `opencode.json` | **Discard** | Per-role model assignment not portable to Cursor. |
| `tools/install.sh` | **Discard** | Symlinks target OpenCode-specific directories. Not applicable to Cursor. |
| General skills (7 SKILL.md files) | **Leave as-is or convert to `.cursor/rules/`** | Content portable. Decide per skill whether the agent should auto-load it (→ `.cursor/rules/`) or reference it on demand. |
| `docs/` | **No change** | Methodology documentation is portable markdown. |

---

## 7. Summary Assessment

| Dimension | Verdict |
|---|---|
| **Workflow rules** (spec-driven methodology, conventions, DoD) | **Fully portable** via `.cursorrules` |
| **Methodology documentation** | **Fully portable** as plain markdown |
| **Conductor phase structure** (Analyze → Decompose → Execute → Review → Escalate → Report) | **Partially portable** — phase *concept* preserves; sub-agent delegation, parallel execution, and escalation chain are lost |
| **Skill library** (general skills content) | **Partially portable** — content readable; dynamic loading mechanism lost |
| **Agent definitions** (YAML frontmatter agents) | **Not portable** — must be rewritten as `.cursor/rules/` |
| **Parallel execution** | **Not portable** — Cursor Agent is single-threaded |
| **Permission boundaries** | **Not portable** — no Cursor equivalent |
| **Per-role model assignment** | **Not portable** — single model per Cursor session |
| **Sub-agent orchestration** | **Not portable** — no sub-agent framework in Cursor |
| **`tools/install.sh`** | **Not applicable** — OpenCode-specific symlink setup |

### Key irreducible gap

The conductor pattern — "one premium model directs work, delegates mechanical tasks to cheap sub-agents in parallel" — is **fundamentally an OpenCode-specific architecture** that cannot be replicated on Cursor without either (a) a custom MCP server that implements sub-agent delegation against a multi-model backend, or (b) accepting a flattened single-agent workflow where the same model does both planning and execution, sequentially.

**(Assumption)** Cursor MCP server support, if available, could partially bridge this gap by providing a sub-agent-like abstraction over remote API calls. This was not verifiable from Cursor's client-rendered docs and should be checked against current Cursor MCP documentation.