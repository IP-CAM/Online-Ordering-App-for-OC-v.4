import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/repositories/checkout_repository.dart';

class SetShippingAddress implements UseCase<String, SetShippingAddressParams> {
  final CheckoutRepository _checkoutRepository;

  SetShippingAddress({required CheckoutRepository checkoutRepository})
      : _checkoutRepository = checkoutRepository;

  @override
  Future<Either<Failure, String>> call(SetShippingAddressParams params) async {
    return await _checkoutRepository.setShippingAddress(
        addressId: params.addressId);
  }
}

class SetShippingAddressParams {
  final int addressId;

  SetShippingAddressParams({required this.addressId});
}
