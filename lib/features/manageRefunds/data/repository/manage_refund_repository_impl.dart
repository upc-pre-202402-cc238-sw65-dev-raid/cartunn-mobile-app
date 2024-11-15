import 'package:cartunn/features/manageRefunds/data/datasources/manage_refund_remote_datasource.dart';
import 'package:cartunn/features/manageRefunds/domain/entity/product_refund.dart';
import 'package:cartunn/features/manageRefunds/domain/repository/manage_refund_repository.dart';

class ManageRefundRepositoryImpl implements ManageRefundRepository {
  final ManageRefundRemoteDatasource remoteDatasource;

  ManageRefundRepositoryImpl({required this.remoteDatasource});
  @override
  Future<List<ProductRefund>> getRefunds() async {
    final refunds = await remoteDatasource.getRefunds();
    return refunds.map((refunds) => refunds.toEntity()).toList();
  }
}
