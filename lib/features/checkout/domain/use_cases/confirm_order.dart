import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/repositories/checkout_repository.dart';

class ConfirmOrder implements UseCase<String, ConfirmOrderParams> {
  final CheckoutRepository _checkoutRepository;

  ConfirmOrder({required CheckoutRepository checkoutRepository})
      : _checkoutRepository = checkoutRepository;
  @override
  Future<Either<Failure, String>> call(ConfirmOrderParams params) async {
    return await _checkoutRepository.confirm(comment: params.comment,);
  }
}

class ConfirmOrderParams{
  final String  comment;

  ConfirmOrderParams({required this.comment});
}