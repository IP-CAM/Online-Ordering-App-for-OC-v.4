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
      'products': products != null ? json.encode(products) : null,
      'parentId': parentId,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    // Helper function to safely decode JSON string and convert to List<int>
    List<int>? decodeProductList(dynamic value) {
      if (value == null) return null;
      if (value is String) {
        try {
          final decoded = json.decode(value);
          if (decoded is List) {
            return decoded.map((e) => int.parse(e.toString())).toList();
          }
        } catch (e) {
          return null;
        }
      }
      if (value is List) {
        return value.map((e) => int.parse(e.toString())).toList();
      }
      return null;
    }

    return CategoryModel(
      categoryId: (map['categoryId'] ?? 0) as int,
      name: (map['name'] ?? '') as String,
      description: map['description'] as String?,
      image: map['image'] as String?,
      sortOrder: (map['sortOrder'] ?? 0) as int,
      status: map['status'] == 1, // Convert integer to boolean
      productCount: (map['productCount'] ?? 0) as int,
      products: decodeProductList(map['products']),
      parentId: (map['parentId'] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}