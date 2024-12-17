import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:ordering_app/core/database/db_column.dart';

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
    debugPrint('DatabaseHelper: Initializing database at path: $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    debugPrint(
        'DatabaseHelper: Creating database tables for version: $version');
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
  /// - columns: map of column definitions where key is column name and value is DbColumn object
  ///
  /// Example:
  /// ```dart
  /// await db.create('users', {
  ///   'id': DbColumn.integer().autoIncrement(),
  ///   'name': DbColumn.text().notNull(),
  ///   'email': DbColumn.text().unique(),
  ///   'age': DbColumn.integer()
  /// });
  /// ```
  Future<void> create(
    String tableName,
    Map<String, DbColumn> columns,
  ) async {
    final db = await database;
    debugPrint('DatabaseHelper: Creating table: $tableName');

    // Build column definitions
    final columnDefs =
        columns.entries.map((e) => '${e.key} ${e.value.toString()}').join(', ');

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
    debugPrint('DatabaseHelper: Table created successfully: $tableName');
  }

  /// Find a record by its primary key
  Future<Map<String, dynamic>?> find(String table, int id) async {
    final db = await database;
    debugPrint('DatabaseHelper: Finding record in $table with id: $id');

    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      debugPrint('DatabaseHelper: Record not found in $table with id: $id');
      return null;
    }

    debugPrint('DatabaseHelper: Found record in $table with id: $id');
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
    debugPrint(
        'DatabaseHelper: Fetching records from $table - where: $where, whereArgs: $whereArgs, orderBy: $orderBy, limit: $limit, offset: $offset');

    final results = await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    debugPrint(
        'DatabaseHelper: Retrieved ${results.length} records from $table');
    return results;
  }

  /// Insert a new record
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    debugPrint('DatabaseHelper: Inserting record into $table: $data');

    data['created_at'] = DateTime.now().toIso8601String();
    data['updated_at'] = DateTime.now().toIso8601String();

    final id = await db.insert(table, data);
    debugPrint('DatabaseHelper: Inserted record in $table with id: $id');
    return id;
  }

  /// Update an existing record
  Future<int> update(String table, int id, Map<String, dynamic> data) async {
    final db = await database;
    debugPrint(
        'DatabaseHelper: Updating record in $table with id: $id - data: $data');

    data['updated_at'] = DateTime.now().toIso8601String();
    final result = await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );

    debugPrint('DatabaseHelper: Updated $result record(s) in $table');
    return result;
  }

  /// Delete a record
  Future<int> delete(String table, int id) async {
    final db = await database;
    debugPrint('DatabaseHelper: Deleting record from $table with id: $id');

    final result = await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );

    debugPrint('DatabaseHelper: Deleted $result record(s) from $table');
    return result;
  }

  /// Count records in a table
  Future<int> count(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    debugPrint(
        'DatabaseHelper: Counting records in $table - where: $where, whereArgs: $whereArgs');

    final result = await db.query(
      table,
      columns: ['COUNT(*) as count'],
      where: where,
      whereArgs: whereArgs,
    );

    final count = Sqflite.firstIntValue(result) ?? 0;
    debugPrint('DatabaseHelper: Found $count records in $table');
    return count;
  }

  /// First record matching the criteria
  Future<Map<String, dynamic>?> first(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
  }) async {
    final db = await database;
    debugPrint(
        'DatabaseHelper: Finding first record in $table - where: $where, whereArgs: $whereArgs, orderBy: $orderBy');

    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: 1,
    );

    if (maps.isEmpty) {
      debugPrint('DatabaseHelper: No records found in $table');
      return null;
    }

    debugPrint('DatabaseHelper: Found first record in $table');
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
    debugPrint(
        'DatabaseHelper: Paginating records in $table - page: $page, perPage: $perPage, where: $where, whereArgs: $whereArgs, orderBy: $orderBy');

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

    final lastPage = (total / perPage).ceil();

    debugPrint(
        'DatabaseHelper: Pagination results for $table - total: $total, currentPage: $page, lastPage: $lastPage');

    return {
      'total': total,
      'per_page': perPage,
      'current_page': page,
      'last_page': lastPage,
      'data': data,
    };
  }

  /// Raw SQL query
  Future<List<Map<String, dynamic>>> raw(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    final db = await database;
    debugPrint(
        'DatabaseHelper: Executing raw SQL query: $sql with arguments: $arguments');

    final results = await db.rawQuery(sql, arguments);
    debugPrint('DatabaseHelper: Raw query returned ${results.length} results');
    return results;
  }

  /// Begin a transaction
  Future<void> transaction(Future<void> Function(Transaction) action) async {
    final db = await database;
    debugPrint('DatabaseHelper: Beginning database transaction');

    await db.transaction((txn) async {
      try {
        await action(txn);
        debugPrint('DatabaseHelper: Transaction completed successfully');
      } catch (e) {
        debugPrint('DatabaseHelper: Transaction failed: $e');
        rethrow;
      }
    });
  }

  /// Check if a record exists
  Future<bool> exists(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    debugPrint(
        'DatabaseHelper: Checking existence in $table - where: $where, whereArgs: $whereArgs');

    final count = await this.count(table, where: where, whereArgs: whereArgs);
    final exists = count > 0;

    debugPrint(
        'DatabaseHelper: Record existence check in $table returned: $exists');
    return exists;
  }

  /// Close the database connection
  Future<void> close() async {
    if (_database != null) {
      debugPrint('DatabaseHelper: Closing database connection');
      await _database!.close();
      _database = null;
      debugPrint('DatabaseHelper: Database connection closed');
    }
  }

  /// Truncate a table - removes all records
  ///
  /// Parameters:
  /// - table: name of the table to truncate
  /// - resetIdentity: if true, resets the auto-increment counter (default: true)
  ///
  /// Returns the number of rows that were deleted
  Future<int> truncate(String table, {bool resetIdentity = true}) async {
    debugPrint('DatabaseHelper: Truncating table: $table');

    int deletedRows = 0;

    await transaction((txn) async {
      // Delete all records
      deletedRows = await txn.delete(table);

      // Reset the auto-increment counter if requested
      if (resetIdentity) {
        await txn
            .execute('DELETE FROM sqlite_sequence WHERE name = ?', [table]);
      }
    });

    debugPrint('DatabaseHelper: Truncated $deletedRows rows from $table');
    return deletedRows;
  }

  /// Get records by a list of IDs with ordering support
  ///
  /// Parameters:
  /// - table: name of the table to query
  /// - ids: List of IDs to fetch
  /// - idColumn: Column to use for WHERE IN clause (defaults to 'id')
  /// - orderBy: Optional column name to order by
  /// - orderDirection: Optional order direction ('asc' or 'desc', defaults to 'asc')
  ///
  /// Example usage:
  /// ```dart
  /// // Basic usage
  /// final items = await db.whereIn('products', [1, 2, 3, 4]);
  ///
  /// // With custom ordering
  /// final items = await db.whereIn(
  ///   'products',
  ///   [1, 2, 3, 4],
  ///   orderBy: 'sort_order',
  ///   orderDirection: 'desc'
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> whereIn(
    String table,
    List<dynamic> ids, {
    String column = 'id',
    String? orderBy,
    String orderDirection = 'asc',
  }) async {
    debugPrint('DatabaseHelper: Fetching records from $table with ids: $ids');

    if (ids.isEmpty) {
      return [];
    }

    // Create placeholders for the SQL query
    final placeholders = List.filled(ids.length, '?').join(',');
    final where = '$column IN ($placeholders)';

    // Build order by clause if specified
    final orderByClause =
        orderBy != null ? '$orderBy ${orderDirection.toLowerCase()}' : null;

    return all(
      table,
      where: where,
      whereArgs: ids,
      orderBy: orderByClause,
    );
  }

  /// Build and execute a where query with multiple conditions
  ///
  /// Parameters:
  /// - table: name of the table to query
  /// - conditions: Map of column names and their values to search for
  /// - operator: The operator to use between conditions ('AND' or 'OR'), defaults to 'AND'
  /// - orderBy: Optional order by clause
  /// - limit: Optional limit on number of results
  /// - offset: Optional offset for pagination
  ///
  /// Example usage:
  /// ```dart
  /// // Single condition
  /// final results = await db.where('users', {'status': 'active'});
  ///
  /// // Multiple conditions with AND
  /// final results = await db.where('users', {
  ///   'status': 'active',
  ///   'age': 25
  /// });
  ///
  /// // With list of IDs
  /// final results = await db.where('users', {
  ///   'id': [1, 2, 3, 4],
  ///   'status': 'active'
  /// });
  /// ```
  Future<List<Map<String, dynamic>>> where(
    String table,
    Map<String, dynamic> conditions, {
    String operator = 'AND',
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    debugPrint(
        'DatabaseHelper: Building where query for $table with conditions: $conditions');

    if (conditions.isEmpty) {
      return all(table, orderBy: orderBy, limit: limit, offset: offset);
    }

    final List<String> whereClauses = [];
    final List<dynamic> whereArgs = [];

    // Handle different types of conditions
    conditions.forEach((key, value) {
      if (value is List) {
        if (value.isEmpty) {
          // Handle empty list case
          whereClauses.add('1 = 0'); // This will return no results
        } else {
          // Handle IN clause
          final placeholders = List.filled(value.length, '?').join(',');
          whereClauses.add('$key IN ($placeholders)');
          whereArgs.addAll(value);
        }
      } else if (value == null) {
        // Handle NULL check
        whereClauses.add('$key IS NULL');
      } else if (value is String &&
          (value.contains('%') || value.contains('_'))) {
        // Handle LIKE clause
        whereClauses.add('$key LIKE ?');
        whereArgs.add(value);
      } else {
        // Handle regular equality
        whereClauses.add('$key = ?');
        whereArgs.add(value);
      }
    });

    final whereClause = whereClauses.join(' $operator ');

    debugPrint(
        'DatabaseHelper: Generated where clause: $whereClause with args: $whereArgs');

    return all(
      table,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }
}
