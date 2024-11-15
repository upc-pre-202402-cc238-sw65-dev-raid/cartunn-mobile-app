import 'dart:convert';
import 'package:cartunn/features/auth/data/remote/auth_service.dart';
import 'package:cartunn/features/manageRefunds/data/model/manage_refund_model.dart';
import 'package:http/http.dart' as http;

class ManageRefundRemoteDatasource {
  final AuthService authService;

  ManageRefundRemoteDatasource(this.authService);

  Future<List<ProductRefundModel>> getRefunds() async {
    final token = authService.token;

    if (token == null) {
      throw Exception('User is not authenticated');
    }

    final response = await http.get(
      Uri.parse('https://cartunn.up.railway.app/api/v1/product-refund'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", //  token 
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<ProductRefundModel>.from(
        data.map((x) => ProductRefundModel.fromJson(x)),
      ).toList();
    } else {
      throw Exception('Failed to load products-refunds');
    }
  }
}