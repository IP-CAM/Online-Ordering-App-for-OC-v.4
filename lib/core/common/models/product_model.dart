import 'dart:convert';

import 'package:ordering_app/core/common/entities/product_entity.dart';
import 'package:ordering_app/core/common/entities/product_option_entity.dart';
import 'package:ordering_app/core/constants/db_constants.dart';
import 'package:ordering_app/core/database/db_column.dart';
import 'package:ordering_app/core/common/models/product_option_model.dart';
import 'package:ordering_app/core/utils/helpers.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.productId,
    required super.name,
    required super.description,
    required super.metaTitle,
    required super.metaDescription,
    required super.metaKeyword,
    required super.model,
    required super.sku,
    required super.upc,
    required super.ean,
    required super.jan,
    required super.isbn,
    required super.mpn,
    required super.location,
    required super.quantity,
    required super.stockStatus,
    required super.image,
    required super.additionalImages,
    required super.price,
    required super.special,
    required super.taxClassId,
    required super.dateAvailable,
    required super.weight,
    required super.weightClassId,
    required super.length,
    required super.width,
    required super.height,
    required super.lengthClassId,
    required super.minimum,
    required super.sortOrder,
    required super.status,
    required super.dateAdded,
    required super.dateModified,
    required super.viewed,
    required super.options,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'name': name,
      'description': description,
      'metaTitle': metaTitle,
      'metaDescription': metaDescription,
      'metaKeyword': metaKeyword,
      'model': model,
      'sku': sku,
      'upc': upc,
      'ean': ean,
      'jan': jan,
      'isbn': isbn,
      'mpn': mpn,
      'location': location,
      'quantity': quantity,
      'stockStatus': stockStatus,
      'image': image,
      'additionalImages': json.encode(additionalImages),
      'price': price,
      'special': special,
      'taxClassId': taxClassId,
      'dateAvailable': dateAvailable,
      'weight': weight,
      'weightClassId': weightClassId,
      'length': length,
      'width': width,
      'height': height,
      'lengthClassId': lengthClassId,
      'minimum': minimum,
      'sortOrder': sortOrder,
      'status': status ? 1 : 0,
      'dateAdded': dateAdded,
      'dateModified': dateModified,
      'viewed': viewed,
      'options': json.encode(options.map((x) => (x as ProductOptionModel).toMap()).toList()),
    };
  }

  static String get table => DbTables.products;

  static Map<String, DbColumn> getTableStructure() {
    return {
      DbColumns.id: DbColumn.integer().autoIncrement().notNull(),
      DbColumns.productId: DbColumn.integer().notNull(),
      DbColumns.name: DbColumn.text().notNull(),
      DbColumns.description: DbColumn.text(),
      DbColumns.metaTitle: DbColumn.text(),
      DbColumns.metaDescription: DbColumn.text(),
      DbColumns.metaKeyword: DbColumn.text(),
      DbColumns.model: DbColumn.text(),
      DbColumns.sku: DbColumn.text(),
      DbColumns.upc: DbColumn.text(),
      DbColumns.ean: DbColumn.text(),
      DbColumns.jan: DbColumn.text(),
      DbColumns.isbn: DbColumn.text(),
      DbColumns.mpn: DbColumn.text(),
      DbColumns.location: DbColumn.text(),
      DbColumns.quantity: DbColumn.integer(),
      DbColumns.stockStatus: DbColumn.text(),
      DbColumns.image: DbColumn.text(),
      DbColumns.additionalImages: DbColumn.text(),
      DbColumns.price: DbColumn.real(),
      DbColumns.special: DbColumn.real(),
      DbColumns.taxClassId: DbColumn.integer(),
      DbColumns.dateAvailable: DbColumn.text(),
      DbColumns.weight: DbColumn.real(),
      DbColumns.weightClassId: DbColumn.integer(),
      DbColumns.length: DbColumn.real(),
      DbColumns.width: DbColumn.real(),
      DbColumns.height: DbColumn.real(),
      DbColumns.lengthClassId: DbColumn.integer(),
      DbColumns.minimum: DbColumn.integer(),
      DbColumns.sortOrder: DbColumn.integer(),
      DbColumns.status: DbColumn.integer(),
      DbColumns.dateAdded: DbColumn.text(),
      DbColumns.dateModified: DbColumn.text(),
      DbColumns.viewed: DbColumn.integer(),
      DbColumns.options: DbColumn.text(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['productId'] as int,
      name: map['name'] as String,
      description: (map['description'] ?? '') as String,
      metaTitle: (map['metaTitle'] ?? '') as String,
      metaDescription: (map['metaDescription'] ?? '') as String,
      metaKeyword: (map['metaKeyword'] ?? '') as String,
      model: (map['model'] ?? '') as String,
      sku: (map['sku'] ?? '') as String,
      upc: (map['upc'] ?? '') as String,
      ean: (map['ean'] ?? '') as String,
      jan: (map['jan'] ?? '') as String,
      isbn: (map['isbn'] ?? '') as String,
      mpn: (map['mpn'] ?? '') as String,
      location: (map['location'] ?? '') as String,
      quantity: (map['quantity'] ?? 0) as int,
      stockStatus: (map['stockStatus'] ?? '') as String,
      image: (map['image'] ?? '') as String,
      additionalImages: decodeOrDefault<List<String>>(
        map['additionalImages'],
        [],
        (dynamic value) => (value as List).map((e) => e.toString()).toList(),
      ),
      price: toDouble(map['price']),
      special: map['special'] != null ? toDouble(map['special']) : null,
      taxClassId: (map['taxClassId'] ?? 0) as int,
      dateAvailable: (map['dateAvailable'] ?? '') as String,
      weight: toDouble(map['weight']),
      weightClassId: (map['weightClassId'] ?? 0) as int,
      length: toDouble(map['length']),
      width: toDouble(map['width']),
      height: toDouble(map['height']),
      lengthClassId: (map['lengthClassId'] ?? 0) as int,
      minimum: (map['minimum'] ?? 0) as int,
      sortOrder: (map['sortOrder'] ?? 0) as int,
      status: map['status'] == 1,
      dateAdded: (map['dateAdded'] ?? '') as String,
      dateModified: (map['dateModified'] ?? '') as String,
      viewed: (map['viewed'] ?? 0) as int,
      options: decodeOrDefault<List<ProductOptionEntity>>(
        map['options'],
        [],
        (dynamic value) => (value as List)
            .map((x) => ProductOptionModel.fromMap(x as Map<String, dynamic>))
            .toList(),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}