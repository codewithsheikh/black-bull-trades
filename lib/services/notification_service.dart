import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../models/technical_signal.dart';

class NotificationService extends ChangeNotifier {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool _isInitialized = false;
  bool _permissionGranted = false;

  NotificationService() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    if (_isInitialized) return;

    try {
      // Request permission for iOS devices
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      _permissionGranted = settings.authorizationStatus == AuthorizationStatus.authorized;

      // Configure FCM callbacks
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Get FCM token
      String? token = await _fcm.getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');
        // TODO: Send this token to your backend
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Received foreground message: ${message.data}');
    _processSignalNotification(message.data);
  }

  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    debugPrint('App opened from notification: ${message.data}');
    _processSignalNotification(message.data);
  }

  void _processSignalNotification(Map<String, dynamic> data) {
    try {
      if (data['type'] == 'technical_signal') {
        final signalData = Map<String, dynamic>.from(data['signal']);
        final signal = TechnicalSignal.fromJson(signalData);
        
        // TODO: Update UI with new signal
        // You might want to use a stream or callback to notify the UI
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error processing notification data: $e');
    }
  }

  Future<void> subscribeToSymbol(String symbol) async {
    if (!_permissionGranted) return;

    try {
      await _fcm.subscribeToTopic('signal_${symbol.toLowerCase()}');
      debugPrint('Subscribed to notifications for $symbol');
    } catch (e) {
      debugPrint('Error subscribing to $symbol notifications: $e');
    }
  }

  Future<void> unsubscribeFromSymbol(String symbol) async {
    try {
      await _fcm.unsubscribeFromTopic('signal_${symbol.toLowerCase()}');
      debugPrint('Unsubscribed from notifications for $symbol');
    } catch (e) {
      debugPrint('Error unsubscribing from $symbol notifications: $e');
    }
  }
}

// This function must be declared outside the class as a top-level function
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.data}');
  // Implement background message handling logic here
}

// Example notification payload:
/*
{
  "type": "technical_signal",
  "signal": {
    "crypto_symbol": "BTC",
    "signal_type": "buy",
    "strength": "strong",
    "entry_zone": 45000.00,
    "stop_loss_1": 44100.00,
    "stop_loss_2": 43500.00,
    "take_profit_1": 46500.00,
    "take_profit_2": 48000.00,
    "timestamp": "2024-01-20T10:30:00Z",
    "indicators": {
      "rsi": 32,
      "macd": {
        "line": 0.5,
        "signal": 0.2,
        "histogram": 0.3
      }
    },
    "analysis": "BTC shows strong bullish momentum..."
  }
}
*/