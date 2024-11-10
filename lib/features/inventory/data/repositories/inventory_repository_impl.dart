import 'package:cartunn/features/inventory/data/datasources/inventory_remote_datasource.dart';
import 'package:cartunn/features/inventory/domain/entities/product.dart';
import 'package:cartunn/features/inventory/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDatasource remoteDatasource;

  InventoryRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<Product>> getProducts() async {
    final products = await remoteDatasource.getProducts();
    return products.map((product) => product.toEntity()).toList();
  }
}
