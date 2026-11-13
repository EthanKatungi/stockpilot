import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../movements/low_stock_alerts_screen.dart';
import '../movements/movements_screen.dart';
import '../movements/movements_mock_data.dart';
import '../products/products_mock_data.dart';
import 'export_report_screen.dart';
import 'inventory_valuation_screen.dart';
import 'export_history_screen.dart';
import 'movement_report_data.dart';
import 'reports_mock_data.dart';
import 'stock_movement_report_screen.dart';
import 'widgets/report_charts.dart';
import 'widgets/report_components.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key, this.onOpenMovements});

  final VoidCallback? onOpenMovements;

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  ReportPeriod _period = ReportPeriod.month;
  int _selectedIndex = 0;

  DateTimeRange _movementRange() {
    final latest = MovementsMockData.movements
        .map(MovementReportData.dateOf)
        .whereType<DateTime>()
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final days = switch (_period) {
      ReportPeriod.week => 7,
      ReportPeriod.month => 30,
      ReportPeriod.quarter => 90,
    };
    return DateTimeRange(
      start: latest.subtract(Duration(days: days - 1)),
      end: latest,
    );
  }

  void _openMovements() {
    if (widget.onOpenMovements != null) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      widget.onOpenMovements!();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: MovementsScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final points = ReportsMockData.trends[_period]!;
    final movementSummary = ReportsMockData.movementSummaries[_period]!;
    final stockValue = ReportsMockData.totalValue(ProductsMockData.products);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ReportHeader(
                    title: 'Reports overview',
                    subtitle: 'Performance snapshot across your inventory',
                    eyebrow: 'ANALYTICS',
                  ),
                  const SizedBox(height: 19),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Date range', style: AppTheme.sectionTitle),
                      ),
                      DropdownButton<ReportPeriod>(
                        value: _period,
                        underline: const SizedBox.shrink(),
                        items: [
                          for (final period in ReportPeriod.values)
                            DropdownMenuItem(
                              value: period,
                              child: Text(period.label),
                            ),
                        ],
                        onChanged: (period) {
                          if (period != null) {
                            setState(() {
                              _period = period;
                              _selectedIndex = 0;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 11),
                  Row(
                    children: [
                      Expanded(
                        child: ReportMetricCard(
                          value: ReportsMockData.formatUgx(
                            stockValue,
                            compact: true,
                          ),
                          label: 'Stock value',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ReportMetricCard(
                          value: movementSummary.received,
                          label: 'Stock received',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ReportMetricCard(
                    value: movementSummary.issued,
                    label: 'Stock issued',
                  ),
                  const SizedBox(height: 20),
                  const Text('Inventory trend', style: AppTheme.sectionTitle),
                  const SizedBox(height: 5),
                  Text(
                    '${_period.label} · Illustrative value index',
                    style: AppTheme.bodySmall.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 16, 15, 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        InventoryTrendChart(
                          points: points,
                          selectedIndex: _selectedIndex,
                          onSelect: (index) =>
                              setState(() => _selectedIndex = index),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          '${points[_selectedIndex].label} · Trend index ${points[_selectedIndex].stockIndex.toInt()}',
                          style: AppTheme.bodySmall.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Stock movements', style: AppTheme.sectionTitle),
                  const SizedBox(height: 5),
                  Text(
                    '${_period.label} · Relative activity',
                    style: AppTheme.bodySmall.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 11),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 13, 10, 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        MovementBarsChart(
                          points: points,
                          selectedIndex: _selectedIndex,
                          onSelect: (index) =>
                              setState(() => _selectedIndex = index),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.circle,
                              size: 9,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Received',
                              style: AppTheme.bodySmall.copyWith(fontSize: 10),
                            ),
                            const SizedBox(width: 14),
                            const Icon(
                              Icons.circle,
                              size: 9,
                              color: AppTheme.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Issued',
                              style: AppTheme.bodySmall.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Reports library', style: AppTheme.sectionTitle),
                  const SizedBox(height: 12),
                  ReportDestinationTile(
                    title: 'Stock valuation',
                    subtitle: 'Cost-based inventory value',
                    icon: Icons.account_balance_wallet_outlined,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const InventoryValuationScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  ReportDestinationTile(
                    title: 'Stock movements',
                    subtitle: 'Receipts, issues and adjustments',
                    icon: Icons.swap_horiz,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => StockMovementReportScreen(
                          initialRange: _movementRange(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  ReportDestinationTile(
                    title: 'Low-stock report',
                    subtitle: 'Items below reorder point',
                    icon: Icons.warning_amber_outlined,
                    warning: true,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const LowStockAlertsScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  ReportDestinationTile(
                    title: 'Export history',
                    subtitle: 'Past report file requests',
                    icon: Icons.history,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ExportHistoryScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  ReportDestinationTile(
                    title: 'Export report',
                    subtitle: 'Choose a report and file format',
                    icon: Icons.file_download_outlined,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ExportReportScreen(initialPeriod: _period),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: _openMovements,
                      child: const Text('Open Stock tab'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
