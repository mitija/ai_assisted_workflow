# Spec-Driven, AI-Assisted Development Workflow

**Status:** Working but evolving. Used on real projects, primarily Odoo customization.

**Audience:** Senior developers who may collaborate with us under this flow, or who want to evaluate the methodology. Comments, questions, and suggestions are explicitly welcome — this document is shared for feedback as much as for collaboration.

---

## 1. Problem and Intent

Two failure modes drive this methodology:

- **Spec ambiguity → assumption-driven defects.** The developer fills gaps with assumptions; the consultant rejects the result based on intent that was never written down. The cost is paid in iterations, which are now the dominant cost of software delivery.
- **Specs are no longer read only by humans.** They are increasingly consumed by LLM tooling on the developer side. A spec good enough for a human to interpret is not necessarily good enough for an AI to implement against. Documents must be **AI-ready** as well as human-readable.

The thesis:

> **If the specification is precise enough and the test suite is exhaustive enough, an LLM-assisted developer should be able to produce conforming software in hours, not days — and the cycle should be reproducible by another developer or another LLM later.**

The methodology trades up-front specification rigour for short, lean implementation cycles. The center of gravity sits with the consultant, not the developer.

**Primary context: Odoo customization.** Framework constraints (ORM, view system, module structure, standard UX patterns) remove many decisions that would otherwise need to be specified. The principles generalize to other constrained-framework projects.

---

## 2. Core Principles

1. **The spec is the contract.** If behaviour is not specified or tested, it is not required.
2. **Tests are executable spec.** Every business rule appears as a test scenario with concrete state transitions. Prose alone is not acceptance criteria.
3. **Cycles are short by design.** Typical implementation cycle: a few hours of AI-assisted work. Design effort is pushed upstream so downstream is mechanical. *(TOL Improvements stats to be added.)*
4. **No mid-flight spec changes.** Genuine questions stop work, update the spec, produce a new tag. Implementation never runs in parallel with spec clarification.
5. **The developer is autonomous on method.** We specify the *what* (spec + tests + acceptance), not the *how* (which AI, which IDE, which prompts).
6. **Documentation is a first-class artifact** — own repository, versioned, customer-accessible, kept up to date. A stale spec is worse than no spec.
7. **Local scratch material is not the contract.** Prompts, session notes, copied logs, and experiments may live in the project workspace outside both git repositories. Versioned documentation work may also live under `docs/working/`, but it is still not the frozen implementation contract unless promoted into the tagged customer-facing spec/test docs.

> **A note on strictness.** These principles are not guidelines — they are load-bearing. Loosening any one of them collapses the economics of the lean cycle. The methodology is designed to be adopted as a package, not partially.

---

## 3. Workspace and Repository Layout

The project folder is a **workspace root**, not itself the source repository. It
contains two git repositories with different lifecycles, plus an unversioned
local area:

```
project-folder/
├── docs/                 # documentation/specification git repo
│   ├── customer-facing/  # contractual specs/tests, tagged when ready
│   └── working/          # versioned project documentation work
├── src/                  # source-code git repo
└── local/                # unversioned prompts, session notes, logs, scratch material
```

This separation is deliberate:

- **Documentation repo** — evolves on the specification lifecycle.
- **Code repo** — evolves on the implementation and delivery lifecycle.
- **Local area** — captures unversioned process material that is useful during AI-assisted work but is not a contractual artifact.

Two git repositories are used per project:

**Documentation repo** — single branch, with two top-level areas: `customer-facing/` and `working/`. Customer has read access from day one and validates the customer-facing artifacts directly on the branch. There is no separate review copy. Customer sign-off triggers tagging at each spec freeze (e.g. `spec-260513`). The tag is the stable implementation contract.

```
docs/
├── customer-facing/
│   ├── <epic>_SPEC.md       (functional specification)
│   └── <epic>_TESTS.md      (end-to-end test scenarios)
└── working/                 (versioned project documentation work)
```

**Code repo** — standard. Automated tests live here, derived from the doc scenarios. The dev server tracks the latest delivered work. Source commits, pull requests, development reports, or implementation ledgers should reference the docs tag they implement, so the source history can always be traced back to the exact specification state.

Example source-side reference:

```text
Spec: docs@spec-260513
```

**Docs working area** — versioned by design. `docs/working/` may contain conception notes, consultant-developer Q&A, analysis, and work-in-progress drafts that are relevant to the project and worth preserving with the documentation history. It is part of the docs repo, but it does not override the tagged customer-facing specification and tests.

**Local area** — unversioned by design. `local/` may contain prompt drafts, AI session notes, copied logs, temporary experiments, and other scratch material. It is useful context for humans and AI agents, but it does not override the tagged documentation repo and should not be treated as contractual.

---

## 4. The Specification

### 4.0 Requirement refinement (precursor)

Before the methodology proper, a **refinement** step hardens the initial plain-English requirement. It is a guided, one-question-at-a-time interview (formalized as the `spec-refinement` skill) that turns a rough, high-level requirement into a precise, unambiguous narrative — clarifying the entities, their relationships, the main ways they are manipulated, the key business rules, and the terminology.

It is deliberately **not exhaustive**: it stops once the requirement is precise enough to begin defining models. Exhaustive CRUD, full permissions, field-level types, and exception flows are left to the methodology. The refined narrative is written to `docs/working/refined-requirements.md` and becomes the input to the 5-step methodology below.

### 4.1 The 5-step methodology

A 5-step methodology, formalized as a reusable AI skill (the `specification-methodology` skill):

1. **Models** — entities, fields with explicit types and constraints, relationships, on-delete behaviour. All models extend a `BaseModel` with audit fields.
2. **Roles** — user types and permissions matrix per use case.
3. **Use case identification** — domain-specific first, then CRUD, then extended operations (export, mass operations, state changes).
4. **Use case documentation** — pre-conditions, actors and triggers, main sequence, alternative flows, exception flows, post-conditions, Gherkin acceptance criteria.
5. **Review** — completeness, consistency, traceability, technical feasibility.

Naming conventions, field types, constraint notation (`*`, `U`, `RO`, `C`, `C/S`, `Rel`, `Rel/S`), and relationship semantics (`ref` vs `m2o`) are formalized so that **two consultants — or two LLMs — produce comparable artifacts.**

Outputs are a **wiki-style directory tree** rather than a single document: a `spec-index.md` index plus one file per model under `models/` (global, shared across epics) and one file per use case under `use-cases/`. Large or multi-item sections extract to their own files; large-scope projects may group use cases and tests under `epics/<epic>/` while the data model stays global.

The spec covers as much as needed: functional logic, data schema, business rules, and UI/UX where it deviates from framework defaults. For Odoo, UI/UX is usually thin.

---

## 5. The Test Suite

Each test scenario uses a **state-table format**:

- **Setup** — initial database state, plain English.
- **State table** — one row per step. Columns name the domain-specific quantities tracked. Final column always `Notes`.
- **Per-step expectations** — Given/When/Then prose for each row.
- **Cross-cutting expectations** — invariants that hold across all steps.

A worked example is in **Appendix A**.

If the spec and tests disagree, **the tests win** and the spec is corrected before the next tag.

---

## 6. Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│  Consultant (with AI)                                           │
│  1. Refine the requirement (§4.0), then draft/update SPEC and   │
│     TESTS in docs repo (§4.1)                                   │
│  2. Customer reviews and validates (via docs repo access)       │
│  3. Commit + tag docs when ready (e.g. spec-260513)             │
│  4. Notify developer                                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Developer (with AI, method of their choice)                    │
│  5. Check out docs tag                                          │
│  6. Raise any questions; if genuine → cycle returns to step 1   │
│  7. Implement against spec + tests                              │
│  8. Record the docs tag implemented in source-side traceability │
│  9. Deliver per §6.3                                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Consultant + BA                                                │
│  10. Code review (AI-assisted) against spec                     │
│  11. Run automated tests                                        │
│  12. Behavioural demo on dev server                             │
│  13. Approve, or feed findings into next spec iteration         │
└─────────────────────────────────────────────────────────────────┘
```

**Cycle target: a few hours of implementation per iteration.**

### 6.1 Questions during implementation

- **All questions are answered before implementation begins.** A genuine question that reveals a gap stops the cycle, updates the spec/tests, and produces a new tag. The developer then starts (or restarts) from that tag.
- **Trivial clarifications** that don't change the spec are captured in `docs/working/` or `local/`, depending on whether they should be versioned, without a new tag.
- **No parallel work.** A developer building against an unresolved question is producing rework by design.

### 6.2 Roles

| Role          | Owns                                              | Tools                       |
|---------------|---------------------------------------------------|-----------------------------|
| Consultant    | Spec, tests, acceptance, tagging                  | AI (spec skill), git        |
| BA            | Behavioural validation, customer-facing demo      | Dev server                  |
| Developer     | Code, automated tests, dev server, dev report     | AI (method of their choice) |
| Customer      | Sign-off on customer-facing docs                  | Read access to docs repo    |
| AI (any side) | Drafting, translation, review — never decisions   | —                           |

### 6.3 Developer deliverables

Required at the end of each cycle:

1. **Source code** — committed against the docs tag, with the tag referenced in source-side traceability.
2. **Automated test suite** — covers every state-table row and every cross-cutting invariant in scope.
3. **Development report** — short, covering:
   - Summary of work, tied to use cases and test scenarios.
   - Test coverage statement: what's covered, what isn't, why.
   - Any deviations from spec (should be zero in the routine case).
   - Notable design decisions not dictated by the spec.
4. **Running dev server** — accessible to consultant and BA, with a fixture database suitable for the test scenarios.

---

## 7. Acceptance

Three required pillars:

1. **Automated tests pass** — catches behavioural conformance.
2. **Code review against spec** — AI-assisted, catches architectural drift that tests miss.
3. **Behavioural demo** — consultant + BA exercise the dev server. For Odoo, also covers UI/UX conformance not encoded in tests.

All three are required. None alone is sufficient.

---

## 8. Known Gaps and Open Questions

These are where input from senior developers is most welcome.

### 8.1 The methodology lives or dies by the spec
Enormous onus is on the spec and tests. The developer has no mandate to second-guess them, the AI has no judgement to fall back on, the customer has already signed off. **A bad spec produces bad software on schedule.** This is a feature — it forces specification quality to be taken seriously — but it makes the consultant role the binding constraint on output quality.

### 8.2 The spec itself is AI-drafted
The spec is "vibe-coded" by the consultant in conversation with an AI, then validated by the customer in the docs repo (§3.1). The deeper limitation: **if the consultant asks the AI for something they didn't actually want, the AI produces something they didn't want, and the customer may sign off without spotting it.** The methodology controls drift between spec and code, not between intent and spec. Customer review is the only safety net there.

### 8.3 The current consultant is also a developer

The consultant role today is filled by someone with a developer background. This means:

- The spec routinely defines **technical architecture** — module boundaries, data model, integration points, performance-sensitive design — not just functional behaviour.
- The lean cycle works because the developer arrives at a spec where most architectural decisions are already made.
- A **pure functional consultant** could not produce specs at this level.

In a pure-functional-consultant configuration, the workflow would need to change:

- Add an explicit **technical-design step** between docs tag and implementation.
- Acceptance would need to include **architecture review** separately from spec conformance.
- More tolerance for developer-side decisions, with the trade-off of **less reproducibility across developers**.

This is a scoping caveat, not a flaw: the methodology as described is currently for technically-fluent consultants. Adapting it to functional-only consultancy is open work.

### 8.4 Test execution glue
Test scenarios are plain English; the developer translates them into code-level tests. The translation is a source of drift. Options being considered: a Gherkin-like syntax mapped more directly to code; AI-generated test scaffolding; or accepting the cost and investing in review tooling.

### 8.5 Triggers outside the UI
Scenarios driven from APIs, scheduled jobs, or other non-UI sources are awkward to validate behaviourally on the dev server. A Python script supplements this — a workaround, not a solution.

### 8.6 Developer-side AI workflow
We don't prescribe how the developer uses AI. Deliberate (developers vary, dictating internal workflow is overreach), but it leaves us blind to consistency of method. The contract is the deliverable, not the process. Whether this should change is an open question.

### 8.7 Spec versioning beyond linear tags
A single linear tag sequence works for one project with one developer. Parallel epics, multi-developer engagements, and long-running branches would need a richer model. We haven't needed it yet.

### 8.8 Non-functional requirements
NFRs (performance, security, observability) are captured in a dedicated spec section but not tested with the rigour of functional scenarios. **The largest single technical gap.**

### 8.9 Consultant git fluency
The workflow assumes the consultant can use git fluently — commits, tags, branches, conflicts. Most functional consultants can't. This is a real obstacle to extending the methodology beyond technically-fluent consultants. Options: a wrapper UI, a "spec publishing" step that hides git, or accepting the constraint on adoption.

---

## 9. Summary

The methodology trades up-front specification effort for downstream speed and reproducibility:

- **Implementation cycles are short** because the spec eliminates ambiguity.
- **Acceptance is multi-layered** — tests, AI-assisted code review, behavioural demo.
- **Work is portable** — spec and tests describe the system independently of developer or AI.
- **The customer always has the latest** because the docs repo is shared.

It works when the consultant can write rigorous specs and the developer can execute against them without filling gaps unilaterally. **The bottleneck is those two skills, not the AI.** Risks in §8 are real and named honestly — feedback on closing them is the request.

---

## Appendix A — Sample Test Scenario

Excerpt from a real Odoo procurement scenario. Acronyms (TDQ, VSQ, DQ, OOQ, TOQ) and statuses are defined in the companion spec, not here.

> **TC-INT1 — Full lifecycle: split, partial buy, top-up, edits, validate, cancel, re-buy**
>
> **Setup**
> - Product PROD001, on-hand stock = 3 at the procuring warehouse.
> - No existing TOL line for PROD001, no draft/open real PO for PROD001.
> - VSQ = 3 (captured at TOL creation, frozen). DQ = max(0, TDQ - 3).
>
> **State table**
>
> | # | Action                                       | TDQ | VSQ | DQ | OOQ | TOQ | Status   | Notes                            |
> |---|----------------------------------------------|-----|-----|----|-----|-----|----------|----------------------------------|
> | 1 | Create SO01, qty 7                           |  7  |  3  |  4 |  0  |  4  | to_order | DQ = 7 - 3 = 4                   |
> | 2 | Split API: SO01 ⇒ 6, SO02 ⇒ 11               | 17  |  3  | 14 |  0  | 14  | to_order | TDQ = 6 + 11 = 17                |
> | 3 | Create PO01 via Quick RFQ, override qty 14⇒4 | 17  |  3  | 14 |  4  | 10  | to_order | Default = TOQ; user lowers to 4  |
> | 4 | Create PO02 via Quick RFQ (default qty 10)   | 17  |  3  | 14 | 14  |  0  | rfq      | Default tracks live TOQ          |
> | … |                                              |     |     |    |     |     |          |                                  |
>
> **Per-step expectations (Step 3)**
> - **Given** TDQ = 17, VSQ = 3, DQ = 14, TOQ = 14.
> - **When** user triggers `action_new_quick_rfq`; new PO line defaults to qty 14 (= TOQ).
> - **And** user lowers qty to 4, saves (PO stays draft).
> - **Then** TOL line shows TDQ = 17, VSQ = 3, DQ = 14, OOQ = 4, TOQ = 10, status `to_order`.
> - **And** PO button becomes visible; clicking opens PO01 directly.
>
> **Cross-cutting expectations**
> - Dummy PO stays in `draft` at every step.
> - VSQ = 3 throughout — frozen at TOL creation.
> - DQ is never user-written — computed as max(0, TDQ - VSQ).
> - `sco_status` changes tracked in chatter (who / when / old ⇒ new).

The full scenario runs 10 steps and is followed by 4 sibling scenarios (transferred, dropship, TOQ-zero, cancellation-reactivation). The complete document is ~350 lines.

The format gives the developer:

- **The state table** — what must be true at each step.
- **Per-step Given/When/Then** — how to trigger and assert.
- **Cross-cutting expectations** — invariants to validate throughout.

The result: implementing the test is mechanical. There is no design judgement left to make.
