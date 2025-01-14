import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/features/checkout/data/data_sources/cart_remote_data_source.dart';
import 'package:ordering_app/features/checkout/data/models/checkout_summary_model.dart';

import 'package:ordering_app/features/checkout/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _cartRemoteDataSource;

  CartRepositoryImpl({required CartRemoteDataSource cartRemoteDataSource})
      : _cartRemoteDataSource = cartRemoteDataSource;
  @override
  Future<Either<Failure, CartSummaryModel>> getCart() async {
    try {
      final res = await _cartRemoteDataSource.getCart();
      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> updateCartItem({
    required int cartId,
    required int quantity,
  }) async {
    try {
      final res = await _cartRemoteDataSource.updateCartItem(
        cartId: cartId,
        quantity: quantity,
      );
      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> removeCartItem({required int cartId}) async {
    try {
      final res = await _cartRemoteDataSource.removeItem(
        cartId: cartId,
      );
      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }
}
