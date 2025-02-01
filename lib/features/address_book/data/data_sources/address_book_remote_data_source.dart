import 'package:flutter/material.dart';
import 'package:ordering_app/core/constants/urls.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/utils/web_service.dart';
import 'package:ordering_app/features/address_book/data/models/address_model.dart';
import 'package:ordering_app/features/address_book/data/models/country_model.dart';
import 'package:ordering_app/features/address_book/data/models/zone_model.dart';

abstract interface class AddressBookRemoteDataSource {
  Future<List<AddressModel>> getAddressList();
  Future<List<CountryModel>> getCountryList();
  Future<List<ZoneModel>> getZoneList({required int countryId});

  Future<String> saveAddress({
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
  Future<String> deleteAddress({
    required int addressId,
  });
}

class AddressBookRemoteDataSourceImpl implements AddressBookRemoteDataSource {
  final WebService _webService;

  AddressBookRemoteDataSourceImpl({required WebService webService})
      : _webService = webService;

  @override
  Future<List<AddressModel>> getAddressList() async {
    try {
      final response = await _webService.get(
        endpoint: Urls.addressList,
      );

      // Early return if there's an error
      if (response.error != null) {
        throw response.error!;
      }

      if (response.data is List && (response.data as List).isEmpty) {
        return [];
      }
      // Explicit type casting and null check
      if (response.success && response.data['addresses'] is List) {
        return (response.data['addresses'] as List)
            .map((item) => AddressModel.fromMap(item))
            .toList();
      }

      return [];
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw AppException(error.toString());
    }
  }

  @override
  Future<List<CountryModel>> getCountryList() async {
    try {
      final response = await _webService.get(
        endpoint: Urls.countryList,
      );

      // Early return if there's an error
      if (response.error != null) {
        throw response.error!;
      }

      // Explicit type casting and null check
      if (response.success && response.data['countries'] is List) {
        return (response.data['countries'] as List)
            .map((item) => CountryModel.fromMap(item))
            .toList();
      }

      return [];
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw AppException(error.toString());
    }
  }

  @override
  Future<List<ZoneModel>> getZoneList({required int countryId}) async {
    try {
      final response = await _webService.post(
        endpoint: Urls.country,
        body: {
          'country_id': countryId.toString(),
        },
      );

      // Early return if there's an error
      if (response.error != null) {
        throw response.error!;
      }

      // Explicit type casting and null check
      if (response.success && response.data['zone'] is List) {
        return (response.data['zone'] as List)
            .map((item) => ZoneModel.fromMap(item))
            .toList();
      }

      return [];
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw AppException(error.toString());
    }
  }

  @override
  Future<String> deleteAddress({
    required int addressId,
  }) async {
    try {
      final response = await _webService.post(
        endpoint: Urls.delete,
        body: {
          'address_id': addressId.toString(),
        },
      );

      // Early return if there's an error
      if (response.error != null) {
        throw response.error!;
      }

      // Explicit type casting and null check
      if (response.success && response.data['message'] is String) {
        return response.data['message'];
      }

      throw 'Unknown error!';
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw AppException(error.toString());
    }
  }

  @override
  Future<String> saveAddress({
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
      final response = await _webService.post(
        endpoint: Urls.saveAddress,
        body: {
          if (addressId != null) 'address_id': addressId.toString(),
          'firstname': firstName,
          'lastname': lastName,
          if (company != null) 'company': company,
          'address_1': address1,
          if (address2 != null) 'address_2': address2,
          'city': city,
          'postcode': postcode,
          'country_id': countryId.toString(),
          'zone_id': zoneId.toString(),
        },
      );

      // Early return if there's an error
      if (response.error != null) {
        throw response.error!;
      }

      // Explicit type casting and null check
      if (response.success && response.data['message'] is String) {
        return response.data['message'];
      }

      throw 'Unknown error!';
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw AppException(error.toString());
    }
  }
}
