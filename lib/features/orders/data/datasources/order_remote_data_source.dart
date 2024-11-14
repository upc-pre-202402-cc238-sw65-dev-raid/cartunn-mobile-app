import 'dart:convert';
import 'package:cartunn/features/orders/data/model/order_mOdel.dart';
import 'package:cartunn/features/orders/domain/entities/order.dart';
import 'package:http/http.dart' as http;

class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders() async {
    final response = await http
        .get(Uri.parse('https://cartunn.up.railway.app/api/v1/orders'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<OrderModel>.from(data.map((x) => Order.fromJson(x))).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }
}