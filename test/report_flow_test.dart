import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockpilot/features/movements/movements_screen.dart';
import 'package:stockpilot/features/products/products_mock_data.dart';
import 'package:stockpilot/features/reports/analytics_dashboard_screen.dart';
import 'package:stockpilot/features/reports/inventory_valuation_screen.dart';
import 'package:stockpilot/features/reports/reports_mock_data.dart';
import 'package:stockpilot/features/reports/widgets/report_charts.dart';
import 'package:stockpilot/main.dart';

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _openAnalytics(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.tap(find.text('More'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Analytics & Reports'));
  await tester.pumpAndSettle();
}

void main() {
  test('valuation totals are based on the existing mock product values', () {
    final products = ProductsMockData.products;
    expect(products.length, 18);
    expect(ReportsMockData.valueOf(products.first), 367500000);
    expect(ReportsMockData.totalValue(products), greaterThan(1000000000));
    expect(
      ReportsMockData.totalValue(
        products.where((item) => item.category == ProductCategory.coffee),
      ),
      lessThan(ReportsMockData.totalValue(products)),
    );
  });

  testWidgets('R01 changes period and opens R02', (tester) async {
    _phoneSize(tester);
    await _openAnalytics(tester);
    expect(find.byType(AnalyticsDashboardScreen), findsOneWidget);
    expect(find.text('Stock received'), findsOneWidget);
    expect(find.text('Stock issued'), findsOneWidget);
    expect(find.byType(InventoryTrendChart), findsOneWidget);
    expect(find.byType(MovementBarsChart), findsOneWidget);

    await tester.tap(find.byType(DropdownButton<ReportPeriod>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('7 days').last);
    await tester.pumpAndSettle();
    expect(find.text('12,450 kg'), findsOneWidget);
    expect(find.text('4,200 kg'), findsOneWidget);

    final chart = tester.getRect(find.byType(InventoryTrendChart));
    await tester.tapAt(Offset(chart.right - 4, chart.center.dy));
    await tester.pumpAndSettle();
    expect(find.text('S · Trend index 77'), findsOneWidget);

    await tester.ensureVisible(find.text('Stock valuation'));
    await tester.tap(find.text('Stock valuation'));
    await tester.pumpAndSettle();
    expect(find.byType(InventoryValuationScreen), findsOneWidget);
    expect(find.text('Exact valuation: UGX 1,054,926,000'), findsOneWidget);
    expect(find.text('Category breakdown'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'R02 filters, sorts, searches and keeps export as a placeholder',
    (tester) async {
      _phoneSize(tester);
      await _openAnalytics(tester);
      await tester.ensureVisible(find.text('Stock valuation'));
      await tester.tap(find.text('Stock valuation'));
      await tester.pumpAndSettle();
      expect(find.text('Arabica Coffee'), findsOneWidget);
      expect(find.text('Robusta Coffee'), findsOneWidget);

      await tester.tap(find.text('Coffee').first);
      await tester.pumpAndSettle();
      expect(find.text('Packaging Bags'), findsNothing);
      await tester.enterText(find.byType(TextField), 'ROB-002');
      await tester.pumpAndSettle();
      expect(find.text('Robusta Coffee'), findsOneWidget);
      expect(find.text('Arabica Coffee'), findsNothing);

      await tester.enterText(find.byType(TextField), '');
      await tester.tap(find.text('Highest value'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lowest value').last);
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.text('Roasted Robusta')).dy,
        lessThan(tester.getTopLeft(find.text('Arabica Coffee')).dy),
      );

      await tester.ensureVisible(find.text('Export'));
      await tester.tap(find.text('Export'));
      await tester.pump();
      expect(find.textContaining('No file was created'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Reports link opens the existing Stock tab', (tester) async {
    _phoneSize(tester);
    await _openAnalytics(tester);
    await tester.ensureVisible(find.text('Stock movements').last);
    await tester.tap(find.text('Stock movements').last);
    await tester.pumpAndSettle();
    expect(find.byType(MovementsScreen), findsOneWidget);
    expect(find.text('Stock'), findsOneWidget);
  });
}
