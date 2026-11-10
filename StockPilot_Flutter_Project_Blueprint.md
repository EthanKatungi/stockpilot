# STOCKPILOT — Flutter Project Blueprint

**Purpose:** Relearn Flutter by shipping one incrementally more capable inventory and purchasing app.

**Scope:** A generic small-business inventory manager, with optional future modules for agricultural procurement and TMT operations. This plan intentionally does **not** start with a multi-tenant ERP.

**Platforms:** Flutter iOS simulator first; develop responsive layouts and add Flutter Web validation as a later exercise.

**Learning approach:** Read → Build → Connect → Test → Explain → Commit. Finish each module's acceptance checks before advancing. Use fabricated demonstration data, never live company data during development.

**Time:** No fixed deadlines. As a rough planning assumption, 6–10 focused hours weekly may take several months for the complete sequence. Rework modules freely.

---

## Product scope and milestones

**Milestone A: Offline inventory (modules 1–5)** — functional product catalog, local database and robust stock-in/stock-out ledger.

**Milestone B: Purchasing & reporting (modules 6–7)** — supplier records, purchase orders and simple analytics.

**Milestone C: Connected release (modules 8–10)** — authentication, server authorization, cloud records, tests and internal deployment.

**Explicit exclusions in early modules:** payments, invoicing/tax integration, live bank feeds, AI, import/export compliance, complex warehouse optimization, multi-currency accounting and offline conflict resolution.

### Definitions of done for every module

- [ ] I can demo the new feature without referring to tutorial code.
- [ ] I have tested normal, empty, invalid and failure states where relevant.
- [ ] `flutter analyze` and relevant automated tests pass.
- [ ] I can draw or explain how the feature's data travels from UI to storage.
- [ ] I have committed the work to Git with a meaningful message.
- [ ] I've written 3–5 sentences in `LEARNING_LOG.md` explaining what I learned and what is still confusing.

---

## Preparation (Module 0 — not counted as a core feature)

**Goal:** Create a reproducible development environment.

### Do
- [x] Check Flutter, Dart, Xcode/iOS Simulator and VS Code installations with `flutter doctor -v`.
- [ ] Run one unmodified Flutter starter app on the iOS Simulator.
- [ ] Create the project (`flutter create stockpilot`) and initialize Git.
- [ ] Add a `README.md` explaining the goal and planned modules; add `LEARNING_LOG.md`.
- [ ] Create GitHub repository (private is fine), ignore local secrets and generated files.
- [ ] Make the first commit and verify you can rebuild after a restart.

**Learn:** Flutter CLI, project structure, Dart entry point, hot reload versus hot restart, Git basics.

**Checkpoint:** Blank app starts from a clean checkout; `flutter doctor -v` has no blocker for your chosen iOS target.

---

## MODULE 1 — App shell, design system and navigation

**Goal:** A polished, navigable mock inventory app.

### Build
- [ ] Decide a small design system: colors, typography, spacing, light theme.
- [ ] Build four placeholder screens: Dashboard, Products, Movements, Settings.
- [ ] Add bottom navigation; add routes for Product Details and Add Product.
- [ ] Create reusable widgets: page header, metric card, empty-state view, primary button, product-list row.
- [ ] Add 8–12 **hardcoded** products and show them in a scrolling list.
- [ ] Handle narrow iPhone widths and long product names gracefully.

**Learn:** Widgets, `Scaffold`, layout constraints, lists, composition, themes, basic navigation, `go_router`, hot reload.

**Connect:** The Product List will be reused by real CRUD in Module 2; metric cards by analytics in Module 7.

**Pass when:** Every destination opens and returns correctly; no visible overflow on an iPhone simulator; no data storage or authentication yet.

**Demo:** Tap tabs, open a product detail page, navigate back, rotate or resize where relevant.

---

## MODULE 2 — Product data model, forms and in-memory CRUD

**Goal:** Replace decorative mock screens with genuine user interactions, still stored in RAM.

### Build
- [ ] Define a `Product` model: `id`, `sku`, `name`, `category`, `unit`, `reorderPoint`, `unitCostMinor`, `currency`, `isActive`, timestamps.
- [ ] Build Add Product form with validation and useful keyboard types.
- [ ] Build Edit Product screen and soft archive/unarchive action (not destructive deletion).
- [ ] Implement product search, category filter and sort.
- [ ] Show a friendly empty state and validation errors.
- [ ] Use a simple `setState`-based store for this first working iteration.
- [ ] Write tests for model/input validation (e.g. blank name, duplicate SKU, negative reorder point).

**Learn:** Forms, controllers, nullable fields, immutable models, basic validation, lists, sorting, IDs and CRUD.

**Connect:** The same forms will later write through Riverpod (M3) and Drift (M4), without changing their visual purpose.

**Pass when:** Add → View → Edit → Archive works; filters update immediately; restarting the app resets demo data **on purpose**.

**Demo:** Create `COF-001 / Arabica Coffee / kg`, edit the reorder point, archive it, see it disappear from active stock view.

---

## MODULE 3 — State management with Riverpod

**Goal:** Separate app state from widget code.

### Build
- [ ] Read Riverpod concepts: `Provider`, `NotifierProvider`, `FutureProvider` and `AsyncNotifierProvider` at a high level.
- [ ] Add `flutter_riverpod` and wrap the app in `ProviderScope`.
- [ ] Move product-list state and CRUD operations out of screens to a notifier/controller.
- [ ] Create derived filtered/sorted list state and a product count KPI.
- [ ] Keep form-local values inside the form and shared app data in providers.
- [ ] Write provider tests with an isolated provider container.
- [ ] Explain when `ref.watch`, `ref.read` and `ref.listen` are appropriate.

**Learn:** Reactive state, provider lifecycles, dependency injection, rebuilds, immutable updates, separation of concerns.

**Connect:** Products list, dashboard count and product details must all derive from the *same* source of truth.

**Pass when:** Add/edit/archive actions update all relevant screens instantly; provider tests pass; UI widgets do not own the product catalog.

**Demo:** Open Dashboard and Products; add a product; dashboard KPI updates without manually coordinating the two screens.

---

## MODULE 4 — Local persistence with Drift/SQLite

**Goal:** Product data survives closing and reopening the app.

### Build
- [ ] Follow Drift's current setup for your platforms; run code generation.
- [ ] Create `products` table with constraints and unique SKU, and a `categories` table if you want category management.
- [ ] Make a `ProductDao` or database service with create/read/update/archive methods.
- [ ] Create a repository interface, with a Drift-backed implementation.
- [ ] Inject the repository through Riverpod; keep UI unaware of SQL.
- [ ] Watch database queries so lists refresh reactively.
- [ ] Add a simple schema migration test (e.g. new `reorderPoint` field).
- [ ] Test app restart persistence and clean-empty database state.

**Learn:** Relational databases, SQL basics, asynchronous queries, Futures/Streams, repositories, DAOs and migrations.

**Connect:** Existing Module 3 controllers now use the repository rather than in-memory arrays.

**Pass when:** Records survive restart, no duplicates after repeated saves, and existing screens behave identically from the user's perspective.

**Demo:** Add a product, force close app, relaunch, view the same record.

---

## MODULE 5 — Reliable stock movements (the heart of the app)

**Goal:** Stock becomes a ledger, not an arbitrary editable quantity field.

### Build
- [ ] Design `StockMovement`: `id`, `productId`, `type` (`opening`, `receive`, `issue`, `adjustment`), `quantityDelta`, `reason`, `reference`, timestamp.
- [ ] Use **signed quantity deltas** (+ for received; − for issued). Record an opening balance as a movement.
- [ ] Show current stock as the sum of all approved movement deltas for each product.
- [ ] Add Receive Stock and Issue Stock forms; reject zero/negative entry sizes.
- [ ] Reject an issue that would reduce on-hand stock below zero (for this MVP).
- [ ] Save each movement with a local database transaction; do not update two unrelated values independently.
- [ ] Show a movement history page and a stock adjustment action with a mandatory reason.
- [ ] Write unit/database tests for balance calculations and invalid operations.

**Learn:** Business invariants, transactionality, streams, validation, domain logic and test-driven debugging.

**Connect:** The Dashboard, Products screen and Movement History all read the same underlying ledger. Never put the authoritative balance in a UI widget.

**Pass when:** Opening 50 kg → receiving 20 kg → issuing 5 kg produces 65 kg. Issuing 66 kg is rejected without changing the history or balance. App restart preserves 65 kg.

**Demo:** Repeat those exact steps and inspect all views.

**MILESTONE A REACHED: Useful offline inventory app.**

---

## MODULE 6 — Supplier records and purchase orders

**Goal:** Inventory starts to reflect real purchasing workflows.

### Build
- [ ] Define `Supplier` (`id`, name, contact details, notes, status).
- [ ] Create supplier list, Add/Edit Supplier form and supplier detail page.
- [ ] Define `PurchaseOrder` header and `PurchaseOrderLine` rows with product, ordered quantity and unit cost.
- [ ] Implement Draft → Ordered → Received / Cancelled status transitions. Document which edits are allowed at each stage.
- [ ] Create PO form supporting multiple lines and automatic total calculation.
- [ ] Add Receive Purchase Order action: when received, automatically create inventory movements **once** in a database transaction.
- [ ] Preserve the PO's recorded prices/quantities even if product information later changes.
- [ ] Test that receiving the same order twice cannot add stock twice; defer partial receipts if they distract from the MVP.

**Learn:** Foreign keys, one-to-many relations, data integrity, workflow states, idempotency and complex forms.

**Connect:** Purchase Orders → Stock Movements → Balance → Dashboard all stay consistent.

**Pass when:** Order 10 units of a product → mark received → product stock increases by 10 exactly once; cancelling a draft doesn't change stock.

**MILESTONE B partial: Purchasing system works.**

---

## MODULE 7 — Dashboard, alerts, reports and export

**Goal:** Turn records into useful decisions.

### Build
- [ ] Replace dashboard mock values with derived values from stored records.
- [ ] Show total SKUs, number below reorder point, recent receipts/issues and simple inventory valuation.
- [ ] Make Low Stock view with correct filtering.
- [ ] Add a chart (movements over time or top stock value by category); keep visualizations simple.
- [ ] Add a date-range filter and export a CSV report.
- [ ] Distinguish `loading`, `empty`, `success` and `error` UI states.
- [ ] Add tests for calculations and date filters.

**Learn:** Aggregations, derived state, charts, file I/O, async states, defensive UI.

**Connect:** The dashboard must never maintain shadow copies of stock or purchase totals; derive them from persisted records.

**Pass when:** New movement immediately changes its corresponding KPI; low-stock counts are correct; CSV opens in a spreadsheet app.

**Note:** Basic stock valuation can use quantity × current recorded unit cost as an *illustrative management estimate*, not formal financial accounting.

**MILESTONE B REACHED: Offline inventory + purchasing + reporting.**

---

## MODULE 8 — Authentication and user sessions

**Goal:** Introduce cloud identity without destabilizing the offline app.

### Build
- [ ] Create a separate development Supabase project.
- [ ] Add sign-up, sign-in, sign-out and password reset workflows.
- [ ] Implement route guards and auth-aware loading screens.
- [ ] Model `Profile` and `Organization` records and membership relationships.
- [ ] Show friendly UI for expired sessions, invalid passwords and network failure.
- [ ] Keep service-role or other secret backend keys **off devices**. Use the supported publishable client key and enforce server authorization.
- [ ] Test login persistence, logout and forbidden routes.

**Learn:** Authentication vs authorization, sessions, secure configuration, routing, async failures.

**Connect:** The existing app shell is now behind login for cloud mode; local learning/development records remain clearly separate.

**Pass when:** A new user can register, log out and log back in; unauthenticated users cannot open protected cloud screens.

---

## MODULE 9 — Cloud data, authorization and team access

**Goal:** Make a connected version safe for multiple users.

### Build
- [ ] Design PostgreSQL tables: organizations, memberships, products, movements, suppliers, purchase orders and lines.
- [ ] Include `organization_id` consistently in tenant-owned tables.
- [ ] Set least-privilege grants and Row Level Security on exposed tables; test allow/deny cases.
- [ ] Start with two roles: `owner` and `staff`. Decide explicitly which operations each can perform.
- [ ] Build a remote repository implementation and an explicit way to switch from the local demo dataset to cloud data.
- [ ] Implement server-side, atomic stock receipt/issue operations; do not rely on client-side checks for concurrent users.
- [ ] Make repeated receipt/issue requests idempotent using an operation/request identifier.
- [ ] Display loading, retry and offline/unavailable states. For the first cloud release, **require a network connection for stock-changing actions** instead of claiming full offline sync.
- [ ] Test that users from Organization A cannot read or mutate Organization B's data.

**Learn:** PostgreSQL, remote APIs, asynchronous programming, authorization, concurrency, transactions and multi-tenant data modeling.

**Connect:** Same screens, shared domain models and repository abstraction; new authenticated remote data source. Don't implement two-way synchronization until you deliberately design conflict resolution.

**Pass when:** Two users in the same organization see a consistent stock change; an unauthorized user is denied; rapid duplicate submissions don't double-post a movement.

---

## MODULE 10 — Testing, accessibility, performance and distribution

**Goal:** Complete an internal beta release.

### Build
- [ ] Add unit tests for product validation, balances, order status transitions, idempotency and calculations.
- [ ] Add widget tests for forms, empty states, loading states and error messages.
- [ ] Add integration tests: onboarding/login → create product → receive stock → create PO → view dashboard.
- [ ] Test with slow/absent networking and denied permissions.
- [ ] Use Flutter DevTools to inspect rebuilds, performance and memory on realistic datasets.
- [ ] Improve accessibility: semantic labels, contrast, touch targets, text scaling.
- [ ] Configure CI to run `flutter analyze` and `flutter test` on every push.
- [ ] Prepare icons, signing, privacy information and a TestFlight/internal beta if appropriate.
- [ ] Give 1–2 trusted testers a task script; collect feedback, not merely compliments.

**Learn:** Test pyramid, CI/CD, performance profiling, mobile deployment and product QA.

**Pass when:** Core flows have automated coverage, CI is green, no severe crashes/overflows, and a tester can complete tasks without your guidance.

**MILESTONE C REACHED: Connected internal beta.**

---

## Architecture: grow into it; don't start over-engineered

Start in modules 1–2 with a straightforward feature-first folder layout. Add dedicated repositories and services when modules 3–4 justify them.

```text
lib/
  main.dart
  app/
    app.dart
    router.dart
    theme.dart
  core/
    widgets/
    utils/
  features/
    dashboard/
      presentation/
    products/
      domain/
      presentation/
      data/
    inventory/
      domain/
      presentation/
      data/
    suppliers/
      ...
    purchasing/
      ...
    auth/
      ...
  data/
    local/
      app_database.dart
    remote/
      supabase_client.dart
```

Example **after** persistence is added:

```text
Product screen (Flutter widgets)
    ↓ user action
Product controller (Riverpod)
    ↓ method call
Product repository (domain-facing API)
    ↓
Drift database service (offline)  OR  Supabase client/server (connected)
    ↓ emits updated records
Product controller → Flutter widgets rebuild
```

Flutter's architecture guide separates views/view models from repositories/services. We will apply that pragmatically, not create a separate class for every button.

### Foundational data model

- **Product:** identity, SKU, name, category, measurement unit, reorder point, cost, active status.
- **StockMovement:** immutable-ish inventory event with signed quantity delta, reference, time and reason.
- **Supplier:** business/contact information.
- **PurchaseOrder:** supplier, order date, status and totals.
- **PurchaseOrderLine:** product, ordered quantity, unit cost and later received quantity if partial receipts are implemented.
- **Organization / Membership (later):** data ownership and authorized users.

**Accounting cautions:** Use decimal-safe or integer-minor-unit money types; don't use binary floating point for money. For stock, agree on the unit (pieces, kg, bags) before adding; if mixing units later, explicitly model conversion rules. Preserving transaction history is more important than allowing arbitrary edits to stock balance.

---

## Tests to keep pinned on your wall

| Scenario | Required behavior |
|---|---|
| Create two products with the same SKU | Duplicate rejected in the relevant business scope |
| Enter blank product name | Inline validation error |
| Restart after creating a product | Product still exists after Module 4 |
| Opening +50, receive +20, issue −5 | On hand = 65 |
| Attempt to issue 66 from 65 | Rejected, no movement written |
| Receive purchase order for 10 units | Stock +10, once only |
| Receive same PO a second time | No second increase |
| Change a product's unit cost | Historic PO line price unchanged |
| User A opens org B's inventory | Authorization denied on the server |
| Network fails during a cloud stock action | Clear status, no misleading success message |

---

## How to work in every module

**1 — Study (30–90 minutes as needed):** Read just enough official docs to understand the next task. Write a tiny playground example for unfamiliar APIs.

**2 — Implement:** Break the feature into small commits; don't have an AI generate the whole module in one prompt.

**3 — Connect:** Trace how the feature updates existing screens and persisted records.

**4 — Verify:** Run `flutter analyze`, `flutter test`, device checks, and the explicit acceptance scenario.

**5 — Teach back:** Explain out loud (or in `LEARNING_LOG.md`) how the feature works and what could go wrong.

**6 — Commit:** Name commits for an observable outcome, e.g., `feat(inventory): record stock receipts in sqlite`.

### Progress tracker

- [ ] Preparation (0): environment and Git
- [ ] Module 1: navigation and design system
- [ ] Module 2: in-memory product CRUD
- [ ] Module 3: Riverpod reactive state
- [ ] Module 4: Drift persistence
- [ ] Module 5: stock ledger and tests
- [ ] **Milestone A passed**
- [ ] Module 6: suppliers and purchase orders
- [ ] Module 7: dashboard and reports
- [ ] **Milestone B passed**
- [ ] Module 8: authentication
- [ ] Module 9: cloud data and authorization
- [ ] Module 10: QA and distribution
- [ ] **Milestone C passed**

---

## Future modules (not part of the initial 10)

1. **TMT coffee lots:** origin, grade, moisture, bag count and lot lineage.
2. **Quotation comparisons:** supplier bids, price history and approvals.
3. **Warehouse operations:** multiple locations, scanning and audit counting.
4. **Export documents:** contract attachments, shipment checklists and deadlines.
5. **Buyer portal:** selected lots and quotation requests.
6. **Multi-company SaaS:** configurable organizations, tenant billing, onboarding, support and audit logs.

Decide which to prioritize **only after** interviewing real users and observing their work. A generic stock tool may be best as the learning product; procurement/export tools could be the commercial product.

---

## Reference documentation

- Flutter architecture: https://docs.flutter.dev/app-architecture/guide
- Flutter navigation: https://docs.flutter.dev/ui/navigation
- Flutter testing: https://docs.flutter.dev/testing/overview
- Riverpod: https://riverpod.dev/docs/concepts2/providers
- Riverpod testing: https://riverpod.dev/docs/how_to/testing
- Drift: https://drift.simonbinder.eu/
- Supabase Flutter: https://supabase.com/docs/guides/getting-started/quickstarts/flutter
- Supabase RLS: https://supabase.com/docs/guides/database/postgres/row-level-security

**Versioning note:** This blueprint identifies APIs and concepts rather than pinning exact package versions. Check the current package documentation when beginning each module.
