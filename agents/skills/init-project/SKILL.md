---
name: init-project
description: Initialize or inspect a project's `project_context.yaml` configuration file. Use when starting work on a new project, or when the agent reports that `project_context.yaml` is missing or incomplete.
allowed-tools: Read, Glob, Edit, Write, Bash, Question
---

# Init Project

Use this skill when setting up an agent session for a new project, or when
`project_context.yaml` is missing/invalid. Follow the steps below in order.

This skill creates `project_context.yaml` from the embedded template below.
The template is self-contained — no external file is needed.

## Step 1 — Check if `project_context.yaml` exists

Look for `project_context.yaml` in the project folder (workspace root). If it
already exists, load it and verify each section is filled in (skip to Step 3).
If it is missing, create it with the template content below.

## Embedded Template

When creating the file, use this exact content (fill in the values via Step 2):

```yaml
# project_context.yaml
# Project-specific paths, credentials, and commands for AI agents.
# Fill in the blanks below. Never hard-code these values in code or docs.

project:
  name:                             # Human-readable project name
  description:                      # One-line description

layout:
  source_dir:                       # Source code directory, e.g. "src"
  docs_dir:                         # Docs directory, e.g. "docs"
  summary_file: PROJECT_SUMMARY.md

spec:
  docs_repo:                        # Path or URL of the documentation repo
  customer_facing_dir:              # Dir holding <epic>_SPEC.md and <epic>_TESTS.md
  current_tag:                      # Spec freeze tag, e.g. "spec-260513"

commands:
  install:                          # e.g. "npm install" / "pip install -e ."
  build:                            # e.g. "npm run build"
  lint:                             # e.g. "ruff check ."
  typecheck:                        # e.g. "mypy ."
  format:                           # e.g. "ruff format ."
  test:                             # e.g. "pytest"

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
    config_ini:                     # Odoo connection config file
  database:
    default_name:                   # e.g. "odoo_test"
    user:                           # e.g. "odoo17"
    host: localhost
    port: 5432
    password:                       # leave blank if no password
  qa_instance:
    config_ini:                     # Credentials file (gitignored)
    url:                            # e.g. "https://qa.example.com"
  modules:
    # - name: my_module
    #   path: my_addons/my_module
    #   depends: [base, stock]
```

## Step 2 — Ask the user to fill in values

Ask **one question at a time** using the `Question` tool. Do not batch.

Ask about (in order):

1. **Project name** — Human-readable name (e.g. "Gulli Foods barcode suite").
2. **Description** — One-line description.
3. **Source dir** — Directory holding the source code (e.g. `src`).
4. **Docs dir** — Directory holding project docs (e.g. `docs`).
5. **Is this an Odoo project?** — If yes, also ask for the Odoo-specific values
   below. If no, remove the whole `odoo:` section from the file.

If Odoo:
6. **Odoo version** (e.g. `17`).
7. **Odoo base source path**.
8. **Odoo enterprise source path** (or blank).
9. **Database name**.
10. **Database user**.
11. **Start script path**.
12. **Test script path**.

## Step 3 — Edit and verify

After each answer, use `Edit` or `Write` to fill the value into
`project_context.yaml`. Once all values are filled:

- Read the final file and confirm every relevant field has a value.
- If non-Odoo, confirm the `odoo:` block has been removed.
- Confirm the file is valid YAML (no obvious quoting/syntax issues).

## Step 4 — Done

Report to the user that `project_context.yaml` is ready. Summarise the key
values configured so the user can confirm at a glance.
