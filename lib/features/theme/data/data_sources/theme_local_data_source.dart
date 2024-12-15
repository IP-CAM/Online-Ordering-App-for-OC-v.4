import 'package:flutter/material.dart';
import 'package:ordering_app/core/constants/db_constants.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/utils/database_helper.dart';
import 'package:ordering_app/features/theme/data/models/theme_model.dart';

/// Contract for managing theme preferences in local storage
abstract interface class ThemeLocalDataSource {
  /// Retrieves the current theme settings
  /// Throws [DatabaseException] if retrieval fails
  Future<ThemeModel> getTheme();

  /// Saves the theme preference
  /// [isDarkMode] determines whether to save dark or light theme
  /// Throws [DatabaseException] if save fails
  Future<void> saveTheme({required bool isDarkMode});
}

/// SQLite implementation of [ThemeLocalDataSource]
class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  /// Storage values for theme modes
  static const _ThemeValues _values = _ThemeValues(
    dark: 'dark',
    light: 'light',
  );

  final DatabaseHelper _db;

  /// Creates a data source instance with the provided [DatabaseHelper]
  const ThemeLocalDataSourceImpl({
    required DatabaseHelper databaseHelper,
  }) : _db = databaseHelper;

  @override
  Future<ThemeModel> getTheme() async {
    try {
      final record = await _db.first(DbTables.theme);

      return ThemeModel(
        isDarkMode: record?[DbColumns.themeMode] == _values.dark,
      );
    } catch (error, stackTrace) {
      _logError('retrieving', error, stackTrace);
      throw _mapToException(error);
    }
  }

  @override
  Future<void> saveTheme({required bool isDarkMode}) async {
    try {
      final themeValue = isDarkMode ? _values.dark : _values.light;

      await _db.transaction((txn) async {
        await txn.delete(DbTables.theme);
        await txn.insert(DbTables.theme, {
          DbColumns.themeMode: themeValue,
        });
      });
    } catch (error, stackTrace) {
      _logError('saving', error, stackTrace);
      throw _mapToException(error);
    }
  }

  /// Logs database operation errors
  void _logError(String operation, Object error, StackTrace stackTrace) {
    debugPrint('Error $operation theme: $error');
    debugPrint('Stack trace: $stackTrace');
  }

  /// Maps various error types to [DatabaseException]
  DatabaseException _mapToException(Object error) {
    final message = error is DatabaseException
        ? error.message
        : 'Database operation failed: ${error.toString()}';

    return DatabaseException(message);
  }
}

/// Immutable container for theme value constants
class _ThemeValues {
  final String dark;
  final String light;

  const _ThemeValues({
    required this.dark,
    required this.light,
  });
}
