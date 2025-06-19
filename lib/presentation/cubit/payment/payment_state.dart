import 'package:eato/data/model/payment/payment_model.dart';
import 'package:eato/data/model/payments/refund_amount_model.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}
class PaymentTrackingInitial extends PaymentState {}


class PaymentLoading extends PaymentState {}
class PaymentTrackingLoading extends PaymentState {}


class PaymentSuccess extends PaymentState {
  final PaymentModel paymentModel;

  PaymentSuccess(this.paymentModel);
}

class PaymentTrackingSuccess extends PaymentState {
  final PaymentStausModel paymenStatustModel;

  PaymentTrackingSuccess(this.paymenStatustModel);
}

class PaymentFailure extends PaymentState {
  final String error;

  PaymentFailure(this.error);
}

class PaymentTrackingFailure extends PaymentState {
  final String error;

  PaymentTrackingFailure(this.error);
}
