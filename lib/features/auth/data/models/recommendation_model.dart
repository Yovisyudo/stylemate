import '../../domain/entities/recommendation.dart';
import 'recommendation_item_model.dart';

class RecommendationModel extends Recommendation {
  RecommendationModel({
    required super.id,
    required super.reason,
    required super.weatherTip,
    required super.items,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      id: json['id'],
      reason: json['reason'] ?? '',
      weatherTip: json['weather_tip'] ?? '',
      items: (json['items'] as List? ?? [])
          .map(
            (e) => RecommendationItemModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
    );
  }
}
