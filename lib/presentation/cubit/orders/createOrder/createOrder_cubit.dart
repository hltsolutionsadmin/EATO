import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/core/network/network_service.dart';
import 'package:eato/domain/usecase/orders/createOrder/createOrder_usecase.dart';
import 'package:eato/presentation/cubit/orders/createOrder/createOrder_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final CreateOrderUseCase useCase;
  final NetworkService networkService;

  CreateOrderCubit(this.useCase, this.networkService)
      : super(CreateOrderInitial());

  Future<void> createOrder(context) async {
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
      emit(CreateOrderLoading());
      try {
        final Order = await useCase();
        emit(CreateOrderLoaded(Order));
      } catch (e) {
        print(e);
        emit(CreateOrderError(e.toString()));
      }
    }
  }
}
