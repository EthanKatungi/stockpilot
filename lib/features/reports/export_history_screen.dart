import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'export_history_mock_data.dart';
import 'widgets/report_components.dart';

class ExportHistoryScreen extends StatelessWidget {
  const ExportHistoryScreen({super.key, this.exports});

  final List<MockReportExport>? exports;

  void _placeholder(BuildContext context, String action) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '$action will be implemented in a later phase. No file was created or downloaded.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final records = exports ?? ExportHistoryMockData.exports;
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
                    title: 'Export history',
                    subtitle: 'Previously requested report files',
                    eyebrow: 'REPORTS',
                  ),
                  const SizedBox(height: 18),
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
                          'Sample export history',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'These entries demonstrate the future export workflow. No files have been generated.',
                          style: AppTheme.bodySmall.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${records.length} ${records.length == 1 ? 'export' : 'exports'}',
                    style: AppTheme.sectionTitle,
                  ),
                  const SizedBox(height: 12),
                  if (records.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 30,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppTheme.border),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.folder_open_outlined,
                            size: 32,
                            color: AppTheme.primary,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No exports yet',
                            style: TextStyle(
                              color: AppTheme.ink,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Generated reports will appear here when export functionality is available.',
                            textAlign: TextAlign.center,
                            style: AppTheme.bodySmall,
                          ),
                        ],
                      ),
                    )
                  else
                    for (final record in records) ...[
                      _ExportTile(
                        record: record,
                        onDownload: () =>
                            _placeholder(context, 'Report download'),
                        onRetry: () => _placeholder(context, 'Export retry'),
                      ),
                      const SizedBox(height: 9),
                    ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExportTile extends StatelessWidget {
  const _ExportTile({
    required this.record,
    required this.onDownload,
    required this.onRetry,
  });

  final MockReportExport record;
  final VoidCallback onDownload;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final foreground = switch (record.status) {
      ExportStatus.ready => AppTheme.primary,
      ExportStatus.processing => AppTheme.warning,
      ExportStatus.failed => AppTheme.danger,
    };
    final background = switch (record.status) {
      ExportStatus.ready => AppTheme.mint,
      ExportStatus.processing => AppTheme.warningBackground,
      ExportStatus.failed => AppTheme.dangerBackground,
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  record.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  record.status.label,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            '${record.reportType} · ${record.format}',
            style: AppTheme.bodySmall.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            record.createdAt,
            style: AppTheme.bodySmall.copyWith(fontSize: 10),
          ),
          if (record.status == ExportStatus.ready) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onDownload,
              icon: const Icon(Icons.download_outlined, size: 17),
              label: const Text('Download'),
            ),
          ] else if (record.status == ExportStatus.failed) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 17),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
