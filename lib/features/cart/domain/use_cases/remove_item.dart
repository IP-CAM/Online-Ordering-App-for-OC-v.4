import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/cart/domain/repositories/cart_repository.dart';

class RemoveItem implements UseCase<String, RemoveItemParams> {
  final CartRepository _cartRepository;

  RemoveItem({required CartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, String>> call(RemoveItemParams params) async {
    return await _cartRepository.removeCartItem(cartId: params.cartId);
  }
}

class RemoveItemParams {
  final int cartId;

  RemoveItemParams({required this.cartId});
}
