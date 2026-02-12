import 'package:flutter/material.dart';

class AppTheme {
  static const Color bg = Color(0xFF0D0D0D);
  static const Color infected = Color(0xFFFF2442);
  static const Color suspicious = Color(0xFFF6C945);
  static const Color isolated = Color(0xFF23A9FF);
  static const Color safe = Color(0xFF2AD87A);
  static const Color panel = Color(0xFF151515);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: infected,
        secondary: suspicious,
        surface: panel,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'monospace',
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'monospace',
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'monospace',
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: infected,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      cardTheme: CardTheme(
        color: panel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
