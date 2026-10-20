part of 'cart_bloc.dart';

class CartState extends Equatable {
  const CartState({this.items = const []});

  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;

  /// Total quantity of all items (used for the badge).
  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);

  double get totalAmount => items.fold(0.0, (sum, i) => sum + i.subtotal);

  @override
  List<Object?> get props => [items];
}
