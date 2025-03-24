import 'package:flutter/material.dart';

enum SignalType { buy, sell, neutral }

enum SignalStrength { strong, moderate, weak }

class TechnicalSignal {
  final String cryptoSymbol;
  final SignalType signalType;
  final SignalStrength strength;
  final double entryZone;
  final double stopLoss1;
  final double stopLoss2;
  final double takeProfit1;
  final double takeProfit2;
  final DateTime timestamp;
  final Map<String, dynamic> indicators;
  final String analysis;

  TechnicalSignal({
    required this.cryptoSymbol,
    required this.signalType,
    required this.strength,
    required this.entryZone,
    required this.stopLoss1,
    required this.stopLoss2,
    required this.takeProfit1,
    required this.takeProfit2,
    required this.timestamp,
    required this.indicators,
    required this.analysis,
  });

  factory TechnicalSignal.fromJson(Map<String, dynamic> json) {
    return TechnicalSignal(
      cryptoSymbol: json['crypto_symbol'],
      signalType: SignalType.values.firstWhere(
        (e) => e.toString() == 'SignalType.${json['signal_type']}',
      ),
      strength: SignalStrength.values.firstWhere(
        (e) => e.toString() == 'SignalStrength.${json['strength']}',
      ),
      entryZone: json['entry_zone'].toDouble(),
      stopLoss1: json['stop_loss_1'].toDouble(),
      stopLoss2: json['stop_loss_2'].toDouble(),
      takeProfit1: json['take_profit_1'].toDouble(),
      takeProfit2: json['take_profit_2'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      indicators: Map<String, dynamic>.from(json['indicators']),
      analysis: json['analysis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crypto_symbol': cryptoSymbol,
      'signal_type': signalType.toString().split('.').last,
      'strength': strength.toString().split('.').last,
      'entry_zone': entryZone,
      'stop_loss_1': stopLoss1,
      'stop_loss_2': stopLoss2,
      'take_profit_1': takeProfit1,
      'take_profit_2': takeProfit2,
      'timestamp': timestamp.toIso8601String(),
      'indicators': indicators,
      'analysis': analysis,
    };
  }

  String get signalTypeString {
    switch (signalType) {
      case SignalType.buy:
        return 'BUY';
      case SignalType.sell:
        return 'SELL';
      case SignalType.neutral:
        return 'NEUTRAL';
    }
  }

  Color getSignalColor() {
    switch (signalType) {
      case SignalType.buy:
        return const Color(0xFF2EBD85); // Green
      case SignalType.sell:
        return const Color(0xFFE74C3C); // Red
      case SignalType.neutral:
        return const Color(0xFFF3BA2F); // Yellow
    }
  }

  String getStrengthString() {
    switch (strength) {
      case SignalStrength.strong:
        return 'Strong Signal';
      case SignalStrength.moderate:
        return 'Moderate Signal';
      case SignalStrength.weak:
        return 'Weak Signal';
    }
  }
}