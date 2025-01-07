import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/features/address_book/domain/entities/address_entity.dart';
import 'package:ordering_app/features/address_book/domain/entities/country_entity.dart';
import 'package:ordering_app/features/address_book/domain/entities/zone_entity.dart';

abstract interface class AddressBookRepository {
  Future<Either<Failure, List<AddressEntity>>> getAddressList();
  Future<Either<Failure, List<CountryEntity>>> getCountryList();
  Future<Either<Failure, List<ZoneEntity>>> getZoneList({
    required int countryId,
  });

  Future<Either<Failure,String>> saveAddress({
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
  });

  Future<Either<Failure,String>> deleteAddress({
    required int addressId,
  });

}

