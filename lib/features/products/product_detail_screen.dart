import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../movements/movement_navigation.dart';
import 'products_mock_data.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final MockProduct product;

  void _showComingSoon(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 7, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 44,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.chevron_left, size: 30),
                          color: AppTheme.ink,
                          tooltip: 'Back to products',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                            width: 32,
                            height: 42,
                          ),
                        ),
                        const SizedBox(width: 18),
                        const Expanded(
                          child: Text(
                            'Product details',
                            style: TextStyle(
                              color: AppTheme.ink,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          tooltip: 'Product options',
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.more_horiz,
                            color: AppTheme.ink,
                            size: 25,
                          ),
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showComingSoon(
                                context,
                                'Product editing will be implemented in Module 2.',
                              );
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit product'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 13),
                  const _ProductIllustration(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        color: AppTheme.ink,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      children: [
                        Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            product.categoryLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'SKU: ${product.sku}',
                            textAlign: TextAlign.right,
                            style: AppTheme.bodySmall.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  _StockSummary(product: product),
                  const SizedBox(height: 23),
                  const Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Text(
                      'Inventory details',
                      style: AppTheme.sectionTitle,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      children: [
                        _DetailRow(
                          label: 'Category',
                          value: product.categoryLabel,
                        ),
                        _DetailRow(
                          label: 'Unit of measure',
                          value: product.unitOfMeasure,
                        ),
                        _DetailRow(
                          label: 'Reorder threshold',
                          value: product.reorderThreshold,
                        ),
                        _DetailRow(
                          label: 'Stock value',
                          value: product.stockValue,
                          divider: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    height: 43,
                    child: FilledButton(
                      onPressed: () =>
                          openRecordMovementFlow(context, product: product),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Record stock movement',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

class _ProductIllustration extends StatelessWidget {
  const _ProductIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: AppTheme.mint,
        borderRadius: BorderRadius.circular(17),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 93,
        height: 77,
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 61,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFD9EEDC),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.inventory_2_outlined,
            color: AppTheme.primary,
            size: 40,
          ),
        ),
      ),
    );
  }
}

class _StockSummary extends StatelessWidget {
  const _StockSummary({required this.product});

  final MockProduct product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 126,
      padding: const EdgeInsets.fromLTRB(18, 17, 18, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CURRENT STOCK',
            style: TextStyle(
              color: AppTheme.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.quantity,
            style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 31,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const Spacer(),
          Text(
            'Average unit cost  ·  ${product.averageUnitCost} / ${product.unitSymbol}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
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
        SizedBox(
          height: 31,
          child: Row(
            children: [
              Expanded(child: Text(label, style: AppTheme.bodySmall)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
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
