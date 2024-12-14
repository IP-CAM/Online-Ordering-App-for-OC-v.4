import 'package:flutter/material.dart';
import 'package:ordering_app/core/database/db_constants.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/utils/database_helper.dart';
import 'package:ordering_app/features/theme/data/models/theme_model.dart';

abstract interface class ThemeLocalDataSource {
  Future<ThemeModel> getTheme();
  Future<void> saveTheme({required bool isDarkMode});
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  static const String _darkModeValue = 'dark';
  static const String _lightModeValue = 'light';

  final DatabaseHelper _databaseHelper;

  const ThemeLocalDataSourceImpl(this._databaseHelper);

  @override
  Future<ThemeModel> getTheme() async {
    try {
      final themeRecord = await _databaseHelper.first(DbTables.theme);

      if (themeRecord == null) {
        return ThemeModel(isDarkMode: false);
      }

      return ThemeModel(
          isDarkMode: themeRecord[DbColumns.themeMode] == _darkModeValue);
    } catch (error, stackTrace) {
      debugPrint('Error retrieving theme: $error\n$stackTrace');
      throw AppException(error.toString());
    }
  }

  @override
  Future<void> saveTheme({required bool isDarkMode}) async {
    try {
      final themeValue = isDarkMode ? _darkModeValue : _lightModeValue;

      final recordCount = await _databaseHelper.count(DbTables.theme);

      if (recordCount > 0) {
        final existingRecord = await _databaseHelper.first(DbTables.theme);
        await _databaseHelper.update(DbTables.theme, existingRecord!['id'],
            {DbColumns.themeMode: themeValue});
      } else {
        await _databaseHelper
            .create(DbTables.theme, {DbColumns.themeMode: themeValue});
      }
    } catch (error, stackTrace) {
      debugPrint('Error saving theme: $error\n$stackTrace');
      throw AppException(error.toString());
    }
  }
}
