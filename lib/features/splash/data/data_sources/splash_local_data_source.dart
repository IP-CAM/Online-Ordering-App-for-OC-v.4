import 'package:flutter/foundation.dart';
import 'package:ordering_app/core/constants/db_constants.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/utils/database_helper.dart';
import 'package:ordering_app/core/common/models/category_model.dart';
import 'package:ordering_app/core/common/models/product_model.dart';

abstract interface class SplashLocalDataSource {
  Future<void> saveCategories(List<CategoryModel> categories);
  Future<void> saveProducts(List<ProductModel> products);
  Future<void> saveLastModified(DateTime lastModified);
  Future<DateTime?> getLastModified();
}

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  final DatabaseHelper _db;

  const SplashLocalDataSourceImpl(this._db);

  @override
  Future<DateTime?> getLastModified() async {
    try {
      final res = await _db.first(DbTables.lastModified);
      return res?[DbColumns.date] != null
          ? DateTime.parse(res![DbColumns.date])
          : null;
    } catch (e, stackTrace) {
      _logError('fetching last modified', e, stackTrace);
      throw DatabaseException(
          'Failed to retrieve last modified: ${e.toString()}');
    }
  }

  @override
  Future<void> saveCategories(List<CategoryModel> categories) async {
    try {
      await _db.truncate(DbTables.categories);

      await Future.wait(categories.map(
          (category) => _db.insert(DbTables.categories, category.toMap())));
    } catch (e, stackTrace) {
      _logError('saving categories', e, stackTrace);
      throw DatabaseException('Failed to save categories: ${e.toString()}');
    }
  }

  @override
  Future<void> saveLastModified(DateTime lastModified) async {
    try {
      await _db.truncate(DbTables.lastModified);
      await _db.insert(DbTables.lastModified,
          {DbColumns.date: lastModified.toIso8601String()});
    } catch (e, stackTrace) {
      _logError('saving last modified', e, stackTrace);
      throw DatabaseException('Failed to save last modified: ${e.toString()}');
    }
  }

  @override
  Future<void> saveProducts(List<ProductModel> products) async {
    try {
      await _db.truncate(DbTables.products);
      await Future.wait(products
          .map((product) => _db.insert(DbTables.products, product.toMap())));
    } catch (e, stackTrace) {
      _logError('saving products', e, stackTrace);
      throw DatabaseException('Failed to save products: ${e.toString()}');
    }
  }

  // Centralized error logging method
  void _logError(String operation, Object error, StackTrace stackTrace) {
    debugPrint('Error during $operation: $error');
    debugPrint('Stack trace: $stackTrace');
  }
}
