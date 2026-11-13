enum ExportStatus { ready, processing, failed }

extension ExportStatusLabel on ExportStatus {
  String get label => switch (this) {
    ExportStatus.ready => 'Ready',
    ExportStatus.processing => 'Processing',
    ExportStatus.failed => 'Failed',
  };
}

class MockReportExport {
  const MockReportExport({
    required this.fileName,
    required this.reportType,
    required this.createdAt,
    required this.format,
    required this.status,
  });

  final String fileName;
  final String reportType;
  final String createdAt;
  final String format;
  final ExportStatus status;
}

/// Fictional examples only. No report file exists for these rows.
class ExportHistoryMockData {
  static const exports = <MockReportExport>[
    MockReportExport(
      fileName: 'stock_valuation_2026-11.csv',
      reportType: 'Stock valuation',
      createdAt: '11 Nov 2026 · 10:42',
      format: 'CSV',
      status: ExportStatus.ready,
    ),
    MockReportExport(
      fileName: 'movement_report_2026-11.pdf',
      reportType: 'Stock movements',
      createdAt: '10 Nov 2026 · 15:18',
      format: 'PDF',
      status: ExportStatus.ready,
    ),
    MockReportExport(
      fileName: 'low_stock_2026-11.csv',
      reportType: 'Low-stock report',
      createdAt: '09 Nov 2026 · 09:05',
      format: 'CSV',
      status: ExportStatus.processing,
    ),
    MockReportExport(
      fileName: 'movement_report_2026-10.csv',
      reportType: 'Stock movements',
      createdAt: '31 Oct 2026 · 16:25',
      format: 'CSV',
      status: ExportStatus.failed,
    ),
  ];
}
