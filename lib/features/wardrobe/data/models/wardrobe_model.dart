// lib/features/wardrobe/data/models/wardrobe_item_model.dart
import '../../domain/entities/wardrobe_item.dart';

class WardrobeItemModel extends WardrobeItem {
  WardrobeItemModel({
    required int id,
    required String name,
    required int categoryId,
    String? categoryName,
    String? color,
    String? style,
    required String imageUrl,
  }) : super(
         // Memanggil super constructor dengan benar
         id: id,
         name: name,
         categoryId: categoryId,
         categoryName: categoryName,
         color: color,
         style: style,
         imageUrl: imageUrl,
       );

  factory WardrobeItemModel.fromJson(Map<String, dynamic> json) {
    return WardrobeItemModel(
      id:
          json['item_id'] is String
              ? int.parse(json['item_id'])
              : (json['item_id'] ?? 0),
      name: json['name'] ?? '',
      categoryId:
          json['category_id'] is String
              ? int.parse(json['category_id'])
              : (json['category_id'] ?? 0),
      categoryName: json['category_name'],
      color: json['color'],
      style: json['style'],
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category_id': categoryId,
      'color': color,
      'style': style,
      'image_url': imageUrl,
    };
  }
}
