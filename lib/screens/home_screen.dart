import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crypto_currency.dart';
import '../models/technical_signal.dart';
import '../services/api_service.dart';
import '../widgets/crypto_selection_widget.dart';
import '../widgets/signal_card.dart';
import '../widgets/price_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // Initial data fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final apiService = Provider.of<APIService>(context, listen: false);
      apiService.fetchCryptoPrices();
      apiService.generateTechnicalSignals();
    });
  }

  Future<void> _refreshData() async {
    final apiService = Provider.of<APIService>(context, listen: false);
    await apiService.fetchCryptoPrices();
    await apiService.generateTechnicalSignals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Black Bull Trades',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF3BA2F), // Binance Yellow
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: Consumer<APIService>(
          builder: (context, apiService, child) {
            if (apiService.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (apiService.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${apiService.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: _refreshData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Cryptocurrencies',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CryptoSelectionWidget(
                          selectedCryptos: apiService.selectedCryptos,
                          onCryptoSelected: apiService.addCrypto,
                          onCryptoRemoved: apiService.removeCrypto,
                        ),
                      ],
                    ),
                  ),
                ),
                if (apiService.selectedCryptos.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price Chart',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 300,
                            child: PriceChart(
                              cryptos: apiService.selectedCryptos,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Technical Signals',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: _refreshData,
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final signal = apiService.signals[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: SignalCard(
                            signal: signal,
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/signal-details',
                              arguments: signal,
                            ),
                          ),
                        );
                      },
                      childCount: apiService.signals.length,
                    ),
                  ),
                ] else
                  const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Select up to 3 cryptocurrencies to start\nreceiving technical signals',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/subscription'),
        icon: const Icon(Icons.star),
        label: const Text('Upgrade'),
        backgroundColor: const Color(0xFFF3BA2F), // Binance Yellow
      ),
    );
  }
}