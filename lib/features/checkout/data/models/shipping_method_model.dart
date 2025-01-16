import 'dart:convert';

import 'package:ordering_app/features/checkout/domain/entities/shipping_method_entity.dart';

class ShippingMethodModel extends ShippingMethodEntity {
  ShippingMethodModel({
    required super.shippingMethod,
    required super.code,
  });
    Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shipping_method': shippingMethod,
      'code': code,
    };
  }

  factory ShippingMethodModel.fromMap(Map<String, dynamic> map) {
    return ShippingMethodModel(
      shippingMethod: map['shipping_method'] as String,
      code: map['code']
    );
  }

  String toJson() => json.encode(toMap());

  factory ShippingMethodModel.fromJson(String source) => ShippingMethodModel.fromMap(json.decode(source) as Map<String, dynamic>);
}