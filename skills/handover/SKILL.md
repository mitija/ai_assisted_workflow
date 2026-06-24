---
name: handover
description: Creates a self-contained HANDOVER-xx.md at the end of a session so the next chat session (or another agent) can pick up work immediately with no access to the previous conversation. This skill is user-triggered — it is never loaded automatically.
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, Question
---

# Handover Skill

**User-triggered only** — this skill is never loaded automatically. Call it explicitly
at the end of a work session to produce a **handover document**
(`HANDOVER-<NN>.md`) that is fully self-contained. The next assistant to open
a chat is assumed to have **zero access to this conversation** — the document
must be enough to continue working immediately.

---

## When to use

- Ending a session with remaining work.
- Handing off to another agent or person.
- Documenting context before a break or context-window limit.
- Creating an onboarding document for a new contributor.

## When NOT to use

- For a simple one-shot task that completed fully.
- When the next step is obvious from project state alone (no ambiguity).
- For changelogs or release notes — those are separate documents.

---

## Instructions

### 0. Determine the file number

Before writing, check what HANDOVER files already exist:

```
Glob("HANDOVER-*.md")
```

Identify the highest number used (e.g. if `HANDOVER-03.md` exists, next is `04`).
If none exist, start with `HANDOVER-00.md`.

### 1. Gather context

Collect the information you need by scanning the project:

- **Project goal** — read `PROJECT_SUMMARY.md` and the workspace-root
  `AGENTS.md` for the high-level purpose.
- **Current implementation status** — from `PROJECT_SUMMARY.md` and recent
  git log (`git log --oneline -10`).
- **Important files** — list key files and what they contain. Use Glob and Grep
  to ensure the list is accurate.
- **Recent changes** — `git log --oneline -10` and `git diff --stat` for the
  current working tree.
- **Key decisions** — from the conversation or `PROJECT_SUMMARY.md` design notes.
- **Constraints / conventions** — from `AGENTS.md`, `PROJECT_SUMMARY.md`, and
  repo-specific guidance files.
- **Commands / test results** — recall what was run and what the outcomes were.
  If available, note specific pass/fail counts.
- **Known issues / bugs / risks** — blockers, broken tests, open questions.
- **Pending tasks** — what remains, in priority order, with recommended next
  steps.

### 2. Write the document

**Rules:**

1. **Self-contained.** Assume the reader has never seen the conversation. Spell
   out context explicitly.
2. **Actionable.** Every section ends with what the next agent should do or
   check.
3. **Concise but complete.** Enough detail to continue, not a transcript.
4. **State facts, not narrative.** No "we discussed X then Y". Instead: "X was
   decided; Y was rejected because Z."
5. **Reference files by path** with line numbers where helpful.
6. **No secrets.** Never include credentials, API keys, or `project_context.yaml`
   values.
7. **One counter per session.** If `HANDOVER-03.md` exists and this session
   produces the next one, it is `HANDOVER-04.md`.

**Template:**

```markdown
# HANDOVER-<NN>

**Created**: <YYYY-MM-DD>
**Session summary**: <one-line description of what this session accomplished>
**Previous handover**: <HANDOVER-NN.md or "None">

---

## Project goal

<1–3 paragraphs. What is the project? What problem does it solve?>

## Current implementation status

<Where are we right now? What is working? What phase are we in?>

## Important files

| File | Purpose |
|------|---------|
| `path/to/file` | What it contains / why it matters |
| ... | ... |

## Recent changes

<Bullet list of the key changes made in this session. Include commit messages
if committed, or a summary of uncommitted work.>

## Key decisions and rationale

| Decision | Rationale |
|----------|-----------|
| <What was decided> | <Why this choice over alternatives> |
| ... | ... |

## Constraints, conventions, and architectural preferences

- <Rule 1>
- <Rule 2>
- ...

## Commands / tests already run and results

<Exact commands run and their output summary. Include pass/fail counts.>

## Known issues, bugs, and risks

| Issue | Status | Notes |
|-------|--------|-------|
| <Description> | <Open / Mitigated / Resolved> | <Context or workaround> |

## Pending tasks and recommended next steps

Priority order:

1. **<Task>** — <why it matters and what to do>
2. **<Task>** — ...
```

### 3. Save the file

Write to the workspace root. Verify:

```
ls -la HANDOVER-<NN>.md
```

### 4. Summary output

After saving, provide a brief summary:

```
Handover created: HANDOVER-<NN>.md
```

---

## Quality checklist

- [ ] File is named `HANDOVER-<NN>.md` with the correct next number
- [ ] Every section in the template is filled (or explicitly stated as N/A)
- [ ] No secrets or credentials leaked
- [ ] File paths are accurate (verified with Glob/Read)
- [ ] The document is self-contained — no assumed knowledge from this conversation
- [ ] Pending tasks are ordered by priority
- [ ] Known issues include status and workaround notes
