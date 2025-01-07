
import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/address_book/domain/repositories/address_book_repository.dart';

class DeleteAddress implements UseCase<String,DeleteAddressParams> {
  final AddressBookRepository _addressBookRepository;

  DeleteAddress({required AddressBookRepository addressBookRepository}) : _addressBookRepository = addressBookRepository;

  @override
  Future<Either<Failure, String>> call(DeleteAddressParams params)async {
  return await _addressBookRepository.deleteAddress(addressId: params.addressId);
  }
}

class DeleteAddressParams{
  final int addressId;

  DeleteAddressParams({required this.addressId});
}