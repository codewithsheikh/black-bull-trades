# Feature Plan for Black Bull Trades Mobile App

## Core Features Implementation

### 1. Cryptocurrency Selection
- Allow users to select up to 3 cryptocurrencies (BTC, ETH, BNB, SOL, etc.) in the free plan.
- Use `crypto_selection_widget.dart` to create a user-friendly selection interface.

### 2. Technical Signal Generation
- Implement real technical analysis logic using TA-Lib or TradingView API.
- Replace the mock signal generation in `APIService` with actual calculations for:
  - RSI
  - MACD
  - Moving Averages (EMA/SMA)
  - Fibonacci Retracements
  - ICT Concepts (Smart Money Concepts, Liquidity Sweeps, etc.)
- Ensure signals include:
  - Entry Zone
  - Stop Loss (SL1, SL2)
  - Take Profit Targets (TP1, TP2)

### 3. Real-time Push Notifications
- Use `NotificationService` to send real-time push notifications when signals are confirmed.
- Ensure notifications include relevant signal data and analysis.

### 4. Live Price Updates
- Implement live price updates using the CoinGecko or Binance API.
- Use `price_chart.dart` to display an interactive chart for price movements.

### 5. Subscription Model
- Implement a 3-day free trial followed by a $10/month subscription via Google Play & App Store.
- Use `in_app_purchase_service.dart` to handle in-app purchases.

### 6. UI/UX Design
- Design a clean, user-friendly interface inspired by the Binance mobile app.
- Ensure seamless navigation and accessibility for all users.

### 7. Future Enhancements
- Consider adding support for crypto payments (USDT) in future updates.