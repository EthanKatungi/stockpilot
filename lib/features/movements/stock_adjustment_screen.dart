import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../products/products_mock_data.dart';
import 'movement_navigation.dart';
import 'movements_mock_data.dart';
import 'widgets/inventory_form_components.dart';

class StockAdjustmentScreen extends StatefulWidget {
  const StockAdjustmentScreen({super.key, this.product});

  final MockProduct? product;

  @override
  State<StockAdjustmentScreen> createState() => _StockAdjustmentScreenState();
}

class _StockAdjustmentScreenState extends State<StockAdjustmentScreen> {
  final _formKey = GlobalKey<FormState>();
  MockProduct? _selectedProduct;

  @override
  void initState() {
    super.initState();
    _selectedProduct = widget.product;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Stock adjustments will be implemented in Module 2.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return InventoryFormScaffold(
      title: 'Stock Adjustment',
      subtitle: 'Correct quantity discrepancies',
      eyebrow: 'STOCK ADJUSTMENT',
      formKey: _formKey,
      actionLabel: 'Save Adjustment',
      onSubmit: _submit,
      topContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InventoryMovementTabs(
            selected: MovementType.adjustment,
            onSelected: (type) {
              if (type != MovementType.adjustment) {
                replaceMovementForm(context, type, _selectedProduct);
              }
            },
          ),
          const SizedBox(height: 14),
          const InventoryNotice(
            title: 'Audited stock correction',
            message: 'Record both counted quantity and reason to preserve your history. This preview does not save a movement.',
            warning: true,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InventoryLabeledControl(
            label: 'PRODUCT',
            child: InventoryProductSelector(
              selected: _selectedProduct,
              onChanged: (product) =>
                  setState(() => _selectedProduct = product),
            ),
          ),
          const SizedBox(height: 16),
          InventoryLabeledControl(
            label: 'SYSTEM QUANTITY',
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 47),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                _selectedProduct?.quantity ?? 'Select a product above',
                style: TextStyle(
                  color: _selectedProduct == null
                      ? AppTheme.muted
                      : AppTheme.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          InventoryLabeledControl(
            label: 'COUNTED QUANTITY',
            child: TextFormField(
              style: inventoryInputStyle,
              decoration: inventoryInputDecoration(
                hint: 'Enter the physical count',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              validator: (value) {
                final count = num.tryParse((value ?? '').replaceAll(',', ''));
                return count == null || count < 0
                    ? 'Enter zero or a positive quantity'
                    : null;
              },
            ),
          ),
          const SizedBox(height: 16),
          InventoryLabeledControl(
            label: 'REASON FOR ADJUSTMENT',
            child: DropdownButtonFormField<String>(
              decoration: inventoryInputDecoration(),
              style: inventoryInputStyle,
              hint: const Text('Select a reason', style: inventoryInputStyle),
              items: const [
                DropdownMenuItem(
                  value: 'Physical count',
                  child: Text('Physical count'),
                ),
                DropdownMenuItem(
                  value: 'Damaged goods',
                  child: Text('Damaged goods'),
                ),
                DropdownMenuItem(
                  value: 'Loss / damage',
                  child: Text('Loss / damage'),
                ),
                DropdownMenuItem(
                  value: 'Data correction',
                  child: Text('Data correction'),
                ),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (_) {},
              validator: (value) =>
                  value == null ? 'Select an adjustment reason' : null,
            ),
          ),
          const SizedBox(height: 16),
          InventoryLabeledControl(
            label: 'NOTES (OPTIONAL)',
            child: TextFormField(
              style: inventoryInputStyle,
              decoration: inventoryInputDecoration(
                hint: 'Describe the discrepancy',
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ],
      ),
    );
  }
}
