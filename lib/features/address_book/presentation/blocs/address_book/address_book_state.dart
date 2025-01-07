part of 'address_book_bloc.dart';

@immutable
sealed class AddressBookState {}

final class AddressBookInitial extends AddressBookState {}

final class AddressBookLoading extends AddressBookState {}

final class AddressListFetchSuccess extends AddressBookState {
  final List<AddressEntity> addressList;

  AddressListFetchSuccess({required this.addressList});
}

final class CountryListFetchSuccess extends AddressBookState {
  final List<CountryEntity> countryList;

  CountryListFetchSuccess({required this.countryList});
}

final class ZoneListFetchSuccess extends AddressBookState {
  final List<ZoneEntity> zoneList;

  ZoneListFetchSuccess({required this.zoneList});
}

final class AddressBookFailure extends AddressBookState {
  final String error;

  AddressBookFailure({required this.error});
}

final class AddressSaveSuccess extends AddressBookState {
  final String message;

  AddressSaveSuccess({required this.message});
}

final class AddressDeleteSuccess extends AddressBookState {
  final String message;

  AddressDeleteSuccess({required this.message});

}
