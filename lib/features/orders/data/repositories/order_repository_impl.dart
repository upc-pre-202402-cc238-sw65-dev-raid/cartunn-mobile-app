import 'package:cartunn/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:cartunn/features/orders/domain/entities/order.dart';
import 'package:cartunn/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl  implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Order>> getOrders() async {
    final orders = await remoteDataSource.getOrders();
    return orders.map((order) => order.toEntity()).toList();
  }

}