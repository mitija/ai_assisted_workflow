---
name: init-project
description: Initialize or inspect a project's `project_context.yaml` configuration file. Use when starting work on a new project, or when the agent reports that `project_context.yaml` is missing or incomplete.
allowed-tools: Read, Glob, Bash, Edit, Write, Question
---

# Init Project

Use this skill to create or repair `project_context.yaml`. The workflow is
**scan first, ask last** — infer as much as possible from the filesystem and
only ask the user for values that cannot be discovered.

---

## Step 1 — Scan the workspace

Run these checks **before** asking the user anything:

| What to look for | How to check | What to infer |
|---|---|---|
| `project_context.yaml` already exists | `Glob("project_context.yaml")` | Load it; skip to Step 3 |
| `project_context.template.yaml` | `Glob("project_context.template.yaml")` | Use as baseline if present |
| `docs/` directory | `Glob("docs/**", limit=1)` | `layout.docs_dir = "docs"` |
| `src/` directory | `Glob("src/**", limit=1)` | `layout.source_dir = "src"` |
| Other common source dirs (`app/`, `addons/`, `odoo-*/`) | `Glob(...)` | Set `layout.source_dir` accordingly |
| `*.git` remote URL | `Bash("git remote get-url origin")` | Derive project name from repo slug |
| `package.json` | `Read("package.json")` | Infer `project.name`, JS commands |
| `pyproject.toml` / `setup.cfg` | `Read(...)` | Infer Python commands |
| `odoo_config.ini` / `scripts/odoo_config.ini` | `Glob("**/*odoo*config*.ini")` | Odoo project; record path |
| `run_tests.sh` / `start_odoo*.sh` | `Glob("**/*.sh")` | Fill `odoo.scripts.*` |
| `PROJECT_SUMMARY.md` | `Glob("PROJECT_SUMMARY.md")` | Use as-is for `layout.summary_file` |

Also note which directories exist at the workspace root — this reveals the
`docs/` / `src/` / `local/` skeleton described in AGENTS.md.

---

## Step 2 — Create the directory skeleton and `.gitignore` if missing

If the standard subdirectories (`docs/`, `src/`, `local/`) are absent and this
looks like a fresh project, create them silently:

```
docs/
docs/customer-facing/
docs/working/
src/
local/
```

Use `Bash("mkdir -p ...")` for each missing directory. Do **not** create them
if the project already has a different layout.

### Initialize `.gitignore`

If `.gitignore` does not exist at the workspace root, create it with sensible
defaults. Append to it (do not overwrite) if it already exists but is missing
these entries:

```gitignore
# Project context (contains local secrets/paths)
project_context.yaml

# Unversioned scratch material
local/

# Odoo config files (contain DB credentials)
*odoo_config*.ini
*odoo-qa*.ini

# Python
__pycache__/
*.py[cod]
*.egg-info/
dist/
build/
.venv/
venv/

# Node
node_modules/

# OS
.DS_Store
Thumbs.db

# IDE
.idea/
.vscode/
*.swp
```

Only add entries that are not already present. For non-Odoo projects, omit the
Odoo-specific lines. For non-Python/Node projects, omit those sections.

---

## Step 3 — Write `project_context.yaml` with discovered defaults

Create (or update) `project_context.yaml` using the template below, substituting
every value you discovered in Step 1. Leave a field blank (empty value) only
when it genuinely cannot be inferred — do **not** ask the user for it yet.

```yaml
# project_context.yaml
# Project-specific paths and commands for AI agents.
# Never hard-code these values in code or docs.

project:
  name:                             # Human-readable project name
  description:                      # One-line description

layout:
  source_dir:                       # e.g. "src"
  docs_dir:                         # e.g. "docs"
  summary_file: PROJECT_SUMMARY.md

spec:
  docs_repo:        ./docs
  customer_facing_dir: ./docs/customer-facing
  current_tag:                      # Spec freeze tag, e.g. "spec-260513"

commands:
  install:                          # e.g. "npm install" / "pip install -e ."
  build:                            # e.g. "npm run build"
  lint:                             # e.g. "ruff check ."
  typecheck:                        # e.g. "mypy ."
  format:                           # e.g. "ruff format ."
  test:                             # e.g. "pytest"
```

If this is an Odoo project (detected by the presence of `odoo_config.ini` or
Odoo shell scripts), append the Odoo block:

```yaml
# ---------------------------------------------------------------------------
# Odoo-specific section. Remove this whole block for non-Odoo projects.
# ---------------------------------------------------------------------------
odoo:
  version:                          # e.g. "17"
  source:
    base:                           # Odoo base source path
    enterprise:                     # Enterprise source path (or blank)
  scripts:
    start:                          # Odoo launcher wrapper path
    run_tests:                      # Test wrapper path
    config_ini:                     # Path to odoo_config.ini (gitignored)
  modules:
    # - name: my_module
    #   path: my_addons/my_module
    #   depends: [base, stock]
```

---

## Step 4 — Ask only for what is still blank

Read the file you just wrote and collect every field that is still empty.
Ask the user **one question at a time** using the `Question` tool. Do not
batch unrelated questions.

Suggested order for remaining gaps:

1. **Project name** — if not inferred from git/package.json.
2. **Description** — one line.
3. **Source dir** — if not inferred.
4. **Docs dir** — if not inferred.
5. **Is this an Odoo project?** — only if there was no Odoo signal in Step 1.
   - If yes and `config_ini` path is still blank: ask for it.
   - If yes: Odoo version, base source path, enterprise path, scripts paths.
6. **Build/lint/test commands** — if not inferred from `package.json` /
   `pyproject.toml`. For Odoo projects, skip `commands.test` — it is already
   covered by `odoo.scripts.run_tests` collected in step 5.

After each answer, immediately write it into the file with `Edit`.

---

## Step 5 — Verify and report

- Read the final file; confirm no required field is empty.
- Confirm valid YAML (no obvious quoting/syntax errors).
- For Odoo projects, confirm `odoo:` block is present; for non-Odoo, confirm
  it has been removed.
- Report to the user: list the key values configured so they can confirm at a
  glance. Flag any fields left blank (e.g. `current_tag`) and why.
