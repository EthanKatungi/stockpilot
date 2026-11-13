import '../suppliers/supplier.dart';

enum PurchaseOrderStatus { draft, pending, approved, received }

extension PurchaseOrderStatusLabel on PurchaseOrderStatus {
  String get label => switch (this) {
    PurchaseOrderStatus.draft => 'Draft',
    PurchaseOrderStatus.pending => 'Pending',
    PurchaseOrderStatus.approved => 'Approved',
    PurchaseOrderStatus.received => 'Received',
  };
}

class PurchaseOrderItem {
  const PurchaseOrderItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.shortTotal,
  });

  final String productName;
  final String quantity;
  final String unitPrice;
  final String lineTotal;
  final String shortTotal;
}

class PurchaseOrder {
  const PurchaseOrder({
    required this.id,
    required this.supplier,
    required this.status,
    required this.createdAt,
    required this.expectedAt,
    required this.currency,
    required this.totalValue,
    required this.items,
  });

  final String id;
  final Supplier supplier;
  final PurchaseOrderStatus status;
  final String createdAt;
  final String expectedAt;
  final String currency;
  final String totalValue;
  final List<PurchaseOrderItem> items;
}
