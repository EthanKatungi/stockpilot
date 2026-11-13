import '../movements/movements_mock_data.dart';
import '../products/products_mock_data.dart';

enum ReportPeriod { week, month, quarter }

extension ReportPeriodLabel on ReportPeriod {
  String get label => switch (this) {
    ReportPeriod.week => '7 days',
    ReportPeriod.month => '30 days',
    ReportPeriod.quarter => '90 days',
  };
}

class ReportTrendPoint {
  const ReportTrendPoint({
    required this.label,
    required this.stockIndex,
    required this.received,
    required this.issued,
  });

  final String label;
  final double stockIndex;
  final double received;
  final double issued;
}

/// Illustrative chart points; they are not calculated from stock movements.
class ReportsMockData {
  static const movementSummaries =
      <ReportPeriod, ({String received, String issued})>{
        ReportPeriod.week: (
          received: MovementsMockData.receivedThisWeek,
          issued: MovementsMockData.issuedThisWeek,
        ),
        ReportPeriod.month: (received: '48,600 kg', issued: '16,900 kg'),
        ReportPeriod.quarter: (received: '142,800 kg', issued: '54,300 kg'),
      };

  static const trends = <ReportPeriod, List<ReportTrendPoint>>{
    ReportPeriod.week: [
      ReportTrendPoint(label: 'M', stockIndex: 54, received: 42, issued: 27),
      ReportTrendPoint(label: 'T', stockIndex: 61, received: 58, issued: 35),
      ReportTrendPoint(label: 'W', stockIndex: 57, received: 37, issued: 42),
      ReportTrendPoint(label: 'T', stockIndex: 68, received: 71, issued: 24),
      ReportTrendPoint(label: 'F', stockIndex: 73, received: 63, issued: 32),
      ReportTrendPoint(label: 'S', stockIndex: 70, received: 29, issued: 18),
      ReportTrendPoint(label: 'S', stockIndex: 77, received: 45, issued: 21),
    ],
    ReportPeriod.month: [
      ReportTrendPoint(label: 'W1', stockIndex: 48, received: 45, issued: 26),
      ReportTrendPoint(label: 'W2', stockIndex: 55, received: 70, issued: 34),
      ReportTrendPoint(label: 'W3', stockIndex: 62, received: 84, issued: 43),
      ReportTrendPoint(label: 'W4', stockIndex: 59, received: 62, issued: 39),
      ReportTrendPoint(label: 'W5', stockIndex: 72, received: 92, issued: 31),
      ReportTrendPoint(label: 'W6', stockIndex: 77, received: 79, issued: 36),
    ],
    ReportPeriod.quarter: [
      ReportTrendPoint(label: 'M1', stockIndex: 43, received: 54, issued: 31),
      ReportTrendPoint(label: 'M2', stockIndex: 58, received: 68, issued: 39),
      ReportTrendPoint(label: 'M3', stockIndex: 76, received: 86, issued: 34),
    ],
  };

  static int valueOf(MockProduct product) =>
      int.parse(product.stockValue.replaceAll(RegExp(r'[^0-9]'), ''));

  static int totalValue(Iterable<MockProduct> products) =>
      products.fold(0, (total, product) => total + valueOf(product));

  static String formatUgx(int value, {bool compact = false}) {
    if (compact && value >= 1000000000) {
      return 'UGX ${(value / 1000000000).toStringAsFixed(2)}B';
    }
    if (compact && value >= 1000000) {
      return 'UGX ${(value / 1000000).toStringAsFixed(1)}M';
    }
    final grouped = value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return 'UGX $grouped';
  }
}
