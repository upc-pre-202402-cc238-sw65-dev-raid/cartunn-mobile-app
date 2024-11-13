import 'package:cartunn/features/orders/domain/entities/order.dart';
import 'package:cartunn/features/orders/domain/repositories/order_repository.dart';

class GetOrders {
  final OrderRepository repository;

  GetOrders(this.repository);

  Future<List<Order>> call() async {
    return await repository.fetchOrders();
  }
}
