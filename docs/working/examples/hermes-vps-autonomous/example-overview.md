# Example A: Hermes Agent on VPS — Scope and Framework Mapping

## Scope

This example demonstrates the end-to-end analyst workflow in **autonomous mode**
for configuring a Hermes agent using Ansible on a VPS. The fictional project
involves deploying an AI agent to a cloud VPS and making it accessible via
Discord.

## What this example demonstrates

| Framework element | Where demonstrated |
|---|---|
| Objective brief / Intake (Phase 1) | Intake Q&A, objective brief production, human confirmation |
| Mode choice | Selection of autonomous mode |
| Decision classification | Class A/B decisions resolved autonomously (port selection, process manager, log rotation); Class C decisions escalated (secret storage approach) |
| Provenance | Every requirement labelled with provenance: explicitly-requested, inferred-context, domain-practice, design-decision, risk-control |
| Requirements and business rules | FR-001–FR-013, BR-001–BR-003 |
| Hierarchical success criteria | HC-001–HC-003 → FR-xxx → SC-001–SC-018 → VER-001–VER-009 |
| Verification definitions | VER-001–VER-009 with method and pass/fail criteria |
| Traceability | Complete chain from OBJ-001 → HC-xxx → FR/BR → SC → VER |
| Wireframe / UI representation | Not applicable (infrastructure, no UI) |
| Intended documentation | Configuration reference, operations guide, troubleshooting guide |
| Quality review | Step 19 findings (critical, warning, suggestion) |
| Validation package / approval | Not produced (autonomous mode skips the guided validation gate) |
| Baseline outcome | Final traceability state, autonomous decision record, documentation completeness |

The `configured authorised-user` decision is traced through BR-001, DEC-004, SC-002, SC-012, and the `authorised_user_id` configuration entry.

## Mode: Autonomous

The analyst performs full discovery without pausing for human approval before
implementation. Only Class C/D decisions are escalated. The governing rule
applied throughout:

> Non-blocking uncertainty is resolved and recorded, not escalated.

## Fictional project context

- **Project:** Deploy a Hermes AI agent on a Hetzner CX22 VPS
- **Infrastructure:** Single Ubuntu 24.04 VPS, Ansible-managed
- **Communication:** Discord bot (slash commands)
- **Security:** Personal-use deployment with appropriate precautions
- **Automation:** Fully automated via Ansible playbook