import 'dart:convert';

import 'package:ordering_app/core/database/db_column.dart';
import 'package:ordering_app/core/database/db_constants.dart';
import 'package:ordering_app/features/theme/domain/entities/theme_entity.dart';

class ThemeModel extends ThemeEntity {
  ThemeModel({
    required super.isDarkMode,
  });

  // Static getter to access table name
  static String get table => DbTables.theme;

  // Static method to get table structure
  static Map<String, DbColumn> getTableStructure() {
    return {
      DbColumns.id: DbColumn.integer().autoIncrement().notNull(),
      DbColumns.themeMode: DbColumn.text().notNull().defaultValue(DbDefaults.systemTheme),
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isDarkMode': isDarkMode,
    };
  }

  factory ThemeModel.fromMap(Map<String, dynamic> map) {
    return ThemeModel(
      isDarkMode: map['isDarkMode'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ThemeModel.fromJson(String source) =>
      ThemeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
