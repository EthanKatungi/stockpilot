import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../products/products_mock_data.dart';
import '../../products/widgets/category_filter_chip.dart';
import '../movements_mock_data.dart';

const inventoryInputStyle = TextStyle(
  color: AppTheme.ink,
  fontSize: 13,
  height: 1.3,
);

InputDecoration inventoryInputDecoration({String? hint}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    borderSide: const BorderSide(color: AppTheme.border),
  );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppTheme.muted, fontSize: 13),
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: border,
    enabledBorder: border,
    focusedBorder: border,
  );
}

class InventoryPageHeader extends StatelessWidget {
  const InventoryPageHeader({
    super.key,
    required this.title,
    required this.eyebrow,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String eyebrow;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.chevron_left, size: 24),
              color: AppTheme.primary,
              tooltip: 'Back',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 28, height: 28),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                'STOCKPILOT / $eyebrow',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .7,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.ink,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1.16,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppTheme.muted,
            fontSize: 11,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class InventoryMovementTabs extends StatelessWidget {
  const InventoryMovementTabs({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final MovementType selected;
  final ValueChanged<MovementType> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (index, type) in MovementType.values.indexed) ...[
          if (index > 0) const SizedBox(width: 8),
          CategoryFilterChip(
            label: switch (type) {
              MovementType.receipt => 'Receive',
              MovementType.issue => 'Issue',
              MovementType.adjustment => 'Adjust',
            },
            width: switch (type) {
              MovementType.receipt => 87,
              MovementType.issue => 66,
              MovementType.adjustment => 78,
            },
            selected: selected == type,
            onTap: () => onSelected(type),
          ),
        ],
      ],
    );
  }
}

class InventoryNotice extends StatelessWidget {
  const InventoryNotice({
    super.key,
    required this.title,
    required this.message,
    this.warning = false,
  });

  final String title;
  final String message;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: warning ? AppTheme.warningBackground : AppTheme.mint,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: warning ? AppTheme.warning : AppTheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: AppTheme.bodySmall.copyWith(fontSize: 11, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class InventoryLabeledControl extends StatelessWidget {
  const InventoryLabeledControl({
    super.key,
    required this.label,
    required this.child,
  });

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

class InventoryProductSelector extends StatelessWidget {
  const InventoryProductSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final MockProduct? selected;
  final ValueChanged<MockProduct?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<MockProduct>(
      key: ValueKey(selected?.sku),
      initialValue: selected,
      isExpanded: true,
      decoration: inventoryInputDecoration(),
      style: inventoryInputStyle,
      hint: const Text('Select a product', style: inventoryInputStyle),
      items: [
        for (final product in ProductsMockData.products)
          DropdownMenuItem(
            value: product,
            child: Text(
              '${product.name} · ${product.sku}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: onChanged,
      validator: (value) => value == null ? 'Select a product' : null,
    );
  }
}

class InventoryFormScaffold extends StatelessWidget {
  const InventoryFormScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.eyebrow,
    required this.formKey,
    required this.actionLabel,
    required this.onSubmit,
    required this.child,
    this.topContent,
  });

  final String title;
  final String subtitle;
  final String eyebrow;
  final GlobalKey<FormState> formKey;
  final String actionLabel;
  final VoidCallback onSubmit;
  final Widget child;
  final Widget? topContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 7, 20, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InventoryPageHeader(
                    title: title,
                    eyebrow: eyebrow,
                    subtitle: subtitle,
                  ),
                  const SizedBox(height: 18),
                  if (topContent != null) ...[
                    topContent!,
                    const SizedBox(height: 17),
                  ],
                  Form(key: formKey, child: child),
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
            onPressed: onSubmit,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
