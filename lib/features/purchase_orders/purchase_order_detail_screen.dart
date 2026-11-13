import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'purchase_order.dart';
import 'approve_purchase_order_screen.dart';
import 'receive_purchase_order_screen.dart';
import 'widgets/purchase_order_components.dart';

class PurchaseOrderDetailScreen extends StatelessWidget {
  const PurchaseOrderDetailScreen({
    super.key,
    required this.order,
    this.onOpenMovements,
  });

  final PurchaseOrder order;
  final VoidCallback? onOpenMovements;

  @override
  Widget build(BuildContext context) {
    final awaitingApproval =
        order.status == PurchaseOrderStatus.draft ||
        order.status == PurchaseOrderStatus.pending;
    final statusDescription = switch (order.status) {
      PurchaseOrderStatus.draft ||
      PurchaseOrderStatus.pending => 'Awaiting approval',
      PurchaseOrderStatus.approved => 'Awaiting receipt',
      PurchaseOrderStatus.received => 'Received',
    };

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PurchaseOrderHeader(
                    title: 'Purchase Order Detail',
                    subtitle: '${order.id} · $statusDescription',
                    eyebrow: 'ORDER DETAILS',
                    showBack: true,
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: order.status.background,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${order.status.label.toUpperCase()} · $statusDescription',
                          style: TextStyle(
                            color: order.status.foreground,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          switch (order.status) {
                            PurchaseOrderStatus.draft =>
                              'Purchase order ${order.id} has not been sent.',
                            PurchaseOrderStatus.pending =>
                              'Purchase order ${order.id} is awaiting approval.',
                            PurchaseOrderStatus.approved =>
                              'Purchase order ${order.id} is awaiting goods receipt.',
                            PurchaseOrderStatus.received =>
                              'Purchase order ${order.id} is marked received in this demo.',
                          },
                          style: AppTheme.bodySmall.copyWith(
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Order summary', style: AppTheme.sectionTitle),
                  const SizedBox(height: 11),
                  _DetailRow(
                    label: 'Supplier',
                    value: order.supplier.businessName,
                  ),
                  _DetailRow(label: 'Order date', value: order.createdAt),
                  _DetailRow(label: 'Expected date', value: order.expectedAt),
                  _DetailRow(
                    label: 'Currency',
                    value: order.currency,
                    divider: false,
                  ),
                  const SizedBox(height: 20),
                  const Text('Items ordered', style: AppTheme.sectionTitle),
                  const SizedBox(height: 12),
                  for (final item in order.items) ...[
                    _OrderItemTile(item: item),
                    const SizedBox(height: 9),
                  ],
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.mint,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'ORDER TOTAL',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          order.totalValue,
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (awaitingApproval) ...[
                    _ActionButton(
                      label: 'Review & Approve',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              ApprovePurchaseOrderScreen(order: order),
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    const _ActionButton(label: 'Receive Goods'),
                  ] else if (order.status == PurchaseOrderStatus.approved)
                    _ActionButton(
                      label: 'Receive Goods',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ReceivePurchaseOrderScreen(
                            order: order,
                            onOpenMovements: onOpenMovements,
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
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
                    fontWeight: FontWeight.w600,
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

class _OrderItemTile extends StatelessWidget {
  const _OrderItemTile({required this.item});

  final PurchaseOrderItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
                  '${item.quantity} × ${item.unitPrice}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.bodySmall.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: item.lineTotal,
            child: Text(
              item.shortTotal,
              style: const TextStyle(
                color: AppTheme.primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppTheme.border,
          disabledForegroundColor: AppTheme.muted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
