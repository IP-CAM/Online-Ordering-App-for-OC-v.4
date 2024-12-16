import 'dart:convert';

import 'package:ordering_app/core/common/entities/product_option_entity.dart';
import 'package:ordering_app/core/utils/helpers.dart';

class ProductOptionModel extends ProductOptionEntity {
  ProductOptionModel({
    required super.productOptionId,
    required super.optionId,
    required super.name,
    required super.type,
    required super.optionValue,
    required super.required,
    required super.defaultValue,
    required super.masterOption,
    required super.masterOptionValue,
    required super.minimum,
    required super.maximum,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product_option_id': productOptionId,
      'option_id': optionId,
      'name': name,
      'type': type,
      'option_value': optionValue
          .map((x) => (x as ProductOptionValueModel).toMap())
          .toList(),
      'required': required,
      'default': defaultValue,
      'master_option': masterOption,
      'master_option_value': masterOptionValue,
      'minimum': minimum,
      'maximum': maximum,
    };
  }

  factory ProductOptionModel.fromMap(Map<String, dynamic> map) {
    return ProductOptionModel(
      productOptionId: map['product_option_id'] as String,
      optionId: map['option_id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      optionValue: List<ProductOptionValueModel>.from(
        (map['option_value'] as List<dynamic>).map<ProductOptionValueEntity>(
          (x) => ProductOptionValueModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      required: map['required'] as String,
      defaultValue: map['default'] as String,
      masterOption: map['master_option'] as String,
      masterOptionValue: map['master_option_value'] as String,
      minimum: map['minimum'] as String,
      maximum: map['maximum'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductOptionModel.fromJson(String source) =>
      ProductOptionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ProductOptionValueModel extends ProductOptionValueEntity {
  ProductOptionValueModel({
    required super.productOptionValueId,
    required super.optionValueId,
    required super.name,
    required super.shortcode,
    required super.price,
    required super.pricePrefix,
    required super.priceValue,
    required super.masterOptionValue,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product_option_value_id': productOptionValueId,
      'option_value_id': optionValueId,
      'name': name,
      'shortcode': shortcode,
      'price': price,
      'price_prefix': pricePrefix,
      'price_value': priceValue,
      'master_option_value': masterOptionValue,
    };
  }

  factory ProductOptionValueModel.fromMap(Map<String, dynamic> map) {
    return ProductOptionValueModel(
      productOptionValueId: map['product_option_value_id'] as String,
      optionValueId: map['option_value_id'] as String,
      name: map['name'] as String,
      shortcode: map['shortcode'] as String,
      price: map['price'] as bool,
      pricePrefix: map['price_prefix'] as String,
      priceValue: toDouble(map['price_value']),
      masterOptionValue: map['master_option_value'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductOptionValueModel.fromJson(String source) =>
      ProductOptionValueModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
