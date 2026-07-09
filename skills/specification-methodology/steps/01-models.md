# Step 1: Identify Models and Attributes

[Back to Index](../SKILL.md) | [Next: Step 2 — Roles](02-roles.md)

## Objective

Extract all data entities (models) from the plain English requirements and define their attributes.

## Process

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
- **Field types** — See [Field Types Reference](../references/field-reference.md#primitive-types)
- **Constraints** — See [Constraint Symbols](../references/field-reference.md#constraint-symbols)
   - **Defaults** — What values should fields have initially?

4. **Determine Relationships**
   - **Aggregation (ref)**: Child references parent (weak). E.g., Deck created by User — deck can exist even if user deleted. On delete: SET NULL or RESTRICT.
   - **Composition (m2o)**: Child is part of parent (strong). E.g., Card belongs to Deck — card cannot exist without deck. On delete: CASCADE.
   - **One-to-many (o2m)**: Parent has many children.
   - **Many-to-many (m2m)**: Both sides independent.
   - See [Relationship Types](../references/field-reference.md#relationship-types) and [On-Delete Behaviors](../references/field-reference.md#on-delete-behaviors) for details.

5. **Define a Base Model with Audit Fields**
   - Define an abstract `BaseModel` that all application models inherit from, with four standard audit fields:
     - `create_timestamp` (timestamp, RO) — When the record was created
     - `write_timestamp` (timestamp, RO) — When the record was last modified
     - `create_uid` (m2o -> User, RO) — Who created the record
     - `write_uid` (m2o -> User, RO) — Who last modified the record
   - These fields are system-managed, not user-editable.

## Output Format

Each model written to `models/<ModelName>.md`. See [Specification Template: Model File](../assets/specification-template.md#model-file-template) for the exact format.

The file contains a fields table documenting all attributes, relationships, computed fields, and related fields:

| Field Name | Label | Type | Related Model | Constraints | Default | Comments |
|------------|-------|------|---------------|-------------|---------|----------|
| [field] | [Label] | [type] | [Model or empty] | [constraints] | [value] | [Brief note] |

Plus a **Field Notes** section for detailed explanations (computation formulas, complex default logic, conditional rules, related paths, validation rules, etc.).

**Notes on the table format:**
- The **Related Model** column is only for relationship fields (ref, m2o, o2m, m2m) and related fields (Rel, Rel/S).
- The **Comments** column should be short (on-delete behavior, enum values). Use **Field Notes** for anything that does not fit.

## Example

File `models/Deck.md` — see [Complete Model Example](../references/field-reference.md#complete-model-example).

> **Checkpoint:** Present the models to the user for validation before moving to [Step 2](02-roles.md). Do not proceed past an unresolved ambiguity.