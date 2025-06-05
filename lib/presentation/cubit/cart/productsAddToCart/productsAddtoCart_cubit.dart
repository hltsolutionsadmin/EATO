import 'package:eato/domain/usecase/cart/productsAddToCart/productsAddtoCart_usecase.dart';
import 'package:eato/presentation/cubit/cart/productsAddToCart/productsAddtoCart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsAddToCartCubit extends Cubit<ProductsAddToCartState> {
  final ProductsAddToCartUseCase useCase;

  ProductsAddToCartCubit( this.useCase) : super(ProductsAddToCartInitial());

  Future<void> addToCart(List<Map<String, dynamic>> payload) async {
    emit(ProductsAddToCartLoading());
    try {
      final result = await useCase(payload);
      print(result);
      emit(ProductsAddToCartSuccess(result));
    } catch (e) {
      print(e);
      emit(ProductsAddToCartFailure(e.toString()));
    }
  }
}
