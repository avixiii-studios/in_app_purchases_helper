import 'package:flutter/material.dart';
import 'package:in_app_purchases_helper/in_app_purchases_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'In-App Purchases Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const StoreScreen(),
    );
  }
}

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final _purchasesHelper = InAppPurchasesHelper();
  List<PurchaseItem> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeStore();
  }

  Future<void> _initializeStore() async {
    try {
      await _purchasesHelper.initialize();
      final products = await _purchasesHelper.loadProducts([
        'test_product_1',
        'test_product_2',
      ]);
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _purchaseProduct(String productId) async {
    try {
      await _purchasesHelper.purchaseProduct(productId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text(product.description),
                  trailing: TextButton(
                    onPressed: () => _purchaseProduct(product.id),
                    child: Text('${product.price} ${product.currencyCode}'),
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _purchasesHelper.dispose();
    super.dispose();
  }
}
