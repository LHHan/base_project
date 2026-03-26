import 'package:base_project_getx/app/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductModel', () {
    final validJson = {
      'id': 1,
      'title': 'iPhone 9',
      'description': 'An apple mobile which is nothing like apple',
      'price': 549.99,
      'discountPercentage': 12.96,
      'rating': 4.69,
      'stock': 94,
      'brand': 'Apple',
      'category': 'smartphones',
      'thumbnail': 'https://example.com/image.jpg',
      'images': ['https://example.com/1.jpg', 'https://example.com/2.jpg'],
    };

    test('fromJson parses all fields correctly', () {
      final product = ProductModel.fromJson(validJson);

      expect(product.id, 1);
      expect(product.title, 'iPhone 9');
      expect(product.description, 'An apple mobile which is nothing like apple');
      expect(product.price, 549.99);
      expect(product.discountPercentage, 12.96);
      expect(product.rating, 4.69);
      expect(product.stock, 94);
      expect(product.brand, 'Apple');
      expect(product.category, 'smartphones');
      expect(product.thumbnail, 'https://example.com/image.jpg');
      expect(product.images.length, 2);
    });

    test('fromJson uses defaults when fields are null', () {
      final product = ProductModel.fromJson({
        'id': null,
        'title': null,
        'description': null,
        'price': null,
        'discountPercentage': null,
        'rating': null,
        'stock': null,
        'brand': null,
        'category': null,
        'thumbnail': null,
        'images': null,
      });

      expect(product.id, -1);
      expect(product.title, '');
      expect(product.price, 0.0);
      expect(product.stock, 0);
      expect(product.images, isEmpty);
    });

    test('toJson round-trips correctly', () {
      final original = ProductModel.fromJson(validJson);
      final json = original.toJson();
      final restored = ProductModel.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.price, original.price);
      expect(restored.rating, original.rating);
      expect(restored.images.length, original.images.length);
    });

    test('fromJson handles discountPercentage as int', () {
      final json = Map<String, dynamic>.from(validJson);
      json['discountPercentage'] = 10;

      final product = ProductModel.fromJson(json);
      expect(product.discountPercentage, 10.0);
    });

    test('fromJson handles empty images list', () {
      final json = Map<String, dynamic>.from(validJson);
      json['images'] = <String>[];

      final product = ProductModel.fromJson(json);
      expect(product.images, isEmpty);
    });
  });
}
