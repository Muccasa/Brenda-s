import 'package:flutter/material.dart';
import 'package:flutter_application/domain/models/product.dart';
import 'package:flutter_application/features/products/product_card.dart';
import 'package:flutter_application/features/products/product_detail.dart';
import 'package:flutter_application/features/products/checkout_page.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = _mockProducts();

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetail(product: p))),
            child: ProductCard(product: p),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutPage())),
        label: const Text('Checkout'),
        icon: const Icon(Icons.shopping_cart),
      ),
    );
  }

  List<Product> _mockProducts() => [
        Product(id: 'p1', name: 'Stainless Spoon Set', price: 9.99),
        Product(id: 'p2', name: 'Chef Knife 8"', price: 24.99),
        Product(id: 'p3', name: 'Non-stick Pan', price: 19.99),
        Product(id: 'p4', name: 'Cutting Board', price: 7.99),
        Product(id: 'p5', name: 'Measuring Cups', price: 5.49),
        Product(id: 'p6', name: 'Wooden Spatula', price: 3.99),
      ];
}
