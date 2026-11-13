import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockpilot/core/theme/app_theme.dart';
import 'package:stockpilot/features/movements/movement_detail_screen.dart';
import 'package:stockpilot/features/movements/movements_mock_data.dart';
import 'package:stockpilot/features/movements/widgets/movement_tile.dart';
import 'package:stockpilot/features/reports/export_history_screen.dart';
import 'package:stockpilot/features/reports/export_report_screen.dart';
import 'package:stockpilot/features/reports/movement_report_data.dart';
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
  test('movement report dates use the existing mock records', () {
    expect(
      MovementReportData.dateOf(MovementsMockData.movements.first),
      DateTime(2026, 11, 11),
    );
    expect(
      MovementReportData.dateOf(MovementsMockData.movements[4]),
      DateTime(2026, 11, 9),
    );
  });

  testWidgets('R03 applies date and type filters, then opens a transaction', (
    tester,
  ) async {
    _phoneSize(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: StockMovementReportScreen(
          initialRange: DateTimeRange(
            start: DateTime(2026, 11, 10),
            end: DateTime(2026, 11, 11),
          ),
        ),
      ),
    );
    expect(find.textContaining('2 in range'), findsOneWidget);
    expect(find.byType(MovementTile), findsNWidgets(2));
    await tester.tap(find.byIcon(Icons.calendar_today_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(DateRangePickerDialog), findsOneWidget);
    Navigator.of(tester.element(find.byType(DateRangePickerDialog))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Receipts'));
    await tester.pumpAndSettle();
    expect(find.textContaining('1 in range'), findsOneWidget);
    expect(find.byType(MovementTile), findsOneWidget);
    expect(find.text('Packaging Bags'), findsNothing);

    await tester.tap(find.byType(MovementTile));
    await tester.pumpAndSettle();
    expect(find.byType(MovementDetailScreen), findsOneWidget);
    expect(find.textContaining('MOV-1042'), findsWidgets);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(StockMovementReportScreen), findsOneWidget);

    await tester.tap(find.text('Adjustments'));
    await tester.pumpAndSettle();
    expect(find.text('No transactions match these filters.'), findsOneWidget);

    await tester.ensureVisible(find.text('Export CSV'));
    await tester.tap(find.text('Export CSV'));
    await tester.pumpAndSettle();
    expect(find.byType(ExportReportScreen), findsOneWidget);
    expect(find.text('Stock movements'), findsOneWidget);
    expect(find.text('10 Nov 2026 – 11 Nov 2026'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Analytics opens R03 and export history', (tester) async {
    _phoneSize(tester);
    await _openAnalytics(tester);
    await tester.ensureVisible(find.text('Stock movements').last);
    await tester.tap(find.text('Stock movements').last);
    await tester.pumpAndSettle();
    expect(find.byType(StockMovementReportScreen), findsOneWidget);
    await tester.ensureVisible(find.text('View export history'));
    await tester.tap(find.text('View export history'));
    await tester.pumpAndSettle();
    expect(find.byType(ExportHistoryScreen), findsOneWidget);
    expect(find.text('stock_valuation_2026-11.csv'), findsOneWidget);
    expect(find.text('Ready'), findsNWidgets(2));
    expect(find.text('Processing'), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);

    await tester.ensureVisible(find.text('Download').first);
    await tester.tap(find.text('Download').first);
    await tester.pump();
    expect(
      find.textContaining('No file was created or downloaded'),
      findsOneWidget,
    );
    await tester.ensureVisible(find.text('Retry'));
    await tester.tap(find.text('Retry'));
    await tester.pump();
    expect(
      find.textContaining('No file was created or downloaded'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Export history has an empty state', (tester) async {
    _phoneSize(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const ExportHistoryScreen(exports: []),
      ),
    );
    expect(find.text('No exports yet'), findsOneWidget);
    expect(find.text('0 exports'), findsOneWidget);
    expect(find.text('Download'), findsNothing);
  });
}
