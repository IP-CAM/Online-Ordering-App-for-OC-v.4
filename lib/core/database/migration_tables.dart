part of 'migrations.dart';

/// Table definition class to hold table information
class TableDefinition {
  final String name;
  final Map<String, DbColumn> columns;

  const TableDefinition({
    required this.name,
    required this.columns,
  });
}

/// List of table definitions with their structure providers
final List<TableDefinition> tables = [
  TableDefinition(
    name: DbTables.theme,
    columns: ThemeModel.getTableStructure(),
  ),
  TableDefinition(
    name: DbTables.loginInfo,
    columns: LoginInfoModel.getTableStructure(),
  ),
  TableDefinition(
    name: DbTables.categories,
    columns: CategoryModel.getTableStructure(),
  ),
  TableDefinition(
    name: DbTables.products,
    columns: ProductModel.getTableStructure(),
  ),
  TableDefinition(
    name: DbTables.lastModified,
    columns: {
      DbColumns.id: DbColumn.integer().autoIncrement().notNull(),
      DbColumns.date: DbColumn.text().notNull(),
    },
  ),
];
