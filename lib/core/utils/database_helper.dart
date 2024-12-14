import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

/// DatabaseHelper class provides ORM-like functionality for SQLite in Flutter

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  /// Factory constructor to maintain a singleton instance
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  /// Get database instance, creates one if it doesn't exist
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    // Example table creation - modify according to your needs
    await db.execute('''
      CREATE TABLE IF NOT EXISTS models (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  /// Create a new table in the database
  /// 
  /// Parameters:
  /// - tableName: name of the table to create
  /// - columns: map of column definitions where key is column name and value is column type/constraints
  /// 
  /// Example:
  /// ```dart
  /// await db.createTable('users', {
  ///   'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
  ///   'name': 'TEXT NOT NULL',
  ///   'email': 'TEXT UNIQUE',
  ///   'age': 'INTEGER'
  /// });
  /// ```
  Future<void> createTable(
    String tableName,
    Map<String, String> columns,
  ) async {
    final db = await database;
    
    // Build column definitions
    final columnDefs = columns.entries.map((e) => '${e.key} ${e.value}').join(', ');
    
    // Add timestamp columns if not explicitly defined
    final hasCreatedAt = columns.containsKey('created_at');
    final hasUpdatedAt = columns.containsKey('updated_at');
    
    final timestamps = [
      if (!hasCreatedAt) 'created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP',
      if (!hasUpdatedAt) 'updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP',
    ].join(', ');
    
    final fullColumnDefs = [
      columnDefs,
      if (timestamps.isNotEmpty) timestamps,
    ].join(', ');

    // Create table query
    final sql = '''
      CREATE TABLE IF NOT EXISTS $tableName (
        $fullColumnDefs
      )
    ''';

    await db.execute(sql);
  }

  /// Find a record by its primary key
  Future<Map<String, dynamic>?> find(String table, int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return maps.first;
  }

  /// Get all records from a table
  Future<List<Map<String, dynamic>>> all(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// Insert a new record
  Future<int> create(String table, Map<String, dynamic> data) async {
    final db = await database;
    data['created_at'] = DateTime.now().toIso8601String();
    data['updated_at'] = DateTime.now().toIso8601String();
    return await db.insert(table, data);
  }

  /// Update an existing record
  Future<int> update(String table, int id, Map<String, dynamic> data) async {
    final db = await database;
    data['updated_at'] = DateTime.now().toIso8601String();
    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete a record
  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Count records in a table
  Future<int> count(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    final result = await db.query(
      table,
      columns: ['COUNT(*) as count'],
      where: where,
      whereArgs: whereArgs,
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// First record matching the criteria
  Future<Map<String, dynamic>?> first(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return maps.first;
  }

  /// Get records with pagination
  Future<Map<String, dynamic>> paginate(
    String table, {
    int page = 1,
    int perPage = 10,
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
  }) async {
    final offset = (page - 1) * perPage;

    final total = await count(table, where: where, whereArgs: whereArgs);
    final data = await all(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: perPage,
      offset: offset,
    );

    return {
      'total': total,
      'per_page': perPage,
      'current_page': page,
      'last_page': (total / perPage).ceil(),
      'data': data,
    };
  }

  /// Raw SQL query
  Future<List<Map<String, dynamic>>> raw(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }

  /// Begin a transaction
  Future<void> transaction(Future<void> Function(Transaction) action) async {
    final db = await database;
    await db.transaction((txn) async {
      await action(txn);
    });
  }

  /// Check if a record exists
  Future<bool> exists(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final count = await this.count(table, where: where, whereArgs: whereArgs);
    return count > 0;
  }

  /// Close the database connection
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}