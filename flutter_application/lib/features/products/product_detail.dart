import 'package:flutter/material.dart';
import 'package:flutter_application/domain/models/product.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 240, color: Colors.grey[200], child: const Icon(Icons.image, size: 96)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, color: Colors.green)),
                const SizedBox(height: 12),
                const Text('Product details and description go here. This is a placeholder.'),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // add to cart stub
                      Navigator.pop(context);
                    },
                    child: const Text('Add to cart'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // buy now stub
                      Navigator.pop(context);
                    },
                    child: const Text('Buy now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
