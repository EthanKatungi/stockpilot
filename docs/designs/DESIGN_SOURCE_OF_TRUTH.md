# StockPilot UI design source of truth

## Reference and priority

The consolidated reference is [`stockpilot_complete_ui_reference.html`](stockpilot_complete_ui_reference.html). It contains the planned screen and state gallery. Use it as the primary visual specification for new and unapproved UI. Build the app with native Flutter and Dart widgets; the HTML is a reference, not application code.

Apply sources in this order:

1. Approved Flutter screens retain their existing functionality and overall visual design.
2. The consolidated HTML reference guides new and unapproved screens.
3. `AppTheme` and existing shared widgets keep implementations consistent.
4. Written phase requirements define behavior and interactions that a static mockup cannot show.

Some HTML frames reconstruct earlier mockups. Minor differences are not a reason to rewrite approved Dashboard, Products, Product Details, or Add Product screens. Report any serious conflict before changing an approved screen substantially.

## Workflow

- Stop relying on Figma MCP for UI implementation. Use it again only if the user explicitly requests it.
- Inspect the relevant HTML frame, existing Flutter architecture, theme, mock data, and routes before coding.
- Implement and review one phase at a time. Preserve approved features and bottom navigation.
- Keep UI fixtures separate from widgets. Forms may validate input, but must clearly disclose that stock and records are not yet saved.
- Format modified Dart files, run `flutter analyze` and relevant tests, and inspect the iOS simulator when available.
- Summarize design differences and placeholders, then wait for approval before starting the next phase.
