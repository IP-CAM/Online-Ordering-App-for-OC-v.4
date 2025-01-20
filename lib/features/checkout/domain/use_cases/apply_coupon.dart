import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/repositories/checkout_repository.dart';

class ApplyCoupon implements UseCase<String, ApplyCouponParams> {
  final CheckoutRepository _checkoutRepository;

  ApplyCoupon({required CheckoutRepository checkoutRepository})
      : _checkoutRepository = checkoutRepository;

  @override
  Future<Either<Failure, String>> call(ApplyCouponParams params) async {
    return await _checkoutRepository.applyCoupon(code: params.code);
  }
}

class ApplyCouponParams {
  final String code;

  ApplyCouponParams({required this.code});
}
