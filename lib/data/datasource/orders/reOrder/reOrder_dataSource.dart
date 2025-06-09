import 'package:dio/dio.dart';
import 'package:eato/core/constants/api_constants.dart';
import 'package:eato/data/model/orders/reOrder/reOrder_model.dart';

abstract class ReOrderRemoteDataSource {
  Future<ReOrderModel> reOrder(
    int orderId,
  );
}

class ReOrderRemoteDataSourceImpl implements ReOrderRemoteDataSource {
  final Dio client;

  ReOrderRemoteDataSourceImpl({required this.client});

  @override
  Future<ReOrderModel> reOrder( int orderId,) async {
    try {
      final response = await client.post(
        '$baseUrl${'$reOrderUrl/$orderId'}',
      );

      print('ReOrder Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ReOrderModel.fromJson(response.data);
      } else {
        throw Exception('Failed to ReOrder. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('ReOrder Error: $e');
      throw Exception('ReOrder failed: ${e.toString()}');
    }
  }
}
