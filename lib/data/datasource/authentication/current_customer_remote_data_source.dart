import 'package:dio/dio.dart';
import 'package:eato/data/model/authentication/current_customer_model.dart';

import '../../../core/constants/api_constants.dart';

abstract class CurrentCustomerRemoteDataSource {
  Future<CurrentCustomerModel> currentCustomer();
}

class CurrentCustomerRemoteDataSourceImpl
    implements CurrentCustomerRemoteDataSource {
  final Dio client;

  CurrentCustomerRemoteDataSourceImpl({required this.client});

  @override
  Future<CurrentCustomerModel> currentCustomer() async {
    try {
      final response = await client.request(
        '$baseUrl2$userDetails',
        options: Options(method: 'GET'),
      );
      if (response.statusCode == 200) {
        print('responce of current customer:: $response');
        return CurrentCustomerModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load current customer data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load current customer data: ${e.toString()}');
    }
  }
}
