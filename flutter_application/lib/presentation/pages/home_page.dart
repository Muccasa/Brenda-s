import 'package:flutter/material.dart';
import 'package:flutter_application/core/utils/logger.dart';
import 'package:flutter_application/features/products/products_page.dart';
import 'package:flutter_application/presentation/pages/admin_analytics_page.dart';
import 'package:flutter_application/presentation/pages/chat_support_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Logger.log('HomePage built');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('Brendas - Kitchen Essentials', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Shop by category', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 96,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _categoryTile('Cutlery'),
                _categoryTile('Pans'),
                _categoryTile('Knives'),
                _categoryTile('Accessories'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _featureTile(context, 'Products', 'Browse products', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductsPage()));
          }),
          const SizedBox(height: 8),
          _featureTile(context, 'Analytics', 'Admin analytics dashboard', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAnalyticsPage()));
          }),
          const SizedBox(height: 8),
          _featureTile(context, 'Chat Support', 'Contact support', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatSupportPage()));
          }),
        ],
      ),
    );
  }

  Widget _featureTile(BuildContext context, String title, String subtitle, VoidCallback onTap) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _categoryTile(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(label: Text(title)),
    );
  }
}
