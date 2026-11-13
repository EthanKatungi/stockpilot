import '../movements/movements_mock_data.dart';

/// Reads the existing display-only movement dates for local report filtering.
class MovementReportData {
  static const _months = <String>[
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

  static DateTime? dateOf(MockMovement movement) {
    final match = RegExp(r'(\d{1,2})\s+([A-Za-z]{3})\s+(\d{4})')
        .firstMatch(movement.occurredAt);
    if (match == null) return null;
    final month = _months.indexOf(match.group(2)!);
    if (month < 0) return null;
    return DateTime(
      int.parse(match.group(3)!),
      month + 1,
      int.parse(match.group(1)!),
    );
  }

  static String dateLabel(DateTime date) =>
      '${date.day} ${_months[date.month - 1]} ${date.year}';
}
