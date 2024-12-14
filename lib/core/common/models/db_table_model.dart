/// Model class for defining database table structure
class DbTableModel {
  /// Name of the table
  final String tableName;
  
  /// Map of column names to their SQLite definitions
  final Map<String, String> columns;

  /// Constructor for creating a table definition
  const DbTableModel({
    required this.tableName,
    required this.columns,
  });
}