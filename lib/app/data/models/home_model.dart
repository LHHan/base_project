/// Template model — replace with your actual data structure.
///
/// When creating a new model:
/// 1. Add fields matching your API response.
/// 2. Implement [fromJson] for deserialization.
/// 3. Implement [toJson] if you need to serialize for requests.
///
/// Example:
/// ```dart
/// class ProductModel {
///   final int id;
///   final String name;
///   final double price;
///
///   ProductModel({required this.id, required this.name, required this.price});
///
///   factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
///         id: json['id'] as int? ?? 0,
///         name: json['name'] as String? ?? '',
///         price: (json['price'] as num?)?.toDouble() ?? 0.0,
///       );
///
///   Map<String, dynamic> toJson() => {'id': id, 'name': name, 'price': price};
/// }
/// ```
class HomeModel {
  final int id;

  HomeModel({required this.id});

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        id: json['id'] as int? ?? -1,
      );

  Map<String, dynamic> toJson() => {'id': id};
}
