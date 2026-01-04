import 'package:stylemate/features/auth/data/models/recommendation_item_model.dart';
import '../../domain/entities/recommendation.dart';

class RecommendationModel extends Recommendation {
  RecommendationModel({
    required super.id,
    required super.reason,
    required super.weatherTip,
    required super.items,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> itemsJson = json['items'] ?? [];

    final items = itemsJson
        .map(
          (item) => RecommendationItemModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();

    return RecommendationModel(
      id: int.tryParse((json['id'] ?? 0).toString()) ?? 0,
      reason: json['reason'] ?? 'Tidak ada alasan',
      weatherTip: json['weather_tip'] ?? json['weatherTip'] ?? '',
      items: items,
    );
  }
}
