import 'package:flutter/foundation.dart';
import 'package:stylemate/features/auth/data/models/recommendation_item_model.dart';
import 'package:stylemate/features/auth/domain/entities/recommendation_item.dart';


@immutable
abstract class Recommendation {
  final int id;
  final String reason;
  final String weatherTip;
  final List<RecommendationItem> items;

  const Recommendation({
    required this.id,
    required this.reason,
    required this.weatherTip,
    required this.items,
  });
}
