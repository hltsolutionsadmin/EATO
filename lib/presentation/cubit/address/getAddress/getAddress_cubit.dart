import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/core/network/network_service.dart';
import 'package:eato/domain/usecase/address/getAddress/getAddress_usecase.dart';
import 'package:eato/presentation/cubit/address/getAddress/getAddress_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAddressCubit extends Cubit<GetAddressState> {
  final GetAddressUseCase getAddressUseCase;
  final NetworkService networkService;

  GetAddressCubit(this.getAddressUseCase, this.networkService)
      : super(GetAddressInitial());

  Future<void> fetchAddress(context) async {
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
      emit(GetAddressLoading());
      try {
        final result = await getAddressUseCase();
        emit(GetAddressSuccess(result));
      } catch (e) {
        emit(GetAddressFailure(e.toString()));
      }
    }
  }
}
