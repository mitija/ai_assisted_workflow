# Step 2: Identify Roles

[Back to Step 1: Models](01-models.md) | [Up to Index](../SKILL.md) | [Next: Step 3 — Use Case Identification](03-use-case-identification.md)

## Objective

Define user roles and their permission levels for each feature/use case.

## Process

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

## Output

- Role definitions table
- Comprehensive permissions matrix
- Special permission rules documented

See [Specification Template: Roles Section](../assets/specification-template.md#roles-section) for the output format.

## Example

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

> **Checkpoint:** Present the roles and permissions matrix to the user for validation before moving to [Step 3](03-use-case-identification.md).