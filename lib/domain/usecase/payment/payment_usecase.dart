import 'package:eato/data/model/payment/payment_model.dart';
import 'package:eato/data/model/payments/refund_amount_model.dart';
import 'package:eato/domain/repository/payment/payment_repository.dart';

class PaymentUseCase {
  final PaymentRepository repository;

  PaymentUseCase({required this.repository});

  Future<PaymentModel> call(Map<String, dynamic> payload) {
    return repository.makePayment(payload);
  }

  Future<PaymentStausModel> Payment_Tracking(String paymentId) {
    return repository.PaymentTracking(paymentId);
  }
}
