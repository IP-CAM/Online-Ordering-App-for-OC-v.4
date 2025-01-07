import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/address_book/domain/entities/address_entity.dart';
import 'package:ordering_app/features/address_book/domain/entities/country_entity.dart';
import 'package:ordering_app/features/address_book/domain/entities/zone_entity.dart';
import 'package:ordering_app/features/address_book/domain/use_cases/delete_address.dart';
import 'package:ordering_app/features/address_book/domain/use_cases/fetch_address_list.dart';
import 'package:ordering_app/features/address_book/domain/use_cases/fetch_country_list.dart';
import 'package:ordering_app/features/address_book/domain/use_cases/fetch_zone_list.dart';
import 'package:ordering_app/features/address_book/domain/use_cases/save_address.dart';

part 'address_book_event.dart';
part 'address_book_state.dart';

class AddressBookBloc extends Bloc<AddressBookEvent, AddressBookState> {
  final FetchCountryList _fetchCountryList;
  final FetchAddressList _fetchAddressList;
  final FetchZoneList _fetchZoneList;
  final DeleteAddress _deleteAddress;
  final SaveAddress _saveAddress;

  AddressBookBloc({
    required FetchCountryList fetchCountryList,
    required FetchAddressList fetchAddressList,
    required FetchZoneList fetchZoneList,
    required DeleteAddress deleteAddress,
    required SaveAddress saveAddress,
  })  : _fetchAddressList = fetchAddressList,
        _fetchCountryList = fetchCountryList,
        _fetchZoneList = fetchZoneList,
        _deleteAddress = deleteAddress,
        _saveAddress = saveAddress,
        super(AddressBookInitial()) {
    on<AddressBookEvent>((event, emit) {
      emit(AddressBookLoading());
    });
    on<FetchAddressListEvent>(_onFetchAddressListEvent);
    on<FetchZoneListEvent>(_onFetchZoneListEvent);
    on<FetchCountryListEvent>(_onFetchCountryListEvent);
    on<AddressSaveEvent>(_onAddressSaveEvent);
    on<AddressDeleteEvent>(_onAddressDeleteEvent);
  }

  void _onFetchAddressListEvent(
      FetchAddressListEvent event, Emitter<AddressBookState> emit) async {
    final res = await _fetchAddressList(NoParams());
    res.fold(
      (l) => emit(AddressBookFailure(error: l.message)),
      (r) => emit(AddressListFetchSuccess(addressList: r)),
    );
  }

  void _onFetchZoneListEvent(
      FetchZoneListEvent event, Emitter<AddressBookState> emit) async {
    final res = await _fetchZoneList(
      FetchZoneListParams(countryId: event.countryId),
    );
    res.fold(
      (l) => emit(AddressBookFailure(error: l.message)),
      (r) => emit(ZoneListFetchSuccess(zoneList: r)),
    );
  }

  void _onFetchCountryListEvent(
      FetchCountryListEvent event, Emitter<AddressBookState> emit) async {
    final res = await _fetchCountryList(NoParams());
    res.fold(
      (l) => emit(AddressBookFailure(error: l.message)),
      (r) => emit(CountryListFetchSuccess(countryList: r)),
    );
  }

  void _onAddressDeleteEvent(
      AddressDeleteEvent event, Emitter<AddressBookState> emit) async {
    final res = await _deleteAddress(
      DeleteAddressParams(addressId: event.addressId),
    );
    res.fold(
      (l) => emit(AddressBookFailure(error: l.message)),
      (r) => emit(AddressDeleteSuccess(message: r)),
    );
  }

  void _onAddressSaveEvent(
      AddressSaveEvent event, Emitter<AddressBookState> emit) async {
    final res = await _saveAddress(
      SaveAddressParams(
        addressId: event.addressId,
        firstName: event.firstName,
        lastName: event.lastName,
        address1: event.address1,
        address2: event.address2,
        company: event.company,
        city: event.city,
        postcode: event.postcode,
        countryId: event.countryId,
        zoneId: event.zoneId,
      ),
    );

    res.fold(
      (l) => emit(AddressBookFailure(error: l.message)),
      (r) => emit(AddressSaveSuccess(message: r)),
    );
  }
}
