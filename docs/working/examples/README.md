# Worked Examples — Analyst Workflow

Two illustrative examples demonstrating the four-phase analyst workflow (intake,
discovery, review, baseline) in both operating modes.

| # | Example | Mode | What it demonstrates |
|---|---------|------|---------------------|
| A | [Hermes Agent on VPS](hermes-vps-autonomous/illustrative-content.md) | Autonomous | Initial Q&A, inferred operational requirements, security/authorisation decisions, configuration documentation, restart/recovery criteria, deployment/idempotency criteria, traceability, autonomous decision-making |
| B | [Breathing Exercise Application](breathing-guided/illustrative-content.md) | Guided | Functional user journeys, business rules, pause/resume/interruption behaviour, low-fidelity wireframes, accessibility requirements, detailed success criteria, guided functional validation, human-feedback propagation |

## Structure

Each example is self-contained under its own directory:

```
examples/
  README.md                                              ← this index
  hermes-vps-autonomous/
    example-overview.md                                  ← scope and framework mapping
    illustrative-content.md                              ← full worked example
  breathing-guided/
    example-overview.md                                  ← scope and framework mapping
    illustrative-content.md                              ← full worked example
```

## Convention

Every example explicitly separates **framework requirements** (the analyst skills,
phases, artefact types, and quality gates defined in the workflow) from
**illustrative fictional content** (the specific project and its details).
Framework-required elements are identified in the content; fictional project
details are clearly scoped as illustrative.

## Disclaimer

These examples are purely illustrative documentation. They do not describe any
real deployment, live system, or actual secrets. No real credentials,
endpoints, or personal data are exposed.