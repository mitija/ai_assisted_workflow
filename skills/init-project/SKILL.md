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
local/tmp/
```

If the standard directories already exist (i.e. the project uses the standard
layout) but `local/tmp/` is missing, create only `local/tmp/`:

```
local/tmp/
```

Use `Bash("mkdir -p ...")` for each missing directory. Do **not** create the
standard skeleton or `local/tmp/` if the project already has a different layout.

The `local/tmp/` directory is the project-local location for temporary files;
prefer it over system `/tmp` for project work.

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
# project_context.template.yaml
#
# Copy this file to `project_context.yaml` and fill in the values for your
# local machine / project. `project_context.yaml` should be gitignored.
#
# Agents read this file at the start of a session to discover project-specific
# paths, credentials, and commands. Never hard-code these values in code or docs.

project:
  name:                  # Human-readable project name, e.g. "Gulli Foods barcode suite"
  description:           # One-line description of what this project is

# Where the code and docs live. Adjust to match this project's layout.
layout:
  source_dir:            # Directory holding the source code, e.g. "src" or "odoo-sco-pca"
  docs_dir:              # Directory holding project docs, e.g. "docs"
  summary_file: PROJECT_SUMMARY.md   # File holding current project state (no history)

# Spec-driven workflow: where the specification and tests live (see
# AI_assisted_development_workflow.md). Specs/tests are usually in a separate,
# tagged documentation repo. Agents read these before implementing.
spec:
  docs_repo:             ./docs                   # Path or URL of the documentation repo
  customer_facing_dir:   ./docs/customer-facing   # Dir holding <epic>_SPEC.md and <epic>_TESTS.md
  current_tag:           # Spec freeze tag to implement against, e.g. "spec-260513"

# Generic build / quality commands. Fill in for non-Odoo projects, or in addition
# to the Odoo section below. Agents use configured commands rather than guessing
# or inventing them, and run each applicable check before completion. (Odoo tests
# use odoo.scripts.run_tests instead.)
commands:
  install:               # e.g. "npm install" / "pip install -e ."
  build:                 # e.g. "npm run build"
  lint:                  # e.g. "ruff check ." / "npm run lint"
  typecheck:             # e.g. "mypy ." / "tsc --noEmit"
  format:                # e.g. "ruff format ." / "prettier -w ."
  test:                  # generic test command (Odoo uses odoo.scripts.run_tests)

# ----------------------------------------------------------------------------
# Filesystem boundary (informational — mirrors opencode.json permissions).
# These are paths outside the project root that this project legitimately needs.
# The authoritative access rules live in the project's opencode.json under
# `permission.external_directory`. This section documents what they are and why.
# Agents use this during the permission preflight to detect missing authorizations.
# ----------------------------------------------------------------------------
# filesystem:
# external_paths:
#     - path: /path/to/odoo/source
#       reason: "Odoo runtime for development server"
#     - path: /path/to/shared/lib
#       reason: "Sibling monorepo workspace"

# ----------------------------------------------------------------------------
# Odoo-specific section. Remove this whole block for non-Odoo projects.
# ----------------------------------------------------------------------------
odoo:
  version:               # e.g. "17"

  # Odoo source code (read-only reference)
  source:
    base:                # Base Odoo source, e.g. "/path/to/odoo/17/odoo"
    enterprise:          # Enterprise source, e.g. "/path/to/odoo/17/enterprise"

  # Executable / scripts
  scripts:
    start:               # Odoo launcher wrapper, e.g. "/path/to/odoo/17/start_odoo17.sh"
    run_tests:           # Test wrapper (drops/recreates DB), e.g. "/path/to/odoo/17/run_tests.sh"
    # Connection config for the local dev/test database. All DB credentials
    # (host, port, user, password, dbname) come from this file — do not
    # duplicate them here.
    config_ini:          # e.g. "scripts/odoo_config.ini"  (gitignored)

  # Remote QA instance reachable via XMLRPC for data checks (optional).
  # All connection details (URL, credentials) are read from config_ini below.
  qa_instance:
    config_ini:          # e.g. "scripts/odoo-qa.ini"  (gitignored)

  # Modules maintained in this project (optional, list as needed)
  modules:
    # - name: gullifood_stock_barcode
    #   path: odoo-gulli-foods/gullifood_stock_barcode
    #   depends: [stock_barcode, stock_barcode_mrp, product_multiple_barcodes]
```

The template includes both the generic project sections and the Odoo-specific
section. For non-Odoo projects, remove the entire `odoo:` block.

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

## Step 5 — Initialize filesystem boundary in opencode.json

After `project_context.yaml` is complete, check for and initialize the
`permission.external_directory` block in the project's `opencode.json`:

1. **Locate** `opencode.json` at the project root via `Glob("opencode.json")` or
   `Glob(".opencode/opencode.json")`.
2. **Read** the file and check whether a `permission.external_directory` key
   exists. If it does but is empty or missing project-root-relevant paths, note
   it for the preflight.
3. **If the key is missing**, add an empty `permission.external_directory`
   block to `opencode.json`:
   ```json
   "permission": {
     "external_directory": {
     }
   }
   ```
   Merge it into the existing JSON structure — preserve all existing keys.
4. **Scan** the newly-written `project_context.yaml` for absolute paths outside
   the project root (e.g. Odoo `source.base`, `source.enterprise`, `scripts.*`
   paths, or any `commands.*` that reference external tools by absolute path).
   Extend scanning to also discover paths from:
   - Project config files — `.ini`, `.cfg`, `.env`, and equivalent config files.
   - Environment-variable references — `$HOME`, `$PROJECTS`, or other variables
     used in config, resolved after expansion.
   - Git-linked directories — `git submodule`, `git worktree` locations.
   - Dependency-link targets — `npm link` or equivalent symlinked dependency
     directories.
   - User declaration — any path the user explicitly stated is required.
5. **Normalize** — for each discovered path, perform environment-variable and
    tilde expansion, normalize `.`/`..`, resolve to an absolute path, and
    canonicalize symlinks before classifying it.
 6. **Filter** — reject broad values such as `$HOME`, `~/`, `~/**`, `$PROJECTS`,
    `~/Projects/**`, or a parent workspace directory. Only concrete project-specific
    paths are eligible as authorization candidates.
 7. **Present** any discovered external paths to the user, one at a time, using
    the `Question` tool. For each:
    - Show the path and why it was discovered.
    - Ask whether to add it to `permission.external_directory` as an `"allow"`.
    - If approved, edit it into the JSON block using the glob pattern
      `"<path>/**"` (e.g. `"/opt/odoo/17/**"`).
    - If denied, do not add it.
 8. **Validate** the final JSON is valid and `permission.external_directory`
    contains only the approved paths.

> **Never** add broad patterns like `~/Projects/**` or `~/**`. Only concrete,
> project-specific external paths are permitted.

---

## Step 6 — Verify and report

- Read the final file; confirm no required field is empty.
- Confirm valid YAML (no obvious quoting/syntax errors).
- For Odoo projects, confirm `odoo:` block is present; for non-Odoo, confirm
  it has been removed.
- Report to the user: list the key values configured so they can confirm at a
  glance. Flag any fields left blank (e.g. `current_tag`) and why.
