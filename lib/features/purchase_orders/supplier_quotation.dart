import '../suppliers/supplier.dart';

/// Display-only supplier offer for one requested product and quantity.
class SupplierQuotation {
  const SupplierQuotation({
    required this.supplier,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    this.currency = 'UGX',
  });

  final Supplier supplier;
  final String productName;
  final double quantity;
  final String unit;
  final double unitPrice;
  final String currency;

  double get total => quantity * unitPrice;
}
