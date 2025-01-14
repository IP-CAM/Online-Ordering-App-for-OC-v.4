import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/repositories/checkout_repository.dart';

class SetPaymentMethod implements UseCase<String, SetPaymentMethodParams> {
  final CheckoutRepository _checkoutRepository;

  SetPaymentMethod({required CheckoutRepository checkoutRepository})
      : _checkoutRepository = checkoutRepository;

  @override
  Future<Either<Failure, String>> call(SetPaymentMethodParams params) async {
    return await _checkoutRepository.setPaymentMethod(code: params.code);
  }
}

class SetPaymentMethodParams {
  final String code;

  SetPaymentMethodParams({required this.code});
}
