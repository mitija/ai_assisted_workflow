# Quality Checklist

Detailed review checklist for [Step 5: Review](../steps/05-review.md). Use this to validate specification completeness, consistency, and correctness.

## Completeness

- [ ] All models from requirements documented (each in its own `models/<ModelName>.md`)
- [ ] All attributes defined with types and constraints
- [ ] All relationships identified
- [ ] All user roles defined
- [ ] Permissions matrix complete (every use case has role assignments)
- [ ] All use cases documented (each in its own `use-cases/UC-XXX-<title>.md`)
- [ ] Every use case has acceptance criteria
- [ ] Non-functional requirements specified

## Structure / Formatting

- [ ] Sections exceeding 40 lines (>40) extracted to separate files (Data Initialization, NFR, Integration Points, Appendices)
- [ ] All relative links between files are valid (index -> models, index -> use cases, cross-references)
- [ ] The main index (`spec-index.md`) links to every sub-file

## Consistency

- [ ] Model names used consistently throughout
- [ ] Field names match across use cases and models
- [ ] Role names consistent in permissions matrix and use cases
- [ ] Use case numbering sequential
- [ ] Glossary terms used correctly

## Clarity

- [ ] Use cases are unambiguous
- [ ] Technical jargon explained in glossary
- [ ] Acceptance criteria are testable
- [ ] Exception flows cover edge cases

## Traceability

- [ ] Each requirement from plain English addressed
- [ ] Each model referenced in at least one use case
- [ ] Each use case references at least one model
- [ ] Permissions align with business rules

## Technical Feasibility

- [ ] Data model relationships are sound
- [ ] Cascade delete rules won't cause data loss issues
- [ ] Performance requirements are realistic
- [ ] Security requirements address common vulnerabilities

## Anti-Patterns

- **Skipping Generic Use Cases** — Do not assume "everyone knows CRUD" — document it. Generic use cases often have domain-specific twists.
- **Vague Acceptance Criteria** — "User can create decks" is NOT testable. "Given a collection, when user submits valid form, then deck created" IS testable.
- **Missing Exception Flows** — Happy path is not enough. Consider validation, permissions, concurrency, system errors.
- **Inconsistent Terminology** — Using both "Flashcard" and "Card" interchangeably creates confusion. Pick one term and stick to it.
- **Overly Complex Models** — Do not over-engineer for hypothetical future needs. Start with MVP, document future enhancements separately.
- **Forgetting Audit Fields** — Who created this? When? Who modified it? Plan for audit trails early, hard to add later.