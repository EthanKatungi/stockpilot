import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'purchase_order.dart';
import 'widgets/purchase_order_components.dart';

class ApprovePurchaseOrderScreen extends StatefulWidget {
  const ApprovePurchaseOrderScreen({super.key, required this.order});

  final PurchaseOrder order;

  @override
  State<ApprovePurchaseOrderScreen> createState() =>
      _ApprovePurchaseOrderScreenState();
}

class _ApprovePurchaseOrderScreenState
    extends State<ApprovePurchaseOrderScreen> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  bool get _canApprove =>
      widget.order.status == PurchaseOrderStatus.draft ||
      widget.order.status == PurchaseOrderStatus.pending;

  Future<void> _approve() async {
    if (!_canApprove) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Approve purchase order?'),
        content: Text(
          'Review ${widget.order.id} for ${widget.order.supplier.businessName}. '
          'Approval is a preview and will not change this order yet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Confirm Approval'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Purchase order approval will be implemented in a later phase. Nothing was changed.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
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
                    title: 'Approve Purchase Order',
                    subtitle: 'Review before supplier confirmation',
                    eyebrow: 'APPROVAL FLOW',
                    showBack: true,
                  ),
                  const SizedBox(height: 18),
                  PurchaseOrderNotice(
                    title: _canApprove
                        ? 'Review before approval'
                        : 'Order cannot be approved',
                    message: _canApprove
                        ? 'Approval will be available in a later phase. Stock is not added during approval.'
                        : 'This order is ${order.status.label.toLowerCase()}. Only draft or pending orders can be approved.',
                    warning: true,
                  ),
                  const SizedBox(height: 20),
                  const Text('Order to approve', style: AppTheme.sectionTitle),
                  const SizedBox(height: 11),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppTheme.border),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      children: [
                        _InfoRow(label: 'Order ID', value: order.id),
                        _InfoRow(
                          label: 'Supplier',
                          value: order.supplier.businessName,
                        ),
                        _InfoRow(label: 'Status', value: order.status.label),
                        _InfoRow(label: 'Order date', value: order.createdAt),
                        _InfoRow(
                          label: 'Expected date',
                          value: order.expectedAt,
                        ),
                        _InfoRow(
                          label: 'Products',
                          value: '${order.items.length} products',
                        ),
                        _InfoRow(
                          label: 'Total value',
                          value: order.totalValue,
                          last: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Items ordered', style: AppTheme.sectionTitle),
                  const SizedBox(height: 10),
                  for (final item in order.items) ...[
                    PurchaseOrderLineSummary(item: item),
                    const SizedBox(height: 9),
                  ],
                  const SizedBox(height: 10),
                  PurchaseOrderLabeledField(
                    label: 'APPROVER NOTE',
                    child: TextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      style: purchaseOrderInputStyle,
                      decoration: purchaseOrderInputDecoration(
                        hint: 'Optional note',
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton(
                      onPressed: _canApprove ? _approve : null,
                      child: const Text('Approve Order'),
                    ),
                  ),
                  const SizedBox(height: 9),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Return to Draft'),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.last = false});

  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTheme.bodySmall.copyWith(fontSize: 11),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      if (!last) const Divider(height: 1, color: AppTheme.border),
    ],
  );
}
