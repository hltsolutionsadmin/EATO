import 'package:eato/data/datasource/payment/payment_dataSource.dart';
import 'package:eato/data/model/payment/payment_model.dart';
import 'package:eato/data/model/payments/refund_amount_model.dart';
import 'package:eato/domain/repository/payment/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaymentModel> makePayment(Map<String, dynamic> payload) {
    return remoteDataSource.Payment(payload);
  }

  @override
  Future<PaymentStausModel> PaymentTracking(String paymentId) {
    return remoteDataSource.Payment_Tracking(paymentId);
  }
}
