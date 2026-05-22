class Shoe {
  final String id;
  final String name;
  final String sku;
  final String description;
  final double price;
  final String image;
  final int stockQuantity;
  final int soldCount;
  final String category;
  final bool isActive;
  final List<String> colors;
  final List<int> sizes;
  bool isFavorite;

  Shoe({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.soldCount,
    required this.sku,
    required this.description,
    required this.stockQuantity,
    required this.category,
    required this.isActive,
    required this.colors,
    required this.sizes,
    this.isFavorite = false,
  });
}
