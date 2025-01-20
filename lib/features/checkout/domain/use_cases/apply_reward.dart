
import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/repositories/checkout_repository.dart';

class ApplyReward implements UseCase <String,ApplyRewardParams> {
  final CheckoutRepository _checkoutRepository;

  ApplyReward({required CheckoutRepository checkoutRepository}) : _checkoutRepository = checkoutRepository;

  @override
  Future<Either<Failure, String>> call(ApplyRewardParams params)async {
    return await _checkoutRepository.applyReward(points: params.points);
  }
}
class ApplyRewardParams {
  final String points;

  ApplyRewardParams({required this.points,});
}