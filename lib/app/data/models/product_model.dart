class ProductModel {
  int id;
  String title;
  String description;
  double price;
  double discountPercentage;
  double rating;
  int stock;
  String brand;
  String category;
  String thumbnail;
  List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as int? ?? -1,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        price: json['price'] as double? ?? 0.0,
        discountPercentage: double.tryParse(
                json['discountPercentage'].toString() as String? ?? '0.0') ??
            0.0,
        rating: json['rating'] as double? ?? 0.0,
        stock: json['stock'] as int? ?? 0,
        brand: json['brand'] as String? ?? '',
        category: json['category'] as String? ?? '',
        thumbnail: json['thumbnail'] as String? ?? '',
        images: json['images'] == null
            ? []
            : json['images'].cast<String>() as List<String>? ?? [],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'discountPercentage': discountPercentage,
        'rating': rating,
        'stock': stock,
        'brand': brand,
        'category': category,
        'thumbnail': thumbnail,
        'images': images,
      };
}
