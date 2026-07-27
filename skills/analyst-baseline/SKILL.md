---
name: analyst-baseline
description: Phase 4 of the analyst workflow. Establishes and maintains the requirements baseline with stable identifiers, traceability, and consistency across the project lifecycle. Supports implementation (interpretation, change evaluation, scope protection), verification (evidence mapping), and completion (final documentation baseline). Maintains traceability from objective through high-level criteria, requirements, detailed criteria, verification, and evidence.
allowed-tools: Read, Grep, Glob, Edit, Write, Question
---

# Analyst Baseline Skill

This is Phase 4 of the analyst workflow. Load it after the quality gate
(Phase 3) completes and the requirements set is approved.

## Purpose

Establish the authoritative requirements baseline with stable identifiers and
full traceability. Maintain consistency across all functional artefacts
throughout implementation, verification, and completion. The baseline is the
single source of truth for the functional contract.

## Documentation tag policy

Only the analyst may create an immutable tag in the configured documentation
repository. Do so only after the applicable quality and baseline gates; guided
analysis additionally requires human validation approval, while autonomous
analysis requires that no blocking Class C or D decision remains. Use the
project's canonical naming convention, defaulting to `spec-YYMMDD` with a
deterministic collision suffix. The tag must point to the committed approved
documentation baseline and be recorded with repository, tag, commit, baseline,
validation, and publication status. Record it as the current implementation
tag. Never move, delete, or repoint an existing tag; any change requires a new
tag. Tag creation is distinct from push or publication, which requires separate
authorization. The analyst may not create source, release, deployment, or
production tags. Conductor, committer, reviewer, verifier, and implementation
roles remain prohibited from tagging.

## Stable identifiers

Use the following identifier prefixes for all functional artefacts:

| Prefix | Artefact | Example |
|--------|----------|---------|
| OBJ | Functional objective | OBJ-001 |
| HC | High-level success criterion | HC-001 |
| FR | Functional requirement | FR-001 |
| BR | Business rule | BR-001 |
| NFR | Non-functional requirement | NFR-001 |
| OPS | Operational requirement | OPS-001 |
| SC | Detailed success criterion | SC-001 |
| VER | Verification method | VER-001 |
| DOC | Documentation requirement | DOC-001 |
| DEC | Decision | DEC-001 |
| RISK | Risk | RISK-001 |

Identifiers are stable: once assigned, they persist for the life of the
project. When a requirement is superseded, mark it as deprecated rather than
reusing its identifier.

## Traceability model

Maintain traceability that answers these questions:

- Why does this requirement exist?
- Which human objective does it support?
- Which detailed criterion proves it?
- How will it be verified?
- Has it been verified?
- What evidence exists?
- Which objectives have insufficient coverage?
- Which requirements do not support an objective, constraint, or risk control?
- Which tests are not linked to expected behaviour?
- What is affected if a requirement changes?

### Traceability structure

Prefer a machine-readable source (YAML) with a generated or maintained
Markdown summary. The structure should support:

```text
artefacts/traceability.yaml     (machine-readable source)
docs/traceability.md            (human-readable summary)
```

Adapt the file locations to the project's conventions.

### Traceability chain

```text
OBJ-xxx (Functional objective)
    ↓ maps-to
HC-xxx (High-level success criterion)
    ↓ satisfies
FR-xxx / BR-xxx / NFR-xxx / OPS-xxx / DOC-xxx (Requirement or business rule)
    ↓ verified-by
SC-xxx (Detailed success criterion)
    ↓ verified-by
VER-xxx (Verification method)
    ↓ evidence
Test reference, inspection result, or evidence artifact
```

Each link should be bi-directional: the requirement knows its criterion, and
the criterion knows its requirement.

### Traceability during implementation

As implementation proceeds, update the traceability to include:

- Verification status (not-verified / passing / failing / deferred)
- Test or inspection reference (file path, test name, script location)
- Evidence location (log file, screenshot, report)
- Deferred items with rationale
- Known limitations with impact assessment

## Documentation lifecycle

### During implementation

The analyst:

- Answers functional interpretation questions from implementation agents
- Evaluates proposed requirement changes — distinguishes legitimate discoveries
  from scope creep
- Updates documentation when legitimate discoveries occur (the system does
  something useful that was not originally specified)
- Prevents implementation decisions from silently becoming new functional
  requirements — implementation shortcuts are implementation debt, not new
  requirements
- Maintains traceability between approved intent and implementation

##### Discovery that changes frozen contractual behaviour

When an implementation agent identifies a genuine gap or discovery that would
change the frozen contractual behaviour in `docs/customer-facing/`, the
following sequence is mandatory:

1. **Stop implementation.** The implementation agent must stop and report the
   finding rather than working around it or silently altering behaviour.
2. **Analyst updates requirements.** The analyst updates the affected
requirements, specification, and contractual tests in `docs/working/`,
    propagating traceability through the full chain (OBJ → HC →
    FR/BR/NFR/OPS/DOC → SC → VER).
3. **Human reviews and analyst tags.** The human reviews the updated artefacts.
   After the applicable quality and baseline gates, the analyst creates a new
   immutable docs tag in the configured documentation repository. In guided
   mode this requires human validation approval; in autonomous mode it requires
   no blocking Class C/D decision. The tag points to the committed approved
   docs baseline and implementation resumes against it.
4. **Implementation resumes against new tag.** Implementation resumes only
   against the new tag. The implementation agent re-reads the current spec and
   tests at the new tag before continuing.

### During verification

The analyst ensures:

- Verification evidence maps to the correct success criteria
- Failed criteria are reflected accurately, with details of the failure
- Limitations and deviations from the specification are documented
- User and operational documentation reflect verified behaviour, not intended
  behaviour where they differ
- Verification gaps are identified and reported

### At completion

The analyst delivers the completed documentation baseline, explaining:

- What the system is intended to do
- How it should be used, configured, and operated
- How success was verified
- What limitations remain
- Which decisions were made autonomously
- Which decisions were confirmed by the human

## Consistency maintenance

The baseline is authoritative. Where several documents describe the same
behaviour, they must agree. Detect and resolve:

- A business rule differing from the user guide
- A wireframe exposing an action forbidden by the requirements
- A success criterion testing behaviour absent from the specification
- A configuration option documented but unsupported
- Implemented behaviour not reflected in the operations guide
- A requirement changed without updating traceability

When a change occurs (human feedback, scope change, legitimate discovery):

1. Identify every affected artefact (do not ask the human to do this).
2. Update each one consistently.
3. Verify no contradictions were introduced.
4. Update the traceability links.

The analyst is the consistency owner. If automated checks exist, use them.
Otherwise, perform manual cross-referencing proportionate to project risk.

## Documentation completion gate

Before declaring documentation complete, verify:

- [ ] All high-level objectives are represented in the requirements
- [ ] Key business rules are documented
- [ ] Detailed requirements are traceable to objectives and success criteria
- [ ] Success criteria are defined for every mandatory requirement
- [ ] Verification evidence is linked to success criteria
- [ ] User-visible behaviour is documented in the user guide
- [ ] Supported configuration is documented in the configuration reference
- [ ] Operational procedures are documented in the operations guide
- [ ] Known limitations are explicit
- [ ] Autonomous analyst decisions are recorded with rationale
- [ ] Human-confirmed decisions are identifiable
- [ ] No material contradictions remain between artefacts
- [ ] Documentation reflects actual supported behaviour (verified during
      implementation)
- [ ] Deferred criteria or limitations are explicitly recorded

Documentation completeness and consistency are mandatory delivery criteria.

## Output

- Traceability source file (YAML preferred) with complete links
- Traceability summary (Markdown) for human readers
- Updated documentation reflecting any implementation-phase changes
- Consistency verification report
- Completed documentation baseline at project end

## Quality checklist

- [ ] Identifiers are stable (no reuse, deprecation only)
- [ ] Every requirement links to at least one objective and one success criterion
- [ ] Every high-level criterion has sufficient detailed coverage
- [ ] Verification evidence is linked to success criteria
- [ ] No orphan requirements, unsupported objectives, or orphan verification
      references
- [ ] All cross-artefact contradictions resolved
- [ ] Documentation reflects verified behaviour (not aspirational behaviour)
- [ ] Autonomous decisions are recorded and identifiable
- [ ] Human-confirmed decisions are identifiable
