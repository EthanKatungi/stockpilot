import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'supplier.dart';
import 'supplier_form_screen.dart';
import 'widgets/supplier_page_header.dart';

class SupplierProfileScreen extends StatelessWidget {
  const SupplierProfileScreen({super.key, required this.supplier});

  final Supplier supplier;

  @override
  Widget build(BuildContext context) {
    final active = supplier.status == SupplierStatus.active;

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
                  SupplierPageHeader(
                    title: 'Supplier Profile',
                    eyebrow: 'SUPPLIER DETAILS',
                    subtitle: 'Supplier ID ${supplier.id}',
                    showBack: true,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: active ? AppTheme.mint : AppTheme.background,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            supplier.initials,
                            style: TextStyle(
                              color: active ? AppTheme.primary : AppTheme.muted,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                supplier.businessName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppTheme.ink,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                '${active ? 'Active' : 'Inactive'} supplier · ${supplier.city}',
                                style: AppTheme.bodySmall.copyWith(
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Contact information',
                          style: AppTheme.sectionTitle,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                EditSupplierScreen(supplier: supplier),
                          ),
                        ),
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  _SupplierDetailRow(
                    label: 'Contact person',
                    value: supplier.contactPerson,
                  ),
                  _SupplierDetailRow(label: 'Phone', value: supplier.phone),
                  _SupplierDetailRow(label: 'Email', value: supplier.email),
                  _SupplierDetailRow(
                    label: 'Business location',
                    value: supplier.location,
                  ),
                  _SupplierDetailRow(
                    label: 'Category',
                    value: supplier.category,
                    divider: false,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Purchasing overview',
                    style: AppTheme.sectionTitle,
                  ),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      Expanded(
                        child: _SupplierMetric(
                          value: '${supplier.orderCount}',
                          label: 'Orders placed',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SupplierMetric(
                          value: '${supplier.pendingDeliveries}',
                          label: 'Pending deliveries',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Purchase order creation will be implemented in Phase 4C.',
                              ),
                            ),
                          );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Create Purchase Order'),
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

class _SupplierDetailRow extends StatelessWidget {
  const _SupplierDetailRow({
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

class _SupplierMetric extends StatelessWidget {
  const _SupplierMetric({required this.value, required this.label});

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
          const SizedBox(height: 3),
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
