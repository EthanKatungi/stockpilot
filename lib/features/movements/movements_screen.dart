import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../products/widgets/category_filter_chip.dart';
import 'low_stock_alerts_screen.dart';
import 'movement_detail_screen.dart';
import 'movement_navigation.dart';
import 'movements_mock_data.dart';
import 'widgets/movement_tile.dart';

class MovementsScreen extends StatefulWidget {
  const MovementsScreen({super.key, this.movements});

  /// An optional display list makes the empty state easy to preview and test.
  final List<MockMovement>? movements;

  @override
  State<MovementsScreen> createState() => _MovementsScreenState();
}

class _MovementsScreenState extends State<MovementsScreen> {
  MovementType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final allMovements = widget.movements ?? MovementsMockData.movements;
    final visibleMovements = allMovements
        .where(
          (movement) => _selectedType == null || movement.type == _selectedType,
        )
        .toList(growable: false);
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'STOCKPILOT / INVENTORY ACTIVITY',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: .7,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Stock Movements',
                              style: TextStyle(
                                color: AppTheme.ink,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                height: 1.16,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'Track every change to your inventory',
                              style: TextStyle(
                                color: AppTheme.muted,
                                fontSize: 11,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const LowStockAlertsScreen(),
                        ),
                      ),
                      tooltip: 'Low-stock alerts',
                      icon: const Icon(Icons.notifications_outlined),
                      color: AppTheme.warning,
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.warningBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        value: MovementsMockData.receivedThisWeek,
                        label: 'Received this week',
                        background: Colors.white,
                        valueColor: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: _SummaryCard(
                        value: MovementsMockData.issuedThisWeek,
                        label: 'Issued this week',
                        background: Colors.white,
                        valueColor: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CategoryFilterChip(
                        label: 'All',
                        width: 53,
                        selected: _selectedType == null,
                        onTap: () => setState(() => _selectedType = null),
                      ),
                      const SizedBox(width: 8),
                      CategoryFilterChip(
                        label: 'Received',
                        width: 90,
                        selected: _selectedType == MovementType.receipt,
                        onTap: () => setState(
                          () => _selectedType = MovementType.receipt,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CategoryFilterChip(
                        label: 'Issued',
                        width: 73,
                        selected: _selectedType == MovementType.issue,
                        onTap: () =>
                            setState(() => _selectedType = MovementType.issue),
                      ),
                      const SizedBox(width: 8),
                      CategoryFilterChip(
                        label: 'Adjustments',
                        width: 105,
                        selected: _selectedType == MovementType.adjustment,
                        onTap: () => setState(
                          () => _selectedType = MovementType.adjustment,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Recent movements',
                        style: AppTheme.sectionTitle,
                      ),
                    ),
                    const Text(
                      'Filter',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                if (visibleMovements.isEmpty)
                  _MovementEmptyState(filtered: _selectedType != null)
                else
                  for (final movement in visibleMovements) ...[
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
                const SizedBox(height: 7),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: FilledButton.icon(
                    onPressed: () => openRecordMovementFlow(context),
                    icon: const Icon(Icons.add, size: 19),
                    label: const Text('Record Movement'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
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
      height: 84,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.bodySmall.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovementEmptyState extends StatelessWidget {
  const _MovementEmptyState({required this.filtered});

  final bool filtered;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 38),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Icon(Icons.swap_horiz, color: AppTheme.primary, size: 30),
          const SizedBox(height: 10),
          Text(
            filtered ? 'No matching movements' : 'No stock movements yet',
            style: const TextStyle(
              color: AppTheme.ink,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            filtered
                ? 'Try another movement type.'
                : 'Record a receipt, issue or adjustment to see it here.',
            textAlign: TextAlign.center,
            style: AppTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
