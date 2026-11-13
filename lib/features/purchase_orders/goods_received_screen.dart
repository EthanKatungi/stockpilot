import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../movements/movements_screen.dart';
import 'goods_receipt_preview.dart';
import 'purchase_order_draft.dart';
import 'purchase_orders_screen.dart';
import 'widgets/purchase_order_components.dart';

/// I20 presents a local receipt preview, not a completed inventory operation.
class GoodsReceivedScreen extends StatelessWidget {
  const GoodsReceivedScreen({
    super.key,
    required this.preview,
    this.onOpenMovements,
  });

  final GoodsReceiptPreview preview;
  final VoidCallback? onOpenMovements;

  void _backToOrders(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => PurchaseOrdersScreen(onOpenMovements: onOpenMovements),
      ),
      (route) => route.isFirst,
    );
  }

  void _viewMovements(BuildContext context) {
    if (onOpenMovements != null) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      onOpenMovements!();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: MovementsScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  const PurchaseOrderHeader(
                    title: 'Goods Received',
                    subtitle: 'Receipt preview only',
                    eyebrow: 'SUCCESS STATE',
                    showBack: true,
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppTheme.mint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppTheme.primary,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  const Center(
                    child: Text(
                      'Receipt preview ready',
                      style: TextStyle(
                        color: AppTheme.ink,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'These quantities are shown for review. No receipt, stock movement or order balance was saved or updated.',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 21),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PURCHASE ORDER',
                          style: TextStyle(
                            color: Color(0xFFD7EBDD),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .7,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          preview.order.id,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Delivery reference ${preview.deliveryReference}',
                          style: const TextStyle(
                            color: Color(0xFFD4F4DF),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 17),
                  const Text(
                    'Received quantities preview',
                    style: AppTheme.sectionTitle,
                  ),
                  const SizedBox(height: 10),
                  for (final line in preview.lines) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppTheme.border),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              line.productName,
                              style: const TextStyle(
                                color: AppTheme.ink,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${formatOrderNumber(line.quantity)} ${line.unit}',
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 9),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton(
                      onPressed: () => _viewMovements(context),
                      child: const Text('View Stock Movements'),
                    ),
                  ),
                  const SizedBox(height: 9),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () => _backToOrders(context),
                      child: const Text('Back to Purchase Orders'),
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
