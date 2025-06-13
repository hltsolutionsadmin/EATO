import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/core/network/network_service.dart';
import 'package:eato/domain/usecase/address/deleteAddress/deleteAddress_usecase.dart';
import 'package:eato/presentation/cubit/address/deleteAddress/deleteAddress_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAddressCubit extends Cubit<DeleteAddressState> {
  final DeleteAddressUseCase usecase;
  final NetworkService networkService;
  DeleteAddressCubit(this.usecase, this.networkService)
      : super(DeleteAddressInitial());

  Future<void> deleteAddress(int addressId, context) async {
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
      emit(DeleteAddressLoading());
      try {
        final result = await usecase.execute(addressId);
        emit(DeleteAddressSuccess(result));
      } catch (e) {
        emit(DeleteAddressFailure(e.toString()));
      }
    }
  }
}
