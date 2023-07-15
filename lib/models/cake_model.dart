class CakeModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  CakeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  factory CakeModel.fromJson(Map<String, dynamic> json) {
    return CakeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
  }
}
