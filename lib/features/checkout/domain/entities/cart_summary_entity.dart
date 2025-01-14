import 'package:ordering_app/features/checkout/domain/entities/cart_item_entity.dart';
import 'package:ordering_app/features/address_book/domain/entities/address_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/shipping_method_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/total_entity.dart';

class CartSummaryEntity {
  final List<CartItemEntity> products;
  final AddressEntity? shippingAddress;
  final ShippingMethodEntity? shippingMethod;
  final List<TotalEntity> totals;

  CartSummaryEntity({
    required this.products,
   required this.shippingAddress,
   required this.shippingMethod,
    required this.totals,
  });


}
