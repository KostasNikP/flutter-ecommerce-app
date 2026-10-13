class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String imagePath;
  final List<String> imagePaths;
  final String category;
  int quantity;
 
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
    this.imagePaths = const [],
    required this.category,
    this.quantity = 1,
  });
}
 