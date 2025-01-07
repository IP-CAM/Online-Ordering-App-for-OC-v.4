import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/address_book/domain/repositories/address_book_repository.dart';

class SaveAddress implements UseCase<String, SaveAddressParams> {
  final AddressBookRepository _addressBookRepository;

  SaveAddress({required AddressBookRepository addressBookRepository})
      : _addressBookRepository = addressBookRepository;

  @override
  Future<Either<Failure, String>> call(SaveAddressParams params) async {
    return await _addressBookRepository.saveAddress(
      addressId: params.addressId,
      firstName: params.firstName,
      lastName: params.lastName,
      address1: params.address1,
      address2: params.address2,
      company: params.company,
      city: params.city,
      postcode: params.postcode,
      countryId: params.countryId,
      zoneId: params.zoneId,
    );
  }
}

class SaveAddressParams {
  final int? addressId;
  final String firstName;
  final String lastName;
  final String address1;
  final String? address2;
  final String? company;
  final String city;
  final String postcode;
  final int countryId;
  final int zoneId;

  SaveAddressParams({
    required this.addressId,
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.address2,
    required this.company,
    required this.city,
    required this.postcode,
    required this.countryId,
    required this.zoneId,
  });
}
