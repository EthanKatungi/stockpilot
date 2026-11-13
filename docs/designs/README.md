# StockPilot Modular UI Design Reference

This folder contains **55 static mobile screen mockups**, divided into **nine focused HTML gallery files** for Codex and human review.

Open `index.html` in your browser to browse the library. The files are offline and have no external dependencies.

## Source-of-truth / usage guidance

- **Existing approved Flutter implementations**: preserve their working behavior and overall design. Do not overwrite them for minor cosmetic differences.
- **For new screens or unapproved work**, use the relevant feature HTML file, plus `design_tokens.css` and `components.css`.
- **Do not read the complete 55-screen master HTML as part of each Codex phase.** Use `screen_manifest.json` if you need to locate an ID.
- **HTML here is static design only**, not functioning application logic. Build native Flutter widgets, not a WebView.
- Figma-derived mockups are HTML **reconstructions**, not pixel-exact Figma exports. Other screens were originally HTML mockups.
- Values, names, dates, transactions and form content are illustrative. Validate real business rules separately.

## Module files and stable screen IDs

| File | Screen IDs | Count | Scope |
|---|---|---:|---|
| `dashboard.html` | M01 | 1 | Dashboard shell, valuation, summary metrics and recent activity |
| `products.html` | M02, M03, M04, I07, I08, I09 | 6 | Product list, detail, add, edit, search and archive |
| `stock_movements.html` | I01, I02, I03, I04, I05, I06 | 6 | Movement history, stock receipt, issue, adjustment, details and low-stock alerts |
| `suppliers.html` | I10, I11, I12, I13 | 4 | Supplier directory, profile, add and edit forms |
| `purchase_orders.html` | I14, I15, I16, I17, I18, I19, I20, I21 | 8 | Purchase order list, creation, line items, details, approval, receiving and quotations |
| `reports.html` | R01, R02, R03, R04, R05 | 5 | Overview, valuations, movement reports, low-stock reports and exports |
| `settings.html` | S01, S02, S03, S04, S05, S06, S07, S08, S09 | 9 | Settings, preferences, notifications, profile, team and access |
| `authentication.html` | A01, A02, A03, A04, A05, A06, A07, A08 | 8 | Welcome, sign-in, account creation, password reset and workspace onboarding |
| `system_states.html` | X01, X02, X03, X04, X05, X06, X07, X08 | 8 | Network, loading, empty, errors, success, permission and confirmation |

## Suggested Codex handoff

> Design reference for this task: `docs/designs/purchase_orders.html` (only screen IDs I14 and I17 in subphase 4C.1), plus `docs/designs/design_tokens.css` and `docs/designs/components.css`. Do not read unrelated mockup galleries or the master reference. Inspect only the target feature files and immediate dependencies. Reuse existing UI components. Build native Flutter widgets. Do not modify unrelated screens, add unnecessary dependencies, or implement backend business logic during the UI-only phase. Format modified files and run `flutter analyze` and relevant tests. Summarize changes and stop.

## Suggested directory

```
stockpilot/
  docs/
    designs/
      index.html
      README.md
      design_tokens.css
      components.css
      screen_manifest.json
      dashboard.html
      products.html
      stock_movements.html
      suppliers.html
      purchase_orders.html
      reports.html
      settings.html
      authentication.html
      system_states.html
      assets/stockpilot_concept.webp
```

The original full gallery can be stored elsewhere as an archive; it is **not required** to render these split files.
