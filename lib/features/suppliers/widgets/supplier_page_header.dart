import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class SupplierPageHeader extends StatelessWidget {
  const SupplierPageHeader({
    super.key,
    required this.title,
    required this.eyebrow,
    required this.subtitle,
    this.showBack = false,
  });

  final String title;
  final String eyebrow;
  final String subtitle;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (showBack) ...[
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.chevron_left, size: 24),
                color: AppTheme.primary,
                tooltip: 'Back',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 28,
                  height: 28,
                ),
              ),
              const SizedBox(width: 5),
            ],
            Expanded(
              child: Text(
                'STOCKPILOT / $eyebrow',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .7,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.ink,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1.16,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppTheme.muted,
            fontSize: 11,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
