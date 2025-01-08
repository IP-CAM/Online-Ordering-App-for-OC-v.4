
import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ordering_app/features/cart/domain/repositories/cart_repository.dart';

class FetchCart implements UseCase<List<CartItemEntity>, NoParams> {
  final CartRepository _cartRepository;

  FetchCart({required CartRepository cartRepository}) : _cartRepository = cartRepository;
  @override
  Future<Either<Failure, List<CartItemEntity>>> call(NoParams params)async {
    return await _cartRepository.getCart();
  }
}