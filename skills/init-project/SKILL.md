---
name: init-project
description: Initialize, inspect, convert with approval, or repair valid v2 project_context.yaml using evidence-first profile inference and controlled extensions.
allowed-tools: Read, Glob, Bash, Edit, Write, Question
---

# Init Project

Use this skill when `project_context.yaml` is missing or unusable, or when a
project asks to inspect or repair it. Scan first and ask last. Do not print
secrets. Use config references for credentials and keep external access
permission-gated.

## Profiles and schema

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
adds Odoo-specific fields. Extensions must be controlled and self-describing;
unknown extension keys in valid v2 are preserved unchanged when not understood.

`schema_version: 2` is required and v2 is the only supported schema. Missing or
unsupported versions are unusable. Init may offer explicit reinitialization or
conversion with user approval, but promises no automatic migration or
preservation and never silently interprets an old top-level layout as supported
v2 data.

## Workflow

1. Inspect `project_context.yaml`, the standalone template, root directories,
   `PROJECT_SUMMARY.md`, package/build metadata, docs/spec files, git remotes,
   Odoo indicators, and relevant configuration before writing. Detect the schema:
   only `schema_version: 2` is usable.
2. For valid v2, infer project name, layout, commands, and profiles from evidence.
   Set `profiles.inferred` to those signals, ask the user to confirm or correct
   `profiles.selected`, and write the confirmed active profile selection. Ask
   only for missing fields belonging to active profiles. A non-code project must
   not be asked for source, build, test, or Odoo fields. Validate active profiles:
   required paths and commands, acceptance criteria/evidence for non-code work,
   spec/tag references for code work, and Odoo fields only when selected.
3. If the file is missing, create it from the v2 template above. If it has a
   missing or unsupported version, report it as unusable and offer explicit
   reinitialization or conversion. Write only after the user approves; do not
   promise automatic migration or preservation and do not interpret old
   top-level fields as supported v2 data.
4. For an existing valid v2 file, preserve unknown extension keys while repairing
   only unusable v2 values. Discover external paths only from active v2 profile
   data.
5. First perform only lexical handling: expand known environment-variable and `~`
   syntax when values are available, normalize textual `.`/`..`, and reject obvious
   broad home, Projects/workspace, or parent paths. Do not read, list, search, stat,
   traverse, resolve symlinks, or otherwise access the external path at this stage.
   A configuration reference is discovery evidence only and does not authorize access.
   For a concrete project-specific candidate, present one path at a time with its
   lexically expanded/normalized form, required operation, necessity, why the project
   root or a narrower path cannot satisfy the need, and the risk and scope. Only after
   explicit approval to access it may you resolve its absolute path and canonicalize
   symlinks. If the canonical target is broader than or outside the exact scope of the
   approved candidate, stop even if an existing allow entry happens to cover it. Present
   the exact canonical target and renewed justification, obtain renewed explicit approval
   to access it, and obtain a second, separate explicit approval before adding or relying
   on permission for that changed target. Harmless canonical spelling differences within
   the exact approved scope do not require re-approval; never continue silently. If a
   genuinely necessary operation requires a broad directory, stop and ask with a
   reasoned, risk-aware justification; approval must identify the narrowest concrete
   subpath possible. The authoritative allow list is `opencode.json`; never bypass or
   silently alter it.
6. Write a valid v2 context after each approved answer. Ensure literal secrets
   are absent and references point to protected config or environment values.
7. Verify YAML parsing, selected-profile validity, controlled-extension handling,
   and that the standalone and embedded v2 templates remain semantically and
   structurally synchronized. Report inferred values, blanks, and any approved
   reinitialization or conversion.

The conductor invokes this skill when context is absent or unusable; an
unresolved human choice or permission decision remains a gate, not a reason to
guess. Setup planning occurs before decomposition, while command execution and
setup evidence belong to Execute and completion.
