import '../../domain/entities/recommendation_item.dart';

class RecommendationItemModel extends RecommendationItem {
  // ✅ IP laptop Anda - Ganti ini jika IP berubah
  static const String _laptopIp = "192.168.1.10";

  const RecommendationItemModel({
    required super.id,
    required super.categoryName,
    required super.image,
  });

  factory RecommendationItemModel.fromJson(Map<String, dynamic> json) {
    // 🔍 DEBUG: Print raw JSON untuk cek struktur
    print('🔍 DEBUG RecommendationItem JSON: $json');

    // Ambil image URL dengan fallback untuk berbagai kemungkinan key
    String imageUrl =
        json['image'] ?? json['imageUrl'] ?? json['image_url'] ?? '';

    // ✅ PERBAIKI: Replace localhost dengan IP laptop
    if (imageUrl.isNotEmpty && imageUrl.contains('localhost')) {
      imageUrl = imageUrl.replaceAll('localhost', _laptopIp);
      print('🔄 URL diubah dari localhost ke $_laptopIp');
    }

    // 📷 DEBUG: Print hasil parsing
    print('📷 Image URL parsed: $imageUrl');

    // Parse ID dengan aman (bisa int atau string dari JSON)
    final int itemId =
        json['id'] is int
            ? json['id']
            : int.tryParse(json['id'].toString()) ?? 0;

    // Parse categoryName dengan fallback
    final String categoryName =
        json['categoryName'] ?? json['category_name'] ?? 'Unknown';

    return RecommendationItemModel(
      id: itemId,
      categoryName: categoryName,
      image: imageUrl,
    );
  }

  /// Optional: Method untuk convert ke JSON (jika diperlukan untuk save data)
  Map<String, dynamic> toJson() {
    return {'id': id, 'categoryName': categoryName, 'image': image};
  }

  /// Optional: Method untuk debugging
  @override
  String toString() {
    return 'RecommendationItemModel(id: $id, categoryName: $categoryName, image: $image)';
  }
}
