import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/features/cart/domain/entities/cart_item_entity.dart';

abstract interface class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCart();
  Future<Either<Failure, String>> updateCartItem({
    required int cartId,
    required int quantity,
  });
    Future<Either<Failure, String>> removeCartItem({
    required int cartId,
  });
}
