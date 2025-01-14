import 'dart:convert';

import 'package:ordering_app/features/address_book/data/models/address_model.dart';
import 'package:ordering_app/features/checkout/data/models/cart_item_model.dart';
import 'package:ordering_app/features/checkout/data/models/shipping_method_model.dart';
import 'package:ordering_app/features/checkout/data/models/total_model.dart';
import 'package:ordering_app/features/checkout/domain/entities/cart_summary_entity.dart';

class CartSummaryModel extends CartSummaryEntity {
  CartSummaryModel({
    required super.products,
    required super.shippingAddress,
    required super.shippingMethod,
    required super.totals,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'products': products.map((x) => (x as CartItemModel).toMap()).toList(),
      'shippingAddress': (shippingAddress as AddressModel).toMap(),
      'shippingMethod': (shippingMethod as ShippingMethodModel).toMap(),
      'totals': totals.map((x) => (x as TotalModel).toMap()).toList(),
    };
  }

  factory CartSummaryModel.fromMap(Map<String, dynamic> map) {
    return CartSummaryModel(
      products: 
        (map['products'] as List<dynamic>).map(
          (x) => CartItemModel.fromMap(x as Map<String, dynamic>),
        ).toList(),
      
      shippingAddress: map['shipping_address'] != null
          ? AddressModel.fromMap(map['shippingAddress'] as Map<String, dynamic>)
          : null,
      shippingMethod: map['shipping_method'] != null
          ? ShippingMethodModel.fromMap(
              map['shippingMethod'] as Map<String, dynamic>)
          : null,
      totals: List<TotalModel>.from(
        (map['totals'] as List<dynamic>).map<TotalModel>(
          (x) => TotalModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CartSummaryModel.fromJson(String source) =>
      CartSummaryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
