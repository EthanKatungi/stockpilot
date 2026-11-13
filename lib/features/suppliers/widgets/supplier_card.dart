import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../supplier.dart';

class SupplierCard extends StatelessWidget {
  const SupplierCard({super.key, required this.supplier, required this.onTap});

  final Supplier supplier;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = supplier.status == SupplierStatus.active;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.border),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? AppTheme.mint : AppTheme.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  supplier.initials,
                  style: TextStyle(
                    color: active ? AppTheme.primary : AppTheme.muted,
                    fontSize: 13,
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
                      supplier.businessName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${supplier.city} · ${supplier.orderCount} orders',
                      style: AppTheme.bodySmall.copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${supplier.contactPerson} · ${supplier.phone}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.bodySmall.copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      supplier.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.bodySmall.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              Text(
                active ? 'Active' : 'Inactive',
                style: TextStyle(
                  color: active ? AppTheme.primary : AppTheme.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
