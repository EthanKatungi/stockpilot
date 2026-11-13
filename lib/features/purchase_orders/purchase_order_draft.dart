import '../products/products_mock_data.dart';
import '../suppliers/supplier.dart';

/// Temporary UI state for the two-step order form. It is never persisted.
class PurchaseOrderDraft {
  PurchaseOrderDraft()
    : orderDate = _today(),
      expectedDate = _today().add(const Duration(days: 7));

  Supplier? supplier;
  DateTime orderDate;
  DateTime expectedDate;
  String currency = 'UGX';
  String notes = '';
  final List<DraftOrderLine> items = [];

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);
}

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

class DraftOrderLine {
  const DraftOrderLine({
    required this.product,
    required this.quantity,
    required this.unitPrice,
  });

  final MockProduct product;
  final double quantity;
  final double unitPrice;

  double get subtotal => quantity * unitPrice;
}

String formatOrderDate(DateTime date) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String formatOrderNumber(double value, {bool showFraction = false}) {
  final fixed = value.toStringAsFixed(
    showFraction || value != value.truncateToDouble() ? 2 : 0,
  );
  final parts = fixed.split('.');
  final digits = parts.first;
  final grouped = digits.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return parts.length == 2 ? '$grouped.${parts.last}' : grouped;
}
