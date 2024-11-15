import 'dart:convert';
import 'package:cartunn/features/orders/data/model/order_model.dart';
import 'package:cartunn/features/auth/data/remote/auth_service.dart';
import 'package:http/http.dart' as http;

class OrderRemoteDataSource {
  final AuthService authService;

  OrderRemoteDataSource(this.authService);

  Future<List<OrderModel>> getOrders() async {
    final token = authService.token;
    if (token == null) {
      print('Error: El token es null en getOrders');
      throw Exception('No token found. Please login first.');
    }

    final response = await http.get(
      Uri.parse('https://cartunn.up.railway.app/api/v1/orders'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<OrderModel>.from(data.map((x) => OrderModel.fromJson(x)))
          .toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }
}
