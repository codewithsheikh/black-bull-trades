import 'package:flutter/material.dart';
import '../models/technical_signal.dart';

class SignalCard extends StatelessWidget {
  final TechnicalSignal signal;
  final VoidCallback? onTap;

  const SignalCard({
    super.key,
    required this.signal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: signal.getSignalColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildPriceLevels(),
              const SizedBox(height: 16),
              _buildIndicators(),
              const SizedBox(height: 8),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
            const SizedBox(width: 8),
            Text(
              signal.cryptoSymbol,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: signal.getSignalColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            signal.getStrengthString(),
            style: TextStyle(
              color: signal.getSignalColor(),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceLevels() {
    return Column(
      children: [
        _buildPriceLevel(
          'Entry',
          signal.entryZone,
          const Color(0xFFF3BA2F),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildPriceLevel(
                'SL1',
                signal.stopLoss1,
                Colors.red.shade300,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPriceLevel(
                'TP1',
                signal.takeProfit1,
                Colors.green.shade300,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceLevel(String label, double price, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
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

  Widget _buildIndicators() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildIndicatorChip(
          'RSI',
          signal.indicators['rsi'].toString(),
        ),
        if (signal.indicators['macd'] != null)
          _buildIndicatorChip(
            'MACD',
            signal.indicators['macd']['histogram'].toStringAsFixed(2),
          ),
        if (signal.indicators['moving_averages'] != null)
          _buildIndicatorChip(
            'EMA20',
            '\$${signal.indicators['moving_averages']['ema20'].toStringAsFixed(2)}',
          ),
      ],
    );
  }

  Widget _buildIndicatorChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatTimestamp(signal.timestamp),
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
        const Row(
          children: [
            Icon(
              Icons.arrow_forward,
              size: 16,
              color: Color(0xFFF3BA2F),
            ),
            SizedBox(width: 4),
            Text(
              'View Details',
              style: TextStyle(
                color: Color(0xFFF3BA2F),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}