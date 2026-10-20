import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../products/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAdd);
    on<IncreaseQuantity>(_onIncrease);
    on<DecreaseQuantity>(_onDecrease);
    on<RemoveFromCart>(_onRemove);
    on<ClearCart>((event, emit) => emit(const CartState()));
  }

  void _onAdd(AddToCart event, Emitter<CartState> emit) {
    final items = List<CartItem>.of(state.items);
    final index = items.indexWhere((i) => i.product.id == event.product.id);
    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    } else {
      items.add(CartItem(product: event.product));
    }
    emit(CartState(items: items));
  }

  void _onIncrease(IncreaseQuantity event, Emitter<CartState> emit) {
    emit(CartState(
      items: state.items
          .map((i) => i.product.id == event.productId
              ? i.copyWith(quantity: i.quantity + 1)
              : i)
          .toList(),
    ));
  }

  void _onDecrease(DecreaseQuantity event, Emitter<CartState> emit) {
    emit(CartState(
      items: state.items
          .map((i) => i.product.id == event.productId && i.quantity > 1
              ? i.copyWith(quantity: i.quantity - 1)
              : i)
          .toList(),
    ));
  }

  void _onRemove(RemoveFromCart event, Emitter<CartState> emit) {
    emit(CartState(
      items:
          state.items.where((i) => i.product.id != event.productId).toList(),
    ));
  }
}
