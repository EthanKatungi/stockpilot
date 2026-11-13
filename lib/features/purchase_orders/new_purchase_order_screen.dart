import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../products/widgets/category_filter_chip.dart';
import '../suppliers/supplier.dart';
import '../suppliers/suppliers_mock_data.dart';
import 'add_order_items_screen.dart';
import 'purchase_order_draft.dart';
import 'widgets/purchase_order_components.dart';

class NewPurchaseOrderScreen extends StatefulWidget {
  const NewPurchaseOrderScreen({super.key});

  @override
  State<NewPurchaseOrderScreen> createState() => _NewPurchaseOrderScreenState();
}

class _NewPurchaseOrderScreenState extends State<NewPurchaseOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _draft = PurchaseOrderDraft();
  late final TextEditingController _orderDateController;
  late final TextEditingController _expectedDateController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _orderDateController = TextEditingController(
      text: formatOrderDate(_draft.orderDate),
    );
    _expectedDateController = TextEditingController(
      text: formatOrderDate(_draft.expectedDate),
    );
    _notesController = TextEditingController(text: _draft.notes);
  }

  @override
  void dispose() {
    _orderDateController.dispose();
    _expectedDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool expected}) async {
    final initial = expected
        ? (_draft.expectedDate.isBefore(_draft.orderDate)
              ? _draft.orderDate
              : _draft.expectedDate)
        : _draft.orderDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: expected ? _draft.orderDate : DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (expected) {
        _draft.expectedDate = picked;
        _expectedDateController.text = formatOrderDate(picked);
      } else {
        _draft.orderDate = picked;
        _orderDateController.text = formatOrderDate(picked);
      }
    });
    _formKey.currentState?.validate();
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddOrderItemsScreen(draft: _draft),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 26),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PurchaseOrderHeader(
                    title: 'New Purchase Order',
                    subtitle: 'Step 1 of 2: Supplier and order',
                    eyebrow: 'PURCHASING FORM',
                    showBack: true,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      CategoryFilterChip(
                        label: '1 · Order',
                        width: 96,
                        selected: true,
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      CategoryFilterChip(
                        label: '2 · Items',
                        width: 91,
                        selected: false,
                        onTap: _continue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PurchaseOrderLabeledField(
                          label: 'SUPPLIER',
                          child: DropdownButtonFormField<Supplier>(
                            initialValue: _draft.supplier,
                            isExpanded: true,
                            decoration: purchaseOrderInputDecoration(
                              hint: 'Select a supplier',
                            ),
                            style: purchaseOrderInputStyle,
                            items: [
                              for (final supplier
                                  in SuppliersMockData.suppliers.where(
                                    (supplier) =>
                                        supplier.status ==
                                        SupplierStatus.active,
                                  ))
                                DropdownMenuItem(
                                  value: supplier,
                                  child: Text(
                                    supplier.businessName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                            onChanged: (supplier) =>
                                setState(() => _draft.supplier = supplier),
                            validator: (supplier) =>
                                supplier == null ? 'Select a supplier' : null,
                          ),
                        ),
                        PurchaseOrderLabeledField(
                          label: 'ORDER DATE',
                          child: TextFormField(
                            controller: _orderDateController,
                            readOnly: true,
                            onTap: () => _pickDate(expected: false),
                            style: purchaseOrderInputStyle,
                            decoration: purchaseOrderInputDecoration(
                              suffixIcon: const Icon(
                                Icons.calendar_today_outlined,
                                color: AppTheme.primary,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        PurchaseOrderLabeledField(
                          label: 'EXPECTED DELIVERY DATE',
                          child: TextFormField(
                            controller: _expectedDateController,
                            readOnly: true,
                            onTap: () => _pickDate(expected: true),
                            style: purchaseOrderInputStyle,
                            decoration: purchaseOrderInputDecoration(
                              suffixIcon: const Icon(
                                Icons.calendar_today_outlined,
                                color: AppTheme.primary,
                                size: 18,
                              ),
                            ),
                            validator: (_) =>
                                _draft.expectedDate.isBefore(_draft.orderDate)
                                ? 'Expected delivery must follow the order date'
                                : null,
                          ),
                        ),
                        PurchaseOrderLabeledField(
                          label: 'CURRENCY',
                          child: DropdownButtonFormField<String>(
                            initialValue: _draft.currency,
                            decoration: purchaseOrderInputDecoration(),
                            style: purchaseOrderInputStyle,
                            items: const [
                              DropdownMenuItem(
                                value: 'UGX',
                                child: Text('UGX'),
                              ),
                              DropdownMenuItem(
                                value: 'USD',
                                child: Text('USD'),
                              ),
                              DropdownMenuItem(
                                value: 'KES',
                                child: Text('KES'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _draft.currency = value);
                              }
                            },
                          ),
                        ),
                        PurchaseOrderLabeledField(
                          label: 'REFERENCE / NOTES',
                          child: TextFormField(
                            controller: _notesController,
                            onChanged: (value) => _draft.notes = value,
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                            style: purchaseOrderInputStyle,
                            decoration: purchaseOrderInputDecoration(
                              hint: 'Optional order details',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.mint,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Draft order',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Inventory is only affected when goods are received. Nothing is saved in this preview.',
                          style: AppTheme.bodySmall.copyWith(
                            fontSize: 11,
                            height: 1.5,
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
            onPressed: _continue,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Continue to Items'),
          ),
        ),
      ),
    );
  }
}
