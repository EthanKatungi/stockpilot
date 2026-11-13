import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../products/products_mock_data.dart';
import 'movement_navigation.dart';
import 'movements_mock_data.dart';
import 'widgets/inventory_form_components.dart';

class RecordStockReceiptScreen extends StatelessWidget {
  const RecordStockReceiptScreen({super.key, this.product});

  final MockProduct? product;

  @override
  Widget build(BuildContext context) {
    return _StockMovementFormScreen(
      type: MovementType.receipt,
      preselectedProduct: product,
    );
  }
}

class RecordStockIssueScreen extends StatelessWidget {
  const RecordStockIssueScreen({super.key, this.product});

  final MockProduct? product;

  @override
  Widget build(BuildContext context) {
    return _StockMovementFormScreen(
      type: MovementType.issue,
      preselectedProduct: product,
    );
  }
}

class _StockMovementFormScreen extends StatefulWidget {
  const _StockMovementFormScreen({
    required this.type,
    required this.preselectedProduct,
  });

  final MovementType type;
  final MockProduct? preselectedProduct;

  @override
  State<_StockMovementFormScreen> createState() =>
      _StockMovementFormScreenState();
}

class _StockMovementFormScreenState extends State<_StockMovementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  MockProduct? _selectedProduct;
  String _selectedUnit = 'Kilograms (kg)';

  bool get _isReceipt => widget.type == MovementType.receipt;

  @override
  void initState() {
    super.initState();
    _selectedProduct = widget.preselectedProduct;
    _selectedUnit = _selectedProduct?.unitOfMeasure ?? 'Kilograms (kg)';
  }

  void _selectProduct(MockProduct? product) {
    setState(() {
      _selectedProduct = product;
      _selectedUnit = product?.unitOfMeasure ?? 'Kilograms (kg)';
    });
  }

  String? _quantityValidator(String? value) {
    final quantity = num.tryParse((value ?? '').replaceAll(',', ''));
    if (quantity == null || quantity <= 0) {
      return 'Enter a quantity greater than zero';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _isReceipt
                ? 'Stock receipt recording will be implemented in Module 2.'
                : 'Stock issue recording will be implemented in Module 2.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return InventoryFormScaffold(
      title: _isReceipt ? 'Record Stock Receipt' : 'Record Stock Issue',
      subtitle: _isReceipt
          ? 'Goods entering your warehouse'
          : 'Goods leaving your inventory',
      eyebrow: _isReceipt ? 'STOCK IN' : 'STOCK OUT',
      formKey: _formKey,
      actionLabel: _isReceipt ? 'Record Receipt' : 'Record Issue',
      onSubmit: _submit,
      topContent: InventoryMovementTabs(
        selected: widget.type,
        onSelected: (type) {
          if (type != widget.type) {
            replaceMovementForm(context, type, _selectedProduct);
          }
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InventoryLabeledControl(
            label: 'PRODUCT',
            child: InventoryProductSelector(
              selected: _selectedProduct,
              onChanged: _selectProduct,
            ),
          ),
          const SizedBox(height: 16),
          InventoryLabeledControl(
            label: 'QUANTITY',
            child: TextFormField(
              style: inventoryInputStyle,
              decoration: inventoryInputDecoration(hint: 'e.g. 1,000'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              validator: _quantityValidator,
            ),
          ),
          const SizedBox(height: 16),
          InventoryLabeledControl(
            label: 'UNIT OF MEASURE',
            child: DropdownButtonFormField<String>(
              key: ValueKey(_selectedUnit),
              initialValue: _selectedUnit,
              decoration: inventoryInputDecoration(),
              style: inventoryInputStyle,
              items: const [
                DropdownMenuItem(
                  value: 'Kilograms (kg)',
                  child: Text('Kilograms (kg)'),
                ),
                DropdownMenuItem(
                  value: 'Pieces (pcs)',
                  child: Text('Pieces (pcs)'),
                ),
                DropdownMenuItem(
                  value: 'Litres (L)',
                  child: Text('Litres (L)'),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _selectedUnit = value);
              },
            ),
          ),
          const SizedBox(height: 16),
          InventoryLabeledControl(
            label: _isReceipt ? 'DELIVERY REFERENCE' : 'ISSUE REFERENCE',
            child: TextFormField(
              style: inventoryInputStyle,
              decoration: inventoryInputDecoration(
                hint: _isReceipt ? 'e.g. RCV-1029' : 'e.g. ISS-1006',
              ),
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a reference number'
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          InventoryLabeledControl(
            label: 'NOTES (OPTIONAL)',
            child: TextFormField(
              style: inventoryInputStyle,
              decoration: inventoryInputDecoration(
                hint: 'Add a note about this movement',
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(height: 17),
          if (_isReceipt)
            const InventoryNotice(
              title: 'Receipt preview',
              message: 'Receiving stock would increase available quantity. This preview does not save a movement.',
            )
          else
            InventoryNotice(
              title: _selectedProduct == null
                  ? 'Available stock: Select a product'
                  : 'Available stock: ${_selectedProduct!.quantity}',
              message: 'An issue should not exceed available quantity. This preview does not save a movement.',
              warning: true,
            ),
        ],
      ),
    );
  }
}
