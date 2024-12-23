import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseItem {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currencyCode;
  final ProductDetails productDetails;

  PurchaseItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyCode,
    required this.productDetails,
  });

  factory PurchaseItem.fromProductDetails(ProductDetails details) {
    return PurchaseItem(
      id: details.id,
      title: details.title,
      description: details.description,
      price: double.parse(details.price.replaceAll(RegExp(r'[^0-9.]'), '')),
      currencyCode: details.currencyCode,
      productDetails: details,
    );
  }
}
