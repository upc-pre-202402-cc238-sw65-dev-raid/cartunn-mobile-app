import 'package:cartunn/features/inventory/domain/entities/product.dart';

abstract class InventoryRepository {
  Future<List<Product>> getProducts();
}
