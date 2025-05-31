import 'package:eato/data/model/payment/payment_model.dart';

abstract class PaymentRepository {
  Future<PaymentModel> makePayment(Map<String, dynamic> payload);
}
