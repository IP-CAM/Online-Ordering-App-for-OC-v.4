part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

final class CartUpdateEvent extends CartEvent {
  final int cartId;
  final int quantity;

  CartUpdateEvent({
    required this.cartId,
    required this.quantity,
  });
}

final class CartFetchEvent extends CartEvent {}

final class CartItemRemoveEvent extends CartEvent {
  final int cartId;

  CartItemRemoveEvent({required this.cartId});
}
