import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/crypto_currency.dart';
import '../models/technical_signal.dart';

class APIService extends ChangeNotifier {
  final String baseUrl = 'https://api.coingecko.com/api/v3';
  List<CryptoCurrency> selectedCryptos = [];
  List<TechnicalSignal> signals = [];
  bool isLoading = false;
  String? error;

  // Maximum number of cryptocurrencies allowed in free plan
  static const int maxFreePlanCryptos = 3;

  Future<void> fetchCryptoPrices() async {
    if (selectedCryptos.isEmpty) return;

    try {
      isLoading = true;
      notifyListeners();

      final symbols = selectedCryptos.map((c) => c.symbol.toLowerCase()).join(',');
      final response = await http.get(
        Uri.parse('$baseUrl/coins/markets?vs_currency=usd&ids=$symbols&order=market_cap_desc&sparkline=false'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        for (var crypto in selectedCryptos) {
          final marketData = data.firstWhere(
            (item) => item['symbol'].toString().toUpperCase() == crypto.symbol,
            orElse: () => null,
          );
          if (marketData != null) {
            crypto.currentPrice = marketData['current_price'].toDouble();
            crypto.priceChangePercent24h = marketData['price_change_percentage_24h'].toDouble();
          }
        }
        error = null;
      } else {
        error = 'Failed to fetch prices: ${response.statusCode}';
      }
    } catch (e) {
      error = 'Error fetching prices: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generateTechnicalSignals() async {
    if (selectedCryptos.isEmpty) return;

    try {
      isLoading = true;
      notifyListeners();

      // In a real app, this would call your backend API for actual technical analysis
      // For demo, we'll generate mock signals based on current prices
      signals = selectedCryptos.map((crypto) {
        final random = Random();
        final signalType = SignalType.values[random.nextInt(3)];
        final currentPrice = crypto.currentPrice;

        // Generate realistic price levels based on current price
        final volatilityFactor = 0.05; // 5% price movement
        final entryZone = currentPrice;
        final stopLoss1 = currentPrice * (1 - volatilityFactor * 1.5);
        final stopLoss2 = currentPrice * (1 - volatilityFactor * 2);
        final takeProfit1 = currentPrice * (1 + volatilityFactor * 2);
        final takeProfit2 = currentPrice * (1 + volatilityFactor * 3);

        return TechnicalSignal(
          cryptoSymbol: crypto.symbol,
          signalType: signalType,
          strength: SignalStrength.values[random.nextInt(3)],
          entryZone: entryZone,
          stopLoss1: stopLoss1,
          stopLoss2: stopLoss2,
          takeProfit1: takeProfit1,
          takeProfit2: takeProfit2,
          timestamp: DateTime.now(),
          indicators: _generateMockIndicators(currentPrice),
          analysis: _generateAnalysis(crypto.symbol, signalType),
        );
      }).toList();

      error = null;
    } catch (e) {
      error = 'Error generating signals: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _generateMockIndicators(double currentPrice) {
    final random = Random();
    return {
      'rsi': 30 + random.nextInt(40), // RSI between 30-70
      'macd': {
        'line': -2 + random.nextDouble() * 4, // MACD line between -2 and 2
        'signal': -2 + random.nextDouble() * 4, // Signal line between -2 and 2
        'histogram': -1 + random.nextDouble() * 2, // Histogram between -1 and 1
      },
      'moving_averages': {
        'ema20': currentPrice * (0.95 + random.nextDouble() * 0.1),
        'ema50': currentPrice * (0.93 + random.nextDouble() * 0.14),
        'sma200': currentPrice * (0.90 + random.nextDouble() * 0.2),
      },
      'fibonacci_levels': {
        '0.236': currentPrice * 0.964,
        '0.382': currentPrice * 0.938,
        '0.500': currentPrice * 0.915,
        '0.618': currentPrice * 0.892,
        '0.786': currentPrice * 0.857,
      },
    };
  }

  String _generateAnalysis(String symbol, SignalType signalType) {
    switch (signalType) {
      case SignalType.buy:
        return '$symbol shows bullish momentum with RSI indicating oversold conditions. MACD suggests potential trend reversal. Multiple support levels identified with ICT concepts showing institutional buying pressure. Fair Value Gap detected above current price, suggesting upward movement potential.';
      case SignalType.sell:
        return '$symbol displays bearish divergence with weakening momentum. Price approaching major resistance levels with potential liquidity sweep. Order blocks identified above current price suggest institutional selling pressure. Risk management crucial at current levels.';
      case SignalType.neutral:
        return '$symbol is consolidating within a range. Mixed signals from technical indicators suggest waiting for clearer direction. Monitor key support and resistance levels for potential breakout opportunities. Volume analysis shows declining trading activity.';
    }
  }

  bool canAddMoreCryptos() {
    return selectedCryptos.length < maxFreePlanCryptos;
  }

  void addCrypto(CryptoCurrency crypto) {
    if (canAddMoreCryptos() && !selectedCryptos.contains(crypto)) {
      selectedCryptos.add(crypto);
      notifyListeners();
      fetchCryptoPrices();
      generateTechnicalSignals();
    }
  }

  void removeCrypto(CryptoCurrency crypto) {
    selectedCryptos.remove(crypto);
    signals.removeWhere((signal) => signal.cryptoSymbol == crypto.symbol);
    notifyListeners();
  }
}