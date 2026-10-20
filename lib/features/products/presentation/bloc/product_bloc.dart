import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({required GetProducts getProducts})
      : _getProducts = getProducts,
        super(const ProductState()) {
    on<LoadProducts>(_onLoad);
  }

  final GetProducts _getProducts;

  Future<void> _onLoad(LoadProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final products = await _getProducts();
      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (_) {
      emit(state.copyWith(
        status: ProductStatus.failure,
        errorMessage: 'Could not load products. Please try again.',
      ));
    }
  }
}
