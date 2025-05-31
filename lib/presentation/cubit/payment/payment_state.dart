import 'package:eato/data/model/payment/payment_model.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final PaymentModel paymentModel;

  PaymentSuccess(this.paymentModel);
}

class PaymentFailure extends PaymentState {
  final String error;

  PaymentFailure(this.error);
}
