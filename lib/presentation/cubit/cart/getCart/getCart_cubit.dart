import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/core/network/network_service.dart';
import 'package:eato/domain/usecase/cart/getCart/getCart_usecase.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetCartCubit extends Cubit<GetCartState> {
  final GetCartUseCase useCase;
  final NetworkService networkService;

  GetCartCubit(this.useCase, this.networkService) : super(GetCartInitial());

  Future<void> fetchCart(context) async {
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
      emit(GetCartLoading());
      try {
        final cart = await useCase.execute();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('cart_id', cart.id ?? 0);
        print("cart id is ${cart.id}");
        emit(GetCartLoaded(cart));
      } catch (e) {
        emit(GetCartError(e.toString()));
      }
    }
  }
}
