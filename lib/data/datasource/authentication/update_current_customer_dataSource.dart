import 'package:dio/dio.dart';
import 'package:eato/core/constants/api_constants.dart';
import 'package:eato/data/model/authentication/update_current_customer_model.dart';

abstract class UpdateCurrentCustomerRemoteDatasource {
  Future<UpdateCurrentCustomerModel> updateCurrentCustomer({
    Map<String, dynamic> payload,
  });
}

class UpdateCurrentCustomerRemoteDataSourceImpl
    implements UpdateCurrentCustomerRemoteDatasource {
  final Dio client;

  UpdateCurrentCustomerRemoteDataSourceImpl({required this.client});

  @override
  Future<UpdateCurrentCustomerModel> updateCurrentCustomer({
    dynamic payload,
  }) async {
    try {
      final response = await client.request(
        '$baseUrl$updateCurrentCustomerUrl',
        data: payload,
        options: Options(method: 'PUT'),
      );

      print('Response: ${response.data}');

      if (response.statusCode == 200) {
        return UpdateCurrentCustomerModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load UpdateCurrentCustomer data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception(
          'Failed to load UpdateCurrentCustomer data: ${e.toString()}');
    }
  }
}
