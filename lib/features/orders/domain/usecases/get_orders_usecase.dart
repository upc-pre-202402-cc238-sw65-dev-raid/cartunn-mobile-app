import 'package:cartunn/features/orders/domain/entities/order.dart';
import 'package:cartunn/features/orders/domain/repositories/order_repository.dart';

class GetOrdersUsecase {
  final OrderRepository repository;

  GetOrdersUsecase({required this.repository});

  Future<List<Order>> call() async {
    return await repository.getOrders();
  }
}
