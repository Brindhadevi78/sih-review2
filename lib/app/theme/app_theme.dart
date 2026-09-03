import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // --- Palette ---
  static const Color _primary = Color(0xFF7B6FA0);      // soft violet
  static const Color _primaryLight = Color(0xFFB39DDB); // lavender
  static const Color _secondary = Color(0xFFE8A598);    // warm blush
  static const Color _background = Color(0xFFF9F6F2);   // warm off-white
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _onPrimary = Color(0xFFFFFFFF);
  static const Color _onBackground = Color(0xFF3D3450); // deep muted purple
  static const Color _onSurface = Color(0xFF3D3450);
  static const Color _error = Color(0xFFB00020);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: _primary,
          onPrimary: _onPrimary,
          primaryContainer: _primaryLight,
          onPrimaryContainer: _onBackground,
          secondary: _secondary,
          onSecondary: _onBackground,
          secondaryContainer: Color(0xFFFCE4EC),
          onSecondaryContainer: _onBackground,
          surface: _surface,
          onSurface: _onSurface,
          error: _error,
          onError: _onPrimary,
        ),
        scaffoldBackgroundColor: _background,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: _surface,
          shadowColor: _primary.withAlpha(40),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _background,
          foregroundColor: _onBackground,
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: _onBackground,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: _onBackground,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: _onBackground,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: _onSurface,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: _onSurface,
            height: 1.5,
          ),
          labelLarge: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            foregroundColor: _onPrimary,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD1C4E9)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD1C4E9)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _primary, width: 1.5),
          ),
        ),
      );
}
