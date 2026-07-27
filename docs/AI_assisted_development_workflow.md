# Agentic Framework for Long-Horizon AI Work

**Status:** Production-ready for its core, spec-driven coding workflow and still
evolving. The framework also supports documentation, research, analysis,
configuration, and project setup; those broader non-code workflows are less mature.

This is the authoritative overview for the detailed [workflow documentation](workflow/README.md).

## The paradigm

The human supplies intent, desired outcomes, high-level criteria, constraints, and
consequential decisions. The **analyst** turns that intent into a defensible
functional contract through evidence-first research and analysis. The analyst owns
research into motivation, the problem, beneficiaries, outcomes, and reasonable user
or operational expectations, recording sources, findings, confidence, assumptions,
and provenance while distinguishing observed or domain expectations from explicit
human requirements. The **conductor** delivers against the contract across code
and non-code work. Implementers may use any suitable AI workflow; the deliverable
and its evidence are what matter.

## Roles and analyst phases

- **Human (Objective Owner):** confirms the objective, makes consequential
  decisions, and makes the final judgement about the delivered outcome.
- **Analyst (Functional Contract Owner):** owns requirements, business rules,
  success criteria, provenance, traceability, verification definitions, wireframes,
  and intended documentation through four phases:
  1. **Intake** establishes the objective brief and analysis mode.
  2. **Discovery** uses existing evidence to develop the functional contract.
  3. **Review** applies the requirements quality gate and, in guided mode, produces
     a validation package for human review.
  4. **Baseline** establishes stable identifiers, consistency, traceability, and
     evidence mappings across the lifecycle.
- **Conductor (Delivery Owner):** accepts the analyst baseline, coordinates delivery,
  and owns outcome assessment. The analyst does not implement application code.

Every requirement and important business rule carries exactly one provenance value:
explicitly-requested, inferred-context, inherited, domain-practice, design-decision,
risk-control, or unresolved. Inferred decisions are never silently presented as
human requirements.

## Conductor phases

The conductor owns six delivery phases:

1. **Analyze** is a thin orchestration gate for modes, permissions, project-context
   readiness, work classification, analyst-baseline sufficiency, and objective/scope
   alignment. It does not perform the analyst's research or requirements analysis.
2. **Decompose** creates a dependency-aware graph for code or non-code work.
3. **Execute** delegates implementation and verification, using the verifier and
   committer where appropriate.
4. **Review** invokes the mandatory read-only reviewer audit; critical or blocking
   findings trigger remediation and re-review.
5. **Escalate** diagnoses failed tasks through the escalation path before continuing
   or aborting.
6. **Report** records task results, evidence, review outcomes, and overall status.

`analysis_mode` (`guided` or `autonomous`) is independent of `interaction_mode`
(`interactive` or `autonomous`). The first governs how the analyst handles
requirements decisions and validation; the second governs how the conductor handles
orchestration ambiguity. Neither mode removes the need to stop for genuine
blockers or consequential decisions.

The analyst may create an immutable tag only in the configured documentation
repository, after the applicable quality and baseline gates (and human validation
in guided mode; autonomous analysis must have no blocking Class C or D decision),
using the canonical naming convention, normally `spec-YYMMDD` with a collision
suffix. The analyst records the repository, tag, commit, baseline, validation, and
publication status. Existing tags are never moved, deleted, or repointed; a changed
baseline receives a new tag. Tag creation is separate from push or publication
authorization. No agent other than the analyst may create tags, and the analyst
may not create source, release, deployment, or production tags.

Project context uses a minimal envelope with optional visible typed profiles such
as `code`, `non_code`, and `odoo`. Inactive profiles impose no requirements;
controlled self-describing extensions are preserved, legacy v1 remains readable,
and secrets and external paths remain protected. If context is missing or unusable,
the conductor routes the work to `init-project`.

## Traceability and completion

The evidence chain runs from objective and high-level criteria through requirements,
business rules, detailed success criteria, verification definitions, and delivered
evidence. In spec-driven coding, contractual tests are necessary but not sufficient.
Completion also requires review against the contract, behavioural or equivalent
outcome evidence, documentation and traceability checks, the conductor's functional
outcome assessment, and final human judgement. Passing tests alone is not completion.

## Benefits and trade-offs

The separation of intent, contract ownership, and delivery makes assumptions visible,
keeps work reproducible, and supports short implementation cycles when analysis is
strong. The trade-off is that rigour moves up front: analysis quality becomes the
main bottleneck, and human gates remain important for consequential interpretation.

## Limitations and maturity

Analysis can drift from intent, particularly in autonomous mode, and no process can
replace informed human judgement. Verification is less standardized for
non-functional requirements, external triggers, UI/UX nuance, and non-code outcomes.
Tooling, environment setup, git fluency, and the still-maturing non-code workflow
also constrain adoption. These are active improvement areas, not reasons to treat
the core workflow as experimental.

## Topics

| Topic | Description |
|---|---|
| [Philosophy](workflow/philosophy.md) | Problem, thesis, and guiding principles. |
| [Principles](workflow/principles.md) | Load-bearing principles, provenance, and traceability. |
| [Workspace and Repositories](workflow/workspace-and-repositories.md) | Project layout and repository model. |
| [Specification](workflow/specification.md) | Analyst contract and optional post-baseline structuring. |
| [Test Suite](workflow/test-suite.md) | Contractual test format and acceptance criteria. |
| [Workflow](workflow/workflow.md) | Detailed analyst and conductor lifecycle. |
| [Acceptance](workflow/acceptance.md) | Required acceptance and completion evidence. |
| [Known Gaps and Open Questions](workflow/known-gaps-and-open-questions.md) | Current limitations and unresolved improvement questions. |
| [Sample Test Scenario](workflow/appendices/sample-test-scenario.md) | Worked Odoo procurement example. |
