import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/movements/movements_screen.dart';
import '../../features/movements/low_stock_alerts_screen.dart';
import '../../features/products/products_screen.dart';
import '../../features/settings/settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      DashboardScreen(
        onOpenMovements: () => setState(() => currentPageIndex = 2),
        onOpenLowStockAlerts: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const LowStockAlertsScreen()),
        ),
      ),
      const ProductsScreen(),
      const MovementsScreen(),
      const SetttingsScreen(),
    ];
    return Scaffold(
      body: screens[currentPageIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 65,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppTheme.border)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavigationItem(
                icon: Icons.home_outlined,
                label: 'Home',
                selected: currentPageIndex == 0,
                onTap: () => setState(() => currentPageIndex = 0),
              ),
              _NavigationItem(
                icon: Icons.inventory_2_outlined,
                label: 'Products',
                selected: currentPageIndex == 1,
                onTap: () => setState(() => currentPageIndex = 1),
              ),
              _NavigationItem(
                icon: Icons.swap_horiz,
                label: 'Stock',
                selected: currentPageIndex == 2,
                onTap: () => setState(() => currentPageIndex = 2),
              ),
              _NavigationItem(
                icon: Icons.more_horiz,
                label: 'More',
                selected: currentPageIndex == 3,
                onTap: () => setState(() => currentPageIndex = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 63,
          height: 53,
          decoration: BoxDecoration(
            color: selected ? AppTheme.mint : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? AppTheme.primary : AppTheme.muted,
                size: 23,
              ),
              const SizedBox(height: 1),
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppTheme.primary : AppTheme.muted,
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
