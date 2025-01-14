import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/repositories/cart_repository.dart';

class UpdateCart implements UseCase<String, UpdateCartParams> {
  final CartRepository _cartRepository;

  UpdateCart({required CartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, String>> call(UpdateCartParams params) async {
    return await _cartRepository.updateCartItem(
      cartId: params.cartId,
      quantity: params.quantity,
    );
  }
}

class UpdateCartParams {
  final int cartId;
  final int quantity;

  UpdateCartParams({
    required this.cartId,
    required this.quantity,
  });
}
