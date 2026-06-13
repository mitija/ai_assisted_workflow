# AGENTS.odoo.md

Odoo-specific guidance. Append/include alongside the generic `AGENTS.md`.
All concrete paths and credentials come from `project_context.yaml` (see
`odoo:` section) — do not hard-code them here.

## Odoo Source Code (read-only reference)
The base and enterprise source trees (`odoo.source.base` / `odoo.source.enterprise`)
are available for reference. Consult them to understand inherited models, views,
and behaviour. Do not modify them.

## Running Tests
Prefer the test wrapper (`odoo.scripts.run_tests`) — it drops and recreates the
database before each run:

    <run_tests.sh> [-d DATABASE] module1 [module2 ...]

Options: `-d DATABASE` (default from `odoo.database.default_name`), `-h/--help`.
Output is shown live and saved to `/tmp/odoo_test_<timestamp>.log`. Always read
that log file for the actual results rather than the truncated Bash output.

Direct CLI alternative (using `odoo.scripts.config_ini`):

    ./odoo-bin -c <odoo.conf> -d <database> --test-tags <tag> -i <module> --stop-after-init
    ./odoo-bin -c <odoo.conf> -d <database> --test-file addons/<module>/tests/<file>.py --stop-after-init

## Reading Test Output / Logs
- Inspect logs with `Read('/tmp/odoo_test_xxx.log', offset=..., limit=...)`.
- Search with `Grep(pattern='ERROR|FAIL', path='/tmp/odoo_test_xxx.log')`.
- Never pipe/redirect via Bash to read or search log files.

## Database & Instances
- Local dev/test DB: see `odoo.database` in `project_context.yaml`.
- QA instance (optional): credentials in `odoo.qa_instance.config_ini`,
  reachable via XMLRPC for data checks.

## Modules
The modules maintained in this project are listed under `odoo.modules` in
`project_context.yaml` (name, path, dependencies).

## Acceptance: behavioural / UI-UX demo
Beyond automated tests and spec-conformance review, Odoo work is accepted via a
behavioural demo on the dev server (see `AI_assisted_development_workflow.md` §7).
For Odoo this demo also covers **UI/UX conformance** — views, flows, and standard
UX patterns — which is usually thin in the spec and not fully captured in tests.
So:
- Deliver a running dev server with a fixture database matching the test
  scenarios, so the consultant/BA can exercise the use cases interactively.
- Make sure UI behaviour (views, buttons, wizards, list/form layout) matches the
  framework's standard patterns unless the spec explicitly deviates.
