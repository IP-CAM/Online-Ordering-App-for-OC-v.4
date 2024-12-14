part of 'migrations.dart';

/// List of table definitions with their structure providers
final List<TableDefinition> tables = [
  TableDefinition(
    name: DbTables.theme,
    columns: ThemeModel.getTableStructure(),
  ),
];

/// Table definition class to hold table information
class TableDefinition {
  final String name;
  final Map<String, DbColumn> columns;

  const TableDefinition({
    required this.name,
    required this.columns,
  });
}