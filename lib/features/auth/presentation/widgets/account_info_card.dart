import 'package:flutter/material.dart';
import 'package:ordering_app/core/common/entities/login_info_entity.dart';

class AccountInfoCard extends StatelessWidget {
  final LoginInfoEntity userInfo;

  const AccountInfoCard({
    super.key,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_pin,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Personal Information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildInfoTile(
              context,
              icon: Icons.person_outline,
              label: 'Full Name',
              value: '${userInfo.firstName ?? 'N/A'} ${userInfo.lastName ?? ''}',
            ),
            _buildDivider(),
            _buildInfoTile(
              context,
              icon: Icons.email_outlined,
              label: 'Email Address',
              value: userInfo.email ?? 'N/A',
            ),
            _buildDivider(),
            _buildInfoTile(
              context,
              icon: Icons.phone_outlined,
              label: 'Phone Number',
              value: userInfo.telephone?.isEmpty ?? true
                  ? 'Not provided'
                  : userInfo.telephone!,
            ),
            if (userInfo.telephone?.isEmpty ?? true)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 36.0),
                child: TextButton.icon(
                  onPressed: () {
                    // TODO: Implement add phone number functionality
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: Text(
                    'Add phone number',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey.withOpacity(0.2),
      ),
    );
  }
}