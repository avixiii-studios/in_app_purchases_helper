# In-App Purchases Helper

A Flutter package to easily integrate in-app purchases for both Android and iOS platforms.

## Features

- Easy to integrate in-app purchases
- Support for both Android and iOS platforms
- Handle consumable and non-consumable products
- Simple API for purchase management
- Built-in purchase status tracking

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  in_app_purchases_helper: ^0.0.1
```

### Usage

1. Initialize the helper:

```dart
final purchasesHelper = InAppPurchasesHelper();
await purchasesHelper.initialize();
```

2. Load products:

```dart
final products = await purchasesHelper.loadProducts(['product_id_1', 'product_id_2']);
```

3. Make a purchase:

```dart
await purchasesHelper.purchaseProduct('product_id_1');
```

## Additional Setup Required

### For Android:

1. Create an application in the Google Play Console
2. Configure your in-app products
3. Add your app's license key to your app's build.gradle file

### For iOS:

1. Set up your app in App Store Connect
2. Configure your in-app purchases
3. Add the "In-App Purchase" capability in Xcode

## License

This project is licensed under the MIT License - see the LICENSE file for details