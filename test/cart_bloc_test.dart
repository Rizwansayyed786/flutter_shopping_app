import 'package:flutter_shop_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_shop_app/features/products/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tee = Product(
      id: 'a', name: 'Tee', description: 'd', price: 100, imageUrl: 'u');
  const jeans = Product(
      id: 'b', name: 'Jeans', description: 'd', price: 250, imageUrl: 'u');

  late CartBloc bloc;

  setUp(() => bloc = CartBloc());
  tearDown(() => bloc.close());

  Future<void> pump() => Future<void>.delayed(Duration.zero);

  test('adding the same product increments quantity', () async {
    bloc
      ..add(const AddToCart(tee))
      ..add(const AddToCart(tee));
    await pump();
    expect(bloc.state.items.length, 1);
    expect(bloc.state.items.first.quantity, 2);
  });

  test('total amount is computed correctly', () async {
    bloc
      ..add(const AddToCart(tee))
      ..add(const AddToCart(jeans))
      ..add(const IncreaseQuantity('a'));
    await pump();
    expect(bloc.state.totalAmount, 450);
    expect(bloc.state.totalItems, 3);
  });

  test('decrease never goes below 1', () async {
    bloc
      ..add(const AddToCart(tee))
      ..add(const DecreaseQuantity('a'));
    await pump();
    expect(bloc.state.items.first.quantity, 1);
  });

  test('remove empties the cart', () async {
    bloc
      ..add(const AddToCart(tee))
      ..add(const RemoveFromCart('a'));
    await pump();
    expect(bloc.state.isEmpty, true);
  });
}
