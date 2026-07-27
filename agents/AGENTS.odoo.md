# AGENTS.odoo.md

Odoo-specific guidance. Append/include alongside the generic `AGENTS.md`.
All concrete paths and credentials come from protected configuration referenced by
`project_context.yaml` (see `profiles.odoo` in v2, or the legacy equivalent when
reading v1) — do not hard-code or expose them here.

## Odoo Source Code (read-only reference)
The base and enterprise source trees (`odoo.source.base` / `odoo.source.enterprise`)
are available for reference. Consult them to understand inherited models, views,
and behaviour. Do not modify them.

## Running Tests
Prefer the test wrapper (`odoo.scripts.run_tests`) — it drops and recreates the
database before each run:

    <run_tests.sh> [-d DATABASE] module1 [module2 ...]

Options: `-d DATABASE` (default from the protected local Odoo config referenced by
`profiles.odoo.scripts.config_ini`), `-h/--help`.

The wrapper must configure Odoo's native `--logfile <path>` option so that Odoo
writes all logging to `local/tmp/odoo_test_<timestamp>.log` instead of stderr.
This is a wrapper implementation requirement (the wrapper is external to this
repository and will be updated separately). Do not use shell redirection (`>`),
append (`>>`), or `tee` to capture Odoo logs — rely solely on Odoo's `--logfile`.

Because `--logfile` sends Odoo logging directly to the file, test log messages
are not streamed to the terminal in real time. Only non-log command output
(e.g. wrapper progress messages) may appear live. Always read the log file for
the actual Odoo test results rather than the truncated Bash output.

Direct CLI alternative (using the protected config referenced by
`profiles.odoo.scripts.config_ini`):

    ./odoo-bin -c <odoo.conf> -d <database> --test-tags <tag> -i <module> --stop-after-init
    ./odoo-bin -c <odoo.conf> -d <database> --test-file addons/<module>/tests/<file>.py --stop-after-init

## Reading Test Output / Logs
- Inspect logs with `Read('local/tmp/odoo_test_xxx.log', offset=..., limit=...)`.
- Search with `Grep(pattern='ERROR|FAIL', path='local/tmp/odoo_test_xxx.log')`.
- Never pipe/redirect via Bash to read or search log files.

## Database & Instances
- Local dev/test DB: use the protected config referenced by
  `profiles.odoo.scripts.config_ini` (or its recognized legacy v1 equivalent).
- QA instance (optional): use the protected config referenced by
  `profiles.odoo.qa_instance.config_ini`,
  reachable via XMLRPC for data checks.

## Modules
The modules maintained in this project are listed under `odoo.modules` in
`project_context.yaml` (name, path, dependencies).

## Acceptance: behavioural / UI-UX demo
Beyond automated tests and spec-conformance review, Odoo work is accepted via a
behavioural demo on the dev server (see [docs/workflow/acceptance.md](../docs/workflow/acceptance.md)).
For Odoo this demo also covers **UI/UX conformance** — views, flows, and standard
UX patterns — which is usually thin in the spec and not fully captured in tests.
So:
- Deliver a running dev server with a fixture database matching the test
  scenarios, so the consultant/BA can exercise the use cases interactively.
- Make sure UI behaviour (views, buttons, wizards, list/form layout) matches the
  framework's standard patterns unless the spec explicitly deviates.
