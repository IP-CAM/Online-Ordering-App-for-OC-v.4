import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/features/address_book/data/data_sources/address_book_remote_data_source.dart';
import 'package:ordering_app/features/address_book/domain/entities/address_entity.dart';
import 'package:ordering_app/features/address_book/domain/entities/country_entity.dart';
import 'package:ordering_app/features/address_book/domain/entities/zone_entity.dart';
import 'package:ordering_app/features/address_book/domain/repositories/address_book_repository.dart';

class AddressBookRepositoryImpl implements AddressBookRepository {
  final AddressBookRemoteDataSource _addressBookRemoteDataSource;

  AddressBookRepositoryImpl(
      {required AddressBookRemoteDataSource addressBookRemoteDataSource})
      : _addressBookRemoteDataSource = addressBookRemoteDataSource;
  @override
  Future<Either<Failure, List<AddressEntity>>> getAddressList() async {
    try {
      final res = await _addressBookRemoteDataSource.getAddressList();
      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CountryEntity>>> getCountryList() async {
    try {
      final res = await _addressBookRemoteDataSource.getCountryList();
      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ZoneEntity>>> getZoneList({
    required int countryId,
  }) async {
    try {
      final res = await _addressBookRemoteDataSource.getZoneList(
        countryId: countryId,
      );
      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> deleteAddress({
    required int addressId,
  }) async {
    try {
      final res = await _addressBookRemoteDataSource.deleteAddress(
          addressId: addressId);
      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveAddress({
    required int? addressId,
    required String firstName,
    required String lastName,
    required String address1,
    required String? address2,
    required String? company,
    required String city,
    required String postcode,
    required int countryId,
    required int zoneId,
  }) async {
    try {
      final res = await _addressBookRemoteDataSource.saveAddress(
        addressId: addressId,
        firstName: firstName,
        lastName: lastName,
        address1: address1,
        address2: address2,
        company: company,
        city: city,
        postcode: postcode,
        countryId: countryId,
        zoneId: zoneId,
      );
      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }
}
