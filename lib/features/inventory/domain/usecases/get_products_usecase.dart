import 'package:cartunn/features/inventory/domain/entities/product.dart';
import 'package:cartunn/features/inventory/domain/repositories/inventory_repository.dart';

class GetProductsUseCase {
  final InventoryRepository repository;

  GetProductsUseCase({required this.repository});

  Future<List<Product>> call() async {
    return await repository.getProducts();
  }
}
