# Specification Templates

Reference templates for the spec wiki output. Use these when generating specification files.

## Model File Template

Each model goes in `models/<ModelName>.md`:

```markdown
# Model: [ModelName]

**Description:** [One-sentence description]

**Extends:** BaseModel

## Fields

| Field Name | Label | Type | Related Model | Constraints | Default | Comments |
|------------|-------|------|---------------|-------------|---------|----------|
| [field] | [Label] | [type] | [Model or empty] | [constraints] | [value] | [Brief note] |

## Field Notes

- **[field_name]**: [Detailed explanation — computation formula, complex default logic, conditional rules, related path for Rel fields, validation rules, etc.]
```

## Roles Section

For embedding in `spec-index.md` (always inline):

```markdown
## User Roles

### Role Definitions

| Role | Description | Parent Role |
|------|-------------|-------------|
| [Role Name] | [Description] | [Parent or —] |

### Permissions Matrix

| Use Case | [Role 1] | [Role 2] |
|----------|----------|----------|
| [Use Case] | [Permission] | [Permission] |
```

## Use Case Index Template

For embedding in `spec-index.md`:

```markdown
## Use Cases

| UC ID | Title | Model | Authorized Roles |
|-------|-------|-------|------------------|
| [UC-001] | [Action] [Model] | [Model or empty] | [Roles] |
```

Individual use case files go in `use-cases/UC-XXX-<kebab-case-title>.md` (see template below).

## Use Case File Template

Each use case goes in `use-cases/UC-XXX-<kebab-case-title>.md`:

```markdown
# UC-XXX: Title

## Summary
One sentence describing what the use case accomplishes.

## Pre-conditions
- What must be true before execution

## Actors & Trigger
**Authorized Roles:** Roles with permission levels
**Trigger:** What initiates this use case

## Main Sequence
1. **User** performs action
2. **System** responds with result
3. (Continue back-and-forth...)

## Alternative Flows
**[ALT-X: Description]**
- Variation details

## Exception Flows
**[EXC-X: Description]**
- Triggered when: condition
- User feedback: "error message"

## Technical Considerations
- Algorithms, performance, security, integrations

## Post-conditions
- What is true after successful completion

## Acceptance Criteria
GIVEN precondition description
WHEN action description
THEN expected result description

## Related Models
- [ModelName](../models/ModelName.md)
```

### Filled Example: UC-006 Create Deck

```markdown
# UC-006: Create Deck

## Summary
User creates a new deck within a collection to organize flashcards by topic.

## Pre-conditions
- User is logged in
- User has "Create" permission on Decks
- Collection exists and belongs to user

## Actors & Trigger
**Authorized Roles:** Admin (full), User (own collections only)
**Trigger:** User clicks "New Deck" within a collection

## Main Sequence
1. **User** clicks "New Deck" in collection
2. **System** displays deck creation form
3. **User** enters deck name
4. **User** optionally enters description
5. **User** submits form
6. **System** validates required fields
7. **System** creates deck in collection
8. **System** redirects to deck view

## Exception Flows
**[EXC-1: Empty Name]**
- Triggered when: Name field is empty
- User feedback: "Deck name is required"

## Acceptance Criteria
GIVEN a logged-in user viewing a collection
WHEN the user submits a valid deck form
THEN the deck is created within that collection

## Related Models
- [Deck](../models/Deck.md)
- [Collection](../models/Collection.md)
```

## Spec Index Template

The main index file `spec-index.md` structure:

```markdown
# [Project Name] — Specification

## 1. General Business Context

**Objective:** [What the system achieves]
**Scope:** [In scope / out of scope]
**Stakeholders:** [List of stakeholders]
**Glossary:** [Term definitions]

## 2. User Roles

[Roles section — see above]

## 3. Data Initialization

[Initial data requirements, creation order. Inline if ≤40 lines, otherwise extract to data-initialization.md]

## 4. Use Cases

[Use case index table — see above]

## 5. Data Models

[Model index table — links to models/]

## 6. Non-Functional Requirements

[Performance, security, availability, scalability. Inline if ≤40 lines, otherwise extract to non-functional-requirements.md]

## 7. Integration Points

[External system integrations. Inline if ≤40 lines, otherwise extract to integration-points.md]

## 8. Appendices

[Technical references, revision history, open questions. Inline if ≤40 lines, otherwise extract to appendices.md]
```