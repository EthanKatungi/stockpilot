import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFF14532D);
  static const primaryDark = Color(0xFF0F3E24);
  static const primaryLight = Color(0xFF2B7547);
  static const accent = Color(0xFF16A34A);
  static const mint = Color(0xFFEAF5ED);
  static const background = Color(0xFFF7FAF7);
  static const ink = Color(0xFF17251D);
  static const muted = Color(0xFF657469);
  static const border = Color(0xFFE5ECE6);
  static const warning = Color(0xFFD7871F);
  static const warningBackground = Color(0xFFFFF5E5);
  static const packagingBackground = Color(0xFFFFF3E6);
  static const packagingInk = Color(0xFFC17C28);
  static const commodityBackground = Color(0xFFEBEDF8);
  static const commodityInk = Color(0xFF6669AB);

  static const bodySmall = TextStyle(color: muted, fontSize: 12, height: 1.3);
  static const sectionTitle = TextStyle(
    color: ink,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static ThemeData get light {
    final colors = ColorScheme.fromSeed(seedColor: primary).copyWith(
      primary: primary,
      surface: Colors.white,
      onSurface: ink,
      outline: border,
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: colors,
      scaffoldBackgroundColor: background,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: ink, height: 1.3),
      ),
    );
  }
}
