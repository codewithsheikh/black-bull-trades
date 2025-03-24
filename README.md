# Black Bull Trades

A professional Crypto Technical Analysis Signal Mobile App built with Flutter.

## Features

✅ **Cryptocurrency Selection**
- Select up to 3 cryptocurrencies in free plan
- Support for major cryptocurrencies (BTC, ETH, BNB, SOL, etc.)
- Real-time price updates

✅ **Technical Analysis Signals**
- Automated Buy/Sell/Neutral signals
- Advanced technical indicators:
  - RSI
  - MACD
  - Moving Averages (EMA/SMA)
  - Fibonacci Retracements
  - ICT Smart Money Concepts
  - Liquidity Sweeps
  - Fair Value Gaps (FVG)
  - Order Blocks
  - Trend Analysis
  - Chart Patterns
  - Candlestick Patterns
  - Volume Analysis
  - Support & Resistance Zones

✅ **Signal Details**
- Entry Zone
- Stop Loss (SL1, SL2)
- Take Profit Targets (TP1, TP2)
- Detailed analysis and reasoning
- Interactive price charts

✅ **Real-time Notifications**
- Push notifications for new signals
- Price alerts
- Market news updates

✅ **Premium Features**
- 3-Day Free Trial
- $10/month subscription
- Unlimited cryptocurrency selection
- Advanced indicator access
- Priority support

## Technical Stack

- **Frontend**: Flutter
- **State Management**: Provider
- **Charts**: fl_chart
- **API Integration**: http
- **Push Notifications**: Firebase Cloud Messaging
- **In-App Purchases**: in_app_purchase
- **Market Data**: CoinGecko API

## Project Structure

```
black_bull_trades/
├── lib/
│   ├── models/
│   │   ├── crypto_currency.dart
│   │   └── technical_signal.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── signal_details_screen.dart
│   │   ├── subscription_screen.dart
│   │   └── settings_screen.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── notification_service.dart
│   │   └── in_app_purchase_service.dart
│   ├── widgets/
│   │   ├── crypto_selection_widget.dart
│   │   ├── signal_card.dart
│   │   └── price_chart.dart
│   └── main.dart
└── pubspec.yaml
```

## Setup Instructions

1. **Prerequisites**
   - Flutter SDK
   - Android Studio / Xcode
   - Firebase project setup
   - Google Play / App Store developer accounts

2. **Installation**
   ```bash
   # Clone the repository
   git clone https://github.com/yourusername/black_bull_trades.git

   # Navigate to project directory
   cd black_bull_trades

   # Install dependencies
   flutter pub get

   # Run the app
   flutter run
   ```

3. **Configuration**
   - Set up Firebase project and add google-services.json/GoogleService-Info.plist
   - Configure in-app purchases in Google Play Console / App Store Connect
   - Update API endpoints in api_service.dart

## Development Guidelines

- Follow Flutter best practices and conventions
- Maintain consistent code formatting
- Write comprehensive documentation
- Include unit tests for critical functionality
- Use meaningful commit messages

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.