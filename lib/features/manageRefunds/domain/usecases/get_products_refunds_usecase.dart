import 'package:cartunn/features/manageRefunds/domain/entity/product_refund.dart';
import 'package:cartunn/features/manageRefunds/domain/repository/manage_refund_repository.dart';

class GetProductsRefundsUseCase {
  final ManageRefundRepository repository;

  GetProductsRefundsUseCase({required this.repository});
  Future<List<ProductRefund>> call() async {
    return await repository.getRefunds();
  }
}
