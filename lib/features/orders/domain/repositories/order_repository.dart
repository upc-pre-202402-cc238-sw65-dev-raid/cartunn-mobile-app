
import 'package:cartunn/features/orders/domain/entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> fetchOrders();
}