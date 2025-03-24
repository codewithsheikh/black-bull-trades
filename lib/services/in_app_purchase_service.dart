import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseService extends ChangeNotifier {
  static const String _monthlySubscriptionId = 'black_bull_trades_monthly';
  static const String _trialPeriodDays = '3';
  
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _isPurchasePending = false;
  bool _isSubscribed = false;
  DateTime? _trialEndDate;
  String? _error;

  bool get isAvailable => _isAvailable;
  bool get isPurchasePending => _isPurchasePending;
  bool get isSubscribed => _isSubscribed;
  bool get isInTrialPeriod => _trialEndDate?.isAfter(DateTime.now()) ?? false;
  String? get error => _error;
  List<ProductDetails> get products => _products;

  InAppPurchaseService() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _isAvailable = await _iap.isAvailable();
      if (!_isAvailable) {
        _error = 'Store not available';
        notifyListeners();
        return;
      }

      // Listen to purchase updates
      _subscription = _iap.purchaseStream.listen(
        _handlePurchaseUpdate,
        onDone: () => _subscription.cancel(),
        onError: (error) {
          _error = 'Purchase stream error: $error';
          notifyListeners();
        },
      );

      // Load products
      await _loadProducts();
      
      // Restore purchases
      await restorePurchases();
      
      // Check trial period
      _checkTrialPeriod();
      
    } catch (e) {
      _error = 'Initialization error: $e';
      notifyListeners();
    }
  }

  Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response = await _iap.queryProductDetails({_monthlySubscriptionId});
      
      if (response.error != null) {
        _error = 'Error loading products: ${response.error}';
        notifyListeners();
        return;
      }

      _products = response.productDetails;
      notifyListeners();
    } catch (e) {
      _error = 'Error loading products: $e';
      notifyListeners();
    }
  }

  Future<void> _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _isPurchasePending = true;
      } else {
        _isPurchasePending = false;
        
        if (purchaseDetails.status == PurchaseStatus.error) {
          _error = 'Error: ${purchaseDetails.error}';
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                   purchaseDetails.status == PurchaseStatus.restored) {
          _isSubscribed = true;
          _trialEndDate = null;
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    }
    notifyListeners();
  }

  Future<void> startSubscription() async {
    if (_products.isEmpty) {
      _error = 'No products available';
      notifyListeners();
      return;
    }

    final ProductDetails product = _products.first;
    
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName: null, // Optional user identifier
      );

      _isPurchasePending = true;
      notifyListeners();

      // Start the purchase flow
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      _error = 'Purchase error: $e';
      _isPurchasePending = false;
      notifyListeners();
    }
  }

  Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (e) {
      _error = 'Restore purchases error: $e';
      notifyListeners();
    }
  }

  void startTrial() {
    if (!isInTrialPeriod && !_isSubscribed) {
      _trialEndDate = DateTime.now().add(Duration(days: int.parse(_trialPeriodDays)));
      notifyListeners();
    }
  }

  void _checkTrialPeriod() {
    if (_trialEndDate != null && _trialEndDate!.isBefore(DateTime.now())) {
      _trialEndDate = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // Helper methods for UI
  String get subscriptionPrice {
    if (_products.isEmpty) return 'Loading...';
    return _products.first.price;
  }

  String get subscriptionPeriod {
    return 'Monthly';
  }

  String get trialPeriodText {
    if (isInTrialPeriod) {
      final daysLeft = _trialEndDate!.difference(DateTime.now()).inDays + 1;
      return '$daysLeft days left in trial';
    }
    return '$_trialPeriodDays-day free trial';
  }

  bool get canStartTrial {
    return !isInTrialPeriod && !_isSubscribed && _trialEndDate == null;
  }
}