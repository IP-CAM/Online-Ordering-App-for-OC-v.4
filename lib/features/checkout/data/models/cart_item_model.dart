import 'dart:convert';

import 'package:ordering_app/features/checkout/domain/entities/cart_item_entity.dart';
import 'package:ordering_app/features/checkout/data/models/subscription_model.dart';

class CartItemModel extends CartItemEntity {
  CartItemModel({
    required super.cartId,
    required super.productId,
    required super.name,
    required super.model,
    required super.options,
    required super.subscription,
    required super.quantity,
    required super.price,
    required super.total,
    required super.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cart_id': cartId,
      'product_id': productId,
      'name': name,
      'model': model,
      'options':
          options?.map((x) => (x as CartItemOptionModel).toMap()).toList(),
      'subscription': subscription,
      'quantity': quantity,
      'price': price,
      'total': total,
      'image': image,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      cartId: map['cart_id'] is String
          ? int.parse(map['cart_id'])
          : map['cart_id'] as int,
      productId: map['product_id'] is String
          ? int.parse(map['product_id'])
          : map['product_id'] as int,
      name: map['name'] as String,
      model: map['model'] as String,
      options: map['option'] != null
          ? List<CartItemOptionModel>.from(
              (map['option'] as List<dynamic>).map<CartItemOptionModel?>(
                (x) => CartItemOptionModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      subscription:
          map['subscription'] is Map<String,dynamic> ? (SubscriptionModel.fromMap(map['subscription'] as Map<String,dynamic>)) : null,
      quantity: map['quantity'] is String
          ? int.parse(map['quantity'])
          : map['quantity'] as int,
      price: map['price'] is int ||  map['price'] is double ? map['price'].toString() : map['price'] as String,
      total:  map['total'] is int ||  map['total'] is double ?  map['total'].toString() : map['total'] as String,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source) =>
      CartItemModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CartItemOptionModel extends CartItemOptionEntity {
  CartItemOptionModel({
    required super.productOptionId,
    required super.productOptionValueId,
    required super.name,
    required super.value,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product_option_id': productOptionId,
      'product_option_value_id': productOptionValueId,
      'name': name,
      'value': value,
    };
  }

  factory CartItemOptionModel.fromMap(Map<String, dynamic> map) {
    return CartItemOptionModel(
      productOptionId: map['product_option_id'] is int ? map['product_option_id'].toString() : map['product_option_id'] as String,
      productOptionValueId: map['product_option_value_id'] == null ? null : map['product_option_value_id'] is int ? map['product_option_value_id'].toString() : map['product_option_value_id'] as String,
      name: map['name'] as String,
      value: map['value'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemOptionModel.fromJson(String source) =>
      CartItemOptionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
