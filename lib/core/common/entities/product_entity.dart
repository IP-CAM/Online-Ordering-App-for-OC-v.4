import 'package:ordering_app/core/common/entities/product_option_entity.dart';

class ProductEntity {
  final int productId;
  final String name;
  final String description;
  final String metaTitle;
  final String metaDescription;
  final String metaKeyword;
  final String model;
  final String sku;
  final String upc;
  final String ean;
  final String jan;
  final String isbn;
  final String mpn;
  final String location;
  final int quantity;
  final String stockStatus;
  final String image;
  final List<String> additionalImages;
  final List<int> categories;
  final double price;
  final double? special;
  final int taxClassId;
  final String dateAvailable;
  final double weight;
  final int weightClassId;
  final double length;
  final double width;
  final double height;
  final int lengthClassId;
  final int minimum;
  final int sortOrder;
  final bool status;
  final String dateAdded;
  final String dateModified;
  final int viewed;
  final List<ProductOptionEntity> options;

  const ProductEntity({
    required this.productId,
    required this.name,
    required this.description,
    required this.metaTitle,
    required this.metaDescription,
    required this.metaKeyword,
    required this.model,
    required this.sku,
    required this.upc,
    required this.ean,
    required this.jan,
    required this.isbn,
    required this.mpn,
    required this.location,
    required this.quantity,
    required this.stockStatus,
    required this.image,
    required this.additionalImages,
    required this.categories,
    required this.price,
    required this.special,
    required this.taxClassId,
    required this.dateAvailable,
    required this.weight,
    required this.weightClassId,
    required this.length,
    required this.width,
    required this.height,
    required this.lengthClassId,
    required this.minimum,
    required this.sortOrder,
    required this.status,
    required this.dateAdded,
    required this.dateModified,
    required this.viewed,
    required this.options,
  });

}
