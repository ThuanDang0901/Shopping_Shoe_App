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
  });
}
