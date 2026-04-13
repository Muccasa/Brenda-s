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
          _featureTile(context, 'Products', 'Browse products', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductsPage()));
          }),
          _featureTile(context, 'Analytics', 'Admin analytics dashboard', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAnalyticsPage()));
          }),
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
}
