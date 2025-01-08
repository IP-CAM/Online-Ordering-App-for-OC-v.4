part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartFailure extends CartState {
  final String error;

  CartFailure({required this.error,});
}

final class CartFetchSuccess extends CartState {
  final List<CartItemEntity> cartItems;

  CartFetchSuccess({required this.cartItems});
}

final class CartUpdateSuccess extends CartState {
  final String message;

  CartUpdateSuccess({required this.message});
}
