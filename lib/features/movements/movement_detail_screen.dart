import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'movements_mock_data.dart';
import 'widgets/inventory_form_components.dart';
import 'widgets/movement_tile.dart';

class MovementDetailScreen extends StatelessWidget {
  const MovementDetailScreen({super.key, required this.movement});

  final MockMovement movement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 7, 20, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InventoryPageHeader(
                    title: 'Movement Details',
                    eyebrow: 'ACTIVITY RECORD',
                    subtitle:
                        'Movement #${movement.id} · Recorded ${movement.dateLabel.toLowerCase()}',
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 22,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: movement.type == MovementType.receipt
                            ? const [AppTheme.primary, AppTheme.primaryLight]
                            : movement.type == MovementType.issue
                            ? const [Color(0xFF9D641B), AppTheme.warning]
                            : const [AppTheme.dangerDark, AppTheme.danger],
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          switch (movement.type) {
                            MovementType.receipt => 'STOCK RECEIVED',
                            MovementType.issue => 'STOCK ISSUED',
                            MovementType.adjustment => 'STOCK ADJUSTMENT',
                          },
                          style: const TextStyle(
                            color: Color(0xFFD7EBDD),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .7,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          movement.quantity,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            height: 1.16,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          'Movement ${movement.id} · Demo record',
                          style: const TextStyle(
                            color: Color(0xFFD4F4DF),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 17),
                  const Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Text(
                      'Movement information',
                      style: AppTheme.sectionTitle,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppTheme.border),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        _InformationRow(
                          label: 'Product',
                          value: movement.product.name,
                        ),
                        _InformationRow(
                          label: 'Type',
                          value: movement.type.label,
                        ),
                        _InformationRow(
                          label: 'Quantity',
                          value: movement.quantity,
                        ),
                        _InformationRow(
                          label: 'Reference',
                          value: movement.reference,
                        ),
                        _InformationRow(
                          label: 'Date',
                          value: movement.occurredAt,
                        ),
                        _InformationRow(
                          label: 'Recorded by',
                          value: movement.recordedBy,
                        ),
                        _InformationRow(
                          label: 'Previous stock',
                          value: movement.previousStock,
                        ),
                        _InformationRow(
                          label: 'New stock',
                          value: movement.newStock,
                          divider: false,
                        ),
                      ],
                    ),
                  ),
                  if (movement.notes.isNotEmpty) ...[
                    const SizedBox(height: 22),
                    const Padding(
                      padding: EdgeInsets.only(left: 2),
                      child: Text('Notes', style: AppTheme.sectionTitle),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.mint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        movement.notes,
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: AppTheme.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Done'),
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

class _InformationRow extends StatelessWidget {
  const _InformationRow({
    required this.label,
    required this.value,
    this.divider = true,
  });

  final String label;
  final String value;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            children: [
              Expanded(child: Text(label, style: AppTheme.bodySmall)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppTheme.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (divider)
          const Divider(height: 1, thickness: 1, color: AppTheme.border),
      ],
    );
  }
}
