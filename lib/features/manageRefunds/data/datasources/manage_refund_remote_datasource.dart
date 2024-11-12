import 'dart:convert';
import 'package:cartunn/features/manageRefunds/data/model/manage_refund_model.dart';
import 'package:http/http.dart' as http;

class ManageRefundRemoteDatasource {
  Future<List<ProductRefundModel>> getRefunds() async {
    final response = await http
        .get(Uri.parse('https://cartunn.up.railway.app/api/v1/product-refund'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<ProductRefundModel>.from(data.map((x) => ProductRefundModel.fromJson(x)))
          .toList();
    } else {
      throw Exception('Failed to load products-refunds');
    }
  }
}
