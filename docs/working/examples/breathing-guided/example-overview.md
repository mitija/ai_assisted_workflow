# Example B: Breathing Exercise Application — Scope and Framework Mapping

## Scope

This example demonstrates the end-to-end analyst workflow in **guided mode** for
a breathing exercise application. The fictional project involves a mobile/web
app that guides users through configurable breathing sessions with visual and
haptic cues.

## What this example demonstrates

| Framework element | Where demonstrated |
|---|---|
| Objective brief / Intake (Phase 1) | Intake Q&A, objective brief production, human confirmation |
| Mode choice | Selection of guided mode |
| Decision classification | Class A/B decisions (animation style, sound defaults); Class C decisions escalated (pause behaviour, data persistence) |
| Provenance | Every requirement labelled: explicitly-requested, inferred-context, domain-practice, design-decision, risk-control |
| Requirements and business rules | FR-001–FR-015, BR-001–BR-006 |
| Hierarchical success criteria | HC-001–HC-005 → FR-xxx → SC-001–SC-020 → VER-001–VER-011 |
| Verification definitions | VER-001–VER-011 |
| Traceability | Complete chain from OBJ-001 → HC → FR/BR → SC → VER |
| Wireframe / UI representation | ASCII wireframes for main screen, session configuration, active session, completion state, error state |
| Intended documentation | User guide, configuration reference (breathing patterns), troubleshooting guide |
| Quality review | Step 19 findings: compound requirements split, missing edge cases addressed |
| Guided validation package | Functional validation package produced; human feedback received and propagated |
| Human feedback propagation | Human requested pause-resume behaviour change; analyst updated BR-002, FR-004, SC-004, SC-007, user guide, wireframe, traceability |
| Baseline outcome | Final traceability state, decision record, validation decision, documentation completeness |

## Mode: Guided

The analyst performs full discovery (Phase 2), then pauses for human review of
a curated functional validation package (Phase 3 guided mode). After human
approval with changes, feedback is propagated to all affected artefacts before
the baseline is finalised.

## Fictional project context

- **Project:** BreatheEasy — a mobile-first breathing exercise app
- **Platform:** Progressive Web App (responsive, mobile-first)
- **Users:** General public, with focus on stress reduction and mindfulness
- **Key features:** Configurable breathing patterns, visual guide, optional
  sound cues, session history
- **Monetisation:** Free, no ads