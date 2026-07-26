---
name: analyst-discovery
description: Phase 2 of the analyst workflow. Transforms the confirmed objective brief into a complete, defensible functional contract through a structured 20-step discovery process. Evidence-first — inspects existing material before asking. Class A and B decisions are resolved autonomously; Class C and D decisions are handled according to the selected analysis mode. Produces requirements, business rules, success criteria, verification definitions, wireframes, and intended documentation.
allowed-tools: Read, Grep, Glob, Edit, Write, WebFetch, Question
---

# Analyst Discovery Skill

This is Phase 2 of the analyst workflow. Load it after the objective brief is
confirmed.

## Purpose

Transform the high-level objective brief into a complete, internally consistent
functional contract. This phase is evidence-first: inspect before asking.
Class A and B decisions are resolved autonomously; Class C and D decisions
are handled according to the selected analysis mode.

## The 20-step discovery process

Follow these steps in order. Each step builds on the previous. Do not skip
steps unless the project is trivially small and the step clearly does not apply
(state why if skipping).

### Step 1 — Frame the objective

Restate the objective from the brief in precise terms. Identify the core
outcome the system must achieve. Distinguish the primary goal from secondary
desires.

### Step 2 — Capture high-level success criteria

Extract every high-level success criterion the human stated or implied. Record
them as HC-001, HC-002, etc. Do not yet derive detailed criteria — that comes
later.

### Step 3 — Inspect repository, environment and existing evidence

Read existing code, documentation, configuration, templates, and project
conventions. Look for:

- existing models, schemas, or data structures
- existing business rules documented elsewhere
- prior requirements or specifications
- environment constraints (languages, frameworks, platforms)
- naming conventions and terminology

Do not ask questions whose answers are already available in the repository.

### Step 4 — Research domain conventions and comparable systems

Where permitted (webfetch allowed), research:

- domain standard practices
- comparable open-source systems
- common patterns and pitfalls
- regulatory or compliance conventions

Record findings concisely. Distinguish established conventions from opinions.

### Step 5 — Identify actors, stakeholders and external systems

List every:

- **Actor** — human role or external system that interacts with the intended
  system
- **Stakeholder** — person or group with an interest in the outcome (not
  necessarily a direct user)
- **External system** — existing system the solution must integrate with

For each, note their goals, interests, and interaction patterns.

### Step 6 — Model important entities, events, states, lifecycles and information flows

Identify the key entities the system must store, track, or manage. For each:

- attributes (high-level, not exhaustive field list)
- lifecycle states and valid transitions
- relationships to other entities
- events that trigger state changes
- information flows between actors and entities

Produce lightweight models — tables, lists, or diagrams in text. Do not design
database schemas.

### Step 7 — Generate and classify candidate requirements

Derive functional, non-functional, operational, and documentation requirements
from:

- the objective and high-level criteria
- actor goals and workflows
- entity lifecycles and state transitions
- external system interactions
- domain research findings

For each requirement, determine whether it is:

- **Functional (FR-xxx)** — a specific behaviour or capability the system
  must provide
- **Non-functional / quality (NFR-xxx)** — a quality attribute or constraint
  on system behaviour (performance, security, privacy, accessibility,
  reliability, availability, maintainability, observability)
- **Operational / infrastructure (OPS-xxx)** — a constraint or capability
  related to deployment, configuration, backup/recovery, monitoring,
  support/operations, or infrastructure
- **Documentation (DOC-xxx)** — a required document, reference, or label
  the system must produce or expose

Explicitly consider each of the following areas. For each, either derive at
least one requirement or record a rationale for why it is not applicable:

| Area | Typical concern |
|------|----------------|
| Security | Authentication, authorisation, encryption, audit, secrets management, input validation |
| Privacy | Data minimisation, retention, consent, anonymisation, PII handling |
| Accessibility | WCAG compliance, screen-reader support, keyboard navigation, colour contrast |
| Performance | Response times, throughput, concurrency, batch windows, latency |
| Availability | Uptime SLA, planned maintenance windows, graceful degradation, failover |
| Reliability | Error handling, data integrity, idempotency, consistency guarantees |
| Observability | Logging, metrics, tracing, health checks, alerting, dashboards |
| Maintainability | Code modularity, configuration externalisation, upgrade paths, API versioning |
| Deployment | Build pipeline, environment provisioning, release strategy, rollback |
| Configuration | Environment variables, feature flags, secrets, runtime settings |
| Backup / recovery | Snapshot schedule, retention policy, restore procedure, disaster recovery |
| Regulatory / compliance | GDPR, SOC2, PCI-DSS, HIPAA, jurisdiction-specific rules |
| Support / operations | Incident response, escalation paths, runbooks, SLAs, on-call rotation |

Write each requirement as a clear statement: "The system shall [behaviour]
under [condition]." Assign a provisional identifier (FR-xxx, NFR-xxx,
OPS-xxx, or DOC-xxx).

For every requirement, record:

- **Provenance** — how it was derived (explicitly-requested, inferred-context,
  inherited, domain-practice, design-decision, risk-control, unresolved)
- **Confidence** — high/medium/low assessment
- **Rationale** — why this requirement exists
- **Impact** — cost, scope, or risk impact if missing
- **Success criteria** — at least one measurable criterion (detailed in Step 14)
- **Verification approach** — how it will be verified (detailed in Step 15)
- **Traceability** — link to the source (HC-xxx, actor goal, entity,
  external system)

### Step 8 — Define business rules

From the Q&A, domain research, and entity models, extract:

- constraints on data or behaviour
- derivation rules (what is computed from what)
- authorisation rules (who can do what)
- sequencing rules (what must happen before what)

Record each as BR-xxx with the rule statement, rationale, source, and exactly one
canonical provenance label (explicitly-requested, inferred-context, inherited,
domain-practice, design-decision, risk-control, unresolved).

### Step 9 — Analyse exceptions, failures, recovery and edge cases

For every requirement and business rule, consider:

- What can go wrong? (network failure, invalid input, concurrent access,
  timeout, partial failure)
- What is the system's expected behaviour in each case?
- How does it recover?
- What are the edge cases? (empty states, boundary values, duplicate
  submissions, rapid repeated actions)

Record explicit exception and recovery requirements where the behaviour is not
obvious.

### Step 10 — Identify contradictions and gaps

Cross-check all artefacts produced so far:

- Do any requirements contradict each other?
- Do any business rules conflict?
- Are there scenarios not covered by any requirement?
- Are there success criteria with no supporting requirements?

Flag each contradiction or gap. If resolvable autonomously, resolve it and
record the decision. If not, classify and escalate.

### Step 11 — Classify decisions

Review every unresolved decision and classify as A, B, C, or D (see the
analyst agent's decision classification). Record the classification and
rationale.

### Step 12 — Resolve Class A and B decisions (both modes)

For Class A and B decisions:

- Apply the most logical option based on evidence, precedent, and convention
- Record the decision (DEC-xxx), rationale, and alternative considered
- Do not ask the human
- In guided analysis, flag Class B decisions for prominent inclusion in the
  Phase 3 validation package

### Step 13 — Handle Class C and D decisions (mode-dependent)

For Class C and D decisions, behaviour depends on the analysis mode recorded
in the objective brief:

**Class C (material decision):**

- **Autonomous analysis**: stop and ask the human immediately. Frame the
  question with: the issue, your recommended option, rationale, alternatives,
  and consequences. Ask one question at a time, waiting for the answer. Record
  the human's decision as DEC-xxx.
- **Guided analysis**: if the decision blocks continued analysis (nothing can
  proceed without a ruling), ask immediately using the same framing. Otherwise,
  record the provisional decision (DEC-xxx) with a "pending-human-validation"
  tag and include it prominently in the Phase 3 validation package. Do not ask
  the human now.

**Class D (blocking decision):**

- **Both modes**: stop and ask the human immediately. Frame the question with:
  the issue, your recommended option, rationale, alternatives, and consequences.
  Ask one question at a time, waiting for the answer. Record the human's
  decision as DEC-xxx. Do not continue until the human responds.

### Step 14 — Define detailed success criteria

For every requirement and business rule, define at least one detailed success
criterion (SC-xxx). Each must be:

- specific and measurable
- verifiable (pass/fail or observed value)
- mapped to at least one high-level criterion (HC-xxx)
- distinct from the requirement itself

### Step 15 — Define verification methods

For every detailed success criterion, define how it will be verified:

- automated test (unit, integration, end-to-end)
- manual inspection
- documented procedure
- observed evidence (log, screenshot, output)

Record as VER-xxx. The verification method defines **what** to check, not the
implementation of the test itself.

### Step 16 — Draft intended user and operational documentation

Write documentation as though the system already exists:

- **User guide** — purpose, intended users, normal workflows, supported
  behaviour, permissions, expected responses, limitations, examples
- **Configuration reference** — every externally supported configuration item:
  name, purpose, type, required/optional, default, allowed values, example,
  security implications, restart required
- **Operations guide** — installation, start/stop, upgrade, monitoring, health
  checks, logging, backup/restore, secret rotation, failure recovery, rebuild,
  uninstall
- **Troubleshooting guide** — symptoms, likely causes, diagnostic steps,
  corrective actions, escalation conditions

Write only the sections that apply to the project. Use gaps in documentation
to discover missing requirements (Step 17).

### Step 17 — Use documentation gaps to discover missing requirements

Review the documentation you just wrote. Wherever you could not clearly explain
behaviour, configuration, or operation, you have likely found a gap in the
requirements. Add the missing requirements and update all affected artefacts.

### Step 18 — Produce wireframes where they help validate behaviour

Where the work includes meaningful UI components, produce low-fidelity
wireframes (ASCII art, text layouts, or simple structural diagrams). These
should validate:

- primary workflows and navigation
- information hierarchy
- visible actions and state transitions
- permissions — what each role can see or do
- error states and empty states

Wireframes focus on behaviour and structure. Do not specify final colours,
branding, typography, or detailed visual polish.

In guided analysis, wireframes should appear in the validation package. In
autonomous analysis, create them without interruption unless they expose a
Class C or D decision (which must be asked immediately per Step 13).

### Step 19 — Perform an independent requirements-quality review

Review the complete set of requirements against the quality criteria (see
`analyst-review` skill if loaded separately, or apply them directly):

- **Necessity** — does each requirement support an objective, constraint, or
  risk control?
- **Clarity** — is each requirement unambiguous?
- **Singularity** — does each requirement address exactly one behaviour?
- **Consistency** — no internal contradictions
- **Feasibility** — is the requirement achievable within known constraints?
- **Testability** — can success or failure be determined unambiguously?
- **Traceability** — is each requirement linked to its source and criteria?
- **Implementation independence** — does the requirement say *what*, not *how*?
- **Priority** — is relative importance clear?
- **Visible assumptions** — are assumptions explicit?
- **No unnecessary scope** — is each requirement justified?

Fix any issues found. Record findings.

### Step 20 — Produce the requirements baseline and traceability package

Consolidate everything into a coherent baseline:

- Requirements (functional FR, business rules BR, non-functional NFR,
  operational OPS, documentation DOC) with stable identifiers, statements,
  rationale, provenance, and priority
- Detailed success criteria with high-level criterion mappings
- Verification methods
- Traceability links: objective → high-level criterion → requirement
  (FR/BR/NFR/OPS/DOC) → detailed criterion → verification method
- Assumptions, decisions (with rationale), risks, known limitations
- Intended documentation
- Wireframes (where applicable)

## Output

The complete requirements baseline, ready for the quality gate (Phase 3). All
artefacts are internally consistent and traceable. The baseline explicitly
includes functional (FR), business rules (BR), non-functional (NFR),
operational (OPS), and documentation (DOC) requirements,
each with provenance, confidence, rationale, impact, success criteria,
verification, and traceability. Non-applicable categories are documented with
rationale.

## Quality checklist

- [ ] All 20 steps completed (skipped steps documented with rationale)
- [ ] Every requirement (FR/NFR/OPS/DOC) has a provenance label
- [ ] Every business rule (BR) has a provenance label
- [ ] Every requirement has at least one detailed success criterion
- [ ] Every detailed success criterion maps to a high-level criterion
- [ ] Every mandatory requirement has a verification method
- [ ] Provenance and traceability are verified for requirements and business rules across all five classes (FR/BR/NFR/OPS/DOC)
- [ ] All Class A/B decisions resolved and recorded; Class B flagged for validation package in guided mode
- [ ] All Class C decisions handled per mode (asked immediately in autonomous; deferred to validation package or asked immediately in guided)
- [ ] All Class D decisions stopped and asked immediately in both modes
- [ ] No evidence was ignored before asking questions
- [ ] Documentation gaps used to discover missing requirements
- [ ] No implementation code was written
- [ ] Wireframes produced where UI behaviour is meaningful
- [ ] Every non-functional, operational, and documentation requirement has stable ID, provenance, confidence, rationale, impact, and traceability
- [ ] Each of security, privacy, accessibility, performance, availability, reliability, observability, maintainability, deployment, configuration, backup/recovery, regulatory/compliance, and support/operations was explicitly considered — either requirements exist or rationale is recorded for inapplicability
- [ ] Non-applicable categories are documented with rationale, not silently omitted