import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/entities/payment_method_entity.dart';
import 'package:ordering_app/features/checkout/domain/repositories/checkout_repository.dart';

class FetchPaymentMethods
    implements UseCase<List<PaymentMethodEntity>, NoParams> {
  final CheckoutRepository _checkoutRepository;

  FetchPaymentMethods({required CheckoutRepository checkoutRepository})
      : _checkoutRepository = checkoutRepository;

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> call(
      NoParams params) async {
    return await _checkoutRepository.paymentMethods();
  }
}
