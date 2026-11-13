import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../movements/movement_detail_screen.dart';
import '../movements/movements_mock_data.dart';
import '../movements/widgets/movement_tile.dart';
import '../products/products_mock_data.dart';
import '../products/widgets/category_filter_chip.dart';
import 'export_history_screen.dart';
import 'export_report_screen.dart';
import 'movement_report_data.dart';
import 'widgets/report_components.dart';

class StockMovementReportScreen extends StatefulWidget {
  const StockMovementReportScreen({super.key, this.initialRange});

  /// Optional fixture for focused previews and tests.
  final DateTimeRange? initialRange;

  @override
  State<StockMovementReportScreen> createState() =>
      _StockMovementReportScreenState();
}

class _StockMovementReportScreenState extends State<StockMovementReportScreen> {
  late DateTimeRange _range;
  MovementType? _type;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    final latest = MovementsMockData.movements
        .map(MovementReportData.dateOf)
        .whereType<DateTime>()
        .reduce((a, b) => a.isAfter(b) ? a : b);
    _range =
        widget.initialRange ??
        DateTimeRange(start: DateTime(latest.year, latest.month), end: latest);
  }

  List<MockMovement> get _visibleMovements =>
      MovementsMockData.movements.where((movement) {
        final date = MovementReportData.dateOf(movement);
        return date != null &&
            !date.isBefore(_range.start) &&
            !date.isAfter(_range.end) &&
            (_type == null || movement.type == _type);
      }).toList();

  Future<void> _pickRange() async {
    final selected = await showDateRangePicker(
      context: context,
      initialDateRange: _range,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected == null || !mounted) return;
    setState(() {
      _range = selected;
      _selectedDay = null;
    });
  }

  void _openExport() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExportReportScreen(
          initialReport: ReportExportType.movements,
          initialRange: _range,
          initialFormat: ReportFileFormat.csv,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movements = _visibleMovements;
    final received = movements
        .where((item) => item.type == MovementType.receipt)
        .length;
    final issued = movements
        .where((item) => item.type == MovementType.issue)
        .length;
    final adjusted = movements
        .where((item) => item.type == MovementType.adjustment)
        .length;
    final byProduct = <MockProduct, List<MockMovement>>{};
    for (final movement in movements) {
      byProduct.putIfAbsent(movement.product, () => []).add(movement);
    }
    final products = byProduct.entries.toList()
      ..sort((a, b) {
        final count = b.value.length.compareTo(a.value.length);
        return count != 0 ? count : a.key.name.compareTo(b.key.name);
      });
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
                    title: 'Movement report',
                    subtitle: 'Inventory activity across a date range',
                    eyebrow: 'REPORTS',
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'DATE RANGE',
                    style: TextStyle(
                      color: AppTheme.muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _pickRange,
                    icon: const Icon(Icons.calendar_today_outlined, size: 18),
                    label: Text(
                      '${MovementReportData.dateLabel(_range.start)} – ${MovementReportData.dateLabel(_range.end)}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CategoryFilterChip(
                          label: 'All',
                          width: 53,
                          selected: _type == null,
                          onTap: () => setState(() {
                            _type = null;
                            _selectedDay = null;
                          }),
                        ),
                        const SizedBox(width: 8),
                        CategoryFilterChip(
                          label: 'Receipts',
                          width: 91,
                          selected: _type == MovementType.receipt,
                          onTap: () => setState(() {
                            _type = MovementType.receipt;
                            _selectedDay = null;
                          }),
                        ),
                        const SizedBox(width: 8),
                        CategoryFilterChip(
                          label: 'Issues',
                          width: 71,
                          selected: _type == MovementType.issue,
                          onTap: () => setState(() {
                            _type = MovementType.issue;
                            _selectedDay = null;
                          }),
                        ),
                        const SizedBox(width: 8),
                        CategoryFilterChip(
                          label: 'Adjustments',
                          width: 111,
                          selected: _type == MovementType.adjustment,
                          onTap: () => setState(() {
                            _type = MovementType.adjustment;
                            _selectedDay = null;
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 17),
                  Row(
                    children: [
                      Expanded(
                        child: ReportMetricCard(
                          value: '$received',
                          label: 'Received',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ReportMetricCard(
                          value: '$issued',
                          label: 'Issued',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ReportMetricCard(
                          value: '$adjusted',
                          label: 'Adjusted',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 19),
                  const Text('Movement trends', style: AppTheme.sectionTitle),
                  const SizedBox(height: 7),
                  Text(
                    'Transaction counts · ${movements.length} in range',
                    style: AppTheme.bodySmall.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: movements.isEmpty
                        ? const Text(
                            'No movement trend for this selection.',
                            style: AppTheme.bodySmall,
                          )
                        : _DailyActivityChart(
                            movements: movements,
                            selectedDay: _selectedDay,
                            onSelect: (date) =>
                                setState(() => _selectedDay = date),
                          ),
                  ),
                  const SizedBox(height: 19),
                  const Text('By product', style: AppTheme.sectionTitle),
                  const SizedBox(height: 10),
                  if (products.isEmpty)
                    const Text(
                      'No product activity for this selection.',
                      style: AppTheme.bodySmall,
                    )
                  else
                    for (final entry in products) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppTheme.border),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.key.name,
                                style: const TextStyle(
                                  color: AppTheme.ink,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              '${entry.value.length} ${entry.value.length == 1 ? 'movement' : 'movements'}',
                              style: AppTheme.bodySmall.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  const SizedBox(height: 19),
                  const Text('Movement history', style: AppTheme.sectionTitle),
                  const SizedBox(height: 11),
                  if (movements.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Text(
                        'No transactions match these filters.',
                        textAlign: TextAlign.center,
                        style: AppTheme.bodySmall,
                      ),
                    )
                  else
                    for (final movement in movements) ...[
                      MovementTile(
                        movement: movement,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                MovementDetailScreen(movement: movement),
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                    ],
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton.icon(
                      onPressed: _openExport,
                      icon: const Icon(Icons.file_download_outlined, size: 18),
                      label: const Text('Export CSV'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const ExportHistoryScreen(),
                        ),
                      ),
                      child: const Text('View export history'),
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

class _DailyActivityChart extends StatelessWidget {
  const _DailyActivityChart({
    required this.movements,
    required this.selectedDay,
    required this.onSelect,
  });

  final List<MockMovement> movements;
  final DateTime? selectedDay;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final dates =
        movements
            .map(MovementReportData.dateOf)
            .whereType<DateTime>()
            .toSet()
            .toList()
          ..sort();
    final selected = selectedDay ?? dates.last;
    final selectedItems = movements
        .where((item) => MovementReportData.dateOf(item) == selected)
        .toList();
    return Column(
      children: [
        SizedBox(
          height: 98,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final date in dates)
                Expanded(
                  child: InkWell(
                    onTap: () => onSelect(date),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 78,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              for (final type in MovementType.values) ...[
                                Container(
                                  width: dates.length > 8 ? 5 : 8,
                                  height:
                                      (movements
                                                  .where(
                                                    (item) =>
                                                        MovementReportData.dateOf(
                                                              item,
                                                            ) ==
                                                            date &&
                                                        item.type == type,
                                                  )
                                                  .length *
                                              29)
                                          .toDouble()
                                          .clamp(0, 75),
                                  decoration: BoxDecoration(
                                    color: type.foreground.withValues(
                                      alpha: selected == date ? 1 : .65,
                                    ),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(3),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 2),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${date.day}',
                          style: AppTheme.bodySmall.copyWith(fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${MovementReportData.dateLabel(selected)} · ${selectedItems.length} ${selectedItems.length == 1 ? 'movement' : 'movements'}',
          style: AppTheme.bodySmall.copyWith(fontSize: 10),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final type in MovementType.values) ...[
              Icon(Icons.circle, color: type.foreground, size: 8),
              const SizedBox(width: 3),
              Text(type.label, style: AppTheme.bodySmall.copyWith(fontSize: 9)),
              const SizedBox(width: 10),
            ],
          ],
        ),
      ],
    );
  }
}
