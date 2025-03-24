import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';
import '../services/in_app_purchase_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildNotificationSettings(context),
          _buildSubscriptionSettings(context),
          _buildAppSettings(context),
          _buildSupportSection(context),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context) {
    return Consumer<NotificationService>(
      builder: (context, notificationService, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF3BA2F),
                ),
              ),
            ),
            SwitchListTile(
              title: const Text('Signal Alerts'),
              subtitle: const Text('Receive notifications for new trading signals'),
              value: true, // TODO: Implement notification preferences
              onChanged: (bool value) {
                // TODO: Implement notification toggle
              },
            ),
            SwitchListTile(
              title: const Text('Price Alerts'),
              subtitle: const Text('Get notified about significant price changes'),
              value: false, // TODO: Implement notification preferences
              onChanged: (bool value) {
                // TODO: Implement notification toggle
              },
            ),
            SwitchListTile(
              title: const Text('News Updates'),
              subtitle: const Text('Stay informed about market news'),
              value: false, // TODO: Implement notification preferences
              onChanged: (bool value) {
                // TODO: Implement notification toggle
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubscriptionSettings(BuildContext context) {
    return Consumer<InAppPurchaseService>(
      builder: (context, purchaseService, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Subscription',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF3BA2F),
                ),
              ),
            ),
            ListTile(
              title: const Text('Current Plan'),
              subtitle: Text(
                purchaseService.isSubscribed
                    ? 'Premium'
                    : purchaseService.isInTrialPeriod
                        ? 'Free Trial'
                        : 'Free Plan',
              ),
              trailing: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/subscription'),
                child: Text(
                  purchaseService.isSubscribed ? 'Manage' : 'Upgrade',
                ),
              ),
            ),
            if (purchaseService.isInTrialPeriod)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  purchaseService.trialPeriodText,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAppSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'App Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF3BA2F),
            ),
          ),
        ),
        ListTile(
          title: const Text('Theme'),
          subtitle: const Text('Dark'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement theme selection
          },
        ),
        ListTile(
          title: const Text('Currency'),
          subtitle: const Text('USD'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement currency selection
          },
        ),
        ListTile(
          title: const Text('Chart Preferences'),
          subtitle: const Text('Customize chart appearance'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement chart settings
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Support',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF3BA2F),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help Center'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement help center navigation
          },
        ),
        ListTile(
          leading: const Icon(Icons.mail_outline),
          title: const Text('Contact Support'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement contact support
          },
        ),
        ListTile(
          leading: const Icon(Icons.star_outline),
          title: const Text('Rate the App'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement app rating
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF3BA2F),
            ),
          ),
        ),
        ListTile(
          title: const Text('Version'),
          subtitle: const Text('1.0.0'),
        ),
        ListTile(
          title: const Text('Terms of Service'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement terms of service navigation
          },
        ),
        ListTile(
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement privacy policy navigation
          },
        ),
        const ListTile(
          title: Text('© 2024 Black Bull Trades'),
          subtitle: Text('All rights reserved'),
        ),
      ],
    );
  }
}