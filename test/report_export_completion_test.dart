import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockpilot/features/movements/low_stock_alerts_screen.dart';
import 'package:stockpilot/features/reports/analytics_dashboard_screen.dart';
import 'package:stockpilot/features/reports/export_history_screen.dart';
import 'package:stockpilot/features/reports/export_report_screen.dart';
import 'package:stockpilot/features/reports/reports_mock_data.dart';
import 'package:stockpilot/features/reports/stock_movement_report_screen.dart';
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
  testWidgets('R01 period carries into R03 and R05', (tester) async {
    _phoneSize(tester);
    await _openAnalytics(tester);
    expect(find.byType(AnalyticsDashboardScreen), findsOneWidget);
    await tester.tap(find.byType(DropdownButton<ReportPeriod>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('7 days').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Stock movements').last);
    await tester.tap(find.text('Stock movements').last);
    await tester.pumpAndSettle();
    expect(find.byType(StockMovementReportScreen), findsOneWidget);
    expect(find.text('5 Nov 2026 – 11 Nov 2026'), findsOneWidget);
    Navigator.of(tester.element(find.byType(StockMovementReportScreen))).pop();
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Export report'));
    await tester.tap(find.text('Export report'));
    await tester.pumpAndSettle();
    expect(find.byType(ExportReportScreen), findsOneWidget);
    expect(find.text('Last 7 days'), findsOneWidget);
    expect(find.text('Inventory valuation'), findsOneWidget);
    expect(find.text('CSV (.csv)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('R05 changes format, explains no export, and opens history', (
    tester,
  ) async {
    _phoneSize(tester);
    await _openAnalytics(tester);
    await tester.ensureVisible(find.text('Export report'));
    await tester.tap(find.text('Export report'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('CSV (.csv)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PDF (.pdf)').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Generate report'));
    await tester.pump();
    expect(find.textContaining('No file was created'), findsOneWidget);
    await tester.ensureVisible(find.text('View export history'));
    await tester.tap(find.text('View export history'));
    await tester.pumpAndSettle();
    expect(find.byType(ExportHistoryScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('R04 uses the existing low-stock screen', (tester) async {
    _phoneSize(tester);
    await _openAnalytics(tester);
    await tester.ensureVisible(find.text('Low-stock report'));
    await tester.tap(find.text('Low-stock report'));
    await tester.pumpAndSettle();
    expect(find.byType(LowStockAlertsScreen), findsOneWidget);
    expect(find.text('Low-stock Alerts'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
