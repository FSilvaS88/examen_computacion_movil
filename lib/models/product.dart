class ProductModel {
  final int id;
  final String name;
  final double price;
  final String image;
  final String state;

  ProductModel({
    this.id = 0,
    required this.name,
    required this.price,
    required this.image,
    required this.state,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['product_id'] ?? 0,
      name: json['product_name'],
      price: (json['product_price'] as num).toDouble(),
      image: json['product_image'] ?? '',
      state: json['product_state'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': name,
      'product_price': price,
      'product_image': image,
      'product_state': state,
    };
  }
}
