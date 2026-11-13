import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../purchase_order.dart';

class PurchaseOrderHeader extends StatelessWidget {
  const PurchaseOrderHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.eyebrow,
    this.showBack = false,
  });

  final String title;
  final String subtitle;
  final String eyebrow;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (showBack) ...[
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.chevron_left, size: 24),
                color: AppTheme.primary,
                tooltip: 'Back',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 28,
                  height: 28,
                ),
              ),
              const SizedBox(width: 5),
            ],
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

extension PurchaseOrderStatusStyle on PurchaseOrderStatus {
  Color get foreground => switch (this) {
    PurchaseOrderStatus.draft ||
    PurchaseOrderStatus.pending => AppTheme.warning,
    PurchaseOrderStatus.approved => AppTheme.primary,
    PurchaseOrderStatus.received => AppTheme.muted,
  };

  Color get background => switch (this) {
    PurchaseOrderStatus.draft ||
    PurchaseOrderStatus.pending => AppTheme.warningBackground,
    PurchaseOrderStatus.approved => AppTheme.mint,
    PurchaseOrderStatus.received => AppTheme.background,
  };
}

class PurchaseOrderStatusBadge extends StatelessWidget {
  const PurchaseOrderStatusBadge({super.key, required this.status});

  final PurchaseOrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: status.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.foreground,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

const purchaseOrderInputStyle = TextStyle(color: AppTheme.ink, fontSize: 13);

InputDecoration purchaseOrderInputDecoration({
  String? hint,
  Widget? suffixIcon,
}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    borderSide: const BorderSide(color: AppTheme.border),
  );
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTheme.bodySmall.copyWith(fontSize: 12),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: border,
    enabledBorder: border,
    focusedBorder: border,
  );
}

class PurchaseOrderLabeledField extends StatelessWidget {
  const PurchaseOrderLabeledField({
    super.key,
    required this.label,
    required this.child,
  });

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

class PurchaseOrderNotice extends StatelessWidget {
  const PurchaseOrderNotice({
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
    final foreground = warning ? AppTheme.warning : AppTheme.primary;
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
              color: foreground,
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

class PurchaseOrderLineSummary extends StatelessWidget {
  const PurchaseOrderLineSummary({super.key, required this.item});

  final PurchaseOrderItem item;

  @override
  Widget build(BuildContext context) => Container(
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
                'Ordered ${item.quantity}',
                style: AppTheme.bodySmall.copyWith(fontSize: 10),
              ),
            ],
          ),
        ),
        Text(
          item.shortTotal,
          style: const TextStyle(
            color: AppTheme.primary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
