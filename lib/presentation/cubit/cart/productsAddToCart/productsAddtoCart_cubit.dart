import 'package:eato/domain/usecase/cart/productsAddToCart/productsAddtoCart_usecase.dart';
import 'package:eato/presentation/cubit/cart/productsAddToCart/productsAddtoCart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsAddToCartCubit extends Cubit<ProductsAddToCartState> {
  final ProductsAddToCartUseCase useCase;

  ProductsAddToCartCubit(this.useCase) : super(ProductsAddToCartInitial());


  Future<void> addToCart(
  List<Map<String, dynamic>> payload, {
  BuildContext? context,
  bool forceReplace = false,
}) async {
  emit(ProductsAddToCartLoading());
  try {
    final result = await useCase(payload, forceReplace: forceReplace);
    emit(ProductsAddToCartSuccess(result));
  } catch (e) {
    if (e.toString().contains('403') && context != null && context.mounted) {
      // final shouldReplace = await _showReplaceCartDialog(context);
     
        final result = await useCase(payload, forceReplace: true);
        emit(ProductsAddToCartSuccess(result));
     
      return;
    }
    emit(ProductsAddToCartFailure(e.toString()));
  }
}
}
