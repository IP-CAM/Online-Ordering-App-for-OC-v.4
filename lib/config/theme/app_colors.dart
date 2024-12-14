import 'package:flutter/material.dart';
import 'package:ordering_app/config/theme/color_code_generator.dart';

/// Configurable color palette for the application
class AppColors {
  /// Primary color of the application
  final Color primary;

  /// Secondary color of the application
  final Color secondary;

  /// Generated Material color swatch from primary color
  late final MaterialColor primarySwatch;

  /// Generated complementary colors
  late final Color complementary;

  /// Generated analogous colors
  late final List<Color> analogousColors;

  /// Error color
  late final Color error;

  /// Success color
  late final Color success;

  /// Warning color
  late final Color warning;

  /// Info color
  late final Color info;

  /// Text colors
  late final Color textPrimary;
  late final Color textSecondary;
  late final Color textDisabled;

  /// Background colors
  late final Color backgroundLight;
  late final Color backgroundDark;
  late final Color surfaceLight;
  late final Color surfaceDark;

  /// Border colors
  late final Color borderLight;
  late final Color borderDark;

  // Transparent
  late Color transparent;
  late Color semiTransparent;

  AppColors({
    required this.primary,
    required this.secondary,
  }) {
    _generateColors();
  }

  void _generateColors() {
    // Generate primary swatch
    primarySwatch = ColorGenerator.createMaterialColor(primary);

    // Generate complementary and analogous colors
    complementary = ColorGenerator.generateComplementaryColor(primary);
    analogousColors = ColorGenerator.generateAnalogousColors(primary);

    // Generate semantic colors
    error = const Color(0xFFB00020);
    success = ColorGenerator.generateSaturationVariant(
      const Color(0xFF4CAF50),
      amount: 0.1,
    );
    warning = ColorGenerator.generateSaturationVariant(
      const Color(0xFFFFC107),
      amount: 0.1,
    );
    info = ColorGenerator.generateLighterShade(primary, amount: 0.1);

    // Generate text colors
    textPrimary = ColorGenerator.generateDarkerShade(
      const Color(0xFF000000),
      amount: 0.1,
    );
    textSecondary = const Color(0xFF757575);
    textDisabled = const Color(0xFFBDBDBD);

    // Generate background colors
    backgroundLight = const Color(0xFFFFFFFF);
    backgroundDark = const Color(0xFF121212);
    surfaceLight = const Color(0xFFFFFFFF);
    surfaceDark = const Color(0xFF1E1E1E);

    // Generate border colors
    borderLight = const Color(0xFFE0E0E0);
    borderDark = const Color(0xFF424242);

// Transparent
    transparent = const Color.fromRGBO(0, 0, 0, 0);
    semiTransparent = const Color.fromRGBO(0, 0, 0, 0.479);
  }
}
