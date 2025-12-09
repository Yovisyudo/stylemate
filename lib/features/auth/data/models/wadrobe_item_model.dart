


import 'package:stylemate/features/auth/presentation/pages/wardrobe_item.dart';

class WardrobeItemModel extends WardrobeItem {
  WardrobeItemModel({
    required super.id,
    required super.name,
    required super.categoryName,
    required super.color,
    required super.style,
    super.imageUrl,
    super.weatherSuitable,
    super.material,
  });

  factory WardrobeItemModel.fromJson(Map<String, dynamic> json) {
    return WardrobeItemModel(
      id: json['item_id'],
      name: json['name'],
      categoryName: json['category_name'] ?? '',
      color: json['color'],
      style: json['detected_style'] ?? json['style'],
      imageUrl: json['image_url'],
      weatherSuitable: json['weather_suitable'],
      material: json['material'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color,
      'style': style,
      'image_url': imageUrl,
    };
  }
}