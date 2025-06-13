import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/core/network/network_service.dart';
import 'package:eato/domain/usecase/address/defaultAddress/post/defaultAddress_usecase.dart';
import 'package:eato/presentation/cubit/address/defaultAddress/post/defaultAddress_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefaultAddressCubit extends Cubit<DefaultAddressState> {
  final DefaultAddressUseCase useCase;
  final NetworkService networkService;

  DefaultAddressCubit(this.useCase, this.networkService)
      : super(DefaultAddressInitial());

  Future<void> setDefaultAddress(int addressId, context) async {
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
      emit(DefaultAddressLoading());
      try {
        final result = await useCase(addressId);
        emit(DefaultAddressSuccess(defaultAddressModel: result));
      } catch (e) {
        emit(DefaultAddressFailure(error: e.toString()));
      }
    }
  }
}
