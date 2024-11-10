import 'dart:convert';
import 'package:cartunn/features/inventory/data/models/product_model.dart';
import 'package:http/http.dart' as http;

class InventoryRemoteDatasource {
  Future<List<ProductModel>> getProducts() async {
    final response = await http
        .get(Uri.parse('https://cartunn.up.railway.app/api/v1/products'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<ProductModel>.from(data.map((x) => ProductModel.fromJson(x)))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
