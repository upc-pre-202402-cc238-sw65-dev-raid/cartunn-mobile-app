class Order {
  final int id;
  final String name;
  final String description;
  final int code;
  final String entryDate;
  final String exitDate;
  final String status;
  final String imageUrl;

  Order({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.entryDate,
    required this.exitDate,
    required this.status,
    required this.imageUrl,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
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
}