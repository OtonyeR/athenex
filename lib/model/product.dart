class Product {
  int? id; // SQLite primary key
  String name;
  double price;
  int quantity;
  String category;
  String? description;
  List<String> imagePaths; // multiple image paths

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
    this.description,
    List<String>? imagePaths,
  }) : imagePaths = imagePaths ?? [];

  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: map['id'] as int?,
    name: map['name'] as String,
    price: (map['price'] as num).toDouble(),
    quantity: map['quantity'] as int,
    category: map['category'] as String,
    description: map['description'] as String,
    imagePaths: (map['image_paths'] != null && map['image_paths'].toString().isNotEmpty)
        ? map['image_paths'].toString().split(',')
        : [],
  );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{
      'name': name,
      'price': price,
      'quantity': quantity,
      'category': category,
      'description': description ?? '',
      'image_paths': imagePaths.isNotEmpty ? imagePaths.join(',') : '',
    };
    if (id != null) m['id'] = id;
    return m;
  }
}
