import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../products/product_detail_screen.dart';
import '../products/products_mock_data.dart';
import '../products/widgets/category_filter_chip.dart';
import 'widgets/inventory_form_components.dart';

enum _AlertFilter { all, critical, warning }

class LowStockAlertsScreen extends StatefulWidget {
  const LowStockAlertsScreen({super.key});

  @override
  State<LowStockAlertsScreen> createState() => _LowStockAlertsScreenState();
}

class _LowStockAlertsScreenState extends State<LowStockAlertsScreen> {
  _AlertFilter _filter = _AlertFilter.all;

  @override
  Widget build(BuildContext context) {
    final allAlerts = ProductsMockData.products
        .where((product) => product.isLowStock)
        .toList(growable: false);
    final products = allAlerts.where(
      (product) => switch (_filter) {
        _AlertFilter.all => true,
        _AlertFilter.critical => product.isCriticalStock,
        _AlertFilter.warning => !product.isCriticalStock,
      },
    );

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
                  const InventoryPageHeader(
                    title: 'Low-stock Alerts',
                    eyebrow: 'INVENTORY HEALTH',
                    subtitle: 'Products approaching reorder thresholds',
                  ),
                  const SizedBox(height: 18),
                  InventoryNotice(
                    title: '${allAlerts.length} products need attention',
                    message: 'Products below reorder threshold should be considered for replenishment.',
                    warning: true,
                  ),
                  const SizedBox(height: 15),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CategoryFilterChip(
                          label: 'All alerts',
                          width: 93,
                          selected: _filter == _AlertFilter.all,
                          onTap: () =>
                              setState(() => _filter = _AlertFilter.all),
                        ),
                        const SizedBox(width: 8),
                        CategoryFilterChip(
                          label: 'Critical',
                          width: 82,
                          selected: _filter == _AlertFilter.critical,
                          onTap: () =>
                              setState(() => _filter = _AlertFilter.critical),
                        ),
                        const SizedBox(width: 8),
                        CategoryFilterChip(
                          label: 'Warning',
                          width: 84,
                          selected: _filter == _AlertFilter.warning,
                          onTap: () =>
                              setState(() => _filter = _AlertFilter.warning),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Text(
                      'Below reorder point',
                      style: AppTheme.sectionTitle,
                    ),
                  ),
                  const SizedBox(height: 13),
                  if (products.isEmpty)
                    _NoAlerts(filtered: _filter != _AlertFilter.all)
                  else
                    for (final product in products) ...[
                      _LowStockTile(
                        product: product,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                ProductDetailScreen(product: product),
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                    ],
                  const SizedBox(height: 7),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Purchase orders will be implemented in a later phase.',
                              ),
                            ),
                          ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Review Purchase Orders'),
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

class _LowStockTile extends StatelessWidget {
  const _LowStockTile({required this.product, required this.onTap});

  final MockProduct product;
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
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: product.isCriticalStock
                      ? AppTheme.dangerBackground
                      : AppTheme.warningBackground,
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.priority_high,
                  color: product.isCriticalStock
                      ? AppTheme.danger
                      : AppTheme.warning,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        color: AppTheme.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '${product.quantity} available · Reorder at ${product.reorderThreshold}',
                      maxLines: 2,
                      style: const TextStyle(
                        color: AppTheme.muted,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                product.isCriticalStock ? 'Critical' : 'Low',
                style: TextStyle(
                  color: product.isCriticalStock
                      ? AppTheme.danger
                      : AppTheme.warning,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoAlerts extends StatelessWidget {
  const _NoAlerts({required this.filtered});

  final bool filtered;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppTheme.primary,
            size: 30,
          ),
          const SizedBox(height: 9),
          Text(
            filtered
                ? 'No alerts in this category.'
                : 'All products have healthy stock levels.',
          ),
        ],
      ),
    );
  }
}
