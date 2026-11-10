import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class CategoryFilterChip extends StatelessWidget {
  const CategoryFilterChip({
    super.key,
    required this.label,
    required this.width,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final double width;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: width,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppTheme.primary : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: selected ? null : Border.all(color: AppTheme.border),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppTheme.muted,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
