import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/core/network/network_service.dart';
import 'package:eato/domain/usecase/cart/productsAddToCart/productsAddtoCart_usecase.dart';
import 'package:eato/presentation/cubit/cart/productsAddToCart/productsAddtoCart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsAddToCartCubit extends Cubit<ProductsAddToCartState> {
  final ProductsAddToCartUseCase useCase;
  final NetworkService networkService;

  ProductsAddToCartCubit(this.useCase, this.networkService)
      : super(ProductsAddToCartInitial());

  Future<void> addToCart(
    List<Map<String, dynamic>> payload, {
    context,
    bool forceReplace = false,
  }) async {
    bool isConnected = await networkService.hasInternetConnection();
    print(isConnected);
    if (!isConnected) {
      print("No Internet Connection");
      CustomSnackbars.showErrorSnack(
        context: context,
        title: 'Alert',
        message: 'Please check Internet Connection',
      );
      return;
    } else {
      emit(ProductsAddToCartLoading());
      try {
        final result = await useCase(payload, forceReplace: forceReplace);
        emit(ProductsAddToCartSuccess(result));
      } catch (e) {
        if (e.toString().contains('403') &&
            context != null &&
            context.mounted) {
          final result = await useCase(payload, forceReplace: true);
          emit(ProductsAddToCartSuccess(result));

          return;
        }
        emit(ProductsAddToCartFailure(e.toString()));
      }
    }
  }
}
