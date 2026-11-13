import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../products/products_mock_data.dart';
import '../products/widgets/category_filter_chip.dart';
import 'purchase_order_draft.dart';
import 'widgets/purchase_order_components.dart';

class AddOrderItemsScreen extends StatefulWidget {
  const AddOrderItemsScreen({super.key, required this.draft});

  final PurchaseOrderDraft draft;

  @override
  State<AddOrderItemsScreen> createState() => _AddOrderItemsScreenState();
}

class _AddOrderItemsScreenState extends State<AddOrderItemsScreen> {
  Future<void> _addItem() async {
    final line = await showModalBottomSheet<DraftOrderLine>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: AppTheme.background,
      builder: (_) => _AddItemSheet(currency: widget.draft.currency),
    );
    if (!mounted || line == null) return;
    setState(() => widget.draft.items.add(line));
  }

  void _saveDraft() {
    final message = widget.draft.items.isEmpty
        ? 'Add at least one item before saving a draft.'
        : 'Saving purchase order drafts will be implemented in a later phase. Nothing was saved.';
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 26),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PurchaseOrderHeader(
                    title: 'Add Order Items',
                    subtitle: 'Step 2 of 2: Add quantities and pricing',
                    eyebrow: 'PURCHASING FORM',
                    showBack: true,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      CategoryFilterChip(
                        label: '1 · Order',
                        width: 96,
                        selected: false,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      CategoryFilterChip(
                        label: '2 · Items',
                        width: 91,
                        selected: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.business_outlined,
                          color: AppTheme.primary,
                          size: 19,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            draft.supplier?.businessName ??
                                'No supplier selected',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Order line items',
                          style: AppTheme.sectionTitle,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _addItem,
                        icon: const Icon(Icons.add, size: 17),
                        label: const Text('Add item'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (draft.items.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppTheme.border),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.add_box_outlined,
                            color: AppTheme.primary,
                            size: 29,
                          ),
                          SizedBox(height: 9),
                          Text(
                            'No items added yet',
                            style: TextStyle(
                              color: AppTheme.ink,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Add a product, quantity and unit price to build this order.',
                            textAlign: TextAlign.center,
                            style: AppTheme.bodySmall,
                          ),
                        ],
                      ),
                    )
                  else
                    for (final (index, item) in draft.items.indexed) ...[
                      _DraftLineTile(
                        line: item,
                        currency: draft.currency,
                        onRemove: () =>
                            setState(() => draft.items.removeAt(index)),
                      ),
                      const SizedBox(height: 9),
                    ],
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 21,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ESTIMATED ORDER TOTAL',
                          style: TextStyle(
                            color: Color(0xFFD7EBDD),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .7,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${draft.currency} ${formatOrderNumber(draft.total)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${draft.items.length} ${draft.items.length == 1 ? 'product' : 'products'} · Local preview',
                          style: const TextStyle(
                            color: Color(0xFFD4F4DF),
                            fontSize: 11,
                          ),
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
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 61,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 1),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppTheme.border)),
          ),
          child: FilledButton(
            onPressed: _saveDraft,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save Purchase Order Draft'),
          ),
        ),
      ),
    );
  }
}

class _DraftLineTile extends StatelessWidget {
  const _DraftLineTile({
    required this.line,
    required this.currency,
    required this.onRemove,
  });

  final DraftOrderLine line;
  final String currency;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
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
              line.product.name[0],
              style: const TextStyle(
                color: AppTheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${formatOrderNumber(line.quantity)} ${line.product.unitSymbol} × $currency ${formatOrderNumber(line.unitPrice, showFraction: line.unitPrice != line.unitPrice.truncateToDouble())}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.bodySmall.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            formatOrderNumber(line.subtotal),
            style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            onPressed: onRemove,
            tooltip: 'Remove ${line.product.name}',
            icon: const Icon(Icons.close, size: 18),
            color: AppTheme.muted,
            constraints: const BoxConstraints.tightFor(width: 31, height: 40),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _AddItemSheet extends StatefulWidget {
  const _AddItemSheet({required this.currency});

  final String currency;

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  MockProduct? _product;

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _add() {
    if (!_formKey.currentState!.validate()) return;
    final quantity = double.parse(_quantityController.text.replaceAll(',', ''));
    final unitPrice = double.parse(_priceController.text.replaceAll(',', ''));
    Navigator.of(context).pop(
      DraftOrderLine(
        product: _product!,
        quantity: quantity,
        unitPrice: unitPrice,
      ),
    );
  }

  String? _positiveNumber(String? value) {
    final number = double.tryParse((value ?? '').replaceAll(',', ''));
    return number == null || !number.isFinite || number <= 0
        ? 'Enter a number greater than zero'
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 26),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add order item', style: AppTheme.sectionTitle),
              const SizedBox(height: 18),
              PurchaseOrderLabeledField(
                label: 'PRODUCT',
                child: DropdownButtonFormField<MockProduct>(
                  initialValue: _product,
                  isExpanded: true,
                  decoration: purchaseOrderInputDecoration(
                    hint: 'Select a product',
                  ),
                  style: purchaseOrderInputStyle,
                  items: [
                    for (final product in ProductsMockData.products)
                      DropdownMenuItem(
                        value: product,
                        child: Text(
                          '${product.name} · ${product.sku}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (product) => setState(() => _product = product),
                  validator: (product) =>
                      product == null ? 'Select a product' : null,
                ),
              ),
              PurchaseOrderLabeledField(
                label: _product == null
                    ? 'QUANTITY'
                    : 'QUANTITY (${_product!.unitSymbol})',
                child: TextFormField(
                  controller: _quantityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  style: purchaseOrderInputStyle,
                  decoration: purchaseOrderInputDecoration(hint: 'e.g. 2,000'),
                  validator: _positiveNumber,
                ),
              ),
              PurchaseOrderLabeledField(
                label: 'UNIT PRICE (${widget.currency})',
                child: TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  style: purchaseOrderInputStyle,
                  decoration: purchaseOrderInputDecoration(hint: 'e.g. 8,750'),
                  validator: _positiveNumber,
                ),
              ),
              const SizedBox(height: 7),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: FilledButton(
                  onPressed: _add,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add to Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
