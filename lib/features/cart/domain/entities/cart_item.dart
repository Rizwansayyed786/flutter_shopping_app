import 'package:equatable/equatable.dart';

import '../../../products/domain/entities/product.dart';

class CartItem extends Equatable {
  const CartItem({required this.product, this.quantity = 1});

  final Product product;
  final int quantity;

  double get subtotal => product.price * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);

  @override
  List<Object?> get props => [product, quantity];
}
