import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/core/network/network_service.dart';
import 'package:eato/domain/usecase/payment/payment_usecase.dart';
import 'package:eato/presentation/cubit/orders/createOrder/createOrder_cubit.dart';
import 'package:eato/presentation/cubit/payment/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentUseCase paymentUseCase;
  final NetworkService networkService;

  PaymentCubit(this.paymentUseCase, this.networkService)
      : super(PaymentInitial());

  Future<void> makePayment(
      Map<String, dynamic> payload, BuildContext context) async {
    print(payload);
    final bool isConnected = await networkService.hasInternetConnection();
    print('Internet connected: $isConnected');

    if (!isConnected) {
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
      print('Payment result: ${result.status}');
      if (result.status == 'Verified') {
        final createOrderCubit = context.read<CreateOrderCubit>();
        await createOrderCubit.createOrder(context, payload['paymentId']);
      }
      emit(PaymentSuccess(result));
    } catch (e) {
      print('Payment error: $e');
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> paymentTracking(String paymentId, BuildContext context) async {
    final bool isConnected = await networkService.hasInternetConnection();
    print('Internet connected: $isConnected');

    if (!isConnected) {
      CustomSnackbars.showErrorSnack(
        context: context,
        title: 'Alert',
        message: 'Please check Internet Connection',
      );
      return;
    }

    emit(PaymentLoading());

    try {
      final result = await paymentUseCase.Payment_Tracking(paymentId);
      emit(PaymentTrackingSuccess(result));
    } catch (e) {
      print('Payment tracking error: $e');
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> paymentRefund(String paymentId, BuildContext context) async {
  final bool isConnected = await networkService.hasInternetConnection();
  print('Internet connected: $isConnected');

  if (!isConnected) {
    CustomSnackbars.showErrorSnack(
      context: context,
      title: 'Alert',
      message: 'Please check Internet Connection',
    );
    return;
  }

  emit(PaymentRefundLoading());

  try {
    final result = await paymentUseCase.Payment_Refund(paymentId);
    print('Payment refund result: ${result.status}');

    if (result.status == 'REFUNDED') {
      Future.delayed(Duration(milliseconds: 200), () {
        if (context.mounted) {
          CustomSnackbars.showErrorSnack(
            context: context,
            title: 'Alert',
            message:
                'Your order was not confirmed, if any amount was deducted, it will be refunded within 24 hours.',
          );
        }
      });

      emit(PaymentRefundSuccess(result));
    }
  } catch (e) {
    print('Payment refund error: $e');
    emit(PaymentRefundFailure(e.toString()));
  }
}

}
