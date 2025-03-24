import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/crypto_currency.dart';

class PriceChart extends StatefulWidget {
  final List<dynamic> cryptos;
  final bool showControls;

  const PriceChart({
    super.key,
    required this.cryptos,
    this.showControls = false,
  });

  @override
  State<PriceChart> createState() => _PriceChartState();
}

class _PriceChartState extends State<PriceChart> {
  int _selectedTimeframe = 1; // 1D by default
  bool _showVolume = true;

  // Mock data - In real app, this would come from your API
  final List<FlSpot> _priceData = List.generate(
    24,
    (i) => FlSpot(
      i.toDouble(),
      40000 + (2000 * i.toDouble() * (0.5 - (i % 2))),
    ),
  );

  final List<FlSpot> _volumeData = List.generate(
    24,
    (i) => FlSpot(
      i.toDouble(),
      1000000 * (1 + (i % 3) * 0.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showControls) _buildControls(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LineChart(
              _mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            spacing: 8,
            children: [
              _timeframeButton('1H'),
              _timeframeButton('1D'),
              _timeframeButton('1W'),
              _timeframeButton('1M'),
            ],
          ),
          Row(
            children: [
              const Text(
                'Volume',
                style: TextStyle(fontSize: 12),
              ),
              Switch(
                value: _showVolume,
                onChanged: (value) {
                  setState(() {
                    _showVolume = value;
                  });
                },
                activeColor: const Color(0xFFF3BA2F),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeframeButton(String text) {
    final isSelected = text == '1D'; // Mock selection
    return InkWell(
      onTap: () {
        // TODO: Implement timeframe selection
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF3BA2F)
              : const Color(0xFFF3BA2F).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFF3BA2F),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  LineChartData _mainData() {
    return LineChartData(
      gridData: _buildGridData(),
      titlesData: _buildTitlesData(),
      borderData: _buildBorderData(),
      lineBarsData: [
        _buildPriceLine(),
        if (_showVolume) _buildVolumeLine(),
      ],
      minX: 0,
      maxX: 23,
      minY: _getMinY(),
      maxY: _getMaxY(),
      lineTouchData: _buildTouchData(),
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 1000,
      verticalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey.withOpacity(0.1),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: Colors.grey.withOpacity(0.1),
          strokeWidth: 1,
        );
      },
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 6,
          getTitlesWidget: (value, meta) {
            const style = TextStyle(
              color: Colors.grey,
              fontSize: 12,
            );
            String text;
            switch (value.toInt()) {
              case 0:
                text = '00:00';
                break;
              case 6:
                text = '06:00';
                break;
              case 12:
                text = '12:00';
                break;
              case 18:
                text = '18:00';
                break;
              default:
                return const SizedBox();
            }
            return Text(text, style: style);
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 10000,
          reservedSize: 42,
          getTitlesWidget: (value, meta) {
            return Text(
              '\$${(value / 1000).toStringAsFixed(1)}K',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            );
          },
        ),
      ),
    );
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: true,
      border: Border.all(
        color: Colors.grey.withOpacity(0.1),
      ),
    );
  }

  LineChartBarData _buildPriceLine() {
    return LineChartBarData(
      spots: _priceData,
      isCurved: true,
      color: const Color(0xFFF3BA2F),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: const Color(0xFFF3BA2F).withOpacity(0.1),
      ),
    );
  }

  LineChartBarData _buildVolumeLine() {
    return LineChartBarData(
      spots: _volumeData,
      isCurved: true,
      color: Colors.blue.withOpacity(0.5),
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: Colors.blue.withOpacity(0.1),
      ),
    );
  }

  LineTouchData _buildTouchData() {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.black.withOpacity(0.8),
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((LineBarSpot touchedSpot) {
            final isVolume = touchedSpot.barIndex == 1;
            return LineTooltipItem(
              isVolume
                  ? 'Vol: \$${_formatVolume(touchedSpot.y)}'
                  : '\$${touchedSpot.y.toStringAsFixed(2)}',
              TextStyle(
                color: isVolume ? Colors.blue : const Color(0xFFF3BA2F),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList();
        },
      ),
    );
  }

  double _getMinY() {
    final minPrice = _priceData.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    if (_showVolume) {
      final minVolume = _volumeData.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
      return minPrice < minVolume ? minPrice : minVolume;
    }
    return minPrice;
  }

  double _getMaxY() {
    final maxPrice = _priceData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    if (_showVolume) {
      final maxVolume = _volumeData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
      return maxPrice > maxVolume ? maxPrice : maxVolume;
    }
    return maxPrice;
  }

  String _formatVolume(double volume) {
    if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(2)}M';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(2)}K';
    }
    return volume.toStringAsFixed(2);
  }
}