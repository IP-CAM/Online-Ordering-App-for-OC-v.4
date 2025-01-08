import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ordering_app/features/cart/domain/use_cases/fetch_cart.dart';
import 'package:ordering_app/features/cart/domain/use_cases/remove_item.dart';
import 'package:ordering_app/features/cart/domain/use_cases/update_cart.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final FetchCart _fetchCart;
  final RemoveItem _removeItem;
  final UpdateCart _updateCart;
  CartBloc({
    required FetchCart fetchCart,
    required RemoveItem removeItem,
    required UpdateCart updateCart,
  })  : _fetchCart = fetchCart,
        _removeItem = removeItem,
        _updateCart = updateCart,
        super(CartInitial()) {
    on<CartEvent>((event, emit) {
      emit(CartLoading());
    });

    on<CartItemRemoveEvent>(_onCartItemRemoveEvent);
    on<CartFetchEvent>(_onCartFetchEvent);
    on<CartUpdateEvent>(_onCartUpdateEvent);
  }

  void _onCartUpdateEvent(
      CartUpdateEvent event, Emitter<CartState> emit) async {
    final res = await _updateCart(
      UpdateCartParams(
        cartId: event.cartId,
        quantity: event.quantity,
      ),
    );
    res.fold(
      (l) => emit(CartFailure(error: l.message)),
      (r) => emit(CartUpdateSuccess(message: r)),
    );
  }

  void _onCartFetchEvent(CartFetchEvent event, Emitter<CartState> emit) async {
    final res = await _fetchCart(NoParams());
    res.fold(
      (l) => emit(CartFailure(error: l.message)),
      (r) => emit(CartFetchSuccess(cartItems: r)),
    );
  }

  void _onCartItemRemoveEvent(
      CartItemRemoveEvent event, Emitter<CartState> emit) async {
    final res = await _removeItem(RemoveItemParams(cartId: event.cartId));
    res.fold(
      (l) => emit(CartFailure(error: l.message)),
      (r) => emit(CartUpdateSuccess(message: r)),
    );
  }
}
