import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockpilot/core/theme/app_theme.dart';
import 'package:stockpilot/features/movements/low_stock_alerts_screen.dart';
import 'package:stockpilot/features/movements/movement_detail_screen.dart';
import 'package:stockpilot/features/movements/movements_screen.dart';
import 'package:stockpilot/features/movements/record_stock_movement_screen.dart';
import 'package:stockpilot/features/movements/stock_adjustment_screen.dart';
import 'package:stockpilot/features/products/products_mock_data.dart';
import 'package:stockpilot/main.dart';

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetViewInsets);
}

void main() {
  testWidgets('Stock tab filters movements and opens their details', (
    tester,
  ) async {
    _phoneSize(tester);
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Stock'));
    await tester.pumpAndSettle();

    expect(find.text('Stock Movements'), findsOneWidget);
    await tester.tap(find.text('Arabica Coffee'));
    await tester.pumpAndSettle();
    expect(find.byType(MovementDetailScreen), findsOneWidget);
    expect(find.text('DEL-2026-042'), findsOneWidget);
    expect(find.text('Warehouse team'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Issued'));
    await tester.pumpAndSettle();
    expect(find.text('Packaging Bags'), findsOneWidget);
    expect(find.text('Arabica Coffee'), findsNothing);
    await tester.tap(find.text('Packaging Bags'));
    await tester.pumpAndSettle();
    expect(find.text('ISS-2026-019'), findsOneWidget);
    expect(find.text('8,200 pcs'), findsOneWidget);
  });

  testWidgets('Product movement flow keeps its product and stock unchanged', (
    tester,
  ) async {
    _phoneSize(tester);
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Products'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Arabica Coffee'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Record stock movement'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Receive stock'));
    await tester.pumpAndSettle();
    expect(find.byType(RecordStockReceiptScreen), findsOneWidget);
    expect(find.text('Arabica Coffee · ARA-001'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), '100');
    await tester.enterText(find.byType(TextFormField).at(1), 'RCV-2000');
    await tester.tap(find.text('Record Receipt'));
    await tester.pump();
    expect(
      find.text('Stock receipt recording will be implemented in Module 2.'),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('42,000 kg'), findsOneWidget);

    await tester.tap(find.text('Record stock movement'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Issue stock'));
    await tester.pumpAndSettle();
    expect(find.byType(RecordStockIssueScreen), findsOneWidget);
    expect(find.text('Available stock: 42,000 kg'), findsOneWidget);

    await tester.tap(find.text('Adjust'));
    await tester.pumpAndSettle();
    expect(find.byType(StockAdjustmentScreen), findsOneWidget);
    expect(find.text('Arabica Coffee · ARA-001'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Record stock movement'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adjust stock'));
    await tester.pumpAndSettle();
    expect(find.byType(StockAdjustmentScreen), findsOneWidget);
    expect(find.text('42,000 kg'), findsOneWidget);
  });

  testWidgets('Dashboard alert card opens seven matching mock alerts', (
    tester,
  ) async {
    _phoneSize(tester);
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Low-stock alerts'));
    await tester.pumpAndSettle();

    expect(find.byType(LowStockAlertsScreen), findsOneWidget);
    expect(find.text('7 products need attention'), findsOneWidget);
    expect(find.text('120 L available · Reorder at 200 L'), findsOneWidget);
    await tester.tap(find.text('Critical').first);
    await tester.pumpAndSettle();
    expect(find.text('Roasted Robusta'), findsOneWidget);
    expect(find.text('Green Tea'), findsNothing);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Good morning, Ethan'), findsOneWidget);
  });

  testWidgets('empty movement list and keyboard inset do not overflow', (
    tester,
  ) async {
    _phoneSize(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: MovementsScreen(movements: [])),
      ),
    );
    expect(find.text('No stock movements yet'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: RecordStockReceiptScreen(
          product: ProductsMockData.products.first,
        ),
      ),
    );
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(TextFormField).last);
    await tester.enterText(find.byType(TextFormField).last, 'Count checked');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    for (final screen in <Widget>[
      RecordStockIssueScreen(product: ProductsMockData.products.first),
      StockAdjustmentScreen(product: ProductsMockData.products.first),
    ]) {
      await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: screen));
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(TextFormField).last);
      await tester.enterText(find.byType(TextFormField).last, 'Count checked');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
