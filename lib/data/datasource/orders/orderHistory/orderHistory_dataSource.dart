import 'package:dio/dio.dart';
import 'package:eato/core/constants/api_constants.dart';
import 'package:eato/data/model/orders/orderHistory/orderHistory_model.dart';

abstract class OrderHistoryRemoteDataSource {
  Future<OrderHistoryModel> orderHistory(
      int page, int size, String searchQuery);
}

class OrderHistoryRemoteDataSourceImpl implements OrderHistoryRemoteDataSource {
  final Dio client;

  OrderHistoryRemoteDataSourceImpl({required this.client});

  @override
  Future<OrderHistoryModel> orderHistory(
      int page, int size, String searchQuery) async {
    try {
      final response = await client.request(
        '$baseUrl${orderHistoryUrl(page, size, searchQuery)}',
        options: Options(method: 'GET'),
      );
      if (response.statusCode == 200) {
        print('responce of OrderHistory:: $response');
        return OrderHistoryModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load OrderHistory data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load OrderHistory data: ${e.toString()}');
    }
  }
}
