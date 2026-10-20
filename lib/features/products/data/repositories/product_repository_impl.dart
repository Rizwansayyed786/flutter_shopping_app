import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._dataSource);

  final ProductLocalDataSource _dataSource;

  @override
  Future<List<Product>> getProducts() => _dataSource.getProducts();
}
