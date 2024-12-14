part of 'migrations.dart';

/// List of all database tables with their structure
final List<DbTableModel> tables = [
  DbTableModel(
    tableName: DbTables.theme,
    columns: {
      DbColumns.id: DbColumn.integer().autoIncrement().toString(),
      DbColumns.themeMode: DbColumn.text()
          .notNull()
          .defaultValue(DbDefaults.systemTheme)
          .toString(),
    },
  ),
  // Example of another table:
  // DbTableModel(
  //   tableName: DbTables.users,
  //   columns: {
  //     DbColumns.id: DbColumn.integer().autoIncrement().toString(),
  //     DbColumns.name: DbColumn.text().notNull().toString(),
  //     DbColumns.email: DbColumn.text().notNull().unique().toString(),
  //     DbColumns.createdAt: DbColumn.datetime().notNull().toString(),
  //   },
  // ),
];