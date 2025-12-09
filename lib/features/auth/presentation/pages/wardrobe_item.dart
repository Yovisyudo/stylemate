class WardrobeItem {
  final int id;
  final String name;
  final String categoryName;
  final String color;
  final String style;
  final String? imageUrl;
  final String? weatherSuitable;
  final String? material;

  WardrobeItem({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.color,
    required this.style,
    this.imageUrl,
    this.weatherSuitable,
    this.material,
  });
}
