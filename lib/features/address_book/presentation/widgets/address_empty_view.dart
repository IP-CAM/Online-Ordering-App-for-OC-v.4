import 'package:flutter/material.dart';
import 'package:ordering_app/config/theme/custom_colors.dart';

class EmptyAddressView extends StatelessWidget {
  final VoidCallback onAddAddress;

  const EmptyAddressView({
    super.key,
    required this.onAddAddress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: appColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_outlined,
                size: 48,
                color: appColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No addresses found',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first delivery address to get started',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAddAddress,
              icon: const Icon(Icons.add),
              label: const Text('Add New Address'),
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.primary,
                foregroundColor: theme.colorScheme.surface,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}