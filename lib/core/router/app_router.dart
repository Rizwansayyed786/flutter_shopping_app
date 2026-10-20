import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/login_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/products/presentation/bloc/product_bloc.dart';
import '../../features/products/presentation/pages/product_list_page.dart';
import '../../injection_container.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/';
  static const String products = '/products';
  static const String cart = '/cart';
}

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => LoginBloc(loginUser: sl.loginUser),
            child: const LoginPage(),
          ),
        );
      case AppRoutes.products:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => ProductBloc(getProducts: sl.getProducts)
              ..add(const LoadProducts()),
            child: const ProductListPage(),
          ),
        );
      case AppRoutes.cart:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CartPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
