import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'purchase_order_draft.dart';
import 'supplier_quotation.dart';
import 'supplier_quotations_mock_data.dart';
import 'widgets/purchase_order_components.dart';

class SupplierQuotationsScreen extends StatefulWidget {
  const SupplierQuotationsScreen({super.key});

  @override
  State<SupplierQuotationsScreen> createState() =>
      _SupplierQuotationsScreenState();
}

class _SupplierQuotationsScreenState extends State<SupplierQuotationsScreen> {
  late SupplierQuotation _selectedQuote;

  @override
  void initState() {
    super.initState();
    _selectedQuote = _lowestQuote;
  }

  SupplierQuotation get _lowestQuote => SupplierQuotationsMockData.quotations
      .reduce((a, b) => a.total <= b.total ? a : b);

  void _createOrderPlaceholder() {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Creating an order from ${_selectedQuote.supplier.businessName}’s quote will be implemented later. Nothing was created.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final quotes = SupplierQuotationsMockData.quotations;
    final request = quotes.first;
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
                    title: 'Supplier Quotations',
                    subtitle: 'Compare supplier pricing and terms',
                    eyebrow: 'ADVANCED PURCHASING',
                    showBack: true,
                  ),
                  const SizedBox(height: 18),
                  const PurchaseOrderNotice(
                    title: 'Quotation comparison',
                    message: 'Compare supplier offers before deciding. These prices are mock examples.',
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${request.productName} · ${formatOrderNumber(request.quantity)} ${request.unit}',
                    style: AppTheme.sectionTitle,
                  ),
                  const SizedBox(height: 11),
                  for (final quote in quotes) ...[
                    _QuoteCard(
                      quote: quote,
                      isLowest: identical(quote, _lowestQuote),
                      isSelected: identical(quote, _selectedQuote),
                      onTap: () => setState(() => _selectedQuote = quote),
                    ),
                    const SizedBox(height: 9),
                  ],
                  const SizedBox(height: 13),
                  const Text(
                    'Evaluation guidance',
                    style: AppTheme.sectionTitle,
                  ),
                  const SizedBox(height: 10),
                  const PurchaseOrderNotice(
                    title: 'Price is only one factor',
                    message: 'Consider quality, supplier reliability and delivery lead time.',
                    warning: true,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton(
                      onPressed: _createOrderPlaceholder,
                      child: const Text('Create Order from Quote'),
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

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({
    required this.quote,
    required this.isLowest,
    required this.isSelected,
    required this.onTap,
  });

  final SupplierQuotation quote;
  final bool isLowest;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isLowest ? AppTheme.mint : Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isLowest ? Colors.white : AppTheme.mint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  quote.supplier.businessName[0],
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
                      quote.supplier.businessName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${quote.currency} ${formatOrderNumber(quote.unitPrice)} per ${quote.unit}',
                      style: AppTheme.bodySmall.copyWith(fontSize: 10),
                    ),
                    if (isLowest) ...[
                      const SizedBox(height: 4),
                      const Text(
                        'LOWEST PRICE',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${quote.currency} ${formatOrderNumber(quote.total)}',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.primary,
                      size: 16,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
