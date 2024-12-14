import 'package:flutter/foundation.dart';
import 'package:ordering_app/core/common/models/db_table_model.dart';
import 'package:ordering_app/core/utils/database_helper.dart';
import 'package:ordering_app/core/database/db_column.dart';
import 'package:ordering_app/core/database/db_constants.dart';

part 'migration_tables.dart';

/// Function to execute all database migrations
Future<void> migrateDbTables() async {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  for (final table in tables) {
    await databaseHelper.createTable(
      table.tableName,
      table.columns,
    );

    debugPrint('Table created => ${table.tableName}');
  }
}

/// Function to get initial data for tables that need seeding
Map<String, List<Map<String, dynamic>>> getInitialData() {
  return {
    DbTables.theme: [
      {
        DbColumns.themeMode: DbDefaults.systemTheme,
      }
    ],
  };
}

/// Function to seed initial data
Future<void> seedInitialData() async {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final initialData = getInitialData();

  for (final entry in initialData.entries) {
    final tableName = entry.key;
    final data = entry.value;

    for (final item in data) {
      await databaseHelper.create(tableName, item);
    }
  }
}

/// Initialize database with migrations and seeding
Future<void> initializeDatabase() async {
  await migrateDbTables();
  await seedInitialData();
}
