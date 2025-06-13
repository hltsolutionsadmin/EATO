import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/core/network/network_service.dart';
import 'package:eato/domain/usecase/cart/createCart/createCart_usecase.dart';
import 'package:eato/presentation/cubit/cart/createCart/createCart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCartCubit extends Cubit<CreateCartState> {
  final CreateCartUseCase useCase;
  final NetworkService networkService;

  CreateCartCubit(this.useCase, this.networkService)
      : super(CreateCartInitial());

  Future<void> createCart(context) async {
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
      emit(CreateCartLoading());
      try {
        final cart = await useCase();
        emit(CreateCartLoaded(cart));
      } catch (e) {
        emit(CreateCartError(e.toString()));
      }
    }
  }
}
