import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/core/network/network_service.dart';
import 'package:eato/domain/usecase/payment/payment_usecase.dart';
import 'package:eato/presentation/cubit/payment/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentUseCase paymentUseCase;
    final NetworkService networkService;


  PaymentCubit(this.paymentUseCase, this.networkService) : super(PaymentInitial());

  Future<void> makePayment(Map<String, dynamic> payload, context) async {
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
    }
    emit(PaymentLoading());
    try {
      final result = await paymentUseCase(payload);
      emit(PaymentSuccess(result));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }
}
