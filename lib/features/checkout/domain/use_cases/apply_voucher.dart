
import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/repositories/checkout_repository.dart';

class ApplyVoucher implements UseCase<String,ApplyVoucherParams> {
  final CheckoutRepository _checkoutRepository;

  ApplyVoucher({required CheckoutRepository checkoutRepository}) : _checkoutRepository = checkoutRepository;
  
  @override
  Future<Either<Failure, String>> call(ApplyVoucherParams params) async{
return await _checkoutRepository.applyVoucher(code: params.code);
  }
}
class ApplyVoucherParams {
  final String code;

  ApplyVoucherParams({required this.code});
}