import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/repositories/checkout_repository.dart';

class SetShippingMethod implements UseCase<String, SetShippingMethodParams> {
  final CheckoutRepository _checkoutRepository;

  SetShippingMethod({required CheckoutRepository checkoutRepository})
      : _checkoutRepository = checkoutRepository;

  @override
  Future<Either<Failure, String>> call(SetShippingMethodParams params) async {
    return await _checkoutRepository.setShippingMethod(code: params.code);
  }
}

class SetShippingMethodParams {
  final String code;

  SetShippingMethodParams({required this.code});
}
