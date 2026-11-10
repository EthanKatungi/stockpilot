import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'dashboard_mock_data.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, this.onOpenMovements});

  final VoidCallback? onOpenMovements;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 22),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _DashboardHeader(),
                const SizedBox(height: 23),
                const _StockValueCard(),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        value: DashboardMockData.activeProducts,
                        label: 'Active products',
                        background: Colors.white,
                        valueColor: AppTheme.ink,
                      ),
                    ),
                    SizedBox(width: 11),
                    Expanded(
                      child: _MetricCard(
                        value: DashboardMockData.lowStockAlerts,
                        label: 'Low-stock alerts',
                        background: AppTheme.warningBackground,
                        valueColor: AppTheme.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.only(left: 2),
                  child: Text('Quick actions', style: AppTheme.sectionTitle),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: '+  Receive stock',
                        onPressed: onOpenMovements,
                        primary: true,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: _ActionButton(
                        label: '↗  Issue stock',
                        onPressed: onOpenMovements,
                        primary: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 23),
                Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 2),
                        child: Text(
                          'Recent activity',
                          style: AppTheme.sectionTitle,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onOpenMovements,
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        minimumSize: const Size(0, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'View all',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                for (final activity in DashboardMockData.activities) ...[
                  _ActivityRow(activity: activity),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, right: 46),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'STOCKPILOT  /  OVERVIEW',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Good morning, ${DashboardMockData.greetingName}',
                style: TextStyle(
                  color: AppTheme.ink,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 1),
              Text(
                "Here's how your inventory is doing today.",
                style: TextStyle(
                  color: AppTheme.muted,
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 3,
          right: 3,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.border),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.circle, color: AppTheme.primary, size: 8),
          ),
        ),
      ],
    );
  }
}

class _StockValueCard extends StatelessWidget {
  const _StockValueCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 15,
            right: -13,
            child: CircleAvatar(
              radius: 47,
              backgroundColor: AppTheme.primaryDark,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 21, 20, 19),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOTAL STOCK VALUE',
                  style: TextStyle(
                    color: Color(0xFFD9EEDC),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 14),
                const SizedBox(
                  height: 38,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DashboardMockData.stockValue,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 29,
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.north_east, color: Colors.white, size: 13),
                      SizedBox(width: 5),
                      Text(
                        DashboardMockData.growth,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.value,
    required this.label,
    required this.background,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color background;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 103,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 27,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 2,
            style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.onPressed,
    required this.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 49,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: primary ? AppTheme.primary : Colors.white,
          foregroundColor: primary ? Colors.white : AppTheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: primary
                ? BorderSide.none
                : const BorderSide(color: AppTheme.border),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.activity});

  final DashboardActivity activity;

  @override
  Widget build(BuildContext context) {
    final color = activity.incoming ? AppTheme.primary : AppTheme.warning;
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          Container(
            width: 33,
            height: 36,
            decoration: BoxDecoration(
              color: activity.incoming
                  ? AppTheme.mint
                  : AppTheme.warningBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              activity.incoming ? 'IN' : 'OUT',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  activity.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  activity.time,
                  style: AppTheme.bodySmall.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            activity.amount,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(width: 3),
        ],
      ),
    );
  }
}
