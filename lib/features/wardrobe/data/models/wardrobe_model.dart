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
         id: id,
         name: name,
         categoryId: categoryId,
         categoryName: categoryName,
         color: color,
         style: style,
         imageUrl: imageUrl,
       );

  factory WardrobeItemModel.fromJson(Map<String, dynamic> json) {
    // 1. SAFE PARSING IMAGE URL
    String rawImage = json['image'] ?? json['image_url'] ?? '';
    String finalImageUrl =
        rawImage.contains('http')
            ? rawImage
            : 'http://10.42.189.26:8080/uploads/$rawImage';

    return WardrobeItemModel(
      // 2. SAFE PARSING ID (Anti-Error String vs Int)
      // Apapun isinya (String/Int/Null), ubah ke String dulu, lalu parse ke Int
      id: int.tryParse((json['item_id'] ?? json['id'] ?? 0).toString()) ?? 0,

      name: json['name'] ?? '',

      // 3. SAFE PARSING CATEGORY ID
      categoryId: int.tryParse((json['category_id'] ?? 0).toString()) ?? 0,

      categoryName:
          json['category_name'] ?? json['categoryName'] ?? 'Kategori Umum',
      color: json['color'],
      style: json['style'],
      imageUrl: finalImageUrl,
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
