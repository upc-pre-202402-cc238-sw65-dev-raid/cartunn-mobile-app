import 'package:cartunn/features/inventory/domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.image,
    required super.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      price: json['price'].toDouble(),
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      title: title,
      description: description,
      image: image,
      price: price,
    );
  }
}
