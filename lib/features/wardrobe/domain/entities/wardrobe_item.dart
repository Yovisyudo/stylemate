// lib/features/wardrobe/domain/entities/wardrobe_item.dart
class WardrobeItem {
  final int id; // Ini akan map ke item_id di DB
  final String name;
  final int categoryId; // Ini wajib ada untuk relasi ke tabel categories
  final String? categoryName; // Nullable karena hasil JOIN
  final String? color;
  final String? style;
  final String imageUrl;

  WardrobeItem({
    required this.id,
    required this.name,
    required this.categoryId,
    this.categoryName,
    this.color,
    this.style,
    required this.imageUrl,
  });
}
