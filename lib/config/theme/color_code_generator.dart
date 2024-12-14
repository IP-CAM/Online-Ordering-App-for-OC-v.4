import 'package:flutter/material.dart';

/// Utility class to generate color variations from base colors
class ColorGenerator {
  /// Generates a MaterialColor swatch from a base color
  static MaterialColor createMaterialColor(Color color) {
    List<double> strengths = <double>[.05, .1, .2, .3, .4, .5, .6, .7, .8, .9];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 0; i < strengths.length; i++) {
      final double ds = 0.5 - strengths[i];
      swatch[(strengths[i] * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }

  /// Generates a complementary color
  static Color generateComplementaryColor(Color color) {
    final hslColor = HSLColor.fromColor(color);
    return hslColor.withHue((hslColor.hue + 180) % 360).toColor();
  }

  /// Generates an analogous color palette
  static List<Color> generateAnalogousColors(Color color, {int count = 2}) {
    final List<Color> colors = [];
    final hslColor = HSLColor.fromColor(color);
    const double hueStep = 30;

    for (int i = 1; i <= count; i++) {
      colors.add(
        hslColor.withHue((hslColor.hue + (hueStep * i)) % 360).toColor(),
      );
    }

    return colors;
  }

  /// Generates a lighter shade of the color
  static Color generateLighterShade(Color color, {double amount = 0.1}) {
    final hslColor = HSLColor.fromColor(color);
    return hslColor
        .withLightness((hslColor.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Generates a darker shade of the color
  static Color generateDarkerShade(Color color, {double amount = 0.1}) {
    final hslColor = HSLColor.fromColor(color);
    return hslColor
        .withLightness((hslColor.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Generates a color with adjusted saturation
  static Color generateSaturationVariant(Color color, {double amount = 0.1}) {
    final hslColor = HSLColor.fromColor(color);
    return hslColor
        .withSaturation((hslColor.saturation + amount).clamp(0.0, 1.0))
        .toColor();
  }
}