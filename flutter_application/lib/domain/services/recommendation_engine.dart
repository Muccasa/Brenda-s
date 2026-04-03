import 'package:flutter_application/domain/models/product.dart';

/// Simple in-memory recommendation engine interface.
class RecommendationEngine {
  /// Returns a list of recommended products for the given user/product context.
  /// This is a placeholder — replace with ML model, collaborative filtering
  /// or remote recommender service integration.
  List<Product> getRecommendations({String? userId, Product? forProduct}) {
    // TODO: implement real recommendation logic
    return const [];
  }
}
