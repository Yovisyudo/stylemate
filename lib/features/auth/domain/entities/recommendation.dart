import '../../data/models/recommendation_item_model.dart';

class Recommendation {
  final int id;
  final String reason;
  final String weatherTip;
  final List<RecommendationItemModel> items; // ✅ BENAR

  Recommendation({
    required this.id,
    required this.reason,
    required this.weatherTip,
    required this.items,
  });
}
