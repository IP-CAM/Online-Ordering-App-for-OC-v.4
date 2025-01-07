import 'package:flutter/material.dart';
import 'package:ordering_app/features/about/domain/entities/info_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatelessWidget {
  final ContactEntity contact;

  const ContactCard({
    super.key,
    required this.contact,
  });

  Future<void> _launchUrl(String url, String scheme) async {
    final Uri uri = Uri(
      scheme: scheme,
      path: url,
    );
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      await _launchUrl(phoneNumber, 'tel');
    } catch (e) {
      debugPrint('Error launching phone call: $e');
    }
  }

  Future<void> _sendEmail(String email) async {
    try {
      await _launchUrl(email, 'mailto');
    } catch (e) {
      debugPrint('Error launching email: $e');
    }
  }

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
                  Icons.store,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  contact.store,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildInfoTile(
              context,
              icon: Icons.place_outlined,
              value: contact.address,
            ),
            _buildDivider(),
            InkWell(
              onTap: () => _makePhoneCall(contact.telephone),
              child: _buildInfoTile(
                context,
                icon: Icons.contact_phone_outlined,
                value: contact.telephone,
                isInteractive: true,
              ),
            ),
            _buildDivider(),
            InkWell(
              onTap: () => _sendEmail(contact.email),
              child: _buildInfoTile(
                context,
                icon: Icons.email_outlined,
                value: contact.email,
                isInteractive: true,
              ),
            ),
            _buildDivider(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String value,
    bool isInteractive = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isInteractive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isInteractive
                            ? Theme.of(context).colorScheme.secondary
                            : null,
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