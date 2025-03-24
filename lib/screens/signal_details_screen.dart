import 'package:flutter/material.dart';
import '../models/technical_signal.dart';
import '../widgets/price_chart.dart';

class SignalDetailsScreen extends StatelessWidget {
  const SignalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signal = ModalRoute.of(context)!.settings.arguments as TechnicalSignal;

    return Scaffold(
      appBar: AppBar(
        title: Text('${signal.cryptoSymbol} Signal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share coming soon!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSignalHeader(signal),
            _buildPriceChart(signal),
            _buildPriceLevels(signal),
            _buildIndicators(signal),
            _buildAnalysis(signal),
          ],
        ),
      ),
    );
  }

  Widget _buildSignalHeader(TechnicalSignal signal) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: signal.getSignalColor().withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: signal.getSignalColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  signal.signalTypeString,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                signal.getStrengthString(),
                style: TextStyle(
                  color: signal.getSignalColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Generated on ${_formatDateTime(signal.timestamp)}',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChart(TechnicalSignal signal) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: PriceChart(
        cryptos: [signal.cryptoSymbol],
        showControls: true,
      ),
    );
  }

  Widget _buildPriceLevels(TechnicalSignal signal) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Levels',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPriceLevel(
            'Entry Zone',
            signal.entryZone,
            const Color(0xFFF3BA2F),
          ),
          const SizedBox(height: 8),
          _buildPriceLevel(
            'Stop Loss 1',
            signal.stopLoss1,
            Colors.red.shade300,
          ),
          const SizedBox(height: 8),
          _buildPriceLevel(
            'Stop Loss 2',
            signal.stopLoss2,
            Colors.red,
          ),
          const SizedBox(height: 8),
          _buildPriceLevel(
            'Take Profit 1',
            signal.takeProfit1,
            Colors.green.shade300,
          ),
          const SizedBox(height: 8),
          _buildPriceLevel(
            'Take Profit 2',
            signal.takeProfit2,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceLevel(String label, double price, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators(TechnicalSignal signal) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Technical Indicators',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildIndicatorCard('RSI', signal.indicators['rsi'].toString()),
          if (signal.indicators['macd'] != null) ...[
            const SizedBox(height: 8),
            _buildIndicatorCard(
              'MACD',
              'Line: ${signal.indicators['macd']['line'].toStringAsFixed(2)}\n'
              'Signal: ${signal.indicators['macd']['signal'].toStringAsFixed(2)}\n'
              'Histogram: ${signal.indicators['macd']['histogram'].toStringAsFixed(2)}',
            ),
          ],
          if (signal.indicators['moving_averages'] != null) ...[
            const SizedBox(height: 8),
            _buildIndicatorCard(
              'Moving Averages',
              'EMA20: \$${signal.indicators['moving_averages']['ema20'].toStringAsFixed(2)}\n'
              'EMA50: \$${signal.indicators['moving_averages']['ema50'].toStringAsFixed(2)}\n'
              'SMA200: \$${signal.indicators['moving_averages']['sma200'].toStringAsFixed(2)}',
            ),
          ],
          if (signal.indicators['fibonacci_levels'] != null) ...[
            const SizedBox(height: 8),
            _buildIndicatorCard(
              'Fibonacci Levels',
              signal.indicators['fibonacci_levels'].entries
                  .map((e) => '${e.key}: \$${e.value.toStringAsFixed(2)}')
                  .join('\n'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIndicatorCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysis(TechnicalSignal signal) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analysis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              signal.analysis,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}