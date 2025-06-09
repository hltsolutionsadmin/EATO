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
      final shouldReplace = await _showReplaceCartDialog(context);
      if (shouldReplace == true) {
        // If user selects Yes, proceed with forceReplace
        final result = await useCase(payload, forceReplace: true);
        emit(ProductsAddToCartSuccess(result));
      } else {
        // If user selects No, emit rejected state
        emit(ProductsAddToCartRejected('Kept previous restaurant items'));
      }
      return;
    }
    emit(ProductsAddToCartFailure(e.toString()));
  }
}

  Future<bool?> _showReplaceCartDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Replace cart items?'),
        content: const Text(
          'Your cart contains dishes from a previous restaurant. '
          'Do you want to discard the selection and add dishes from this restaurant?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
