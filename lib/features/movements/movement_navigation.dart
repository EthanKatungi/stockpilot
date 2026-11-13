import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../products/products_mock_data.dart';
import 'movements_mock_data.dart';
import 'record_stock_movement_screen.dart';
import 'stock_adjustment_screen.dart';
import 'widgets/movement_tile.dart';

Future<void> openRecordMovementFlow(
  BuildContext context, {
  MockProduct? product,
}) async {
  final type = await showModalBottomSheet<MovementType>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Record movement', style: AppTheme.sectionTitle),
          if (product != null) ...[
            const SizedBox(height: 4),
            Text(product.name, style: AppTheme.bodySmall),
          ],
          const SizedBox(height: 14),
          for (final type in MovementType.values)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              leading: MovementTypeBadge(type: type, compact: true),
              title: Text(
                switch (type) {
                  MovementType.receipt => 'Receive stock',
                  MovementType.issue => 'Issue stock',
                  MovementType.adjustment => 'Adjust stock',
                },
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppTheme.muted),
              onTap: () => Navigator.of(sheetContext).pop(type),
            ),
        ],
      ),
    ),
  );

  if (!context.mounted || type == null) return;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => movementFormForType(type, product)),
  );
}

Widget movementFormForType(MovementType type, MockProduct? product) {
  return switch (type) {
    MovementType.receipt => RecordStockReceiptScreen(product: product),
    MovementType.issue => RecordStockIssueScreen(product: product),
    MovementType.adjustment => StockAdjustmentScreen(product: product),
  };
}

void replaceMovementForm(
  BuildContext context,
  MovementType type,
  MockProduct? product,
) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute<void>(builder: (_) => movementFormForType(type, product)),
  );
}
