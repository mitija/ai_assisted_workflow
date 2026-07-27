---
name: conductor-analyze
description: Phase 1 orchestration gate. Records modes and permissions, initializes project context, classifies work, gathers context, checks analyst readiness and alignment, and routes to decomposition.
---

# Conductor: Analyze

This phase is a thin orchestration gate. The conductor does not perform detailed
elicitation, research, motivation analysis, or requirements design; those belong
to the analyst.

## Gate

1. Record `interaction_mode` (`interactive` by default or explicitly
   `autonomous`) and obtain or pass through the independent `analysis_mode`
   (`guided` or `autonomous`). Never infer one from the other.
2. In autonomous mode, run the filesystem permission preflight. Inspect
   `opencode.json` and project configuration, normalize and canonicalize
   discovered paths, reject broad paths, ask approval for concrete missing
   permissions, and persist only approved entries. Interactive mode handles
   these questions during normal dialogue. Do not modify `opencode.json` before
   approval.
3. Check `project_context.yaml`. If it is absent or unusable, invoke or arrange
   the `init-project` skill, respecting its human questions and permission gates.
   Confirm the resulting context is usable before continuing.
4. Delegate project-context gathering to `explore`: read the context, summary,
   applicable docs/spec and test references, and relevant project files. Do not
   duplicate the analyst's research or detailed elicitation.
5. Classify the work as **code** or **non-code**. Code work includes source or
   application-test changes. Non-code work includes documentation,
   configuration, setup, organisation, or research that does not produce
   application code.
6. Check analyst baseline sufficiency. The objective and scope must be aligned,
   the objective brief confirmed, requirements/business rules/traceability and
   verification methods must exist, the quality gate must pass, and the analyst
   must confirm readiness. Guided mode additionally requires human validation
   approval; autonomous mode requires no blocking C/D decision.
7. Check verification readiness. For code work, the analyst baseline must identify
   applicable contractual scenarios, unit-test expectations, and verification and
   evidence methods. Passing test and check results are required during Execute
   and at completion, not before decomposition. Non-code work must include the
   analyst's explicit acceptance criteria and evidence definition.
8. If analysis is insufficient, delegate the complete analysis lifecycle to the
   analyst and then re-read its outputs through `explore`. Do not perform that
   work in the conductor.
9. Challenge unexplained scope additions or objective misalignment. Preserve
   mandatory objective confirmation, guided validation, final review, and human
   outcome judgement.
10. Route ready code work to `conductor-code-decomposition`; route ready
    non-code work to `conductor-noncode-decomposition`.

In autonomous interaction mode, record non-blocking assumptions and stop for
hard blockers. In interactive mode, ask one question at a time and wait rather
than guessing.
