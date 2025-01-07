part of 'address_book_bloc.dart';

@immutable
sealed class AddressBookEvent {}

final class FetchAddressListEvent extends AddressBookEvent {}

final class FetchZoneListEvent extends AddressBookEvent {
  final int countryId;

  FetchZoneListEvent({required this.countryId});
}

final class FetchCountryListEvent extends AddressBookEvent {}

final class AddressDeleteEvent extends AddressBookEvent {
  final int addressId;

  AddressDeleteEvent({required this.addressId});
}

final class AddressSaveEvent extends AddressBookEvent {
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

  AddressSaveEvent({
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
