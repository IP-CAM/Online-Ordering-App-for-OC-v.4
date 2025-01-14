import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/features/checkout/domain/entities/cart_summary_entity.dart';

abstract interface class CartRepository {
  Future<Either<Failure, CartSummaryEntity>> getCart();
  Future<Either<Failure, String>> updateCartItem({
    required int cartId,
    required int quantity,
  });
    Future<Either<Failure, String>> removeCartItem({
    required int cartId,
  });
}
