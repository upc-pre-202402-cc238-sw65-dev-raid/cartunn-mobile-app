import 'package:cartunn/features/orders/domain/entities/order.dart';

class OrderModel extends Order{
  OrderModel({
    required super.id,
    required super.name,
    required super.description,
    required super.code,
    required super.entryDate,
    required super.exitDate,
    required super.status,
    required super.imageUrl,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      code: json['code'],
      entryDate: json['entryDate'],
      exitDate: json['exitDate'],
      status: json['status'],
      imageUrl: json['imageUrl'],
    );
  }

  Order toEntity() {
    return Order(
      id: id,
      name: name,
      description: description,
      code: code,
      entryDate: entryDate,
      exitDate: exitDate,
      status: status,
      imageUrl: imageUrl,
    );
  }
}