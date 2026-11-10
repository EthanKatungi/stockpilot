import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  static const _inputStyle = TextStyle(
    color: AppTheme.ink,
    fontSize: 13,
    height: 1.3,
  );

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  String? _positiveNumber(String? value) {
    final number = num.tryParse((value ?? '').replaceAll(',', ''));
    if (number == null || number <= 0) {
      return 'Enter a value greater than zero';
    }
    return null;
  }

  String? _nonNegativeNumber(String? value) {
    final number = num.tryParse((value ?? '').replaceAll(',', ''));
    if (number == null || number < 0) {
      return 'Enter zero or a positive value';
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Product saving will be implemented in Module 2.'),
        ),
      );
  }

  InputDecoration _decoration({String? hint}) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: const BorderSide(color: AppTheme.border),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppTheme.muted,
        fontSize: 13,
        height: 1.3,
      ),
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: border,
      enabledBorder: border,
      focusedBorder: border,
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppTheme.warning),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppTheme.warning),
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
          padding: const EdgeInsets.fromLTRB(20, 7, 20, 22),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 42,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, size: 25),
                          color: AppTheme.ink,
                          tooltip: 'Close add product',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                            width: 32,
                            height: 42,
                          ),
                        ),
                        const SizedBox(width: 13),
                        const Text(
                          'Add product',
                          style: TextStyle(
                            color: AppTheme.ink,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Text(
                      'Create a new inventory item',
                      style: TextStyle(
                        color: AppTheme.muted,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _LabeledControl(
                          label: 'PRODUCT NAME',
                          child: TextFormField(
                            decoration: _decoration(
                              hint: 'e.g. Arabica Coffee',
                            ),
                            style: _inputStyle,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            validator: _required,
                          ),
                        ),
                        const SizedBox(height: 13),
                        _LabeledControl(
                          label: 'SKU / PRODUCT CODE',
                          child: TextFormField(
                            decoration: _decoration(hint: 'e.g. ARA-001'),
                            style: _inputStyle,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            validator: _required,
                          ),
                        ),
                        const SizedBox(height: 13),
                        _LabeledControl(
                          label: 'CATEGORY',
                          child: DropdownButtonFormField<String>(
                            decoration: _decoration(),
                            style: _inputStyle,
                            hint: const Text(
                              'Select a category',
                              style: TextStyle(
                                color: AppTheme.ink,
                                fontSize: 13,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Coffee',
                                child: Text('Coffee'),
                              ),
                              DropdownMenuItem(
                                value: 'Packaging',
                                child: Text('Packaging'),
                              ),
                              DropdownMenuItem(
                                value: 'Commodity',
                                child: Text('Commodity'),
                              ),
                              DropdownMenuItem(
                                value: 'Other',
                                child: Text('Other'),
                              ),
                            ],
                            onChanged: (_) {},
                            validator: (value) =>
                                value == null ? 'Select a category' : null,
                          ),
                        ),
                        const SizedBox(height: 13),
                        _LabeledControl(
                          label: 'UNIT OF MEASURE',
                          child: DropdownButtonFormField<String>(
                            initialValue: 'Kilograms (kg)',
                            decoration: _decoration(),
                            style: _inputStyle,
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
                            onChanged: (_) {},
                          ),
                        ),
                        const SizedBox(height: 13),
                        _LabeledControl(
                          label: 'COST PER UNIT (UGX)',
                          child: TextFormField(
                            decoration: _decoration(hint: 'e.g. 8,750'),
                            style: _inputStyle,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9,]'),
                              ),
                            ],
                            validator: _positiveNumber,
                          ),
                        ),
                        const SizedBox(height: 13),
                        _LabeledControl(
                          label: 'LOW-STOCK THRESHOLD',
                          child: TextFormField(
                            decoration: _decoration(hint: 'e.g. 1,000'),
                            style: _inputStyle,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9,]'),
                              ),
                            ],
                            validator: _nonNegativeNumber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 49),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.mint,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Text(
                      'Initial stock can be recorded as a receipt later.',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
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
            onPressed: _save,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Save product',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledControl extends StatelessWidget {
  const _LabeledControl({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
