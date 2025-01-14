import 'dart:convert';

import 'package:ordering_app/features/checkout/domain/entities/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  PaymentMethodModel({
    required super.code,
    required super.title,
    required super.terms,
    required super.sortOrder,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'title': title,
      'terms': terms,
      'sortOrder': sortOrder,
    };
  }

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      code: map['code'] as String,
      title: map['title'] as String,
      terms: map['terms'] as String,
      sortOrder: map['sortOrder'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentMethodModel.fromJson(String source) => PaymentMethodModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
