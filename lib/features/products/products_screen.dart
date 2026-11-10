import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'add_product_screen.dart';
import 'product_detail_screen.dart';
import 'products_mock_data.dart';
import 'widgets/category_filter_chip.dart';
import 'widgets/product_list_tile.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _query = '';
  ProductCategory? _selectedCategory;

  List<MockProduct> get _visibleProducts {
    final query = _query.trim().toLowerCase();
    return ProductsMockData.products
        .where((product) {
          final matchesCategory =
              _selectedCategory == null ||
              product.category == _selectedCategory;
          final matchesQuery =
              query.isEmpty ||
              product.name.toLowerCase().contains(query) ||
              product.sku.toLowerCase().contains(query);
          return matchesCategory && matchesQuery;
        })
        .toList(growable: false);
  }

  void _selectCategory(ProductCategory? category) {
    setState(() => _selectedCategory = category);
  }

  void _openProduct(MockProduct product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _openAddProduct() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AddProductScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final visibleProducts = _visibleProducts;
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProductsHeader(onAddProduct: _openAddProduct),
                const SizedBox(height: 23),
                _ProductSearchField(
                  onChanged: (value) => setState(() => _query = value),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CategoryFilterChip(
                        label: 'All',
                        width: 53,
                        selected: _selectedCategory == null,
                        onTap: () => _selectCategory(null),
                      ),
                      const SizedBox(width: 9),
                      CategoryFilterChip(
                        label: 'Coffee',
                        width: 81,
                        selected: _selectedCategory == ProductCategory.coffee,
                        onTap: () => _selectCategory(ProductCategory.coffee),
                      ),
                      const SizedBox(width: 8),
                      CategoryFilterChip(
                        label: 'Packaging',
                        width: 103,
                        selected:
                            _selectedCategory == ProductCategory.packaging,
                        onTap: () => _selectCategory(ProductCategory.packaging),
                      ),
                      const SizedBox(width: 9),
                      CategoryFilterChip(
                        label: 'Others',
                        width: 90,
                        selected: _selectedCategory == ProductCategory.others,
                        onTap: () => _selectCategory(ProductCategory.others),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 21),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'All products',
                          style: TextStyle(
                            color: AppTheme.ink,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                      ),
                      Text(
                        'Sort  ↓',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                if (visibleProducts.isEmpty)
                  const _EmptyProducts()
                else
                  for (
                    var index = 0;
                    index < visibleProducts.length;
                    index++
                  ) ...[
                    ProductListTile(
                      product: visibleProducts[index],
                      onTap: () => _openProduct(visibleProducts[index]),
                    ),
                    if (index != visibleProducts.length - 1)
                      const SizedBox(height: 9),
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductsHeader extends StatelessWidget {
  const _ProductsHeader({required this.onAddProduct});

  final VoidCallback onAddProduct;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Products',
                  style: TextStyle(
                    color: AppTheme.ink,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  '${ProductsMockData.products.length} inventory items',
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
        Material(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(13),
          child: InkWell(
            onTap: onAddProduct,
            borderRadius: BorderRadius.circular(13),
            child: const SizedBox(
              width: 42,
              height: 42,
              child: Icon(Icons.add, color: Colors.white, size: 27),
            ),
          ),
        ),
        const SizedBox(width: 1),
      ],
    );
  }
}

class _ProductSearchField extends StatelessWidget {
  const _ProductSearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppTheme.border),
    );
    return SizedBox(
      height: 49,
      child: TextField(
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        autocorrect: false,
        style: const TextStyle(color: AppTheme.ink, fontSize: 13, height: 1.3),
        decoration: InputDecoration(
          hintText: 'Search products or SKUs',
          hintStyle: const TextStyle(
            color: AppTheme.muted,
            fontSize: 13,
            height: 1.3,
          ),
          prefixIcon: const Icon(Icons.search, color: AppTheme.muted, size: 22),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 49,
            minHeight: 49,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          enabledBorder: border,
          focusedBorder: border,
          border: border,
        ),
      ),
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 36),
      child: Center(
        child: Text('No products found', style: AppTheme.bodySmall),
      ),
    );
  }
}
