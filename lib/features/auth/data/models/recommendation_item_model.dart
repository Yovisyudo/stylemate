class RecommendationItemModel {
  final int id;
  final String name;
  final String imageUrl;
  final String? categoryName;

  RecommendationItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.categoryName,
  });

  factory RecommendationItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecommendationItemModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['image_url'], // 🔥 hasil normalisasi datasource
      categoryName: json['category_name'],
    );
  }
}
