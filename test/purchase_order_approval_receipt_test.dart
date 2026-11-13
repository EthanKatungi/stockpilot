import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockpilot/core/theme/app_theme.dart';
import 'package:stockpilot/features/purchase_orders/approve_purchase_order_screen.dart';
import 'package:stockpilot/features/purchase_orders/goods_received_screen.dart';
import 'package:stockpilot/features/purchase_orders/purchase_order.dart';
import 'package:stockpilot/features/purchase_orders/purchase_orders_mock_data.dart';
import 'package:stockpilot/features/purchase_orders/receive_purchase_order_screen.dart';

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  test('ordered mock quantities parse safely', () {
    expect(parseOrderedQuantity('2,000 kg'), (amount: 2000, unit: 'kg'));
    expect(parseOrderedQuantity('500 pcs'), (amount: 500, unit: 'pcs'));
    expect(parseOrderedQuantity('bad quantity'), isNull);
  });

  testWidgets('I18 reviews selected order and handles approval cancellation', (
    tester,
  ) async {
    _phoneSize(tester);
    final order = PurchaseOrdersMockData.orders.first;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ApprovePurchaseOrderScreen(order: order),
      ),
    );
    expect(find.text(order.id), findsOneWidget);
    expect(find.text(order.supplier.businessName), findsOneWidget);
    expect(find.text(order.totalValue), findsOneWidget);
    expect(find.text('Arabica Coffee'), findsOneWidget);
    await tester.ensureVisible(find.byType(TextFormField));
    await tester.enterText(find.byType(TextFormField), 'Approved for review');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    tester.testTextInput.hide();
    await tester.ensureVisible(find.text('Approve Order'));
    await tester.tap(find.text('Approve Order'));
    await tester.pumpAndSettle();
    expect(find.text('Approve purchase order?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Nothing was changed'), findsNothing);
    await tester.tap(find.text('Approve Order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm Approval'));
    await tester.pump();
    expect(find.textContaining('Nothing was changed'), findsOneWidget);
    expect(order.status, PurchaseOrderStatus.draft);
  });

  testWidgets('I18 blocks approval of already received orders', (tester) async {
    _phoneSize(tester);
    final order = PurchaseOrdersMockData.orders[2];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ApprovePurchaseOrderScreen(order: order),
      ),
    );
    await tester.ensureVisible(find.text('Approve Order'));
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Approve Order'),
    );
    expect(button.onPressed, isNull);
    expect(order.status, PurchaseOrderStatus.received);
  });

  testWidgets(
    'I19 validates zero, negative and excess before receipt preview',
    (tester) async {
      _phoneSize(tester);
      final order = PurchaseOrdersMockData.orders[1];
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: ReceivePurchaseOrderScreen(order: order),
        ),
      );
      expect(find.textContaining(order.id), findsOneWidget);
      expect(find.textContaining(order.supplier.businessName), findsOneWidget);
      expect(find.text('Robusta Coffee'), findsOneWidget);
      expect(find.text('Jute Sacks'), findsOneWidget);

      await tester.ensureVisible(find.text('Confirm Receipt'));
      await tester.tap(find.text('Confirm Receipt'));
      await tester.pumpAndSettle();
      expect(find.textContaining('greater than zero'), findsOneWidget);
      expect(find.text('Enter a delivery reference'), findsOneWidget);

      final inputs = find.byType(TextFormField);
      await tester.ensureVisible(inputs.at(0));
      await tester.enterText(inputs.at(0), '-1');
      await tester.enterText(inputs.at(2), 'DEL-2026-042');
      await tester.ensureVisible(find.text('Confirm Receipt'));
      await tester.tap(find.text('Confirm Receipt'));
      await tester.pumpAndSettle();
      expect(find.text('Quantity cannot be negative'), findsOneWidget);

      await tester.ensureVisible(inputs.at(0));
      await tester.enterText(inputs.at(0), '1,501');
      await tester.ensureVisible(find.text('Confirm Receipt'));
      await tester.tap(find.text('Confirm Receipt'));
      await tester.pumpAndSettle();
      expect(find.text('Cannot exceed 1,500'), findsOneWidget);

      await tester.ensureVisible(inputs.at(0));
      await tester.enterText(inputs.at(0), '1,000');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      tester.testTextInput.hide();
      await tester.ensureVisible(find.text('Confirm Receipt'));
      await tester.tap(find.text('Confirm Receipt'));
      await tester.pumpAndSettle();
      expect(find.text('Confirm receipt preview?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Nothing was recorded'), findsNothing);
      await tester.ensureVisible(inputs.at(0));
      await tester.enterText(inputs.at(0), '1,500');
      await tester.ensureVisible(inputs.at(1));
      await tester.enterText(inputs.at(1), '500');
      tester.testTextInput.hide();
      await tester.ensureVisible(find.text('Confirm Receipt'));
      await tester.tap(find.text('Confirm Receipt'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.byType(GoodsReceivedScreen), findsOneWidget);
      expect(find.text('PO-2026-013'), findsOneWidget);
      expect(find.textContaining('DEL-2026-042'), findsOneWidget);
      expect(find.text('1,500 kg'), findsOneWidget);
      expect(find.text('500 pcs'), findsOneWidget);
      expect(find.textContaining('No receipt, stock movement'), findsOneWidget);
      expect(order.status, PurchaseOrderStatus.approved);
    },
  );
}
