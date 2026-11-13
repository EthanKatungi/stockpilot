import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'export_history_screen.dart';
import 'movement_report_data.dart';
import 'reports_mock_data.dart';
import 'widgets/report_components.dart';

enum ReportExportType { valuation, movements, lowStock }

extension ReportExportTypeLabel on ReportExportType {
  String get label => switch (this) {
    ReportExportType.valuation => 'Inventory valuation',
    ReportExportType.movements => 'Stock movements',
    ReportExportType.lowStock => 'Low-stock report',
  };
}

enum ReportFileFormat { csv, pdf }

extension on ReportFileFormat {
  String get label => switch (this) {
    ReportFileFormat.csv => 'CSV (.csv)',
    ReportFileFormat.pdf => 'PDF (.pdf)',
  };
}

enum _ExportPeriod { week, month, quarter, custom }

extension on _ExportPeriod {
  String get label => switch (this) {
    _ExportPeriod.week => 'Last 7 days',
    _ExportPeriod.month => 'This month',
    _ExportPeriod.quarter => 'Last 90 days',
    _ExportPeriod.custom => 'Selected date range',
  };
}

class ExportReportScreen extends StatefulWidget {
  const ExportReportScreen({
    super.key,
    this.initialReport = ReportExportType.valuation,
    this.initialPeriod = ReportPeriod.month,
    this.initialRange,
    this.initialFormat = ReportFileFormat.csv,
  });

  final ReportExportType initialReport;
  final ReportPeriod initialPeriod;
  final DateTimeRange? initialRange;
  final ReportFileFormat initialFormat;

  @override
  State<ExportReportScreen> createState() => _ExportReportScreenState();
}

class _ExportReportScreenState extends State<ExportReportScreen> {
  final _formKey = GlobalKey<FormState>();
  late ReportExportType _report;
  late _ExportPeriod _period;
  late ReportFileFormat _format;

  @override
  void initState() {
    super.initState();
    _report = widget.initialReport;
    _format = widget.initialFormat;
    _period = widget.initialRange != null
        ? _ExportPeriod.custom
        : switch (widget.initialPeriod) {
            ReportPeriod.week => _ExportPeriod.week,
            ReportPeriod.month => _ExportPeriod.month,
            ReportPeriod.quarter => _ExportPeriod.quarter,
          };
  }

  void _generatePlaceholder() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Generating a ${_format.label} ${_report.label.toLowerCase()} report will be implemented later. No file was created.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
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
                    title: 'Export report',
                    subtitle: 'Choose a format to share',
                    eyebrow: 'EXPORT',
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ReportLabeledField(
                          label: 'REPORT',
                          child: DropdownButtonFormField<ReportExportType>(
                            initialValue: _report,
                            isExpanded: true,
                            decoration: reportInputDecoration(),
                            items: [
                              for (final report in ReportExportType.values)
                                DropdownMenuItem(
                                  value: report,
                                  child: Text(report.label),
                                ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _report = value);
                              }
                            },
                          ),
                        ),
                        ReportLabeledField(
                          label: 'PERIOD',
                          child: DropdownButtonFormField<_ExportPeriod>(
                            initialValue: _period,
                            isExpanded: true,
                            decoration: reportInputDecoration(),
                            items: [
                              for (final period in _ExportPeriod.values)
                                if (period != _ExportPeriod.custom ||
                                    widget.initialRange != null)
                                  DropdownMenuItem(
                                    value: period,
                                    child: Text(period.label),
                                  ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _period = value);
                              }
                            },
                          ),
                        ),
                        if (_period == _ExportPeriod.custom &&
                            widget.initialRange != null) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${MovementReportData.dateLabel(widget.initialRange!.start)} – ${MovementReportData.dateLabel(widget.initialRange!.end)}',
                              style: AppTheme.bodySmall.copyWith(fontSize: 11),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        ReportLabeledField(
                          label: 'FORMAT',
                          child: DropdownButtonFormField<ReportFileFormat>(
                            initialValue: _format,
                            isExpanded: true,
                            decoration: reportInputDecoration(),
                            items: [
                              for (final format in ReportFileFormat.values)
                                DropdownMenuItem(
                                  value: format,
                                  child: Text(format.label),
                                ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _format = value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.mint,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Privacy reminder',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Reports may contain sensitive business information. Review recipients before sharing. This preview creates no file.',
                          style: AppTheme.bodySmall.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 17),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton(
                      onPressed: _generatePlaceholder,
                      child: const Text('Generate report'),
                    ),
                  ),
                  const SizedBox(height: 9),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(height: 7),
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
