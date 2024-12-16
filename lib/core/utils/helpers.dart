  import 'dart:convert';

double toDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

      T decodeOrDefault<T>(dynamic value, T defaultValue, T Function(dynamic) converter) {
      if (value == null) return defaultValue;
      if (value is String) {
        try {
          final decoded = json.decode(value);
          return converter(decoded);
        } catch (e) {
          return defaultValue;
        }
      }
      return converter(value);
    }