# Step 3: Identify Use Cases

[Back to Step 2: Roles](02-roles.md) | [Up to Index](../SKILL.md) | [Next: Step 4 — Use Case Documentation](04-use-case-documentation.md)

## Objective

Identify all user interactions with the system, starting from domain-specific workflows in the requirements, then completing the list with standard CRUD and extended operations.

## Process

1. **Extract Domain-Specific Use Cases First**
   - Read the plain English requirements carefully
   - Identify unique workflows and interactions specific to the application domain
   - These are the use cases that make the system distinctive
   - **Examples:** Activate/Deactivate Decks, Start Training Session, Review Card, Import Deck from CSV

2. **Complete with Core CRUD Operations**
   - For each model identified in [Step 1](01-models.md), consider standard operations:
     - **Create** — New instance
     - **View** — Details of specific instance
     - **Edit** — Modify existing instance
     - **List** — Collection of instances (sorting, filtering, pagination)
     - **Delete** — Remove instance (confirmation, cascade impacts, soft vs hard)

3. **Complete with Extended Operations (if applicable)**
   - **Duplicate** — Copy existing instance
   - **Archive** — Mark as inactive/archived
   - **Share** — Grant access to others
   - **State Change** — Transition through workflow states
   - **Export** — Download data (PDF, CSV, Excel, JSON)
   - **Mass Operations** — Action on multiple instances

4. **Cross-Reference with Permissions**
   - Ensure each use case has authorized roles assigned
   - Verify the [permissions matrix from Step 2](02-roles.md) covers all use cases

## Output

A summary table listing all identified use cases. The Model column may be left empty for cross-cutting use cases.

| UC ID | Title | Model | Authorized Roles |
|-------|-------|-------|------------------|
| UC-001 | [Action] [Model] | [Model or empty] | [Roles] |

See [Specification Template: Use Case Index](../assets/specification-template.md#use-case-index-template) for the full format.

## Example

| UC ID | Title | Model | Authorized Roles |
|-------|-------|-------|------------------|
| UC-001 | Activate Deck | Deck | User, Admin |
| UC-002 | Start Training Session | | User, Admin |
| UC-003 | Review Card | Card | User, Admin |
| UC-004 | Import Deck from CSV | Deck | Admin |
| UC-005 | Create Collection | Collection | User, Admin |
| UC-006 | Create Deck | Deck | User, Admin |
| UC-007 | Create Card | Card | User, Admin |

> **Checkpoint:** Present the use case list to the user for validation before moving to [Step 4](04-use-case-documentation.md).