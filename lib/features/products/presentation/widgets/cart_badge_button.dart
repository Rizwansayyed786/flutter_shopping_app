import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';

/// Cart icon with a live item-count badge.
class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (p, c) => p.totalItems != c.totalItems,
      builder: (context, state) {
        return IconButton(
          tooltip: 'Cart',
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.cart),
          icon: Badge(
            isLabelVisible: state.totalItems > 0,
            label: Text('${state.totalItems}'),
            child: const Icon(Icons.shopping_cart_outlined, size: 26),
          ),
        );
      },
    );
  }
}
