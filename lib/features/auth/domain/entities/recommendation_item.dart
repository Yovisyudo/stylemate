import 'package:flutter/foundation.dart';

@immutable
class RecommendationItem {
  final int id;
  final String categoryName;
  final String image;

  const RecommendationItem({
    required this.id,
    required this.categoryName,
    required this.image,
  });
}
