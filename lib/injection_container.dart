import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/products/data/datasources/product_local_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/get_products.dart';

/// Very small hand-written service locator (no extra dependency needed).
class ServiceLocator {
  ServiceLocator._() {
    final AuthRepository authRepository =
        AuthRepositoryImpl(AuthLocalDataSourceImpl());
    final ProductRepository productRepository =
        ProductRepositoryImpl(ProductLocalDataSourceImpl());

    loginUser = LoginUser(authRepository);
    getProducts = GetProducts(productRepository);
  }

  static final ServiceLocator instance = ServiceLocator._();

  late final LoginUser loginUser;
  late final GetProducts getProducts;
}

ServiceLocator get sl => ServiceLocator.instance;
