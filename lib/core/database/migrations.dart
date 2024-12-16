import 'package:flutter/foundation.dart';
import 'package:ordering_app/core/database/db_column.dart';
import 'package:ordering_app/core/utils/database_helper.dart';
import 'package:ordering_app/core/constants/db_constants.dart';
import 'package:ordering_app/features/auth/data/models/login_info_model.dart';
import 'package:ordering_app/core/common/models/category_model.dart';
import 'package:ordering_app/core/common/models/product_model.dart';
import 'package:ordering_app/features/theme/data/models/theme_model.dart';

part 'migration_tables.dart';

/// Function to execute all database migrations
Future<void> migrateDbTables() async {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  for (final table in tables) {
    await databaseHelper.create(table.name, table.columns);
  }
}

/// Function to get initial data for tables that need seeding
Map<String, List<Map<String, dynamic>>> getInitialData() {
  return {};
}

/// Function to seed initial data
Future<void> seedInitialData() async {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final initialData = getInitialData();

  for (final entry in initialData.entries) {
    final tableName = entry.key;
    final data = entry.value;

    for (final item in data) {
      await databaseHelper.insert(tableName, item);
      debugPrint('Seeded $tableName with data: $item');
    }
  }
}

/// Initialize database with migrations and seeding
Future<void> initializeDatabase() async {
  await migrateDbTables();
  await seedInitialData();
}
