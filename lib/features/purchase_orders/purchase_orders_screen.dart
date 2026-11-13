import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../products/widgets/category_filter_chip.dart';
import 'purchase_order.dart';
import 'purchase_order_detail_screen.dart';
import 'new_purchase_order_screen.dart';
import 'supplier_quotations_screen.dart';
import 'purchase_orders_mock_data.dart';
import 'widgets/purchase_order_components.dart';

class PurchaseOrdersScreen extends StatefulWidget {
  const PurchaseOrdersScreen({super.key, this.orders, this.onOpenMovements});

  /// Optional fixtures make the empty state previewable without changing demo data.
  final List<PurchaseOrder>? orders;
  final VoidCallback? onOpenMovements;

  @override
  State<PurchaseOrdersScreen> createState() => _PurchaseOrdersScreenState();
}

class _PurchaseOrdersScreenState extends State<PurchaseOrdersScreen> {
  PurchaseOrderStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final orders = widget.orders ?? PurchaseOrdersMockData.orders;
    final visibleOrders = orders
        .where(
          (order) => _selectedStatus == null || order.status == _selectedStatus,
        )
        .toList(growable: false);
    final openCount = orders
        .where((order) => order.status != PurchaseOrderStatus.received)
        .length;
    final awaitingReceiptCount = orders
        .where((order) => order.status == PurchaseOrderStatus.approved)
        .length;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PurchaseOrderHeader(
                    title: 'Purchase Orders',
                    subtitle: 'From ordering to delivery',
                    eyebrow: 'PURCHASING',
                    showBack: true,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _OrderMetric(
                          value: '$openCount',
                          label: 'Open orders',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _OrderMetric(
                          value: '$awaitingReceiptCount',
                          label: 'Awaiting receipt',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CategoryFilterChip(
                          label: 'All',
                          width: 53,
                          selected: _selectedStatus == null,
                          onTap: () => setState(() => _selectedStatus = null),
                        ),
                        const SizedBox(width: 8),
                        for (final status in [
                          PurchaseOrderStatus.draft,
                          PurchaseOrderStatus.approved,
                          PurchaseOrderStatus.received,
                          PurchaseOrderStatus.pending,
                        ]) ...[
                          CategoryFilterChip(
                            label: status.label,
                            width: switch (status) {
                              PurchaseOrderStatus.draft => 66,
                              PurchaseOrderStatus.approved => 91,
                              PurchaseOrderStatus.received => 88,
                              PurchaseOrderStatus.pending => 80,
                            },
                            selected: _selectedStatus == status,
                            onTap: () =>
                                setState(() => _selectedStatus = status),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Purchase orders',
                          style: AppTheme.sectionTitle,
                        ),
                      ),
                      Text(
                        'Filter',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  if (visibleOrders.isEmpty)
                    _OrderEmptyState(filtered: _selectedStatus != null)
                  else
                    for (final order in visibleOrders) ...[
                      _PurchaseOrderTile(
                        order: order,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => PurchaseOrderDetailScreen(
                              order: order,
                              onOpenMovements: widget.onOpenMovements,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                    ],
                  const SizedBox(height: 7),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const NewPurchaseOrderScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('New Purchase Order'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const SupplierQuotationsScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.compare_arrows, size: 18),
                      label: const Text('Compare Supplier Quotations'),
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

class _OrderMetric extends StatelessWidget {
  const _OrderMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.bodySmall.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _PurchaseOrderTile extends StatelessWidget {
  const _PurchaseOrderTile({required this.order, required this.onTap});

  final PurchaseOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
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
                  color: order.status.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'P',
                  style: TextStyle(
                    color: order.status.foreground,
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
                      order.id,
                      style: const TextStyle(
                        color: AppTheme.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${order.supplier.businessName} · ${order.items.length} ${order.items.length == 1 ? 'product' : 'products'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.bodySmall.copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.createdAt,
                      style: AppTheme.bodySmall.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              PurchaseOrderStatusBadge(status: order.status),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderEmptyState extends StatelessWidget {
  const _OrderEmptyState({required this.filtered});

  final bool filtered;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            color: AppTheme.primary,
            size: 30,
          ),
          const SizedBox(height: 9),
          Text(
            filtered ? 'No orders with this status' : 'No purchase orders yet',
            style: const TextStyle(
              color: AppTheme.ink,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            filtered
                ? 'Try another status filter.'
                : 'New orders will appear here when creation is available.',
            textAlign: TextAlign.center,
            style: AppTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
