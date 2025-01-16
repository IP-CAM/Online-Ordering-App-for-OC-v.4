
import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/entities/checkout_summary_entity.dart';
import 'package:ordering_app/features/checkout/domain/repositories/checkout_repository.dart';

class FetchCheckoutSummary implements UseCase<CheckoutSummaryEntity, NoParams> {
  final CheckoutRepository _checkoutRepository;

  FetchCheckoutSummary({required CheckoutRepository checkoutRepository}) : _checkoutRepository = checkoutRepository;

  @override
  Future<Either<Failure, CheckoutSummaryEntity>> call(NoParams params) async{
return await _checkoutRepository.reviewOrder();
  }

}