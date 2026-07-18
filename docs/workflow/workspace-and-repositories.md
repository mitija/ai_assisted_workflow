# Workspace and Repository Layout

The project folder is a **workspace root**, not itself the source repository. It contains two git repositories with different lifecycles, plus an unversioned local area:

```
project-folder/
├── docs/                 # documentation/specification git repo
│   ├── customer-facing/  # contractual specs/tests, tagged when ready
│   └── working/          # versioned project documentation work
├── src/                  # source-code git repo
└── local/                # unversioned prompts, session notes, logs, scratch material
```

This separation is deliberate:

- **Documentation repo** — evolves on the specification lifecycle.
- **Code repo** — evolves on the implementation and delivery lifecycle.
- **Local area** — captures unversioned process material that is useful during AI-assisted work but is not a contractual artifact.

## Documentation Repo

Single branch, with two top-level areas: `customer-facing/` and `working/`. Customer has read access from day one and validates the customer-facing artifacts directly on the branch. There is no separate review copy. Customer sign-off triggers tagging at each spec freeze (e.g. `spec-260513`). The tag is the stable implementation contract.

```
docs/
├── customer-facing/
│   ├── <epic>_SPEC.md       (functional specification)
│   └── <epic>_TESTS.md      (end-to-end test scenarios)
└── working/                 (versioned project documentation work)
```

## Code Repo

Standard. Automated tests live here, derived from the doc scenarios. The dev server tracks the latest delivered work. Source commits, pull requests, development reports, or implementation ledgers should reference the docs tag they implement, so the source history can always be traced back to the exact specification state.

Example source-side reference:

```text
Spec: docs@spec-260513
```

## Docs Working Area

Versioned by design. `docs/working/` may contain conception notes, consultant-developer Q&A, analysis, and work-in-progress drafts that are relevant to the project and worth preserving with the documentation history. It is part of the docs repo, but it does not override the tagged customer-facing specification and tests.

## Local Area

Unversioned by design. `local/` may contain prompt drafts, AI session notes, copied logs, temporary experiments, and other scratch material. It is useful context for humans and AI agents, but it does not override the tagged documentation repo and should not be treated as contractual.

## Navigation

- [Workflow index](README.md)
- [Landing page](../AI_assisted_development_workflow.md)