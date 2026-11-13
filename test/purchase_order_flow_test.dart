import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockpilot/core/theme/app_theme.dart';
import 'package:stockpilot/features/purchase_orders/purchase_order_detail_screen.dart';
import 'package:stockpilot/features/purchase_orders/approve_purchase_order_screen.dart';
import 'package:stockpilot/features/purchase_orders/receive_purchase_order_screen.dart';
import 'package:stockpilot/features/purchase_orders/new_purchase_order_screen.dart';
import 'package:stockpilot/features/purchase_orders/purchase_orders_screen.dart';
import 'package:stockpilot/main.dart';

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _openOrders(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.tap(find.text('More'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Purchase Orders'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('More opens orders and distinct selected details', (
    tester,
  ) async {
    _phoneSize(tester);
    await _openOrders(tester);
    expect(find.byType(PurchaseOrdersScreen), findsOneWidget);
    expect(find.text('Open orders'), findsOneWidget);
    expect(find.text('Awaiting receipt'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.text('PO-2026-014'));
    await tester.pumpAndSettle();
    expect(find.byType(PurchaseOrderDetailScreen), findsOneWidget);
    expect(find.text('Nile Agricultural Co.'), findsOneWidget);
    expect(find.text('Arabica Coffee'), findsOneWidget);
    expect(find.text('UGX 18,750,000'), findsOneWidget);
    expect(find.text('18 Nov 2026'), findsOneWidget);
    await tester.ensureVisible(find.text('Review & Approve'));
    await tester.tap(find.text('Review & Approve'));
    await tester.pumpAndSettle();
    expect(find.byType(ApprovePurchaseOrderScreen), findsOneWidget);
    expect(find.text('Nile Agricultural Co.'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(PurchaseOrderDetailScreen), findsOneWidget);
    Navigator.of(tester.element(find.byType(PurchaseOrderDetailScreen))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('PO-2026-013'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Elgon Coffee Traders'), findsOneWidget);
    expect(find.text('UGX 11,600,000'), findsOneWidget);
    expect(find.text('Robusta Coffee'), findsOneWidget);
    await tester.ensureVisible(find.text('Receive Goods'));
    await tester.tap(find.text('Receive Goods'));
    await tester.pumpAndSettle();
    expect(find.byType(ReceivePurchaseOrderScreen), findsOneWidget);
    expect(find.textContaining('Elgon Coffee Traders'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('status filters, empty state, and new-order navigation work', (
    tester,
  ) async {
    _phoneSize(tester);
    await _openOrders(tester);
    await tester.tap(find.text('Approved').first);
    await tester.pumpAndSettle();
    expect(find.text('PO-2026-013'), findsOneWidget);
    expect(find.text('PO-2026-014'), findsNothing);

    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('New Purchase Order'));
    await tester.tap(find.text('New Purchase Order'));
    await tester.pumpAndSettle();
    expect(find.byType(NewPurchaseOrderScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(PurchaseOrdersScreen), findsOneWidget);
    Navigator.of(tester.element(find.byType(PurchaseOrdersScreen))).pop();
    await tester.pumpAndSettle();
    expect(find.text('Suppliers'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const PurchaseOrdersScreen(orders: []),
      ),
    );
    expect(find.text('No purchase orders yet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
