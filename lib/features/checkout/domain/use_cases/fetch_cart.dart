
import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/entities/cart_summary_entity.dart';
import 'package:ordering_app/features/checkout/domain/repositories/cart_repository.dart';

class FetchCart implements UseCase<CartSummaryEntity, NoParams> {
  final CartRepository _cartRepository;

  FetchCart({required CartRepository cartRepository}) : _cartRepository = cartRepository;
  @override
  Future<Either<Failure, CartSummaryEntity>> call(NoParams params)async {
    return await _cartRepository.getCart();
  }
}