class ProductRefund {
  final int id;
  final String title;
  final String description;
  final String status;
  ProductRefund({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });
  factory ProductRefund.fromJson(Map<String, dynamic> json) {
    return ProductRefund(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
    );
  }
}