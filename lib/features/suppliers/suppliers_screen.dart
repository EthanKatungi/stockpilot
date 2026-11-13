import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../products/widgets/category_filter_chip.dart';
import 'supplier.dart';
import 'supplier_form_screen.dart';
import 'supplier_profile_screen.dart';
import 'suppliers_mock_data.dart';
import 'widgets/supplier_card.dart';
import 'widgets/supplier_page_header.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key, this.suppliers});

  /// An override supports empty-state previews without changing shared fixtures.
  final List<Supplier>? suppliers;

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  String _query = '';
  SupplierStatus? _status;

  void _openAddSupplier() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AddSupplierScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final allSuppliers = widget.suppliers ?? SuppliersMockData.suppliers;
    final query = _query.trim().toLowerCase();
    final visibleSuppliers = allSuppliers
        .where((supplier) {
          final matchesStatus = _status == null || supplier.status == _status;
          final matchesQuery =
              query.isEmpty ||
              [
                supplier.businessName,
                supplier.contactPerson,
                supplier.location,
                supplier.phone,
                supplier.email,
              ].any((value) => value.toLowerCase().contains(query));
          return matchesStatus && matchesQuery;
        })
        .toList(growable: false);

    return Scaffold(
      body: SafeArea(
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
                  const SupplierPageHeader(
                    title: 'Suppliers',
                    eyebrow: 'PURCHASING',
                    subtitle: 'Manage your trading partners',
                    showBack: true,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${allSuppliers.length} suppliers',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 19),
                  const Text(
                    'SEARCH SUPPLIERS',
                    style: TextStyle(
                      color: AppTheme.muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: (value) => setState(() => _query = value),
                    textInputAction: TextInputAction.search,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Search business or contact name',
                      hintStyle: AppTheme.bodySmall.copyWith(fontSize: 12),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppTheme.muted,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                      border: _searchBorder,
                      enabledBorder: _searchBorder,
                      focusedBorder: _searchBorder,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      CategoryFilterChip(
                        label: 'All',
                        width: 53,
                        selected: _status == null,
                        onTap: () => setState(() => _status = null),
                      ),
                      const SizedBox(width: 8),
                      CategoryFilterChip(
                        label: 'Active',
                        width: 78,
                        selected: _status == SupplierStatus.active,
                        onTap: () =>
                            setState(() => _status = SupplierStatus.active),
                      ),
                      const SizedBox(width: 8),
                      CategoryFilterChip(
                        label: 'Inactive',
                        width: 87,
                        selected: _status == SupplierStatus.inactive,
                        onTap: () =>
                            setState(() => _status = SupplierStatus.inactive),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Supplier directory',
                          style: AppTheme.sectionTitle,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _openAddSupplier,
                        icon: const Icon(Icons.add, size: 17),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (visibleSuppliers.isEmpty)
                    _SupplierEmptyState(
                      filtered: query.isNotEmpty || _status != null,
                    )
                  else
                    for (final supplier in visibleSuppliers) ...[
                      SupplierCard(
                        supplier: supplier,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                SupplierProfileScreen(supplier: supplier),
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                    ],
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton.icon(
                      onPressed: _openAddSupplier,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Supplier'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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

  OutlineInputBorder get _searchBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    borderSide: const BorderSide(color: AppTheme.border),
  );
}

class _SupplierEmptyState extends StatelessWidget {
  const _SupplierEmptyState({required this.filtered});

  final bool filtered;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.business_outlined,
            color: AppTheme.primary,
            size: 30,
          ),
          const SizedBox(height: 9),
          Text(
            filtered ? 'No matching suppliers' : 'No suppliers yet',
            style: const TextStyle(
              color: AppTheme.ink,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            filtered
                ? 'Try another search or filter.'
                : 'Add a supplier to start your directory.',
            textAlign: TextAlign.center,
            style: AppTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
