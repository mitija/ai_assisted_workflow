---
name: specification-methodology
description: Generates comprehensive software specifications from plain English requirements using a 5-step methodology (Models, Roles, Use Cases identification, Use Cases documentation, Review). Use when creating or writing software specifications, defining data models, documenting use cases, or planning a new software project.
argument-hint: [requirements-file-or-description]
---

# Specification Writing Methodology

You are a specification writer. Your job is to transform plain English requirements into structured, testable specifications suitable for TDD (Test-Driven Development) implementation.

## When to Use

- The user wants to create a software specification from requirements
- The user wants to define data models, roles, or use cases for a new project
- The user wants to document an existing system's behavior formally
- The user provides plain English requirements and needs them structured

## Input

The user provides plain English requirements, either as:
- A file path to a requirements document: `$ARGUMENTS`
- A description in the conversation
- An existing partial specification to complete

If `$ARGUMENTS` is provided, read that file first to understand the requirements.

## Process Overview

Follow this five-step approach strictly. Complete each step before moving to the next. Present each step's output to the user for review before proceeding.

```
Plain English Requirements
         |
    Step 1: Models and Attributes
         |
    Step 2: Roles
         |
    Step 3: Identify Use Cases
         |
    Step 4: Document Use Cases
         |
    Step 5: Review
         |
  Final Specification
```

---

## Step 1: Identify Models and Attributes

### Objective

Extract all data entities (models) from the plain English requirements and define their attributes.

### Process

1. **Read Requirements Thoroughly**
   - Identify nouns that represent business entities
   - Look for things that need to be stored, tracked, or managed
   - Consider relationships between entities

2. **Create Model List**
   - List each identified entity
   - Group related entities
   - Identify parent-child relationships

3. **Define Attributes for Each Model**
   - **Required fields** — What data is essential?
   - **Optional fields** — What data is nice-to-have?
   - **Computed fields** — What can be calculated from other data?
   - **Field types** — See Field Types Reference below
   - **Constraints** — See Constraint Symbols below
   - **Defaults** — What values should fields have initially?

4. **Determine Relationships**
   - **Aggregation (ref)**: Child references parent (weak relationship, child can exist independently). E.g., Deck created by User — deck can exist even if user deleted.
   - **Composition (m2o)**: Child is part of parent (strong ownership, child cannot exist without parent). E.g., Card belongs to Deck — card cannot exist without deck.
   - **One-to-many (o2m)**: Parent has many children (e.g., Collection has many Decks).
   - **Many-to-many (m2m)**: Both sides independent (e.g., User activates many Decks, Deck activated by many Users).
   - **On Delete behavior** — CASCADE (m2o/composition), SET NULL or RESTRICT (ref/aggregation).

5. **Define a Base Model with Audit Fields**
   - Define an abstract base class (`BaseModel`) that all application models inherit from, with four standard audit fields:
     - `create_timestamp` (timestamp, RO) — When the record was created
     - `write_timestamp` (timestamp, RO) — When the record was last modified
     - `create_uid` (m2o -> User, RO) — Who created the record
     - `write_uid` (m2o -> User, RO) — Who last modified the record
   - These fields are system-managed (set automatically on create/write), not user-editable
   - By inheriting from BaseModel, every model gets consistent audit tracking without repeating these fields

### Output Format

Each model is written to its own file at `models/<ModelName>.md` (see Output Document Structure). The file contains a single fields table documenting all attributes, relationships, computed fields, and related fields:

```markdown
# Model: [ModelName]

**Description:** [One-sentence description]

**Extends:** BaseModel

## Fields

| Field Name | Label | Type | Related Model | Constraints | Default | Comments |
|------------|-------|------|---------------|-------------|---------|----------|
| [field] | [Human-readable label] | [type] | [Model or empty] | [constraints] | [value] | [Brief note] |

## Field Notes

- **[field_name]**: [Detailed explanation — computation formula, complex default logic, conditional rules, related path for Rel fields, validation rules, etc.]
```

**Notes on the table format:**
- The **Related Model** column is only used for relationship fields (ref, m2o, o2m, m2m) and related fields (Rel, Rel/S). Leave empty for regular fields.
- The **Comments** column should be kept short (e.g., on-delete behavior, enum values list). Use the **Field Notes** section for anything that does not fit.

### Step 1 Example

File: `models/Deck.md`

```markdown
# Model: Deck

**Description:** A set of flashcards on a specific topic

**Extends:** BaseModel

## Fields

| Field Name | Label | Type | Related Model | Constraints | Default | Comments |
|------------|-------|------|---------------|-------------|---------|----------|
| collection_id | Collection | m2o | Collection | * | - | CASCADE on delete |
| name | Name | string(255) | | * | - | |
| description | Description | text | | | NULL | |
| card_count | Card Count | integer | | C/S, RO | 0 | |
| created_by_id | Created By | ref | User | | - | SET NULL on delete |

## Field Notes

- **card_count**: COUNT(card_ids). Updated on card create/delete.
```

> **Checkpoint:** Present the models to the user for validation before moving to Step 2. Do not proceed past an unresolved ambiguity.

---

## Step 2: Identify Roles

### Objective

Define user roles and their permission levels for each feature/use case.

### Process

1. **List All User Types**
   - Who will use the system?
   - What are their primary responsibilities?
   - Are there hierarchical relationships?

2. **Define Role Attributes**
   - Role name (e.g., Admin, User, Manager, Guest)
   - Description of responsibilities
   - Parent role (if applicable for permission inheritance)

3. **Create Permissions Matrix**
   - List all features/use cases (rows)
   - List all roles (columns)
   - Define permission level for each intersection:
     - **Full** — All CRUD operations
     - **Create** — Can create only
     - **Read** — Can view only
     - **Edit** — Can modify existing
     - **Delete** — Can remove
     - **None** — No access

4. **Consider Special Permissions**
   - Self-service (can user modify own data only?)
   - Delegation (can user grant permissions to others?)
   - Conditional access (different permissions based on state/status?)

### Output

- Role definitions table
- Comprehensive permissions matrix
- Special permission rules documented

### Step 2 Example

**Role definitions:**

| Role | Description | Parent Role |
|------|-------------|-------------|
| Admin | Administrator with full system access | — |
| User | Regular user, manages own learning data | — |

**Permissions matrix** (use cases as rows, roles as columns):

| Use Case | Admin | User |
|----------|-------|------|
| Manage Collections/Decks/Cards (master data) | Full | Read |
| Manage own progress | Full | Full (own only) |
| User management | Full | None |
| System configuration | Full | None |

> **Checkpoint:** Present the roles and permissions matrix to the user for validation before moving to Step 3.

---

## Step 3: Identify Use Cases

### Objective

Identify all user interactions with the system, starting from domain-specific workflows in the requirements, then completing the list with standard CRUD and extended operations.

### Process

1. **Extract Domain-Specific Use Cases First**
   - Read the plain English requirements carefully
   - Identify unique workflows and interactions specific to the application domain
   - These are the use cases that make the system distinctive
   - **Examples:**
     - Activate/Deactivate Decks (specific to learning workflow)
     - Start Training Session (domain-specific interaction)
     - Review Card (core learning activity)
     - Import Deck from CSV (bulk operation specific to flashcards)

2. **Complete with Core CRUD Operations**
   - For each model identified in Step 1, consider which of these standard operations are needed (not all apply to every model):
     - **Create** — User creates a new instance
     - **View** — User views details of a specific instance
     - **Edit** — User modifies an existing instance
     - **List** — User views a collection of instances (sorting, filtering, pagination)
     - **Delete** — User removes an instance (confirmation, cascade impacts, soft vs hard delete)

3. **Complete with Extended Operations (if applicable)**
   - **Duplicate** — User creates a copy of an existing instance
   - **Archive** — User marks instance as inactive/archived
   - **Share** — User grants access to others
   - **State Change** — User transitions instance through workflow states (e.g., "Publish", "Approve")
   - **Export** — User downloads or prints data (PDF, CSV, Excel, JSON)
   - **Mass Operations** — User performs action on multiple instances at once

4. **Cross-Reference with Permissions**
   - Ensure each use case has authorized roles assigned
   - Verify the permissions matrix from Step 2 covers all use cases

### Output

A summary table listing all identified use cases. The Model column may be left empty for use cases that are cross-cutting or don't involve a single main model.

| UC ID | Title | Model | Authorized Roles |
|-------|-------|-------|------------------|
| UC-001 | [Action] [Model] | [Model or empty] | [Roles] |

### Step 3 Example

| UC ID | Title | Model | Authorized Roles |
|-------|-------|-------|------------------|
| UC-001 | Activate Deck | Deck | User, Admin |
| UC-002 | Start Training Session | | User, Admin |
| UC-003 | Review Card | Card | User, Admin |
| UC-004 | Import Deck from CSV | Deck | Admin |
| UC-005 | Create Collection | Collection | User, Admin |
| UC-006 | Create Deck | Deck | User, Admin |
| UC-007 | Create Card | Card | User, Admin |

> **Checkpoint:** Present the use case list to the user for validation before moving to Step 4.

---

## Step 4: Document Use Cases

### Objective

Write detailed, testable specifications for each use case identified in Step 3.

### Use Case Template

Each use case must include all of the following sections:

- **Use Case ID** — UC-XXX (sequential numbering)
- **Title** — Action + Model (e.g., "Create Deck")
- **Summary** — One-sentence description of what the use case accomplishes
- **Pre-conditions** — What must be true before execution (authentication, data dependencies)
- **Actors & Trigger** — Authorized roles and what initiates the use case (button click, event, schedule)
- **Main Sequence** — Numbered back-and-forth interaction between User and System. Group consecutive actions by the same actor. Prefix each step with **User** or **System**.
- **Alternative Flows** — Variations, optional paths, different user choices
- **Exception Flows** — What can go wrong: validation failures, business rule violations, system errors, with user feedback for each
- **Related Models** — List of models involved in this use case, with links to their files. Keep model references here rather than scattering links throughout the main text.
- **Technical Considerations** — Special algorithms, performance requirements, security concerns, integration points
- **Post-conditions** — What is true after successful completion, data state changes, side effects
- **Acceptance Criteria** — Gherkin-style scenarios (Given/When/Then), testable conditions for "done". These are inputs to the contractual `<epic>_TESTS.md` scenarios authored via the `test-scenarios` skill, which are authoritative; do not treat the criteria here as the final test contract.

### Process

1. **Document Each Use Case** following the template above. Be thorough in main sequence and exception flows. Include all acceptance criteria.
2. **Review for Completeness** — Every use case from the Step 3 table must have a detailed specification. Cross-check that main sequences reference correct model fields and relationships.

### Use Case Output Format

Each use case is written to its own file at `use-cases/UC-XXX-<kebab-case-title>.md` (see Output Document Structure):

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

### Step 4 Example

File: `use-cases/UC-006-create-deck.md`

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

> **Checkpoint:** Present the documented use cases to the user for validation before moving to Step 5. The Gherkin acceptance criteria written here feed the contractual `<epic>_TESTS.md` (see the `test-scenarios` skill), which is the authoritative test contract.

---

## Step 5: Review and Finalize

### Objective

Ensure specification is complete, consistent, and ready for implementation.

### Review Checklist

#### Completeness
- [ ] All models from requirements documented (each in its own `models/<ModelName>.md`)?
- [ ] All attributes defined with types and constraints?
- [ ] All relationships identified?
- [ ] All user roles defined?
- [ ] Permissions matrix complete (every use case has role assignments)?
- [ ] All use cases documented (each in its own `use-cases/UC-XXX-<title>.md`)?
- [ ] Every use case has acceptance criteria?
- [ ] Non-functional requirements specified?

#### Structure / Formatting
- [ ] Sections exceeding 40 lines (>40) extracted to separate files (Data Initialization, NFR, Integration Points, Appendices)?
- [ ] All relative links between files are valid (index -> models, index -> use cases, cross-references)?
- [ ] The main index (`spec-index.md`) links to every sub-file?

#### Consistency
- [ ] Model names used consistently throughout?
- [ ] Field names match across use cases and models?
- [ ] Role names consistent in permissions matrix and use cases?
- [ ] Use case numbering sequential?
- [ ] Glossary terms used correctly?

#### Clarity
- [ ] Use cases are unambiguous?
- [ ] Technical jargon explained in glossary?
- [ ] Acceptance criteria are testable?
- [ ] Exception flows cover edge cases?

#### Traceability
- [ ] Each requirement from plain English addressed?
- [ ] Each model referenced in at least one use case?
- [ ] Each use case references at least one model?
- [ ] Permissions align with business rules?

#### Technical Feasibility
- [ ] Data model relationships are sound?
- [ ] Cascade delete rules won't cause data loss issues?
- [ ] Performance requirements are realistic?
- [ ] Security requirements address common vulnerabilities?

### Review Process

This skill is agent-run; the review steps below are what the agent performs, plus the mandatory human checkpoints.

1. **Agent Self-Review** — Review the whole specification against the checklist above. Record any open questions in the Appendix.
2. **Surface Blockers** — For each genuine ambiguity or gap, stop and ask the user one question at a time (unpack complex ones first). Do not guess or work ahead of an unresolved blocker.
3. **Human Validation** — Human validation is required at the end of each step (Steps 1–4) and again here at finalization. Do not proceed without it.
4. **Finalization** — Address feedback, resolve open questions, update the revision history, and mark the spec as "Final".
5. **Wiki Integrity** — Verify all files exist, all relative links resolve, and the main index (`spec-index.md`) links to every sub-file.

---

## Output Document Structure

The specification is organized as a **wiki-style directory tree** rather than a single monolithic file. The main file (`spec-index.md`) acts as an index and contains sections that are short enough to stay inline. Larger or multi-item sections are split into their own files.

### Directory Layout

The **default layout** (single project, no epics) keeps use cases flat at the spec root:

```
spec/
├── spec-index.md                    # Main index + inline sections
├── data-initialization.md           # (if >40 lines, otherwise inline in spec-index.md)
├── non-functional-requirements.md   # (if >40 lines, otherwise inline in spec-index.md)
├── integration-points.md            # (if >40 lines, otherwise inline in spec-index.md)
├── appendices.md                    # (if >40 lines, otherwise inline in spec-index.md)
├── <project>_TESTS.md               # Contractual test scenarios (see test-scenarios skill)
├── models/
│   ├── <ModelName>.md               # One file per model — GLOBAL, shared across epics
│   ├── <ModelName>.md
│   └── ...
└── use-cases/
    ├── UC-001-<kebab-case-title>.md  # One file per use case
    ├── UC-002-<kebab-case-title>.md
    └── ...
```

### Epic-Split Layout (large-scope projects)

When a project's scope grows large enough to split by EPIC, group use cases and tests under per-epic folders. **The data model stays global** at the spec root — `models/` is never duplicated or moved per epic, because entities are shared across epics.

```
spec/
├── spec-index.md                    # Main index, links to every epic + global models
├── models/                          # GLOBAL data model — shared by all epics
│   └── <ModelName>.md
└── epics/
    ├── <epic-a>/
    │   ├── use-cases/
    │   │   └── UC-001-<kebab-case-title>.md
    │   └── <epic-a>_TESTS.md         # One TESTS file per epic
    └── <epic-b>/
        ├── use-cases/
        │   └── UC-101-<kebab-case-title>.md
        └── <epic-b>_TESTS.md
```

**Migration rule:** A project may start flat (no epic) and introduce epics later — this is expected and acceptable. To migrate, move the use-case files and the TESTS file into `epics/<epic>/`, then update the relative links in `spec-index.md` and any cross-references. The global `models/` directory does not move. Each epic owns exactly one `<epic>_TESTS.md`; a flat project has a single `<project>_TESTS.md` at the root.

### Main Index File (`spec-index.md`)

The main file contains these sections in order:

1. **General Business Context** — Objectives, scope, stakeholders, glossary *(always inline)*
2. **User Roles** — Role definitions and permissions matrix *(always inline)*
3. **Data Initialization** — Initial data requirements and creation order *(inline if ≤40 lines, otherwise link to `data-initialization.md`)*
4. **Use Cases Index** — Summary table of all use cases (from Step 3) with links to individual files in `use-cases/` (or, in epic-split layout, links to each epic's use cases)
5. **Data Models Index** — Summary table of all (global) models with links to individual files in `models/`
6. **Non-Functional Requirements** — Performance, security, availability, scalability *(inline if ≤40 lines, otherwise link to `non-functional-requirements.md`)*
7. **Integration Points** — External system integrations *(inline if ≤40 lines, otherwise link to `integration-points.md`)*
8. **Appendices** — Technical references, revision history, open questions *(inline if ≤40 lines, otherwise link to `appendices.md`)*

### Extraction Rule

For sections 3, 6, 7, and 8: if the section content exceeds **40 lines** (>40), extract it to a standalone `.md` file and replace the inline content with a brief summary and a relative link (e.g., `See [Data Initialization](data-initialization.md)`). If the section is 40 lines or fewer, keep it inline in `spec-index.md`.

### File Naming Conventions

- **Model files:** `models/<ModelName>.md` — PascalCase, matching the model name exactly (e.g., `models/UserCardProgress.md`)
- **Use case files:** `use-cases/UC-XXX-<kebab-case-title>.md` — UC ID prefix + kebab-case title (e.g., `use-cases/UC-001-activate-deck.md`)
- **Section files:** kebab-case (e.g., `data-initialization.md`, `non-functional-requirements.md`)
- **Test files:** `<project>_TESTS.md` (flat) or `<epic>_TESTS.md` (epic-split) — see the `test-scenarios` skill

### Cross-Referencing

- The main index must link to every sub-file using relative Markdown links.
- Sub-files may link back to the main index (`../spec-index.md` or `[index](spec-index.md)`) and to related models/use cases when relevant.
- Use case files should link to the models they reference. Model files may also link to relevant use cases when helpful, but this is optional (maintenance trade-off).

---

## Field Types Reference

### Primitive Types

| Type | Description | Examples | Constraints |
|------|-------------|----------|-------------|
| **string(N)** | Text with maximum length N | string(255), string(100) | Default max: 255 chars |
| **text** | Long-form text (unlimited) | Descriptions, notes, content | No length limit |
| **integer** | Whole numbers | IDs, counts, quantities | Can be positive/negative |
| **float** | Approximate decimal numbers | Ratings, percentages, coordinates | Subject to rounding |
| **decimal** | Exact fixed-precision decimal | Quantities, tax rates, financial amounts | No rounding, specify precision (e.g., decimal(10,2)) |
| **boolean** | True/False values | is_active, is_blocked, is_verified | Default: false |
| **date** | Calendar date (YYYY-MM-DD) | birth_date, due_date | No time component |
| **datetime** | Date and time (human-readable) | appointment_date, event_start | Calendar-oriented, may include timezone |
| **timestamp** | Point-in-time instant (UTC) | create_timestamp, write_timestamp | Stored as UTC or epoch, for system tracking |
| **time** | Time of day (HH:MM:SS) | start_time, end_time | No date component |
| **uuid** | Universally unique identifier | External IDs, tokens | 128-bit value |
| **binary** | Raw binary data | File storage, blobs | Size considerations |

### Extended Types

Built on top of base types, adding semantic meaning and specific handling (validation, rendering, storage):

| Type | Base Type | Description | Examples |
|------|-----------|-------------|----------|
| **json** | text | JSON-encoded structured data | Settings, metadata, custom_fields |
| **html** | text | HTML-formatted rich text | Email bodies, rich descriptions, CMS content |
| **currency** | decimal | Monetary amount with currency code | Price, total_amount, balance |
| **file** | binary | Stored file with metadata (name, mime type, size) | Documents, attachments, uploads |
| **image** | binary | Image file with optional dimensions/thumbnails | Avatars, product photos, logos |

### Selection/Enum Types

| Type | Description | Example Definition | Example Values |
|------|-------------|-------------------|----------------|
| **selection** | Fixed set of choices | status: selection(['draft', 'published', 'archived']) | 'draft' |
| **enum** | Named enumeration | difficulty: enum(Difficulty) where Difficulty = {EASY, MEDIUM, HARD} | Difficulty.EASY |

### Relationship Types

| Type | Description | Example | Notes | Lifecycle |
|------|-------------|---------|-------|-----------|
| **ref** | Aggregation: Child references parent (weak relationship) | deck.created_by_id -> User | Foreign key in this model | Child can exist independently |
| **m2o** | Composition: Child is part of parent (strong ownership) | card.deck_id -> Deck | Foreign key in this model | Child cannot exist without parent |
| **o2m** | One record has multiple children | collection.decks -> List[Deck] | Virtual field (inverse of ref/m2o) | Depends on child relationship type |
| **m2m** | Multiple records on both sides | user.activated_decks <-> deck.activated_by_users | Junction table required | Both sides exist independently |

**Key Difference between ref and m2o:**
- **ref (Aggregation)**: The child *references* the parent but can exist independently. If parent deleted, child survives (SET NULL or RESTRICT). Example: Deck references User who created it.
- **m2o (Composition)**: The child is *part of* the parent. If parent deleted, child must be deleted (CASCADE). Example: Card is part of Deck.

---

## Constraint Symbols

| Symbol | Constraint | Meaning | Example |
|--------|------------|---------|---------|
| **\*** | Required | Field must have a value (NOT NULL) | name* |
| **U** | Unique | No duplicate values allowed | email (U) |
| **RO** | Read-only | Cannot be modified after creation | id (RO) |
| **C** | Computed | Calculated from other fields (not stored) | full_name (C) |
| **C/S** | Computed & Stored | Calculated but stored in DB | card_count (C/S) |
| **Rel** | Related | Value from a related model via dot notation (not stored). E.g., `collection_id.name` | collection_id.name (Rel) |
| **Rel/S** | Related & Stored | Same as Rel but denormalized and stored in DB (must stay in sync) | collection_id.name (Rel/S) |
| **PK** | Primary Key | Unique identifier, typically auto-generated (no need to specify unless overriding) | id (PK) |
| **FK** | Foreign Key | Reference to another model | user_id (FK) |
| **I** | Indexed | Database index for performance | email (I) |

---

## On-Delete Behaviors

When defining relationships, specify what happens when the parent record is deleted:

| Behavior | Description | Use Case |
|----------|-------------|----------|
| **CASCADE** | Delete child records automatically | Deck deleted -> all Cards deleted |
| **SET NULL** | Set foreign key to NULL | User deleted -> Cards.created_by = NULL |
| **RESTRICT** | Prevent deletion if children exist | Cannot delete Collection if Decks exist |
| **SET DEFAULT** | Set foreign key to default value | Advanced / rarely used |
| **NO ACTION** | Database handles it (usually like RESTRICT) | Advanced — let DB enforce integrity |

---

## Naming Conventions

- **Models:** PascalCase (e.g., `UserCardProgress`, `DeckActivation`)
- **Fields:** snake_case (e.g., `card_count`, `created_at`)
- **Single-reference fields (`m2o` composition and `ref` aggregation):** suffix with `_id` (e.g., `collection_id`, `created_by_id`). Both use the `_id` suffix, but they mean different lifecycles — `m2o` is composition (child deleted with parent, CASCADE) and `ref` is aggregation (child survives parent, SET NULL/RESTRICT). See Relationship Types.
- **One-to-many / many-to-many fields:** suffix with `_ids` (e.g., `card_ids`, `activated_deck_ids`)
- **Boolean fields:** phrase as a question using `is_`, `has_`, `can_` prefixes (e.g., `is_active`, `has_attachments`, `can_edit`)
- Maintain glossary throughout — avoid synonyms (one term = one concept)

---

## Complete Model Example

File: `models/Deck.md`

```markdown
# Model: Deck

**Description:** A collection of flashcards on a specific topic, organized within a parent collection.

**Extends:** BaseModel

## Fields

| Field Name | Label | Type | Related Model | Constraints | Default | Comments |
|------------|-------|------|---------------|-------------|---------|----------|
| collection_id | Collection | m2o | Collection | * | - | CASCADE on delete |
| name | Name | string(255) | | * | - | |
| description | Description | text | | | NULL | |
| is_active | Active | boolean | | * | true | |
| card_ids | Cards | o2m | Card | | - | CASCADE on delete |
| created_by_id | Created By | ref | User | | - | SET NULL on delete |
| activated_by_user_ids | Activated By | m2m | User | | - | |
| card_count | Card Count | integer | | C/S, RO | 0 | |
| mastery_percentage | Mastery | float | | C | - | Per user |
| collection_name | Collection Name | string | Collection | Rel | - | |
| creator_name | Creator | string | User | Rel | - | |

## Field Notes

- **card_count**: COUNT(card_ids). Updated automatically when cards are created or deleted.
- **mastery_percentage**: (cards_mastered / card_count) * 100. Computed on-the-fly per user, not stored.
- **collection_name**: Related path: collection_id.name
- **creator_name**: Related path: created_by_id.display_name
```

---

## Best Practices

### During Specification Writing

1. **Start Simple, Add Detail Progressively** — Begin with high-level model list, add attributes iteratively, expand use cases from basic to detailed.

2. **Use Consistent Naming** — Follow the naming conventions above strictly. Maintain glossary throughout. Avoid synonyms (one term = one concept).

3. **Think About the User** — Write use cases from user perspective. Include realistic examples. Consider user errors and confusion.

4. **Leverage Examples** — Reference similar systems or features. Use screenshots or wireframes if available. Provide sample data.

5. **Collaborate Early** — Involve developers in Step 1 (model design). Involve users in Steps 3-4 (use case identification and validation). Do not wait until Step 5 to get feedback.

### Common Pitfalls to Avoid

- **Skipping Generic Use Cases** — Do not assume "everyone knows CRUD" — document it. Generic use cases often have domain-specific twists.
- **Vague Acceptance Criteria** — "User can create decks" is NOT testable. "Given a collection, when user submits valid form, then deck created" IS testable.
- **Missing Exception Flows** — Happy path is not enough. Consider validation, permissions, concurrency, system errors.
- **Inconsistent Terminology** — Using both "Flashcard" and "Card" interchangeably creates confusion. Pick one term and stick to it.
- **Overly Complex Models** — Do not over-engineer for hypothetical future needs. Start with MVP, document future enhancements separately.
- **Forgetting Audit Fields** — Who created this? When? Who modified it? Plan for audit trails early, hard to add later.

---

## Adapting for Different Projects

### For Smaller Projects
- Simplify use case detail (fewer exception flows)
- Combine related use cases (e.g., "Manage Decks" instead of separate Create/Edit/Delete)
- Skip Step 2 if single user type

### For Larger Projects
- Add sub-steps to each step (e.g., Step 1a: Core models, Step 1b: Integration models)
- Create multiple specification documents (one per module/subdomain)
- Include formal review gates with sign-off

### For Different Domains
- Adjust generic use cases list (e.g., e-commerce might add "Purchase", "Return")
- Add domain-specific sections (e.g., payment processing, compliance requirements)
- Modify template to include industry-standard sections

---

## Important Rules

- Never use synonyms — one term equals one concept throughout the document
- Maintain a glossary and reference it
- Every use case must have Gherkin-style acceptance criteria
- Document exception flows — the happy path is not enough
- Do not over-engineer for hypothetical future needs — start with MVP
- Always include audit fields via BaseModel inheritance
- Be explicit about on-delete behaviors for every relationship
- Specification writing is iterative — refine as you go through the steps
