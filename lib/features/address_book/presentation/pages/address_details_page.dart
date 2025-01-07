import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/utils/loader.dart';
import 'package:ordering_app/core/utils/navigation_service.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';
import 'package:ordering_app/features/address_book/domain/entities/address_entity.dart';
import 'package:ordering_app/features/address_book/domain/entities/country_entity.dart';
import 'package:ordering_app/features/address_book/domain/entities/zone_entity.dart';
import 'package:ordering_app/features/address_book/presentation/blocs/address_book/address_book_bloc.dart';
import 'package:ordering_app/features/address_book/presentation/widgets/address_form_field.dart';
import 'package:ordering_app/features/theme/presentation/widgets/theme_mode_fab.dart';

class AddressDetailsPage extends StatefulWidget {
  final AddressEntity? address;

  const AddressDetailsPage({
    super.key,
    this.address,
  });

  @override
  State<AddressDetailsPage> createState() => _AddressDetailsPageState();
}

class _AddressDetailsPageState extends State<AddressDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoadingZones = false;
  CountryEntity? _selectedCountry;
  ZoneEntity? _selectedZone;

  List<CountryEntity> _countries = [];
  List<ZoneEntity> _zones = [];

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _postcodeController = TextEditingController();

  List<ZoneEntity> get _availableZones {
    if (_selectedCountry == null) return [];
    return _zones
        .where((zone) => zone.countryId == _selectedCountry!.countryId)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    context.read<AddressBookBloc>().add(FetchCountryListEvent());

    if (widget.address != null) {
      _firstNameController.text = widget.address!.firstName;
      _lastNameController.text = widget.address!.lastName;
      _companyController.text = widget.address?.company ?? '';
      _address1Controller.text = widget.address!.address1;
      _address2Controller.text = widget.address?.address2 ?? '';
      _cityController.text = widget.address!.city;
      _postcodeController.text = widget.address!.postcode;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCountry == null) {
      showCustomSnackBar(
        context: context,
        message: 'Please select a country',
        type: SnackBarType.error,
      );
      return;
    }

    if (_selectedZone == null) {
      showCustomSnackBar(
        context: context,
        message: 'Please select a zone/state/region',
        type: SnackBarType.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      context.read<AddressBookBloc>().add(
            AddressSaveEvent(
              addressId: widget.address?.addressId,
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              address1: _address1Controller.text,
              address2: _address2Controller.text,
              company: _companyController.text,
              city: _cityController.text,
              postcode: _postcodeController.text,
              countryId: _selectedCountry!.countryId,
              zoneId: _selectedZone!.zoneId,
            ),
          );

      if (mounted) {
        BlocProvider.of<AddressBookBloc>(context).add(FetchAddressListEvent());

        NavigationService.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(
          context: context,
          message: 'Error saving address: ${e.toString()}',
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleCountryChanged(CountryEntity? country) {
    if (country == null) return;

    setState(() {
      _selectedCountry = country;
      _selectedZone = null;
      _zones = []; // Clear zones when country changes
      _isLoadingZones = true;
    });

    context.read<AddressBookBloc>().add(
          FetchZoneListEvent(countryId: country.countryId),
        );
  }

  void _handleZoneChanged(ZoneEntity? zone) {
    setState(() {
      _selectedZone = zone;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.address != null ? 'Edit Address' : 'Add Address',
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: BlocListener<AddressBookBloc, AddressBookState>(
        listener: (context, state) {
          if (state is AddressBookLoading) {
            Loader.show(context);
          } else {
            Loader.hide();
          }

          if (state is AddressBookFailure) {
            showCustomSnackBar(
              context: context,
              message: state.error,
              type: SnackBarType.error,
            );
          }

          if (state is CountryListFetchSuccess) {
            setState(() {
              _countries = state.countryList;
              if (widget.address != null) {
                try {
                  _selectedCountry = _countries.firstWhere(
                    (country) => country.name == widget.address!.country,
                  );
                  if (_selectedCountry != null) {
                    _isLoadingZones = true;
                    context.read<AddressBookBloc>().add(
                          FetchZoneListEvent(
                            countryId: _selectedCountry!.countryId,
                          ),
                        );
                  }
                } catch (e) {
                  // Handle case when country is not found
                  _selectedCountry = null;
                }
              }
            });
          }

          if (state is ZoneListFetchSuccess) {
            setState(() {
              _zones = state.zoneList;
              _isLoadingZones = false;

              if (widget.address != null && _selectedCountry != null) {
                try {
                  _selectedZone = _zones.firstWhere(
                    (zone) =>
                        zone.countryId == _selectedCountry!.countryId &&
                        zone.name == widget.address!.zone,
                  );
                } catch (e) {
                  // Handle case when zone is not found
                  _selectedZone = null;
                }
              }
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AddressFormField(
                  controller: _firstNameController,
                  label: 'First Name',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AddressFormField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AddressFormField(
                  controller: _companyController,
                  label: 'Company (Optional)',
                ),
                const SizedBox(height: 16),
                AddressFormField(
                  controller: _address1Controller,
                  label: 'Address Line 1',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AddressFormField(
                  controller: _address2Controller,
                  label: 'Address Line 2 (Optional)',
                ),
                const SizedBox(height: 16),
                AddressFormField(
                  controller: _cityController,
                  label: 'City',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AddressFormField(
                  controller: _postcodeController,
                  label: 'Post Code',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your post code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<CountryEntity>(
                  key: const ValueKey('country_dropdown'),
                  value: _selectedCountry,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: _countries.map((country) {
                    return DropdownMenuItem(
                      value: country,
                      child: Text(
                        country.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: _handleCountryChanged,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a country';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ZoneEntity>(
                  key: ValueKey('zone_dropdown_${_selectedCountry?.countryId}'),
                  value: _selectedZone,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Zone / State',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    suffixIcon: _isLoadingZones
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : null,
                  ),
                  items: _availableZones.map((zone) {
                    return DropdownMenuItem(
                      value: zone,
                      child: Text(
                        zone.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: _isLoadingZones ? null : _handleZoneChanged,
                  validator: (value) {
                    if (_selectedCountry != null &&
                        !_isLoadingZones &&
                        value == null) {
                      return 'Please select a zone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveAddress,
                  child: Text(
                    widget.address != null ? 'Update Address' : 'Add Address',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const ThemeModeFAB(),
    );
  }
}
