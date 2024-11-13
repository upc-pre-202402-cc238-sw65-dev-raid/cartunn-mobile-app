import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/order.dart';

abstract class OrderRemoteDataSource {
  Future<List<Order>> fetchOrders();
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final http.Client client;

  OrderRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Order>> fetchOrders() async {
    final response = await client.get(Uri.parse('https://cartunn.up.railway.app/api/v1/orders'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Order>.from(data.map((x) => Order.fromJson(x)));
    } else {
      throw Exception('Failed to load orders');
    }
  }
}