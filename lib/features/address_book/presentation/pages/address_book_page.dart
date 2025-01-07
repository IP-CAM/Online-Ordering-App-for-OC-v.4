import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/config/routes/route_constants.dart';
import 'package:ordering_app/config/theme/custom_colors.dart';
import 'package:ordering_app/core/utils/loader.dart';
import 'package:ordering_app/core/utils/navigation_service.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';
import 'package:ordering_app/features/address_book/domain/entities/address_entity.dart';
import 'package:ordering_app/features/address_book/presentation/blocs/address_book/address_book_bloc.dart';
import 'package:ordering_app/features/address_book/presentation/widgets/address_card.dart';
import 'package:ordering_app/features/address_book/presentation/widgets/address_empty_view.dart';
import 'package:ordering_app/features/theme/presentation/widgets/theme_mode_fab.dart';

class AddressBookPage extends StatefulWidget {
  final bool isOnCheckout;

  const AddressBookPage({
    super.key,
    this.isOnCheckout = false,
  });

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  List<AddressEntity> _addresses = [];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() {
    context.read<AddressBookBloc>().add(FetchAddressListEvent());
  }

  void _navigateToAddAddress() {
    NavigationService.push(
      context,
      RouteConstants.addressDetailsPage,
    );
    _loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isOnCheckout ? 'Select delivery address' : 'Address book',
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton.icon(
              onPressed: _navigateToAddAddress,
              icon: Icon(
                Icons.add,
                size: 20,
                color: theme.colorScheme.surface,
              ),
              label: const Text('Add New'),
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.secondary,
                foregroundColor: theme.colorScheme.surface,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<AddressBookBloc, AddressBookState>(
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

          if (state is AddressListFetchSuccess) {
            setState(() {
              _addresses = state.addressList;
            });
          }
          if (state is AddressSaveSuccess) {
            showCustomSnackBar(
              context: context,
              message: state.message,
              type: SnackBarType.success,
            );
            _loadAddresses();
          }
          if (state is AddressDeleteSuccess) {
            showCustomSnackBar(
              context: context,
              message: state.message,
              type: SnackBarType.success,
            );
            _loadAddresses();
          }
        },
        builder: (context, state) {
          if (_addresses.isEmpty) {
            return EmptyAddressView(onAddAddress: _navigateToAddAddress);
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadAddresses();
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) => AddressCard(
                address: _addresses[index],
                isOnCheckout: widget.isOnCheckout,
                onDeleteTap: () => _loadAddresses(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: const ThemeModeFAB(),
    );
  }
}
