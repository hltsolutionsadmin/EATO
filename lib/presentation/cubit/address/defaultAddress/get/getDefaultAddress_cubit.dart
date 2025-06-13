import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/core/network/network_service.dart';
import 'package:eato/domain/usecase/address/defaultAddress/get/getDefaultAddress_usecase.dart';
import 'package:eato/presentation/cubit/address/defaultAddress/get/getDefaultAddress_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressSavetoCartCubit extends Cubit<AddressSavetoCartState> {
  final AddressSavetoCartUseCase useCase;
  final NetworkService networkService;
  AddressSavetoCartCubit(this.useCase, this.networkService)
      : super(AddressSavetoCartInitial());

  Future<void> addressSavetoCart(int addressId, context) async {
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
      try {
        emit(AddressSavetoCartLoading());
        final result = await useCase(addressId);
        emit(AddressSavetoCartSuccess(result));
      } catch (e) {
        emit(AddressSavetoCartFailure(e.toString()));
      }
    }
  }
}
