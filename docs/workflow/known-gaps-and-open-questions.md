# Known Gaps and Open Questions

These are where input from senior developers is most welcome.

## The Methodology Lives or Dies by the Analysis

Enormous onus is on the requirements baseline produced by the analyst. The conductor has no mandate to second-guess it, the developer has no mandate to fill gaps, and the human has already confirmed the high-level interpretation. **A bad requirements baseline produces bad software on schedule.** This is a feature — it forces analysis quality to be taken seriously — but it makes the analyst role the binding constraint on output quality.

## The Analyst's Output Is AI-Drafted

The requirements baseline is produced by the analyst agent in conversation with the human and the existing evidence. The deeper limitation: **if the analyst infers something the human didn't actually want, the specification drifts from intent before implementation begins.** Human review in guided mode is the primary safety net. In autonomous mode, the safety net is weaker — the conductor's alignment check and the final human outcome review catch drift later, at higher cost.

## Analyst / Conductor Split Maturity

The separation of analysis (analyst) from delivery (conductor) is new. The following are open questions:

- How much of the existing conductor's analysis-phase behaviour (Phase 1 — Analyze) should be retained versus delegated entirely?
- Should the conductor perform a lightweight alignment check on the analyst's output, or is a formal review gate needed between analysis and delivery?
- In autonomous mode, who decides when analysis is complete enough for implementation to begin?
- How do mode transitions (guided → autonomous, autonomous → guided) interact with the conductor's decomposition and execution phases?

Current implementation: the conductor determines whether sufficient analysis exists, delegates discovery to the analyst when needed, and checks alignment before accepting the baseline. This is expected to evolve with practice.

## Provenance Rigor Overhead

Every requirement must record its provenance (explicitly-requested, inferred-context, inherited, domain-practice, design-decision, risk-control, unresolved). For small, low-risk projects this may feel bureaucratic. The intent is that the format scales: small tasks may use a single consolidated document with lightweight provenance annotations; larger projects use structured YAML. Finding the right default balance is ongoing work.

## The Spec Itself Is AI-Drafted

The requirements baseline is analyst-drafted using AI. The deeper limitation: **if the analyst infers something the human didn't actually want, the AI produces something the human didn't want, and the human may sign off without spotting it (in guided mode) or never see it (in autonomous mode).** The methodology controls drift between spec and code, not between intent and spec. Review gates (guided validation, conductor alignment check, final outcome review) are the safety net.

## The Analyst Is Also a Developer (Currently)

The analyst role today is filled by the same person who handles the conductor and developer functions. This means:

- The requirements baseline routinely defines **technical architecture** — module boundaries, data model, integration points, performance-sensitive design — not just functional behaviour.
- The analyst makes technical design decisions that a pure functional analyst would not.
- A **pure functional analyst** would need a separate technical-design step between baseline acceptance and implementation.

In a pure-functional-analyst configuration, the workflow would need to change:

- Add an explicit **technical-design step** after requirements baseline approval.
- Acceptance would need to include **architecture review** separately from spec conformance.
- More tolerance for developer-side decisions, with the trade-off of **less reproducibility across developers.**

This is a scoping caveat, not a flaw: the methodology as described currently assumes a technically-fluent analyst. Adapting it to functional-only analysis is open work.

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

## Analyst / Conductor Git Fluency

The workflow assumes the analyst and conductor can use git fluently — commits, tags, branches, conflicts. Most functional analysts and consultants can't. This is a real obstacle to extending the methodology beyond technically-fluent practitioners. Options: a wrapper UI, a "spec publishing" step that hides git, or accepting the constraint on adoption.

## Navigation

- [Workflow index](README.md)
- [Landing page](../AI_assisted_development_workflow.md)