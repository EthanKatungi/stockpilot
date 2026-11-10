import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../products_mock_data.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({super.key, required this.product});

  final MockProduct product;

  @override
  Widget build(BuildContext context) {
    final (iconBackground, iconColor) = switch (product.category) {
      ProductCategory.coffee => (AppTheme.mint, AppTheme.primary),
      ProductCategory.packaging => (
        AppTheme.packagingBackground,
        AppTheme.packagingInk,
      ),
      ProductCategory.others => (
        AppTheme.commodityBackground,
        AppTheme.commodityInk,
      ),
    };

    return Container(
      constraints: const BoxConstraints(minHeight: 79),
      padding: const EdgeInsets.fromLTRB(11, 14, 14, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              product.initials,
              style: TextStyle(
                color: iconColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${product.categoryLabel} · ${product.sku}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 100,
            height: 48,
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  product.quantity,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
