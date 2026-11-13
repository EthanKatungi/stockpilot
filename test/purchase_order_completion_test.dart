import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockpilot/core/theme/app_theme.dart';
import 'package:stockpilot/features/movements/movements_screen.dart';
import 'package:stockpilot/features/purchase_orders/goods_received_screen.dart';
import 'package:stockpilot/features/purchase_orders/purchase_order.dart';
import 'package:stockpilot/features/purchase_orders/purchase_orders_mock_data.dart';
import 'package:stockpilot/features/purchase_orders/purchase_orders_screen.dart';
import 'package:stockpilot/features/purchase_orders/supplier_quotations_mock_data.dart';
import 'package:stockpilot/features/purchase_orders/supplier_quotations_screen.dart';
import 'package:stockpilot/main.dart';

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _openReceiptPreview(WidgetTester tester) async {
  await tester.tap(find.text('PO-2026-013'));
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('Receive Goods'));
  await tester.tap(find.text('Receive Goods'));
  await tester.pumpAndSettle();
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), '1,000');
  await tester.ensureVisible(fields.at(2));
  await tester.enterText(fields.at(2), 'DEL-2026-042');
  tester.testTextInput.hide();
  await tester.ensureVisible(find.text('Confirm Receipt'));
  await tester.tap(find.text('Confirm Receipt'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
  expect(find.byType(GoodsReceivedScreen), findsOneWidget);
}

void main() {
  test('mock quotes compare equal quantities and compute their totals', () {
    final quotes = SupplierQuotationsMockData.quotations;
    expect(quotes.map((quote) => quote.productName).toSet(), {
      'Arabica Coffee',
    });
    expect(quotes.map((quote) => quote.quantity).toSet(), {2000});
    expect(quotes.map((quote) => quote.total), [17000000, 17500000, 18200000]);
  });

  testWidgets('I14 opens I21 and quote action stays a placeholder', (
    tester,
  ) async {
    _phoneSize(tester);
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const PurchaseOrdersScreen()),
    );
    await tester.ensureVisible(find.text('Compare Supplier Quotations'));
    await tester.tap(find.text('Compare Supplier Quotations'));
    await tester.pumpAndSettle();
    expect(find.byType(SupplierQuotationsScreen), findsOneWidget);
    expect(find.text('LOWEST PRICE'), findsOneWidget);
    expect(find.text('UGX 17,000,000'), findsOneWidget);
    expect(find.text('UGX 17,500,000'), findsOneWidget);
    expect(find.text('UGX 18,200,000'), findsOneWidget);
    await tester.tap(find.text('Nile Agricultural Co.'));
    await tester.ensureVisible(find.text('Create Order from Quote'));
    await tester.tap(find.text('Create Order from Quote'));
    await tester.pump();
    expect(find.textContaining('Nothing was created'), findsOneWidget);
    expect(PurchaseOrdersMockData.orders.length, 9);
    expect(tester.takeException(), isNull);
  });

  testWidgets('I20 returns to orders or opens the Stock tab', (tester) async {
    _phoneSize(tester);
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Purchase Orders'));
    await tester.pumpAndSettle();

    await _openReceiptPreview(tester);
    expect(find.text('1,000 kg'), findsOneWidget);
    expect(find.textContaining('DEL-2026-042'), findsOneWidget);
    await tester.ensureVisible(find.text('Back to Purchase Orders'));
    await tester.tap(find.text('Back to Purchase Orders'));
    await tester.pumpAndSettle();
    expect(find.byType(PurchaseOrdersScreen), findsOneWidget);

    await _openReceiptPreview(tester);
    await tester.ensureVisible(find.text('View Stock Movements'));
    await tester.tap(find.text('View Stock Movements'));
    await tester.pumpAndSettle();
    expect(find.byType(MovementsScreen), findsOneWidget);
    expect(find.text('Stock'), findsOneWidget);
    expect(
      PurchaseOrdersMockData.orders[1].status,
      PurchaseOrderStatus.approved,
    );
    expect(tester.takeException(), isNull);
  });
}
