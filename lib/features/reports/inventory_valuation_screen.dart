import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../products/product_detail_screen.dart';
import '../products/products_mock_data.dart';
import '../products/widgets/category_filter_chip.dart';
import 'export_report_screen.dart';
import 'reports_mock_data.dart';
import 'widgets/report_components.dart';

enum _ValuationSort { highest, lowest, name }

extension on _ValuationSort {
  String get label => switch (this) {
    _ValuationSort.highest => 'Highest value',
    _ValuationSort.lowest => 'Lowest value',
    _ValuationSort.name => 'Product name',
  };
}

class InventoryValuationScreen extends StatefulWidget {
  const InventoryValuationScreen({super.key});

  @override
  State<InventoryValuationScreen> createState() =>
      _InventoryValuationScreenState();
}

class _InventoryValuationScreenState extends State<InventoryValuationScreen> {
  ProductCategory? _category;
  _ValuationSort _sort = _ValuationSort.highest;
  String _query = '';

  List<MockProduct> get _visibleProducts {
    final products = ProductsMockData.products.where((product) {
      final matchesCategory =
          _category == null || product.category == _category;
      final matchesQuery =
          product.name.toLowerCase().contains(_query) ||
          product.sku.toLowerCase().contains(_query);
      return matchesCategory && matchesQuery;
    }).toList();
    switch (_sort) {
      case _ValuationSort.highest:
        products.sort(
          (a, b) =>
              ReportsMockData.valueOf(b).compareTo(ReportsMockData.valueOf(a)),
        );
      case _ValuationSort.lowest:
        products.sort(
          (a, b) =>
              ReportsMockData.valueOf(a).compareTo(ReportsMockData.valueOf(b)),
        );
      case _ValuationSort.name:
        products.sort((a, b) => a.name.compareTo(b.name));
    }
    return products;
  }

  void _openExport() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            const ExportReportScreen(initialReport: ReportExportType.valuation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleProducts;
    final total = ReportsMockData.totalValue(visible);
    final allTotal = ReportsMockData.totalValue(ProductsMockData.products);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ReportHeader(
                    title: 'Stock valuation',
                    subtitle: 'Inventory values by product and category',
                    eyebrow: 'REPORTS',
                  ),
                  const SizedBox(height: 18),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CategoryFilterChip(
                          label: 'All',
                          width: 53,
                          selected: _category == null,
                          onTap: () => setState(() => _category = null),
                        ),
                        const SizedBox(width: 8),
                        CategoryFilterChip(
                          label: 'Coffee',
                          width: 75,
                          selected: _category == ProductCategory.coffee,
                          onTap: () => setState(
                            () => _category = ProductCategory.coffee,
                          ),
                        ),
                        const SizedBox(width: 8),
                        CategoryFilterChip(
                          label: 'Packaging',
                          width: 101,
                          selected: _category == ProductCategory.packaging,
                          onTap: () => setState(
                            () => _category = ProductCategory.packaging,
                          ),
                        ),
                        const SizedBox(width: 8),
                        CategoryFilterChip(
                          label: 'Other',
                          width: 72,
                          selected: _category == ProductCategory.others,
                          onTap: () => setState(
                            () => _category = ProductCategory.others,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 17),
                  Row(
                    children: [
                      Expanded(
                        child: ReportMetricCard(
                          value: ReportsMockData.formatUgx(
                            total,
                            compact: true,
                          ),
                          label: 'Total value',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ReportMetricCard(
                          value: '${visible.length}',
                          label: 'Products',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Exact valuation: ${ReportsMockData.formatUgx(total)}',
                    style: AppTheme.bodySmall.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 19),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Products by value',
                          style: AppTheme.sectionTitle,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _openExport,
                        icon: const Icon(
                          Icons.file_download_outlined,
                          size: 17,
                        ),
                        label: const Text('Export'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: (value) =>
                        setState(() => _query = value.trim().toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Search products or SKU',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppTheme.muted,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: const BorderSide(color: AppTheme.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: const BorderSide(color: AppTheme.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: DropdownButton<_ValuationSort>(
                      value: _sort,
                      underline: const SizedBox.shrink(),
                      items: [
                        for (final sort in _ValuationSort.values)
                          DropdownMenuItem(
                            value: sort,
                            child: Text(sort.label),
                          ),
                      ],
                      onChanged: (sort) {
                        if (sort != null) setState(() => _sort = sort);
                      },
                    ),
                  ),
                  if (visible.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Text(
                        'No products match these filters.',
                        textAlign: TextAlign.center,
                        style: AppTheme.bodySmall,
                      ),
                    )
                  else
                    for (final product in visible) ...[
                      _ValuationProductTile(
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
                  const SizedBox(height: 17),
                  const Text(
                    'Category breakdown',
                    style: AppTheme.sectionTitle,
                  ),
                  Text(
                    'All products',
                    style: AppTheme.bodySmall.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 11),
                  for (final category in ProductCategory.values) ...[
                    _CategoryValueBar(category: category, allTotal: allTotal),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.mint,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Calculation method',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Shown values come from fictional product records. Define a valuation method before using production data.',
                          style: AppTheme.bodySmall.copyWith(fontSize: 11),
                        ),
                      ],
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

class _ValuationProductTile extends StatelessWidget {
  const _ValuationProductTile({required this.product, required this.onTap});

  final MockProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(13),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppTheme.mint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                product.name[0],
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 11),
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
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${product.quantity} × ${product.averageUnitCost}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.bodySmall.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              ReportsMockData.formatUgx(
                ReportsMockData.valueOf(product),
                compact: true,
              ),
              style: const TextStyle(
                color: AppTheme.primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _CategoryValueBar extends StatelessWidget {
  const _CategoryValueBar({required this.category, required this.allTotal});

  final ProductCategory category;
  final int allTotal;

  @override
  Widget build(BuildContext context) {
    final products = ProductsMockData.products.where(
      (product) => product.category == category,
    );
    final value = ReportsMockData.totalValue(products);
    final label = switch (category) {
      ProductCategory.coffee => 'Coffee',
      ProductCategory.packaging => 'Packaging',
      ProductCategory.others => 'Other',
    };
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              ReportsMockData.formatUgx(value, compact: true),
              style: AppTheme.bodySmall.copyWith(fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: allTotal == 0 ? 0 : value / allTotal,
          minHeight: 7,
          borderRadius: BorderRadius.circular(5),
          color: AppTheme.primary,
          backgroundColor: AppTheme.mint,
        ),
      ],
    );
  }
}
