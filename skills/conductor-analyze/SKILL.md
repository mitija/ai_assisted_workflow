---
name: conductor-analyze
description: Phase 1 orchestration gate. Records modes and permissions, initializes project context, classifies work, gathers context, checks analyst readiness and alignment, and routes to decomposition.
---

# Conductor: Analyze

This phase is the user-facing orchestration gate. The conductor owns project
initialization, tooling and environment readiness, command/layout discovery,
permissions, setup tasks, and setup blockers, but delegates mechanics to
`init-project`, `general`, `explore`, or `verifier`. Detailed elicitation,
research, motivation analysis, and requirements design belong to the analyst.

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
3. Check `project_context.yaml`. It is usable only when it is valid v2 with
   `schema_version: 2`; missing or unsupported versions are unusable. If absent
   or unusable, invoke or arrange `init-project`, respecting explicit
   reinitialization/conversion approval and permission gates. Confirm the
   resulting context is usable before continuing.
4. Delegate project-context gathering to `explore`: read the context, summary,
   applicable docs/spec and test references, and relevant project files. Do not
   duplicate the analyst's research or detailed elicitation.
5. Classify the work as **code** or **non-code**. Code work includes source or
   application-test changes. Non-code work includes documentation,
   configuration, setup, organisation, or research that does not produce
   application code.
6. Check analyst baseline sufficiency. If it is absent or needs maintenance,
   automatically delegate the proportionate analyst lifecycle. The minimum gate
   is confirmed objective/scope, applicable requirements or acceptance criteria,
   verification/evidence method, alignment, no blocking decision, and analyst
   readiness. Full-tier work additionally requires the full artefact and quality
   gates; lightweight work may use one consolidated baseline. Guided mode
   additionally requires one consolidated human validation approval; autonomous
   mode requires no blocking C/D decision.
7. Check verification readiness. For code work, the analyst baseline must identify
   applicable contractual scenarios, unit-test expectations, and verification and
   evidence methods. Passing test and check results are required during Execute
   and at completion, not before decomposition. Non-code work must include the
   analyst's explicit acceptance criteria and evidence definition.
8. If analysis is insufficient or stale, delegate the proportionate analysis
   lifecycle to the analyst and then re-read its outputs through `explore`. Do
   not perform that work in the conductor. A direct analyst run intended to drive
   delivery follows this same readiness and alignment check.
9. Challenge unexplained scope additions or objective misalignment. Preserve
   mandatory objective confirmation, guided validation, final review, and human
   outcome judgement.
10. Route ready code work to `conductor-code-decomposition`; route ready
    non-code work to `conductor-noncode-decomposition`.

In autonomous interaction mode, record non-blocking assumptions and stop for
hard blockers. In interactive mode, ask one question at a time and wait rather
than guessing.
