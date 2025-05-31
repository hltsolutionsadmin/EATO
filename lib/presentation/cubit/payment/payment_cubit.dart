import 'package:eato/domain/usecase/payment/payment_usecase.dart';
import 'package:eato/presentation/cubit/payment/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentUseCase paymentUseCase;

  PaymentCubit(this.paymentUseCase) : super(PaymentInitial());

  Future<void> makePayment(Map<String, dynamic> payload) async {
    emit(PaymentLoading());
    try {
      final result = await paymentUseCase(payload);
      emit(PaymentSuccess(result));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }
}
