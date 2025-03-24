import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import screens (will create these next)
import 'screens/home_screen.dart';
import 'screens/signal_details_screen.dart';
import 'screens/subscription_screen.dart';
import 'screens/settings_screen.dart';

// Import services (will create these next)
import 'services/api_service.dart';
import 'services/notification_service.dart';
import 'services/in_app_purchase_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BlackBullTradesApp());
}

class BlackBullTradesApp extends StatelessWidget {
  const BlackBullTradesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => APIService()),
        ChangeNotifierProvider(create: (_) => NotificationService()),
        ChangeNotifierProvider(create: (_) => InAppPurchaseService()),
      ],
      child: MaterialApp(
        title: 'Black Bull Trades',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF1A1A1A),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF252525),
            elevation: 0,
          ),
          cardTheme: CardTheme(
            color: const Color(0xFF252525),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFF3BA2F),        // Binance Yellow
            secondary: Color(0xFF2EBD85),      // Green for Buy signals
            error: Color(0xFFE74C3C),          // Red for Sell signals
            background: Color(0xFF1A1A1A),     // Dark background
            surface: Color(0xFF252525),        // Card background
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/signal-details': (context) => const SignalDetailsScreen(),
          '/subscription': (context) => const SubscriptionScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}