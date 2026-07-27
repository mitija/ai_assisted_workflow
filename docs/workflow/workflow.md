# Workflow

## End-to-end cycle

1. **Human:** provides the problem, desired functional outcome, high-level
   criteria, constraints, and consequential decisions.
2. **Conductor:** is the normal entry, transparently invokes the analyst when the
   baseline is missing or stale, and owns initialization, tooling, environment,
   command/layout, permission, and setup readiness plus blockers. It then confirms
   analyst readiness and alignment and runs Analyze, Decompose, Execute, Review,
   Escalate on failure, and Report.
3. **Analyst:** performs evidence-first intake, discovery, review, and baseline when
   invoked by the conductor. The analyst researches task/domain/background context
   and records motivation, beneficiaries, outcomes, reasonable expectations,
   sources, findings, confidence, assumptions, and provenance. Direct analyst
   invocation remains the specialist, analysis-only path.
4. **Implementers:** deliver code or non-code work against the baseline. In code
   work, contractual tests are derived from the frozen specification where one
   exists. Genuine functional ambiguity is a blocker routed to the analyst.
5. **Evidence and completion:** the verifier records checks, the mandatory reviewer
   audits the result, the conductor assesses the functional outcome, and the human
   makes the final outcome judgement.

The conductor's six phases are:

1. **Analyze** — a thin orchestration gate that records modes and permissions,
   initializes missing or unusable project context, classifies work, checks
   analyst-baseline sufficiency, and checks objective/scope alignment. Detailed
   research and functional analysis remain the analyst's responsibility.
2. **Decompose** — builds a dependency-aware code or non-code task graph.
3. **Execute** — delegates ready work in topological rounds, with verification and
   focused commits where appropriate.
4. **Review** — invokes the mandatory reviewer audit against the goal, baseline,
   and acceptance criteria. Critical or blocking findings require remediation.
5. **Escalate** — diagnoses failed verification or blocked tasks through escalate1
   and escalate2 as needed before continuing or aborting.
6. **Report** — records task results, verification evidence, review findings,
   resolutions, and overall status.

### Readiness versus results

Before Decompose, the analyst baseline identifies applicable contractual scenarios,
code unit-test expectations, verification/evidence methods, and explicit non-code
acceptance criteria/evidence. This is a planning gate, not a requirement for
passing results. Applicable tests, checks, and acceptance evidence are run and
assessed during Execute and are required at completion.

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
| Analyst | Evidence-first functional contract, research record, provenance, traceability, verification definitions, and documentation tags under policy | Analyst skills and git |
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
