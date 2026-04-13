import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('1x Stainless Spoon Set - \$9.99'),
            const Spacer(),
            const Text('Choose Payment Method', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // MPesa STK Push integration placeholder
              },
              icon: const Icon(Icons.mobile_friendly),
              label: const Text('Pay with M-Pesa'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                // Card payment (Stripe) placeholder
              },
              icon: const Icon(Icons.credit_card),
              label: const Text('Pay with Card'),
            ),
          ],
        ),
      ),
    );
  }
}
