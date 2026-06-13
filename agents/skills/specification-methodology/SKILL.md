---
name: specification-methodology
description: Generates comprehensive software specifications from plain English requirements using a 5-step methodology (Models, Roles, Use Cases identification, Use Cases documentation, Review). Use when creating or writing software specifications, defining data models, documenting use cases, or planning a new software project.
allowed-tools: Read, Glob, Grep, Edit, Write, Task, WebSearch, WebFetch
argument-hint: [requirements-file-or-description]
---

# Specification Writing Methodology

You are a specification writer for M+ Software projects. Your job is to transform plain English requirements into structured, testable specifications suitable for TDD (Test-Driven Development) implementation.

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
    Step 1: Models
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
     - `create_timestamp` (datetime, RO) — When the record was created
     - `write_timestamp` (datetime, RO) — When the record was last modified
     - `create_uid` (m2o -> User, RO) — Who created the record
     - `write_uid` (m2o -> User, RO) — Who last modified the record
   - These fields are system-managed (set automatically on create/write), not user-editable
   - By inheriting from BaseModel, every model gets consistent audit tracking without repeating these fields

### Output Format

For each model, a single fields table documenting all attributes, relationships, computed fields, and related fields:

```markdown
### Model: [ModelName]

**Description:** [One-sentence description]

**Extends:** BaseModel

#### Fields

| Field Name | Label | Type | Related Model | Constraints | Default | Comments |
|------------|-------|------|---------------|-------------|---------|----------|
| [field] | [Human-readable label] | [type] | [Model or empty] | [constraints] | [value] | [Brief note] |

#### Field Notes

- **[field_name]**: [Detailed explanation — computation formula, complex default logic, conditional rules, related path for Rel fields, validation rules, etc.]
```

**Notes on the table format:**
- The **Related Model** column is only used for relationship fields (ref, m2o, o2m, m2m) and related fields (Rel, Rel/S). Leave empty for regular fields.
- The **Comments** column should be kept short (e.g., on-delete behavior, enum values list). Use the **Field Notes** section for anything that does not fit.

### Step 1 Example

```
### Model: Deck

**Description:** A set of flashcards on a specific topic

**Extends:** BaseModel

#### Fields

| Field Name | Label | Type | Related Model | Constraints | Default | Comments |
|------------|-------|------|---------------|-------------|---------|----------|
| collection_id | Collection | m2o | Collection | * | - | CASCADE on delete |
| name | Name | string(255) | | * | - | |
| description | Description | text | | | NULL | |
| card_count | Card Count | integer | | C/S, RO | 0 | |
| created_by_id | Created By | ref | User | | - | SET NULL on delete |

#### Field Notes

- **card_count**: COUNT(card_ids). Updated on card create/delete.
```

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

```
Role: Admin
Description: Administrator with full system access
Permissions: Full CRUD on all models, user management, system configuration

Role: User
Description: Regular user with read-only access to master data
Permissions: Read collections/decks/cards, Full access to own progress
```

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
- **Technical Considerations** — Special algorithms, performance requirements, security concerns, integration points
- **Post-conditions** — What is true after successful completion, data state changes, side effects
- **Acceptance Criteria** — Gherkin-style scenarios (Given/When/Then), testable conditions for "done"

### Process

1. **Document Each Use Case** following the template above. Be thorough in main sequence and exception flows. Include all acceptance criteria.
2. **Review for Completeness** — Every use case from the Step 3 table must have a detailed specification. Cross-check that main sequences reference correct model fields and relationships.

### Use Case Output Format

```markdown
### UC-XXX: [Title]

#### Summary
[One sentence describing what the use case accomplishes]

#### Pre-conditions
- [What must be true before execution]

#### Actors & Trigger
**Authorized Roles:** [Roles with permission levels]
**Trigger:** [What initiates this use case]

#### Main Sequence
1. **User** [action]
2. **System** [response]
3. [Continue back-and-forth...]

#### Alternative Flows
**[ALT-X: Description]**
- [Variation details]

#### Exception Flows
**[EXC-X: Description]**
- Triggered when: [condition]
- User feedback: "[error message]"

#### Technical Considerations
- [Algorithms, performance, security, integrations]

#### Post-conditions
- [What is true after successful completion]

#### Acceptance Criteria
GIVEN [precondition]
WHEN [action]
THEN [expected result]
```

### Step 4 Example

```
### UC-006: Create Deck

#### Summary
User creates a new deck within a collection to organize flashcards by topic.

#### Pre-conditions
- User is logged in
- User has "Create" permission on Decks
- Collection exists and belongs to user

#### Actors & Trigger
**Authorized Roles:** Admin (full), User (own collections only)
**Trigger:** User clicks "New Deck" within a collection

#### Main Sequence
1. **User** clicks "New Deck" in collection
2. **System** displays deck creation form
3. **User** enters deck name
4. **User** optionally enters description
5. **User** submits form
6. **System** validates required fields
7. **System** creates deck in collection
8. **System** redirects to deck view

#### Exception Flows
**[EXC-1: Empty Name]**
- Triggered when: Name field is empty
- User feedback: "Deck name is required"

#### Acceptance Criteria
GIVEN a logged-in user viewing a collection
WHEN the user submits a valid deck form
THEN the deck is created within that collection
```

---

## Step 5: Review and Finalize

### Objective

Ensure specification is complete, consistent, and ready for implementation.

### Review Checklist

#### Completeness
- [ ] All models from requirements documented?
- [ ] All attributes defined with types and constraints?
- [ ] All relationships identified?
- [ ] All user roles defined?
- [ ] Permissions matrix complete (every use case has role assignments)?
- [ ] All use cases documented (generic + domain-specific)?
- [ ] Every use case has acceptance criteria?
- [ ] Non-functional requirements specified?

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

1. **Self-Review** — Review against checklist, mark open questions in Appendix
2. **Peer Review** — Developer reviews technical accuracy, analyst reviews requirement coverage
3. **Stakeholder Review** — Product owner validates business logic, end users validate flows
4. **Finalization** — Address feedback, resolve open questions, update revision history, mark as "Final"

---

## Output Document Structure

The final specification document must follow this structure:

1. **General Business Context** — Objectives, scope, stakeholders, glossary
2. **User Roles** — Role definitions and permissions matrix
3. **Data Initialization** — Initial data requirements and creation order
4. **Use Cases** — Detailed use case specifications
5. **Data Models** — Model definitions with attributes and relationships
6. **Non-Functional Requirements** — Performance, security, availability, scalability
7. **Integration Points** — External system integrations
8. **Appendices** — Technical references, revision history, open questions

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
| **enum** | Named enumeration | role: enum(UserRole) where UserRole = {ADMIN, USER} | UserRole.ADMIN |

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
| **SET DEFAULT** | Set foreign key to default value | Rarely used |
| **NO ACTION** | Database handles it (usually like RESTRICT) | Let DB enforce integrity |

---

## Naming Conventions

- **Models:** PascalCase (e.g., `UserCardProgress`, `DeckActivation`)
- **Fields:** snake_case (e.g., `card_count`, `created_at`)
- **Many-to-one / ref fields:** suffix with `_id` (e.g., `collection_id`, `created_by_id`)
- **One-to-many / many-to-many fields:** suffix with `_ids` (e.g., `card_ids`, `activated_deck_ids`)
- **Boolean fields:** phrase as a question using `is_`, `has_`, `can_` prefixes (e.g., `is_active`, `has_attachments`, `can_edit`)
- Maintain glossary throughout — avoid synonyms (one term = one concept)

---

## Complete Model Example

### Model: Deck

**Description:** A collection of flashcards on a specific topic, organized within a parent collection.

**Extends:** BaseModel

#### Fields

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

#### Field Notes

- **card_count**: COUNT(card_ids). Updated automatically when cards are created or deleted.
- **mastery_percentage**: (cards_mastered / card_count) * 100. Computed on-the-fly per user, not stored.
- **collection_name**: Related path: collection_id.name
- **creator_name**: Related path: created_by_id.display_name

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
