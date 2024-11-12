import 'package:cartunn/features/manageRefunds/domain/entity/product_refund.dart';

class ProductRefundModel extends ProductRefund {	
  ProductRefundModel({
    required super.id,
    required super.title,
    required super.description,
    required super.status,
  });

  factory ProductRefundModel.fromJson(Map<String, dynamic> json) {
    return ProductRefundModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
    );
  }
  ProductRefund toEntity() {
    return ProductRefund(
      id: id,
      title: title,
      description: description,
      status: status,
    );
  }
}
