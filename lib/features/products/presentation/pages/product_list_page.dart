import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../bloc/product_bloc.dart';
import '../widgets/cart_badge_button.dart';
import '../widgets/product_card.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  void _logout(BuildContext context) {
    context.read<CartBloc>().add(const ClearCart());
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(AppConstants.appName),
        actions: [
          const CartBadgeButton(),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _logout(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          switch (state.status) {
            case ProductStatus.initial:
            case ProductStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ProductStatus.failure:
              return EmptyState(
                icon: Icons.error_outline_rounded,
                title: 'Something went wrong',
                message: state.errorMessage ?? 'Please try again.',
                action: SizedBox(
                  width: 180,
                  child: PrimaryButton(
                    label: 'Retry',
                    onPressed: () =>
                        context.read<ProductBloc>().add(const LoadProducts()),
                  ),
                ),
              );
            case ProductStatus.success:
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                      child: Text(
                        'Latest arrivals',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverGrid.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 260,
                        mainAxisExtent: 330,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ProductCard(
                          product: product,
                          onAddToCart: () {
                            context.read<CartBloc>().add(AddToCart(product));
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                content: Text('${product.name} added to cart'),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'VIEW CART',
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(AppRoutes.cart),
                                ),
                              ));
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
