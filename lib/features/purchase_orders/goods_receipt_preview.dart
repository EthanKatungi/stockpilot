import 'purchase_order.dart';

/// Local display data passed from the receipt form. No record is saved.
class GoodsReceiptPreview {
  const GoodsReceiptPreview({
    required this.order,
    required this.deliveryReference,
    required this.receivedAt,
    required this.lines,
  });

  final PurchaseOrder order;
  final String deliveryReference;
  final DateTime receivedAt;
  final List<ReceiptPreviewLine> lines;
}

class ReceiptPreviewLine {
  const ReceiptPreviewLine({
    required this.productName,
    required this.quantity,
    required this.unit,
  });

  final String productName;
  final double quantity;
  final String unit;
}
