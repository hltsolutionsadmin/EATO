import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/core/network/network_service.dart';
import 'package:eato/domain/usecase/cart/updateCartItems/updateCartItems_usecase.dart';
import 'package:eato/presentation/cubit/cart/updateCartItems/updateCartItems_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateCartItemsCubit extends Cubit<UpdateCartItemsState> {
  final UpdateCartItemsUseCase updateCartItemsUseCase;
  final NetworkService networkService;
  UpdateCartItemsCubit(this.updateCartItemsUseCase, this.networkService)
      : super(UpdateCartItemsInitial());

  Future<void> updateCartItem(
      Map<String, dynamic> payload, String cartId, context) async {
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
      emit(UpdateCartItemsLoading());
      try {
        final result = await updateCartItemsUseCase(payload, cartId);
        emit(UpdateCartItemsSuccess(result));
      } catch (e) {
        emit(UpdateCartItemsFailure(e.toString()));
      }
    }
  }
}
