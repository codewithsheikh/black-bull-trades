import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/in_app_purchase_service.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Features'),
      ),
      body: Consumer<InAppPurchaseService>(
        builder: (context, purchaseService, child) {
          if (purchaseService.isPurchasePending) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing purchase...'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildFeaturesList(),
                _buildPricingCard(purchaseService),
                if (purchaseService.error != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      purchaseService.error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF3BA2F), Color(0xFFFFD700)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.star,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Upgrade to Premium',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get unlimited access to all features',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      {
        'icon': Icons.currency_bitcoin,
        'title': 'Unlimited Cryptocurrencies',
        'description': 'Track and analyze any cryptocurrency',
      },
      {
        'icon': Icons.notifications_active,
        'title': 'Real-time Notifications',
        'description': 'Get instant alerts for new signals',
      },
      {
        'icon': Icons.analytics,
        'title': 'Advanced Technical Analysis',
        'description': 'Access to all technical indicators',
      },
      {
        'icon': Icons.support_agent,
        'title': 'Priority Support',
        'description': '24/7 customer support access',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Premium Features',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...features.map((feature) => _buildFeatureItem(
                icon: feature['icon'] as IconData,
                title: feature['title'] as String,
                description: feature['description'] as String,
              )),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3BA2F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFF3BA2F),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(InAppPurchaseService purchaseService) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (purchaseService.canStartTrial) ...[
            const Text(
              'Start Your Free Trial',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              purchaseService.trialPeriodText,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => purchaseService.startTrial(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3BA2F),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Start Free Trial',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No credit card required',
              style: TextStyle(color: Colors.grey),
            ),
          ] else if (purchaseService.isInTrialPeriod) ...[
            Text(
              purchaseService.trialPeriodText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF3BA2F),
              ),
            ),
          ],
          const SizedBox(height: 24),
          const Text(
            'Premium Subscription',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${purchaseService.subscriptionPrice} / ${purchaseService.subscriptionPeriod}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF3BA2F),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: purchaseService.isSubscribed
                ? null
                : () => purchaseService.startSubscription(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF3BA2F),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              purchaseService.isSubscribed
                  ? 'Currently Subscribed'
                  : 'Subscribe Now',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => purchaseService.restorePurchases(),
            child: const Text('Restore Purchases'),
          ),
        ],
      ),
    );
  }
}