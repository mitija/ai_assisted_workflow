# Field Types and Constraints Reference

## Primitive Types

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

## Extended Types

Built on top of base types, adding semantic meaning and specific handling (validation, rendering, storage):

| Type | Base Type | Description | Examples |
|------|-----------|-------------|----------|
| **json** | text | JSON-encoded structured data | Settings, metadata, custom_fields |
| **html** | text | HTML-formatted rich text | Email bodies, rich descriptions, CMS content |
| **currency** | decimal | Monetary amount with currency code | Price, total_amount, balance |
| **file** | binary | Stored file with metadata (name, mime type, size) | Documents, attachments, uploads |
| **image** | binary | Image file with optional dimensions/thumbnails | Avatars, product photos, logos |

## Selection/Enum Types

| Type | Description | Example Definition | Example Values |
|------|-------------|-------------------|----------------|
| **selection** | Fixed set of choices | status: selection(['draft', 'published', 'archived']) | 'draft' |
| **enum** | Named enumeration | difficulty: enum(Difficulty) where Difficulty = {EASY, MEDIUM, HARD} | Difficulty.EASY |

## Relationship Types

| Type | Description | Example | Notes | Lifecycle |
|------|-------------|---------|-------|-----------|
| **ref** | Aggregation: Child references parent (weak) | deck.created_by_id -> User | Foreign key in this model | Child can exist independently |
| **m2o** | Composition: Child is part of parent (strong) | card.deck_id -> Deck | Foreign key in this model | Child cannot exist without parent |
| **o2m** | One record has multiple children | collection.decks -> List[Deck] | Virtual field (inverse of ref/m2o) | Depends on child relationship type |
| **m2m** | Multiple records on both sides | user.activated_decks <-> deck.activated_by_users | Junction table required | Both sides exist independently |

**Key Difference between ref and m2o:**
- **ref (Aggregation)**: The child *references* the parent but can exist independently. On parent delete: SET NULL or RESTRICT. Example: Deck references User who created it.
- **m2o (Composition)**: The child is *part of* the parent. On parent delete: CASCADE. Example: Card is part of Deck.

## Constraint Symbols

| Symbol | Constraint | Meaning | Example |
|--------|------------|---------|---------|
| **\*** | Required | Field must have a value (NOT NULL) | name* |
| **U** | Unique | No duplicate values allowed | email (U) |
| **RO** | Read-only | Cannot be modified after creation | id (RO) |
| **C** | Computed | Calculated from other fields (not stored) | full_name (C) |
| **C/S** | Computed & Stored | Calculated but stored in DB | card_count (C/S) |
| **Rel** | Related | Value from a related model via dot notation (not stored). E.g., `collection_id.name` | collection_id.name (Rel) |
| **Rel/S** | Related & Stored | Same as Rel but denormalized and stored in DB | collection_id.name (Rel/S) |
| **PK** | Primary Key | Unique identifier, typically auto-generated | id (PK) |
| **FK** | Foreign Key | Reference to another model | user_id (FK) |
| **I** | Indexed | Database index for performance | email (I) |

## On-Delete Behaviors

When defining relationships, specify what happens when the parent record is deleted:

| Behavior | Description | Use Case |
|----------|-------------|----------|
| **CASCADE** | Delete child records automatically | Deck deleted -> all Cards deleted |
| **SET NULL** | Set foreign key to NULL | User deleted -> Cards.created_by = NULL |
| **RESTRICT** | Prevent deletion if children exist | Cannot delete Collection if Decks exist |
| **SET DEFAULT** | Set foreign key to default value | Advanced / rarely used |
| **NO ACTION** | Database handles it (usually like RESTRICT) | Advanced — let DB enforce integrity |

## Naming Conventions

- **Models:** PascalCase (e.g., `UserCardProgress`, `DeckActivation`)
- **Fields:** snake_case (e.g., `card_count`, `created_at`)
- **Single-reference fields (m2o/ref):** suffix with `_id` (e.g., `collection_id`, `created_by_id`). Both use `_id` suffix but mean different lifecycles — `m2o` is composition (CASCADE), `ref` is aggregation (SET NULL/RESTRICT).
- **One-to-many / many-to-many fields:** suffix with `_ids` (e.g., `card_ids`, `activated_deck_ids`)
- **Boolean fields:** phrase as a question using `is_`, `has_`, `can_` prefixes (e.g., `is_active`, `has_attachments`, `can_edit`)
- Maintain glossary throughout — avoid synonyms (one term = one concept)

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