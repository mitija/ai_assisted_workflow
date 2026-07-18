# Philosophy

## Problem

Two failure modes drive this methodology:

- **Spec ambiguity → assumption-driven defects.** The developer fills gaps with assumptions; the consultant rejects the result based on intent that was never written down. The cost is paid in iterations, which are now the dominant cost of software delivery.
- **Specs are no longer read only by humans.** They are increasingly consumed by LLM tooling on the developer side. A spec good enough for a human to interpret is not necessarily good enough for an AI to implement against. Documents must be **AI-ready** as well as human-readable.

## Thesis

> **If the specification is precise enough and the test suite is exhaustive enough, an LLM-assisted developer should be able to produce conforming software in hours, not days — and the cycle should be reproducible by another developer or another LLM later.**

The methodology trades up-front specification rigour for short, lean implementation cycles. The center of gravity sits with the consultant, not the developer.

**Every task — whether code, documentation, research, or configuration — must have explicit acceptance criteria defined before work begins, and completion must be checked against those criteria.**

**Primary context: Odoo customization.** Framework constraints (ORM, view system, module structure, standard UX patterns) remove many decisions that would otherwise need to be specified. The principles generalize to other constrained-framework projects.

## Guiding Principles

Three explicit principles guide the evolution of this methodology and the repository that encodes it:

### 1. Portability Across Tooling

Although the repository is developed for use with opencode, the material — specifications, tests, workflow definitions, skills — should remain as portable as possible across end-user AI tools. No artifact should assume a specific AI platform, IDE, or agent framework unless the dependency is explicitly documented and justified. This ensures the methodology outlasts any single tool and can be adopted by teams using different toolchains.

### 2. Continuous Improvement Through Real Project Feedback

The methodology is not a theoretical exercise. It evolves through application on real projects, and each project is expected to maintain a `LESSONS_LEARNT.md` file at the project root. Observations from these files feed improvements back into this repository — whether as refinements to skills, corrections to the workflow, or new patterns. The repository itself is a living artifact shaped by practice.

### 3. Broad Scope Beyond Software Development

The methodology's scope is broader than software development alone. It aims to provide a long-horizon LLM workflow for *any* AI activity — including research, analysis, documentation, configuration, and other non-code tasks. This requires:

- Explicit acceptance criteria defined before work begins.
- A mechanism for the LLM to assert completed work against those criteria.
- The ability to continue autonomously until criteria are met, without requiring human intervention at every step.

This broader scope is partly aspirational: current practice focuses on code implementation, but the architecture of the workflow — spec-driven, test-validated, acceptance-gated — is designed to generalize.

## Navigation

- [Workflow index](README.md)
- [Landing page](../AI_assisted_development_workflow.md)