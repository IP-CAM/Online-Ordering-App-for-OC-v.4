import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/config/routes/route_constants.dart';
import 'package:ordering_app/config/theme/custom_colors.dart';
import 'package:ordering_app/core/utils/navigation_service.dart';
import 'package:ordering_app/features/address_book/domain/entities/address_entity.dart';
import 'package:ordering_app/features/address_book/presentation/blocs/address_book/address_book_bloc.dart';

class AddressCard extends StatelessWidget {
  final AddressEntity address;
  final VoidCallback? onDeleteTap;
  final bool isOnCheckout;

  const AddressCard({
    super.key,
    required this.address,
    this.onDeleteTap,
    required this.isOnCheckout,
  });

  void _handleSelect(BuildContext context, int addressId) {
    NavigationService.pushReplacementWithQuery(context, RouteConstants.checkout, {
      'addressId': addressId,
    });
  }

  void _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => NavigationService.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<AddressBookBloc>(context).add(
                AddressDeleteEvent(
                  addressId: address.addressId,
                ),
              );
              NavigationService.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AddressBookBloc>().add(
            AddressDeleteEvent(addressId: address.addressId),
          );
      onDeleteTap?.call();
    }
  }

  void _handleEdit(BuildContext context) {
    NavigationService.pushWithQuery(
      context,
      RouteConstants.addressDetailsPage,
      {'address': address},
    );
    onDeleteTap?.call(); // Refresh list after edit
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 75,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${address.firstName} ${address.lastName}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildAddressDetails(context),
                  ],
                ),
              ),
            ),
            Container(
              width: 1,
              color: theme.colorScheme.outlineVariant,
            ),
            SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (isOnCheckout)
                    Column(
                      children: [
                        Container(
                          height: 1,
                          color: theme.colorScheme.outlineVariant,
                        ),
                        _ActionButton(
                          icon: Icons.check,
                          label: 'Select',
                          color: appColors.success,
                          onTap: () =>
                              _handleSelect(context, address.addressId),
                        ),
                        Container(
                          height: 1,
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ],
                    ),
                  _ActionButton(
                    icon: Icons.edit,
                    label: 'Edit',
                    color: appColors.info,
                    onTap: () => _handleEdit(context),
                  ),
                  Container(
                    height: 1,
                    color: theme.colorScheme.outlineVariant,
                  ),
                  _ActionButton(
                    icon: Icons.delete,
                    label: 'Delete',
                    color: appColors.error,
                    onTap: () => _handleDelete(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressDetails(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      height: 1.5,
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(address.address1, style: style),
        if (address.address2?.isNotEmpty == true)
          Text(address.address2!, style: style),
        if (address.company?.isNotEmpty == true)
          Text(address.company!, style: style),
        Text(
          '${address.city}, ${address.zone} ${address.postcode}',
          style: style,
        ),
        Text(address.country, style: style),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
