import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';
import '../../domain/entities/order.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Order>> fetchOrders() async {
    return await remoteDataSource.fetchOrders();
  }
}
