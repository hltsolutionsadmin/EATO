import 'package:dio/dio.dart';
import 'package:eato/core/constants/api_constants.dart';
import 'package:eato/data/model/orders/createOrder/createOrder_model.dart';

abstract class CreateOrderRemoteDataSource {
  Future<CreateOrderModel> createOrder();
}

class CreateOrderRemoteDataSourceImpl implements CreateOrderRemoteDataSource {
  final Dio client;

  CreateOrderRemoteDataSourceImpl({required this.client});

  @override
  Future<CreateOrderModel> createOrder() async {
    try {
      final response = await client.post(
        '$baseUrl$createOrderUrl',
      );

      print('CreateOrder Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateOrderModel.fromJson(response.data);
      } else {
        throw Exception('Failed to CreateOrder. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('CreateOrder Error: $e');
      throw Exception('CreateOrder failed: ${e.toString()}');
    }
  }
}
