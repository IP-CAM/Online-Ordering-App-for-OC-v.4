
import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/repositories/checkout_repository.dart';

class RemoveVoucher implements UseCase<String,NoParams> {
  final CheckoutRepository _checkoutRepository;

  RemoveVoucher({required CheckoutRepository checkoutRepository}) : _checkoutRepository = checkoutRepository;

  @override
  Future<Either<Failure, String>> call(NoParams params) async{
return await _checkoutRepository.removeVoucher();
  }
}
