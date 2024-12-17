import 'package:flutter/foundation.dart';
import 'package:ordering_app/core/common/models/category_model.dart';
import 'package:ordering_app/core/common/models/product_model.dart';
import 'package:ordering_app/core/constants/db_constants.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/utils/database_helper.dart';

abstract interface class HomeLocalDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<List<ProductModel>> getProductsByIds({
    required List<int> productIds,
  });
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final DatabaseHelper _databaseHelper;

  const HomeLocalDataSourceImpl({required DatabaseHelper db})
      : _databaseHelper = db;

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final categoryList = await _databaseHelper.all(DbTables.categories);

      return categoryList.map((row) => CategoryModel.fromMap(row)).toList();
    } catch (error, stackTrace) {
      _logError('retrieving categories', error, stackTrace);
      throw DatabaseException('Failed to retrieve categories: $error');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByIds({
    required List<int> productIds,
  }) async {
    try {
      final productList = await _databaseHelper.whereIn(
        DbTables.products,
        column: DbColumns.productId,
        productIds,
        orderBy: DbColumns.sortOrder,
      );

      return productList.map((row) => ProductModel.fromMap(row)).toList();
    } catch (error, stackTrace) {
      _logError('retrieving products', error, stackTrace);
      throw DatabaseException('Failed to retrieve products: $error');
    }
  }

  void _logError(String operation, Object error, StackTrace stackTrace) {
    debugPrint('Error during $operation: $error');
    debugPrint('Stack trace: $stackTrace');
  }
}
