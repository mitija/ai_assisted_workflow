---
name: init-project
description: Initialize, inspect, migrate, or repair project_context.yaml using evidence-first profile inference while preserving legacy v1 semantics and extensions.
allowed-tools: Read, Glob, Bash, Edit, Write, Question
---

# Init Project

Use this skill when `project_context.yaml` is missing or unusable, or when a
project asks to inspect or migrate it. Scan first and ask last. Do not print
secrets. Use config references for credentials and keep external access
permission-gated.

## Profiles and compatibility

The standalone `agents/project_context.template.yaml` and this embedded
template are the same v2 structure:

```yaml
schema_version: 2
project:
  name:
  description:
profiles:
  selected: []
  inferred: []
  code:
    layout:
      source_dir:
      docs_dir:
      summary_file: PROJECT_SUMMARY.md
    spec:
      docs_repo:
      customer_facing_dir:
      current_tag:
    commands:
      install:
      build:
      lint:
      typecheck:
      format:
      test:
    filesystem:
      external_paths: []
  non_code:
    acceptance:
      criteria: []
      evidence:
    research:
      sources: []
      findings: []
    layout:
      docs_dir:
      summary_file: PROJECT_SUMMARY.md
  odoo:
    version:
    source:
      base:
      enterprise:
    scripts:
      start:
      run_tests:
      config_ini:
    qa_instance:
      config_ini:
    modules: []
extensions: {}
```

`selected` is the active profile set. `inferred` records evidence-derived
signals visibly; the user may correct `selected`. Inactive profiles impose no
fields. Profiles are typed: `code` carries source/spec/commands and optional
filesystem data, `non_code` carries acceptance and research support, and `odoo`
adds Odoo-specific fields. Extensions must be controlled, self-describing, and
preserved unchanged when not understood.

For legacy v1, a missing `schema_version` means v1. Read and preserve the
top-level `project`, `layout`, `spec`, `commands`, `filesystem`, and `odoo`
structures and their meanings. Do not silently reinterpret or discard unknown
keys. Offer migration to v2, retain unknown content under `extensions` only
with the user's agreement, and document the migration result.

## Workflow

1. Inspect `project_context.yaml`, the standalone template, root directories,
   `PROJECT_SUMMARY.md`, package/build metadata, docs/spec files, git remotes,
   Odoo indicators, and relevant configuration. Infer project name, layout,
   commands, and profiles from evidence.
2. If no context exists, create it from the v2 template above. If it exists,
   preserve its schema and unknown fields while repairing only unusable values.
3. Set `profiles.inferred` to the detected signals and ask the user to confirm
   or correct `profiles.selected`. Ask only for missing fields belonging to
   active profiles. A non-code project must not be asked for source, build,
   test, or Odoo fields.
4. Validate active profiles. Check required paths and commands, acceptance
   criteria/evidence for non-code work, spec/tag references for code work, and
   Odoo fields only when `odoo` is active. Record unresolved values explicitly.
5. Discover external paths from active profile data and project configuration.
   Expand variables and `~`, normalize `.`/`..`, resolve absolute paths, and
   canonicalize symlinks before classifying. Reject broad paths and present
   concrete project-specific paths one at a time for permission approval. The
   authoritative allow list is `opencode.json`; never bypass or silently alter
   it.
6. Write the context after each answer. Preserve extensions and unknown fields.
   Ensure literal secrets are absent and references point to protected config or
   environment values.
7. Verify YAML parsing, active-profile validity, legacy preservation where
   applicable, and that the standalone and embedded templates remain
   semantically and structurally synchronized. Report inferred values, blanks,
   compatibility status, and any proposed migration.

The conductor invokes this skill when context is absent or unusable; an
unresolved human choice or permission decision remains a gate, not a reason to
guess.
