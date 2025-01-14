import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/entities/shipping_method_entity.dart';
import 'package:ordering_app/features/checkout/domain/repositories/checkout_repository.dart';

class FetchShippingMethods
    implements UseCase<List<ShippingMethodEntity>, NoParams> {
  final CheckoutRepository _checkoutRepository;

  FetchShippingMethods({required CheckoutRepository checkoutRepository})
      : _checkoutRepository = checkoutRepository;

  @override
  Future<Either<Failure, List<ShippingMethodEntity>>> call(
      NoParams params) async {
    return await _checkoutRepository.shippingMethods();
  }
}
