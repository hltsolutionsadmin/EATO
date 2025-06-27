import 'package:eato/components/custom_snackbar.dart';
import 'package:eato/core/network/network_service.dart';
import 'package:eato/domain/usecase/orders/createOrder/createOrder_usecase.dart';
import 'package:eato/presentation/cubit/cart/clearCart/clearCart_cubit.dart';
import 'package:eato/presentation/cubit/orders/createOrder/createOrder_state.dart';
import 'package:eato/presentation/cubit/payment/payment_cubit.dart';
import 'package:eato/presentation/screen/order/orderSuccess_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final CreateOrderUseCase useCase;
  final NetworkService networkService;

  CreateOrderCubit(this.useCase, this.networkService)
      : super(CreateOrderInitial());

  Future<void> createOrder(BuildContext context, String paymentId) async {
    bool isConnected = await networkService.hasInternetConnection();
    print('Internet connected: $isConnected');

    if (!isConnected) {
      CustomSnackbars.showErrorSnack(
        context: context,
        title: 'Alert',
        message: 'Please check Internet Connection',
      );
      return;
    }
    final payload = {
      "paymentTransactionId" : paymentId 
    };
    emit(CreateOrderLoading());
    try {
      final order = await useCase(payload);
      print('order: ${order.status}');
      if (order.status == "success") {
        final clearCartCubit = context.read<ClearCartCubit>();
        await clearCartCubit.clearCart(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
        );
        emit(CreateOrderLoaded(order));
      } else {
        final paymentCubit = context.read<PaymentCubit>();
        await paymentCubit.paymentRefund(paymentId, context);
      }
    } catch (e) {
       final paymentCubit = context.read<PaymentCubit>();
        await paymentCubit.paymentRefund(paymentId, context);
        
      print('CreateOrder error: $e');
      emit(CreateOrderError(e.toString()));
    }
  }
}
