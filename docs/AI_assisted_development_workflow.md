# Agentic Framework for Long-Horizon AI Work

**Status:** Working but evolving. Used on real projects, primarily Odoo-related work but not limited to Odoo.

**Audience:** Senior developers, expanding to people who want to run long-horizon AI tasks. Comments, questions, and suggestions are explicitly welcome — this document is shared for feedback as much as for collaboration.

---

This document is the landing page for a wiki-style collection. The detailed content lives under [`docs/workflow/README.md`](workflow/README.md).

Specification-driven coding is a relatively mature, well-tested capability within this framework. Current framework improvement prioritises non-coding long-horizon work — documentation, research, analysis, planning, and configuration — where the same structured decomposition and verification principles apply. The [philosophy page](workflow/philosophy.md) remains the canonical expanded explanation of the overall approach.

Two failure modes drive this methodology:

- **Spec ambiguity → assumption-driven defects.** The developer fills gaps with assumptions; the consultant rejects the result based on intent that was never written down. The cost is paid in iterations, which are now the dominant cost of software delivery.
- **Specs are no longer read only by humans.** They are increasingly consumed by LLM tooling on the developer side. A spec good enough for a human to interpret is not necessarily good enough for an AI to implement against. Documents must be **AI-ready** as well as human-readable.

The thesis:

> **If the specification is precise enough and the test suite is exhaustive enough, an LLM-assisted developer should be able to produce conforming software in hours, not days — and the cycle should be reproducible by another developer or another LLM later.**

The methodology trades up-front specification rigour for short, lean implementation cycles. The center of gravity sits with the consultant, not the developer.

Beyond coding, the same acceptance-driven autonomy applies. For non-coding flows (research, analysis, documentation, configuration), every task is defined with explicit acceptance criteria and the LLM is instructed how to assess its work against those criteria, continuing until they are met. For software flows, the acceptance criteria are operationalized as a test suite and the LLM runs the tests until they pass.

**Primary context: Odoo customization.** Framework constraints (ORM, view system, module structure, standard UX patterns) remove many decisions that would otherwise need to be specified. The principles generalize to other constrained-framework projects.

## Topics

| Topic | Description |
|---|---|
| [Philosophy](workflow/philosophy.md) | Problem, intent, and the three guiding principles of the methodology |
| [Principles](workflow/principles.md) | The seven load-bearing principles |
| [Workspace and Repositories](workflow/workspace-and-repositories.md) | Project layout, two-repo model, local area |
| [Specification](workflow/specification.md) | Requirement refinement and the 5-step methodology |
| [Test Suite](workflow/test-suite.md) | State-table test format and acceptance criteria |
| [Workflow](workflow/workflow.md) | End-to-end cycle, roles, developer deliverables |
| [Acceptance](workflow/acceptance.md) | Three required pillars of acceptance |
| [Known Gaps and Open Questions](workflow/known-gaps-and-open-questions.md) | Honest assessment of current limitations |
| [Sample Test Scenario](workflow/appendices/sample-test-scenario.md) | Worked example from a real Odoo procurement scenario |

---

The methodology trades up-front specification effort for downstream speed and reproducibility:

- **Implementation cycles are short** because the spec eliminates ambiguity.
- **Acceptance is multi-layered** — tests, AI-assisted code review, behavioural demo.
- **Work is portable** — spec and tests describe the system independently of developer or AI.
- **The customer always has the latest** because the docs repo is shared.

It works when the consultant can write rigorous specs and the developer can execute against them without filling gaps unilaterally. **The bottleneck is those two skills, not the AI.** Risks are named honestly in the [known gaps](workflow/known-gaps-and-open-questions.md) — feedback on closing them is the request.
