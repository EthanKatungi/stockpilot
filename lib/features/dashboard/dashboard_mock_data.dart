/// Display-only values until inventory storage and movements are implemented.
class DashboardMockData {
  static const greetingName = 'Ethan';
  static const stockValue = 'UGX 312,400,000';
  static const growth = '+6.4% this month';
  static const activeProducts = '18';
  static const lowStockAlerts = '7';

  static const activities = <DashboardActivity>[
    DashboardActivity(
      incoming: true,
      title: 'Received · Arabica Coffee',
      time: 'Today at 09:42',
      amount: '+2,000 kg',
    ),
    DashboardActivity(
      incoming: false,
      title: 'Issued · Packaging Bags',
      time: 'Yesterday at 16:15',
      amount: '−500 pcs',
    ),
    DashboardActivity(
      incoming: true,
      title: 'Received · Robusta Coffee',
      time: 'Yesterday at 11:08',
      amount: '+850 kg',
    ),
  ];
}

class DashboardActivity {
  const DashboardActivity({
    required this.incoming,
    required this.title,
    required this.time,
    required this.amount,
  });

  final bool incoming;
  final String title;
  final String time;
  final String amount;
}
