import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import 'supplier.dart';
import 'suppliers_mock_data.dart';
import 'widgets/supplier_page_header.dart';

class AddSupplierScreen extends StatelessWidget {
  const AddSupplierScreen({super.key});

  @override
  Widget build(BuildContext context) => const _SupplierFormScreen();
}

class EditSupplierScreen extends StatelessWidget {
  const EditSupplierScreen({super.key, required this.supplier});

  final Supplier supplier;

  @override
  Widget build(BuildContext context) => _SupplierFormScreen(supplier: supplier);
}

class _SupplierFormScreen extends StatefulWidget {
  const _SupplierFormScreen({this.supplier});

  final Supplier? supplier;

  @override
  State<_SupplierFormScreen> createState() => _SupplierFormScreenState();
}

class _SupplierFormScreenState extends State<_SupplierFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _businessNameController;
  late final TextEditingController _contactPersonController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _locationController;
  String? _category;

  bool get _editing => widget.supplier != null;

  @override
  void initState() {
    super.initState();
    final supplier = widget.supplier;
    _businessNameController = TextEditingController(
      text: supplier?.businessName,
    );
    _contactPersonController = TextEditingController(
      text: supplier?.contactPerson,
    );
    _phoneController = TextEditingController(text: supplier?.phone);
    _emailController = TextEditingController(text: supplier?.email);
    _locationController = TextEditingController(text: supplier?.location);
    _category = supplier?.category;
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _editing
                ? 'Supplier updates will be implemented in Module 2. No changes were saved.'
                : 'Supplier saving will be implemented in Module 2. No supplier was saved.',
          ),
        ),
      );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  SupplierPageHeader(
                    title: _editing ? 'Edit Supplier' : 'Add Supplier',
                    eyebrow: 'SUPPLIER FORM',
                    subtitle: _editing
                        ? 'Update supplier records'
                        : 'Register a supplier',
                    showBack: true,
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SupplierFormField(
                          label: 'BUSINESS NAME',
                          child: TextFormField(
                            controller: _businessNameController,
                            decoration: _decoration('e.g. Kampala Supplies'),
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            validator: _required,
                          ),
                        ),
                        _SupplierFormField(
                          label: 'CONTACT PERSON',
                          child: TextFormField(
                            controller: _contactPersonController,
                            decoration: _decoration('Full name'),
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            validator: _required,
                          ),
                        ),
                        _SupplierFormField(
                          label: 'PHONE',
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: _decoration('+256 ...'),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9+ ()-]'),
                              ),
                            ],
                            validator: (value) {
                              if (_required(value) != null) {
                                return 'Enter a phone number';
                              }
                              final digits = value!.replaceAll(
                                RegExp(r'\D'),
                                '',
                              );
                              return digits.length < 9
                                  ? 'Enter a valid phone number'
                                  : null;
                            },
                          ),
                        ),
                        _SupplierFormField(
                          label: 'EMAIL',
                          child: TextFormField(
                            controller: _emailController,
                            decoration: _decoration('name@company.com'),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              if (email.isEmpty) {
                                return 'Enter an email address';
                              }
                              return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                      .hasMatch(email)
                                  ? null
                                  : 'Enter a valid email address';
                            },
                          ),
                        ),
                        _SupplierFormField(
                          label: 'BUSINESS LOCATION',
                          child: TextFormField(
                            controller: _locationController,
                            decoration: _decoration('City / region'),
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            validator: _required,
                          ),
                        ),
                        _SupplierFormField(
                          label: 'CATEGORY',
                          child: DropdownButtonFormField<String>(
                            initialValue: _category,
                            isExpanded: true,
                            decoration: _decoration('Select category'),
                            items: [
                              for (final category
                                  in SuppliersMockData.categories)
                                DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ),
                            ],
                            onChanged: (value) =>
                                setState(() => _category = value),
                            validator: (value) =>
                                value == null ? 'Select a category' : null,
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
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(_editing ? 'Update Supplier' : 'Save Supplier'),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: const BorderSide(color: AppTheme.border),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTheme.bodySmall.copyWith(fontSize: 12),
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: border,
      enabledBorder: border,
      focusedBorder: border,
    );
  }
}

class _SupplierFormField extends StatelessWidget {
  const _SupplierFormField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.muted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: .3,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
