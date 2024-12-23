import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'models/purchase_item.dart';
import 'models/purchase_result.dart';

class InAppPurchasesHelper {
  static final InAppPurchasesHelper _instance = InAppPurchasesHelper._internal();
  factory InAppPurchasesHelper() => _instance;
  InAppPurchasesHelper._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final List<PurchaseItem> _products = [];
  
  bool _isInitialized = false;

  /// Initialize the helper
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      throw PlatformException(
        code: 'store_not_available',
        message: 'Store is not available',
      );
    }

    _subscription = _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        debugPrint('Error in purchase stream: $error');
      },
    );

    _isInitialized = true;
  }

  /// Load products from store
  Future<List<PurchaseItem>> loadProducts(List<String> productIds) async {
    if (!_isInitialized) await initialize();
    
    final ProductDetailsResponse response = 
        await _inAppPurchase.queryProductDetails(productIds.toSet());

    if (response.error != null) {
      throw PlatformException(
        code: 'products_load_error',
        message: response.error!.message,
      );
    }

    _products.clear();
    for (var product in response.productDetails) {
      _products.add(PurchaseItem.fromProductDetails(product));
    }

    return _products;
  }

  /// Purchase a product
  Future<void> purchaseProduct(String productId) async {
    final product = _products.firstWhere(
      (element) => element.id == productId,
      orElse: () => throw PlatformException(
        code: 'product_not_found',
        message: 'Product $productId not found',
      ),
    );

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: product.productDetails,
    );

    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Handle pending purchases
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle error
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                 purchaseDetails.status == PurchaseStatus.restored) {
        // Handle successful purchase
      }
      
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  /// Dispose resources
  void dispose() {
    _subscription?.cancel();
    _isInitialized = false;
  }
}
