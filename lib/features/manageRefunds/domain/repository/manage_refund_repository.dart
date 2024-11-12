import 'package:cartunn/features/manageRefunds/domain/entity/product_refund.dart';

abstract class ManageRefundRepository {
  Future<List<ProductRefund>> getRefunds();
  
}