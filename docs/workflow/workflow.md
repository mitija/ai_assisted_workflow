# Workflow

## End-to-end cycle

1. **Human:** provides the problem, desired functional outcome, high-level
   criteria, constraints, and consequential decisions.
2. **Analyst:** runs intake, discovery, review, and baseline. The result is a
   requirements baseline with stable IDs, provenance, verification definitions,
   intended documentation, and traceability.
3. **Conductor:** confirms analyst readiness and alignment, then runs Analyze,
   Decompose, Execute, Review, Escalate on failure, and Report.
4. **Implementers:** deliver code or non-code work against the baseline. In code
   work, contractual tests are derived from the frozen specification where one
   exists. Genuine functional ambiguity is a blocker routed to the analyst.
5. **Evidence and completion:** the verifier records checks, the mandatory reviewer
   audits the result, the conductor assesses the functional outcome, and the human
   makes the final outcome judgement.

The conductor's six phases are:

1. **Analyze** — determines goal, scope, constraints, work type, context, and
   whether a sufficient analyst baseline exists.
2. **Decompose** — builds a dependency-aware code or non-code task graph.
3. **Execute** — delegates ready work in topological rounds, with verification and
   focused commits where appropriate.
4. **Review** — invokes the mandatory reviewer audit against the goal, baseline,
   and acceptance criteria. Critical or blocking findings require remediation.
5. **Escalate** — diagnoses failed verification or blocked tasks through escalate1
   and escalate2 as needed before continuing or aborting.
6. **Report** — records task results, verification evidence, review findings,
   resolutions, and overall status.

## Modes and questions

The analyst's `analysis_mode` is independent of the conductor's `interaction_mode`:

- **Autonomous analysis:** the analyst resolves non-blocking decisions and asks
  the human only about consequential or blocking decisions.
- **Guided analysis:** the analyst pauses after Review with a functional validation
  package for human approval, approval with changes, or reanalysis.
- **Interactive orchestration:** the conductor consults the human when resolving
  orchestration ambiguity.
- **Autonomous orchestration:** the conductor proceeds without routine dialogue,
  while still stopping for genuine blockers and required human decisions.

During implementation, a genuine functional-contract gap stops the cycle. The
analyst interprets the issue, updates the baseline when necessary, and a new docs
tag is produced before work resumes. Trivial clarifications that do not alter the
contract may be recorded in `docs/working/` or `local/`.

## Roles

| Role | Owns | Tools |
|---|---|---|
| Human | Intent, high-level criteria, consequential decisions, final judgement | Docs and outcome review |
| Analyst | Functional contract, provenance, traceability, verification definitions | Analyst skills and git |
| Conductor | Delivery orchestration, review, evidence, outcome assessment | Conductor skills and agents |
| Implementer | Code or non-code deliverable and implementation tests | Method of choice |
| Reviewer | Independent correctness and completeness audit | Read-only reviewer agent |
| Verifier | Independent command/inspection execution and evidence | Verifier agent |
| Committer | Focused commits when committing is in scope | Committer agent |

## Implementation deliverables

For a spec-driven coding cycle, the source-side deliverables are:

1. Source code committed against the docs tag, with that tag referenced in
   source-side traceability.
2. Automated tests covering every in-scope contractual scenario and invariant.
3. A development report covering work, test coverage, deviations, and design
   decisions not dictated by the specification.

For non-code work, the equivalent deliverable and its explicit acceptance evidence
are defined during analysis. All work remains subject to review, traceability, and
functional outcome assessment.

## Navigation

- [Workflow index](README.md)
- [Specification](specification.md)
- [Acceptance](acceptance.md)
- [Landing page](../AI_assisted_development_workflow.md)
