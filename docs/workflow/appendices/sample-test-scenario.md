# Appendix A — Sample Test Scenario

Excerpt from a real Odoo procurement scenario. Acronyms (TDQ, VSQ, DQ, OOQ, TOQ) and statuses are defined in the companion spec, not here.

> **TC-INT1 — Full lifecycle: split, partial buy, top-up, edits, validate, cancel, re-buy**
>
> **Setup**
> - Product PROD001, on-hand stock = 3 at the procuring warehouse.
> - No existing TOL line for PROD001, no draft/open real PO for PROD001.
> - VSQ = 3 (captured at TOL creation, frozen). DQ = max(0, TDQ - 3).
>
> **State table**
>
> | # | Action                                       | TDQ | VSQ | DQ | OOQ | TOQ | Status   | Notes                            |
> |---|----------------------------------------------|-----|-----|----|-----|-----|----------|----------------------------------|
> | 1 | Create SO01, qty 7                           |  7  |  3  |  4 |  0  |  4  | to_order | DQ = 7 - 3 = 4                   |
> | 2 | Split API: SO01 ⇒ 6, SO02 ⇒ 11               | 17  |  3  | 14 |  0  | 14  | to_order | TDQ = 6 + 11 = 17                |
> | 3 | Create PO01 via Quick RFQ, override qty 14⇒4 | 17  |  3  | 14 |  4  | 10  | to_order | Default = TOQ; user lowers to 4  |
> | 4 | Create PO02 via Quick RFQ (default qty 10)   | 17  |  3  | 14 | 14  |  0  | rfq      | Default tracks live TOQ          |
> | … |                                              |     |     |    |     |     |          |                                  |
>
> **Per-step expectations (Step 3)**
> - **Given** TDQ = 17, VSQ = 3, DQ = 14, TOQ = 14.
> - **When** user triggers `action_new_quick_rfq`; new PO line defaults to qty 14 (= TOQ).
> - **And** user lowers qty to 4, saves (PO stays draft).
> - **Then** TOL line shows TDQ = 17, VSQ = 3, DQ = 14, OOQ = 4, TOQ = 10, status `to_order`.
> - **And** PO button becomes visible; clicking opens PO01 directly.
>
> **Cross-cutting expectations**
> - Dummy PO stays in `draft` at every step.
> - VSQ = 3 throughout — frozen at TOL creation.
> - DQ is never user-written — computed as max(0, TDQ - VSQ).
> - `sco_status` changes tracked in chatter (who / when / old ⇒ new).

The full scenario runs 10 steps and is followed by 4 sibling scenarios (transferred, dropship, TOQ-zero, cancellation-reactivation). The complete document is ~350 lines.

The format gives the developer:

- **The state table** — what must be true at each step.
- **Per-step Given/When/Then** — how to trigger and assert.
- **Cross-cutting expectations** — invariants to validate throughout.

The result: implementing the test is mechanical. There is no design judgement left to make.

## Navigation

- [Test Suite](../test-suite.md)
- [Workflow index](../README.md)
- [Landing page](../../AI_assisted_development_workflow.md)