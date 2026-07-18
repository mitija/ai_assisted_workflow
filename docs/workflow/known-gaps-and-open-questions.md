# Known Gaps and Open Questions

These are where input from senior developers is most welcome.

## The Methodology Lives or Dies by the Spec

Enormous onus is on the spec and tests. The developer has no mandate to second-guess them, the AI has no judgement to fall back on, the customer has already signed off. **A bad spec produces bad software on schedule.** This is a feature — it forces specification quality to be taken seriously — but it makes the consultant role the binding constraint on output quality.

## The Spec Itself Is AI-Drafted

The spec is "vibe-coded" by the consultant in conversation with an AI, then validated by the customer in the docs repo. The deeper limitation: **if the consultant asks the AI for something they didn't actually want, the AI produces something they didn't want, and the customer may sign off without spotting it.** The methodology controls drift between spec and code, not between intent and spec. Customer review is the only safety net there.

## The Current Consultant Is Also a Developer

The consultant role today is filled by someone with a developer background. This means:

- The spec routinely defines **technical architecture** — module boundaries, data model, integration points, performance-sensitive design — not just functional behaviour.
- The lean cycle works because the developer arrives at a spec where most architectural decisions are already made.
- A **pure functional consultant** could not produce specs at this level.

In a pure-functional-consultant configuration, the workflow would need to change:

- Add an explicit **technical-design step** between docs tag and implementation.
- Acceptance would need to include **architecture review** separately from spec conformance.
- More tolerance for developer-side decisions, with the trade-off of **less reproducibility across developers.**

This is a scoping caveat, not a flaw: the methodology as described is currently for technically-fluent consultants. Adapting it to functional-only consultancy is open work.

## Test Execution Glue

Test scenarios are plain English; the developer translates them into code-level tests. The translation is a source of drift. Options being considered: a Gherkin-like syntax mapped more directly to code; AI-generated test scaffolding; or accepting the cost and investing in review tooling.

## Triggers Outside the UI

Scenarios driven from APIs, scheduled jobs, or other non-UI sources are awkward to validate behaviourally on the dev server. A Python script supplements this — a workaround, not a solution.

## Developer-Side AI Workflow

We don't prescribe how the developer uses AI. Deliberate (developers vary, dictating internal workflow is overreach), but it leaves us blind to consistency of method. The contract is the deliverable, not the process. Whether this should change is an open question.

## Spec Versioning Beyond Linear Tags

A single linear tag sequence works for one project with one developer. Parallel epics, multi-developer engagements, and long-running branches would need a richer model. We haven't needed it yet.

## Non-Functional Requirements

NFRs (performance, security, observability) are captured in a dedicated spec section but not tested with the rigour of functional scenarios. **The largest single technical gap.**

## Consultant Git Fluency

The workflow assumes the consultant can use git fluently — commits, tags, branches, conflicts. Most functional consultants can't. This is a real obstacle to extending the methodology beyond technically-fluent consultants. Options: a wrapper UI, a "spec publishing" step that hides git, or accepting the constraint on adoption.

## Navigation

- [Workflow index](README.md)
- [Landing page](../AI_assisted_development_workflow.md)