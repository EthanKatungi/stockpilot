# StockPilot — UI implementation map

## Purpose
Build all Flutter interfaces as an approved, consistent shell **before** connecting state, persistence, authentication, and inventory business logic. UI is implemented in short Codex phases with review after each phase.

## Design sources

The consolidated [`stockpilot_complete_ui_reference.html`](stockpilot_complete_ui_reference.html) contains the complete UI gallery. Follow [`DESIGN_SOURCE_OF_TRUTH.md`](DESIGN_SOURCE_OF_TRUTH.md) for the current HTML-first workflow and source priority. Figma MCP is no longer used unless the user explicitly requests it.

The design language is dark forest green `#14532D`, mint `#EAF5ED`, white, neutral background `#F7FAF7`, ink `#17251D`, Inter typography, rounded 12–18 px cards, 8-point-derived spacing, and a 393 × 852 pt iPhone reference frame.

**All figures, suppliers, employees, contact information and product amounts shown in UI references are fictional demonstration content.**

## UI-only Codex phases

| Phase | Screens | What to verify |
|---|---|---|
| 1–3 (approved) | Dashboard, products, product details, add product | Existing code stays working and visual design consistent |
| 4 | Movement history, receive, issue, adjustment, movement details, low stock | Forms navigable, product preselection, mock-only submissions |
| 5 | Supplier list, supplier profile, add/edit supplier | Reusable form widgets, supplier row states, navigation |
| 6 | Purchase order list, create PO, order items, order detail, approve, receive, success | Explicit statuses, no changes to real inventory until backend module |
| 7 | Quotations; reports overview, valuation, movements, alerts, export | Tables/charts with mock data, filter UI without fake persisted results |
| 8 | Settings, business profile, app/notification preferences, notification center | Controls shown clearly as placeholders until persistence exists |
| 9 | Team directory, invite member, role permissions, account profile | Distinguish visual role checks from server authorization |
| 10 | Welcome, sign in, sign up, password reset, verification, workspace setup/selection | Forms usable and validated locally; do not simulate successful logins |
| 11 | Empty, error, loading, permission, offline, success, confirmation screens | All critical states visually testable with fixture data |
| 12 | UI consolidation and review | Widget tests, consistent theme, accessibility, small/large iPhone layouts, Flutter analyze |

## After UI completion — functionality modules

1. **Domain models and validation:** Product, StockMovement, Supplier, PurchaseOrder, PurchaseOrderItem, Organization, Membership. Use precise types and explicit monetary units.
2. **State management:** Riverpod providers/controllers. Replace hardcoded fixtures incrementally rather than in one large rewrite.
3. **Local persistence:** Drift/SQLite; migrations; normalized movement ledger; integration tests.
4. **Inventory engine:** Immutable movement records for receipts/issues/adjustments, stock not negative by default, appropriate transactions and tests.
5. **Purchasing engine:** PO state machine (`draft → approved → partially received → received`), receiving against orders and idempotency.
6. **Analytics and exports:** Aggregate inventory and purchasing data from the persistent source of truth.
7. **Backend and authentication:** Supabase Auth, PostgreSQL schema, Row Level Security, team/organization isolation.
8. **Multi-user & cloud sync:** Server-authoritative stock transactions, concurrency, retry behavior and optimistic states only when safe.
9. **Device integration & release:** Notifications, export/share flows, accessibility, TestFlight and CI/CD.

## Design-to-data contract

| UI item | Underlying data/action eventually required |
|---|---|
| Product list | Paginated/queryable products; stock summaries; category search |
| Product details | Product by ID; current stock derived from movements; reorder threshold |
| Add/edit product | Form validation; SKU uniqueness per organization; archive state |
| Stock receipt/issue/adjustment | Atomic, auditable stock-movement transaction with actor and reference |
| Supplier pages | Supplier CRUD, contact records and order history |
| PO creation | Header + line-item draft; recalculation of totals |
| PO approval | Server-side authorization and state transition |
| PO receipt | Idempotent receipt event, per-line quantities, inventory updates in same transaction |
| Reports | Date range and organization filters; server/local aggregation; export |
| Auth and workspace | Verified user identity, organization memberships and secure session lifecycle |
| Team and roles | Server-enforced permissions, not merely hidden Flutter buttons |
| Offline and errors | Explicit retry, sync/conflict behavior and recoverable states |

## Rules for Codex

- Inspect the existing Flutter project and relevant consolidated HTML frames before changing code.
- Keep approved screens stable unless a shared design-system correction is justified.
- Use **native Flutter** widgets (not WebView/HTML inside the app). Do not blindly convert HTML tags into Flutter.
- Centralize colors, typography, spacing and genuine shared components. Avoid premature abstractions.
- Keep static demo fixtures separate from widgets. Do not present fake save success, authentication or transaction processing.
- Implement one UI phase at a time; after each, run `dart format`, `flutter analyze`, relevant tests and a simulator check. Pause for review.
- Do not add Riverpod, storage or APIs during UI-only phases unless explicitly requested.
- Do not commit/push without the user's instruction.
