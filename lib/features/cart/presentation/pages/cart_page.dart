import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/cart_bloc.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_summary.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  Future<void> _checkout(BuildContext context) async {
    final bloc = context.read<CartBloc>();
    final total = bloc.state.totalAmount;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.check_circle_rounded,
            color: Colors.green, size: 48),
        title: const Text('Order placed!'),
        content: Text(
          'Thank you for shopping. Your demo order of ₹${total.toStringAsFixed(2)} was placed.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    bloc.add(const ClearCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            buildWhen: (p, c) => p.isEmpty != c.isEmpty,
            builder: (context, state) {
              if (state.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () =>
                    context.read<CartBloc>().add(const ClearCart()),
                child: const Text('Clear all'),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty',
              message:
                  'Looks like you haven\'t added anything yet.\nGo ahead and explore our products!',
              action: SizedBox(
                width: 200,
                child: PrimaryButton(
                  label: 'Start shopping',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    final id = item.product.id;
                    return CartItemTile(
                      key: ValueKey(id),
                      item: item,
                      onIncrease: () =>
                          context.read<CartBloc>().add(IncreaseQuantity(id)),
                      onDecrease: () =>
                          context.read<CartBloc>().add(DecreaseQuantity(id)),
                      onRemove: () {
                        context.read<CartBloc>().add(RemoveFromCart(id));
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            content: Text('${item.product.name} removed'),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () => context
                                  .read<CartBloc>()
                                  .add(AddToCart(item.product)),
                            ),
                          ));
                      },
                    );
                  },
                ),
              ),
              CartSummary(
                totalItems: state.totalItems,
                totalAmount: state.totalAmount,
                onCheckout: () => _checkout(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
