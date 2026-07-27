# Known Gaps and Open Questions

These are where input from senior developers is most welcome.

## Analysis Quality Is the Bottleneck

Enormous onus is on the requirements baseline produced by the analyst. The conductor has no mandate to second-guess it, the developer has no mandate to fill gaps, and the human has already confirmed the high-level interpretation. **A bad requirements baseline produces bad software on schedule.** This is a feature — it forces analysis quality to be taken seriously — but it makes the analyst role the binding constraint on output quality.

## Provenance Rigor Overhead

Every requirement must record its provenance (explicitly-requested, inferred-context, inherited, domain-practice, design-decision, risk-control, unresolved). For small, low-risk projects this may feel bureaucratic. The intent is that the format scales: small tasks may use a single consolidated document with lightweight provenance annotations; larger projects use structured YAML. Finding the right default balance is ongoing work.

## Analyst Output Can Drift from Intent

The requirements baseline is AI-drafted from conversation and existing evidence. If
the analyst infers something the human did not want, the specification can drift
before implementation. Guided validation, conductor alignment, traceability, and
final outcome review reduce this risk but cannot eliminate it; autonomous analysis
has a weaker early safety net.

## Technical Fluency and Role Boundaries

The analyst role is currently often filled by the same person who handles conductor
and implementation functions. This means:

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

## Verification Gaps

NFRs (performance, security, observability) are captured in a dedicated spec section
but are not tested with the rigour of functional scenarios. External triggers,
UI/UX nuance, and non-code outcomes also lack equally standardized verification.
**This is the largest technical gap.**

## Project-Specific Authorization and Git Boundaries

The conductor automates routine setup and delegates mechanics, but project-specific
authorization remains a genuine boundary: commits, documentation tags, branches,
conflicts, and publication may require explicit approval. Most functional analysts
and consultants cannot safely grant these permissions. The bounded analyst tag
policy reduces one hand-off but does not remove the need for a wrapper UI, a "spec
publishing" step that hides git, or an explicit authorization workflow.

## Profile-Aware Project Context

The minimal v2 envelope with optional typed profiles reduces irrelevant setup fields
for non-code and mixed projects. Missing or unsupported context requires explicit
reinitialization or conversion, and controlled extensions are preserved only for
valid v2 context. Profile selection, validation, and extension governance add
complexity, and the right balance between flexibility and machine-readable
consistency remains an active maintenance concern.

## Navigation

- [Workflow index](README.md)
- [Landing page](../AI_assisted_development_workflow.md)
