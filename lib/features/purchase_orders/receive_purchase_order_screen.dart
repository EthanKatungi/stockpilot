import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import 'goods_receipt_preview.dart';
import 'goods_received_screen.dart';
import 'purchase_order.dart';
import 'purchase_order_draft.dart';
import 'widgets/purchase_order_components.dart';

/// The current order model keeps quantities as display strings, for example
/// "2,000 kg". Parse only the mock ordered amount for local form validation.
({double amount, String unit})? parseOrderedQuantity(String text) {
  final match = RegExp(r'^\s*([\d,]+(?:\.\d+)?)\s*(\S.*)?$').firstMatch(text);
  if (match == null) return null;
  final amount = double.tryParse(match.group(1)!.replaceAll(',', ''));
  if (amount == null || !amount.isFinite || amount < 0) return null;
  return (amount: amount, unit: match.group(2)?.trim() ?? '');
}

class ReceivePurchaseOrderScreen extends StatefulWidget {
  const ReceivePurchaseOrderScreen({
    super.key,
    required this.order,
    this.onOpenMovements,
  });

  final PurchaseOrder order;
  final VoidCallback? onOpenMovements;

  @override
  State<ReceivePurchaseOrderScreen> createState() =>
      _ReceivePurchaseOrderScreenState();
}

class _ReceivePurchaseOrderScreenState
    extends State<ReceivePurchaseOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _referenceController = TextEditingController();
  late final TextEditingController _dateController;
  late final List<TextEditingController> _quantityControllers;
  late DateTime _receiptDate;
  bool _showZeroError = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _receiptDate = DateTime(now.year, now.month, now.day);
    _dateController = TextEditingController(
      text: formatOrderDate(_receiptDate),
    );
    _quantityControllers = List.generate(
      widget.order.items.length,
      (_) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    _referenceController.dispose();
    _dateController.dispose();
    for (final controller in _quantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _quantityError(String? text, double outstanding) {
    if (text == null || text.trim().isEmpty) return null;
    final quantity = double.tryParse(text.replaceAll(',', ''));
    if (quantity == null || !quantity.isFinite) return 'Enter a valid quantity';
    if (quantity < 0) return 'Quantity cannot be negative';
    if (quantity > outstanding) {
      return 'Cannot exceed ${formatOrderNumber(outstanding)}';
    }
    return null;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _receiptDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _receiptDate = picked;
      _dateController.text = formatOrderDate(picked);
    });
  }

  Future<void> _confirmReceipt() async {
    if (widget.order.status != PurchaseOrderStatus.approved) return;
    final valid = _formKey.currentState!.validate();
    final hasPositiveQuantity = _quantityControllers.any(
      (controller) =>
          (double.tryParse(controller.text.replaceAll(',', '')) ?? 0) > 0,
    );
    setState(() => _showZeroError = !hasPositiveQuantity);
    if (!valid || !hasPositiveQuantity) return;
    FocusScope.of(context).unfocus();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm receipt preview?'),
        content: Text(
          'Review the entered quantities for ${widget.order.id}. '
          'This preview will not record goods or update inventory.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    final lines = <ReceiptPreviewLine>[
      for (final (index, item) in widget.order.items.indexed)
        if ((double.tryParse(
                  _quantityControllers[index].text.replaceAll(',', ''),
                ) ??
                0) >
            0)
          ReceiptPreviewLine(
            productName: item.productName,
            quantity: double.parse(
              _quantityControllers[index].text.replaceAll(',', ''),
            ),
            unit: parseOrderedQuantity(item.quantity)!.unit,
          ),
    ];
    final preview = GoodsReceiptPreview(
      order: widget.order,
      deliveryReference: _referenceController.text.trim(),
      receivedAt: _receiptDate,
      lines: lines,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GoodsReceivedScreen(
          preview: preview,
          onOpenMovements: widget.onOpenMovements,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final canReceive =
        order.status == PurchaseOrderStatus.approved &&
        order.items.every(
          (item) => parseOrderedQuantity(item.quantity) != null,
        );
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
                  const PurchaseOrderHeader(
                    title: 'Receive Purchase Order',
                    subtitle: 'Record goods received against an order',
                    eyebrow: 'GOODS RECEIVED',
                    showBack: true,
                  ),
                  const SizedBox(height: 18),
                  PurchaseOrderNotice(
                    title: '${order.id} · ${order.status.label}',
                    message: canReceive
                        ? 'Supplier: ${order.supplier.businessName}. Enter actual quantities delivered into your warehouse.'
                        : 'Only approved orders with valid ordered quantities can be received.',
                    warning: !canReceive,
                  ),
                  const SizedBox(height: 20),
                  const Text('Items to receive', style: AppTheme.sectionTitle),
                  const SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final (index, item) in order.items.indexed) ...[
                          _ReceiptItemField(
                            item: item,
                            controller: _quantityControllers[index],
                            quantityError: _quantityError,
                            onChanged: () {
                              if (_showZeroError) {
                                setState(() => _showZeroError = false);
                              }
                            },
                          ),
                          const SizedBox(height: 9),
                        ],
                        if (_showZeroError) ...[
                          const Text(
                            'Enter a received quantity greater than zero for at least one item.',
                            style: TextStyle(
                              color: AppTheme.danger,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        const SizedBox(height: 8),
                        PurchaseOrderLabeledField(
                          label: 'DELIVERY REFERENCE',
                          child: TextFormField(
                            controller: _referenceController,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            style: purchaseOrderInputStyle,
                            decoration: purchaseOrderInputDecoration(
                              hint: 'e.g. DEL-2026-042',
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Enter a delivery reference'
                                : null,
                          ),
                        ),
                        PurchaseOrderLabeledField(
                          label: 'RECEIVED DATE',
                          child: TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            onTap: _pickDate,
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
                      ],
                    ),
                  ),
                  PurchaseOrderNotice(
                    title: 'Partial delivery supported',
                    message: 'You may enter less than ordered. No quantities or outstanding balances change in this preview.',
                    warning: true,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton(
                      onPressed: canReceive ? _confirmReceipt : null,
                      child: const Text('Confirm Receipt'),
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

class _ReceiptItemField extends StatelessWidget {
  const _ReceiptItemField({
    required this.item,
    required this.controller,
    required this.quantityError,
    required this.onChanged,
  });

  final PurchaseOrderItem item;
  final TextEditingController controller;
  final String? Function(String?, double) quantityError;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final ordered = parseOrderedQuantity(item.quantity);
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              item.productName[0],
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
                  item.productName,
                  style: const TextStyle(
                    color: AppTheme.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Ordered ${item.quantity}',
                  style: AppTheme.bodySmall.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 9),
                TextFormField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,-]')),
                  ],
                  style: purchaseOrderInputStyle,
                  decoration: purchaseOrderInputDecoration(
                    hint:
                        'Quantity received${ordered == null ? '' : ' (${ordered.unit})'}',
                  ),
                  validator: (value) => ordered == null
                      ? 'Ordered quantity unavailable'
                      : quantityError(value, ordered.amount),
                  onChanged: (_) => onChanged(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
