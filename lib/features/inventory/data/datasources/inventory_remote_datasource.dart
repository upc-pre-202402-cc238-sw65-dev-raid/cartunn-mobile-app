import 'dart:convert';
import 'package:cartunn/features/auth/data/remote/auth_service.dart';
import 'package:cartunn/features/inventory/data/models/product_model.dart';
import 'package:http/http.dart' as http;

class InventoryRemoteDatasource {
  final AuthService authService;
  InventoryRemoteDatasource(this.authService);

  Future<List<ProductModel>> getProducts() async {
    final token = authService.token;
    if (token == null) {
      throw Exception('User is not authenticated');
    }
    final response = await http
        .get(Uri.parse('https://cartunn.up.railway.app/api/v1/products'),
        headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", 
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<ProductModel>.from(data.map((x) => ProductModel.fromJson(x)))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
