import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../movements_mock_data.dart';

extension MovementTypePresentation on MovementType {
  String get label => switch (this) {
    MovementType.receipt => 'Received',
    MovementType.issue => 'Issued',
    MovementType.adjustment => 'Adjustment',
  };

  IconData get icon => switch (this) {
    MovementType.receipt => Icons.north_east,
    MovementType.issue => Icons.south_west,
    MovementType.adjustment => Icons.priority_high,
  };

  Color get foreground => switch (this) {
    MovementType.receipt => AppTheme.primary,
    MovementType.issue => AppTheme.warning,
    MovementType.adjustment => AppTheme.danger,
  };

  Color get background => switch (this) {
    MovementType.receipt => AppTheme.mint,
    MovementType.issue => AppTheme.warningBackground,
    MovementType.adjustment => AppTheme.dangerBackground,
  };
}

class MovementTypeBadge extends StatelessWidget {
  const MovementTypeBadge({
    super.key,
    required this.type,
    this.compact = false,
  });

  final MovementType type;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: type.background,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(type.icon, color: type.foreground, size: 21),
      );
    }

    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: type.background,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        type.label,
        style: TextStyle(
          color: type.foreground,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class MovementTile extends StatelessWidget {
  const MovementTile({super.key, required this.movement, required this.onTap});

  final MockMovement movement;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 78),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              MovementTypeBadge(type: movement.type, compact: true),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movement.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${movement.dateLabel} · ${movement.type.label} #${movement.id}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.bodySmall.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                movement.quantity,
                style: TextStyle(
                  color: movement.type.foreground,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
