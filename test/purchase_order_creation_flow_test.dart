import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockpilot/core/theme/app_theme.dart';
import 'package:stockpilot/features/purchase_orders/add_order_items_screen.dart';
import 'package:stockpilot/features/purchase_orders/new_purchase_order_screen.dart';
import 'package:stockpilot/features/purchase_orders/purchase_order_draft.dart';
import 'package:stockpilot/features/purchase_orders/purchase_orders_screen.dart';
import 'package:stockpilot/features/products/products_mock_data.dart';
import 'package:stockpilot/features/suppliers/supplier.dart';

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  test('draft totals use the selected products and prices', () {
    final draft = PurchaseOrderDraft();
    draft.items.addAll([
      DraftOrderLine(
        product: ProductsMockData.products.first,
        quantity: 2000,
        unitPrice: 8750,
      ),
      DraftOrderLine(
        product: ProductsMockData.products[2],
        quantity: 500,
        unitPrice: 2500,
      ),
    ]);
    expect(draft.items.first.subtotal, 17500000);
    expect(draft.total, 18750000);
    draft.items.removeAt(0);
    expect(draft.total, 1250000);
  });

  testWidgets('I14 opens I15, then I16, and keeps form values on return', (
    tester,
  ) async {
    _phoneSize(tester);
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const PurchaseOrdersScreen()),
    );
    await tester.ensureVisible(find.text('New Purchase Order'));
    await tester.tap(find.text('New Purchase Order'));
    await tester.pumpAndSettle();
    expect(find.byType(NewPurchaseOrderScreen), findsOneWidget);

    await tester.tap(find.text('Continue to Items'));
    await tester.pumpAndSettle();
    expect(find.text('Select a supplier'), findsWidgets);

    await tester.tap(find.byType(DropdownButtonFormField<Supplier>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nile Agricultural Co.').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(TextFormField).last);
    await tester.enterText(find.byType(TextFormField).last, 'November restock');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue to Items'));
    await tester.pumpAndSettle();
    expect(find.byType(AddOrderItemsScreen), findsOneWidget);
    expect(find.text('Nile Agricultural Co.'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(NewPurchaseOrderScreen), findsOneWidget);
    expect(find.text('Nile Agricultural Co.'), findsOneWidget);
    expect(find.text('November restock'), findsOneWidget);
    await tester.tap(find.text('Continue to Items'));
    await tester.pumpAndSettle();
    expect(find.byType(AddOrderItemsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('I16 adds and removes items, validates input, and never saves', (
    tester,
  ) async {
    _phoneSize(tester);
    final draft = PurchaseOrderDraft();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: AddOrderItemsScreen(draft: draft),
      ),
    );

    await tester.tap(find.text('Add item'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to Order'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a number greater than zero'), findsNWidgets(2));

    await tester.tap(find.byType(DropdownButtonFormField<MockProduct>));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Arabica Coffee').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '2,000');
    await tester.enterText(find.byType(TextFormField).last, '8,750');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to Order'));
    await tester.pumpAndSettle();
    expect(draft.items.length, 1);
    expect(find.text('UGX 17,500,000'), findsOneWidget);

    await tester.tap(find.text('Save Purchase Order Draft'));
    await tester.pump();
    expect(find.textContaining('Nothing was saved'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove Arabica Coffee'));
    await tester.pumpAndSettle();
    expect(draft.items, isEmpty);
    expect(find.text('UGX 0'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
