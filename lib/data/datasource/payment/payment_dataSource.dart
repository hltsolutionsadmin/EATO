import 'package:dio/dio.dart';
import 'package:eato/core/constants/api_constants.dart';
import 'package:eato/data/model/payment/payment_model.dart';
import 'package:eato/data/model/payments/refund_amount_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> Payment(Map<String, dynamic> payload);
    Future<PaymentStausModel> Payment_Tracking(String paymentId);

}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio client;

  PaymentRemoteDataSourceImpl({required this.client});

  @override
  Future<PaymentModel> Payment(Map<String, dynamic> payload) async {
    try {
      final response = await client.post(
        '$baseUrl$paymentUrl',
        data: payload,
      );

      print('Payment Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaymentModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to save address. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Payment Error: $e');
      throw Exception('Payment failed: ${e.toString()}');
    }
  }

  @override
  Future<PaymentStausModel> Payment_Tracking(String paymentId) async {
    try {
      final response = await client.post(
        '$baseUrl$paymentUrl/$paymentId',
      );

      print('Payment Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaymentStausModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed payment tracking. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Payment Error: $e');
      throw Exception('Payment failed: ${e.toString()}');
    }
  }
}





