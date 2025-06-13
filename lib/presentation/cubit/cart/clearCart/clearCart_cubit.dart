import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/core/network/network_service.dart';
import 'package:eato/domain/usecase/cart/clearCart/clearCart_usecase.dart';
import 'package:eato/presentation/cubit/cart/clearCart/clearCart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClearCartCubit extends Cubit<ClearCartState> {
  final ClearCartUseCase clearCartUseCase;
  final NetworkService networkService;
  ClearCartCubit(this.clearCartUseCase, this.networkService)
      : super(ClearCartInitial());

  clearCart(context) async {
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
      emit(ClearCartLoading());
      try {
        final result = await clearCartUseCase();
        emit(ClearCartSuccess(result));
      } catch (e) {
        emit(ClearCartFailure(e.toString()));
      }
    }
  }
}
