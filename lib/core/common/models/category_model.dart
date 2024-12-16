import 'dart:convert';

import 'package:ordering_app/core/common/entities/category_entity.dart';
import 'package:ordering_app/core/constants/db_constants.dart';
import 'package:ordering_app/core/database/db_column.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.categoryId,
    required super.name,
    required super.description,
    required super.image,
    required super.sortOrder,
    required super.status,
    required super.productCount,
    required super.products,
    required super.parentId,
  });

  static String get table => DbTables.categories;

  static Map<String, DbColumn> getTableStructure() {
    return {
      DbColumns.id: DbColumn.integer().autoIncrement().notNull(),
      DbColumns.categoryId: DbColumn.integer().notNull(),
      DbColumns.name: DbColumn.text().notNull(),
      DbColumns.description: DbColumn.text(),
      DbColumns.image: DbColumn.text(),
      DbColumns.sortOrder: DbColumn.integer(),
      DbColumns.status: DbColumn.integer(), // boolean stored as integer
      DbColumns.productCount: DbColumn.integer(),
      DbColumns.products: DbColumn.text(), // stored as JSON string
      DbColumns.parentId: DbColumn.integer(),
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'image': image,
      'sortOrder': sortOrder,
      'status': status ? 1 : 0, // Convert boolean to integer for SQLite
      'productCount': productCount,
      'products': products != null ? json.encode(products) : null, // Encode list as JSON string
      'parentId': parentId,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    // Helper function to safely decode JSON string or use default value
    T decodeOrDefault<T>(dynamic value, T defaultValue, T Function(dynamic) converter) {
      if (value == null) return defaultValue;
      if (value is String) {
        try {
          final decoded = json.decode(value);
          return converter(decoded);
        } catch (e) {
          return defaultValue;
        }
      }
      return converter(value);
    }

    return CategoryModel(
      categoryId: (map['categoryId'] ?? 0) as int,
      name: (map['name'] ?? '') as String,
      description: map['description'] as String?,
      image: map['image'] as String?,
      sortOrder: (map['sortOrder'] ?? 0) as int,
      status: map['status'] == 1, // Convert integer to boolean
      productCount: (map['productCount'] ?? 0) as int,
      products: decodeOrDefault<List<String>?>(
        map['products'],
        null,
        (dynamic value) => value != null 
            ? (value as List).map((e) => e.toString()).toList()
            : null,
      ),
      parentId: (map['parentId'] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}