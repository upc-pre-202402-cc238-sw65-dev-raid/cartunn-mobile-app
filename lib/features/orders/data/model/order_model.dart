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
    id: json['id'] ?? 0, // Suponiendo que 'id' es un entero, asigna un valor predeterminado como 0
    name: json['name'] ?? 'N/A', // Valor predeterminado si 'name' es null
    description: json['description'] ?? 'No description', // Valor predeterminado para 'description'
    code: json['code'] ?? 'No code', // Valor predeterminado para 'code'
    entryDate: json['entryDate'] ?? '', // Valor predeterminado para 'entryDate'
    exitDate: json['exitDate'] ?? '', // Valor predeterminado para 'exitDate'
    status: json['status'] ?? 'unknown', // Valor predeterminado para 'status'
    imageUrl: json['imageUrl'] ?? '', // Valor predeterminado para 'imageUrl'
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