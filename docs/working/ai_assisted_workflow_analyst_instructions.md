# Instructions for Updating `ai_assisted_workflow`

## Repository

Work directly in the following repository:

`https://github.com/mitija/ai_assisted_workflow`

Your task is to analyse the existing workflow and update its agents, skills, documentation, templates and process definitions to introduce a dedicated requirements-analysis capability.

Do not merely add a conceptual document. Integrate the new process coherently into the existing workflow while preserving useful existing behaviour where appropriate.

---

# 1. Objective

The current workflow requires the human to validate too many detailed specifications.

The revised workflow must allow the human to remain focused on:

- the functional objective;
- high-level requirements;
- high-level success criteria;
- important constraints;
- consequential business decisions;
- key business rules;
- main user journeys;
- wireframes or functional UI behaviour where applicable.

A dedicated analyst agent must autonomously transform those high-level inputs into:

- detailed requirements;
- business rules;
- user journeys and workflows;
- exception and recovery behaviour;
- detailed success criteria;
- verification requirements;
- traceability;
- wireframes where applicable;
- user documentation;
- configuration documentation;
- operational documentation;
- troubleshooting documentation;
- assumptions, decisions, risks and known limitations.

The analyst should ask the human only when human judgement is materially useful.

The intended operating model is:

> The human owns intent and consequential approval.  
> The analyst owns the documented functional model of the intended system.  
> The conductor owns delivery of that functional model and proof that the intended outcome was achieved.

---

# 2. First Step: Inspect the Existing Repository

Before changing files:

1. Inspect the repository structure.
2. Read all relevant agent definitions, skills, workflow instructions, templates and documentation.
3. Identify:
   - how the conductor currently performs analysis and specification refinement;
   - where human validation is currently mandatory;
   - how specifications, implementation plans, tests and reviews are represented;
   - how agents and skills are registered;
   - which existing concepts can be retained;
   - which files need to be updated, replaced, deprecated or added.
4. Preserve the repository’s existing conventions for:
   - file locations;
   - naming;
   - Markdown style;
   - YAML or metadata structures;
   - agent definitions;
   - skill structure;
   - cross-references.

Do not assume the design described below maps one-to-one to existing files. Adapt it to the repository’s current architecture.

---

# 3. Core Roles

## 3.1 Human: Objective Owner

The human owns:

- the problem to solve;
- the desired functional outcome;
- intended users or beneficiaries;
- high-level success criteria;
- important constraints;
- business priorities;
- consequential business decisions;
- validation of the proposed functional interpretation in guided mode.

The human should not normally be asked to decide:

- libraries or frameworks;
- internal code structure;
- database schemas;
- minor technical defaults;
- reversible implementation details;
- routine error handling;
- low-impact UI details;
- formal requirement wording;
- requirement identifiers;
- document structure;
- traceability links;
- detailed acceptance criteria.

The human may provide corrections or feedback, but should not be expected to author or maintain the detailed project documentation.

## 3.2 Analyst: Functional Contract and Documentation Owner

Introduce a dedicated analyst agent.

Use the name `analyst` unless the repository contains a naming convention that strongly suggests a better equivalent.

The analyst owns the transformation from high-level human intent into a complete, defensible and internally consistent functional contract.

Its responsibilities include:

1. Conducting an initial high-level Q&A.
2. Clarifying the functional objective.
3. Capturing high-level success criteria.
4. Inspecting existing evidence before asking unnecessary questions.
5. Researching relevant domain practices and comparable solutions where permitted.
6. Identifying actors, stakeholders and external systems.
7. Modelling important entities, events, states, lifecycles and information flows.
8. Deriving detailed functional requirements.
9. Deriving business rules.
10. Defining important exceptions, errors and recovery behaviour.
11. Deriving relevant non-functional and operational requirements.
12. Defining detailed success criteria.
13. Mapping detailed criteria to high-level criteria.
14. Defining verification methods.
15. Producing low-fidelity wireframes where useful.
16. Authoring and maintaining intended user and operational documentation.
17. Maintaining assumptions, decisions, risks and limitations.
18. Classifying unresolved decisions by impact.
19. Resolving non-blocking decisions autonomously.
20. Escalating only consequential or blocking decisions.
21. Producing a functional validation package in guided mode.
22. Supporting the conductor during implementation when requirements need interpretation.
23. Ensuring implementation changes do not silently alter the approved functional outcome.
24. Maintaining consistency across all functional artefacts throughout the project.

## 3.3 Conductor: Objective and Delivery Owner

Update the conductor so that it no longer performs detailed requirements elicitation itself.

The conductor should:

1. Receive the human’s objective.
2. Determine whether sufficient analysis already exists.
3. Delegate requirements discovery to the analyst when needed.
4. Check that the analyst’s output remains aligned with the original objective.
5. Challenge unnecessary scope, accidental complexity and over-engineering.
6. Accept the requirements baseline once it is sufficiently complete.
7. Decompose implementation work.
8. Coordinate implementation, technical review and independent verification.
9. Validate the delivered result against:
   - the detailed specification;
   - the original functional objective;
   - the human’s high-level success criteria.
10. Ensure traceability, verification evidence and documentation are complete before declaring success.

---

# 4. Documentation Ownership Paradigm

The revised workflow introduces a fundamental change in ownership.

In the current workflow, the human substantially authors, annotates, structures or validates detailed specifications and supporting documentation.

In the revised workflow, the analyst becomes the authoritative owner of the project’s functional documentation.

The human is not expected to draft, annotate or refine the documentation line by line.

The human provides:

- the functional objective;
- high-level requirements;
- high-level success criteria;
- relevant context;
- important constraints;
- answers to consequential questions;
- validation of the overall functional interpretation in guided mode.

The analyst authors and maintains:

- the objective brief;
- functional requirements;
- business rules;
- non-functional requirements;
- user journeys;
- use cases and scenarios;
- wireframes;
- assumptions;
- decisions;
- risks;
- detailed success criteria;
- verification definitions;
- traceability;
- user documentation;
- configuration documentation;
- operational documentation;
- troubleshooting documentation;
- known limitations;
- deferred requirements.

The analyst must actively create these artefacts. It must not ask the human to provide their detailed contents.

The human may validate:

- whether the proposed system solves the intended problem;
- key business rules;
- important user workflows;
- consequential assumptions;
- material scope decisions;
- significant wireframes;
- major exclusions;
- high-level success-criteria coverage.

The analyst should not normally ask the human to:

- edit individual requirements;
- write formal requirement statements;
- assign identifiers;
- construct the traceability matrix;
- define routine edge cases;
- specify ordinary error handling;
- document configuration fields;
- write detailed acceptance criteria;
- organise documentation;
- maintain consistency between documents.

If the human changes a key business rule, the analyst must identify and update every affected artefact, including where relevant:

- requirements;
- user journeys;
- wireframes;
- success criteria;
- verification methods;
- user documentation;
- configuration documentation;
- traceability;
- implementation scope.

The human must not be required to identify those affected artefacts manually.

The analyst should maintain a single coherent functional baseline. Where several documents describe the same behaviour, it must ensure they remain consistent.

The workflow should define which artefact is authoritative when inconsistencies occur. Prefer structured and traceable sources for requirements, success criteria and decisions, with readable documents generated from or checked against those sources where practical.

The analyst must detect contradictions such as:

- a business rule differing from the user guide;
- a wireframe exposing an action forbidden by the requirements;
- a success criterion testing behaviour absent from the specification;
- a configuration option documented but unsupported;
- implemented behaviour not reflected in the operations guide;
- a requirement changed without updating traceability.

Documentation updates are part of the analyst’s normal work throughout the project. They are not a separate administrative task assigned to the human.

---

# 5. Initial Discovery Session

Every non-trivial project should begin with a structured Q&A between the human and the analyst.

The purpose is to establish:

- the problem to solve;
- intended users;
- intended functional outcome;
- high-level success criteria;
- important constraints;
- explicit exclusions;
- major preferences;
- known integrations;
- required operating mode.

The questions must remain high-level and functional.

The analyst should not begin by asking the human to define:

- detailed entities;
- fields;
- state transitions;
- exception handling;
- database design;
- service boundaries;
- libraries;
- infrastructure details;
- routine technical choices.

The initial Q&A should produce an objective brief containing, where applicable:

- objective;
- problem statement;
- beneficiaries or users;
- high-level success criteria;
- constraints;
- scope boundaries;
- explicit exclusions;
- known integrations;
- assumptions already supplied by the human;
- selected operating mode.

The human should confirm this objective baseline before detailed autonomous analysis proceeds.

This initial confirmation is not approval of a detailed specification. It confirms that the analyst has understood the intended outcome.

---

# 6. Two Analysis Modes

The same underlying analysis process must support two operating modes.

## 6.1 Autonomous Mode

In autonomous mode, the analyst:

- performs the analysis;
- derives requirements and business rules;
- makes non-blocking decisions;
- records decisions and rationale;
- creates wireframes where useful;
- produces the specification;
- produces traceability;
- produces intended documentation;
- completes requirements review;
- allows the conductor to proceed into implementation without mandatory intermediate human approval.

The analyst should interrupt the human only for decisions that are consequential, blocking or unsafe to infer.

The governing rule is:

> Non-blocking uncertainty is resolved and recorded, not escalated.

Autonomous mode is expected to continue through implementation, verification and documentation completion unless a blocking or consequential decision arises.

## 6.2 Guided Mode

In guided mode, the analyst performs the same autonomous analysis but pauses before implementation.

It should produce a concise functional validation package for human review.

The human reviews the functional interpretation, not every individual requirement.

The validation package should include, where applicable:

- refined functional outcome;
- scope boundaries;
- main user journeys;
- key business rules;
- important exceptions;
- significant assumptions;
- decisions made autonomously;
- decisions requiring confirmation;
- low-fidelity wireframes;
- detailed success-criteria coverage;
- high-level traceability summary;
- explicit exclusions and limitations.

The human should be able to respond with the equivalent of:

- approved;
- approved with changes;
- reanalyse.

After feedback, the analyst must update the complete requirements set and all affected documentation consistently.

There should normally be only one mandatory functional validation gate before implementation.

Do not introduce approval pauses after every analysis stage.

## 6.3 Mode Transitions

The workflow should allow mode changes during a project.

Examples:

- begin in guided mode for a new product;
- switch to autonomous mode after the functional validation gate;
- temporarily return to guided mode if a material scope change emerges;
- use guided analysis with autonomous implementation.

Treat analysis governance and implementation autonomy as separate configuration dimensions where practical.

---

# 7. Decision Classification

Define and document a decision policy.

A suggested model is:

- **Class A:** minor, low-impact and reversible;
- **Class B:** functional but low-impact;
- **Class C:** material business, UX, security, cost or scope decision;
- **Class D:** blocking, contradictory, high-risk or difficult to reverse.

Expected behaviour:

| Class | Autonomous mode | Guided mode |
|---|---|---|
| A | Decide and record | Decide and record |
| B | Decide and highlight | Include in validation package |
| C | Ask the human | Include prominently or ask immediately if blocking |
| D | Stop and ask | Stop and ask |

The analyst may decide autonomously when:

- there is a strong convention or project precedent;
- the decision is reversible;
- the cost of being wrong is low;
- it does not materially change scope;
- it does not materially alter the user experience;
- it does not create significant security, privacy, legal or financial exposure.

The analyst should escalate when a decision:

- changes the requested functional outcome;
- creates material cost;
- expands scope significantly;
- introduces legal, privacy or security exposure;
- is difficult to reverse;
- depends strongly on personal preference;
- affects a major user workflow;
- has multiple plausible alternatives with materially different consequences;
- cannot be inferred with sufficient confidence.

Questions to the human should be framed as decisions and include:

- the question;
- recommended option;
- rationale;
- alternatives;
- consequences where relevant.

Avoid open-ended questioning where a bounded recommendation can be made.

---

# 8. Requirements Discovery Process

Create or revise the relevant skill so the analyst follows a process similar to:

1. Frame the objective.
2. Capture high-level success criteria.
3. Inspect repository, environment and existing evidence.
4. Research domain conventions and comparable systems where appropriate.
5. Identify actors, stakeholders and external systems.
6. Model important entities, events, states, lifecycles and information flows.
7. Generate candidate requirements.
8. Define business rules.
9. Analyse exceptions, failures, recovery and edge cases.
10. Identify contradictions and gaps.
11. Classify decisions.
12. Resolve non-blocking decisions.
13. Escalate consequential decisions.
14. Define detailed success criteria.
15. Define verification methods.
16. Draft intended user and operational documentation.
17. Use documentation gaps to discover missing requirements.
18. Produce wireframes where they help validate behaviour.
19. Perform an independent requirements-quality review.
20. Produce the requirements baseline and traceability package.

The process should be evidence-first rather than question-first.

The analyst should inspect existing documentation, code, configuration and project conventions before asking questions whose answers can reasonably be inferred.

Retain useful techniques from the current process, including:

- contradiction detection;
- scenario analysis;
- exception analysis;
- trade-off identification;
- distinguishing examples from general rules;
- detecting ambiguous terms;
- checking assumptions against existing evidence.

---

# 9. Requirements Provenance

The rule “never invent requirements” should be replaced or refined.

The analyst is explicitly allowed to design sensible requirements, provided their origin is recorded honestly.

Each requirement or important rule should be classifiable as one of:

- explicitly requested by the human;
- inferred from supplied context;
- inherited from existing project standards;
- inferred from domain best practice;
- selected as an analyst design decision;
- required as a risk control;
- unresolved.

The governing rule is:

> Never silently present an inferred requirement as though it was explicitly requested by the human.

Where useful, requirements should record:

- stable identifier;
- statement;
- rationale;
- source or provenance;
- confidence;
- impact if wrong;
- whether human confirmation is required;
- related objective;
- related success criteria;
- priority.

Do not introduce excessive bureaucracy for trivial work. The format should scale with project complexity and risk.

---

# 10. Success Criteria Hierarchy

Introduce a formal hierarchy between human intent and verification.

The chain should be:

```text
Functional objective
    ↓
High-level human success criterion
    ↓
Requirement or business rule
    ↓
Detailed success criterion
    ↓
Verification method
    ↓
Implemented test, inspection or evidence
```

The human provides high-level criteria such as:

- I can communicate reliably with Hermes through Discord.
- A clean VPS can be configured automatically.
- The solution is sufficiently secure for personal use.

The analyst derives detailed success criteria such as:

- an authorised Discord user receives a Hermes response;
- unauthorised users are rejected;
- a process failure does not terminate the bot;
- a clean supported VPS can be configured without manual changes;
- the Ansible playbook is idempotent;
- secrets are absent from the repository and normal logs.

Requirements and success criteria must remain distinct.

Example:

- **Requirement:** the service shall restart after unexpected failure.
- **Detailed success criterion:** after the process is forcibly terminated, the service becomes available again within 60 seconds without manual intervention.
- **Verification:** automated recovery test.

The analyst must ensure:

- every detailed success criterion maps to at least one high-level criterion;
- every high-level criterion has sufficient detailed coverage;
- every mandatory requirement has a verification method;
- no criterion is silently weakened during implementation.

---

# 11. Traceability

Add a traceability mechanism and supporting documentation.

Use stable identifiers such as:

- `OBJ-001` for objectives;
- `HC-001` for high-level criteria;
- `FR-001` for functional requirements;
- `BR-001` for business rules;
- `NFR-001` for non-functional requirements;
- `SC-001` for detailed success criteria;
- `VER-001` or `TEST-001` for verification;
- `DOC-001` for documentation requirements;
- `DEC-001` for decisions;
- `RISK-001` for risks.

Adapt identifiers to repository conventions if needed.

The traceability model should support questions such as:

- Why does this requirement exist?
- Which human objective does it support?
- Which detailed criterion proves it?
- How will it be verified?
- Has it been verified?
- What evidence exists?
- Which objectives have insufficient coverage?
- Which requirements do not support an objective, constraint or risk control?
- Which tests are not linked to expected behaviour?
- What is affected if a requirement changes?

The process should identify:

- orphan requirements;
- unsupported objectives;
- orphan tests;
- unverified requirements;
- missing documentation coverage;
- unexplained scope additions.

Prefer a machine-readable source with generated or maintained Markdown where this fits the repository.

Possible structure:

```text
requirements/traceability.yaml
docs/traceability.md
```

Adapt this to the repository’s existing conventions.

The traceability data should evolve during implementation to include:

- verification status;
- test or inspection reference;
- evidence;
- deferred items;
- known limitations.

---

# 12. Requirements Quality Gate

Before implementation, the analyst or a separate read-only requirements reviewer should check each requirement for:

- necessity;
- clarity;
- singularity;
- consistency;
- feasibility;
- testability;
- traceability;
- appropriate implementation independence;
- priority;
- visible assumptions;
- absence of unnecessary scope.

The requirements set as a whole should be:

- sufficiently complete;
- internally consistent;
- bounded;
- risk-aware;
- proportionate to the project;
- traceable to the functional objective;
- explicit about unresolved matters.

Completeness does not mean describing every technical detail.

It means that any remaining implementation freedom can safely be exercised by implementation agents.

Consider introducing a dedicated `requirements-reviewer` agent if that fits the existing architecture better than a self-review step.

This reviewer should be distinct from the implementation code reviewer.

---

# 13. Wireframes and Functional UI Review

Where the work includes meaningful UI components, the analyst should produce low-fidelity wireframes or equivalent functional UI representations.

These should help validate:

- primary workflows;
- information hierarchy;
- navigation;
- visible actions;
- state transitions;
- permissions;
- error states;
- empty states;
- what each user role can see or do.

Wireframes should remain focused on behaviour and structure.

They should not unnecessarily specify:

- final colours;
- branding;
- typography;
- detailed visual polish.

In guided mode, wireframes should normally appear in the functional validation package.

In autonomous mode, they may be created without interruption unless they expose a Class C or D decision.

---

# 14. Documentation as Part of Analysis

Documentation is part of the functional contract, not an afterthought.

The analyst must author intended documentation during analysis as though the system already existed.

Use gaps in the documentation to discover missing requirements.

If the analyst cannot clearly explain how the intended system is used, configured or operated, the functional analysis is probably incomplete.

Depending on the project, documentation may include:

- user guide;
- configuration reference;
- operations guide;
- troubleshooting guide;
- deployment guide;
- upgrade guide;
- backup and restore procedure;
- security and secret-management guidance;
- limitations and exclusions.

## 14.1 User Guide

The user guide should explain:

- purpose of the system;
- intended users;
- normal workflows;
- supported behaviour;
- permissions;
- expected responses;
- limitations;
- examples.

## 14.2 Configuration Reference

The configuration reference should document every externally supported configuration item, including where relevant:

- name;
- purpose;
- type;
- required or optional;
- default;
- allowed values;
- example;
- security implications;
- whether restart or redeployment is required.

## 14.3 Operations Guide

The operations guide should cover, where relevant:

- installation;
- start and stop;
- upgrade;
- monitoring;
- health checks;
- logging;
- backup and restore;
- secret rotation;
- failure recovery;
- rebuild;
- uninstall.

## 14.4 Troubleshooting Guide

The troubleshooting guide should cover:

- symptoms;
- likely causes;
- diagnostic steps;
- corrective actions;
- escalation conditions.

## 14.5 Documentation Requirements

Documentation requirements should themselves be traceable.

Examples:

- every accepted configuration key must appear in the configuration reference;
- every important user-facing behaviour must be described;
- every required operational procedure must be documented;
- examples must reflect supported behaviour;
- known limitations must be explicit.

---

# 15. Documentation Lifecycle

The analyst owns documentation across the full project lifecycle.

## 15.1 Initial Analysis

The analyst creates:

- objective brief;
- initial assumptions;
- initial scope;
- initial high-level traceability.

## 15.2 Detailed Analysis

The analyst expands the baseline into:

- detailed requirements;
- business rules;
- user journeys;
- wireframes;
- success criteria;
- verification definitions;
- intended user and operational documentation.

## 15.3 Guided Validation

The analyst produces a curated functional validation package.

The human reviews the proposed functional interpretation.

The analyst then incorporates feedback into all affected documents.

The human should not be asked to edit the underlying documentation directly unless they explicitly choose to do so.

## 15.4 Implementation

The analyst:

- answers functional interpretation questions;
- evaluates proposed requirement changes;
- updates documentation when legitimate discoveries occur;
- prevents implementation decisions from silently becoming new functional requirements;
- maintains traceability between approved intent and implementation.

## 15.5 Verification

The analyst ensures:

- verification evidence maps to the correct success criteria;
- failed criteria are reflected accurately;
- limitations and deviations are documented;
- user and operational documentation reflect verified behaviour.

## 15.6 Completion

The analyst delivers the completed documentation baseline with the implemented system.

The final documentation must explain:

- what the system is intended to do;
- how it should be used;
- how it should be configured;
- how it should be operated;
- how success was verified;
- what limitations remain;
- which decisions were made autonomously;
- which decisions were confirmed by the human.

---

# 16. Human Review Is Not Document Authorship

In guided mode, human review must not revert to a document-writing exercise.

The analyst should present a concise, curated package focused on matters requiring human judgement.

The human may approve, reject or amend the functional direction.

The analyst must then perform the detailed documentation work.

For example, the analyst may ask:

> Should a paused breathing session resume from the beginning of the current phase or from the exact point at which it was paused?

Once the human answers, the analyst must update:

- the applicable business rule;
- the user journey;
- the wireframe;
- the functional requirement;
- the detailed success criterion;
- the verification scenario;
- the user guide;
- the traceability links.

The workflow should treat this propagation as a core analyst responsibility.

---

# 17. Separation of Verification Responsibilities

The analyst defines:

- detailed success criteria;
- required test conditions;
- expected observable results;
- verification method;
- tolerances;
- mapping to high-level goals.

Implementation agents create:

- automated tests;
- fixtures;
- test environments;
- scripts;
- probes;
- monitoring checks.

The verifier:

- executes verification independently;
- records evidence;
- updates status;
- identifies failures and gaps.

The conductor:

- confirms all high-level success criteria are adequately covered;
- ensures tests were not changed merely to match an incorrect implementation;
- checks the final outcome against both detailed requirements and the original objective.

The implementing agent must not be permitted to redefine success after implementation.

---

# 18. Suggested Artefact Model

Adapt the following conceptual structure to the repository:

```text
analysis/
├── objective.md
├── stakeholders.md
├── assumptions.md
├── decisions.md
├── risks.md
└── research.md

requirements/
├── functional.yaml
├── business-rules.yaml
├── non-functional.yaml
├── success-criteria.yaml
└── traceability.yaml

docs/
├── intended-user-guide.md
├── intended-configuration-reference.md
├── intended-operations-guide.md
└── intended-troubleshooting.md

specification.md
```

Do not create all these files blindly for every project.

Define a scalable model:

- small tasks may use a single consolidated specification;
- larger or higher-risk projects may use separate files;
- the same conceptual information must still be represented.

---

# 19. Workflow Integration

Update the workflow so it broadly follows:

```text
Human objective
    ↓
Initial analyst Q&A
    ↓
Objective brief
    ↓
Human confirms high-level objective and success criteria
    ↓
Analyst performs autonomous requirements discovery
    ↓
Requirements quality review
    ↓
Guided mode only: functional validation package and human approval
    ↓
Requirements baseline
    ↓
Conductor checks alignment with original objective
    ↓
Implementation decomposition
    ↓
Implementation
    ↓
Technical review
    ↓
Independent verification
    ↓
Documentation checked against actual behaviour
    ↓
Traceability updated with evidence
    ↓
Conductor performs functional outcome review
    ↓
Final human outcome review
```

The conductor must not declare the project complete merely because unit tests pass.

Completion should require:

- all mandatory detailed success criteria pass;
- high-level human criteria have sufficient evidence;
- no unexplained traceability gaps remain;
- documentation reflects actual supported behaviour;
- configuration documentation is complete;
- known limitations and deferred criteria are explicit;
- the original functional objective is demonstrably achieved.

---

# 20. Documentation Completion Gate

The conductor must not consider documentation complete merely because files exist.

Before completion, the analyst must demonstrate that:

- all high-level objectives are represented;
- key business rules are documented;
- detailed requirements are traceable;
- success criteria are defined;
- verification evidence is linked;
- user-visible behaviour is documented;
- supported configuration is documented;
- operational procedures are documented;
- known limitations are explicit;
- autonomous analyst decisions are recorded;
- human-confirmed decisions are identifiable;
- no material contradictions remain between artefacts.

Documentation completeness and consistency are mandatory delivery criteria.

---

# 21. Existing Skills and Agents

Review and update all relevant existing files, including where applicable:

- conductor agent definition;
- conductor analysis skill;
- conductor decomposition skill;
- specification refinement skill;
- specification methodology;
- review and verification skills;
- workflow documentation;
- templates;
- examples;
- agent registry;
- README files;
- files describing mandatory human validation.

The current detailed human-interview-based specification flow should be replaced or substantially revised.

Possible skill names include:

- `requirements-discovery`;
- `requirements-analysis`;
- `functional-analysis`;
- `requirements-review`.

Use names that best fit the repository’s existing conventions.

The conductor should no longer load a human-driven specification-refinement process as a hidden substitute for the analyst.

---

# 22. Compatibility and Migration

Where reasonable:

- preserve useful existing specification techniques;
- retain contradiction detection;
- retain scenario analysis;
- retain trade-off identification;
- retain distinction between examples and general rules;
- retain implementation review and verification roles;
- avoid breaking unrelated workflow behaviour.

Clearly document renamed or deprecated skills.

Update references so there are no stale links or instructions pointing to removed or superseded files.

---

# 23. Required Examples

Add or update examples demonstrating both modes.

Use at least the following examples because they exercise different forms of analysis.

## 23.1 Example A: Hermes Agent on a VPS

Objective:

- configure a Hermes agent using Ansible on a VPS;
- communicate with it through Discord;
- make the installation reproducible, maintainable and appropriately secure.

The example should demonstrate:

- initial high-level Q&A;
- high-level success criteria;
- inferred operational requirements;
- security and authorisation decisions;
- configuration documentation;
- restart and recovery criteria;
- deployment and idempotency criteria;
- traceability;
- autonomous decision-making.

## 23.2 Example B: Breathing Exercise Application

Objective:

- create a breathing exercise application similar in functional intent to existing breathing apps;
- guide users through configurable breathing sessions.

The example should demonstrate:

- functional user journeys;
- business rules;
- pause, resume and interruption behaviour;
- low-fidelity wireframes;
- accessibility or usability requirements;
- detailed success criteria;
- guided functional validation;
- propagation of human feedback into all affected documents.

---

# 24. Implementation Approach

Perform the repository changes directly.

Work in small, coherent steps.

After editing:

1. Review all changed files.
2. Search for stale references to the old process.
3. Check naming and cross-links.
4. Validate YAML, JSON and other structured metadata.
5. Run existing repository tests, linters or validation scripts.
6. Add tests or validation where the repository supports them.
7. Ensure the resulting workflow is internally consistent.
8. Confirm the analyst has clear ownership of functional documentation.
9. Confirm the conductor no longer depends on the human to author detailed specifications.
10. Confirm both autonomous and guided modes are represented coherently.

Do not stop after producing a proposal.

Make the actual repository changes.

---

# 25. Required Final Report

At the end, provide:

1. A concise summary of the implemented design.
2. The list of files added.
3. The list of files modified.
4. Any files removed or deprecated.
5. Important design decisions made.
6. Assumptions.
7. Unresolved issues.
8. Validation or tests performed.
9. A short example of how a user would invoke:
   - autonomous analysis mode;
   - guided analysis mode.
10. A brief explanation of how documentation ownership now works.
11. A brief explanation of how traceability connects human objectives to verification evidence.

Do not merely describe intended changes. Complete the changes in the repository.
